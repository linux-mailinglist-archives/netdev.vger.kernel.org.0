Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BDFA95BD
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbfIDWES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:04:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDWES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:04:18 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDA9E15283820;
        Wed,  4 Sep 2019 15:04:16 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:04:11 -0700 (PDT)
Message-Id: <20190904.150411.1322734596741070592.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190904193646.23830-1-pablo@netfilter.org>
References: <20190904193646.23830-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:04:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed,  4 Sep 2019 21:36:41 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) br_netfilter drops IPv6 packets if ipv6 is disabled, from Leonardo Bras.
> 
> 2) nft_socket hits BUG() due to illegal skb->sk caching, patch from
>    Fernando Fernandez Mancera.
> 
> 3) nft_fib_netdev could be called with ipv6 disabled, leading to crash
>    in the fib lookup, also from Leonardo.
> 
> 4) ctnetlink honors IPS_OFFLOAD flag, just like nf_conntrack sysctl does.
> 
> 5) Properly set up flowtable entry timeout, otherwise immediate
>    removal by garbage collector might occur.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
