Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC39183E9C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 02:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgCMBPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 21:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgCMBPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 21:15:07 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584062106;
        bh=OTggwL3F5JHTu7CVBtNAFI5dEm1xaJRX9QqjbT3x9rg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=d7oW/a36KyUfKbOHWEOIQ/ohYSMFp9p6AHHzI2+weqxKOrYKWDxv/OYv18+FzJ3s4
         MAOzly/sAt7bt0sd0AJ34if0mh8aL6raRBMSNQCGiIz6moSs/G5cpFccgE28J2V0cM
         z0odDLANZzA3JNQf/vfm9CdON0FXliAkV1lzrHTU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200312.161450.250161317006618802.davem@davemloft.net>
References: <20200312.161450.250161317006618802.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200312.161450.250161317006618802.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: c0368595c1639947839c0db8294ee96aca0b3b86
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1b51f69461e6a3485bab5a7601e16b79d7eeac59
Message-Id: <158406210666.26569.2524605292513293562.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Mar 2020 01:15:06 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 12 Mar 2020 16:14:50 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1b51f69461e6a3485bab5a7601e16b79d7eeac59

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
