Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9727334E1E9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhC3HNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:13:42 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:37818 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhC3HNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:13:02 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.232])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id F3B90E022C;
        Tue, 30 Mar 2021 15:05:27 +0800 (CST)
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
Subject: [PATCH 5/6] net/ax25: Delete obsolete TODO file
Date:   Tue, 30 Mar 2021 15:02:48 +0800
Message-Id: <1617087773-7183-6-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHUhMTU9DT0pLGkseVkpNSkxLQ0xCSUNDSExVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NCo6Axw5ND8SEjdNLh1WTikW
        NB4aCklVSlVKTUpMS0NMQklCSkxNVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISVlXWQgBWUFITkpONwY+
X-HM-Tid: 0a7881f399782c17kusnf3b90e022c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TODO file here has not been updated for 13 years, and the function 
development described in the file have been implemented or abandoned.

Its existence will mislead developers seeking to view outdated information.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 net/ax25/TODO | 20 --------------------
 1 file changed, 20 deletions(-)
 delete mode 100644 net/ax25/TODO

diff --git a/net/ax25/TODO b/net/ax25/TODO
deleted file mode 100644
index 69fb4e3..0000000
--- a/net/ax25/TODO
+++ /dev/null
@@ -1,20 +0,0 @@
-Do the ax25_list_lock, ax25_dev_lock, linkfail_lockreally, ax25_frag_lock and
-listen_lock have to be bh-safe?
-
-Do the netrom and rose locks have to be bh-safe?
-
-A device might be deleted after lookup in the SIOCADDRT ioctl but before it's
-being used.
-
-Routes to a device being taken down might be deleted by ax25_rt_device_down
-but added by somebody else before the device has been deleted fully.
-
-The ax25_rt_find_route synopsys is pervert but I somehow had to deal with
-the race caused by the static variable in it's previous implementation.
-
-Implement proper socket locking in netrom and rose.
-
-Check socket locking when ax25_rcv is sending to raw sockets.  In particular
-ax25_send_to_raw() seems fishy.  Heck - ax25_rcv is fishy.
-
-Handle XID and TEST frames properly.
-- 
2.7.4

