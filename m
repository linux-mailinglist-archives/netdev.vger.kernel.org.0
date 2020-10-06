Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40936284E93
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgJFPEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJFPEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:04:30 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB76206B5;
        Tue,  6 Oct 2020 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996669;
        bh=PY4wmvXT+VsbkMbeXSfZQqLCq1o9A+65lmVNo5uodI0=;
        h=From:To:Cc:Subject:Date:From;
        b=17d7dkRSLWnugxeLLjNvhOY4YP8tDlJgDCGYikMDnx4SL4E5Do0ijHE8ip3xqc/Vb
         CHxBPoTWxKp1iSHUX6aEKQ+w3GmtDAtZ6hfa9FY/uTqkmsrMz+ogIbXF3DLi0dgicv
         oxvJyqHF3UEp1KwbBY1Q8eAnqDkdeeJKDM4ayKpE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 0/6] pause frame stats
Date:   Tue,  6 Oct 2020 08:04:19 -0700
Message-Id: <20201006150425.2631432-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds support for pause frame statistics.

First pause frame info is extended to support --json.

Pause stats are first of this kind of statistics so add
support for a new flag (--include-statistics).

Next add support for dumping policy to check if the statistics
flag is supported for a given subcommand.

Last but not least - display statistics.

Jakub Kicinski (6):
  update UAPI header copies
  pause: add --json support
  separate FLAGS out in -h
  add support for stats in subcommands
  netlink: use policy dumping to check if stats flag is supported
  pause: add support for dumping statistics

 ethtool.8.in           |   7 ++
 ethtool.c              |  17 ++++-
 internal.h             |   1 +
 netlink/coalesce.c     |   6 +-
 netlink/msgbuff.h      |   6 ++
 netlink/netlink.c      | 151 +++++++++++++++++++++++++++++++++++++++++
 netlink/netlink.h      |  23 +++++--
 netlink/pause.c        | 111 ++++++++++++++++++++++++++----
 uapi/linux/genetlink.h |  11 +++
 uapi/linux/netlink.h   |   2 +
 10 files changed, 311 insertions(+), 24 deletions(-)

-- 
2.26.2

