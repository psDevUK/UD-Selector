import React from 'react';
import Select from 'react-select';
import Creatable, { makeCreatableSelect } from 'react-select/creatable';
import makeAnimated from 'react-select/animated';
// import { colourOptions } from './data';

const animatedComponents = makeAnimated();

// const options = [
//   { value: 'chocolate', label: 'Chocolate' },
//   { value: 'strawberry', label: 'Strawberry' },
//   { value: 'vanilla', label: 'Vanilla' },
// ];

class UDSelector extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedOption: null,
      hidden: false
    }
  }

  handleChange = selectedOption => {
    this.setState({ selectedOption });
  };

  componentWillMount() {
    this.pubSubToken = PubSub.subscribe(this.props.id, this.onIncomingEvent.bind(this));
  }

  componentWillUnmount() {
    PubSub.unsubscribe(this.pubSubToken);
  }

  onIncomingEvent(eventName, event) {
    if (event.type === "requestState") {
      var data = {
        attributes: {
          selectedOption: this.state.selectedOption,
          hidden: this.state.hidden,
        }
      }
      UniversalDashboard.post(`/api/internal/component/element/sessionState/${event.requestId}`, data);
    }
    else if (event.type === "setState") {
      this.setState(event.state.attributes);
    }
    else if (event.type === "clearElement") {
      this.setState({
        value: null
      });
    }
    else if (event.type === "removeElement") {
      this.setState({
        hidden: true
      });
    }
  }
  render() {
    const { selectedOption } = this.state;
    if (this.state.hidden) {
      return null;
    }
    return (
      <Select
        autoFocus
        isMulti
        isSearchable
        closeMenuOnSelect={false}
        components={animatedComponents}
        value={selectedOption}
        onChange={this.handleChange}
        options={this.props.options}
        placeholder={this.props.placeholder}
        className="ud-multi-selector"
        classNamePrefix="selector"
      />
    );
  }
}

export default UDSelector
