Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8CB311F2C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 18:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhBFRkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 12:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhBFRkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 12:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 798A164E88;
        Sat,  6 Feb 2021 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612633206;
        bh=HtOjZjj2z6g1K8kAb394BCeTk6blhuDq2poMqcCU3vE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N9IiaPlGIDnNSlP2gRGx4DeEjCVjXpReAdRfRbOXP+XMaBEHJ/qa5MUN1rHB2rhyJ
         E1trm2u2kue1zbhOPULC4mv+JHAaK1kUdQLzmCqipVGWL7hrr/RQGNhR5zuclUzza7
         X7VFYyYwS+viiGaJ57scDXZzwDad2gMUzen4oxED74+JAqcSxcyZOjzorRTFTV6rAd
         95sJtgLS59xbUDlDqWh4oVwJ3aWNfhnyyggkuNheGi7xdQOn7lQmDjRPV2xRhljR/+
         F5F0pVZd5tXEtpKhP3PG9co9kyq3VFnyTe0KdEvF657co+hsFqL10DxA5hixO4Ebto
         TgLt7l8v529Gg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 70B15609F7;
        Sat,  6 Feb 2021 17:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-02-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161263320645.14418.6438215599301292317.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 17:40:06 +0000
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
In-Reply-To: <20210205163434.14D94C433ED@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Feb 2021 16:34:34 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-02-05
    https://git.kernel.org/netdev/net/c/2da4b24b1dfb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


