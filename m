Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0825373F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHZSeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 14:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgHZSeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 14:34:15 -0400
Subject: Re: [GIT PULL] virtio: bugfixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598466855;
        bh=2IrI3zDccPh7k4A7Ku/CCGl3h9hU0yX4/grdGm77idU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=CT73xgJKU9ebCwnZp3Q1MFBBzKb5KM83wM/zdkExncYhIwOCkq8RMeDPBQdBNAoeC
         lbdLssF9i+Xb9eXqL1V/t6mJRD7deuO1v4771hKMw13s4OTrfAavRsIW0+iKFOJCfA
         NG5PyOa0jwfY9cXlm5TN/yiH5BI0HBXQlbuk/c9I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200826092731-mutt-send-email-mst@kernel.org>
References: <20200826092731-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200826092731-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: cbb523594eb718944b726ba52bb43a1d66188a17
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e652049b2018e3a2e32d71c74cf7d359e07e7618
Message-Id: <159846685526.8056.7551024561913275412.pr-tracker-bot@kernel.org>
Date:   Wed, 26 Aug 2020 18:34:15 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        maxime.coquelin@redhat.com, mst@redhat.com,
        natechancellor@gmail.com, rdunlap@infradead.org,
        sgarzare@redhat.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 26 Aug 2020 09:27:31 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e652049b2018e3a2e32d71c74cf7d359e07e7618

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
