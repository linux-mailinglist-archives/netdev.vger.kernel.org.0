Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665CF1FA16F
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgFOU1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728870AbgFOU1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:27:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C94BC061A0E;
        Mon, 15 Jun 2020 13:27:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CB5E120ED49A;
        Mon, 15 Jun 2020 13:27:32 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:27:31 -0700 (PDT)
Message-Id: <20200615.132731.469724783738296084.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/4] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200614215301.9101-1-pablo@netfilter.org>
References: <20200614215301.9101-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:27:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 14 Jun 2020 23:52:57 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix bogus EEXIST on element insertions to the rbtree with timeouts,
>    from Stefano Brivio.
> 
> 2) Preempt BUG splat in the pipapo element insertion path, also from
>    Stefano.
> 
> 3) Release filter from the ctnetlink error path.
> 
> 4) Release flowtable hooks from the deletion path.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
