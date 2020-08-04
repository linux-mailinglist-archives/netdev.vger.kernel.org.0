Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764FE23C0C7
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgHDUc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgHDUc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:32:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AD0C06174A;
        Tue,  4 Aug 2020 13:32:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1F5E128824A2;
        Tue,  4 Aug 2020 13:16:11 -0700 (PDT)
Date:   Tue, 04 Aug 2020 13:32:56 -0700 (PDT)
Message-Id: <20200804.133256.752889085723331557.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804200208.18620-1-pablo@netfilter.org>
References: <20200804200208.18620-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 13:16:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue,  4 Aug 2020 22:02:03 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Flush the cleanup xtables worker to make sure destructors
>    have completed, from Florian Westphal.
> 
> 2) iifgroup is matching erroneously, also from Florian.
> 
> 3) Add selftest for meta interface matching, from Florian Westphal.
> 
> 4) Move nf_ct_offload_timeout() to header, from Roi Dayan.
> 
> 5) Call nf_ct_offload_timeout() from flow_offload_add() to
>    make sure garbage collection does not evict offloaded flow,
>    from Roi Dayan.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
