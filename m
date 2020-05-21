Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7C81DC5F5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 05:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgEUD4Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 23:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgEUD4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 23:56:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3FFC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 20:56:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE84912768949;
        Wed, 20 May 2020 20:56:20 -0700 (PDT)
Date:   Wed, 20 May 2020 20:56:07 -0700 (PDT)
Message-Id: <20200520.205607.2029699296653494061.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] wireguard fixes for 5.7-rc7
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520044930.8131-1-Jason@zx2c4.com>
References: <20200520044930.8131-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 20:56:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 19 May 2020 22:49:26 -0600

> Hopefully these are the last fixes for 5.7:
> 
> 1) A trivial bump in the selftest harness to support gcc-10.
>    build.wireguard.com is still on gcc-9 but I'll probably switch to
>    gcc-10 in the coming weeks.
> 
> 2) A concurrency fix regarding userspace modifying the pre-shared key at
>    the same time as packets are being processed, reported by Matt
>    Dunwoodie.
> 
> 3) We were previously clearing skb->hash on egress, which broke
>    fq_codel, cake, and other things that actually make use of the flow
>    hash for queueing, reported by Dave Taht and Toke Høiland-Jørgensen.
> 
> 4) A fix for the increased memory usage caused by (3). This can be
>    thought of as part of patch (3), but because of the separate
>    reasoning and breadth of it I thought made it a bit cleaner to put in
>    a standalone commit.

Series applied.

> Fixes (2), (3), and (4) are -stable material.

Queued up for -stable, thanks.
