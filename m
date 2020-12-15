Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673752DA5EA
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgLOCA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgLOCAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607997608;
        bh=v49gBxhDm+yl0g6O8u/pJ936UW9lCUeZOBAVjRzw6eM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dI8ILWzT3RJ1WSux9m9BGg3jpBhaHcrh7JLfr7oJKNmoeoafnSGMaBcskvWRRgxlq
         8uQnzZH1XsFz8wdzhRg2bUr3+KD9rVCfz1xK4Iu1LYurRUuhlX4TNtv3JZrZz3DJdQ
         uvT+yNIGwg6CjW2Z2xEeJFY9YmaDjYxBl5TItU04/utmRb0lfsVsxQFmFRwe7qUCZF
         raXuQLZI7D4arWYPmFHofjitN5Un365tsA44byR9xCEQc6R4fRkAMyh2fjhaHcC81j
         9JUBlnVs3EVoGTTYegI24yrQJdzqUryeeu4557w3HRYmWCTyNZq5VlRbXx3rrXKiPD
         xu5CXMWymFXSA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mediatek: simplify the mediatek code return
 expression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160799760826.15807.13602332538555218805.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 02:00:08 +0000
References: <20201211083801.1632-1-zhengyongjun3@huawei.com>
In-Reply-To: <20201211083801.1632-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sagis@google.com,
        jonolson@google.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Dec 2020 16:38:01 +0800 you wrote:
> Simplify the return expression at mtk_eth_path.c file, simplify this all.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_path.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)

Here is the summary with links:
  - [net-next] net/mediatek: simplify the mediatek code return expression
    https://git.kernel.org/netdev/net-next/c/bb7eae6dd230

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


