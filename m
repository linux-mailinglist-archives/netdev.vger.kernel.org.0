Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A74F1D564A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgEOQkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:40:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56129 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726229AbgEOQkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:40:06 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04FGdvAn026899
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 12:39:57 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E0C39420304; Fri, 15 May 2020 12:39:56 -0400 (EDT)
Date:   Fri, 15 May 2020 12:39:56 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     linux-kernel@vger.kernel.org, inux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Maintainers / Kernel Summit 2020 planning kick-off
Message-ID: <20200515163956.GA2158595@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Feel free to forward this to other Linux kernel mailing lists as
  appropriate -- Ted ]

This year, the Maintainers and Kernel Summit will NOT be held in
Halifax, August 25 -- 28th, as a result of the COVID-19 pandemic.
Instead, we will be pursuing a virtual conference format for both the
Maintainers and Kernel Summit, around the last week of August.

As in previous years, the Maintainers Summit is invite-only, where the
primary focus will be process issues around Linux Kernel Development.
It will be limited to 30 invitees and a handful of sponsored
attendees.

The Kernel Summit is organized as a track which is run in parallel
with the other tracks at the Linux Plumbers Conference (LPC), and is
open to all registered attendees of LPC.

Linus will be generating a core list of people to be invited to the
Maintainers Summit.  The top ten people from that list will receive
invites, and then program committee will use the rest of Linus's list
as a starting point of people to be considered.  People who suggest
topics that should be discussed at the Maintainers Summit will also
be added to the list for consideration.  To make topic suggestions for
the Maintainers Summit, please send e-mail to the
ksummit-discuss@lists.linuxfoundation.org list with a subject prefix
of [MAINTAINERS SUMMIT].

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

	https://bit.ly/lpc20-submit

Please do both steps.  I'll try to notice if someone forgets one or
the other, but your chances of making sure your proposal gets the
necessary attention and consideration are maximized by submitting both
to the mailing list and the web site.

People who submit topic suggestions before June 15th and which are
accepted, will be given free admission to the Linux Plumbers
Conference.

We will be reserving roughly half of the Kernel Summit slots for
last-minute discussions that will be scheduled during the week of
Plumbers, in an "unconference style".  This allows last-minute ideas
that come up to be given given slots for discussion.

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
