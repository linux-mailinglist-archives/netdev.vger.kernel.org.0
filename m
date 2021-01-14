Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AEB2F6D95
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbhANVzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbhANVzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 16:55:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D74B221FE;
        Thu, 14 Jan 2021 21:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610661298;
        bh=kmpsUDrZBfHnJEoOyEC652YHexWQOaiLUyMR/INFZIc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aG5y2HDhgwWch3nXarJNu29q4jCMCvSHfx7BKq43PLGTuxEmv+Qlf4d9ArEW9pkxY
         SePqakJBEyVRpE/T+wccPZXPSKzeBYndV6azw0dYrAA5MgYA9a047AIhl6a6akIENv
         SjT6mzKS8OuN2MApdzrK5J4Dc1XdpC2QHPY+DQNXYvVOA/XQBErNg7fw9DINpWlVuK
         1JP+vowbcPa36n7mS7frOvwpWiOgZO24kIfAn483mKuEqe27JZv7tghnGMInCE4+iE
         RSQH8vIWEZ+7PXnALx3hHDwnBYZPvBHq0MOr/8lduApAivWsT+SM3Ohu4X4r17tPOO
         KcsNULUsBOezg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2FB6A60156;
        Thu, 14 Jan 2021 21:54:58 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.11-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210114200551.208209-1-kuba@kernel.org>
References: <20210114200551.208209-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210114200551.208209-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc4
X-PR-Tracked-Commit-Id: 13a9499e833387fcc7a53915bbe5cddf3c336b59
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e8c13a6bc8ebbef7bd099ec1061633d1c9c94d5b
Message-Id: <161066129812.27370.16678362059110704594.pr-tracker-bot@kernel.org>
Date:   Thu, 14 Jan 2021 21:54:58 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 14 Jan 2021 12:05:51 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e8c13a6bc8ebbef7bd099ec1061633d1c9c94d5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
