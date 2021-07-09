Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236923C297F
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhGITXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhGITXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 15:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 536D8613C9;
        Fri,  9 Jul 2021 19:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625858439;
        bh=Fp+eQsJFd6B8DxNrmeN1/cJIyLa708u/+iW69f5n2FE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Fr7FmdfDTMlRwiy4ykC7xGQ/x7p8dFeFgfok3FCmFTMrgQNAygFgYXLuJ+jTADCkz
         XeMcLTdQ5pRUtGsUhEjS3X+3rvgC1SAuWvE6iJvYfpnEOgKYwBy87SZ9/fHhtIrc73
         DhNQtlpUaxbgYYJTWiQDaaA/FdL/lYhaIK1fikkuW2mDmVH/6se6L2QX0/oExAEqPi
         qdjFSH/i4qNTpFz0+vMfppnwXPHk2+3UFkPUkVESGyi+KgVnz4dTV/DmKNrpq2FwTh
         O7qvU0e0kKCnRMhh6xPGhYMXN6BcHnPsb/2VT5Ae6eVt/UwRAHYdQjgI0/TKkIptiL
         PN7fzkrCjjk4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4AB2C609CD;
        Fri,  9 Jul 2021 19:20:39 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210709071952-mutt-send-email-mst@kernel.org>
References: <20210709071952-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210709071952-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: db7b337709a15d33cc5e901d2ee35d3bb3e42b2f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1eb8df18677d197d7538583823c373d7f13cbebc
Message-Id: <162585843929.13664.10113139479114516329.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Jul 2021 19:20:39 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com, dan.carpenter@oracle.com,
        david@redhat.com, elic@nvidia.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, lkp@intel.com, michael.christie@oracle.com,
        mst@redhat.com, sgarzare@redhat.com, sohaib.amhmd@gmail.com,
        stefanha@redhat.com, wanjiabing@vivo.com, xieyongji@bytedance.com,
        yang.lee@linux.alibaba.com, zhangshaokun@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 9 Jul 2021 07:19:52 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1eb8df18677d197d7538583823c373d7f13cbebc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
