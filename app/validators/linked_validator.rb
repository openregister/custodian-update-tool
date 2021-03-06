class LinkedValidator < ActiveModel::EachValidator
  DELIMITER = ':'.freeze

  def validate_each(record, attribute, value)
    register_linked = options[:register_linked]
    @registers_client = options[:registers_client]
    record.errors.add attribute, 'Must be valid data from a register that is ready to use' unless validate_linked(value, register_linked)
  end

  def validate_linked(value, register_linked)
    return false unless valid_value?(value)

    if value.include? DELIMITER
      check_curie(value)
    else
      check_register(value, register_linked)
    end
  end

  def check_curie(value)
    values = value.split(DELIMITER)

    valid_key?(values[0], values[1])
  end

  def check_register(value, register_linked)
    register_linked.present? && valid_key?(register_linked, value)
  end

  def valid_key?(register_name, key)
    register_data = @registers_client.get_register(register_name, Rails.configuration.register_phase)
    current_register_record = register_data.get_record(key)
    !current_register_record.nil?
  end

  def valid_value?(value)
    return true unless value.include? DELIMITER

    value.match?(/\A[\w-]+:\w+\z/)
  end
end
