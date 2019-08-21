Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23539768F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfHUJ6u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 05:58:50 -0400
Received: from correo.us.es ([193.147.175.20]:46170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbfHUJ6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 05:58:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 362E5BA1B6
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 11:58:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27AEC5B3
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 11:58:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1947CB7FFE; Wed, 21 Aug 2019 11:58:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DA74B7FF6;
        Wed, 21 Aug 2019 11:58:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 21 Aug 2019 11:58:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.43.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C0F5F4265A2F;
        Wed, 21 Aug 2019 11:58:44 +0200 (CEST)
Date:   Wed, 21 Aug 2019 11:58:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190821095844.me6kscvnfruinseu@salvia>
References: <20190820005821.2644-1-leonardo@linux.ibm.com>
 <20190820053607.GL2588@breakpoint.cc>
 <793ce2e9b6200a033d44716749acc837aaf5e4e7.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <793ce2e9b6200a033d44716749acc837aaf5e4e7.camel@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 01:15:58PM -0300, Leonardo Bras wrote:
> On Tue, 2019-08-20 at 07:36 +0200, Florian Westphal wrote:
> > Wouldn't fib_netdev.c have the same problem?
> Probably, but I haven't hit this issue yet.
> 
> > If so, might be better to place this test in both
> > nft_fib6_eval_type and nft_fib6_eval.
>
> I think that is possible, and not very hard to do.
> 
> But in my humble viewpoint, it looks like it's nft_fib_inet_eval() and
> nft_fib_netdev_eval() have the responsibility to choose a valid
> protocol or drop the package. 
> I am not sure if it would be a good move to transfer this
> responsibility to nft_fib6_eval_type() and nft_fib6_eval(), so I would
> rather add the same test to nft_fib_netdev_eval().
> 
> Does it make sense?

Please, update common code to netdev and ip6 extensions as Florian
suggests.

Thanks.
