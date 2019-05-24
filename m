Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177622948C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbfEXJWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:22:55 -0400
Received: from mail.us.es ([193.147.175.20]:37688 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389732AbfEXJWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:22:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C05F10FB07
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:22:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D2CFDA709
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:22:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5B54EDA716; Fri, 24 May 2019 11:22:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0361CDA709;
        Fri, 24 May 2019 11:22:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 May 2019 11:22:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D1D9340705C6;
        Fri, 24 May 2019 11:22:49 +0200 (CEST)
Date:   Fri, 24 May 2019 11:22:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
Message-ID: <20190524092249.7gatc643noc27qzp@salvia>
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <20190505223229.3ujqpwmuefd3wh7b@salvia>
 <4ecbebbb-0a7f-6d45-c2c0-00dee746e573@6wind.com>
 <20190506131605.kapyns6gkyphbea2@salvia>
 <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 10:35:07AM +0200, Nicolas Dichtel wrote:
> Le 06/05/2019 à 15:16, Pablo Neira Ayuso a écrit :
> > On Mon, May 06, 2019 at 10:49:52AM +0200, Nicolas Dichtel wrote:
> [snip]
> >> Is it possible to queue this for stable?
> > 
> > Sure, as soon as this hits Linus' tree.
> > 
> FYI, it's now in Linus tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8e608982022

Please, send an email requesting this to stable@vger.kernel.org and
keep me on CC.

I'll ACK it.

Thanks.
