Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB63B10F1
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 02:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFWAJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 20:09:26 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:55558 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFWAJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 20:09:25 -0400
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C5F9AA66;
        Wed, 23 Jun 2021 02:07:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1624406827;
        bh=XmuXHoOHtHnNMvadIBXxUBeEBXIwxD7W0OO1IbKbwn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eKUHcf9u81HC+idmdb011OeaHRqIR+1RLeDihqsl/C2IE7fWkHRDuDPh+oomwfvMv
         Sb6t/93I+SKuX3w4EQsBNOg0sxVEfuvK3h5w0mUGmnPTeBP1pZ7IM1hs6ydBSqPey8
         OWsWT8tT3a+cy+ajfMexJChnpEkddaxz429TxsZQ=
Date:   Wed, 23 Jun 2021 03:06:37 +0300
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
Message-ID: <YNJ7DTulb1fa/F/7@pendragon.ideasonboard.com>
References: <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
 <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home>
 <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
 <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
 <ae51f636-8fb5-20b7-bbc5-37e22edb9a02@linuxfoundation.org>
 <YNJrZIMs7RvqRBSG@pendragon.ideasonboard.com>
 <3bfbe45c-2356-6db0-e1b8-11b7e37ae858@linuxfoundation.org>
 <66fce207-2602-6452-9216-01ebde656bcd@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66fce207-2602-6452-9216-01ebde656bcd@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 05:57:11PM -0600, Shuah Khan wrote:
> On 6/22/21 5:33 PM, Shuah Khan wrote:
> > On 6/22/21 4:59 PM, Laurent Pinchart wrote:
> >> On Tue, Jun 22, 2021 at 04:33:22PM -0600, Shuah Khan wrote:
> >>> On 6/18/21 7:46 AM, Laurent Pinchart wrote:
> >>>> On Thu, Jun 10, 2021 at 01:55:23PM -0600, Shuah Khan wrote:
> >>>>> On 6/10/21 1:26 PM, Steven Rostedt wrote:
> >>>>>> On Thu, 10 Jun 2021 21:39:49 +0300 Laurent Pinchart wrote:
> >>>>>>
> >>>>>>> There will always be more informal discussions between on-site
> >>>>>>> participants. After all, this is one of the benefits of conferences, by
> >>>>>>> being all together we can easily organize ad-hoc discussions. This is
> >>>>>>> traditionally done by finding a not too noisy corner in the conference
> >>>>>>> center, would it be useful to have more break-out rooms with A/V
> >>>>>>> equipment than usual ?
> >>>>>>
> >>>>>> I've been giving this quite some thought too, and I've come to the
> >>>>>> understanding (and sure I can be wrong, but I don't think that I am),
> >>>>>> is that when doing a hybrid event, the remote people will always be
> >>>>>> "second class citizens" with respect to the communication that is going
> >>>>>> on. Saying that we can make it the same is not going to happen unless
> >>>>>> you start restricting what people can do that are present, and that
> >>>>>> will just destroy the conference IMO.
> >>>>>>
> >>>>>> That said, I think we should add more to make the communication better
> >>>>>> for those that are not present. Maybe an idea is to have break outs
> >>>>>> followed by the presentation and evening events that include remote
> >>>>>> attendees to discuss with those that are there about what they might
> >>>>>> have missed. Have incentives at these break outs (free stacks and
> >>>>>> beer?) to encourage the live attendees to attend and have a discussion
> >>>>>> with the remote attendees.
> >>>>>>
> >>>>>> The presentations would have remote access, where remote attendees can
> >>>>>> at the very least write in some chat their questions or comments. If
> >>>>>> video and connectivity is good enough, perhaps have a screen where they
> >>>>>> can show up and talk, but that may have logistical limitations.
> >>>>>>
> >>>>>
> >>>>> You are absolutely right that the remote people will have a hard time
> >>>>> participating and keeping up with in-person participants. I have a
> >>>>> couple of ideas on how we might be able to improve remote experience
> >>>>> without restricting in-person experience.
> >>>>>
> >>>>> - Have one or two moderators per session to watch chat and Q&A to enable
> >>>>>      remote participants to chime in and participate.
> >>>>> - Moderators can make sure remote participation doesn't go unnoticed and
> >>>>>      enable taking turns for remote vs. people participating in person.
> >>>>>
> >>>>> It will be change in the way we interact in all in-person sessions for
> >>>>> sure, however it might enhance the experience for remote attendees.
> >>>>
> >>>> A moderator to watch online chat and relay questions is I believe very
> >>>> good for presentations, it's hard for a presenter to keep an eye on a
> >>>> screen while having to manage the interaction with the audience in the
> >>>> room (there's the usual joke of the difference between an introvert and
> >>>> an extrovert open-source developer is that the extrovert looks at *your*
> >>>> shoes when talking to you, but in many presentations the speaker
> >>>> nowadays does a fairly good job as watching the audience, at least from
> >>>> time to time :-)).
> >>>>
> >>>> For workshop or brainstorming types of sessions, the highest barrier to
> >>>> participation for remote attendees is local attendees not speaking in
> >>>> microphones. That's the number one rule that moderators would need to
> >>>> enforce, I think all the rest depends on it. This may require a larger
> >>>> number of microphones in the room than usual.
> >>>
> >>> Absolutely. Moderator has to make sure the following things happen for
> >>> this to be effective:
> >>>
> >>> - Watch chat and Q&A, Raise hand from remote participants
> >>> - Enforce some kind of taking turns to allow fairness in
> >>>     participation
> >>> - Have the speaker repeat questions asked in the room (we do that now
> >>>     in some talks - both remote and in-person - chat and Q&A needs
> >>>     reading out for recording)
> >>> - Explore live Transcription features available in the virtual conf.
> >>>     platform. You still need humans watching the transcription.
> >>> - Have a running session notes combined with transcription.
> >>>
> >>> Any of these options aren't sustainable when large number of people
> >>> are participating remotely or in-person. In general a small number of
> >>> people participate either in person or remote in any case, based on
> >>> my observation in remote and in-person settings.
> >>>
> >>> Maybe we can experiment with one or two workshops this time around
> >>> and see how it works out. If we can figure an effective way, it would
> >>> be beneficial for people that can't travel for one reason or the
> >>> other.
> >>
> >> Can we nominate moderators ahead of time ? For workshop-style
> >> discussions, they need to be a person who won't participate actively in
> >> the discussions, as it's impossible to both contribute and moderate at
> >> the same time.
> > 
> > Correct. It will be impossible to participate and moderate in workshop
> > setting. We have to ask for volunteers and nominate moderators ahead of
> > time.
> 
> Subsystems could seek volunteers from other subsystems perhaps ...

That's a good idea, and it's a great way to learn about other parts of
the kernel (or other open-source projects). This would need to be taken
into account when scheduling workshops though. I'd like to also propose
giving official recognition of the important role of moderators, for
instance by extending the speaker's gift scheme to moderators (no
personal interest here as I won't attend the conference in person and
thus can't be a moderator, and it's an easy to make suggestion for me as
I don't manage conference budgets :-)).

-- 
Regards,

Laurent Pinchart
