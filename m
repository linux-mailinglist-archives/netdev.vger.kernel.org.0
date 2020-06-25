Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29C72097FF
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 02:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388977AbgFYAuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 20:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388624AbgFYAuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 20:50:18 -0400
Subject: Re: [GIT PULL] virtio: fixes, tests
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593046217;
        bh=f5RpbcMicbBxqObbdGqeqMmJL+IlXXFRGH9AYmoYkCw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=E0ffJ/zhU2HgdXfI+8AHlU+ReBaqcI6rA6uBDkTFVZ2qAfrK/T0xNbEVUXBgBGTJZ
         T9+/YV8d5biZfPFK9qxDQ6xzp7ARyhDJjrrrSnyjFeyYDIhtu8t7M9B+3n3cNFAdYk
         dNpaciYRpMJuSzfvwCfs7qyOEfTYV7ld9bH+Ucdk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200624050801-mutt-send-email-mst@kernel.org>
References: <20200624050801-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200624050801-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: cb91909e48a4809261ef4e967464e2009b214f06
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc10807db5ced090d83cec167e87c95a47452d24
Message-Id: <159304621781.794.13739731253523627902.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Jun 2020 00:50:17 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, david@redhat.com, eperezma@redhat.com,
        jasowang@redhat.com, mst@redhat.com, pankaj.gupta.linux@gmail.com,
        teawaterz@linux.alibaba.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 24 Jun 2020 05:08:01 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc10807db5ced090d83cec167e87c95a47452d24

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
