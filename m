Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A9639C6A5
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhFEHpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhFEHpf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 03:45:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5CA161359;
        Sat,  5 Jun 2021 07:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622879027;
        bh=Gq9kp/VkgTfvuf8fYYAhdWS4ZtQc/VW9REeVhFoPjBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xNdRME7iezuIhO2hggAJzcFX8eeNEWEKMpQW316asdRj/LpLbvSrLr/gVQH6RNgBw
         /4GKbGqhBP2PTn/iExUFrK4x3EjEIZ9Cc25n6D5CzRtVZKYDgsNbWqdNfm0sksbwVa
         w0pwV1IW5hAwiLsDDFtkunQhcIlQCwkT4by33XlQ=
Date:   Sat, 5 Jun 2021 09:43:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SyzScope <syzscope@gmail.com>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YLsrLz7otkQAkIN7@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 10:11:03AM -0700, SyzScope wrote:
> Hi Greg,
> 
> > Who is working on and doing this "reseach project"?
> We are a group of researchers from University of California, Riverside (we
> introduced ourselves in an earlier email to security@kernel.org if you
> recall).

I do not recall that, sorry, when was that?

> Please allow us to articulate the goal of our research. We'd be
> happy to hear your feedback and suggestions.
> 
> > And what is it
> > doing to actually fix the issues that syzbot finds?  Seems like that
> > would be a better solution instead of just trying to send emails saying,
> > in short "why isn't this reported issue fixed yet?"
> From our limited understanding, we know a key problem with syzbot bugs is
> that there are too many of them - more than what can be handled by
> developers and maintainers. Therefore, it seems some form of prioritization
> on bug fixing would be helpful. The goal of the SyzScope project is to
> *automatically* analyze the security impact of syzbot bugs, which helps with
> prioritizing bug fixes. In other words, when a syzbot bug is reported, we
> aim to attach a corresponding security impact "signal" to help developers
> make an informed decision on which ones to fix first.

Is that really the reason why syzbot-reported problems are not being
fixed?  Just because we don't know which ones are more "important"?

As someone who has been managing many interns for a year or so working
on these, I do not think that is the problem, but hey, what do I know...

> Currently,  SyzScope is a standalone prototype system that we plan to open
> source. We hope to keep developing it to make it more and more useful and
> have it eventually integrated into syzbot (we are in talks with Dmitry).
> 
> We are happy to talk more offline (perhaps even in a zoom meeting if you
> would like). Thanks in advance for any feedback and suggestions you may
> have.

Meetings are not really how kernel development works, sorry.

At the moment, these emails really do not seem all that useful, trying
to tell other people what to do does not get you very far when dealing
with people who you have no "authority" over...

Technical solutions to human issues almost never work, however writing a
procmail filter to keep me from having to see these will work quite well :)

good luck!

greg k-h
