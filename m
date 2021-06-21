Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E903AF626
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhFUTcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFUTcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 626BD6128C;
        Mon, 21 Jun 2021 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303803;
        bh=IEeIi7UNGJZpt335ExRgAvvDhmjD7fs/m+12iVwBgdE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UBBLqgJOrDr/nOyuW+p1MDahuNg0GHIfqvI8F0BV6r1upsRICaW9Tjcfyv7mmZEjg
         yjDyqBHnxyLTzuCQp5BxMWpGUek0c5jwF1nMxnPxO78N32ZCor3Co5Dg1caaCuYgOH
         sDqUUAkKJTgcjlGToPE2NjE4UnBazbSjAtb7jqXESA6CNNnnInsSsqPMX8cJ3yz3JY
         Rttxa8yO1QgS/ICft+njf/1Y3a6HFRoJsj+jIoQMiuX781Y40FXQO/zwCRfBZasgC2
         6YccAcnKbykKTzzaqS76FT3dNBHi8wiZ4zH3eB7Sb7O9jmCZgLVM+suyRJFbKsSzbq
         hLiTKpoEGT0eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5716660A02;
        Mon, 21 Jun 2021 19:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-06-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430380335.11970.11491483965170146030.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:30:03 +0000
References: <20210619155308.68798C433D3@smtp.codeaurora.org>
In-Reply-To: <20210619155308.68798C433D3@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Sat, 19 Jun 2021 15:53:08 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-06-19
    https://git.kernel.org/netdev/net/c/0d98ec879ddc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


