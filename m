Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C831E1E2FCA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 22:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390569AbgEZUK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 16:10:28 -0400
Received: from correo.us.es ([193.147.175.20]:51868 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390075AbgEZUK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 16:10:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5D626172C86
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 22:10:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E948DA714
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 22:10:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4CFA4DA713; Tue, 26 May 2020 22:10:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 431F2DA715;
        Tue, 26 May 2020 22:10:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 May 2020 22:10:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 24D2D42EF42A;
        Tue, 26 May 2020 22:10:24 +0200 (CEST)
Date:   Tue, 26 May 2020 22:10:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Miller <davem@davemloft.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
Message-ID: <20200526201023.GA26232@salvia>
References: <20200525215420.2290-1-pablo@netfilter.org>
 <20200525.182901.536565434439717149.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525.182901.536565434439717149.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 06:29:01PM -0700, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Mon, 25 May 2020 23:54:15 +0200
> 
> > The following patchset contains Netfilter fixes for net:
> > 
> > 1) Set VLAN tag in tcp reset/icmp unreachable packets to reject
> >    connections in the bridge family, from Michael Braun.
> > 
> > 2) Incorrect subcounter flag update in ipset, from Phil Sutter.
> > 
> > 3) Possible buffer overflow in the pptp conntrack helper, based
> >    on patch from Dan Carpenter.
> > 
> > 4) Restore userspace conntrack helper hook logic that broke after
> >    hook consolidation rework.
> > 
> > 5) Unbreak userspace conntrack helper registration via
> >    nfnetlink_cthelper.
> > 
> > You can pull these changes from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
> 
> Pulled, thank you.

If it's still possible, it would be good to toss this pull request.

Otherwise, I will send another pull request to address the kbuild
reports.

Thank you.
