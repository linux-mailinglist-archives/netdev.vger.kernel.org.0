Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53906F2FDF
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 11:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjEAJXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 05:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjEAJXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 05:23:00 -0400
Received: from perseus.uberspace.de (perseus.uberspace.de [95.143.172.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591171AC
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 02:22:56 -0700 (PDT)
Received: (qmail 8168 invoked by uid 988); 1 May 2023 09:22:54 -0000
Authentication-Results: perseus.uberspace.de;
        auth=pass (plain)
Message-ID: <1f759370-af97-e2a4-4b93-183eb854f7cd@david-bauer.net>
Date:   Mon, 1 May 2023 11:22:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
 <e5476692-aa3a-29b8-2e1d-ce93fd13a23b@arinc9.com>
Content-Language: en-US
From:   David Bauer <mail@david-bauer.net>
In-Reply-To: <e5476692-aa3a-29b8-2e1d-ce93fd13a23b@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -
X-Rspamd-Report: MIME_GOOD(-0.1) BAYES_HAM(-3) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -1.6
Received: from unknown (HELO unkown) (::1)
        by perseus.uberspace.de (Haraka/3.0.1) with ESMTPSA; Mon, 01 May 2023 11:22:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=david-bauer.net; s=uberspace;
        h=from;
        bh=QwZKnoaoF4qggiTtg5kg8KcY443HPD6AZLVvdXmng7M=;
        b=EumWdTO8wEuVeRgdhvZ2g4iQPSswe58duOH/gUbmNWcy2s2D9biyRbmcjEG0fF7xZQZgiC7wvU
        cbrElEoYqWNgBpHIkWB3mXTccfsEmDNBRmVYvG8+CMc2yuL8NVbYxXBtlDrZBmWd5NZqbqLhK2D1
        2dLj9zCzC01/G8SGmxywJAf7lBNSs2ehnrbljnpBCLTQqTUW3pPbwbMM8aRI8t6SO1g7sgEHqv6/
        UIf6TFgjPgmAq/2LRhqgcf2NuDxiLquNOedJmPkoAXNW8Vj9drkpM+Cm7/1dlgeGfLtTUD9SOdrr
        W89lCARjN+20I013+Gt0cY5nYB81nhDnBBvepqZjLiGkrOTqr2a4pTqjYnVkt4Wn5Ntgxf1JC7kp
        oE5S7lx4c4LzKnb39z6BPd2mIECgCOm2NcflodxJF2zXxgOc/ofmAnfn6DaOelDfnRTvD/up0U8u
        xerz+A2oQEf+tyNn2tKwaaLPdSETKC9u2wkRqvj71P4h7PJ15DEZxmv4K20qrKAzdgv5Bkz55jd1
        l+YCur7JrBLDCPXBsCZaT7cOLRuWE0tRMdXEFvEoR78kHJSAaXJxPtXpqANjhb5Lfq0dQWj1bYvb
        rQu8U9g5xlQHUjTdtHp8F75/2azyeCWzRjacnu0D4WZmk/t6AYIGtwQ/T6JKeSGj4YIQ9A5YqTvf
        8=
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arinc,

thanks for spotting this issue.

On 4/30/23 21:54, Arınç ÜNAL wrote:
> On 30.04.2023 21:48, Andrew Lunn wrote:
>>>> Try setting ds->slave_mii_bus to the MDIO bus you register via
>>>> of_mdiobus_register().
>>>
>>> That seems to be the case already, under mt7530_setup_mdio():
>>>
>>>     bus = devm_mdiobus_alloc(dev);
>>>     if (!bus)
>>>         return -ENOMEM;
>>>
>>>     ds->slave_mii_bus = bus;
>>>
>>> The bus is registered with devm_of_mdiobus_register(), if that matters. (My
>>> current knowledge about OF or OF helpers for MDIO is next to nothing.)
>>>
>>> The same behaviour is there.
>>
>> Maybe take a look at what is going on in dsa_slave_phy_setup() and
>> dsa_slave_phy_connect().
>>
>> The way i understand it, is it first looks in DT to see if there is a
>> phy-handle, and if there is, it uses it. If not, it assumes there is a
>> 1:1 mapping between port number and PHY address, and looks to see if a
>> PHY has been found on ds->slave_mii_bus at that address, and uses it.
>>
>> So i don't think you need to list the PHY, the fallback should be
>> used.
> 
> Thanks for pointing me in the right direction Andrew.
> 
> I applied this diff:
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 389f33a12534..19d0c209e7e9 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -117,8 +117,12 @@ struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
> 
>       mdiodev = bus->mdio_map[addr];
> 
> -    if (!mdiodev)
> +    if (!mdiodev) {
> +        dev_info(&bus->dev, "mdio device doesn't exist\n");
>           return NULL;
> +    }
> +
> +    dev_info(&bus->dev, "mdio device exists\n");
> 
>       if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>           return NULL;
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 165bb2cb8431..0be408e32a76 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2487,6 +2487,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
>           /* We could not connect to a designated PHY or SFP, so try to
>            * use the switch internal MDIO bus instead
>            */
> +        netdev_err(slave_dev, "using switch's internal MDIO bus\n");
>           ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
>       }
>       if (ret) {
> 
> With or without this patch, the switch's internal MDIO bus is used to set
> up the PHYs.
> 
> DT that defines ethphy0 only, without this patch applied:
> 
> [    4.660784] mt7530-mdio mdio-bus:1f wan (uninitialized): using switch's internal MDIO bus
> [    4.669026] mdio_bus mt7530-0: mdio device exists
> [    4.677693] mt7530-mdio mdio-bus:1f wan (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.693238] mt7530-mdio mdio-bus:1f lan0 (uninitialized): using switch's internal MDIO bus
> [    4.701589] mdio_bus mt7530-0: mdio device exists
> [    4.707101] mt7530-mdio mdio-bus:1f lan0 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.718550] mt7530-mdio mdio-bus:1f lan1 (uninitialized): using switch's internal MDIO bus
> [    4.726856] mdio_bus mt7530-0: mdio device exists
> [    4.732384] mt7530-mdio mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.743822] mt7530-mdio mdio-bus:1f lan2 (uninitialized): using switch's internal MDIO bus
> [    4.752154] mdio_bus mt7530-0: mdio device exists
> [    4.757662] mt7530-mdio mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.769099] mt7530-mdio mdio-bus:1f lan3 (uninitialized): using switch's internal MDIO bus
> [    4.781872] mdio_bus mt7530-0: mdio device exists
> [    4.787413] mt7530-mdio mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:04] driver [MediaTek MT7530 PHY] (irq=POLL)
> 
> Same DT but with this patch applied:
> 
> [    4.621547] mt7530-mdio mdio-bus:1f: configuring for fixed/trgmii link mode
> [    4.631524] mt7530-mdio mdio-bus:1f wan (uninitialized): using switch's internal MDIO bus
> [    4.639764] mdio_bus mt7530-0: mdio device exists
> [    4.647770] mt7530-mdio mdio-bus:1f wan (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.663898] mt7530-mdio mdio-bus:1f lan0 (uninitialized): using switch's internal MDIO bus
> [    4.672253] mdio_bus mt7530-0: mdio device doesn't exist
> [    4.677597] mt7530-mdio mdio-bus:1f lan0 (uninitialized): no phy at 1
> [    4.684053] mt7530-mdio mdio-bus:1f lan0 (uninitialized): failed to connect to PHY: -ENODEV
> [    4.692435] mt7530-mdio mdio-bus:1f lan0 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 1
> [    4.703087] mt7530-mdio mdio-bus:1f lan1 (uninitialized): using switch's internal MDIO bus
> [    4.711408] mdio_bus mt7530-0: mdio device doesn't exist
> [    4.716731] mt7530-mdio mdio-bus:1f lan1 (uninitialized): no phy at 2
> [    4.723214] mt7530-mdio mdio-bus:1f lan1 (uninitialized): failed to connect to PHY: -ENODEV
> [    4.731597] mt7530-mdio mdio-bus:1f lan1 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 2
> [    4.742199] mt7530-mdio mdio-bus:1f lan2 (uninitialized): using switch's internal MDIO bus
> [    4.755431] mdio_bus mt7530-0: mdio device doesn't exist
> [    4.760793] mt7530-mdio mdio-bus:1f lan2 (uninitialized): no phy at 3
> [    4.767263] mt7530-mdio mdio-bus:1f lan2 (uninitialized): failed to connect to PHY: -ENODEV
> [    4.775632] mt7530-mdio mdio-bus:1f lan2 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 3
> [    4.786270] mt7530-mdio mdio-bus:1f lan3 (uninitialized): using switch's internal MDIO bus
> [    4.794591] mdio_bus mt7530-0: mdio device doesn't exist
> [    4.799944] mt7530-mdio mdio-bus:1f lan3 (uninitialized): no phy at 4
> [    4.806397] mt7530-mdio mdio-bus:1f lan3 (uninitialized): failed to connect to PHY: -ENODEV
> [    4.814782] mt7530-mdio mdio-bus:1f lan3 (uninitialized): error -19 setting up PHY for tree 0, switch 0, port 4
> 
> DT without the mdio node defined, with this patch applied:
> 
> [    4.650766] mt7530-mdio mdio-bus:1f: configuring for fixed/trgmii link mode
> [    4.660687] mt7530-mdio mdio-bus:1f wan (uninitialized): using switch's internal MDIO bus
> [    4.668937] mdio_bus mt7530-0: mdio device exists
> [    4.677787] mt7530-mdio mdio-bus:1f wan (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.693165] mt7530-mdio mdio-bus:1f lan0 (uninitialized): using switch's internal MDIO bus
> [    4.701517] mdio_bus mt7530-0: mdio device exists
> [    4.707029] mt7530-mdio mdio-bus:1f lan0 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.718469] mt7530-mdio mdio-bus:1f lan1 (uninitialized): using switch's internal MDIO bus
> [    4.726773] mdio_bus mt7530-0: mdio device exists
> [    4.732322] mt7530-mdio mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.743793] mt7530-mdio mdio-bus:1f lan2 (uninitialized): using switch's internal MDIO bus
> [    4.752143] mdio_bus mt7530-0: mdio device exists
> [    4.757662] mt7530-mdio mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=POLL)
> [    4.769105] mt7530-mdio mdio-bus:1f lan3 (uninitialized): using switch's internal MDIO bus
> [    4.781905] mdio_bus mt7530-0: mdio device exists
> [    4.787459] mt7530-mdio mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:04] driver [MediaTek MT7530 PHY] (irq=POLL)
> 
> This is how I define it, mind you no phandles.
> 
> switch@1f {
>      ...
>      mdio {
>          #address-cells = <0x01>;
>          #size-cells = <0x00>;
> 
>          ethernet-phy@0 {
>              reg = <0x00>;
>          };
>      };
> };
> 
> Like you said, if the mdio node is not defined, the driver will assume 1:1
> mapping. If not, it will need all the PHYs to be defined on the mdio node
> along with on the ports node. Hence back to my original statement, we can
> either force defining the PHYs on the mdio node which would break the ABI,
> or forget about doing PHY muxing this way.

While i was not aware of this side effect, I don't see how this breaks the ABI.

Existing device-trees not defining the MDIO node will still continue to work.

Wouldn't we just skip the whole issue by documenting the need for defining all PHYs
used on the switch when defining the MDIO bus?

Best
David

> 
> There are no MDIO operations needed on the PHYs for the PHY muxing anyway,
> so I'd rather do this some other way.
> 
> Thanks for the help.
> 
> Arınç
