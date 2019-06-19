Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558614B6E5
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 13:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731570AbfFSLRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 07:17:17 -0400
Received: from mail.us.es ([193.147.175.20]:32974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfFSLRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 07:17:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 148EB2519C5
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 13:17:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05851DA70B
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 13:17:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E6B63DA729; Wed, 19 Jun 2019 13:17:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E510BDA707;
        Wed, 19 Jun 2019 13:17:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 13:17:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B27494265A32;
        Wed, 19 Jun 2019 13:17:12 +0200 (CEST)
Date:   Wed, 19 Jun 2019 13:17:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH v5] extensions: libxt_owner: Add supplementary groups
 option
Message-ID: <20190619111712.vcww4uxqk3k7aegq@salvia>
References: <CGME20190610105906eucas1p1a1e124ea55dd97bc7400b5504002e41c@eucas1p1.samsung.com>
 <20190610105856.31754-1-l.pawelczyk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610105856.31754-1-l.pawelczyk@samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 12:58:56PM +0200, Lukasz Pawelczyk wrote:
> The --suppl-groups option causes GIDs specified with --gid-owner to be
> also checked in the supplementary groups of a process.

Applied, thanks.
