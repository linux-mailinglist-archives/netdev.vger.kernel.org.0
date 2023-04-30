Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101316F2A56
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjD3S3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 14:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjD3S3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:29:21 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441311735;
        Sun, 30 Apr 2023 11:29:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682879329; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Df4NHlvOv469Uzy5L8lZNU252LcUatMtKixmuVpIr3/LCgHDQQnncMm8FfsyeZm+q3TsH0y6ad1G6jpSVuudH8k++o1Ruk3zGjdiDJH7x7+CLREVINO5kRsHLOskmDU0PkeNRCAdYcbgy0ojT5mkh31d2ag2XPX7OzNHtI43DSA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682879329; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Azc4Hc1srpPKgzIM+J+f5sUKPmY+suHFF9oAfbKeBhU=; 
        b=W4UMlZXdcTam16sk55nJXZs6QqlEw0O958MtmrNUnn0j7IDElKXl4H4VTDUiNVoccs8JaJbM/xam2UQF5babseT3DtEKqh5FmlDbgOkYuXpxVhOK9HNHXDNYtYuPr7Csa6/QMdtkCTzEQ5FuhW+k7Pek1xdXg1vwQYAN/wACOfc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682879329;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Azc4Hc1srpPKgzIM+J+f5sUKPmY+suHFF9oAfbKeBhU=;
        b=VNwLLh0SrtzCxN6J1ejN0CMx3NFNwTYCaRUy/0vEUpT4/TOw7PaAB2fLpnbsqJJW
        c4DCv+YAlxeYQwVmsAP8nt1TXAxmdPaw9Ma7QWCJx7Pl6gUFr0MeKvm+yR68ztGF2Ip
        0Ce0cbbyPhqFb1qotE62U9wQdXUZ+ODu6/3jNJlk=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 168287932708259.260584656568085; Sun, 30 Apr 2023 11:28:47 -0700 (PDT)
Message-ID: <a6c6fe83-fbb5-f289-2210-6f1db6585636@arinc9.com>
Date:   Sun, 30 Apr 2023 21:28:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
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
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <04cc2904-6d61-416e-bfbe-c24d96fe261b@lunn.ch>
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

On 30.04.2023 20:18, Andrew Lunn wrote:
> On Sun, Apr 30, 2023 at 07:17:10PM +0300, Arınç ÜNAL wrote:
>> On 30.04.2023 15:34, Arınç ÜNAL wrote:
>>> On 30.04.2023 14:28, David Bauer wrote:
>>>> Document the ability to add nodes for the MDIO bus connecting the
>>>> switch-internal PHYs.
>>>
>>> This is quite interesting. Currently the PHY muxing feature for the
>>> MT7530 switch looks for some fake ethernet-phy definitions on the
>>> mdio-bus where the switch is also defined.
>>>
>>> Looking at the binding here, there will be an mdio node under the switch
>>> node. This could be useful to define the ethernet-phys for PHY muxing
>>> here instead, so we don't waste the register addresses on the parent
>>> mdio-bus for fake things. It looks like this should work right out of
>>> the box. I will do some tests.
>>
>> Once I start using the mdio node it forces me to define all the PHYs which
>> were defined as ports.
> 
> Try setting ds->slave_mii_bus to the MDIO bus you register via
> of_mdiobus_register().

That seems to be the case already, under mt7530_setup_mdio():

	bus = devm_mdiobus_alloc(dev);
	if (!bus)
		return -ENOMEM;

	ds->slave_mii_bus = bus;

The bus is registered with devm_of_mdiobus_register(), if that matters. 
(My current knowledge about OF or OF helpers for MDIO is next to nothing.)

The same behaviour is there.

Arınç
