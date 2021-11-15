Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B4A450D5A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbhKORyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238916AbhKORwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:52:44 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD316C0A8890;
        Mon, 15 Nov 2021 09:27:06 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id iq11so13440633pjb.3;
        Mon, 15 Nov 2021 09:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MTplP5x3igISERaVQs+hIMgLuqZSlQ4Kja2MmpsBHAg=;
        b=XEesiEVEHvHPl3zz61+KH76/lHBYqWLtuRbcxXYCqzA6IQc3RAlIGyXVf6Y9sogUOP
         VLJNhKHIq09yEI7hj28ed90T9anjGeFSAMPiiL5iHS+qngUXuYMy96gJOrVy46jQJL+t
         vEHYXYWWvs03BH3Ac8tBYPO2gKWGVlOJHVp1TFWQ64E5YAoSC5NYj1LKDrgg4C3DlEuV
         rrWP2HQZbsEMvii43atUgOPEFozNKTPjRjYoWQ7T6bLY1gM72BmZFES8KE0D4tuOwSq8
         M6SfY6Kdq1oZ0GnETyHfvxR1aS1MVrdwknGA/w2mV2ImGEIP4RLd+c3/LO/OEb7QbPiQ
         6iFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MTplP5x3igISERaVQs+hIMgLuqZSlQ4Kja2MmpsBHAg=;
        b=VNHrsHlbAiVjouv10QxfdoHqQzMEKA8j5fipAlrKOGaLMPY7I763qvPDCIIvefqaPO
         2aP1u27F3NgZLfpVDmYwvOJM6X7ftokeNIvJh++yxlq7E8N2xbPxtzZZfggRkc9qo5li
         COhTCTi/DScLpXrhk6qKJnaOGbO8X6WqHOVkfRE9NHXYNBBgDz9e6nRGW/y/nr40xJ4+
         v4t0OOP8weqdDCesNPz2Mo7nMeGSDRJX+X2obl4p3ZhVmNhCSgrsbNyBukw26cYNkYU8
         I/qZX0LI2gZjprxnWUBNBywavH2F0dHl2a+NqS5MPpaLIScyWfrWMzkc9xuhsLveoRim
         1c+Q==
X-Gm-Message-State: AOAM53031Nw+npclgvkpkr6Rbem6Tei/NioggVATPLuSk0PyiuKudnUP
        Ojp8jnkI4DGVZBpPHQszVBw=
X-Google-Smtp-Source: ABdhPJxOdNEmuNutKJ8PiqRLJaeXrrFp6pWlZCD8dzOqYvJkjrqKPN/vRoOqkrsbfgXlSFVwngw0FQ==
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr246408pjb.190.1636997226093;
        Mon, 15 Nov 2021 09:27:06 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id a29sm15467251pfh.29.2021.11.15.09.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:27:05 -0800 (PST)
Date:   Mon, 15 Nov 2021 22:57:03 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ast@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>
Subject: Re: "resolve_btfids: unresolved" warnings while building v5.16-rc1
Message-ID: <20211115172703.hgsuukifbji6khln@apollo.localdomain>
References: <1b99ae14-abb4-d18f-cc6a-d7e523b25542@gmail.com>
 <20211115141735.o4reo2jruu73a2vf@apollo.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115141735.o4reo2jruu73a2vf@apollo.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 07:47:35PM IST, Kumar Kartikeya Dwivedi wrote:
> On Mon, Nov 15, 2021 at 07:04:51PM IST, Pavel Skripkin wrote:
> > Hi, net/bpf developers!
> >
> > While building newest kernel for fuzzing I met following warnings:
> >
> > ```
> >   BTFIDS  vmlinux
> > WARN: resolve_btfids: unresolved symbol tcp_dctcp_kfunc_ids
> > WARN: resolve_btfids: unresolved symbol tcp_cubic_kfunc_ids
> > WARN: resolve_btfids: unresolved symbol tcp_bbr_kfunc_ids
> >   SORTTAB vmlinux
> >
> > ```

+Cc Andrii

So the reason should be CONFIG_DYNAMIC_FTRACE=n, when that is turned off,
all these three BTF sets should be empty. Earlier they were all part of the
set in bpf_tcp_ca.c, which would never be empty, so there was no warning.

I guess we can demote that warning to debug, but not sure, since it isn't
limited to BTF sets, but also other symbols (e.g. kernel functions referenced in
.BTF_ids).

The other option is to add a dummy function in the set so that set->cnt != 0.

> >
> > I haven't seen such warnings before and have no idea are they important or
> > not. Config is attached.
> >
> > My host is openSUSE Tumbleweed with gcc (SUSE Linux) 10.3.1 20210707
> > [revision 048117e16c77f82598fca9af585500572d46ad73] if it's important :)
> >
> >
>
> I'll take a look later today.
>
> >
> > With regards,
> > Pavel Skripkin
>
> --
> Kartikeya

--
Kartikeya
