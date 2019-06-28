Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA25A5F9
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfF1Ug6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:36:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51470 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfF1Ug6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:36:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48C811340AFCE;
        Fri, 28 Jun 2019 13:36:58 -0700 (PDT)
Date:   Fri, 28 Jun 2019 13:36:57 -0700 (PDT)
Message-Id: <20190628.133657.1483641750948631630.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Netfilter/IPVS fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628174125.20739-1-pablo@netfilter.org>
References: <20190628174125.20739-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 13:36:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 28 Jun 2019 19:41:21 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix memleak reported by syzkaller when registering IPVS hooks,
>    patch from Julian Anastasov.
> 
> 2) Fix memory leak in start_sync_thread, also from Julian.
> 
> 3) Fix conntrack deletion via ctnetlink, from Felix Kaechele.
> 
> 4) Fix reject for ICMP due to incorrect checksum handling, from
>    He Zhe.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
