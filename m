Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B80720FA
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733239AbfGWUkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:40:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGWUkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:40:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 28FB7153BE253;
        Tue, 23 Jul 2019 13:40:00 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:39:59 -0700 (PDT)
Message-Id: <20190723.133959.1151778509619674259.davem@davemloft.net>
To:     maximmi@mellanox.com
Cc:     arnd@arndb.de, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        leon@kernel.org, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, tariqt@mellanox.com
Subject: Re: [PATCH net-next v2] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723120208.27423-1-maximmi@mellanox.com>
References: <20190723120208.27423-1-maximmi@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:40:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>
Date: Tue, 23 Jul 2019 12:02:26 +0000

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The structure is too large to put on the stack, resulting in a
> warning on 32-bit ARM:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:59:5: error: stack frame size of 1344 bytes in function
>       'mlx5e_open_xsk' [-Werror,-Wframe-larger-than=]
> 
> Use kvzalloc() instead.
> 
> Fixes: a038e9794541 ("net/mlx5e: Add XSK zero-copy support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
> v2 changes: use kvzalloc/kvfree and fix a memory leak.

I'll apply this directly to net-next.

Thanks Maxim.
