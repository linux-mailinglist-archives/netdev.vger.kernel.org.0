Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD71E456E7A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhKSLxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233750AbhKSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BB2A961AED;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637322615;
        bh=tQ45oPWEkLCuEOgjzLhC/mOzs98nm6bN8LnimpdjLBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LOEuHeec7PLCUtM9v7DajGh6ZgBEISwuI1sny8iKW73lWaN9rwWPK3M4HXk1ayHIK
         YqEW5lqXKRmD/9VDSCsD/R03kjiGLiQ/QAbBKzIQv7AnSuUwjmM8f5HRHTCqUx7En0
         II0vo0qx6+K0niOyWxFq5qDnIy0bAPT5P8Nc4ut8mpla5/fVd7+nl9BSdJ0Lo5A/5B
         DBAwPlwnVbETszdHByAxGugb6J0RAB5aV/ZHlkIEKLPiYvw8IvF8toFZRz12KOlLzX
         dXtRywIH8KzxooqTx9SvFqgwjFJKqOn5Rc/8WpDqqkLPqH2OX25YYiXW1ACyu32I8K
         n54XgaEAbiwJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B2CCD600E8;
        Fri, 19 Nov 2021 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: Use struct_group() for memcpy() region
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732261572.10547.4786936477964938867.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:50:15 +0000
References: <20211118184253.1284535-1-keescook@chromium.org>
In-Reply-To: <20211118184253.1284535-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     aelior@marvell.com, pkushwaha@marvell.com, skalluru@marvell.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 10:42:53 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() in struct nig_stats around members egress_mac_pkt0_lo,
> egress_mac_pkt0_hi, egress_mac_pkt1_lo, and egress_mac_pkt1_hi (and the
> respective members in struct bnx2x_eth_stats), so they can be referenced
> together. This will allow memcpy() and sizeof() to more easily reason
> about sizes, improve readability, and avoid future warnings about writing
> beyond the end of struct bnx2x_eth_stats's rx_stat_ifhcinbadoctets_hi.
> 
> [...]

Here is the summary with links:
  - bnx2x: Use struct_group() for memcpy() region
    https://git.kernel.org/netdev/net-next/c/29fd0ec65e91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


