Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F0235775D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhDGWKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhDGWKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E04CA61205;
        Wed,  7 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617833409;
        bh=RQ2q7kAefRPdB8LiMZYUtksepVWgo6ZDBMHqa9htQB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MNDjPQuEs4PESwxPhIdamlpnYYajUgbfcNVyMQH6DQdUqby2BB/tSUsJ0xddGhKiS
         VTHTSWolw0iag0+VT04vA3xlPq6EqD5CCfgwdzGUFIP/wvXKhYwWCGiszD/PfRXGu3
         lbhEusJGHjUlQwYkg00D9xiA5023Jr5ZWLe9Cql6M1D8ja+IRAfwC0SrmHjEy1QVIw
         IRO2vvKlLynbfe362KcN2VAwrjuax26GDzY/c2aIzhppnPRcdWERBq3tGAxGd1E4yB
         2771Uy/7kFNODqH66LAmzMvRon5ViD0EMQAzObh9BUyCa2Glz6mLhT7R6Ngk6cOI2P
         NyauCXUD1kA0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5BFE60ACA;
        Wed,  7 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-04-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783340987.5631.5210409702215121000.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:10:09 +0000
References: <20210407122204.E507BC433ED@smtp.codeaurora.org>
In-Reply-To: <20210407122204.E507BC433ED@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Apr 2021 12:22:04 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-04-07
    https://git.kernel.org/netdev/net/c/107adc694558

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


