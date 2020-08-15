Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE77245374
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgHOWB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgHOVvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:25 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADDDC061237;
        Fri, 14 Aug 2020 22:52:37 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id B67A3C009; Sat, 15 Aug 2020 07:52:34 +0200 (CEST)
Date:   Sat, 15 Aug 2020 07:52:19 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] 9p update for 5.9-rc1
Message-ID: <20200815055219.GA20922@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Linus,

the usual small stuff.

Thanks!


The following changes since commit 74d6a5d5662975aed7f25952f62efbb6f6dadd29:

  9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work (2020-07-19 14:58:47 +0200)

are available in the Git repository at:

  https://github.com/martinetd/linux tags/9p-for-5.9-rc1

for you to fetch changes up to 2ed0b7578170c3bab10cde09d4440897b305e40c:

  9p: Remove unneeded cast from memory allocation (2020-07-31 07:28:25 +0200)

----------------------------------------------------------------
9p pull request for inclusion in 5.9

- some code cleanup
- a couple of static analysis fixes
- setattr: try to pick a fid associated with the file rather than the
dentry, which might sometimes matter

----------------------------------------------------------------
Alexander Kapshuk (1):
      net/9p: Fix sparse endian warning in trans_fd.c

Jianyong Wu (2):
      9p: retrieve fid from file when file instance exist.
      9p: remove unused code in 9p

Li Heng (1):
      9p: Remove unneeded cast from memory allocation

Zheng Bin (1):
      9p: Fix memory leak in v9fs_mount

 fs/9p/v9fs.c           |  5 ++---
 fs/9p/vfs_inode.c      | 65 ++++++++---------------------------------------------------------
 fs/9p/vfs_inode_dotl.c |  9 +++++++--
 net/9p/trans_fd.c      |  2 +-
 4 files changed, 18 insertions(+), 63 deletions(-)
