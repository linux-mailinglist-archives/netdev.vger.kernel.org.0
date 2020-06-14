Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7CF1F8B0B
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 00:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgFNWBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 18:01:08 -0400
Received: from correo.us.es ([193.147.175.20]:33346 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbgFNWBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 18:01:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD347FF909
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 00:01:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFCBBDA853
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 00:01:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B786BDA793; Mon, 15 Jun 2020 00:01:04 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79E35DA72F;
        Mon, 15 Jun 2020 00:01:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jun 2020 00:01:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1FBD4426CCBA;
        Mon, 15 Jun 2020 00:01:02 +0200 (CEST)
Date:   Mon, 15 Jun 2020 00:01:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     David Howells <dhowells@redhat.com>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
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
        linux-arch@vger.kernel.org
Subject: Re: Good idea to rename files in include/uapi/ ?
Message-ID: <20200614220101.GA9367@salvia>
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
 <174102.1592165965@warthog.procyon.org.uk>
 <nycvar.YFH.7.77.849.2006142244200.30230@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.77.849.2006142244200.30230@n3.vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 11:08:08PM +0200, Jan Engelhardt wrote:
> 
> On Sunday 2020-06-14 22:19, David Howells wrote:
> >Alexander A. Klimov <grandmaster@al2klimov.de> wrote:
> >
> >> *Is it a good idea to rename files in include/uapi/ ?*
> >
> >Very likely not.  If programs out there are going to be built on a
> >case-sensitive filesystem (which happens all the time), they're going to break
> >if you rename the headers.  We're kind of stuck with them.
> 
> Netfilter has precedent for removing old headers, e.g.
> 7200135bc1e61f1437dc326ae2ef2f310c50b4eb's ipt_ULOG.h.

That's only because NFLOG has been there for ~10 years, so it was safe
to remove ULOG support.
