Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346DB39CD6A
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 07:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhFFFSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 01:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFFFSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 01:18:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2469E613AD;
        Sun,  6 Jun 2021 05:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622956563;
        bh=Zf7Kfx7qL0chz3XFmznzzhgdV1AKk9we4WIewDjyNlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EV1qFVodWq2nbTuND8CUWAyaWMKUWghuAtCusrVe4DCZLJodAB1v6fLmyTPKdRhu9
         Wx6JBqJfAQQ1U/0dS0DFUA0lMpg4OIaStpCqzNqk//enZq3ug+ZNVFaIQeTZFzfmKi
         iMFL5vDArbzmT9HksnI3kjNWe12XiiUMgiREeVEo=
Date:   Sun, 6 Jun 2021 07:16:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SyzScope <syzscope@gmail.com>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YLxaEJQ5CR3xMLnC@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
 <YLsrLz7otkQAkIN7@kroah.com>
 <d37fecad-eed3-5eb8-e30a-ebb912e3a073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d37fecad-eed3-5eb8-e30a-ebb912e3a073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 11:12:49AM -0700, SyzScope wrote:
> Hi Greg,
> 
> > I do not recall that, sorry, when was that?
> We sent an email to security@kernel.org from xzou017@ucr.edu account on May
> 20, the title is "KASAN: use-after-free Read in hci_chan_del has dangerous
> security impact".

So you used a different email address and we were supposed to know how
to correlate between the two?  How?

> > Is that really the reason why syzbot-reported problems are not being
> > fixed?  Just because we don't know which ones are more "important"?
> > 
> > As someone who has been managing many interns for a year or so working
> > on these, I do not think that is the problem, but hey, what do I know...
> 
> Perhaps we misunderstood the problem of syzbot-generated bugs. Our
> understanding is that if a syzbot-generated bug is exploited in the wild
> and/or the exploit code is made publicly available somehow, then the bug
> will be fixed in a prioritized fashion. If our understanding is correct,
> wouldn't it be nice if we, as good guys, can figure out which bugs are
> security-critical and patch them before the bad guys exploit them.

The "problem" is that no one seems willing to provide the resources to
fix the issues being found as quickly as they are being found.  It
usually takes an exponentially longer amount of time for a fix than to
find the problem.  Try it yourself and see!  Fix these issues that your
tool is somehow categorizing as "more important" and let us know how it
goes.

Or is just fixing found bugs somehow not as much fun as writing new
tools?

good luck!

greg k-h
