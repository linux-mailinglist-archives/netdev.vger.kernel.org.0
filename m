Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296C54480BC
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240170AbhKHOFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbhKHOFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:05:55 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F41C061570;
        Mon,  8 Nov 2021 06:03:10 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 093CBC01C; Mon,  8 Nov 2021 15:03:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1636380188; bh=8d1SRJTILJ3jSIx5wk4bJ3Oi9mCX4rFkHpU/0zIOD/c=;
        h=Date:From:To:Cc:Subject:From;
        b=EJabDiL1MEbknzfQkHhzT0Dtf5hWDJ8Ue/enXJuEyjfNS42O7Eh2oi5CA6nxng39f
         TxwQhzd6dLsC4LVdjxLaH8T2u2QfLHGTZr2BqF1zxJDZjmO1KEb4Rxls98fPTt6GEU
         tph5p1DSs3sP1Adrx7vVYPoJpyF3wNGMDsfPZigGV2jW2XZPxIpabyxspaw6ieF/Wo
         XHEyNqsmc108hdawGT7vPaV/By183dRvFecGsK1uUw4CbO5idzcqZ3MC2I09XFS+ls
         VOtwcMHdLJzqJIiwX6umDzf0oWtV6yi41lmwlZlUg1BzyTvW6Da7s/rwnsQXU7D9U3
         Lrl1FbTcYNi9Q==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id AE3D6C009;
        Mon,  8 Nov 2021 15:03:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1636380187; bh=8d1SRJTILJ3jSIx5wk4bJ3Oi9mCX4rFkHpU/0zIOD/c=;
        h=Date:From:To:Cc:Subject:From;
        b=aABpJMwHvyGlEABHKFx++J8MSyggP5v2ObDAsyOFDPyBRdkwALhz8Fdok67xFOTJu
         1GxcuEIF4qG2j6bQPS6P3y6Xoc+CEpwuXW6w4p4RLRdYr3IKj4lhsYl5CziX/eCHCL
         0/N7E9wsINhyJD4MWOSF1vnT6Zda/3b181IQykBBC2cLW117qz/cEjUCppU9SMfUuq
         13S4oNgVIe+nmLzuC2Spm9TVPLo7fOielWS8DeWKlsAC847xUcgBmYl917GEBYDhtr
         5H+jdJ9/twVFVWTDtjjlm808wvA5XU7LMVta2NgTOpd57mRpDqgZgS56sfsEr+G9Sm
         Lq8nQx1/lOhAw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 597cbc73;
        Mon, 8 Nov 2021 14:03:02 +0000 (UTC)
Date:   Mon, 8 Nov 2021 23:02:47 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: [GIT PULL] 9p for 5.16-rc1
Message-ID: <YYkuBxbTYS2ANFnK@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Linus,

I've been hesitant on the checkpatch fixes: it's a large batch of noise
that doesn't give much value, but I guess going forward it's good if
I can have a baseline to keep enforcing and it'll prevent getting more
half-assed drive-by style patches that aren't even correct like I've
had...

If you have an opinion on it feel free to just drop the last patch, the
rest still probably makes sense.



The following changes since commit 8bb7eca972ad531c9b149c0a51ab43a417385813:

  Linux 5.15 (2021-10-31 13:53:10 -0700)

are available in the Git repository at:

  git://github.com/martinetd/linux tags/9p-for-5.16-rc1

for you to fetch changes up to 6e195b0f7c8e50927fa31946369c22a0534ec7e2:

  9p: fix a bunch of checkpatch warnings (2021-11-04 21:04:25 +0900)

----------------------------------------------------------------
9p-for-5.16-rc1: fixes, netfs read support and checkpatch rewrite

- fix syzcaller uninitialized value usage after missing error check
- add module autoloading based on transport name
- convert cached reads to use netfs helpers
- adjust readahead based on transport msize
- and many, many checkpatch.pl warning fixes...

----------------------------------------------------------------
David Howells (1):
      9p: Convert to using the netfs helper lib to do reads and caching

Dominique Martinet (7):
      9p/net: fix missing error check in p9_check_errors
      fscache_cookie_enabled: check cookie is valid before accessing it
      9p: fix file headers
      9p v9fs_parse_options: replace simple_strtoul with kstrtouint
      9p p9mode2perm: remove useless strlcpy and check sscanf return code
      9p: set readahead and io size according to maxsize
      9p: fix a bunch of checkpatch warnings

