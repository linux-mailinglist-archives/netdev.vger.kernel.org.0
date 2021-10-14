Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C887F42CF99
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 02:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhJNAmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 20:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJNAmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 20:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A2F336113B;
        Thu, 14 Oct 2021 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634172007;
        bh=7jecsQ4N+q39amZCDfgMO5CPO/FISEwknDEJ2hNBFFc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o6+3NRCYDpLBIky2ymphRrOvXSQSnBK2dtgEG1RYQfp5rRL9xQV7qi0k8BNwrdffg
         9GvBH3/lmmg/S2xsOV7+vKR7Y72ViU52RxlyYTohm8slEjAwDJTVY7Xkly1Be6i8eF
         Jh/4sv1DhpOTbdDWFVJwPjaHPI7ev9w99+QS7AU2hsYJPp/1MeU3uznHbZc1sKK+GA
         np3sC027MlCGaaQEEGZTvrFXTxIwfX6Or0UK4R+tMT+2sBDQ0Seygl04GZdj0oporp
         rUdUWMX3ZtjYj/Vh9bQNeYNP/rnnCbsutpfwhX5u4SInve4mw4oGOo/Sr0fcGwc3x9
         L8/dRos7UncSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94B6A609CF;
        Thu, 14 Oct 2021 00:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfc: fix error handling of nfc_proto_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163417200760.9495.8934289955961938256.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 00:40:07 +0000
References: <20211013034932.2833737-1-william.xuanziyang@huawei.com>
In-Reply-To: <20211013034932.2833737-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 11:49:32 +0800 you wrote:
> When nfc proto id is using, nfc_proto_register() return -EBUSY error
> code, but forgot to unregister proto. Fix it by adding proto_unregister()
> in the error handling case.
> 
> Fixes: c7fe3b52c128 ("NFC: add NFC socket family")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] nfc: fix error handling of nfc_proto_register()
    https://git.kernel.org/netdev/net/c/0911ab31896f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


