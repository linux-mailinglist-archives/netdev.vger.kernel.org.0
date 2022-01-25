Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB1A49BFC6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiAYX4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235010AbiAYX4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:56:23 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112E5C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:56:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id h12so21574569pjq.3
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FSBNDNh12l2ong7g4Z5F8GEP/PObr0GN/KsPS68OYuQ=;
        b=WlYYTN1A+ZGxyFL2SwGc83zM+RcyWxgBFwdKrXi1MdLmLgo9p7KF7wDgmIrXCio75e
         lDhP8Z4qCoJBDtVDTi/vRoQljg02if5CZvkw7PlvmfiSkRuyutwD88hzmnSKZOibvL8n
         B7YZwmB1TuBtPAFldDBsyfogP5c38aXlfBgsn6L1Sdl/L0ntOPlL9mth1lAZQUPTXA4V
         5jtaFI4Jy+zASGd7KoC9KLbLfooS3QtplbrU2qDiHrySyePf+I2RUFHdvZbmFxL9b+UI
         CFV5gp5+XgYOhIcHrn+w9DYbzBRiMzDNcGh2dSoea4dSfFw4XRSEWFCFnAd5Lxptklg5
         PU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FSBNDNh12l2ong7g4Z5F8GEP/PObr0GN/KsPS68OYuQ=;
        b=l4QxR8/qUt0M6dYsQ/Nqiwp4WVL6KyE4AiWLSuSO3bWx51PJYxf/Jd3QcPeq+ltaPh
         MkJXb5iQpDxa83ABWJUKSOsoOHAByq+Parx5xy79g0uItVeaVvApoeQ6RzmMomSs0Rtn
         bcMiPu40/I4gDOq0SqiH1qXD8nxZpBC3RkpbYLtwC/iZ78yvNKQx8W6pJ2zfUdz58vth
         XQk+qGBjtk5LZpf8pgrcS0yriqSd3ffr5fYmgcaqsut7aoUlpVWSyVw9I1L1hyOG9Toa
         czmNTsi71TgtRCofcIssJe0otXzxWxCkk7db6lcRKTGIz2mTmjEiNx30T7sKNx7+HQVx
         SR6w==
X-Gm-Message-State: AOAM530RAQqWwiuO5A4h3FBOZZ/xQu3j0eTmkglIjEJEi93wFD+yT8RL
        ztUrCRkEkLVUFEAiga0FsByCM+bdqsY=
X-Google-Smtp-Source: ABdhPJy9xVQQ3e+HTjNd+j82aRN0inVkB/hteZjhdKLlnN2HpWLUeYzC7E6BqsDPST1783ZIc4SJdA==
X-Received: by 2002:a17:90a:94c2:: with SMTP id j2mr5906872pjw.63.1643154982540;
        Tue, 25 Jan 2022 15:56:22 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b5sm15532415pgl.22.2022.01.25.15.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 15:56:21 -0800 (PST)
Message-ID: <ae29e4cc-c66c-ea29-b93f-c9c35d64dd66@gmail.com>
Date:   Tue, 25 Jan 2022 15:56:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
References: <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf>
 <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124190845.md3m2wzu7jx4xtpr@skbuf>
 <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124205607.kugsccikzgmbdgmf@skbuf>
 <20220124134242.595fd728@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124223053.gpeonw6f34icwsht@skbuf>
 <CAJq09z5JF71kFKxF860RCXPvofhitaPe7ES4UTMeEVO8LH=PoA@mail.gmail.com>
 <20220125094742.nkxgv4r2fetpko7r@skbuf>
 <CAJq09z4OC4OijWT8=-=vXRQhqFsaP0+asXyO69i37aj39DMB6A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJq09z4OC4OijWT8=-=vXRQhqFsaP0+asXyO69i37aj39DMB6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2022 2:29 PM, Luiz Angelo Daros de Luca wrote:
>> Could you implement a prototype of packet parsing in ndo_features_check,
>> which checks for the known DSA EtherType and clears the offload bit for
>> unsupported packets, and do some performance testing before and after,
>> to lean the argument in your favor with some numbers? I've no problem if
>> you test for the worst case, i.e. line rate with small UDP packets
>> encapsulated with the known (offload-capable) DSA tag format, where
>> there is little benefit for offloading TX checksumming.
> 
> There is no way to tell if a packet has a DSA tag only by parsing its
> content. For Realtek and Marvel EDSA, there is a distinct ethertype
> (although Marvel EDSA uses a non-registered number) that drivers can
> check. For others, specially those that add the tag before the
> ethernet header or after the payload, it might not have a magic
> number. It is impossible to securely identify if and which DSA is in
> use for some DSA tags from the packet alone. This is also the case for
> mediatek. Although it places its tag just before ethertype (like
> Realtek and Marvel), there is no magic number. It needs some context
> to know what type of DSA was applied.

Looking at mtk_eth_soc.h TX_DMA_CHKSUM is 0x7 << 29 so we set 3 bits 
there, which makes me think that either we defined too many bits, or 
some of those bits have a compounded meaning. The rest of the bits do 
not seem to be defined, so maybe there is a programmable offset where to 
calculate the checksum from and deposit it. Is there a public 
programmable manual?

> 
> skb_buf today knows nothing about the added DSA tag. Although
> net_device does know if it is a master port in a dsa tree, and it has
> a default dsa tag, with multiple switches using different tags, it
> cannot tell which dsa tag was added to that packet.
> That is the information I need to test if that tag is supported or not
> by this drive.
> 
> I believe once an offload HW can digest a dsa tag, it might support
> the same type of protocols with or without the tag.
> In the end, what really matters is if a driver supports a specific dsa tag.

To be honest, I am not sure if we need to know about the specific 
details of the tag like is it Realtek, Broadcom, Mediatek, QCA, more 
than knowing whether the L3/L4 offsets will be at "expected" locations. 
By that I mean, located at 14 bytes from the start of the frame for IP 
without VLAN , and 18 bytes with VLAN, did we "stack" switch tags on top 
of another thus moving by another X bytes etc.

> 
> Wouldn't it be much easier to have a dedicated optional
> ndo_dsa_tag_supported()? It would be only needed for those drivers
> that still use NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and only those that
> can digest a tag.

I don't think we need to invent something new, we "just" need to tell 
the DSA conduit interface what type of switch tagger it is attached to 
and where it is in the Ethernet frame. Once we do that, the DSA conduit 
ought to be able to strip out features statically, or dynamically via 
ndo_features_check().
-- 
Florian
