Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42ED73AD6F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387472AbfFJDKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:10:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387400AbfFJDKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 23:10:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBF5710004783;
        Sun,  9 Jun 2019 20:10:31 -0700 (PDT)
Date:   Sun, 09 Jun 2019 20:10:31 -0700 (PDT)
Message-Id: <20190609.201031.2069013389367638475.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] ipv6: tcp: send consistent autoflowlabel in
 TIME_WAIT state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190609005851.32243-1-edumazet@google.com>
References: <20190609005851.32243-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 20:10:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  8 Jun 2019 17:58:51 -0700

> In case autoflowlabel is in action, skb_get_hash_flowi6()
> derives a non zero skb->hash to the flowlabel.
> 
> If skb->hash is zero, a flow dissection is performed.
> 
> Since all TCP skbs sent from ESTABLISH state inherit their
> skb->hash from sk->sk_txhash, we better keep a copy
> of sk->sk_txhash into the TIME_WAIT socket.
> 
> After this patch, ACK or RST packets sent on behalf of
> a TIME_WAIT socket have the flowlabel that was previously
> used by the flow.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
