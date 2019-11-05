Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531F3EF678
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 08:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbfKEHfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 02:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387484AbfKEHfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 02:35:03 -0500
Received: from localhost (host6-102.lan-isdn.imaginet.fr [195.68.6.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E04EF217F4;
        Tue,  5 Nov 2019 07:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572939302;
        bh=K1BKpJQLMtnH3+V92uee7SW/Z+pmSQfrcqeTyN7QlB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eghPibRXlsACFFKrYkascPxzVND7Aiuqaf9uVBhvkHW5YFgjXLIJw1fi5B+JqEn2J
         9Ap1s3dpd6jwGSXdExj1GfwpDBNlhsNN9V3qwx+NLM+UsQ+aRJnfooJHREyAUXMm3j
         G39z1/GxCJimZ8wNJuv9uuLJ6rRp5bamdOGU6ExY=
Date:   Tue, 5 Nov 2019 08:34:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Dan Rue <dan.rue@linaro.org>, LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>, chrubis <chrubis@suse.cz>,
        mmarhefk@redhat.com, Netdev <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: stable-rc-5.3.9-rc1: regressions detected - remove_proc_entry:
 removing non-empty directory 'net/dev_snmp6', leaking at least 'lo'
Message-ID: <20191105073459.GB2588562@kroah.com>
References: <CA+G9fYsWTFQZTHXUDPToaepnKGBoh61SsA_8SHcYgYZXN_L+mg@mail.gmail.com>
 <CA+G9fYu+6A3pYQGs2rydYtHNSCf1t9+OTRqrZeCbpc2ARLx2zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu+6A3pYQGs2rydYtHNSCf1t9+OTRqrZeCbpc2ARLx2zA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 09:44:39AM +0530, Naresh Kamboju wrote:
> Hi Sasha and Greg,
> 
> On Mon, 4 Nov 2019 at 20:59, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > Linux stable rc 5.3 branch running LTP reported following test failures.
> > While investigating these failures I have found this kernel warning
> > from boot console.
> > Please find detailed LTP output log in the bottom of this email.
> >
> > List of regression test cases:
> >   ltp-containers-tests:
> >     * netns_breakns_ip_ipv6_ioctl
> >     * netns_breakns_ip_ipv6_netlink
> >     * netns_breakns_ns_exec_ipv6_ioctl
> >     * netns_breakns_ns_exec_ipv6_netlink
> >     * netns_comm_ip_ipv6_ioctl
> >     * netns_comm_ip_ipv6_netlink
> >     * netns_comm_ns_exec_ipv6_ioctl
> >     * netns_comm_ns_exec_ipv6_netlink
> 
> These reported failures got fixed on latest stable-rc 5.3.y after
> dropping a patch [1].

What is the subject of the patch?

> The kernel warning is also gone now.
> 
> metadata:
>   git branch: linux-5.3.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: 75c9913bbf6e9e64cb669236571e6af45cddfd68

The -rc tree is rebased all the time, can I get a "real" subject line to
get a chance to figure out what you are trying to refer to here?

> ref:
> [PATCH AUTOSEL 5.3 12/33] blackhole_netdev: fix syzkaller reported issue
> [1] https://lkml.org/lkml/2019/10/25/794

lore.kernel.org is much more reliable :)

thanks,

greg k-h
