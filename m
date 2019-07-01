Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9AF25164
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfEUOCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:02:10 -0400
Received: from mail.us.es ([193.147.175.20]:53368 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfEUOCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 10:02:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CA9E103253
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:02:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E643DA707
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:02:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74736DA717; Tue, 21 May 2019 16:02:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59D4CDA707;
        Tue, 21 May 2019 16:02:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 May 2019 16:02:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.195.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 208D24265A31;
        Tue, 21 May 2019 16:02:04 +0200 (CEST)
Date:   Tue, 21 May 2019 16:02:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jagdish Motwani <j.k.motwani@gmail.com>
Cc:     netdev@vger.kernel.org,
        Jagdish Motwani <jagdish.motwani@sophos.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] netfilter: nf_queue:fix reinject verdict handling
Message-ID: <20190521140202.yjqjygtw3l36pi6h@salvia>
References: <20190513181740.5929-1-j.k.motwani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513181740.5929-1-j.k.motwani@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 11:47:40PM +0530, Jagdish Motwani wrote:
> From: Jagdish Motwani <jagdish.motwani@sophos.com>
> 
> This patch fixes netfilter hook traversal when there are more than 1 hooks
> returning NF_QUEUE verdict. When the first queue reinjects the packet,
> 'nf_reinject' starts traversing hooks with a proper hook_index. However,
> if it again receives a NF_QUEUE verdict (by some other netfilter hook), it
> queues the packet with a wrong hook_index. So, when the second queue 
> reinjects the packet, it re-executes hooks in between.

Applied, thanks.
