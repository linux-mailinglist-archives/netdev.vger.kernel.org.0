Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427C439CD74
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 07:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFFFb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 01:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFFFb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 01:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C156860E09;
        Sun,  6 Jun 2021 05:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622957378;
        bh=GvLqCxzOSGpxV+5g+nxJ6YjREkqoOkFCSNfxueusEBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TqJmP0wOoPMpZNdSVIh8wi4aIZ3kRENjGa77taV6gGgKXIbEyDTKNFMWzZY42pVT/
         5wocHIUhBxjNtzUMYzEFaMcvzrf5qA5e3l90oRbJls57J1gUFAZtc7gaASSIRhvo5J
         8grarC/fCFUB/LcORXzGDUilUpCQasrq8TFk/uqIaSE1s2+kEXfRSwL4irCoLejI3t
         OKRJyIxkJC9ipcgCK0Ib2dCexgwdnfyNIYK2rw+kWT27EK4z+nywaVeyefCRuZSotv
         F5LoJV+EP58Zs3sCEBbuE9O7v1R+opwYBNDUXS7OIqAyHB+ZEx49AYF8Ufv2hpqVRp
         knC4tTQNl7aFA==
Date:   Sun, 6 Jun 2021 08:29:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     SyzScope <syzscope@gmail.com>, davem@davemloft.net,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YLxdPvx/c8ts6gZC@unreal>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
 <YLsrLz7otkQAkIN7@kroah.com>
 <d37fecad-eed3-5eb8-e30a-ebb912e3a073@gmail.com>
 <YLxaEJQ5CR3xMLnC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLxaEJQ5CR3xMLnC@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 07:16:00AM +0200, Greg KH wrote:
> On Sat, Jun 05, 2021 at 11:12:49AM -0700, SyzScope wrote:
> > Hi Greg,

<...>

> > Perhaps we misunderstood the problem of syzbot-generated bugs. Our
> > understanding is that if a syzbot-generated bug is exploited in the wild
> > and/or the exploit code is made publicly available somehow, then the bug
> > will be fixed in a prioritized fashion. If our understanding is correct,
> > wouldn't it be nice if we, as good guys, can figure out which bugs are
> > security-critical and patch them before the bad guys exploit them.
> 
> The "problem" is that no one seems willing to provide the resources to
> fix the issues being found as quickly as they are being found.  It
> usually takes an exponentially longer amount of time for a fix than to
> find the problem. 

And this is even an easy case, the more complex and common situation
where repro is not available or it doesn't reproduce locally, because
it is race.

Thanks
