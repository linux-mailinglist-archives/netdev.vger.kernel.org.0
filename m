Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733715B7077
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 16:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiIMO1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 10:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiIMO0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 10:26:39 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB0167459
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 07:16:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663078468; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MzaZa2WQtlRdTzi8tOfC68cBb2Ceoq6HZIXuoCniI+UsmBlEUbgdTUFEOxA590gw9Pkcar2YZbgmIEmsMwzn1UDx4dLmZGbJpUClfgRoA/UizsILxKXFKZCTGCLfQuaKzp2mzW7Feuf4YthZSwMsgrph7tTMfCQEIxiYGXOAgI0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663078468; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=iRLdT3aU1LgBOiMK66KmiIjapaD8BSf3ORp6HQO/xhk=; 
        b=Sj5M2WrMUU+xzkit+73aGwdT5nu/lb4tQWW2BkXNSiUw3IAWLUjAXu3yLzksNdXTOVQYcuswid9kOcnoOEqhK5IlWpdjn6Daazn4YVItxhN5Bl1dgN3caDWft4BkSv+U8i3VAkAa2Z3e+tI7i7unmqyNsFCTi1vGnMC0WM7d0kE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663078468;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=iRLdT3aU1LgBOiMK66KmiIjapaD8BSf3ORp6HQO/xhk=;
        b=Z090IQ4OFjTbEZuFX9rMNBgs8TJ77OP+I4U3QyGJ6LrvNASxlc80n3qUxvS9b9Wb
        Vcdv4RuDMGcAgUY6YQmt8UEF+2T+JJS0CKujOiF0PzkHo8EMTPZ6wfAb2tJKNCnXyr3
        8B2kSgl5I/iPVFSPw0gFtcd3//DoDMQ2QfqTs43Y=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663078466851413.63336965516294; Tue, 13 Sep 2022 07:14:26 -0700 (PDT)
Message-ID: <8a323fc4-bf98-a808-899a-957438b0d792@arinc9.com>
Date:   Tue, 13 Sep 2022 17:14:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu"
 from examples
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-4-vladimir.oltean@nxp.com>
 <b11e86c6-ff35-2103-cebe-ebe5f737d9de@arinc9.com>
 <20220913133122.gzs2uhuk626eazee@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220913133122.gzs2uhuk626eazee@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.09.2022 16:31, Vladimir Oltean wrote:
> On Tue, Sep 13, 2022 at 11:20:04AM +0300, Arınç ÜNAL wrote:
>> Is there also a plan to remove this from every devicetree on mainline that
>> has got this property on the CPU port?
>>
>> I'd like to do the same on the DTs on OpenWrt.
> 
> I don't really have the time to split patches towards every individual
> platform maintainer and follow up with them until such patches would get
> accepted. I would encourage such an initiative coming from somebody else,
> though.

Understood, I think I can deal with this.

Arınç
