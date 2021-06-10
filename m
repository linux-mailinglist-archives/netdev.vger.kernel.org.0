Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC3A3A3472
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhFJUEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhFJUEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:04:45 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCB4D6136D;
        Thu, 10 Jun 2021 20:02:47 +0000 (UTC)
Date:   Thu, 10 Jun 2021 16:02:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <20210610160246.13722775@oasis.local.home>
In-Reply-To: <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
References: <YH2hs6EsPTpDAqXc@mit.edu>
        <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
        <YIx7R6tmcRRCl/az@mit.edu>
        <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
        <YK+esqGjKaPb+b/Q@kroah.com>
        <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
        <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
        <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
        <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
        <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
        <20210610152633.7e4a7304@oasis.local.home>
        <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 13:55:23 -0600
Shuah Khan <skhan@linuxfoundation.org> wrote:

> You are absolutely right that the remote people will have a hard time
> participating and keeping up with in-person participants. I have a
> couple of ideas on how we might be able to improve remote experience
> without restricting in-person experience.
> 
> - Have one or two moderators per session to watch chat and Q&A to enable
>    remote participants to chime in and participate.
> - Moderators can make sure remote participation doesn't go unnoticed and
>    enable taking turns for remote vs. people participating in person.
> 
> It will be change in the way we interact in all in-person sessions for
> sure, however it might enhance the experience for remote attendees.

I have no problem with the above suggestion, and I envision that this
may be the norm going forward. What is still missing is the
interactions of the hallway track and the evening events. I was
thinking about how we could get the remote folks in on what happened
there right afterward, which is why I'm suggesting breakout rooms like
Laurent suggested as well, but at the end of the conference, and
perhaps the conversations of the previous night could continue with a
remote presence.

-- Steve
