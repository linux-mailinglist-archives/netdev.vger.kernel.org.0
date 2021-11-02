Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7EF442FD2
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhKBOLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhKBOLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:11:16 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6CDC061714;
        Tue,  2 Nov 2021 07:08:41 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3D2D1C024; Tue,  2 Nov 2021 15:08:40 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id A3C87C01C;
        Tue,  2 Nov 2021 15:08:33 +0100 (CET)
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id a3f1a5c0;
        Tue, 2 Nov 2021 13:46:12 +0000 (UTC)
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 0/4] Follow up to checkpatch fixes
Date:   Tue,  2 Nov 2021 22:46:04 +0900
Message-Id: <20211102134608.1588018-1-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

This is quite some churn (especially 2nd patch) for very little gain,
I'm not quite decided on what to do with this.

First patch is harmless enough and some people care about SPDX licenses
so I guess it'll get in, and the later two are real improvements so will
definitely get in, but opinions on the big patch are definitely welcome
(along with reviews if any)

Thanks!

Dominique Martinet (4):
  9p: fix file headers
  9p: fix a bunch of checkpatch warnings
  9p v9fs_parse_options: replace simple_strtoul with kstrtouint
  9p p9mode2perm: remove useless strlcpy and check sscanf return code

 fs/9p/acl.c                |  11 +-
 fs/9p/acl.h                |  27 +--
 fs/9p/cache.c              |   4 +-
 fs/9p/v9fs.c               |  19 +-
 fs/9p/v9fs_vfs.h           |  11 +-
 fs/9p/vfs_addr.c           |   8 +-
 fs/9p/vfs_dentry.c         |   4 +-
 fs/9p/vfs_dir.c            |   2 -
 fs/9p/vfs_file.c           |   3 +-
 fs/9p/vfs_inode.c          |  29 ++-
 fs/9p/vfs_inode_dotl.c     |  11 +-
 fs/9p/vfs_super.c          |  11 +-
 fs/9p/xattr.c              |  10 +-
 fs/9p/xattr.h              |  29 +--
 include/net/9p/9p.h        |  12 +-
 include/net/9p/client.h    |  24 ++-
 include/net/9p/transport.h |  20 +-
 net/9p/client.c            | 432 ++++++++++++++++++-------------------
 net/9p/error.c             |   4 +-
 net/9p/mod.c               |  11 +-
 net/9p/protocol.c          |  38 ++--
 net/9p/protocol.h          |   4 +-
 net/9p/trans_common.c      |  10 +-
 net/9p/trans_common.h      |  12 +-
 net/9p/trans_fd.c          |   2 -
 net/9p/trans_rdma.c        |   2 -
 net/9p/trans_xen.c         |  25 +--
 27 files changed, 345 insertions(+), 430 deletions(-)

-- 
2.31.1

