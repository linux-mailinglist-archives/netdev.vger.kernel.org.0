Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FA658350D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiG0WFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 18:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234136AbiG0WFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 18:05:18 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7438D5C;
        Wed, 27 Jul 2022 15:05:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1658959465; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=XYz5/7b34v/qGC1P86nS7wd8YdpQ+TTXaWaAx+qOw93D5LjLlad4sNVkB6zpR1hoTGUkjNs+s7eLj2yvoJkAB5rWVauZdLhI+E8cP3dGEvUcLq+kRagyhhqUuguZz+mwcW8ddGZhNS6PCkILbhSsvH8FEMa5aNPG1lr3WaGSJFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1658959465; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=KulfU3qDbvzcs/NpGiiPGnxBjN9EcMNe7GHzjnyKn1Y=; 
        b=ewGX6dPcfZFIqAAy08Ki6QwaQ9hl4Hub76XjsYIUfQ3HlvPpZzwAOMz2NJRcc/yOjbIdT2TS0VsYc7yfaQ1YbA3oXlvSGQJhd9GYJsx8/MBGikSlVqqC+FQvSPtF0b/bp8OzWtgDt2gRuJBKG8dX+qtZV3ENo2vsgZrt5BQNagk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1658959465;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=KulfU3qDbvzcs/NpGiiPGnxBjN9EcMNe7GHzjnyKn1Y=;
        b=Lv/ydmnJa0iF7zD9n9fFkXJl+kxAD7cabcm7J6y8vQLwMhG75UNMPF6NU10+R48K
        elj5/gcFsiV75xzs91Bv5iZWW1ASbCEXKCzl0mUsDyDPQZ4osuec4WQxTkF8B91bdvh
        3FDinO3g+Xp0zU6sgS9r3LVXXPZWfvtPEOBrCDMY=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1658959461763271.8212578498445; Wed, 27 Jul 2022 15:04:21 -0700 (PDT)
Message-ID: <709af825-7fde-d2c6-2237-3490163afa0e@arinc9.com>
Date:   Thu, 28 Jul 2022 01:04:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Aw: [RFC PATCH net-next] dt-bindings: net: dsa: mediatek,mt7530:
 completely rework binding
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     frank-w@public-files.de
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
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220726122406.31043-1-arinc.unal@arinc9.com>
 <trinity-96b64414-7b29-4886-b309-48fc9f108959-1658953872981@3c-app-gmx-bs42>
 <f8ccb632-4bca-486b-a8a4-65b6b90de751@arinc9.com>
 <0426AFB2-55B6-48E6-998F-8DA09D0BDC29@public-files.de>
 <28a1620c-9771-f4dd-c432-4940d3b8f430@arinc9.com>
In-Reply-To: <28a1620c-9771-f4dd-c432-4940d3b8f430@arinc9.com>
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

On 28.07.2022 00:46, Arınç ÜNAL wrote:
> On 28.07.2022 00:26, Frank Wunderlich wrote:
>> Am 27. Juli 2022 22:59:16 MESZ schrieb "Arınç ÜNAL" 
>> <arinc.unal@arinc9.com>:
>>> On 27.07.2022 23:31, Frank Wunderlich wrote:
>>>>
>>
>>> I've seen this under mt7530_setup():
>>> The bit for MHWTRAP_P6_DIS is cleared to enable port 6 with the 
>>> comment "Enable Port 6 only; P5 as GMAC5 which currently is not 
>>> supported".
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n2189 
>>>
>>
>> Later in same function it looks comment is obsolete.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n2234 

By the way, port 6 seems to be enabled even though port 5 is used as the 
cpu port. Shouldn’t that be behind a check?

>>
>>
>>   I know that rene added p5 support while phylink conversion,but not 
>> sure it was complete.
> 
> Thanks for pointing it out. I suppose it works fine since you tested it. 
> I will update my patch to allow setting port 5 as cpu port along with 
> splitting the patch.
> 
> Arınç
