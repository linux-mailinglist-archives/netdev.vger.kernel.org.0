Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9162E90
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfGIDPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:15:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbfGIDPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:15:04 -0400
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562642102;
        bh=ffJpmiG3YCVrmSdb4Ds3CGUQgDaz+9N4x55s4P3dlvo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=gquIdpoSw1zf4tIdWE/tortMRjaZsdQquNItwfubAGAx7ABS6Jg++fZscnR0BnsTY
         IBuaA0rawGY1tLdIcROynx/7Ndt8b7dpg8G33y+ze2Xv6bNom2fBgUYdFNSu1/eoIZ
         WpG6iyy5q1f4L2tWwnRPvv2jW+B6HfkehCwoYY2E=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <28477.1562362239@warthog.procyon.org.uk>
References: <28477.1562362239@warthog.procyon.org.uk>
X-PR-Tracked-List-Id: <linux-nfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <28477.1562362239@warthog.procyon.org.uk>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
 tags/keys-acl-20190703
X-PR-Tracked-Commit-Id: 7a1ade847596dadc94b37e49f8c03f167fd71748
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f75ef6a9cff49ff612f7ce0578bced9d0b38325
Message-Id: <156264210283.2709.18395042155936707106.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Jul 2019 03:15:02 +0000
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, dhowells@redhat.com,
        jmorris@namei.org, keyrings@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 05 Jul 2019 22:30:39 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-acl-20190703

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f75ef6a9cff49ff612f7ce0578bced9d0b38325

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
