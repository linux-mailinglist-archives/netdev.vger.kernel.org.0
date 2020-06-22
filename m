Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7E42035D2
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgFVLhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgFVLhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:37:13 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11C7C061794;
        Mon, 22 Jun 2020 04:37:13 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 8AF115874A73E; Mon, 22 Jun 2020 13:37:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 83C1760C62D24;
        Mon, 22 Jun 2020 13:37:09 +0200 (CEST)
Date:   Mon, 22 Jun 2020 13:37:09 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
cc:     David Howells <dhowells@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Good idea to rename files in include/uapi/ ?
In-Reply-To: <ab88e504-c139-231a-0294-953ffd1a9442@al2klimov.de>
Message-ID: <nycvar.YFH.7.77.849.2006221336180.26495@n3.vanv.qr>
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de> <174102.1592165965@warthog.procyon.org.uk> <nycvar.YFH.7.77.849.2006142244200.30230@n3.vanv.qr> <ab88e504-c139-231a-0294-953ffd1a9442@al2klimov.de>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Monday 2020-06-15 01:34, Alexander A. Klimov wrote:
>> 
>> A header file rename is no problem. We even have dummy headers
> Hmm.. if I understand all of you correctly, David, Stefano, Pablo and Al say
> like no, not a good idea, but only you, Jan, say like should be no problem.
>
> Jan, do you have anything like commit messages in mainline or public emails
> from maintainers confirming your opinion?

I had already given the commit with the (email) message:

>> Just look at xt_MARK.h, all it does is include xt_mark.h. Cf.
>> 28b949885f80efb87d7cebdcf879c99db12c37bd .
