Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB231AA977
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636450AbgDOOHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636440AbgDOOH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 10:07:27 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54799206A2;
        Wed, 15 Apr 2020 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586959644;
        bh=kHMA5K+vVX9FJ4EGBvRkm0nVrpDxDC7TmdWqvxTxsIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRLyOvd4CrsCRQjd4bIW+97ECxdE6Ai/P3VM58oB9VykN1DeL7JjxNW1jA7TZYAmT
         GGtKe8+EaFEcA5vVrRPoddqsyGvsplwT2ERaCGO2Aef+q4fKIYKwLvjBwmIeruh9kX
         biWvAq6bIeks/9hk+nUkdAr7IZKDwsoMu6FBoaos=
Date:   Wed, 15 Apr 2020 10:07:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Edward Cree <ecree@solarflare.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200415140723.GH1068@sasha-vm>
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
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200414225009.GX3141@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 12:50:09AM +0200, Michal Kubecek wrote:
>On Tue, Apr 14, 2020 at 08:37:18PM +0300, Leon Romanovsky wrote:
>>
>> The autoselection process works good enough for everything outside
>> of netdev community.
>
>That's very far from true. I have seen and heard many complaints about

How about some actionable data? What do you expect us to do with "seen
and heard"?

Do you have evidence that AUTOSEL introduces more regressions over the
stable tagged commits? Do you have evidence showing that AUTOSEL isn't
performing properly? Great, let's go over it.

I have always measured the results of this work and compared it to the
"regular" flow of stable tagged commits, I'm keeping track of how the
quality of it compares to those stable tagged commits, and quite a few
times I took action to deal with specific issues that come up with the
process based on data.

There's not much I can do with "seen and heard".

>AUTOSEL and inflation of stable trees in general, both in private and in

I'm puzzled about your objections to "inflation"? The stable tree was
missing a bunch of fixes before, and now it doesn't.

In parallel to "inflating" the stable trees I'm also driving efforts to
improve the testing of these trees so that we could reliably say that we
didn't introduce any regressions into the stable tree. "inflation" on
it's own doesn't increase the rate of regressions in stable trees, and
that's based on historical data.

>public lists. It was also discussed on Kernel Summit few times - with
>little success.

Define success? We're adding a bunch of missing fixes and not causing
any more regressions than before, you don't call that a success?

Let me also point out that I've tried to bring up this process (as well
as the -stable process in general) at every kernel summit/maintainer's
summit (here's the one from last year: https://lwn.net/Articles/799166/)
and attempted to address any feedback that came back from it. It seemed
to me that there's an agreement that this process was going well (at the
very least Linus didn't yell at me), so I'm still puzzled by your own
success criteria.

-- 
Thanks,
Sasha
