Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF033145F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfEaSEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:04:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfEaSEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:04:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6307814FC66CE;
        Fri, 31 May 2019 11:04:42 -0700 (PDT)
Date:   Fri, 31 May 2019 11:04:41 -0700 (PDT)
Message-Id: <20190531.110441.284528190617162357.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        wenxu@ucloud.cn, sfr@canb.auug.org.au, yuehaibing@huawei.com,
        lkp@intel.com
Subject: Re: [PATCH] netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531091124.26822-1-pablo@netfilter.org>
References: <20190531091124.26822-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 11:04:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 31 May 2019 11:11:24 +0200

> This patch fixes a few problems with CONFIG_IPV6=y and
> CONFIG_NF_CONNTRACK_BRIDGE=m:
> 
> In file included from net/netfilter/utils.c:5:
> include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
> include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather'; did you mean 'nf_ct_attach'? [-Werror=implicit-function-declaration]
> 
> And these too:
> 
> net/ipv6/netfilter.c:242:2: error: unknown field 'br_defrag' specified in initializer
> net/ipv6/netfilter.c:243:2: error: unknown field 'br_fragment' specified in initializer
> 
> This patch includes an original chunk from wenxu.
> 
> Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied.
