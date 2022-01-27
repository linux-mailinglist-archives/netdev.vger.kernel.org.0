Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8198549EB79
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbiA0UAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:00:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45096 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343626AbiA0UAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:00:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62A306115B;
        Thu, 27 Jan 2022 20:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEEBFC340E4;
        Thu, 27 Jan 2022 20:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643313651;
        bh=BBdEh1lyM/dXPzFIbN9SmMID3gjR9YxbbIiFzdmkkPY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AJ9nYeFOjIjVMdxqj3wWkLnXqjmnL707fc5GQNeXzJqjuk4WtfHypYIVXLaMiNViq
         lEm9tLgF/cbir9MsVQNbpF7+9jZLhXXD1lVLqEC2BkzPmoFl6FyE1N7H4chZItn5TT
         LhF5bqIJ99Pu2FG77zYmfWOjdI/E3rIVw83QLGF4mTtQ/H92BugZhOmV0kh2rMqR/S
         7sNgOwVcoolBwObnlvmNwSTu0Ez6dUZPHflM0+Or9zqxEUFru6C8DR+hO48WI+5rmQ
         P1WzVImXWyv4k6aybnHKo2K6FOzH7Ivv4bOoHKYR/BePaw/w6ih10xeALPH2FfupgU
         ME+jVbPqgwYBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD8A0E5D084;
        Thu, 27 Jan 2022 20:00:51 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220127184519.2269399-1-kuba@kernel.org>
References: <20220127184519.2269399-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220127184519.2269399-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc2
X-PR-Tracked-Commit-Id: fd20d9738395cf8e27d0a17eba34169699fccdff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 23a46422c56144939c091c76cf389aa863ce9c18
Message-Id: <164331365170.18719.18015009539108722491.pr-tracker-bot@kernel.org>
Date:   Thu, 27 Jan 2022 20:00:51 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 27 Jan 2022 10:45:19 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/23a46422c56144939c091c76cf389aa863ce9c18

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
