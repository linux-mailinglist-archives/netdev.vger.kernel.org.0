Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92216364725
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241349AbhDSP33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:29:29 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45120 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233733AbhDSP31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 11:29:27 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13JFSplv032708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 11:28:51 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3695315C3B0D; Mon, 19 Apr 2021 11:28:51 -0400 (EDT)
Date:   Mon, 19 Apr 2021 11:28:51 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <YH2hs6EsPTpDAqXc@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Feel free to forward this to other Linux kernel mailing lists as
  appropriate -- Ted ]

This year, the Maintainers and Kernel Summit is currently planned to
be held in Dublin, Ireland, September 27 -- 29th.  Of course, this is
subject to change depending on how much progress the world makes
towards vaccinating the population against the COVID-19 virus, and
whether employers are approving conference travel.  At this point,
there's a fairly good chance that we will need to move to a virtual
conference format, either for one or both of the summits.

As in previous years, the Maintainers Summit is invite-only, where the
primary focus will be process issues around Linux Kernel Development.
It will be limited to 30 invitees and a handful of sponsored
attendees.

The Kernel Summit is organized as a track which is run in parallel
with the other tracks at the Linux Plumbers Conference (LPC), and is
open to all registered attendees of LPC.

Linus has generated a core list of people to be invited to the
Maintainers Summit, and the program committee will be using that list
a starting point of people to be considered.  People who suggest
topics that should be discussed at the Maintainers Summit will also be
added to the list for consideration.  To make topic suggestions for
the Maintainers Summit, please send e-mail to the
ksummit@lists.linux.dev with a subject prefix of [MAINTAINERS SUMMIT].

(Note: The older ksummit-discuss@lists.linuxfoundation.org list has
been migrated to lists.linux.dev, with the subscriber list and
archives preserved.)

The other job of the program committee will be to organize the program
for the Kernel Summit.  The goal of the Kernel Summit track will be to
provide a forum to discuss specific technical issues that would be
easier to resolve in person than over e-mail.  The program committee
will also consider "information sharing" topics if they are clearly of
interest to the wider development community (i.e., advanced training
in topics that would be useful to kernel developers).

To suggest a topic for the Kernel Summit, please do two things.
First, please tag your e-mail with [TECH TOPIC].  As before, please
use a separate e-mail for each topic, and send the topic suggestions
to the ksummit-discuss list.

Secondly, please create a topic at the Linux Plumbers Conference
proposal submission site and target it to the Kernel Summit track.
For your convenience you can use:

	https://bit.ly/lpc21-summit

Please do both steps.  I'll try to notice if someone forgets one or
the other, but your chances of making sure your proposal gets the
necessary attention and consideration are maximized by submitting both
to the mailing list and the web site.

People who submit topic suggestions before June 12th and which are
accepted, will be given free admission to the Linux Plumbers
Conference.

We will be reserving roughly half of the Kernel Summit slots for
last-minute discussions that will be scheduled during the week of
Plumbers, in an "unconference style".  This allows last-minute ideas
that come up to be given given slots for discussion.

If you were not subscribed on to the kernel@lists.linux-dev mailing
list from last year (or if you had removed yourself from the
ksummit-discuss@lists.linux-foundation.org mailing list after the
previous year's kernel and maintainers' summit summit), you can
subscribe sending an e-mail to:

	ksummit+subscribe@lists.linux.dev

The mailing list archive is available at:

	https://lore.kernel.org/ksummit

The program committee this year is composed of the following people:

Jens Axboe
Arnd Bergmann
Jon Corbet
Greg Kroah-Hartman
Ted Ts'o
