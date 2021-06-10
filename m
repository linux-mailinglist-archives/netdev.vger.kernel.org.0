Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF2B3A3409
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhFJT2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhFJT2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 15:28:33 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597D361376;
        Thu, 10 Jun 2021 19:26:35 +0000 (UTC)
Date:   Thu, 10 Jun 2021 15:26:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
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
Message-ID: <20210610152633.7e4a7304@oasis.local.home>
In-Reply-To: <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
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
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 21:39:49 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> There will always be more informal discussions between on-site
> participants. After all, this is one of the benefits of conferences, by
> being all together we can easily organize ad-hoc discussions. This is
> traditionally done by finding a not too noisy corner in the conference
> center, would it be useful to have more break-out rooms with A/V
> equipment than usual ?

I've been giving this quite some thought too, and I've come to the
understanding (and sure I can be wrong, but I don't think that I am),
is that when doing a hybrid event, the remote people will always be
"second class citizens" with respect to the communication that is going
on. Saying that we can make it the same is not going to happen unless
you start restricting what people can do that are present, and that
will just destroy the conference IMO.

That said, I think we should add more to make the communication better
for those that are not present. Maybe an idea is to have break outs
followed by the presentation and evening events that include remote
attendees to discuss with those that are there about what they might
have missed. Have incentives at these break outs (free stacks and
beer?) to encourage the live attendees to attend and have a discussion
with the remote attendees.

The presentations would have remote access, where remote attendees can
at the very least write in some chat their questions or comments. If
video and connectivity is good enough, perhaps have a screen where they
can show up and talk, but that may have logistical limitations.

The evening events (including going out to the bars and just hanging
with other developers) is a lost cause to try and have remote
participation.

Then the last day, perhaps have a bunch of rooms for various topics
where people can come in and continue the conversation from the evening
events but with a remote audience that can ask questions. Again, you
may need to "bribe" the attendees to come to this and interact ;-)

I'm all for making a better remote experience for hybrid events, but
I'm against doing so by making it a worse experience for those that
attend. Not saying that you suggested this, but I have heard of ideas
about limiting what happens so that the live attendees do not have any
advantage over the remote ones.

-- Steve
