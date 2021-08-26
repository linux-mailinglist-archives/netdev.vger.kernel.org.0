Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495C33F83EF
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240598AbhHZIuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 04:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240351AbhHZIuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 04:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF1E161076;
        Thu, 26 Aug 2021 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629967805;
        bh=D1K2/UIRtc6012WHoQNJ15f8Z/1wm09sNdnQmbDsG/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XmW/1cmPiXBj298IjAFDYi5h+3ei7xiW9+HEt7RvHwzOie5NoYlsqN410sxbA5vMt
         dFix5X/6Io7Fly6Bo+Q+q/5cKz8fcYAaRm0cgxQ16b4US6i7CikQRHbhKFz6om7Q3M
         9da/rgGXmMeR9BkW00nlz/vv9OAo0J0mfPE2dc4q8fc/0E2/zsd6DzwcOA1GexM/pa
         pm7/IBs0QD06XB7kW4HOBRzXKRH7g+iZON7XSvRHFmZOhsHhpGoMBasmnfoKm6dt+M
         a7XG4qXgSqcKHtUWeNP/QgtERV4C9hDSbrxrvwizrmRESGfaRmdhQA1U5NrkAStbYc
         +zG8vx790DBeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D190E60A27;
        Thu, 26 Aug 2021 08:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-08-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162996780585.25573.13052455887476388040.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 08:50:05 +0000
References: <20210826064456.1427513-1-mkl@pengutronix.de>
In-Reply-To: <20210826064456.1427513-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Aug 2021 08:44:55 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of a single patch for net/master.
> 
> Stefan Mätje's patch fixes the interchange of RX and TX error counters
> inthe esd_usb2 CAN driver.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-08-26
    https://git.kernel.org/netdev/net/c/92ea47fe09b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


