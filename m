Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F16194032
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgCZNqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:46:35 -0400
Received: from correo.us.es ([193.147.175.20]:41802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbgCZNqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:46:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 051E1F2586
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:46:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EAE13DA3AE
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:46:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DAC8CDA38F; Thu, 26 Mar 2020 14:46:30 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 19A27DA3A4;
        Thu, 26 Mar 2020 14:46:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Mar 2020 14:46:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EBE1F42EF4E0;
        Thu, 26 Mar 2020 14:46:28 +0100 (CET)
Date:   Thu, 26 Mar 2020 14:46:28 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Qian Cai <cai@lca.pw>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter/nf_tables: silence a RCU-list warning
Message-ID: <20200326134628.4eluovllshxidcuu@salvia>
References: <20200325143142.6955-1-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325143142.6955-1-cai@lca.pw>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:31:42AM -0400, Qian Cai wrote:
> It is safe to traverse &net->nft.tables with &net->nft.commit_mutex
> held using list_for_each_entry_rcu(). Silence the PROVE_RCU_LIST false
> positive,
> 
> WARNING: suspicious RCU usage
> net/netfilter/nf_tables_api.c:523 RCU-list traversed in non-reader section!!

Applied, thanks.
