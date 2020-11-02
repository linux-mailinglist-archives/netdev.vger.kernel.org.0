Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903092A2B59
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgKBNVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKBNVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:21:15 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C02C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 05:21:15 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id bl9so6048299qvb.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 05:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DVPMONE8Y4TLXNPQgjWP9zcPgmTd7J7LYcUGnyg1Tek=;
        b=rUvJkhd+RK6kjRMfnLexKkopTV/FAFvW7V4vJvBF4ssISQEwxNmX0m4W1tuBu2nsxU
         Ae5cT+A5kXTiYBG4HhVeTSO4XnvsGMzz/zKGKX0ZK1AUofiLD0fbEqCquyGAA4lRo3NN
         xlKFTwqc8Ew77nYlKiTFEDG1+QQ+1jB3XZsZF8CJqV/Q6i0e6UNgLweJj+pwPb3GvWcl
         mmQt6GIXvwOclR/E+Kqca3DPkAHTfW+ZnRV8OoPcN+GvU0pqzYW+2HhOgsONxQcLCU6m
         d0ZNSx3Z/CEeP4wXm+1ozasYuqa148BQ6UTE1UPdSflpq8Xr5NfAsp7gEfjnKA6rFBgv
         fZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DVPMONE8Y4TLXNPQgjWP9zcPgmTd7J7LYcUGnyg1Tek=;
        b=d5/mJu9DxtIonKjChUXsm8clq3TwFvGhWnOcOE0bcz8B9IWb6gfLPbYJTEUSoBivjH
         N5zzwmOWUJ59xdTidmSF2PliaAyETQ+wkQ16TMBHNG2Eg2DKxoa/QocVOmNaHT5PiZqE
         eCkHS0vuDlUS+JbjELgmyhxE5H3YOGbB7jNQrnozEI1W7qKKI4nxcwPA8ew50O/84fPX
         23rM2QAv48Ug7c+IwttiEq1Kma97oQ/1d2vJCGVAmhCQNc4CkO0AHHA8t955zWh4RMdp
         73ZsSUgNkbGBschqBz3btRt8NvyoIkO1qXUeIpsxUy4FZvAa8JevIDGWekU5QfgfCghu
         heaw==
X-Gm-Message-State: AOAM533SZLkuTPaHQwrx3oCrlZ42U1+ioGVW7bPSopIBPVFmHd5MYv/O
        6dz3kmPb1TyhDRbBAjHPJFaDVrDy1dDUj4bZqKY=
X-Google-Smtp-Source: ABdhPJzlm6i6ut9QIx5U/D8UzBkNTdUwSAYTf4U2lDnVF3UAaksI6BBpwM4PPqw8SDuYT8S2K2dj+4XklI7GrglS1lw=
X-Received: by 2002:a05:6214:136f:: with SMTP id c15mr21822021qvw.57.1604323274411;
 Mon, 02 Nov 2020 05:21:14 -0800 (PST)
MIME-Version: 1.0
References: <CAOKSTBtcsqFZTzvgF-HQGRmvcd=Qanq7r2PREB2qGmnSQZJ_-A@mail.gmail.com>
 <CAOKSTBuRw-H2VbADd6b0dw=cLBz+wwOCc7Bwz_pGve6_XHrqfw@mail.gmail.com> <c743770c-93a4-ad72-c883-faa0df4fa372@gmail.com>
In-Reply-To: <c743770c-93a4-ad72-c883-faa0df4fa372@gmail.com>
From:   Gilberto Nunes <gilberto.nunes32@gmail.com>
Date:   Mon, 2 Nov 2020 10:20:37 -0300
Message-ID: <CAOKSTBuP0+jjmSYNwi3RB=VYROVY08+DOqnu8=YL5zTgy-RnDw@mail.gmail.com>
Subject: Re: Fwd: Problem with r8169 module
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

ethtool using 5.4

ethtool enp1s0f1
Settings for enp1s0f1:
       Supported ports: [ TP MII ]
       Supported link modes:   10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Supported pause frame use: Symmetric Receive-only
       Supports auto-negotiation: Yes
       Supported FEC modes: Not reported
       Advertised link modes:  10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Advertised pause frame use: Symmetric Receive-only
       Advertised auto-negotiation: Yes
       Advertised FEC modes: Not reported
       Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                            100baseT/Half 100baseT/Full
                                            1000baseT/Half 1000baseT/Full
       Link partner advertised pause frame use: Symmetric Receive-only
       Link partner advertised auto-negotiation: Yes
       Link partner advertised FEC modes: Not reported
       Speed: 1000Mb/s
       Duplex: Full
       Port: MII
       PHYAD: 0
       Transceiver: internal
       Auto-negotiation: on
       Supports Wake-on: pumbg
       Wake-on: d
       Current message level: 0x00000033 (51)
                              drv probe ifdown ifup
       Link detected: yes

