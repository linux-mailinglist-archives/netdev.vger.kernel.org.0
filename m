Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C85EF6B0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 08:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbfKEH6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 02:58:14 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32968 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388032AbfKEH6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 02:58:14 -0500
Received: by mail-lj1-f195.google.com with SMTP id t5so20686354ljk.0
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 23:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M0wxXarYwGq77xR0cg46b8aXGRRcSnoyv1t4jCG/d4U=;
        b=eSumxHPcOiFl7VhO3WyGBPumPC/v4Gc1aGiHdrzRvyYQ0qesyHB2lYFxyO/Qcinafd
         OzWa6Nabin/RC1XmJ2LaCrRvgbJ3xtONiPrXIcWCXFrtGGNtSY0XcVdgTyglQhj3Mx5V
         u/zy3LBOF37tj0eEzKQC2dej4Wp8Nvlx7IZRdqfYdZAzgwJdaKUIn/5zFIx7hfUrbDWz
         K4ZKtASudEh1ehCqFcnD52++70ap+jkvZDUlEAwJTkd8sp6XPG+oKtUJKCzNJjhX8OIR
         AHeITDXH8JIWVFpw3mfIygK43KkFEIR6tLl+KPIVeDMAFNtaGCBpIxQGC2ytJ30z/Z1q
         ZtRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M0wxXarYwGq77xR0cg46b8aXGRRcSnoyv1t4jCG/d4U=;
        b=qSfsW49jyh1GYvS/aiFEsaUsc4PdldKgVv6sSTSIm+3FrZ/eTe71aNBvWBhjIfyn9e
         HdzS6/jVngZybiMZGaKw/sazmmIWW1x7Qe6bde+zGwmyRnmduiwqNuIfIiXo7LJMcQB0
         OyAerSuEosujuBYzmqI3yyZ1rR7g8mAGFXQ8nwFMq0QqEX6QM/T29WQT/TsPdr7aDVpy
         fHqaw42XU57m5m3Ht8yxPaQO0QMBiO70bVjHpk5zMGgtpA6g1s61J7flq90KEfDEzJWS
         hEK/hNXumYRqyUlB7WBvmwr60DRCmISnedzR+qcYyd8Uv/ZIhTC+rATyBSdtMcvMETgZ
         1UdA==
X-Gm-Message-State: APjAAAWxnpP+XVQFaq2GqJqDN51AN5bT2WzYANcWenscE+RZrcvaRJrl
        PHr9DrKwLqqbVsHFdHlOq9FyVSKs6WKOdLV+3sftTA==
X-Google-Smtp-Source: APXvYqwItRlN33Dc1rOEb3W8JxKhUBQReYULMFvISIZF6rJ0IO/3DGEZL5QxrgAUTcdO4Qxg1RzQsi4ARYRhodTeuvM=
X-Received: by 2002:a2e:9a5a:: with SMTP id k26mr12064510ljj.46.1572940692487;
 Mon, 04 Nov 2019 23:58:12 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYsWTFQZTHXUDPToaepnKGBoh61SsA_8SHcYgYZXN_L+mg@mail.gmail.com>
 <CA+G9fYu+6A3pYQGs2rydYtHNSCf1t9+OTRqrZeCbpc2ARLx2zA@mail.gmail.com> <20191105073459.GB2588562@kroah.com>
In-Reply-To: <20191105073459.GB2588562@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Nov 2019 13:28:01 +0530
Message-ID: <CA+G9fYvau-CY8eeXM=atzQBjYbmUPg78MXu_GNjCyKDkW_CcVQ@mail.gmail.com>
Subject: Re: stable-rc-5.3.9-rc1: regressions detected - remove_proc_entry:
 removing non-empty directory 'net/dev_snmp6', leaking at least 'lo'
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Dan Rue <dan.rue@linaro.org>, LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>, chrubis <chrubis@suse.cz>,
        mmarhefk@redhat.com, Netdev <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>, maheshb@google.com,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 at 13:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> > > Linux stable rc 5.3 branch running LTP reported following test failures.
> > > While investigating these failures I have found this kernel warning
> > > from boot console.
> > > Please find detailed LTP output log in the bottom of this email.
> > >
> > > List of regression test cases:
> > >   ltp-containers-tests:
> > >     * netns_breakns_ip_ipv6_ioctl
<trim>
> > >     * netns_comm_ns_exec_ipv6_netlink
> >
> > These reported failures got fixed on latest stable-rc 5.3.y after
> > dropping a patch [1].
>
> What is the subject of the patch?

blackhole_netdev: fix syzkaller reported issue
upstream commit b0818f80c8c1bc215bba276bd61c216014fab23b

>
> > The kernel warning is also gone now.
> >
> > metadata:
> >   git branch: linux-5.3.y
> >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >   git commit: 75c9913bbf6e9e64cb669236571e6af45cddfd68
>
> The -rc tree is rebased all the time, can I get a "real" subject line to
> get a chance to figure out what you are trying to refer to here?

Linux 5.3.9-rc1 is good candidate on branch linux-5.3.y and
linux-stable-rc tree.

>
> > ref:
> > [PATCH AUTOSEL 5.3 12/33] blackhole_netdev: fix syzkaller reported issue
> > [1] https://lkml.org/lkml/2019/10/25/794
>
> lore.kernel.org is much more reliable :)

Thank you.

[ Sasha Levin <sashal@kernel.org>  wrote on Mon, 4 Nov 2019 12:13:45 -0500 ]
I've dropped this patch from 5.3 too, it was reverted upstream.
https://lore.kernel.org/netdev/20191104171345.GG4787@sasha-vm/

Ref:

Reverting below patch fixed this problem.
---
commit b0818f80c8c1bc215bba276bd61c216014fab23b
Author: Mahesh Bandewar <maheshb@google.com>
Date:   Fri Oct 11 18:14:55 2019 -0700

    blackhole_netdev: fix syzkaller reported issue

    While invalidating the dst, we assign backhole_netdev instead of
    loopback device. However, this device does not have idev pointer
    and hence no ip6_ptr even if IPv6 is enabled. Possibly this has
    triggered the syzbot reported crash.

    The syzbot report does not have reproducer, however, this is the
    only device that doesn't have matching idev created.

    Crash instruction is :

    static inline bool ip6_ignore_linkdown(const struct net_device *dev)
    {
            const struct inet6_dev *idev = __in6_dev_get(dev);

            return !!idev->cnf.ignore_routes_with_linkdown; <= crash
    }

    Also ipv6 always assumes presence of idev and never checks for it
    being NULL (as does the above referenced code). So adding a idev
    for the blackhole_netdev to avoid this class of crashes in the future.

    Signed-off-by: David S. Miller <davem@davemloft.net>
