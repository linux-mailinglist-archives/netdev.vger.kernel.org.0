Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3085625679
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 19:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfEURTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 13:19:33 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:44375 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbfEURTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 13:19:33 -0400
Received: by mail-wr1-f47.google.com with SMTP id w13so8762214wru.11;
        Tue, 21 May 2019 10:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yYiHtVzcH8+oDGrOjuw5R5rU8RKAgIeX4CeODaqMJ4M=;
        b=Ne1dIIi/0NUT85wJNtonUyHl7lOCxJtd0M/+g1UBlqjatV1IeLCMN1VCpXmG4JsZ5B
         E13dUwtvDZ8FFVJ5AbdS/WsDhWo/GU6k1TlMsVhZlzwuT+r3oFF7ZvUOdQ3BpZekYrMT
         twb0Pvz+dxUP05Ocy3R/Iq32WgSWnfCsqHJsENgOL8A7EirNVXdhio8yXKwG9XNzC5uA
         aMgZiDXl5z+aJrH2tvFfHtHwiZLNXF+eiGKTaMRnb6z681x19MOZf4Lg5wgffftGXsbd
         cJ+katGXHU8YIygETdHBkyn4fDXW2IKSxBFBpNbntbkFi+A0COZ/1462kYnz2MpiBauB
         pHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yYiHtVzcH8+oDGrOjuw5R5rU8RKAgIeX4CeODaqMJ4M=;
        b=ktgS2kUcPg97NsMTif1KNiv/NnfHBMFWu/9oAqZt+TuzhxSCN1KYldJt2WxmwsFwrI
         Ilxbgj/d3U4V6mm7yCrBwzBQ2X5X510GkHjQJ6Ag9muflsxFmommWDL0ABjLOZysNNma
         Kc6FRpwGVCv/B4rG44M52A0HUPz9/dXNh1XmvO/aFNNv1YtKvKbNFB9vPzaeABoodyG1
         MupUnMTbyyszZTbJrZRueDkDq+LE0oujSzSBNiLIL00okQp3KBfoZYLvmMU0dQcXQ4Z5
         G1JXYMwU0UJUAnWq0SGYPCvqrNLbb8fWsP8WgJGL3dIEt8hCQ+wrOpjVXrTnVm8XVlaw
         V2iA==
X-Gm-Message-State: APjAAAUiVPvFvf3pxyT2VHMzpc8l34OEqbWbYdjKicoCzyIB1m6H3gku
        dUlo/Vfe3VQ88u6OSCTkjOWgJAdL
X-Google-Smtp-Source: APXvYqzsYPlXykNQpbVcHvP5WWk5i31JjYltp2INleEpH+vZ/zblSkXrN30+FD87y0uQbGjndN3PWA==
X-Received: by 2002:adf:c601:: with SMTP id n1mr46010087wrg.49.1558459170867;
        Tue, 21 May 2019 10:19:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:305e:9966:b713:e8fc? (p200300EA8BD45700305E9966B713E8FC.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:305e:9966:b713:e8fc])
        by smtp.googlemail.com with ESMTPSA id t7sm27923253wrq.76.2019.05.21.10.19.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 10:19:29 -0700 (PDT)
Subject: Re: net: phy: improve pause mode reporting in phy_print_status
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <git-mailbomb-linux-master-23bfaa594002f4bba085e0a1ae3c9847b988d816@kernel.org>
 <CAMuHMdXH4A96CUuSkmnL8RVubRyd9eswz9VPqBsDqXGbNCWncw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ca30d4db-628b-f70f-5849-1b1fcbc44ad9@gmail.com>
Date:   Tue, 21 May 2019 19:19:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXH4A96CUuSkmnL8RVubRyd9eswz9VPqBsDqXGbNCWncw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.05.2019 15:07, Geert Uytterhoeven wrote:
> Hi Heiner,
> 
Hi Geert,

> On Wed, May 8, 2019 at 8:02 AM Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> Commit:     23bfaa594002f4bba085e0a1ae3c9847b988d816
>> Parent:     5db9c74042e3c2168b1f1104d691063f5b662a8b
>> Refname:    refs/heads/master
>> Web:        https://git.kernel.org/torvalds/c/23bfaa594002f4bba085e0a1ae3c9847b988d816
>> Author:     Heiner Kallweit <hkallweit1@gmail.com>
>> AuthorDate: Sun May 5 19:03:51 2019 +0200
>> Committer:  David S. Miller <davem@davemloft.net>
>> CommitDate: Tue May 7 12:40:39 2019 -0700
>>
>>     net: phy: improve pause mode reporting in phy_print_status
>>
>>     So far we report symmetric pause only, and we don't consider the local
>>     pause capabilities. Let's properly consider local and remote
>>     capabilities, and report also asymmetric pause.
>>
>>     Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Due to this commit, I see the folllowing change on Renesas development
> boards using either the sh_eth or ravb Ethernet driver:
> 
>     -sh-eth ee700000.ethernet eth0: Link is Up - 100Mbps/Full - flow
> control rx/tx
>     +sh-eth ee700000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
> 
> and
> 
>     -ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>     +ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> 
> Adding debug prints reveals that:
> 
>     phydev->autoneg = 1
>     phydev->pause = 1
>     phydev->asym_pause = 0 or 1 (depending on the board)
>     local_pause = 0
>     local_asym_pause = 0
> 
> Is this expected behavior?
> 
Yes. Both local pause parameters being 0 means no pause support is advertised.
Seems like both network drivers miss calls to phy_support_sym_pause or
phy_support_asym_pause respectively to indicate if and which pause modes
the MAC supports.
Before this patch only the remote pause capability was considered.

> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
Heiner
