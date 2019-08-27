Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107A49F2AF
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfH0SvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:51:17 -0400
Received: from correo.us.es ([193.147.175.20]:37804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbfH0SvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 14:51:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A73ED27F8C7
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 20:51:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A62DDA840
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 20:51:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8F97BD1911; Tue, 27 Aug 2019 20:51:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 718E9DA801;
        Tue, 27 Aug 2019 20:51:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Aug 2019 20:51:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 42DA14265A5A;
        Tue, 27 Aug 2019 20:51:10 +0200 (CEST)
Date:   Tue, 27 Aug 2019 20:51:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190827185111.cgutfqkqwsufe2nl@salvia>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
 <20190827103541.vzwqwg4jlbuzajxu@salvia>
 <77c43754ff72e9a2e8048ccd032351cf0186080a.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77c43754ff72e9a2e8048ccd032351cf0186080a.camel@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 02:34:14PM -0300, Leonardo Bras wrote:
> On Tue, 2019-08-27 at 12:35 +0200, Pablo Neira Ayuso wrote:
[...]
> > NFT_BREAK instead to stop evaluating this rule, this results in a
> > mismatch, so you let the user decide what to do with packets that do
> > not match your policy.
>
> Ok, I will replace for v3.

Thanks.

> > The drop case at the bottom of the fib eval function never actually
> > never happens.
>
> Which one do you mean?

Line 31 of net/netfilter/nft_fib_inet.c.
