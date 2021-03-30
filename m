Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A334E1D8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhC3HNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:13:37 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:37808 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhC3HNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:13:00 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.232])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id 1D894E0131;
        Tue, 30 Mar 2021 15:03:36 +0800 (CST)
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
Subject: [PATCH 0/6] Clean up obsolete TODO files
Date:   Tue, 30 Mar 2021 15:02:43 +0800
Message-Id: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZH0sYSUJISR1PS0gYVkpNSkxLQ0xDSkxISk5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NAg6FTo5ST8SNDcJPjwVHT8f
        MhRPCi1VSlVKTUpMS0NMQ0pMTUtMVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISVlXWQgBWUFISkNONwY+
X-HM-Tid: 0a7881f1e60a2c17kusn1d894e0131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is mentioned in the official documents of the Linux Foundation and WIKI 
that you can participate in its development according to the TODO files of 
each module.

But the TODO files here has not been updated for 15 years, and the function 
development described in the file have been implemented or abandoned.

Its existence will mislead developers seeking to view outdated information.

Wang Qing (6):
  mips/sgi-ip27: Delete obsolete TODO file
  scsi/aacraid: Delete obsolete TODO file
  fs/befs: Delete obsolete TODO file
  fs/jffs2: Delete obsolete TODO file
  net/ax25: Delete obsolete TODO file
  net/decnet: Delete obsolete TODO file

 arch/mips/sgi-ip27/TODO   | 19 -------------------
 drivers/scsi/aacraid/TODO |  3 ---
 fs/befs/TODO              | 14 --------------
 fs/jffs2/TODO             | 37 -------------------------------------
 net/ax25/TODO             | 20 --------------------
 net/decnet/TODO           | 40 ----------------------------------------
 6 files changed, 133 deletions(-)
 delete mode 100644 arch/mips/sgi-ip27/TODO
 delete mode 100644 drivers/scsi/aacraid/TODO
 delete mode 100644 fs/befs/TODO
 delete mode 100644 fs/jffs2/TODO
 delete mode 100644 net/ax25/TODO
 delete mode 100644 net/decnet/TODO

-- 
2.7.4

