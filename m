Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24367585965
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbiG3JQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbiG3JQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:16:07 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1713D24973;
        Sat, 30 Jul 2022 02:16:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659172525; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ZiQy66cF6l7rF1Kk0Ro+K7FCFJUDhDRzik60PYhZU+9K7FnYPvvmcwM3DXhpFGIPnOwUgKsXgYLmRqlGzVQwdlVTh7MJPK3pw5KlsLzUZa5W7NsjyAu6X5cyhyRJKuFlK3w/s/i/UJvYP7w8sFUm4sWv9IN7VBnGVUe5a9SzUg4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1659172525; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Ip/n8l6suEtbm+49thEhP6FKGtcYyDNRdjrTqyl8UVM=; 
        b=ct/2ZTeeaj+LRzWYAeDMwMUOZx4tFbT4uFDUlWGqJtk5YoJjuMPjXoip4scruo8dyHeyKhnDwABtAOMdWNizyaqkFLFF5+BJgYvMUUPfx9kkE93KbXMyyTAHvISaE1p1HeQ87HbsdvXPic59M6WBp9m1pEB/8zPiHzDywOzJVRs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1659172525;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Ip/n8l6suEtbm+49thEhP6FKGtcYyDNRdjrTqyl8UVM=;
        b=WinEmM44Ykvb7Xh+Iia+e46vquGVfpvZZeBTUmUZsWtYacUymSxrXNJDWhlCGqRJ
        34j8ZZEkILDcdkwm3vTLGzvu4WPoLhnGczFMG0CEkCQksmoDaYcM4YyKdFlVRMJ4azH
        NwoRQD1ZSa/3nhr3jrlpWb8ntgY1D+AYIy2xkjak=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1659172524609562.8091071134861; Sat, 30 Jul 2022 02:15:24 -0700 (PDT)
Message-ID: <980c9926-9199-9b6e-aa65-6b5276af5d70@arinc9.com>
Date:   Sat, 30 Jul 2022 12:15:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next] dt-bindings: net: dsa: mediatek,mt7530:
 completely rework binding
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220726122406.31043-1-arinc.unal@arinc9.com>
 <YuK193gAQ+Rwe26s@makrotopia.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <YuK193gAQ+Rwe26s@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.07.2022 19:14, Daniel Golle wrote:
> Hi,
> 
> please see a minor comment inline below:
> 
> On Tue, Jul 26, 2022 at 03:24:06PM +0300, Arınç ÜNAL wrote:
>> [...]
>> -  CPU-Ports need a phy-mode property:
>> -    Allowed values on mt7530 and mt7621:
>> -      - "rgmii"
>> -      - "trgmii"
>> -    On mt7531:
>> -      - "1000base-x"
>> -      - "2500base-x"
>> -      - "rgmii"
>> -      - "sgmii"
>> +  There are two versions of MT7530. MT7621AT, MT7621DAT, MT7621ST and MT7623AI
> 
> There are two version of MT7530 **supported by this driver**.....
> (MT7620 also contains MT7530, switch registers are directly mapped into
> SoC's memory map rather than using MDIO like on MT7621 and standalone
> variants, and it got FastEthernet PHYs for Port 0-4)

Thanks Daniel. To be precise, this is the case for MT7620AN, MT7620DA, 
MT7620DAN, MT7620NN, MT7628AN, MT7628DAN, MT7628DBN, MT7628KN, MT7628NN, 
MT7688AN and MT7688KN SoCs as all include a 5p FE switch according to 
Russia hosted WikiDevi.

I'll update the description accordingly.

Arınç
