Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780DD1B2521
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 13:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgDULc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 07:32:26 -0400
Received: from correo.us.es ([193.147.175.20]:40626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgDULcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 07:32:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99B87F2593
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 13:32:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C8A6100A47
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 13:32:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77358100A44; Tue, 21 Apr 2020 13:32:23 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 845C5FF6EF;
        Tue, 21 Apr 2020 13:32:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Apr 2020 13:32:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6056742EF42B;
        Tue, 21 Apr 2020 13:32:21 +0200 (CEST)
Date:   Tue, 21 Apr 2020 13:32:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Stefano Brivio <sbrivio@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set
 back-ends to report partial overlaps on insertion
Message-ID: <20200421113221.rvh3jkjet32m6ng4@salvia>
References: <20200407000058.16423-1-sashal@kernel.org>
 <20200407000058.16423-27-sashal@kernel.org>
 <20200407021848.626df832@redhat.com>
 <20200413163900.GO27528@sasha-vm>
 <20200413223858.17b0f487@redhat.com>
 <20200414150840.GD1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414150840.GD1068@sasha-vm>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Tue, Apr 14, 2020 at 11:08:40AM -0400, Sasha Levin wrote:
> On Mon, Apr 13, 2020 at 10:38:58PM +0200, Stefano Brivio wrote:
> > On Mon, 13 Apr 2020 12:39:00 -0400
> > Sasha Levin <sashal@kernel.org> wrote:
> > 
> > > On Tue, Apr 07, 2020 at 02:18:48AM +0200, Stefano Brivio wrote:
> > > 
> > > >I'm used to not Cc: stable on networking patches (Dave's net.git),
> > > >but I guess I should instead if they go through nf.git (Pablo's tree),
> > > >right?
> > > 
> > > Yup, this confusion has caused for quite a few netfilter fixes to not
> > > land in -stable. If it goes through Pablo's tree (and unless he intructs
> > > otherwise), you should Cc stable.
> > 
> > Hah, thanks for clarifying.
> > 
> > What do you think I should do specifically with 72239f2795fa
> > ("netfilter: nft_set_rbtree: Drop spurious condition for overlap detection
> > on insertion")?
> > 
> > I haven't Cc'ed stable on that one. Can I expect AUTOSEL to pick it up
> > anyway?
> 
> I'll make sure it gets queued up when it hits Linus's tree :)

5.6.6 is out and this fix is still not included...

Would you please enqueue...

commit 72239f2795fab9a58633bd0399698ff7581534a3
Author: Stefano Brivio <sbrivio@redhat.com>
Date:   Wed Apr 1 17:14:38 2020 +0200

    netfilter: nft_set_rbtree: Drop spurious condition for overlap detection on insertion

for 5.6.x -stable ?

Thank you very much.
