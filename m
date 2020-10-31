Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0312A1246
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgJaBAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:00:09 -0400
Received: from correo.us.es ([193.147.175.20]:35674 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaBAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 21:00:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF1FB508CDA
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 02:00:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C090EDA78A
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 02:00:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B6419DA73F; Sat, 31 Oct 2020 02:00:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CCAFDA704;
        Sat, 31 Oct 2020 02:00:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 02:00:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4ED9742EF42A;
        Sat, 31 Oct 2020 02:00:04 +0100 (CET)
Date:   Sat, 31 Oct 2020 02:00:03 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH nf 0/2] route_me_harder routing loop with tunnels
Message-ID: <20201031010003.GA27601@salvia>
References: <20201029025606.3523771-1-Jason@zx2c4.com>
 <20201030192301.GA19199@salvia>
 <CAHmME9qs0h6SaKFrDR18wH2=vCBC9YpOKCBnZzbjQb69SEDB0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9qs0h6SaKFrDR18wH2=vCBC9YpOKCBnZzbjQb69SEDB0g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 01:05:03AM +0100, Jason A. Donenfeld wrote:
> On Fri, Oct 30, 2020 at 8:23 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Thu, Oct 29, 2020 at 03:56:04AM +0100, Jason A. Donenfeld wrote:
> > > Hi Pablo,
> > >
> > > This series fixes a bug in the route_me_harder family of functions with
> > > regards to tunnel interfaces. The first patch contains an addition to
> > > the wireguard test suite; I normally send my wireguard patches through
> > > Dave's tree, but I thought it'd be nice to send these together here
> > > because the test case is illustrative of the issue. The second patch
> > > then fixes the issue with a lengthy explanation of what's going on.
> > >
> > > These are intended for net.git/nf.git, not the -next variety, and to
> > > eventually be backported to stable. So, the second patch has a proper
> > > Fixes: line on it to help with that.
> >
> > Series applied, thanks.
> 
> To nf.git?

Yes.

> Did you forget to git-push perhaps?

I usually take a little time to compile test and run tests before
pushing it out.
