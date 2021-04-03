Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7653531B7
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 02:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhDCAAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 20:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234488AbhDCAAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 20:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3BF0861184;
        Sat,  3 Apr 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617408008;
        bh=KJGhjyUubbKxFR2P02v9QX8UUPsPp7vFqGtrpcRjpCQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=agZt0WE0F3GrVx67v/FgUiNljUJpQARLrHAuBzLZmxsE7Dk6WNWCoW+ZkW11mJ8n5
         f6cNhJsZ51tZh4PscNCLarCBDz60ffZKuSjKKUwUqzjjEJ3IQd1gYvTY5i9f0WBymI
         RXXQ5O41DxgWqbvdMNcPvuQUVce8htSXr1SSSUuPnCtM2NHhdUjQbPFlxAfQH1xbBl
         +Lmwxfxgp6w1aeigB5Jf4jfVRTt52ZmX4TSec7npzrdauSttt3OsVOSQ3WQzbjDhqd
         cPK+wfs6glMOni4//ispx0TbpjwOLK0se3YbAnPBKqPrbw760BntfCNIyc9JhCBR8+
         L1wxxvrt8SgYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 29854609CC;
        Sat,  3 Apr 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] libbpf: remove redundant semi-colon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161740800816.30797.12847311470532759586.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Apr 2021 00:00:08 +0000
References: <20210402012634.1965453-1-yangyingliang@huawei.com>
In-Reply-To: <20210402012634.1965453-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, song@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 2 Apr 2021 09:26:34 +0800 you wrote:
> Remove redundant semi-colon in infinalize_btf_ext().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   add commit log
> 
> [...]

Here is the summary with links:
  - [-next,v2] libbpf: remove redundant semi-colon
    https://git.kernel.org/bpf/bpf-next/c/f07669df4c8d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


