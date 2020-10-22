Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518E2295E0B
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897906AbgJVMIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897898AbgJVMIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 08:08:48 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B6C0613CE;
        Thu, 22 Oct 2020 05:08:48 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id EEFABC009; Thu, 22 Oct 2020 14:08:41 +0200 (CEST)
Date:   Thu, 22 Oct 2020 14:08:26 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] 9p update for 5.10-rc1
Message-ID: <20201022120826.GA28295@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Linus,

another harmless cycle.
(sorry latest commit's message isn't great, I was half expecting a v2
but it didn't come and I remembered too late/didn't want to reword it
myself; and it's still worth taking as is)

Thanks,


The following changes since commit 549738f15da0e5a00275977623be199fbbf7df50:

  Linux 5.9-rc8 (2020-10-04 16:04:34 -0700)

are available in the Git repository at:

  https://github.com/martinetd/linux tags/9p-for-5.10-rc1

for you to fetch changes up to 7ca1db21ef8e0e6725b4d25deed1ca196f7efb28:

  net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid (2020-10-12 10:05:47 +0200)

----------------------------------------------------------------
9p pull request for inclusion in 5.10

A couple of small fixes (loff_t overflow on 32bit, syzbot uninitialized
variable warning) and code cleanup (xen)

----------------------------------------------------------------
Anant Thazhemadam (1):
      net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid

Matthew Wilcox (Oracle) (1):
      9P: Cast to loff_t before multiplying

Ye Bin (1):
      9p/xen: Fix format argument warning

 fs/9p/vfs_file.c   | 4 ++--
 net/9p/trans_fd.c  | 2 +-
 net/9p/trans_xen.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)
-- 
Dominique
