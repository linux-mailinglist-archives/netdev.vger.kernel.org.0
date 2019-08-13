Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900ED8B4B6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 11:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfHMJ5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 05:57:02 -0400
Received: from correo.us.es ([193.147.175.20]:34990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbfHMJ5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 05:57:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ABB95FC5F2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:56:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D866202D0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:56:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 898A71150DF; Tue, 13 Aug 2019 11:56:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 821DA1150DD;
        Tue, 13 Aug 2019 11:56:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 11:56:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 557474265A2F;
        Tue, 13 Aug 2019 11:56:56 +0200 (CEST)
Date:   Tue, 13 Aug 2019 11:56:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netfilter - add missing prototypes.
Message-ID: <20190813095655.qkitgdvfeyuhy4ga@salvia>
References: <54079.1565242088@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54079.1565242088@turing-police>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 01:28:08AM -0400, Valdis Klētnieks wrote:
> Sparse rightly complains about undeclared symbols.
> 
>   CHECK   net/netfilter/nft_set_hash.c
> net/netfilter/nft_set_hash.c:647:21: warning: symbol 'nft_set_rhash_type' was not declared. Should it be static?
> net/netfilter/nft_set_hash.c:670:21: warning: symbol 'nft_set_hash_type' was not declared. Should it be static?
> net/netfilter/nft_set_hash.c:690:21: warning: symbol 'nft_set_hash_fast_type' was not declared. Should it be static?
>   CHECK   net/netfilter/nft_set_bitmap.c
> net/netfilter/nft_set_bitmap.c:296:21: warning: symbol 'nft_set_bitmap_type' was not declared. Should it be static?
>   CHECK   net/netfilter/nft_set_rbtree.c
> net/netfilter/nft_set_rbtree.c:470:21: warning: symbol 'nft_set_rbtree_type' was not declared. Should it be static?
> 
> Include nf_tables_core.h rather than nf_tables.h to pick up the additional definitions.

Applied, thanks.
