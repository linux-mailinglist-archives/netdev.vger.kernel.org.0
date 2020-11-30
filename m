Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86DA2C90AF
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgK3WKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730465AbgK3WKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 17:10:46 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606774205;
        bh=Ke061BKQ/lyD2gHAWGw1AH5U1g5VACS+Ike+6JZwLDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U1ldCNeFiN5XdqAt0uhHOvwk66tGFtz8YgErfaLP6sOEY3aANQn/6ndCyTyqM2RzY
         7ERuOCe0v3xN8k1AsMyBIZ/WMeuYMtb6erVLWIOjf4oNnZEjFr3ZwujKV5jN/+yp77
         gBNXUvTTwF1gUjjk7dH5RtvAX1EfebpGTrxpUde0=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in
 xdp_return_buff()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160677420568.31377.5525835460046675997.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Nov 2020 22:10:05 +0000
References: <20201127171726.123627-1-bjorn.topel@gmail.com>
In-Reply-To: <20201127171726.123627-1-bjorn.topel@gmail.com>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com, magnus.karlsson@intel.com,
        maximmi@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 27 Nov 2020 18:17:26 +0100 you wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> It turns out that it does exist a path where xdp_return_buff() is
> being passed an XDP buffer of type MEM_TYPE_XSK_BUFF_POOL. This path
> is when AF_XDP zero-copy mode is enabled, and a buffer is redirected
> to a DEVMAP with an attached XDP program that drops the buffer.
> 
> [...]

Here is the summary with links:
  - [bpf] xdp: Handle MEM_TYPE_XSK_BUFF_POOL correctly in xdp_return_buff()
    https://git.kernel.org/bpf/bpf/c/ed1182dc004d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


