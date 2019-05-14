Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1EF1D132
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 23:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfENVUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 17:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfENVUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 17:20:15 -0400
Subject: Re: [PULL] vhost: cleanups and fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557868814;
        bh=sAZ3XnUOBom+63DLslp+1ES/j3Ot9HYCWDTdwVdx/cY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ho90yahGxZDTNsYTOSdjuex+X5jmeYETGsjwKUOfTSBpFylw9dv0t8o9MqSHtBRPC
         wJNtIXWY9jJ0ONz4JzpZasiU42EZZQkVzZECneNpc9lRjvRKG4zHVkx1fEZ0p8B3lj
         DeJLnTaiMhefMeQxVPoz1lZD0/rLhjE90wowHtbg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190514171147-mutt-send-email-mst@kernel.org>
References: <20190514171147-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190514171147-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 050f4c4d2fbbd8217d94dc21051cc597d2a6848b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 35c99ffa20edd3c24be352d28a63cd3a23121282
Message-Id: <155786881470.21399.17909669772085382895.pr-tracker-bot@kernel.org>
Date:   Tue, 14 May 2019 21:20:14 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.parri@amarulasolutions.com, benbjiang@tencent.com,
        jasowang@redhat.com, j.neuschaefer@gmx.net, mst@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, yuehaibing@huawei.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 14 May 2019 17:11:47 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/35c99ffa20edd3c24be352d28a63cd3a23121282

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
