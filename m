Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109301D3ECB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgENUPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgENUPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:15:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3145C061A0C;
        Thu, 14 May 2020 13:15:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B048128D72F1;
        Thu, 14 May 2020 13:15:48 -0700 (PDT)
Date:   Thu, 14 May 2020 13:15:47 -0700 (PDT)
Message-Id: <20200514.131547.50336916690992369.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514121913.24519-1-pablo@netfilter.org>
References: <20200514121913.24519-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:15:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 14 May 2020 14:19:07 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix gcc-10 compilation warning in nf_conntrack, from Arnd Bergmann.
> 
> 2) Add NF_FLOW_HW_PENDING to avoid races between stats and deletion
>    commands, from Paul Blakey.
> 
> 3) Remove WQ_MEM_RECLAIM from the offload workqueue, from Roi Dayan.
> 
> 4) Infinite loop when removing nf_conntrack module, from Florian Westphal.
> 
> 5) Set NF_FLOW_TEARDOWN bit on expiration to avoid races when refreshing
>    the timeout from the software path.
> 
> 6) Missing nft_set_elem_expired() check in the rbtree, from Phil Sutter.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
