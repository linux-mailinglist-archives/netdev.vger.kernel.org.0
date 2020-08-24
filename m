Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC580250C25
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHXXNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXXNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 19:13:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43370C061574;
        Mon, 24 Aug 2020 16:13:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BC41129242A0;
        Mon, 24 Aug 2020 15:57:01 -0700 (PDT)
Date:   Mon, 24 Aug 2020 16:13:46 -0700 (PDT)
Message-Id: <20200824.161346.1009201417411312987.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: dsa: sja1105: Do not use address of compatible
 member in sja1105_check_device_id
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200821222515.414167-1-natechancellor@gmail.com>
References: <20200821222515.414167-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:57:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Fri, 21 Aug 2020 15:25:16 -0700

> Clang warns:
> 
> drivers/net/dsa/sja1105/sja1105_main.c:3418:38: warning: address of
> array 'match->compatible' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         for (match = sja1105_dt_ids; match->compatible; match++) {
>         ~~~                          ~~~~~~~^~~~~~~~~~
> 1 warning generated.
> 
> We should check the value of the first character in compatible to see if
> it is empty or not. This matches how the rest of the tree iterates over
> IDs.
> 
> Fixes: 0b0e299720bb ("net: dsa: sja1105: use detected device id instead of DT one on mismatch")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1139
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks.
