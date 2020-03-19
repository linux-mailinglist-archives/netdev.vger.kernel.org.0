Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A02B18AA6E
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 02:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgCSBpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 21:45:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgCSBpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 21:45:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B4CF815717BEF;
        Wed, 18 Mar 2020 18:45:33 -0700 (PDT)
Date:   Wed, 18 Mar 2020 18:45:31 -0700 (PDT)
Message-Id: <20200318.184531.2286126098336198373.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ast@kernel.org
Subject: Re: [PATCH net-next] netfilter: revert introduction of egress hook
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
References: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 18:45:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Wed, 18 Mar 2020 10:33:22 +0100

> This reverts the following commits:
> 
>   8537f78647c0 ("netfilter: Introduce egress hook")
>   5418d3881e1f ("netfilter: Generalize ingress hook")
>   b030f194aed2 ("netfilter: Rename ingress hook include file")
> 
> From the discussion in [0], the author's main motivation to add a hook
> in fast path is for an out of tree kernel module, which is a red flag
> to begin with. Other mentioned potential use cases like NAT{64,46}
> is on future extensions w/o concrete code in the tree yet. Revert as
> suggested [1] given the weak justification to add more hooks to critical
> fast-path.
> 
>   [0] https://lore.kernel.org/netdev/cover.1583927267.git.lukas@wunner.de/
>   [1] https://lore.kernel.org/netdev/20200318.011152.72770718915606186.davem@davemloft.net/
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Applied, this definitely needs more discussion.

Thanks Daniel.
