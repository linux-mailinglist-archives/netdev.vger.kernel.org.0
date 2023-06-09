Return-Path: <netdev+bounces-9653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 883A272A1FE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A51E328194D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B29209AE;
	Fri,  9 Jun 2023 18:19:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C315E1993B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AF09C433EF;
	Fri,  9 Jun 2023 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686334740;
	bh=uZgP+KaADG5C3bWQksf0EHSMXqaMfIjehJbNAS9l1os=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Rw3AukwfoCqsTNddSOskF7q3/FceE9NTnzzCMdQyqPwqR7+O3GGTodz3NX+9ki09J
	 jvyjttN9aavZqHqULdRwfMx/yS+MFJ+kJGruk5roxb/mSpsPeaxrd4m5z4oHgCdqyJ
	 5gBCw8LrHUF7aRBtMQXk/9SSYj6824Y0V22vkRtBsoZgHdb3GCG0+qsAVfvMlk6n62
	 vlULvfeB+CihBxFkC4ULT3fSv/JAF/2SEOGHTHtvj7jjTnfy3NAUsKhG/TDutEEx5q
	 V79gkjKjF2wPWCNvKkierWhpglobOi4AZSgetJoWUjwlZLKwV63Yi5jsqSYDuKzBjS
	 Aw1oyS3EGaTUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3295CC395F3;
	Fri,  9 Jun 2023 18:19:00 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: bugfixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20230609121737-mutt-send-email-mst@kernel.org>
References: <20230609121737-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20230609121737-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 07496eeab577eef1d4912b3e1b502a2b52002ac3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dbfa18c5d7695766f24c0c140204e1f8c921fb95
Message-Id: <168633474019.10395.11484571179409071436.pr-tracker-bot@kernel.org>
Date: Fri, 09 Jun 2023 18:19:00 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, sheng.zhao@bytedance.com, zwisler@chromium.org, kvm@vger.kernel.org, mst@redhat.com, syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com, netdev@vger.kernel.org, zwisler@google.com, linux-kernel@vger.kernel.org, xieyongji@bytedance.com, asmetanin@yandex-team.ru, prathubaronia2011@gmail.com, zengxianjun@bytedance.com, virtualization@lists.linux-foundation.org, rongtao@cestc.cn
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 9 Jun 2023 12:17:37 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dbfa18c5d7695766f24c0c140204e1f8c921fb95

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

