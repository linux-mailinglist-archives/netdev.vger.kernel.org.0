Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E965B943F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiIOGZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIOGZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:25:20 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA767677C;
        Wed, 14 Sep 2022 23:25:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663223085; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QhT+tIPCFvVSGigO6Bnk6e6Bh2/EWYUf/infZjmQGj6iO1TGNFp9mXguDuOUm/DpWvf1OgKkKfqzIb7ZN6l9ctq0lWG5/c7d1CSAjTq9cvsm/EE5alr2+5SNHKUxhuVbtlW8IBJ9ao1FlLD5+bECDV2zoGW0ERjC6wFnGpVteZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663223085; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=SaIR9ac/WNESLZgIJ7NfWDPlOEsbmM5EMrQeBc4rRcQ=; 
        b=GuqatCqi3aNs0LWmQ5GNwlHSYYwAWDsF+H0n4REekizZUb117F/XuatyMC2g/jcD0YiW3vzn3hJN0FaaKwBPpjtMyOueJBdmUDuH34d8RrIXUsWSeagJIFN/B5GVfqb3tgRyCWelbulAdkRevrMZE3eXoEl767I/gNWhoQyVQ4Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663223085;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=SaIR9ac/WNESLZgIJ7NfWDPlOEsbmM5EMrQeBc4rRcQ=;
        b=XDIDPnVMmzMdjdr4PWLtYOkpEuSco+I7L4NEGf6+WLphaJt9VGVtFjp9BCrmtJuU
        7ij/J6uM1EF/jrYfl1rkVfuPnaeTFjQfXrlAeYxX/MKVqAxa1Ngir6nbwhzyqohMOwn
        1gQDBTSmHpK+ZKrFbJ0+d3Q77xQtFQSvBjt7EQxw=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663223084388940.7928349747789; Wed, 14 Sep 2022 23:24:44 -0700 (PDT)
Message-ID: <aca736cd-a2f9-2af9-df59-7f8be7c991b6@arinc9.com>
Date:   Thu, 15 Sep 2022 09:24:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 04/10] dt-bindings: memory: mt7621: add syscon as
 compatible string
Content-Language: en-US
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
 <20220914085451.11723-5-arinc.unal@arinc9.com>
 <20220914151414.GA2233841-robh@kernel.org>
 <44045164-692d-c8f5-3216-b043fb821634@arinc9.com>
 <CAMhs-H-0XV9ocrG3_MuVc3Q=o8HnYso2CqUURjVR3OMc=dAMYg@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CAMhs-H-0XV9ocrG3_MuVc3Q=o8HnYso2CqUURjVR3OMc=dAMYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.09.2022 06:21, Sergio Paracuellos wrote:
> On Wed, Sep 14, 2022 at 5:19 PM Arınç ÜNAL <arinc.unal@arinc9.com> wrote:
>>
>> On 14.09.2022 18:14, Rob Herring wrote:
>>> On Wed, Sep 14, 2022 at 11:54:45AM +0300, Arınç ÜNAL wrote:
>>>> Add syscon as a constant string on the compatible property as it's required
>>>> for the SoC to work. Update the example accordingly.
>>>
>>> It's not required. It's required to automagically create a regmap. That
>>> can be done yourself as well. The downside to adding 'syscon' is it
>>> requires a DT update. Maybe that's fine for this platform? I don't know.
>>
>> My GB-PC2 won't boot without syscon on mt7621.dtsi. This string was
>> always there on the memory controller node on mt7621.dtsi.
> 
> The string was introduced because the mt7621 clock driver needs to
> read some registers creating a regmap from the syscon. The bindings
> were added before the clock driver was properly mainlined and at first
> the clock driver was using ralink architecture dependent operations
> rt_memc_* defined in
> 'arch/mips/include/asm/mach-ralink/ralink_regs.h'. I forgot to update
> the mem controller binding when memc became a syscon so I think this
> patch is correct. I also think the sample should use 'syscon' in the
> node name instead of memory-controller.

Will change to syscon in v2.

Arınç
