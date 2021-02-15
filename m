Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A50131C33C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhBOUux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:50:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhBOUur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 15:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6599B64DF0;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613422207;
        bh=1wB0Z9gzd+8uwYMK31uQuE4l+xRQ9n1vgIUpZ1cwg+A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G9qm4wwaMzsxd0cuTje5eLJedQkbEqJhbNHxuXhZanDRCKNHMwC/7fGbEtDtt5bw6
         DyoaqorId8uM4awzTGuo6VS5hZ5xygo1DkCQRQJj4WE8to4B18AW9PSW6taKn8ZvEP
         BxAD4KEcaf43IM1+ZmGy7CBEvg/fuVM6DgT61bxg7CyxXUjNb/Ev51D+3OrD2HtJns
         gJuG0/nU9jZeBzmVWgJFt7Y+Oaa3h5oHJPoQbeaxOyXLu1vCDlERWvMvyWawgJcIyT
         Y7ZvXyFhghfOr+XM7WEmWElWjVKRh0JCzGFEfIj8grPMBDSuErMuxkKNrNMOj4lKJK
         IGqrm0rhqpfUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5723F60977;
        Mon, 15 Feb 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4/chtls/cxgbit: Keeping the max ofld immediate data
 size same in cxgb4 and ulds
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342220735.9745.1027344116176732388.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 20:50:07 +0000
References: <20210215114226.10003-1-ayush.sawal@chelsio.com>
In-Reply-To: <20210215114226.10003-1-ayush.sawal@chelsio.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        secdev@chelsio.com, varun@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 15 Feb 2021 17:12:26 +0530 you wrote:
> The Max imm data size in cxgb4 is not similar to the max imm data size
> in the chtls. This caused an mismatch in output of is_ofld_imm() of
> cxgb4 and chtls. So fixed this by keeping the max wreq size of imm data
> same in both chtls and cxgb4 as MAX_IMM_OFLD_TX_DATA_WR_LEN.
> 
> As cxgb4's max imm. data value for ofld packets is changed to
> MAX_IMM_OFLD_TX_DATA_WR_LEN. Using the same in cxgbit also.
> 
> [...]

Here is the summary with links:
  - [net] cxgb4/chtls/cxgbit: Keeping the max ofld immediate data size same in cxgb4 and ulds
    https://git.kernel.org/netdev/net/c/2355a6773a2c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


