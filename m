Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC152B2176
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKMRE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgKMRE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 12:04:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1385E21D1A;
        Fri, 13 Nov 2020 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605287095;
        bh=jJBBXfVEo/34P3k9s5AFT1TmAl8tIOllsyN8r4B4CGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oEj2z2aQZ5k2PZ2Lt/8rB1UQFwAg4xqb08xeuK533kJjMORkLYtV5UhztPs8hRjRA
         ZkTBNy3D8oDoq400F27kkav4HwZcmlolnqujx6IbX5DG6ZOVVzCMzn2MAT66LVy4R2
         xXIW1Z/RZlH8k3asnzBMONtqc7mNhoNWDqWDqPms=
Date:   Fri, 13 Nov 2020 09:04:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     wenxu@ucloud.cn, vladbu@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict
 packet fragment support.
Message-ID: <20201113090454.1665f89c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113022522.GH3913@localhost.localdomain>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
        <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
        <20201112142058.61202752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201113022522.GH3913@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 23:25:22 -0300 Marcelo Ricardo Leitner wrote:
> On Thu, Nov 12, 2020 at 02:20:58PM -0800, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 11:24:57 +0800 wenxu@ucloud.cn wrote:  
> > > v7-v10: fix __rcu warning   
> > 
> > Are you reposting stuff just to get it build tested?
> > 
> > This is absolutely unacceptable.  
> 
> I don't know if that's the case, but maybe we could have a shadow
> mailing list just for that? So that bots would monitor and would run
> (almost) the same tests are they do here. Then when patches are posted
> here, a list that people actually subscribe, they are already more
> ready. The bots would have to email an "ok" as well, but that's
> implementation detail already. Not that developers shouldn't test
> before posting, but the bots are already doing some tests that may be
> beyond of what one can think of testing before posting.

The code for the entire system is right here:

https://github.com/kuba-moo/nipa

It depends on a patchwork instance to report results to.

I have a script there to feed patches in locally from a maildir but
haven't tested that in a while so it's probably broken. You can also
just run the build bash script without running the whole bot:

https://github.com/kuba-moo/nipa/blob/master/tests/patch/build_allmodconfig_warn/build_allmodconfig.sh

Hardly rocket science.

I have no preference on what people do to test their code, and I'm
happy to take patches for the bot, too.

But we can't have people posting 11 versions of patches to netdev which
is already too high traffic for people to follow.

Not to mention that someone needs to pay for the CPU cycles of the bot,
and we don't want to block getting results for legitimate patches.