ethtool using 5.9
ethtool enp1s0f1
Settings for enp1s0f1:
       Supported ports: [ TP MII ]
       Supported link modes:   10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Supported pause frame use: Symmetric Receive-only
       Supports auto-negotiation: Yes
       Supported FEC modes: Not reported
       Advertised link modes:  10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Advertised pause frame use: Symmetric Receive-only
       Advertised auto-negotiation: Yes
       Advertised FEC modes: Not reported
       Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                            100baseT/Half 100baseT/Full
                                            1000baseT/Half 1000baseT/Full
       Link partner advertised pause frame use: Symmetric Receive-only
       Link partner advertised auto-negotiation: Yes
       Link partner advertised FEC modes: Not reported
       Speed: 100Mb/s
       Duplex: Full
       Port: MII
       PHYAD: 0
       Transceiver: internal
       Auto-negotiation: on
       Supports Wake-on: pumbg
       Wake-on: d
       Current message level: 0x00000033 (51)
                              drv probe ifdown ifup
       Link detected: yes

ethtool in 5.9.3

ethtool enp1s0f1
Settings for enp1s0f1:
       Supported ports: [ TP MII ]
       Supported link modes:   10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Supported pause frame use: Symmetric Receive-only
       Supports auto-negotiation: Yes
       Supported FEC modes: Not reported
       Advertised link modes:  10baseT/Half 10baseT/Full
                               100baseT/Half 100baseT/Full
                               1000baseT/Full
       Advertised pause frame use: Symmetric Receive-only
       Advertised auto-negotiation: Yes
       Advertised FEC modes: Not reported
       Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                            100baseT/Half 100baseT/Full
                                            1000baseT/Half 1000baseT/Full
       Link partner advertised pause frame use: Symmetric Receive-only
       Link partner advertised auto-negotiation: Yes
       Link partner advertised FEC modes: Not reported
       Speed: 100Mb/s
       Duplex: Full
       Port: MII
       PHYAD: 0
       Transceiver: internal
       Auto-negotiation: on
       Supports Wake-on: pumbg
       Wake-on: d


In 5.9 the downshift occurs right away when I turn the laptop on.

5.4 dmesg
https://pastebin.pl/view/3eb41a4b

5.9.3 dmesg
https://pastebin.pl/view/c07f6c22

---
Gilberto Nunes Ferreira




Em seg., 2 de nov. de 2020 =C3=A0s 05:14, Heiner Kallweit
<hkallweit1@gmail.com> escreveu:
>
> On 02.11.2020 04:36, Gilberto Nunes wrote:
> > Hi there
> >
> > I am in trouble when using newer kernels than 5.4.x regarding Realtek N=
IC r8169
> >
> > Kernel 5.9.2-050902-lowlatency (from
> > https://kernel.ubuntu.com/~kernel-ppa/mainline/ and also compiled from
> > kernel.org)
> >
> > Generic FE-GE Realtek PHY r8169-101:00: Downshift occurred from
> > negotiated speed 1Gbps to actual speed 100Mbps, check cabling!
> > r8169 0000:01:00.1 enp1s0f1: Link is Up - 100Mbps/Full (downshifted) -
> > flow control rx/tx
> >
> > Kernel 5.4.73-050473-lowlatency (from
> > https://kernel.ubuntu.com/~kernel-ppa/mainline/)
> >
> > IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0f1: link becomes ready
> > r8169 0000:01:00.1 enp1s0f1: Link is Up - 1Gbps/Full - flow control rx/=
tx
> >
> > Cable is ok! I double check it....
> >
> The downshift hint didn't exist yet in 5.4. Can you check what the actual
> link speed is under 5.4 (e.g. using iperf3).
>
> Under 5.9:
> Does the downshift happen directly when the link is initially established=
,
> or after some time?
>
> If link speed actually differs, then please:
> - provide full dmesg log
> - ideally do a git bisect to find the offending commit
>   (as issue most likely is chip version / system dependent)
>
> >
> >
> >
> >
> > ---
> > Gilberto Nunes Ferreira
> >
>
