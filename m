Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3568F624
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 23:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbfHOVCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 17:02:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOVCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 17:02:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9100314049755;
        Thu, 15 Aug 2019 14:02:17 -0700 (PDT)
Date:   Thu, 15 Aug 2019 14:02:17 -0700 (PDT)
Message-Id: <20190815.140217.47364101504540637.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814092440.20087-1-pablo@netfilter.org>
References: <20190814092440.20087-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 14:02:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 14 Aug 2019 11:24:33 +0200

> This patchset contains Netfilter fixes for net:
> 
> 1) Extend selftest to cover flowtable with ipsec, from Florian Westphal.
> 
> 2) Fix interaction of ipsec with flowtable, also from Florian.
> 
> 3) User-after-free with bound set to rule that fails to load.
> 
> 4) Adjust state and timeout for flows that expire.
> 
> 5) Timeout update race with flows in teardown state.
> 
> 6) Ensure conntrack id hash calculation use invariants as input,
>    from Dirk Morris.
> 
> 7) Do not push flows into flowtable for TCP fin/rst packets.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
