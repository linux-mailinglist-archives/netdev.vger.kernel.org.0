Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDCE1F5DD6
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 23:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgFJVpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 17:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgFJVpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 17:45:23 -0400
Subject: Re: [GIT PULL] virtio: features, fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591825522;
        bh=CE0aQdpou0/7Squu8lBaWHAf5wRg1NIwqMRssSM2m5Y=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=uwOfHFMudzPjx89JIxmzIihgrvNSZb8E5Y8VJPcl62MOMXz9JENAI7SwNDlcZT/Xu
         SmsVNXCaYo4WTWgoOLs/nwK6d09/7X0uH5LMptEpaEyf2jR+uRf2bq+4UInSqLu7Ke
         I+DUqB2wDcqbwMkgYQwYOqT59zhr0XsLAY6Enz8I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200610004455-mutt-send-email-mst@kernel.org>
References: <20200610004455-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200610004455-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 044e4b09223039e571e6ec540e25552054208765
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 09102704c67457c6cdea6c0394c34843484a852c
Message-Id: <159182552257.4867.17502702352097264992.pr-tracker-bot@kernel.org>
Date:   Wed, 10 Jun 2020 21:45:22 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        anshuman.khandual@arm.com, anthony.yznaga@oracle.com,
        arei.gonglei@huawei.com, cai@lca.pw, clabbe@baylibre.com,
        dan.j.williams@intel.com, davem@davemloft.net, david@redhat.com,
        dyoung@redhat.com, elfring@users.sourceforge.net,
        glider@google.com, gregkh@linuxfoundation.org,
        guennadi.liakhovetski@linux.intel.com, hannes@cmpxchg.org,
        herbert@gondor.apana.org.au, hulkci@huawei.com,
        imammedo@redhat.com, jasowang@redhat.com, jgross@suse.com,
        kernelfans@gmail.com, konrad.wilk@oracle.com, lenb@kernel.org,
        lingshan.zhu@intel.com, linux-acpi@vger.kernel.org, lkp@intel.com,
        longpeng2@huawei.com, matej.genci@nutanix.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com,
        mst@redhat.com, osalvador@suse.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com,
        pavel.tatashin@microsoft.com, rafael@kernel.org,
        richard.weiyang@gmail.com, rjw@rjwysocki.net, rppt@linux.ibm.com,
        stable@vger.kernel.org, stefanha@redhat.com,
        teawaterz@linux.alibaba.com, vbabka@suse.cz, zou_wei@huawei.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 10 Jun 2020 00:44:55 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/09102704c67457c6cdea6c0394c34843484a852c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
