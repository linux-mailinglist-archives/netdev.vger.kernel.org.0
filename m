Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B1D18DDAA
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 03:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgCUChZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 22:37:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgCUChY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 22:37:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2D2C158C4C2C;
        Fri, 20 Mar 2020 19:37:23 -0700 (PDT)
Date:   Fri, 20 Mar 2020 19:37:23 -0700 (PDT)
Message-Id: <20200320.193723.1208553586790382517.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net] tcp: also NULL skb->dev when copy was needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320155202.25719-1-fw@strlen.de>
References: <20200320155202.25719-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Mar 2020 19:37:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 20 Mar 2020 16:52:02 +0100

> In rare cases retransmit logic will make a full skb copy, which will not
> trigger the zeroing added in recent change
> b738a185beaa ("tcp: ensure skb->dev is NULL before leaving TCP stack").
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
> Fixes: 28f8bfd1ac94 ("netfilter: Support iif matches in POSTROUTING")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied and queued up for -stable.
