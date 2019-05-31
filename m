Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69ADE30B10
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfEaJGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:06:17 -0400
Received: from mail.us.es ([193.147.175.20]:55766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbfEaJGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:06:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BB0F10324B
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:06:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D8D5DA709
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:06:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5D681DA71A; Fri, 31 May 2019 11:06:15 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37E7DDA701;
        Fri, 31 May 2019 11:06:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 11:06:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EA5E14265A31;
        Fri, 31 May 2019 11:06:12 +0200 (CEST)
Date:   Fri, 31 May 2019 11:06:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sfr@canb.auug.org.au,
        yuehaibing@huawei.com, lkp@intel.com, wenxu@ucloud.cn
Subject: Re: [PATCH net-next] netfilter: missing #include for
 nf_ct_frag6_gather declaration
Message-ID: <20190531090612.gfnbhada53obehsk@salvia>
References: <20190531081143.21446-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531081143.21446-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc wenxu@ucloud.cn

On Fri, May 31, 2019 at 10:11:43AM +0200, Pablo Neira Ayuso wrote:
> In file included from net/netfilter/utils.c:5:
> include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
> include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather'; did you mean 'nf_ct_attach'? [-Werror=implicit-function-declaration]
>   return nf_ct_frag6_gather(net, skb, user);
>          ^~~~~~~~~~~~~~~~~~

Please, toss this patch, I'll send a new version including a chunk
from wenxu.
