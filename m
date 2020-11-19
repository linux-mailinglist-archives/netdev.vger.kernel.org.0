Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A50F2B93B3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgKSNcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:32:43 -0500
Received: from correo.us.es ([193.147.175.20]:58490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgKSNcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 08:32:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A82E1F0CED
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:32:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 692E9114D8B
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:32:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5E6F8114D7F; Thu, 19 Nov 2020 14:32:42 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D53F114D67;
        Thu, 19 Nov 2020 14:32:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Nov 2020 14:32:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D775942EF4E1;
        Thu, 19 Nov 2020 14:32:39 +0100 (CET)
Date:   Thu, 19 Nov 2020 14:32:39 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, rdunlap@infradead.org
Subject: Re: [PATCH net v2] ipv6: Remove dependency of
 ipv6_frag_thdr_truncated on ipv6 module
Message-ID: <20201119133239.GA22069@salvia>
References: <20201119095833.8409-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201119095833.8409-1-geokohma@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 10:58:33AM +0100, Georg Kohmann wrote:
> IPV6=m
> NF_DEFRAG_IPV6=y
> 
> ld: net/ipv6/netfilter/nf_conntrack_reasm.o: in function
> `nf_ct_frag6_gather':
> net/ipv6/netfilter/nf_conntrack_reasm.c:462: undefined reference to
> `ipv6_frag_thdr_truncated'
> 
> Netfilter is depending on ipv6 symbol ipv6_frag_thdr_truncated. This
> dependency is forcing IPV6=y.
> 
> Remove this dependency by moving ipv6_frag_thdr_truncated out of ipv6. This
> is the same solution as used with a similar issues: Referring to
> commit 70b095c843266 ("ipv6: remove dependency of nf_defrag_ipv6 on ipv6
> module")
> 
> Fixes: 9d9e937b1c8b ("ipv6/netfilter: Discard first fragment not including all headers")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
