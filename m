Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E664202006
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbgFTDHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 23:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732258AbgFTDHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 23:07:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C155C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 20:07:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E79B12784D31;
        Fri, 19 Jun 2020 20:07:15 -0700 (PDT)
Date:   Fri, 19 Jun 2020 20:07:14 -0700 (PDT)
Message-Id: <20200619.200714.837952746007469629.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com
Subject: Re: [PATCH net] geneve: allow changing DF behavior after creation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3b72fc01841507f8439a90f618ef6f6240b9463f.1592473442.git.sd@queasysnail.net>
References: <3b72fc01841507f8439a90f618ef6f6240b9463f.1592473442.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 20:07:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Thu, 18 Jun 2020 12:13:22 +0200

> Currently, trying to change the DF parameter of a geneve device does
> nothing:
> 
>     # ip -d link show geneve1
>     14: geneve1: <snip>
>         link/ether <snip>
>         geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
>     # ip link set geneve1 type geneve id 1 df unset
>     # ip -d link show geneve1
>     14: geneve1: <snip>
>         link/ether <snip>
>         geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
> 
> We just need to update the value in geneve_changelink.
> 
> Fixes: a025fb5f49ad ("geneve: Allow configuration of DF behaviour")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied and queued up for -stable, thanks.
