Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C602B54C3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgKPXKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:10:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPXK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:10:29 -0500
Subject: Re: [GIT PULL] vhost,vdpa: fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568229;
        bh=9UphfRPbiDtx8WS14mhj6/UOt2mT19XhifgecFASUOs=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=KTku/Brz6ZjeXVo9xQupyPGd1Y1dQsZxB7GXoN4kFmuVTsjPNsdiOimXk76b3ElUf
         BWWuD9BgPsWLAXgu8Pn8AjmwVpoD26QOrh8z0yAya/jlYLQ4T2z5C1KNKBuGPH7Hvj
         GaSe6H04/fDrR3MEE96hw6fWvhSvStheKM4BpaQU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201116081420-mutt-send-email-mst@kernel.org>
References: <20201116081420-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201116081420-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: efd838fec17bd8756da852a435800a7e6281bfbc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a08f4523243c86fe35dec8c81c5ec50f721004ce
Message-Id: <160556822900.30215.12731806046913817813.pr-tracker-bot@kernel.org>
Date:   Mon, 16 Nov 2020 23:10:29 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, lkp@intel.com, lvivier@redhat.com,
        michael.christie@oracle.com, mst@redhat.com, rdunlap@infradead.org,
        sfr@canb.auug.org.au, stefanha@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 16 Nov 2020 08:14:20 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a08f4523243c86fe35dec8c81c5ec50f721004ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
