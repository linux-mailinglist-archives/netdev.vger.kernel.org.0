Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14CF401B21
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242059AbhIFMZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237454AbhIFMZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 08:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E080560F43;
        Mon,  6 Sep 2021 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630931045;
        bh=ll0PgTxU1AsOAoGrJa5MgZES4B9sMq3D4bqmFJ7km00=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mwFJBfjlkZ5zff6vbA06vBG3Lnd6xoe858Px4OHvdn9B9mQ4nd9KXPdk41gmGeysk
         M2ETSzqNxoIrqeItn4Zj+giUaJimTToC+s8pO6VKpK43fbgBwPM7rZgl9x/poOyxxT
         t1fUC5fvFhSXtDuyY0pEadPZsqUHM3kl+SfZLzWc53h+ZIAaUmENmlkAB0HbotPVA0
         ntuThAgWJQHEM5wNzktYoopih1uMd5tim0eFa0K3UKjjh1E5PDF0YbT3iRV54iNNgT
         YqyGeyjoYNspWU+OfXjy9PjgJJ+rH5UA2MNHKC3YqOS62jQErHbYWOLtYI+w3Zwg8T
         FrkUWLRt+LgOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D0188609B9;
        Mon,  6 Sep 2021 12:24:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns3: make hclgevf_cmd_caps_bit_map0 and
 hclge_cmd_caps_bit_map0 static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163093104584.13830.17839603759630854215.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Sep 2021 12:24:05 +0000
References: <1630921919-36549-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1630921919-36549-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  6 Sep 2021 17:51:59 +0800 you wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> This symbols is not used outside of hclge_cmd.c and hclgevf_cmd.c, so marks
> it static.
> 
> Fix the following sparse warning:
> 
> [...]

Here is the summary with links:
  - net: hns3: make hclgevf_cmd_caps_bit_map0 and hclge_cmd_caps_bit_map0 static
    https://git.kernel.org/netdev/net/c/0c0383918a3e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


