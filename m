Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119AF6F2979
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjD3QSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 12:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3QSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 12:18:12 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB3C2693;
        Sun, 30 Apr 2023 09:18:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682871453; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=RcKG0fq2Np8JTd1gJDHJ3xZGFExtlqzo5T7irO6pWfeZ/2/M2ZDm/jLBhjXs8kSkqYWKltiQnIDcEIfTBO7FtArT7A896bpZWX/bHXkDg1+sETSGhTQpfGWVAB0eCN0DF1yZRCAZon+5uG7q4OXL3GaSDy2zq2ERlpX200I2kq4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682871453; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=V23TsjyY1dD7n4GR0wkMYD0yPbsZ48d23pahmY6bjZY=; 
        b=egBI5N2x2xYD8oG6Kr7GWcgP9HX9ZmakF1ZNRuSnbe2Adsizk6Cd/KsfzZTavi2qqAUbis9aHymScsoIY7Cl8QpEXxKuW9JW/MEn3HvzSTzSD8PHtAzRRg6QyEtX/5W3pYCIJqQQT5LWlxzpfhUDqT2h168wLDyrOlfqDwO/V9E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682871453;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=V23TsjyY1dD7n4GR0wkMYD0yPbsZ48d23pahmY6bjZY=;
        b=FFkIp0TaDngLCZzkJ4tp5UabOW70Lfj1EnSKtRxj2nB+3YW1YNS1QrZ8kNC+JliO
        OUTaUiy6xEo6mlWlpI1mzcCGLner8djPP+Lpq8LkAJFYiKG637OUtDZVVOs6EkIEVef
        sklI13M03UKQ6L4dcgDVp7QB2mfB6EADw01b7t/8=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682871451193369.77097793382404; Sun, 30 Apr 2023 09:17:31 -0700 (PDT)
Message-ID: <396fad42-89d0-114d-c02e-ac483c1dd1ed@arinc9.com>
Date:   Sun, 30 Apr 2023 19:17:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     David Bauer <mail@david-bauer.net>, Andrew Lunn <andrew@lunn.ch>,
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
        Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230430112834.11520-1-mail@david-bauer.net>
 <20230430112834.11520-2-mail@david-bauer.net>
 <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
Content-Language: en-US
In-Reply-To: <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
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

On 30.04.2023 15:34, Arınç ÜNAL wrote:
> On 30.04.2023 14:28, David Bauer wrote:
>> Document the ability to add nodes for the MDIO bus connecting the
>> switch-internal PHYs.
> 
> This is quite interesting. Currently the PHY muxing feature for the 
> MT7530 switch looks for some fake ethernet-phy definitions on the 
> mdio-bus where the switch is also defined.
> 
> Looking at the binding here, there will be an mdio node under the switch 
> node. This could be useful to define the ethernet-phys for PHY muxing 
> here instead, so we don't waste the register addresses on the parent 
> mdio-bus for fake things. It looks like this should work right out of 
> the box. I will do some tests.

Once I start using the mdio node it forces me to define all the PHYs 
which were defined as ports.

[    4.159534] mt7530-mdio mdio-bus:1f lan0 (uninitialized): no phy at 1
[    4.166002] mt7530-mdio mdio-bus:1f lan0 (uninitialized): failed to 
connect to PHY: -ENODEV
[    4.174421] mt7530-mdio mdio-bus:1f lan0 (uninitialized): error -19 
setting up PHY for tree 0, switch 0, port 1
[    4.185236] mt7530-mdio mdio-bus:1f lan1 (uninitialized): no phy at 2
[    4.191753] mt7530-mdio mdio-bus:1f lan1 (uninitialized): failed to 
connect to PHY: -ENODEV
[    4.200150] mt7530-mdio mdio-bus:1f lan1 (uninitialized): error -19 
setting up PHY for tree 0, switch 0, port 2
[    4.210844] mt7530-mdio mdio-bus:1f lan2 (uninitialized): no phy at 3
[    4.217361] mt7530-mdio mdio-bus:1f lan2 (uninitialized): failed to 
connect to PHY: -ENODEV
[    4.225734] mt7530-mdio mdio-bus:1f lan2 (uninitialized): error -19 
setting up PHY for tree 0, switch 0, port 3
[    4.236394] mt7530-mdio mdio-bus:1f lan3 (uninitialized): no phy at 4
[    4.242901] mt7530-mdio mdio-bus:1f lan3 (uninitialized): failed to 
connect to PHY: -ENODEV
[    4.251297] mt7530-mdio mdio-bus:1f lan3 (uninitialized): error -19 
setting up PHY for tree 0, switch 0, port 4

We can either force defining the PHYs on the mdio node which would break 
the ABI, or forget about doing PHY muxing this way.

Arınç
