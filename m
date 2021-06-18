Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091C53ACD58
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhFROTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhFROTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 10:19:21 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542ED610CD;
        Fri, 18 Jun 2021 14:17:10 +0000 (UTC)
Date:   Fri, 18 Jun 2021 10:17:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <20210618101708.7ff6d67a@oasis.local.home>
In-Reply-To: <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
References: <YIx7R6tmcRRCl/az@mit.edu>
        <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
        <YK+esqGjKaPb+b/Q@kroah.com>
        <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
        <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
        <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
        <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
        <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
        <20210610152633.7e4a7304@oasis.local.home>
        <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
        <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
        <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 07:11:44 -0700
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2021-06-18 at 16:46 +0300, Laurent Pinchart wrote:
> > For workshop or brainstorming types of sessions, the highest barrier
> > to participation for remote attendees is local attendees not speaking
> > in microphones. That's the number one rule that moderators would need
> > to enforce, I think all the rest depends on it. This may require a
> > larger number of microphones in the room than usual.  
> 
> Plumbers has been pretty good at that.  Even before remote
> participation, if people don't speak into the mic, it's not captured on
> the recording, so we've spent ages developing protocols for this. 
> Mostly centred around having someone in the room to remind everyone to
> speak into the mic and easily throwable padded mic boxes.  Ironically,
> this is the detail that meant we couldn't hold Plumbers in person under
> the current hotel protocols ... the mic needs sanitizing after each
> throw.
>

Plumbers also has the advantage of having a throwable mic. And not just
one of them, we have two and a normal mic as well as a lavalier mic.

Having someone running around the audience passing the mic is not very
efficient, and having to get up and stand at a microphone, may be too
intimidating for some.

-- Steve
