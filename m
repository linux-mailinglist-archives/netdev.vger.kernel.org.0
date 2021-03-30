Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D394E34E1DF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhC3HNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:13:40 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:37764 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhC3HNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:13:00 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2021 03:12:59 EDT
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.232])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id 2743DE02F4;
        Tue, 30 Mar 2021 15:04:52 +0800 (CST)
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
Subject: [PATCH 1/6] mips/sgi-ip27: Delete obsolete TODO file
Date:   Tue, 30 Mar 2021 15:02:44 +0800
Message-Id: <1617087773-7183-2-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZS0keGR5MTE1IH0pOVkpNSkxLQ0xDQkhLSEtVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MAg6Sio*UT8KQzcdLh8rTxBM
        GUoKFFZVSlVKTUpMS0NMQ0JISExDVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISVlXWQgBWUFIQ09JNwY+
X-HM-Tid: 0a7881f30dd92c17kusn2743de02f4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TODO file here has not been updated for 15 years, and the function 
development described in the file have been implemented or abandoned.

Its existence will mislead developers seeking to view outdated information.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 arch/mips/sgi-ip27/TODO | 19 -------------------
 1 file changed, 19 deletions(-)
 delete mode 100644 arch/mips/sgi-ip27/TODO

diff --git a/arch/mips/sgi-ip27/TODO b/arch/mips/sgi-ip27/TODO
deleted file mode 100644
index 160857ff..0000000
--- a/arch/mips/sgi-ip27/TODO
+++ /dev/null
@@ -1,19 +0,0 @@
-1. Need to figure out why PCI writes to the IOC3 hang, and if it is okay
-not to write to the IOC3 ever.
-2. Need to figure out RRB allocation in bridge_startup().
-3. Need to figure out why address swaizzling is needed in inw/outw for
-Qlogic scsi controllers.
-4. Need to integrate ip27-klconfig.c:find_lboard and
-ip27-init.c:find_lbaord_real. DONE
-5. Is it okay to set calias space on all nodes as 0, instead of 8k as
-in irix?
-6. Investigate why things do not work without the setup_test() call
-being invoked on all nodes in ip27-memory.c.
-8. Too many do_page_faults invoked - investigate.
-9. start_thread must turn off UX64 ... and define tlb_refill_debug.
-10. Need a bad pmd table, bad pte table. __bad_pmd_table/__bad_pagetable
-does not agree with pgd_bad/pmd_bad.
-11. All intrs (ip27_do_irq handlers) are targeted at cpu A on the node.
-This might need to change later. Only the timer intr is set up to be
-received on both Cpu A and B. (ip27_do_irq()/bridge_startup())
-13. Cache flushing (specially the SMP version) has to be investigated.
-- 
2.7.4

