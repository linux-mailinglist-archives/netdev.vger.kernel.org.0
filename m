Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E831AF56C
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgDRWbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:31:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E11C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:31:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 340E012776098;
        Sat, 18 Apr 2020 15:31:15 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:31:12 -0700 (PDT)
Message-Id: <20200418.153112.1172624610803498181.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        tariqt@mellanox.com, willemb@google.com
Subject: Re: [PATCH net-next] net/mlx4_en: avoid indirect call in TX
 completion
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415164652.68245-1-edumazet@google.com>
References: <20200415164652.68245-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:31:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 Apr 2020 09:46:52 -0700

> Commit 9ecc2d86171a ("net/mlx4_en: add xdp forwarding and data write support")
> brought another indirect call in fast path.
> 
> Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
> when/if CONFIG_RETPOLINE=y
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

I've decided to apply this to 'net' and queue it up for -stable, thanks.
