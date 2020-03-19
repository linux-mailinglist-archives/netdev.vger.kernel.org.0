Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEBA18AA7A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 02:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgCSByz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 21:54:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33800 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgCSByz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 21:54:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 314ED15720BBA;
        Wed, 18 Mar 2020 18:54:55 -0700 (PDT)
Date:   Wed, 18 Mar 2020 18:54:54 -0700 (PDT)
Message-Id: <20200318.185454.2276380590236986388.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] wireguard fixes for 5.6-rc7
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319003047.113501-1-Jason@zx2c4.com>
References: <20200319003047.113501-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 18:54:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 18 Mar 2020 18:30:42 -0600

> I originally intended to spend this cycle working on fun optimizations
> and architecture for WireGuard for 5.7, but I've been a bit neurotic
> about having 5.6 ship without any show stopper bugs. WireGuard has been
> stable for a long time now, but that doesn't make me any less nervous
> about the real deal in 5.6. To that end, I've been doing code reviews
> and having discussions, and we also had a security firm audit the code.
> That audit didn't turn up any vulnerabilities, but they did make a good
> defense-in-depth suggestion. This series contains:
> 
> 1) Removal of a duplicated header, from YueHaibing.
> 2) Testing with 64-bit time in our test suite.
> 3) Account for skb->protocol==0 due to AF_PACKET sockets, suggested
>    by Florian Fainelli.
> 4) Clean up some code in an unreachable switch/case branch, suggested
>    by Florian Fainelli.
> 5) Better handling of low-order points, discussed with Mathias
>    Hall-Andersen.

Series applied, please start providing appropriate Fixes: tags in the
future.

Thank you.
