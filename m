Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECC630B45
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEaJUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:20:48 -0400
Received: from mail.us.es ([193.147.175.20]:38348 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfEaJUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:20:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2822F114569
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:20:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16CE7DA70D
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:20:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0BC2CDA70A; Fri, 31 May 2019 11:20:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 999DFDA707;
        Fri, 31 May 2019 11:20:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 11:20:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7521140705C3;
        Fri, 31 May 2019 11:20:43 +0200 (CEST)
Date:   Fri, 31 May 2019 11:20:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: ipv6: fix compile err unknown field
 br_defrag and br_fragment
Message-ID: <20190531092043.wnfyyfdydemvamx3@salvia>
References: <1559293375-14385-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559293375-14385-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, May 31, 2019 at 05:02:55PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> When CONFIG_IPV6 is not build with modules and CONIFG_NF_CONNTRACK_BRIDGE=m
> There will compile err:
> net/ipv6/netfilter.c:242:2: error: unknown field 'br_defrag' specified in initializer
>   .br_defrag  = nf_ct_frag6_gather,
> net/ipv6/netfilter.c:243:2: error: unknown field 'br_fragment' specified in initializer
>   .br_fragment  = br_ip6_fragment,

Thanks for your patch, I have collapsed this chunk into:

http://patchwork.ozlabs.org/patch/1108255/
