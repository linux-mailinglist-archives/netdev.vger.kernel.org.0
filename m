Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79CC2A9E65
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgKFUFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:05:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728386AbgKFUFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:05:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604693104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gaY0ybpSJpkXRutKhxei8Knh0ecwQJnQ+CkTyY13P7s=;
        b=EYVE6VIF6gr4Qup2jCXN0OoX8ifgIV1RAMwv8aHVeNKV+RF9O+/7UyBIxz+o6ExSUMVcnL
        eqOj6lyQfBTXMkerNLBLbrIJY1y8RkZ64QoJh6z89dWxgzNB9PwATMFHMJySdIXs+NvsOD
        TyY0YP0zkE55GfUxWdxtqALb+OQZMGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-Nt_4lGCJNp66RnTO8qPxGg-1; Fri, 06 Nov 2020 15:05:03 -0500
X-MC-Unique: Nt_4lGCJNp66RnTO8qPxGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7237418CB725;
        Fri,  6 Nov 2020 20:05:01 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 022A76EF70;
        Fri,  6 Nov 2020 20:04:59 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH 4/5] bonding: rename bonding_sysfs_slave.c to _port.c
Date:   Fri,  6 Nov 2020 15:04:35 -0500
Message-Id: <20201106200436.943795-5-jarod@redhat.com>
In-Reply-To: <20201106200436.943795-1-jarod@redhat.com>
References: <20201106200436.943795-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that use of "slave" has been replaced by "port", rename this file too.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/Makefile                                  | 2 +-
 drivers/net/bonding/{bond_sysfs_slave.c => bond_sysfs_port.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/net/bonding/{bond_sysfs_slave.c => bond_sysfs_port.c} (100%)

diff --git a/drivers/net/bonding/Makefile b/drivers/net/bonding/Makefile
index 30e8ae3da2da..2ed0083514a6 100644
--- a/drivers/net/bonding/Makefile
+++ b/drivers/net/bonding/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_BONDING) += bonding.o
 
-bonding-objs := bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sysfs_slave.o bond_debugfs.o bond_netlink.o bond_options.o
+bonding-objs := bond_main.o bond_3ad.o bond_alb.o bond_sysfs.o bond_sysfs_port.o bond_debugfs.o bond_netlink.o bond_options.o
 
 proc-$(CONFIG_PROC_FS) += bond_procfs.o
 bonding-objs += $(proc-y)
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_port.c
similarity index 100%
rename from drivers/net/bonding/bond_sysfs_slave.c
rename to drivers/net/bonding/bond_sysfs_port.c
-- 
2.28.0

