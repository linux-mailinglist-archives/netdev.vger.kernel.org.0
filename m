Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE653ACCA8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhFRNtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:49:01 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:44192 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFRNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:48:58 -0400
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5244B3F0;
        Fri, 18 Jun 2021 15:46:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1624024007;
        bh=cjgy0YmI5JAdyKuANvJ+TssuRnMgzRk5Q7NIsLwYWWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tx57mkgNHFv6d3FeiSUt8xE1/yVBTvCL4VS67xaDuQl/c1RwfsCXJ9q7o+KBjt+Nt
         u9J0NCrM5jVwPknKzctQXqaG6fIX7PJ3XZEydx7KT6UvCQF20lCgZtH1u6I6Bvr8+Q
         Kea3fe7mOtrkryycL+OGWkQoYi27BwgtLqbGwHAE=
Date:   Fri, 18 Jun 2021 16:46:23 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shuah,

On Thu, Jun 10, 2021 at 01:55:23PM -0600, Shuah Khan wrote:
> On 6/10/21 1:26 PM, Steven Rostedt wrote:
> > On Thu, 10 Jun 2021 21:39:49 +0300 Laurent Pinchart wrote:
> > 
> >> There will always be more informal discussions between on-site
> >> participants. After all, this is one of the benefits of conferences, by
> >> being all together we can easily organize ad-hoc discussions. This is
> >> traditionally done by finding a not too noisy corner in the conference
> >> center, would it be useful to have more break-out rooms with A/V
> >> equipment than usual ?
> > 
> > I've been giving this quite some thought too, and I've come to the
> > understanding (and sure I can be wrong, but I don't think that I am),
> > is that when doing a hybrid event, the remote people will always be
> > "second class citizens" with respect to the communication that is going
> > on. Saying that we can make it the same is not going to happen unless
> > you start restricting what people can do that are present, and that
> > will just destroy the conference IMO.
> > 
> > That said, I think we should add more to make the communication better
> > for those that are not present. Maybe an idea is to have break outs
> > followed by the presentation and evening events that include remote
> > attendees to discuss with those that are there about what they might
> > have missed. Have incentives at these break outs (free stacks and
> > beer?) to encourage the live attendees to attend and have a discussion
> > with the remote attendees.
> > 
> > The presentations would have remote access, where remote attendees can
> > at the very least write in some chat their questions or comments. If
> > video and connectivity is good enough, perhaps have a screen where they
> > can show up and talk, but that may have logistical limitations.
> > 
> 
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

A moderator to watch online chat and relay questions is I believe very
good for presentations, it's hard for a presenter to keep an eye on a
screen while having to manage the interaction with the audience in the
room (there's the usual joke of the difference between an introvert and
an extrovert open-source developer is that the extrovert looks at *your*
shoes when talking to you, but in many presentations the speaker
nowadays does a fairly good job as watching the audience, at least from
time to time :-)).

For workshop or brainstorming types of sessions, the highest barrier to
participation for remote attendees is local attendees not speaking in
microphones. That's the number one rule that moderators would need to
enforce, I think all the rest depends on it. This may require a larger
number of microphones in the room than usual.

-- 
Regards,

Laurent Pinchart
