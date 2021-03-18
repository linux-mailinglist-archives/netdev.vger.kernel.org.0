Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6024340CDC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhCRSYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232440AbhCRSYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A5A7D64F1D;
        Thu, 18 Mar 2021 18:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616091851;
        bh=mm5Gj2cRzymNcWhINozh1pQMZ8f06QUkUYUCX5wN1zQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=B5G9Nw7oh0SL8uCt7TnQRKu0AEzIPKfSfK09VntyzyU2POAnVxFpSfpXF1b422qBw
         clJSwBHwJe+YjmnbAO8JXaUTZggOXhQJw8QOsPE/GAtmjY94tdjSF/nyWB0Dtw7AVh
         6cigBZqpvdLdNJ5fqXHOiKP0EBzggCgei7vcgeRuBP+2fwTJsCmzZUjjrAbYCvh5u9
         ORQhgCkBjkQMFB3eyCCrI1GXX61JUWF69GWaGeXM+tGWSgZ/TX2ySXStJvSOhvd+tA
         zOabVCrcoVkFltxCxEoB0UPh9NKLzpWflay/zbVhQZidpH4DL4d44HQFz8afjua1gK
         KrB87wpGxDtVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F42360191;
        Thu, 18 Mar 2021 18:24:11 +0000 (UTC)
Subject: Re: [GIT PULL] vhost: cleanups and fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210318141135-mutt-send-email-mst@kernel.org>
References: <20210318141135-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <stable.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210318141135-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 0bde59c1723a29e294765c96dbe5c7fb639c2f96
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bf152b0b41dc141c8d32eb6e974408f5804f4d00
Message-Id: <161609185164.1841.2155981862734069676.pr-tracker-bot@kernel.org>
Date:   Thu, 18 Mar 2021 18:24:11 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gdawar.xilinx@gmail.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, lvivier@redhat.com, mst@redhat.com,
        parav@nvidia.com, sgarzare@redhat.com, stable@vger.kernel.org,
        tangbin@cmss.chinamobile.com, xianting_tian@126.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 18 Mar 2021 14:11:35 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bf152b0b41dc141c8d32eb6e974408f5804f4d00

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
