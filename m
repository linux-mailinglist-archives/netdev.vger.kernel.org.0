Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60F2EC787
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfKAR3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:29:36 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:39064 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfKAR3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:29:36 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA1HTROJ100272;
        Fri, 1 Nov 2019 12:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572629367;
        bh=P2wSfPHYsgTnR6hxVYkmXWydswdHT0FNUtJtvtjwMEI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vFc9+b10D8of8QGjeW6z4Mwgo9Zim7qfUWRuSkfMCfY6d3pQ1rFTpVMDge5rd+O+s
         mNy4xcbDdHBBen87MdZPNA/H9VKq0ifRO/DNGI+mRgi3BdL5aq9XVsoDw+a4g5t+4h
         vb8MyrXb2pSq2yyyHlkzuOrFqdgDww4t/cSMPngM=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA1HTRer019560
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Nov 2019 12:29:27 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 1 Nov
 2019 12:29:13 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 1 Nov 2019 12:29:13 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1HTN5m046902;
        Fri, 1 Nov 2019 12:29:24 -0500
Subject: Re: [PATCH v5 net-next 05/12] dt-bindings: net: ti: add new cpsw
 switch driver bindings
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-6-grygorii.strashko@ti.com>
 <20191029022305.GK15259@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <0f79794b-ca33-fc00-645a-9cd37aa6fdd4@ti.com>
Date:   Fri, 1 Nov 2019 19:29:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029022305.GK15259@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Andrew,

On 29/10/2019 04:23, Andrew Lunn wrote:
>> +TI SoC Ethernet Switch Controller Device Tree Bindings (new)
>> +------------------------------------------------------
>> +
>> +The 3-port switch gigabit ethernet subsystem provides ethernet packet
>> +communication and can be configured as an ethernet switch.
> 
> Hi Grygorii
> 
> Maybe referring it to a 3-port switch will cause confusion, since in
> this use case, it only has 2 ports, and you only list two ports in the
> device tree.

Yeah. This is how it's defined in TRM - Port 0 (CPU port) is the same as external Port from
CPSW switch core point of view.

> 
>> It provides the
>> +gigabit media independent interface (GMII),reduced gigabit media
>> +independent interface (RGMII), reduced media independent interface (RMII),

[...]

>> +
>> +&mac_sw {
>> +	pinctrl-names = "default", "sleep";
>> +	status = "okay";
>> +};
>> +
>> +&cpsw_port1 {
>> +	phy-handle = <&ethphy0_sw>;
>> +	phy-mode = "rgmii";
>> +	ti,dual_emac_pvid = <1>;
>> +};
>> +
>> +&cpsw_port2 {
>> +	phy-handle = <&ethphy1_sw>;
>> +	phy-mode = "rgmii";
>> +	ti,dual_emac_pvid = <2>;
>> +};
>> +
>> +&davinci_mdio_sw {
>> +	ethphy0_sw: ethernet-phy@0 {
>> +		reg = <0>;
>> +	};
>> +
>> +	ethphy1_sw: ethernet-phy@1 {
>> +		reg = <1>;
>> +	};
>> +};
> 
> In an example, it is unusual to split things up like this. I
> understand that parts of this will be in the dtsi file, and parts in
> the .dts file, but examples generally keep it all as one. And when you
> re-write this in YAML so it can be used to validated real DTs, you
> will have to combine it.

Thank you. I'll update.

-- 
Best regards,
grygorii
