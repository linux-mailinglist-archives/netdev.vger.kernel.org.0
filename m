Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34607203669
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgFVMHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:07:17 -0400
Received: from correo.us.es ([193.147.175.20]:46830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgFVMHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 08:07:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA15DF23D7
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 14:07:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7738DA874
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 14:07:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D5E74DA86C; Mon, 22 Jun 2020 14:07:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F81EDA8FA;
        Mon, 22 Jun 2020 14:07:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Jun 2020 14:07:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E619642EF4FB;
        Mon, 22 Jun 2020 14:07:07 +0200 (CEST)
Date:   Mon, 22 Jun 2020 14:07:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        David Howells <dhowells@redhat.com>,
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
Message-ID: <20200622120707.GA17620@salvia>
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
 <174102.1592165965@warthog.procyon.org.uk>
 <nycvar.YFH.7.77.849.2006142244200.30230@n3.vanv.qr>
 <ab88e504-c139-231a-0294-953ffd1a9442@al2klimov.de>
 <nycvar.YFH.7.77.849.2006221336180.26495@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.77.849.2006221336180.26495@n3.vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 01:37:09PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2020-06-15 01:34, Alexander A. Klimov wrote:
> >> 
> >> A header file rename is no problem. We even have dummy headers
> > Hmm.. if I understand all of you correctly, David, Stefano, Pablo and Al say
> > like no, not a good idea, but only you, Jan, say like should be no problem.
> >
> > Jan, do you have anything like commit messages in mainline or public emails
> > from maintainers confirming your opinion?
> 
> I had already given the commit with the (email) message:
> 
> >> Just look at xt_MARK.h, all it does is include xt_mark.h. Cf.
> >> 28b949885f80efb87d7cebdcf879c99db12c37bd .

Why rename this in 2020 ?

