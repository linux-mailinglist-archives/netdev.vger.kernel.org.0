Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F32310FBE
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhBEQe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:34:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233728AbhBEQbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 11:31:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A41064E49;
        Fri,  5 Feb 2021 18:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612548777;
        bh=OEdo9FgWHCfNz1W4m5jQ8e6zfGEvZ8qUY/UkHoGEWXA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SV2rfU2qRQ15Rr/3zIRHopOucvCIp5MECi1h0m4HSokeQmDfZO6iingAuJk/mbYDG
         b51bX2UmrwO7iwY642mCbyCEDlFmp4z+qOm+W6EPeZzL2+LdmPtfRAAtzXMqF6stdH
         86rOJBQ0+JGuBVbcTUu7JoYv5aWbVVVTAFAvKsCnn/dBi7P4UFDkq1l8fQmPDx9Urb
         wweqaC4MB3Za/u3HAG36UhnvYvbh0rm+L35FBnaWnOqFmYBp35GsqsWjhYQcWFZiMp
         ZNIGoenfWsEIvjeHOWvGEe6nsGALW/yfD2pmKc6A7oPQUB8hqunH3/OmSZ8YryVPgc
         Kr0vllqySu4Qw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2604D609F2;
        Fri,  5 Feb 2021 18:12:57 +0000 (UTC)
Subject: Re: [GIT PULL] vdpa: last minute bugfix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210205104520-mutt-send-email-mst@kernel.org>
References: <20210205104520-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210205104520-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: b35ccebe3ef76168aa2edaa35809c0232cb3578e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e07ce64d83046178c9c0c35e9d230a9b178b62ef
Message-Id: <161254877710.14736.823422420550424616.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Feb 2021 18:12:57 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 5 Feb 2021 10:45:20 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e07ce64d83046178c9c0c35e9d230a9b178b62ef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
