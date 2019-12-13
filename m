Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE15711EE40
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLMXKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfLMXKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 18:10:14 -0500
Subject: Re: [PULL] virtio: cleanups and fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576278613;
        bh=gaN6eYA24VQ2L4oceDEHAodf6zAVvVtpngVvrBOoTrQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=yGWsIpdGaBv4h8N3hZbouhx07axdCi2cpdIHUhXIG6mGm5oz5Qpag+oju3Lbbpevv
         MDmXaR7qSjjITTBHME1EA+VEFInpjEPqnEDKZHfPTZBWQtTMrTxSgK9nFwMCok0Yts
         O8rIPq39FCebQiZwdYKXcVLHEWNBhovoJj44WxXo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191213093519-mutt-send-email-mst@kernel.org>
References: <20191213093519-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191213093519-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 63b9b80e9f5b2c463d98d6e550e0d0e3ace66033
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dd79b5361a6ab3def4a577843ebfecd75b634c8b
Message-Id: <157627861383.1837.13487568040839175464.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Dec 2019 23:10:13 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@redhat.com, imammedo@redhat.com,
        jasowang@redhat.com, liuj97@gmail.com, mst@redhat.com,
        stable@vger.kernel.org, yuhuang@redhat.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 13 Dec 2019 09:35:19 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dd79b5361a6ab3def4a577843ebfecd75b634c8b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
