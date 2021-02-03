Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66FB30E820
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhBCX7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:59:17 -0500
Received: from correo.us.es ([193.147.175.20]:58786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233392AbhBCX7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:59:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE033DED42
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 00:58:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD17FDA72F
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 00:58:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BFF25DA78B; Thu,  4 Feb 2021 00:58:29 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-106.1 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        FORGED_MUA_MOZILLA,NICE_REPLY_A,SMTPAUTH_US2,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7B45DA704;
        Thu,  4 Feb 2021 00:58:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Feb 2021 00:58:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 78B38426CC84;
        Thu,  4 Feb 2021 00:58:27 +0100 (CET)
Date:   Thu, 4 Feb 2021 00:58:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: remove redundant assignment of
 variable err
Message-ID: <20210203235827.GA21793@salvia>
References: <20210128175923.645865-1-colin.king@canonical.com>
 <20210203230421.GA18404@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203230421.GA18404@salvia>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 12:04:21AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 28, 2021 at 05:59:23PM +0000, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The variable err is being assigned a value that is never read,
> > the same error number is being returned at the error return
> > path via label err1.  Clean up the code by removing the assignment.
> 
> Applied to nf, thanks.

Sorry, I meant, nf-next
