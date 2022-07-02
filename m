Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E65563DC7
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 04:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiGBCfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 22:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiGBCfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 22:35:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBDE286D2
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 19:35:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id q18so3918409pld.13
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 19:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=M6f9teuI0q/E97bbwIC2FvfW718OYKguDk8jXXCj5Wo=;
        b=ledl3IGd7sHL7MZ5nZrwvG1DfltIxpc9Z9I0Jrg2z3LBJ3SOvy2pLQR9AttkDD9wev
         v+Xc6UPrTW0Ftonm3e/IG0eFf7S1ZfPzn1KDKZzeWohMA9euLmYtvCQlC5n/fsIMOkT1
         Sj4A2SbTgy2f2xujfOhUfNnOfibFoPlV5ugNmveD7ZViEDMT65A6Gw0Qw/cDZ5OcazPJ
         SOowqMm9oM9PUhzaIAnIimdwd7NovYVA+UYn6CPej6T2zfeJLxMZdlxFKgJsV6B79pod
         dqlpIb32JBlMmy5a6WXNTvuVnLwUjhQqUkwUhqGHqMdUaJIEOEtwmBzObqEUWosDEKNt
         5Jcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:content-language:from:in-reply-to
         :content-transfer-encoding;
        bh=M6f9teuI0q/E97bbwIC2FvfW718OYKguDk8jXXCj5Wo=;
        b=fKowNoTa3kDffVBXqddzEnGE9KgTnR9tuKSVqbCBzJ+MYkC92pt/Q8hmhWE/nY/+1O
         PKgqUIWIOfeobG4QO8KCZqC5e7VCZ+RMMPqw58+BlTz98wo0It2AepVRM386UzipyU3p
         5GMeG3gcr4CsuCO2QxXWI/ZdlT9uorfVSScl2xZz4sVBXi3VufOAf6Zt5cr8DVDrP/h2
         gR+fNxGERWSgOb/g9ElVIjJ+mjl3cRX6IJBKSWzScbrlWF0qMROpgkcva0UtDUwgVdlL
         Q62AZ3BL8W6xKa6fRFVSPYIHLBgelTOtyYYoAvMqxzQ4Tn35NVdLrpKuUPRunMeDROZA
         IVug==
X-Gm-Message-State: AJIora99260tt7iUVkSNZqnHciP3+2Yz4Tn7uZuKQWCdg5UbV8bK1REU
        Occp4K53VXBxEAo7OIjR6xI=
X-Google-Smtp-Source: AGRyM1vLUEFTlCaaq9LvD8qnkR4R3eqq4m58RTOvRGx7Tcc99MwSn2bIMpNpjWQK2ekpyhXQ+G4LWw==
X-Received: by 2002:a17:902:9693:b0:16b:d0d1:e16b with SMTP id n19-20020a170902969300b0016bd0d1e16bmr590410plp.69.1656729300423;
        Fri, 01 Jul 2022 19:35:00 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c09:ef3f:66d8:aaa3? ([2600:8802:b00:4a48:c09:ef3f:66d8:aaa3])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902780600b0016a4db13429sm16256370pll.192.2022.07.01.19.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 19:35:00 -0700 (PDT)
Message-ID: <b6b4e138-8a12-c80f-0cd3-1681605ac6ac@gmail.com>
Date:   Fri, 1 Jul 2022 19:34:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: Fw: [Bug 216195] New: Maxlinear GPY115 UBSAN: shift-out-of-bounds
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Joao.Pinto@synopsys.com
Cc:     netdev@vger.kernel.org
References: <20220701164506.78266ebe@hermes.local>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220701164506.78266ebe@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Intel folks, Joao,

On 7/1/2022 4:45 PM, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 01 Jul 2022 08:26:11 +0000
> From: bugzilla-daemon@kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 216195] New: Maxlinear GPY115 UBSAN: shift-out-of-bounds
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=216195
> 
>              Bug ID: 216195
>             Summary: Maxlinear GPY115 UBSAN: shift-out-of-bounds
>             Product: Networking
>             Version: 2.5
>      Kernel Version: 5.15-5.17
>            Hardware: Intel
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: normal
>            Priority: P1
>           Component: Other
>            Assignee: stephen@networkplumber.org
>            Reporter: cedric@bytespeed.nl
>          Regression: No
> 
> This is related to specific (wired) Ethernet IC: Maxlinear Ethernet GPY115B
> The network interface does show up in ifconfig but is not functioning, no
> ip-address is assigned.
> 
> During the bootup process I get the following warning:
> 
>      UBSAN: shift-out-of-bounds in
>      /build/linux-WLUive/linux-
>      5.15.0/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:224:12
>      Shift exponent 40 is too large for 32-bit type 'unsigned int'
> 
> This results in the following error:
> 
>      Maxlinear Ethernet GPY115B stmmac-3:01: gpy_config_aneg failed -110
> 
> The specific kernel I am running: 5.15.0-40-generic on Ubuntu but also tested
> this with Fedora Server 36 running kernel 5.17.
> Config: CONFIG_MAXLINEAR_GPHY=m
> The module is installed here:
> /usr/lib/modules/5.15.0-generic/kernel/drivers/net/phy/mxl-gpy.ko
> 
> Additional information:
> https://askubuntu.com/questions/1416068/how-to-enable-maxlinear-phy-gpy115-drivers
> 
> Datasheet:
> https://www.maxlinear.com/product/connectivity/wired/ethernet/ethernet-transceivers-phy/gpy115
> 

I do not know how or if the undefined behavior relates to the Ethernet 
PHY driver reporting a -ETIMEDOUT during auto-negotiation however the 
undefined behavior looks legit to me. Line 224 is:

value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);

with:

#define MTL_RXQ_DMA_QXMDMACH(chan, q)  ((chan) << (8 * (q)))

So for the shift to exceed 32-bits we would need q to be >=4, or q = 3 
and chan >= 256, more on that below. The report does not indicate which 
platform is used but googling around shows this askubuntu bug report 
from the same person:

https://askubuntu.com/questions/1416068/how-to-enable-maxlinear-phy-gpy115-drivers

and indicates that the platform is an Onlogic HX310 which is Intel 
Elkhart SoC. This means that dwmac-intel.c is likely the glue driver 
being used for registration and there we have several paths through 
which plat->rx_queues_to_use is used as an iterator to initialize 
plat->rx_queues_cfg[i].chan = i.

Given there can be 1, 6 or 8 RX queues according to that file, then the 
latter 2 combinations will trigger undefined behaviors by shifting too 
much to the left.

Not having access to the DMWAC4 datasheet however I do not know how to 
fix it.

Fixes tag for that bug would be:

Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")
-- 
Florian
