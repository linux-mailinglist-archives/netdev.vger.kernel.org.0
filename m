Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83C82D511A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgLJC7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 21:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgLJC7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 21:59:53 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDE1C0613CF;
        Wed,  9 Dec 2020 18:59:13 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 52F7C4D259C1A;
        Wed,  9 Dec 2020 18:59:13 -0800 (PST)
Date:   Wed, 09 Dec 2020 18:59:12 -0800 (PST)
Message-Id: <20201209.185912.732747722425337247.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH net 0/4] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209221810.32504-1-pablo@netfilter.org>
References: <20201209221810.32504-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 18:59:13 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed,  9 Dec 2020 23:18:06 +0100

> Hi Jakub, David,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Switch to RCU in x_tables to fix possible NULL pointer dereference,
>    from Subash Abhinov Kasiviswanathan.
> 
> 2) Fix netlink dump of dynset timeouts later than 23 days.
> 
> 3) Add comment for the indirect serialization of the nft commit mutex
>    with rtnl_mutex.
> 
> 4) Remove bogus check for confirmed conntrack when matching on the
>    conntrack ID, from Brett Mastbergen.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
> 

Pulled, thanks.
