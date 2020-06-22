Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A13203EBF
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgFVSG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:06:29 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:56972 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730099AbgFVSG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:06:29 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id D4F60467DC;
        Mon, 22 Jun 2020 18:06:20 +0000 (UTC)
Subject: Re: Good idea to rename files in include/uapi/ ?
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     David Howells <dhowells@redhat.com>,
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
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
 <174102.1592165965@warthog.procyon.org.uk>
 <nycvar.YFH.7.77.849.2006142244200.30230@n3.vanv.qr>
 <ab88e504-c139-231a-0294-953ffd1a9442@al2klimov.de>
 <nycvar.YFH.7.77.849.2006221336180.26495@n3.vanv.qr>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <482bbfe2-77c7-226c-98a9-d6505866123a@al2klimov.de>
Date:   Mon, 22 Jun 2020 20:06:19 +0200
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.77.849.2006221336180.26495@n3.vanv.qr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spamd-Bar: ++
X-Spam-Level: **
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 22.06.20 um 13:37 schrieb Jan Engelhardt:
> 
> On Monday 2020-06-15 01:34, Alexander A. Klimov wrote:
>>>
>>> A header file rename is no problem. We even have dummy headers
>> Hmm.. if I understand all of you correctly, David, Stefano, Pablo and Al say
>> like no, not a good idea, but only you, Jan, say like should be no problem.
>>
>> Jan, do you have anything like commit messages in mainline or public emails
>> from maintainers confirming your opinion?
> 
> I had already given the commit with the (email) message:
> 
>>> Just look at xt_MARK.h, all it does is include xt_mark.h. Cf.
>>> 28b949885f80efb87d7cebdcf879c99db12c37bd .
In that commit no .h file disappeared.
