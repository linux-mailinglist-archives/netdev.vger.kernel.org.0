Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4B248E117
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 00:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbiAMXl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 18:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235773AbiAMXlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 18:41:55 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B68C06173E;
        Thu, 13 Jan 2022 15:41:55 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D3E00C01A; Fri, 14 Jan 2022 00:41:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1642117312; bh=2aEkqz5/AQOW2kreM22bx+J68/cwIwKWJKqmf4QjsjY=;
        h=Date:From:To:Cc:Subject:From;
        b=fOCM/jGT4Vooq5gEl0Un1DBDULNAt5Y+iZKAL2CHv6Js5Wkfff6LKgMKcEND+dbIQ
         FkV0j7bZdD6WfAcVvNP3vsyQ+v9rSPqbk0ZsCPYPFc7f99GHcxmD4GzcWW1Msx+zOq
         cFxYVohFnbOqIaOnBOn1KoguhqxcubeH3pctTcspAPXigl0WMwcpDCTmpFoW0SdA2C
         j2TadpDRx6tPf1gYAJHaFJeZ94VWHxqUCI9gmkCcKzHsjVHyn5v+hidi6rYVMjnjUI
         UXhCmX9TywFDDmX5cdZk55j/u6Vj6cfviofSMl+6Kro12YJm4GzaJbr1XGFsDyuGGO
         Ip95DHVI1XHjA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E9BABC009;
        Fri, 14 Jan 2022 00:41:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1642117312; bh=2aEkqz5/AQOW2kreM22bx+J68/cwIwKWJKqmf4QjsjY=;
        h=Date:From:To:Cc:Subject:From;
        b=fOCM/jGT4Vooq5gEl0Un1DBDULNAt5Y+iZKAL2CHv6Js5Wkfff6LKgMKcEND+dbIQ
         FkV0j7bZdD6WfAcVvNP3vsyQ+v9rSPqbk0ZsCPYPFc7f99GHcxmD4GzcWW1Msx+zOq
         cFxYVohFnbOqIaOnBOn1KoguhqxcubeH3pctTcspAPXigl0WMwcpDCTmpFoW0SdA2C
         j2TadpDRx6tPf1gYAJHaFJeZ94VWHxqUCI9gmkCcKzHsjVHyn5v+hidi6rYVMjnjUI
         UXhCmX9TywFDDmX5cdZk55j/u6Vj6cfviofSMl+6Kro12YJm4GzaJbr1XGFsDyuGGO
         Ip95DHVI1XHjA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0509ad97;
        Thu, 13 Jan 2022 23:41:47 +0000 (UTC)
Date:   Fri, 14 Jan 2022 08:41:32 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: [GIT PULL] 9p for 5.17-rc1
Message-ID: <YeC4rCJjQhLOJGlH@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 2585cf9dfaaddf00b069673f27bb3f8530e2039c:

  Linux 5.16-rc5 (2021-12-12 14:53:01 -0800)

are available in the Git repository at:

  git://github.com/martinetd/linux tags/9p-for-5.17-rc1

for you to fetch changes up to 19d1c32652bbbf406063025354845fdddbcecd3a:

  9p: fix enodata when reading growing file (2022-01-11 15:21:53 +0900)

----------------------------------------------------------------
9p-for-5.17-rc1: fixes, split 9p_net_fd, new reviewer

- fix possible uninitialized memory usage for setattr
- fix fscache reading hole in a file just after it's been grown
- split net/9p/trans_fd.c in its own module like other transports
  that module defaults to 9P_NET and is autoloaded if required so
  users should not be impacted
- add Christian Schoenebeck to 9p reviewers
- some more trivial cleanup

----------------------------------------------------------------
Changcheng Deng (1):
      fs: 9p: remove unneeded variable

Christian Brauner (1):
      9p: only copy valid iattrs in 9P2000.L setattr implementation

Christian Schoenebeck (2):
      MAINTAINERS: 9p: add Christian Schoenebeck as reviewer
      net/9p: show error message if user 'msize' cannot be satisfied

Dominique Martinet (1):
      9p: fix enodata when reading growing file

Thomas Weißschuh (3):
      9p/trans_fd: split into dedicated module
      9p/xen: autoload when xenbus service is available
      net/p9: load default transports

Zhang Mingyu (1):
      9p: Use BUG_ON instead of if condition followed by BUG.

zhuxinran (1):
      9p/trans_virtio: Fix typo in the comment for p9_virtio_create()

 MAINTAINERS                |  1 +
 fs/9p/vfs_addr.c           |  5 +++++
 fs/9p/vfs_file.c           |  6 ++----
 fs/9p/vfs_inode_dotl.c     | 29 ++++++++++++++++++++---------
 include/net/9p/9p.h        |  2 --
 include/net/9p/transport.h |  2 +-
 net/9p/Kconfig             |  7 +++++++
 net/9p/Makefile            |  5 ++++-
 net/9p/client.c            |  7 ++++++-
 net/9p/mod.c               | 15 +++++++++++----
 net/9p/trans_fd.c          | 14 ++++++++++++--
 net/9p/trans_virtio.c      |  2 +-
 net/9p/trans_xen.c         |  1 +
 13 files changed, 71 insertions(+), 25 deletions(-)

-- 
Dominique
