Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E025859A8
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiG3JgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiG3JgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:36:04 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ADC18E07;
        Sat, 30 Jul 2022 02:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659173720; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=TKQQjb7ac+ivNU+QKoCKvumYFhO1f97PFAruFCysvTptSPQ6dFkyqCRwciVZTXi/B8WOptwq0eP2M5UzaQFPCVw5SVk3ZZV2hSRl2GX2iEzWLLbNUrZgO2v5NYRBdo5KiDEdiwYCoEyw70ttCCDM3/QJrNzZ5+HpXjMwuh0cgxI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1659173720; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=G7NscnYW6e9l+s6/WtNH8K8Pr07LMRM/ZHwEmfI4Dlo=; 
        b=hZNWs04mn5LWF549DqyY8UPHDFtOKw4gT0tOtNjyJaNeY5jE1PsqP5C1WrORv84qbzeOfNBXUO23QAxkAsUWd2Ss/f2pu+166I1HOUn0gfC78iVv4aVhOD7EQBBWcM/Bc99MseFqyTEhmy9VIYpwLHlqFP34wRMlBIJKDjC3vkc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1659173720;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=G7NscnYW6e9l+s6/WtNH8K8Pr07LMRM/ZHwEmfI4Dlo=;
        b=Ds0+LL7pCTJA9a/mNbBXd3J2CvzZpPydkY33AzWiQj6Czso0og16N3sdeOxyPziI
        1L+52f6RH7zrMsHsDg41ydBhKZaMfNUj0hmRqAEb3RasqZkclzJMYgjYKD9rZhRfZfy
        JAzwY1Z9crbXVa+Co2OkB7fwI0WW0Hyki1QRJ+Bw=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1659173718691412.0344941538166; Sat, 30 Jul 2022 02:35:18 -0700 (PDT)
Message-ID: <60be5351-8fd4-a7ae-9ff1-d336c2bcf391@arinc9.com>
Date:   Sat, 30 Jul 2022 12:35:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next] dt-bindings: net: dsa: mediatek,mt7530:
 completely rework binding
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
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
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20220726122406.31043-1-arinc.unal@arinc9.com>
 <YuK193gAQ+Rwe26s@makrotopia.org>
 <980c9926-9199-9b6e-aa65-6b5276af5d70@arinc9.com>
 <CALW65jYfcfND4QiD=8OhMCgW0LZMSBYmVZK5Ce8u3cMPh+8Rdg@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CALW65jYfcfND4QiD=8OhMCgW0LZMSBYmVZK5Ce8u3cMPh+8Rdg@mail.gmail.com>
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

On 30.07.2022 12:30, DENG Qingfang wrote:
> On Sat, Jul 30, 2022 at 5:15 PM Arınç ÜNAL <arinc.unal@arinc9.com> wrote:
>> Thanks Daniel. To be precise, this is the case for MT7620AN, MT7620DA,
>> MT7620DAN, MT7620NN, MT7628AN, MT7628DAN, MT7628DBN, MT7628KN, MT7628NN,
>> MT7688AN and MT7688KN SoCs as all include a 5p FE switch according to
>> Russia hosted WikiDevi.
> 
> MT76x8 series uses a different switch IP.

Alrighty, only MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs then. 
Thanks Qingfang.

Arınç
