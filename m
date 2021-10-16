Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925EA43017D
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 11:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbhJPJbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 05:31:19 -0400
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17428 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243923AbhJPJbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 05:31:18 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Oct 2021 05:31:18 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1634375615; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=BpY3SY0aB26/FbDa40bp/WI+57QCU0IwonMWaoE6jh4M+lvFlYZuKERrjR/UoO+J1qquZ6ULYE5Z1kRtLAnM6wNSGDSuszBmPiCRFf92b3lmBTkHxHSGeoFy/R9QtqCjZ1wAlrsu85Io9VHGaiSrrE77nlMp1ljYKnBLumr0Qf0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1634375615; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=sYetWd5dkPd+TI2PlmPR4bwqbZoI6NEUiz188dhP0zk=; 
        b=Z5R5azUjfz63NZD9PKtuSlayMzyDtyd322pRaDg//YpHtVG5/DDnpXSPAKN+XSSULP5lWjQxJyIUQDm5NyUiPcw+YJkf9wqnoohGbHqnXvkuGA4DhjSO0DD3OIFFOiaW77YFjVpE/Gi8ReQTbZaP8O8jfxmgfl/L118SIABrL7c=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1634375615;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=sYetWd5dkPd+TI2PlmPR4bwqbZoI6NEUiz188dhP0zk=;
        b=OlKVSVLQPITCn8Uxx/IzUx0aklCUIsMJ57VDMPAODlGQkuvOxIQ30NEFOP/cbrUt
        MxtYUZEq9LvxI4kyJmn7GHCJApBAfEHrrqevN3BtxHIb+d1Wp53ske722KvXmFugHtL
        9PqwDxl/rpqh7JuuUSyh2uSdgVs3mjgGKsE8wTMY=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1634375614599922.1792449684986; Sat, 16 Oct 2021 02:13:34 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/7] net: dsa: add support for RTL8365MB-VC
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211015171030.2713493-1-alvin@pqrs.dk>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Message-ID: <96111adf-205d-1cca-d05e-20bef29ed29e@arinc9.com>
Date:   Sat, 16 Oct 2021 12:13:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015171030.2713493-1-alvin@pqrs.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on net-next master branch kernel on Asus RT-AC88U router using 
OpenWrt.

DT specification:

	ethernet-switch {
		compatible = "realtek,rtl8365mb";
		mdc-gpios = <&chipcommon 6 GPIO_ACTIVE_HIGH>;
		mdio-gpios = <&chipcommon 7 GPIO_ACTIVE_HIGH>;
		reset-gpios = <&chipcommon 10 GPIO_ACTIVE_LOW>;
		realtek,disable-leds;
		dsa,member = <1 0>;

		ports {
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0>;

			port@0 {
				reg = <0>;
				label = "lan5";
				phy-handle = <&ethphy0>;
			};

			port@1 {
				reg = <1>;
				label = "lan6";
				phy-handle = <&ethphy1>;
			};

			port@2 {
				reg = <2>;
				label = "lan7";
				phy-handle = <&ethphy2>;
			};

			port@3 {
				reg = <3>;
				label = "lan8";
				phy-handle = <&ethphy3>;
			};

			port@6 {
				reg = <6>;
				label = "cpu";
				ethernet = <&sw0_p5>;
				phy-mode = "rgmii";
				tx-internal-delay-ps = <2000>;
				rx-internal-delay-ps = <2000>;

				fixed-link {
					speed = <1000>;
					full-duplex;
					pause;
				};
			};
		};

		mdio {
			compatible = "realtek,smi-mdio";
			#address-cells = <1>;
			#size-cells = <0>;

			ethphy0: phy@0 {
				reg = <0>;
			};

			ethphy1: phy@1 {
				reg = <1>;
			};

			ethphy2: phy@2 {
				reg = <2>;
			};

			ethphy3: phy@3 {
				reg = <3>;
			};
		};
	};

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
