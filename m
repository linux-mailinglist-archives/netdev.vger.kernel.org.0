Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76BF3489E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfFDN0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:26:10 -0400
Received: from mail.us.es ([193.147.175.20]:36492 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfFDN0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 09:26:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E4C6FB369
        for <netdev@vger.kernel.org>; Tue,  4 Jun 2019 15:26:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E948DA702
        for <netdev@vger.kernel.org>; Tue,  4 Jun 2019 15:26:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 01575DA70B; Tue,  4 Jun 2019 15:26:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2514DA702;
        Tue,  4 Jun 2019 15:26:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Jun 2019 15:26:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AEC084265A32;
        Tue,  4 Jun 2019 15:26:05 +0200 (CEST)
Date:   Tue, 4 Jun 2019 15:26:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] netfilter: ipv6: nf_defrag: fix leakage of unqueued
 fragments
Message-ID: <20190604132605.jlhxljrzaqkw4f2j@salvia>
References: <51d82a9bd6312e51a56ccae54e00452a0ef957dd.1559480671.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51d82a9bd6312e51a56ccae54e00452a0ef957dd.1559480671.git.gnault@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 03:13:47PM +0200, Guillaume Nault wrote:
> With commit 997dd9647164 ("net: IP6 defrag: use rbtrees in
> nf_conntrack_reasm.c"), nf_ct_frag6_reasm() is now called from
> nf_ct_frag6_queue(). With this change, nf_ct_frag6_queue() can fail
> after the skb has been added to the fragment queue and
> nf_ct_frag6_gather() was adapted to handle this case.

Applied, thanks.
