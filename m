Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7F840AEED
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhINNbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhINNbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 748F161107;
        Tue, 14 Sep 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626208;
        bh=Wx2ABN3/CU9YeSCXTNJp6ANx8IQO1VeMGt6q9i0MT78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IBnnLAk0YJ0BFWfvCeJ+gN1YbPo4eaQY4srkQrqJ4yQcTWC2u0cWsxnx5+PeJZ6/B
         S4GUqtGWN5xZmVajcWvW51wx9ZFWrflDnyZZst8fyXMz2lUWAy3K3hLVvjnufxbKSD
         QPbhgkdaQ3lxrTAZblmsLNXytretwKzY0xKQBX6XgWtWc/yqRm2+br+AlkDSQlV5bc
         st0YJq7AP5YLGstWAASRSinebdvSpFGmrYCi8Llv/0Hoc7r3eQgLU14WsG3d5YVwp5
         01NP62ZUbONZgW3O6chlPG1r262f6VxbKE0CgV741/QoGM05D1DyPuy2boIiK2vP4Q
         gJlr4cU5eRMCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6EEF260A7D;
        Tue, 14 Sep 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] ptp: ptp_clockmatrix: Remove idtcm_enable_tod_sync()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162620845.30283.12490506691689292945.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:30:08 +0000
References: <1631563954-6700-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1631563954-6700-1-git-send-email-min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 13 Sep 2021 16:12:32 -0400 you wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Not need since TCS firmware file will configure it properlly.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c | 229 +-----------------------------------------
>  1 file changed, 2 insertions(+), 227 deletions(-)

Here is the summary with links:
  - [net,1/3] ptp: ptp_clockmatrix: Remove idtcm_enable_tod_sync()
    https://git.kernel.org/netdev/net-next/c/c70aae139d39
  - [net,2/3] ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)
    https://git.kernel.org/netdev/net-next/c/794c3dffacc1
  - [net,3/3] ptp: ptp_clockmatrix: Add support for pll_mode=0 and manual ref switch of WF and WP
    https://git.kernel.org/netdev/net-next/c/da9facf1c182

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


