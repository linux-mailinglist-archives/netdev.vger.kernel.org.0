Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698FE117F07
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLJEcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:32:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39824 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfLJEcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:32:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48685154F0CD6;
        Mon,  9 Dec 2019 20:32:03 -0800 (PST)
Date:   Mon, 09 Dec 2019 20:32:02 -0800 (PST)
Message-Id: <20191209.203202.180894312618501297.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: smc911x: Adjust indentation in
 smc911x_phy_configure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209215027.10222-1-natechancellor@gmail.com>
References: <20191209215027.10222-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 20:32:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Mon,  9 Dec 2019 14:50:27 -0700

> Clang warns:
> 
> ../drivers/net/ethernet/smsc/smc911x.c:939:3: warning: misleading
> indentation; statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>          if (!lp->ctl_rfduplx)
>          ^
> ../drivers/net/ethernet/smsc/smc911x.c:936:2: note: previous statement
> is here
>         if (lp->ctl_rspeed != 100)
>         ^
> 1 warning generated.
> 
> This warning occurs because there is a space after the tab on this line.
> Remove it so that the indentation is consistent with the Linux kernel
> coding style and clang no longer warns.
> 
> Fixes: 0a0c72c9118c ("[PATCH] RE: [PATCH 1/1] net driver: Add support for SMSC LAN911x line of ethernet chips")
> Link: https://github.com/ClangBuiltLinux/linux/issues/796
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied.
