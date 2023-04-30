Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A396F2A85
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 21:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjD3Tzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 15:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjD3Tzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 15:55:44 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716701B0;
        Sun, 30 Apr 2023 12:55:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682884511; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ELVmPsPj+tvgATiVD8QnGSS2qfJ6ouQ8XHITVeKAtQsH49ts3s4uBoikWldY/xSEVpVMNx+jjQ0J84OCJ1akpmejjFUrXV+50O3ihQkkVrkf9RWVgpUXyl0FqJi52eH2Bvj0ClqDpQJVyOtOYQOj25QLDEWLLeS0B+XT/gZas9M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682884511; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yS1MvJOhkRGZd3+E1QPM0e+Ot0X4hMIHOBiXmhpx4pU=; 
        b=XzpvrETB60QvAfL9t7MkN5FriGWzdhi0q0WzFOwpvw94VRPJqzDNHbtRjt7qlU7CCp54RX9ghBlXdGBnfwbo2dYH55GB2CvwAB8NEeZvi8HzATRy19PnzbC8UhahmXIVL34OCtHxsrOnctLfMeScIiD7Y+TH7jfX3TgQW+Bbok8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682884511;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=yS1MvJOhkRGZd3+E1QPM0e+Ot0X4hMIHOBiXmhpx4pU=;
        b=LgNKLw9HOE39T4dd7Nd0VX84d7FIPRYLNsGFRGlzfnYqwhzT6YyhKob33qje01RY
        YPaRst+xIoLxQKY9qi6GIELT3RPFlDAnmwY4+2eYd5t0RBADvPCLnJMoBa1a0hb+bP5
        vKjV0tqZm6hPsqAwGQxgy0wWSm2nXf2lmGtQUl+E=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682884510627985.736159985858; Sun, 30 Apr 2023 12:55:10 -0700 (PDT)
Message-ID: <e5476692-aa3a-29b8-2e1d-ce93fd13a23b@arinc9.com>
Date:   Sun, 30 Apr 2023 22:54:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Bauer <mail@david-bauer.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230430112834.11520-1-mail@david-bauer.net>
 <20230430112834.11520-2-mail@david-bauer.net>
 <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
 <396fad42-89d0-114d-c02e-ac483c1dd1ed@arinc9.com>
 <04cc2904-6d61-416e-bfbe-c24d96fe261b@lunn.ch>
 <a6c6fe83-fbb5-f289-2210-6f1db6585636@arinc9.com>
 <207753d6-cffd-4a23-be16-658d7c9ceb4a@lunn.ch>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <207753d6-cffd-4a23-be16-658d7c9ceb4a@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.04.2023 21:48, Andrew Lunn wrote:
>>> Try setting ds->slave_mii_bus to the MDIO bus you register via
>>> of_mdiobus_register().
>>
>> That seems to be the case already, under mt7530_setup_mdio():
>>
>> 	bus = devm_mdiobus_alloc(dev);
>> 	if (!bus)
>> 		return -ENOMEM;
>>
>> 	ds->slave_mii_bus = bus;
>>
>> The bus is registered with devm_of_mdiobus_register(), if that matters. (My
>> current knowledge about OF or OF helpers for MDIO is next to nothing.)
>>
>> The same behaviour is there.
> 
> Maybe take a look at what is going on in dsa_slave_phy_setup() and
> dsa_slave_phy_connect().
> 
> The way i understand it, is it first looks in DT to see if there is a
> phy-handle, and if there is, it uses it. If not, it assumes there is a
> 1:1 mapping between port number and PHY address, and looks to see if a
> PHY has been found on ds->slave_mii_bus at that address, and uses it.
> 
> So i don't think you need to list the PHY, the fallback should be
> used.

Thanks for pointing me in the right direction Andrew.

I applied this diff:

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 389f33a12534..19d0c209e7e9 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -117,8 +117,12 @@ struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
  
  	mdiodev = bus->mdio_map[addr];
  
-	if (!mdiodev)
+	if (!mdiodev) {
+		dev_info(&bus->dev, "mdio device doesn't exist\n");
  		return NULL;
+	}
+
+	dev_info(&bus->dev, "mdio device exists\n");
  
  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
  		return NULL;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 165bb2cb8431..0be408e32a76 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2487,6 +2487,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
  		/* We could not connect to a designated PHY or SFP, so try to
  		 * use the switch internal MDIO bus instead
  		 */
+		netdev_err(slave_dev, "using switch's internal MDIO bus\n");
  		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
  	}
  	if (ret) {

With or without this patch, the switch's internal MDIO bus is used to set
up the PHYs.

DT that defines ethphy0 only, without this patch applied:

[    4.660784] mt7530-mdio mdio-bus:1f wan (uninitialized): using switch's internal MDIO bus
[    4.669026] mdio_bus mt7530-0: mdio device exists
[    4.677693] mt7530-mdio mdio-bus:1f wan (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.693238] mt7530-mdio mdio-bus:1f lan0 (uninitialized): using switch's internal MDIO bus
[    4.701589] mdio_bus mt7530-0: mdio device exists
[    4.707101] mt7530-mdio mdio-bus:1f lan0 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.718550] mt7530-mdio mdio-bus:1f lan1 (uninitialized): using switch's internal MDIO bus
[    4.726856] mdio_bus mt7530-0: mdio device exists
[    4.732384] mt7530-mdio mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.743822] mt7530-mdio mdio-bus:1f lan2 (uninitialized): using switch's internal MDIO bus
[    4.752154] mdio_bus mt7530-0: mdio device exists
[    4.757662] mt7530-mdio mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.769099] mt7530-mdio mdio-bus:1f lan3 (uninitialized): using switch's internal MDIO bus
[    4.781872] mdio_bus mt7530-0: mdio device exists
[    4.787413] mt7530-mdio mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:04] driver [MediaTek MT7530 PHY] (irq=POLL)

