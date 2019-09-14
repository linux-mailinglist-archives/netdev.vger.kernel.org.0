Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE6EB2D53
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 01:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbfINXZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 19:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731619AbfINXZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 19:25:07 -0400
Subject: Re: [PULL] vhost: a last minute revert
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568503506;
        bh=iBQBEA3uIqdk00gdwd+B3Cq4P9l9gIj9SR2TQ2C82lM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Na8bS16rUEizU0A5NcPGOinkD87+iv2mvooco1NWMrM3IdU8ioPH++LHyaV1Uvvgu
         I/i8igs7Lk9s46AFsEen3hWOBAbeO72FeiksCZgM7DHdq72sBvrBkcxaOjUingyAJb
         2f60vFbCMTz4GiSq4qOeJkahy8w2PdGk3nOIzZ60=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190914153859-mutt-send-email-mst@kernel.org>
References: <20190914153859-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190914153859-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 0d4a3f2abbef73b9e5bb5f12213c275565473588
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1f9c632cde0c3d781463a88ce430a8dd4a7c1a0e
Message-Id: <156850350648.2116.2811850659740913129.pr-tracker-bot@kernel.org>
Date:   Sat, 14 Sep 2019 23:25:06 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mst@redhat.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 14 Sep 2019 15:38:59 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1f9c632cde0c3d781463a88ce430a8dd4a7c1a0e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
