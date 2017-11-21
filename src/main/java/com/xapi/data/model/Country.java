package com.xapi.data.model;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
@Table(name="country")
public class Country implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="CODE", nullable=false, unique=true) 	private String code;
	@Column(name="NAME", nullable=false, unique=true) 	private String name;
	@Column(name="FLAG", nullable=false, unique=true) 	private String flag;

	@OneToOne(fetch=FetchType.EAGER) 
		@JoinColumn(name="CURRENCY", unique=true)		private Currency currency;
	
//	@ManyToMany(cascade = CascadeType.ALL, fetch=FetchType.EAGER)
//    @JoinTable(name = "country_currency", 
//    	joinColumns = @JoinColumn(name = "code", referencedColumnName = "code"), 
//    	inverseJoinColumns = @JoinColumn(name = "iso", referencedColumnName = "iso"))
//														private Set<Currency> currencies; // @JsonBackReference(value="currencies")
	  
	private transient List<Section> sections = new LinkedList<>();
		
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}

	public Currency getCurrency() {
		return currency;
	}

	public void setCurrency(Currency currency) {
		this.currency = currency;
	}
	
	public List<Section> getSections(){
		return sections;
	}

	public void setSections(List<Section> sections) {
		this.sections = sections;
	}		
	
	public boolean addSection(Section section){
		return sections == null? false: sections.add(section);
	}
	
	public boolean removeSection(Section section){
		return  sections == null? false: sections.remove(section);
	}

	@Override
	public String toString(){
		StringBuffer toString = new StringBuffer();
		for(Field field: this.getClass().getDeclaredFields())
			try {
				toString.append( field.getName() + " = " ).append( field.get( this ) ).append("\n");
			} catch (IllegalArgumentException | IllegalAccessException e) {
				e.printStackTrace();
			}
		
		return toString.toString();
	}	
	
	@Override
	public Country clone(){	
		Country cloneCountry = new Country();
			cloneCountry.setName(this.name);
			cloneCountry.setCode(this.code);
			cloneCountry.setFlag(this.flag);
			cloneCountry.setCurrency(this.currency);
//			cloneCountry.setSections(this.sections);
			
		return cloneCountry;
	}
}
