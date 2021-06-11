Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EC73A3A05
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhFKDCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:02:45 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:55624 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhFKDCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 23:02:42 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 15B2xgZD025772;
        Fri, 11 Jun 2021 04:59:42 +0200
Date:   Fri, 11 Jun 2021 04:59:42 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <20210611025942.GE25638@1wt.eu>
References: <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
 <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
 <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home>
 <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
 <87tum5uyrq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tum5uyrq.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 12:43:05AM +0200, Toke Høiland-Jørgensen wrote:
> Shuah Khan <skhan@linuxfoundation.org> writes:
> > I have a
> > couple of ideas on how we might be able to improve remote experience
> > without restricting in-person experience.
> >
> > - Have one or two moderators per session to watch chat and Q&A to enable
> >    remote participants to chime in and participate.
> > - Moderators can make sure remote participation doesn't go unnoticed and
> >    enable taking turns for remote vs. people participating in person.
> >
> > It will be change in the way we interact in all in-person sessions for
> > sure, however it might enhance the experience for remote attendees.
> 
> This is basically how IETF meetings function: At the beginning of every
> session, a volunteer "jabber scribe" is selected to watch the chat and
> relay any questions to a microphone in the room. And the video streaming
> platform has a "virtual queue" that remove participants can enter and
> the session chairs are then responsible for giving people a chance to
> speak. Works reasonably well, I'd say :)

I was about to say the same. In addition, local participants line up
at a microphone and do not interrupt the speaker, but the organiser
gives them the signal to ask a question. This allows to maintain a
good balance between local and remote participants. Also it's common
to see some locals go back to their seat because someone else just
asked the same question. And when remote questions are asked using
pure text, it's easy for the organiser to skip them if already
responded as well.

This method is rather efficient because it doesn't require to keep the
questions for the end of the session, yet questions do not interrupt
the speaker. It also solves the problem of people not speaking in the
microphone. The only thing is that it can be quite intimidating for
local participants who are too shy of standing up in front of a
microphone and everyone else.

Just my two cents,
Willy
