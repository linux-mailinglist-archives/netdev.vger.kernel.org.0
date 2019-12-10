Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8074D117F03
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLJE3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:29:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfLJE3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:29:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49291154F0CC5;
        Mon,  9 Dec 2019 20:29:21 -0800 (PST)
Date:   Mon, 09 Dec 2019 20:29:20 -0800 (PST)
Message-Id: <20191209.202920.1031568566965416683.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: tulip: Adjust indentation in
 {dmfe,uli526x}_init_module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209211623.44166-1-natechancellor@gmail.com>
References: <20191209211623.44166-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 20:29:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Mon,  9 Dec 2019 14:16:23 -0700

> Clang warns:
> 
> ../drivers/net/ethernet/dec/tulip/uli526x.c:1812:3: warning: misleading
> indentation; statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>         switch (mode) {
>         ^
> ../drivers/net/ethernet/dec/tulip/uli526x.c:1809:2: note: previous
> statement is here
>         if (cr6set)
>         ^
> 1 warning generated.
> 
> ../drivers/net/ethernet/dec/tulip/dmfe.c:2217:3: warning: misleading
> indentation; statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>         switch(mode) {
>         ^
> ../drivers/net/ethernet/dec/tulip/dmfe.c:2214:2: note: previous
> statement is here
>         if (cr6set)
>         ^
> 1 warning generated.
> 
> This warning occurs because there is a space before the tab on these
> lines. Remove them so that the indentation is consistent with the Linux
> kernel coding style and clang no longer warns.
> 
> While we are here, adjust the default block in dmfe_init_module to have
> a proper break between the label and assignment and add a space between
> the switch and opening parentheses to avoid a checkpatch warning.
> 
> Fixes: e1c3e5014040 ("[PATCH] initialisation cleanup for ULI526x-net-driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/795
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, but it's really crummy that the tool gets tripped up by the
fact that a space preceeds the TAB.  It's what the code visually looks
like, not what exact kinds of SPACE characters were used to get there.
