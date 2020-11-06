Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758C42A9CC7
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgKFS6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFS6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 13:58:44 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A886C0613CF;
        Fri,  6 Nov 2020 10:58:44 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b1so3331810lfp.11;
        Fri, 06 Nov 2020 10:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tuA+B6GqLZERItqqoDaOIJ0JH2dxClC2hdQn1kAzRoI=;
        b=ERtjIyIcmYFyKcqyCl/rDk5LrIYJUr3+cdAsz53AJEcLy0UC/T9TC/W15gh/n5Ygab
         +uSY7H5tMRuSJnF2pNdfF/Dv1etzZ+VsMPZvfIgcvnh4mRON+gTgPb5Tc0gcTnAzvXuW
         ZroXY0b/CVg09sfY1QJiUdXWjHE461wE0kX5iRXbqBty+UX+FBZNn5YpRlwMeoEkcmBM
         o6TRP5xyxwnDll3M3E2PKpH9I1Ft70tjhLr0UuTUjkXYXXvoG/xhcLg88Y8AGsrC8ggz
         n5WQJvBcTsrebEf08GpLDC/d7gDn/0CmSIMDxouMb4DhABKsch1x4yW1o9lMc2Vo3AxD
         +IWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tuA+B6GqLZERItqqoDaOIJ0JH2dxClC2hdQn1kAzRoI=;
        b=sIHmUvXRGmFX5aCkahgZklHoSkBq0SNoicE/tllks5IMB43cyyOPbd8jNeDny+SeCX
         lL0lRgbihxQ/hzrFmedzmL3HRZMGZuG5spgeOfldFwnLKG5FftMEgCHr12MF3b7vaiDc
         OQB8wZjLc2+ZyIpBeTKBB+wZIB5OwUlXHhXEsYFgmKi27LxgNiy3lpeGPfMJEq6nMgvN
         rCSWvj5NZbBBIkY7QUu9k4pqwmp9keMMCGL629KyY2KWj+dbWto572Er8kgI5231c6Tk
         CMW+6QPPx8wTDFvGWlcHDqoNEbIpmXYTDGplU2+dp9JlUm8AUndEqfPPIXYr7ovl6T9y
         Ef8A==
X-Gm-Message-State: AOAM5321bPnCEacuCRoeQnxkrATX34+ieJGbvLPmKCmUh4/ZogfqhlrT
        LX88fBQD3G1rbv/a8xeHNMbNLvjd0pJN6RVyfSc=
X-Google-Smtp-Source: ABdhPJx50MKHs6klorI5liJbCSQwzAWB5FBar+Nr3DIk76z+xiODjK/7yZGZL5lxI9Q0uV4VkQNZ7UsgBUBZIql8aFk=
X-Received: by 2002:a19:6912:: with SMTP id e18mr1327239lfc.196.1604689122702;
 Fri, 06 Nov 2020 10:58:42 -0800 (PST)
MIME-Version: 1.0
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201106090117.3755588-1-liuhangbin@gmail.com> <20201106105554.02a3142b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106105554.02a3142b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 6 Nov 2020 10:58:30 -0800
Message-ID: <CAADnVQLEMLwNUYwboYah+H6uR9JU=GLgem9-kF1Ut0x_VJjWRA@mail.gmail.com>
Subject: Re: [PATCHv2 net 0/2] Remove unused test_ipip.sh test and add missed
 ip6ip6 test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 10:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  6 Nov 2020 17:01:15 +0800 Hangbin Liu wrote:
> > In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
> > ip6ip6 test") we added some bpf tunnel tests. In commit 933a741e3b82
> > ("selftests/bpf: bpf tunnel test.") when we moved it to the current
> > folder, we missed some points:
> >
> > 1. ip6ip6 test is not added
> > 2. forgot to remove test_ipip.sh in sample folder
> > 3. TCP test code is not removed in test_tunnel_kern.c
> >
> > In this patch set I add back ip6ip6 test and remove unused code. I'm not sure
> > if this should be net or net-next, so just set to net.
>
> I'm assuming you meant to tag this with the bpf tree.

Right. Thanks for headsup.