Same DT but with this patch applied:

[    4.621547] mt7530-mdio mdio-bus:1f: configuring for fixed/trgmii link mode
[    4.631524] mt7530-mdio mdio-bus:1f wan (uninitialized): using switch's internal MDIO bus
[    4.639764] mdio_bus mt7530-0: mdio device exists
[    4.647770] mt7530-mdio mdio-bus:1f wan (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.663898] mt7530-mdio mdio-bus:1f lan0 (uninitialized): using switch's internal MDIO bus
[    4.672253] mdio_bus mt7530-0: mdio device doesn't exist
[    4.677597] mt7530-mdio mdio-bus:1f lan0 (uninitialized): no phy at 1
[    4.684053] mt7530-mdio mdio-bus:1f lan0 (uninitialized): failed to connect to PHY: -ENODEV
[    4.692435] mt7530-mdio mdio-bus:1f lan0 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 1
[    4.703087] mt7530-mdio mdio-bus:1f lan1 (uninitialized): using switch's internal MDIO bus
[    4.711408] mdio_bus mt7530-0: mdio device doesn't exist
[    4.716731] mt7530-mdio mdio-bus:1f lan1 (uninitialized): no phy at 2
[    4.723214] mt7530-mdio mdio-bus:1f lan1 (uninitialized): failed to connect to PHY: -ENODEV
[    4.731597] mt7530-mdio mdio-bus:1f lan1 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 2
[    4.742199] mt7530-mdio mdio-bus:1f lan2 (uninitialized): using switch's internal MDIO bus
[    4.755431] mdio_bus mt7530-0: mdio device doesn't exist
[    4.760793] mt7530-mdio mdio-bus:1f lan2 (uninitialized): no phy at 3
[    4.767263] mt7530-mdio mdio-bus:1f lan2 (uninitialized): failed to connect to PHY: -ENODEV
[    4.775632] mt7530-mdio mdio-bus:1f lan2 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 3
[    4.786270] mt7530-mdio mdio-bus:1f lan3 (uninitialized): using switch's internal MDIO bus
[    4.794591] mdio_bus mt7530-0: mdio device doesn't exist
[    4.799944] mt7530-mdio mdio-bus:1f lan3 (uninitialized): no phy at 4
[    4.806397] mt7530-mdio mdio-bus:1f lan3 (uninitialized): failed to connect to PHY: -ENODEV
[    4.814782] mt7530-mdio mdio-bus:1f lan3 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 4

DT without the mdio node defined, with this patch applied:

[    4.650766] mt7530-mdio mdio-bus:1f: configuring for fixed/trgmii link mode
[    4.660687] mt7530-mdio mdio-bus:1f wan (uninitialized): using switch's internal MDIO bus
[    4.668937] mdio_bus mt7530-0: mdio device exists
[    4.677787] mt7530-mdio mdio-bus:1f wan (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.693165] mt7530-mdio mdio-bus:1f lan0 (uninitialized): using switch's internal MDIO bus
[    4.701517] mdio_bus mt7530-0: mdio device exists
[    4.707029] mt7530-mdio mdio-bus:1f lan0 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.718469] mt7530-mdio mdio-bus:1f lan1 (uninitialized): using switch's internal MDIO bus
[    4.726773] mdio_bus mt7530-0: mdio device exists
[    4.732322] mt7530-mdio mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.743793] mt7530-mdio mdio-bus:1f lan2 (uninitialized): using switch's internal MDIO bus
[    4.752143] mdio_bus mt7530-0: mdio device exists
[    4.757662] mt7530-mdio mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=POLL)
[    4.769105] mt7530-mdio mdio-bus:1f lan3 (uninitialized): using switch's internal MDIO bus
[    4.781905] mdio_bus mt7530-0: mdio device exists
[    4.787459] mt7530-mdio mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:04] driver [MediaTek MT7530 PHY] (irq=POLL)

This is how I define it, mind you no phandles.

switch@1f {
	...
	mdio {
		#address-cells = <0x01>;
		#size-cells = <0x00>;

		ethernet-phy@0 {
			reg = <0x00>;
		};
	};
};

Like you said, if the mdio node is not defined, the driver will assume 1:1
mapping. If not, it will need all the PHYs to be defined on the mdio node
along with on the ports node. Hence back to my original statement, we can
either force defining the PHYs on the mdio node which would break the ABI,
or forget about doing PHY muxing this way.

There are no MDIO operations needed on the PHYs for the PHY muxing anyway,
so I'd rather do this some other way.

Thanks for the help.

Arınç
