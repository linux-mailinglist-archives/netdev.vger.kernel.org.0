Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05ABAEF465
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 05:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbfKEEOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 23:14:52 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45705 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfKEEOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 23:14:52 -0500
Received: by mail-lj1-f196.google.com with SMTP id n21so6511361ljg.12
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 20:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8KB+te/nLoebcMQPIFtuyG/ym5HSoU7PnWgKfaQPNOE=;
        b=gTNyTkL5COxLe6mqgrHi3rTaVdO7kVoZQp01mpmI55r12uEYKWt0QJBX1E1p6C7I/l
         btHxbM50pwDG3wpnQ4m55tveqmvQ1sU5LCVbxLPyjMIU9VEwz3awilFHSrwSMLMemOxD
         xZdsRRLzbw0IXm8mE+KQJgsw2PDAQsDawCM/GfZbY2Ngk2PT/DmZ5yMBSeOEhZhHnW3z
         MsxM4eyGrq/S5zZ0ni7q91iHMVNxC9hqketMuY6Htr4dFoOrStv+OUpYCQxCH05MM9VO
         uWtuu4oEU7pecgxvZXUb23Dg+KEIWLE9/QL+qmKP0blqSuXFGFdtZ9VDSzywwSQUClpW
         378g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8KB+te/nLoebcMQPIFtuyG/ym5HSoU7PnWgKfaQPNOE=;
        b=mmGuGnrOjoBEiEDHtt2gk01EyDY1egr2S0x2/gq9czaQhi1LOBUtU2eAT00jD9P0gl
         RTY91VZq21erCNEhSjU4GBLgDvjmDRqPXVFaExKFeGZaHJsh6b1akfgTvhcBMAS4w9nd
         5vKnVyOsbYQYbSOswNuzEq2Ja4SWslxwgHTeYVdnqglb6V0XSEswNhOAuLkVbFoOF7Le
         FihuCARy1QNEhAOMwacuNElF43Yb2Ri+RtM/2bh+G4c9fHye7q4LzW7goiM8JL3zanyv
         fCSXOIi27kZtq53jusW7zA/GZ6/zo8tnNISu2yvupqMqmt7/z3vz1CegZkn1O90BxQFL
         rC/A==
X-Gm-Message-State: APjAAAWFujaJau3xqtgkILqrJkvCQzOBZ14UVMmZUn6MdmoQI0MlawbQ
        xNzpLwrZU/S4cAVXq1XjX5MHfvhU+w72euePMipExd0JOhM=
X-Google-Smtp-Source: APXvYqzo8BCoI5pHogfN3mp2CXgLWA5a2xI0z1nWrz3rcFHdAQqHlzKc7jtT22WecxPiwuhFxoupOIdodhQEymY8ey0=
X-Received: by 2002:a2e:888a:: with SMTP id k10mr10715245lji.195.1572927290338;
 Mon, 04 Nov 2019 20:14:50 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYsWTFQZTHXUDPToaepnKGBoh61SsA_8SHcYgYZXN_L+mg@mail.gmail.com>
In-Reply-To: <CA+G9fYsWTFQZTHXUDPToaepnKGBoh61SsA_8SHcYgYZXN_L+mg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Nov 2019 09:44:39 +0530
Message-ID: <CA+G9fYu+6A3pYQGs2rydYtHNSCf1t9+OTRqrZeCbpc2ARLx2zA@mail.gmail.com>
Subject: Re: stable-rc-5.3.9-rc1: regressions detected - remove_proc_entry:
 removing non-empty directory 'net/dev_snmp6', leaking at least 'lo'
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkft-triage@lists.linaro.org, Dan Rue <dan.rue@linaro.org>,
        LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>, chrubis <chrubis@suse.cz>,
        mmarhefk@redhat.com, Netdev <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha and Greg,

On Mon, 4 Nov 2019 at 20:59, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Linux stable rc 5.3 branch running LTP reported following test failures.
> While investigating these failures I have found this kernel warning
> from boot console.
> Please find detailed LTP output log in the bottom of this email.
>
> List of regression test cases:
>   ltp-containers-tests:
>     * netns_breakns_ip_ipv6_ioctl
>     * netns_breakns_ip_ipv6_netlink
>     * netns_breakns_ns_exec_ipv6_ioctl
>     * netns_breakns_ns_exec_ipv6_netlink
>     * netns_comm_ip_ipv6_ioctl
>     * netns_comm_ip_ipv6_netlink
>     * netns_comm_ns_exec_ipv6_ioctl
>     * netns_comm_ns_exec_ipv6_netlink

These reported failures got fixed on latest stable-rc 5.3.y after
dropping a patch [1].
The kernel warning is also gone now.

metadata:
  git branch: linux-5.3.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: 75c9913bbf6e9e64cb669236571e6af45cddfd68

ref:
[PATCH AUTOSEL 5.3 12/33] blackhole_netdev: fix syzkaller reported issue
[1] https://lkml.org/lkml/2019/10/25/794

Best regards
Naresh Kamboju
