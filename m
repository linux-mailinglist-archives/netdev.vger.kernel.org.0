Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E22ABD45
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395082AbfIFQFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392102AbfIFQFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 12:05:07 -0400
Subject: Re: [PULL] vhost, virtio: last minute fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567785907;
        bh=6dKqhgHm+LF4MKNxNOJfMbZ8mldeK+fKzvmBs20KYGA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=sxSJKpT53C48cNP3QTWWR1YL/uamT1Lq4S08NoR3g7HXAvQoRBBd89dr28qJOujuT
         WGMEVQDUyboqrradEl1dLNmYucJNt51UkPP1w9LmXd2dl2TnBCvkWykPnG1ly63RNy
         99/8h9vVmlPyvqckxH/tOkJdMsPJUzCJmxdIz0I4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190906094103-mutt-send-email-mst@kernel.org>
References: <20190906094103-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190906094103-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 02fa5d7b17a761f53ef1eedfc254e1f33bd226b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d098a6234c135c3fd1692fc451908b5c2a43244
Message-Id: <156778590706.8517.1772605570873720347.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Sep 2019 16:05:07 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, jiangkidd@hotmail.com, linyunsheng@huawei.com,
        mst@redhat.com, namit@vmware.com, tiwei.bie@intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 6 Sep 2019 09:41:03 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d098a6234c135c3fd1692fc451908b5c2a43244

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