Sohaib Mohamed (4):
      fs/9p: cleanup: opening brace at the beginning of the next line
      9p: fix minor indentation and codestyle
      fs/9p: fix warnings found by checkpatch.pl
      fs/9p: fix indentation and Add missing a blank line after declaration

Thomas Weißschuh (1):
      net/9p: autoload transport modules

 fs/9p/Kconfig              |   1 +
 fs/9p/acl.c                |  11 +---
 fs/9p/acl.h                |  27 ++++-----
 fs/9p/cache.c              | 141 +-------------------------------------------
 fs/9p/cache.h              |  97 +-----------------------------
 fs/9p/fid.c                |   3 +-
 fs/9p/v9fs.c               |  22 ++++---
 fs/9p/v9fs.h               |  17 ++++--
 fs/9p/v9fs_vfs.h           |  11 ++--
 fs/9p/vfs_addr.c           | 215 +++++++++++++++++++++++++++++++++---------------------------------
 fs/9p/vfs_dentry.c         |   4 +-
 fs/9p/vfs_dir.c            |   6 +-
 fs/9p/vfs_file.c           |  20 +++++--
 fs/9p/vfs_inode.c          |  29 +++++----
 fs/9p/vfs_inode_dotl.c     |  11 ++--
 fs/9p/vfs_super.c          |  14 +++--
 fs/9p/xattr.c              |  10 +---
 fs/9p/xattr.h              |  29 ++++-----
 include/linux/fscache.h    |   2 +-
 include/net/9p/9p.h        |  12 ++--
 include/net/9p/client.h    |  24 ++++----
 include/net/9p/transport.h |  26 ++++----
 net/9p/client.c            | 434 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------
 net/9p/error.c             |   4 +-
 net/9p/mod.c               |  41 ++++++++-----
 net/9p/protocol.c          |  38 ++++++------
 net/9p/protocol.h          |   4 +-
 net/9p/trans_common.c      |  10 +---
 net/9p/trans_common.h      |  12 +---
 net/9p/trans_fd.c          |   2 -
 net/9p/trans_rdma.c        |   3 +-
 net/9p/trans_virtio.c      |   1 +
 net/9p/trans_xen.c         |  26 +-------
 33 files changed, 523 insertions(+), 784 deletions(-)





============================

The same stats without the last patch
 fs/9p/Kconfig              |   1 +
 fs/9p/acl.c                |  10 +------
 fs/9p/acl.h                |  10 +------
 fs/9p/cache.c              | 137 ----------------------------------------------------------------------------------------
 fs/9p/cache.h              |  97 ++------------------------------------------------------------
 fs/9p/fid.c                |   3 +-
 fs/9p/v9fs.c               |  18 ++++++------
 fs/9p/v9fs.h               |  17 ++++++++---
 fs/9p/vfs_addr.c           | 209 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
 fs/9p/vfs_dentry.c         |   2 --
 fs/9p/vfs_dir.c            |   6 ++--
 fs/9p/vfs_file.c           |  19 +++++++++----
 fs/9p/vfs_inode.c          |  15 ++++++----
 fs/9p/vfs_inode_dotl.c     |   2 --
 fs/9p/vfs_super.c          |   7 ++---
 fs/9p/xattr.c              |  10 +------
 fs/9p/xattr.h              |  10 +------
 include/linux/fscache.h    |   2 +-
 include/net/9p/9p.h        |   2 --
 include/net/9p/client.h    |   2 --
 include/net/9p/transport.h |   8 ++++--
 net/9p/client.c            |   4 +--
 net/9p/error.c             |   2 --
 net/9p/mod.c               |  32 +++++++++++++++------
 net/9p/protocol.c          |   2 --
 net/9p/protocol.h          |   2 --
 net/9p/trans_common.c      |  10 +------
 net/9p/trans_common.h      |  10 +------
 net/9p/trans_fd.c          |   2 --
 net/9p/trans_rdma.c        |   3 +-
 net/9p/trans_virtio.c      |   1 +
 net/9p/trans_xen.c         |  26 ++---------------
 32 files changed, 201 insertions(+), 480 deletions(-)

-- 
Dominique Martinet | Asmadeus
