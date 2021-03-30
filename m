Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B57B34E1E8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhC3HNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:13:42 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:37792 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhC3HNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:13:01 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.232])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id C3FCEE03F2;
        Tue, 30 Mar 2021 15:05:11 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wang Qing <wangqing@vivo.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 3/6] fs/befs: Delete obsolete TODO file
Date:   Tue, 30 Mar 2021 15:02:46 +0800
Message-Id: <1617087773-7183-4-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTk9LTxhPHx8aGUxOVkpNSkxLQ0xCSklDQ01VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pxg6Qyo*Oj8JDjcJEB02TjEO
        OjdPFElVSlVKTUpMS0NMQkpIT0pJVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISVlXWQgBWUFISktLNwY+
X-HM-Tid: 0a7881f35b5c2c17kusnc3fcee03f2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TODO file here has not been updated from 2005, and the function 
development described in the file have been implemented or abandoned.

Its existence will mislead developers seeking to view outdated information.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 fs/befs/TODO | 14 --------------
 1 file changed, 14 deletions(-)
 delete mode 100644 fs/befs/TODO

diff --git a/fs/befs/TODO b/fs/befs/TODO
deleted file mode 100644
index 3250921..0000000
--- a/fs/befs/TODO
+++ /dev/null
@@ -1,14 +0,0 @@
-TODO
-==========
-
-* Convert comments to the Kernel-Doc format.
-
-* Befs_fs.h has gotten big and messy. No reason not to break it up into 
-	smaller peices.
-
-* See if Alexander Viro's option parser made it into the kernel tree. 
-	Use that if we can. (include/linux/parser.h)
-
-* See if we really need separate types for on-disk and in-memory 
-	representations of the superblock and inode.
-
-- 
2.7.4

