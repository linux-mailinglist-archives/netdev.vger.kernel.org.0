Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F30427DB4
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 23:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJIVjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 17:39:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhJIVjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 17:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Chk7yE4J2WOqoX/5dLGbdpv9rujKzHvkaAG1M3o1khQ=; b=l4x709xfkEYY9qNWS4juI1FElQ
        EQQaQbQ28CIIFstyfZKEVQGpGvf4cnX50tcURnZCZpjlGDvmrVJo2ozVhvR686EcUloI1RskpJ0Yo
        fz6nAHa1q1DemVwAQhJwuxh3JdvLNEL6IVAjb5Y414EsxTQJOub6upCysWs9uNU75f1E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZK1m-00ABFQ-A2; Sat, 09 Oct 2021 23:37:10 +0200
Date:   Sat, 9 Oct 2021 23:37:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v2 08/15] dt-bindings: net: dsa: qca8k: Add MAC
 swap and clock phase properties
Message-ID: <YWILhniu2KFIGut9@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-9-ansuelsmth@gmail.com>
 <YWHMRMTSa8xP4SKK@lunn.ch>
 <YWHamNcXmxuaVgB+@Ansuel-xps.localdomain>
 <YWHx7Q9jBrws8ioN@lunn.ch>
 <YWH2P7ogyH3T0CVp@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWH2P7ogyH3T0CVp@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here is 2 configuration one from an Netgear r7800 qca8337:
> 
> 	switch@10 {
> 		compatible = "qca,qca8337";
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 		reg = <0x10>;
> 
> 		qca8k,rgmii0_1_8v;
> 		qca8k,rgmii56_1_8v;
> 
> 		ports {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 
> 			port@0 {
> 				reg = <0>;
> 				label = "cpu";
> 				ethernet = <&gmac1>;
> 				phy-mode = "rgmii-id";
> 
> 				fixed-link {
> 					speed = <1000>;
> 					full-duplex;
> 				};
> 			};
> 
> 			port@1 {
> 				reg = <1>;
> 				label = "lan1";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port1>;
> 			};
> 
> 			port@2 {
> 				reg = <2>;
> 				label = "lan2";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port2>;
> 			};
> 
> 			port@3 {
> 				reg = <3>;
> 				label = "lan3";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port3>;
> 			};
> 
> 			port@4 {
> 				reg = <4>;
> 				label = "lan4";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port4>;
> 			};
> 
> 			port@5 {
> 				reg = <5>;
> 				label = "wan";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port5>;
> 			};
> 
> 			port@6 {
> 				reg = <6>;
> 				label = "cpu";
> 				ethernet = <&gmac2>;
> 				phy-mode = "sgmii";
> 
> 				fixed-link {
> 					speed = <1000>;
> 					full-duplex;
> 				};

So here, it is a second CPU port.  But some other board could connect
an SGMII PHY, and call the port lan5. Or it could be connected to an
SFP cage, and used that way. Or are you forced to use it as a CPU
port, or not use it at all?

> And here is one with mac swap Tp-Link Archer c7 v4 qca8327 
> 
> 	switch0@10 {
> 		compatible = "qca,qca8337";
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		reg = <0>;
> 		qca,sgmii-rxclk-falling-edge;
> 		qca,mac6-exchange;
> 
> 		ports {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 
> 			port@0 {
> 				reg = <0>;
> 				label = "cpu";
> 				ethernet = <&eth0>;
> 				phy-mode = "sgmii";
> 
> 				fixed-link {
> 					speed = <1000>;
> 					full-duplex;
> 				};

So when looking for SGMI properties, you need to look here. Where as
in the previous example, you would look in port 6. And the reverse is
true for RGMII delays.

> 			};
> 
> 			port@1 {
> 				reg = <1>;
> 				label = "wan";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port1>;
> 			};
> 
> 			port@2 {
> 				reg = <2>;
> 				label = "lan1";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port2>;
> 			};
> 
> 			port@3 {
> 				reg = <3>;
> 				label = "lan2";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port3>;
> 			};
> 
> 			port@4 {
> 				reg = <4>;
> 				label = "lan3";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port4>;
> 			};
> 
> 			port@5 {
> 				reg = <5>;
> 				label = "lan4";
> 				phy-mode = "internal";
> 				phy-handle = <&phy_port5>;
> 			};
> 		};

So here, port '6' is not used. But it could be connected to an RGMII
PHY and called lan5. Would the naming work out? What does devlink
think of it, etc. What about phy-handle? Is there an external MDIO
bus? What address would be used if there is no phy-handle?

      Andrew
