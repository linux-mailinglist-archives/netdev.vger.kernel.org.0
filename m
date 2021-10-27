Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F53543CDF2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242839AbhJ0Pwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242768AbhJ0Pwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:52:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 439FB610A3;
        Wed, 27 Oct 2021 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635349807;
        bh=yXN7baPMnG810G+0iIIYR9z1NVDqu2elk6T2N8yeF4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nqm3deA60h/RL/C8G5yG4ayeQtJRtbMXkMw7okihiNMd5OV/TcxUgNY/s/ApAM08W
         PYXqNyrUxwWZvjVhzlUhpBo7l2na+KzjPFNu0CzTALXyHZM9GohKfVRGM+EBaYQg5/
         t3TGM1E713L/Ae3oMrPEo1UqjWQRGU4Jl+PMF+ierhDG2Sq6WZrfH3forlikfYC75H
         Tuptmbm0zk7r2uywu5mY5J0/9YxvkEesD1w31ZbuLNH0V08UHoD/+JOSnqeKQXImSZ
         K76++gyGyc3QvMRNs6LQRKA0XQfTaDG6vkCSyyxxARpbFAWEhe66g8QLkc0ae5GWGm
         NdnKkKL3Qc6mw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 380CA60726;
        Wed, 27 Oct 2021 15:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-10-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163534980722.3624.2323520135730371409.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 15:50:07 +0000
References: <20211027143756.91711-1-johannes@sipsolutions.net>
In-Reply-To: <20211027143756.91711-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Oct 2021 16:37:55 +0200 you wrote:
> Hi,
> 
> Two more fixes. Both issues have been around for a while though.
> 
> Please pull and let me know if there's any problem.
> 
> Thanks,
> johannes
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-10-27
    https://git.kernel.org/netdev/net/c/afe8ca110cf4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


