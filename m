Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A283A117F0B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLJEcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:32:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfLJEcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:32:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2D7D154F0CDF;
        Mon,  9 Dec 2019 20:32:51 -0800 (PST)
Date:   Mon, 09 Dec 2019 20:32:51 -0800 (PST)
Message-Id: <20191209.203251.2060454946547270295.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     paulus@samba.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ppp: Adjust indentation into ppp_async_input
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209223859.19013-1-natechancellor@gmail.com>
References: <20191209223859.19013-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 20:32:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Mon,  9 Dec 2019 15:38:59 -0700

> Clang warns:
> 
> ../drivers/net/ppp/ppp_async.c:877:6: warning: misleading indentation;
> statement is not part of the previous 'if' [-Wmisleading-indentation]
>                                 ap->rpkt = skb;
>                                 ^
> ../drivers/net/ppp/ppp_async.c:875:5: note: previous statement is here
>                                 if (!skb)
>                                 ^
> 1 warning generated.
> 
> This warning occurs because there is a space before the tab on this
> line. Clean up this entire block's indentation so that it is consistent
> with the Linux kernel coding style and clang no longer warns.
> 
> Fixes: 6722e78c9005 ("[PPP]: handle misaligned accesses")
> Link: https://github.com/ClangBuiltLinux/linux/issues/800
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied.
