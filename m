Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7EDEF6D6
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388099AbfKEIGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387994AbfKEIGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 03:06:18 -0500
Received: from localhost (host6-102.lan-isdn.imaginet.fr [195.68.6.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47597214D8;
        Tue,  5 Nov 2019 08:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572941177;
        bh=r8CPAD2ukH3TuZMyKg8muNUfDNqz5bGb2awi7lR72D0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GU7cnJiQWPcE3woPx8W0TGQ78hO6fwTGm/8YE13mbxJv5cMRSmhGkeC75QPju9uQs
         g5golJoltqhWflG1G0lHkQHSg3MLB3fGGRNYuM0Tx0guwjPcpW0gEZnZTWujnJvMwH
         VA54j2rFzYc8Ib9RlHqJK4o05frCP8bc9cwCTThM=
Date:   Tue, 5 Nov 2019 09:06:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Dan Rue <dan.rue@linaro.org>, LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>, chrubis <chrubis@suse.cz>,
        mmarhefk@redhat.com, Netdev <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>, maheshb@google.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: stable-rc-5.3.9-rc1: regressions detected - remove_proc_entry:
 removing non-empty directory 'net/dev_snmp6', leaking at least 'lo'
Message-ID: <20191105080614.GB2611856@kroah.com>
References: <CA+G9fYsWTFQZTHXUDPToaepnKGBoh61SsA_8SHcYgYZXN_L+mg@mail.gmail.com>
 <CA+G9fYu+6A3pYQGs2rydYtHNSCf1t9+OTRqrZeCbpc2ARLx2zA@mail.gmail.com>
 <20191105073459.GB2588562@kroah.com>
 <CA+G9fYvau-CY8eeXM=atzQBjYbmUPg78MXu_GNjCyKDkW_CcVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvau-CY8eeXM=atzQBjYbmUPg78MXu_GNjCyKDkW_CcVQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 01:28:01PM +0530, Naresh Kamboju wrote:
> On Tue, 5 Nov 2019 at 13:05, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > > > Linux stable rc 5.3 branch running LTP reported following test failures.
> > > > While investigating these failures I have found this kernel warning
> > > > from boot console.
> > > > Please find detailed LTP output log in the bottom of this email.
> > > >
> > > > List of regression test cases:
> > > >   ltp-containers-tests:
> > > >     * netns_breakns_ip_ipv6_ioctl
> <trim>
> > > >     * netns_comm_ns_exec_ipv6_netlink
> > >
> > > These reported failures got fixed on latest stable-rc 5.3.y after
> > > dropping a patch [1].
> >
> > What is the subject of the patch?
> 
> blackhole_netdev: fix syzkaller reported issue
> upstream commit b0818f80c8c1bc215bba276bd61c216014fab23b

That commit is not in any stable queue or tree at the moment, are you
sure this is still an issue?

> > > The kernel warning is also gone now.
> > >
> > > metadata:
> > >   git branch: linux-5.3.y
> > >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >   git commit: 75c9913bbf6e9e64cb669236571e6af45cddfd68
> >
> > The -rc tree is rebased all the time, can I get a "real" subject line to
> > get a chance to figure out what you are trying to refer to here?
> 
> Linux 5.3.9-rc1 is good candidate on branch linux-5.3.y and
> linux-stable-rc tree.

I can not parse this, what do you mean?

thanks,

greg k-h
