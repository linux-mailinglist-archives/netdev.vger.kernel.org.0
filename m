Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60641BFBC
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfEMXGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:06:51 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43843 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726233AbfEMXGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:06:51 -0400
Received: from callcc.thunk.org (rrcs-67-53-55-100.west.biz.rr.com [67.53.55.100])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4DN6hUY006602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 May 2019 19:06:45 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 14F3A420024; Mon, 13 May 2019 19:06:43 -0400 (EDT)
Date:   Mon, 13 May 2019 19:06:43 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, ksummit-discuss@lists.linuxfoundation.org
Subject: Maintainer's / Kernel Summit 2019 planning kick-off
Message-ID: <20190513230643.GA4347@mit.edu>
Reply-To: tytso@mit.edu
Mail-Followup-To: tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Feel free to forward this to other Linux kernel mailing lists as
  appropriate -- Ted ]

This year, the Maintainer's and Kernel Summit will be at the Corinthia
Hotel in Lisbon, Portugal, September 9th -- 12th.  The Kernel Summit
will be held as a track during the Linux Plumbers Conference
September 9th -- 11th.  The Maintainer's Summit will be held
afterwards, on September 12th.

As in previous years, the "Maintainer's Summit" is an invite-only,
half-day event, where the primary focus will be process issues around
Linux Kernel Development.  It will be limited to 30 invitees and a
handful of sponsored attendees.  This makes it smaller than the first
few kernel summits (which were limited to around 50 attendees).

The "Kernel Summit" is organized as a track which is run in parallel
with the other tracks at the Linux Plumber's Conference (LPC), and is
open to all registered attendees of LPC.

Linus has a generated a list of 18 people to use as a core list.  The
program committee will pick at least ten people from that list, and
then use the rest of Linus's list as a starting point of people to be
considered.  People who suggest topics that should be discussed on the
Maintainer's summit will also be added to the list for consideration.
To make topic suggestions for the Maintainer's Summit, please send
e-mail to the ksummit-discuss@lists.linuxfoundation.org list with a
subject prefix of [MAINTAINERS SUMMIT].

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

	http://bit.ly/lpc19-submit

Please do both steps.  I'll try to notice if someone forgets one or
the other, but your chances of making your proposal gets the necessary
attention and consideration by submiting both to the mailing list and
the web site.

People who submit topic suggestions before May 31st and which are
accepted, will be given a free admission to the Linux Plumbers
Conference.

We will reserving roughly half of the Kernel Summit slots for
last-minute discussions that will be scheduled during the week of
Plumber's, in an "unconference style".  This allows ideas that come up
in hallway discussions, and in the LPC miniconferences, to be given
scheduled, dedicated times for discussion.

If you were not subscribed on to the kernel-discuss mailing list from
last year (or if you had removed yourself after the kernel summit),
you can subscribe to the discuss list using mailman:

   https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss

The program committee this year is composed of the following people:

Greg Kroah-Hartman
Jens Axboe
Jon Corbet
Ted Ts'o
Thomas Gleixner
