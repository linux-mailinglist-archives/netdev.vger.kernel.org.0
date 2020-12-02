Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD192CC847
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgLBUtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgLBUtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:49:16 -0500
Subject: Re: [GIT PULL] vdpa: last minute bugfixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606942113;
        bh=Pfal5eZHb3G2KKSiwL+xk4HK/vWCqBVH2HiQl3Y7Bnw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=GIJbhoSgwSrDVO8gN/q7DdNyv+3y2WmmotTi9dLx7ITg47CY/Z1CFeXepmb9u2mra
         r7HtzDNMascxpqVuXomN2igH4zLdyx9GS36qGqNnF1+jyigR3LFRGYA+1hGZwEIEzz
         E5Ytt8h/Akm/Am1L0+rw1Y/bOJ+nFNl1Y5UCFfNZLnlaVXM9kuf7d3N//6DlAjwAc2
         k6jSZK0yOWoLkeuJJqcczDrL2ISy1y9/AuypWQbMSUoP+OlN3XyG5hiptQ1lcdjYdM
         VIyydKcS4kYEgJu/UYDrZIhZvDFOLe040NDGFkx+v7rfr/KREZnYs+5gNa2wczoe9y
         jxI1KFY2U+/tg==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201202065147-mutt-send-email-mst@kernel.org>
References: <20201202065147-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201202065147-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 2c602741b51daa12f8457f222ce9ce9c4825d067
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2c6ffa9e9b11bdfa267fe05ad1e98d3491b4224f
Message-Id: <160694211318.5087.448562250965611321.pr-tracker-bot@kernel.org>
Date:   Wed, 02 Dec 2020 20:48:33 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, eli@mellanox.com, jasowang@redhat.com,
        leonro@nvidia.com, lkp@intel.com, mst@redhat.com,
        parav@mellanox.com, rdunlap@infradead.org, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 2 Dec 2020 06:51:47 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2c6ffa9e9b11bdfa267fe05ad1e98d3491b4224f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
