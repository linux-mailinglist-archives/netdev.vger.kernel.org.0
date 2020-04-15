Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D1F1A9289
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 07:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393334AbgDOFbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 01:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgDOFbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 01:31:07 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F372020767;
        Wed, 15 Apr 2020 05:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586928665;
        bh=JIjqmDp1sR3dCa7tuSFYE8h4yUg3CUtUZbKogGuMrg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXfnAA8ykHLfwWvYnTxVAdeNxPE1hg/7KlpdZtFIuTg0SwqySNABqyEBTVRNsiFOU
         wITpl8y71eiELF+l5o5uNuYMT99b1xZZncQACZHb2U8WTSrh+000m3vqfY9EJ5zugm
         4npQzdLjCjI14bYMSdMaHQmXsRiV9Bt5yk74khN0=
Date:   Wed, 15 Apr 2020 08:31:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200415053101.GC1239315@unreal>
References: <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414173718.GE1011271@unreal>
 <20200414225009.GX3141@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414225009.GX3141@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 12:50:09AM +0200, Michal Kubecek wrote:
> On Tue, Apr 14, 2020 at 08:37:18PM +0300, Leon Romanovsky wrote:
> >
> > The autoselection process works good enough for everything outside
> > of netdev community.
>
> That's very far from true. I have seen and heard many complaints about
> AUTOSEL and inflation of stable trees in general, both in private and in
> public lists. It was also discussed on Kernel Summit few times - with
> little success.

I'm aware of the discussions and the cases brought there. From what I
saw, Sasha and Greg came with numbers and process that is much better
than anything else we had before. While the opponents came with very
narrow examples of imperfections in AUTOSEL machinery.

Of course, the AUTOSEL mechanism is not perfect and prone to errors,
but it is much better than try to rely on the developers good will to
add Fixes and stable@ tag.

It is pretty easy to be biased while receiving those complaints, because
people are contacting us only if something is broken. I imagine that no one
is approaching you and expressing his happiness with stable@ or anything
else.

Just for fun and to get perspective, for one my very popular tool, which
I wrote two years ago, I received only ONE "thank you" email that says that
this tool works as expected and helped to identify the problem.

And personally, I'm running latest Fedora on all my servers and laptop and
it works great - stable and reliable.

Thanks

>
> Just for fun, I suggest everyone to read first section of
> Documentation/process/stable-kernel-rules.rst and compare with today's
> reality. Of course, rules can change over time but keeping that document
> in kernel tree as a memento is rather sad - I went through the rules now
> and there are only three which are not broken on a regular basis these
> days.
>
> Michal Kubecek
