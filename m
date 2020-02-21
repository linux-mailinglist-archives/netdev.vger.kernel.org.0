Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4141687F7
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgBUT5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:57:05 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43108 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgBUT5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 14:57:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id s1so1779134pfh.10
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 11:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=es-iitr-ac-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=btdpP75zyRVNd2zdgzUEwBQJP+VyfWPJzrchDwkOdOs=;
        b=PEKn2MBcmvOEnkpWiIbdjv9ZxqEbvv+hAMODBy0nzIAv4StveA+VGLTeX2JDlTFEJp
         tdcNhIA+M1Nwm3hEkKkVeDapbpCcNaSrHKuMod09Ej5rITU1adajdij1pqlZmVx6EBXW
         XTq2YspggUFvNn91B6mYvitzYdXAxxYC71zP2AKUql8n6+wROY/qu9O6X4LSv2gUcnpa
         +0RZ8xM8AriE5vZgEyNnHmHJjsDRAjqb7dg0Vo4c//+95R+IaT/Dl9GQtEL7I/RraezV
         nE4xMHTV6ZhGG5KkmN7W51vDD9/utKvHatkX0CHIh/mYu7r0cYaA3Mgk2D1gEfFCSP9R
         fbbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=btdpP75zyRVNd2zdgzUEwBQJP+VyfWPJzrchDwkOdOs=;
        b=LNNsoXKSbMusg47nuk2HynOHZtzh7OpOs8CF1lEvDCWomWt0rAmeMP9VuyAzk0C9cQ
         JCyhiupFRSwvXWitRk5f6GqGhTZM62hYigEGj6niCoZWeh7An54whDGsR2Tc2vNQsjKC
         lclzEChRdn6i/vsuaDTnxowdpnadeRkRve0u+3UeYeCqcknAIz34OoHBOEZNC30nDuAR
         1O4sX4sPuLsPbhJrXb42r0wFkzVf4kZ1/CWoz1m/j6wVKXwUb4kI7L+ItCwRZ/E+S99Y
         Q9A6qYNJ3iyHB8S2TB/oZ7KBcpFkhPoIuaWC3PIE1lLPOYg/PJeoAuMkoglJ0DNWplUh
         MAiA==
X-Gm-Message-State: APjAAAWuCFT7JfFArT0O2xjoo9qnWWkKVun3BlLQ8sbwQq8PzGyZ+dGL
        IMqv9cNpAqmQl0/N2CD8RecUgQ==
X-Google-Smtp-Source: APXvYqyuzt+qh+/9qPz7Xo4v2MMC+7vbZxDZI/rp3+7oRsDVJjoc9KxF/5d1CXRa9xg4vob5FiB3Tg==
X-Received: by 2002:a63:487:: with SMTP id 129mr39862540pge.193.1582315019992;
        Fri, 21 Feb 2020 11:56:59 -0800 (PST)
Received: from kaaira-HP-Pavilion-Notebook ([103.37.201.178])
        by smtp.gmail.com with ESMTPSA id x28sm3274324pgc.83.2020.02.21.11.56.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 11:56:59 -0800 (PST)
Date:   Sat, 22 Feb 2020 01:26:49 +0530
From:   Kaaira Gupta <kgupta@es.iitr.ac.in>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: add braces around macro arguments
Message-ID: <20200221195649.GA18450@kaaira-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch.pl warnings of adding braces around macro arguments to
prevent precedence issues by adding braces in qlge_dbg.c

Signed-off-by: Kaaira Gupta <kgupta@es.iitr.ac.in>
---
 drivers/staging/qlge/qlge_dbg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 8cf39615c520..c7af2548d119 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1525,7 +1525,7 @@ void ql_dump_regs(struct ql_adapter *qdev)
 #ifdef QL_STAT_DUMP
 
 #define DUMP_STAT(qdev, stat)	\
-	pr_err("%s = %ld\n", #stat, (unsigned long)qdev->nic_stats.stat)
+	pr_err("%s = %ld\n", #stat, (unsigned long)(qdev)->nic_stats.stat)
 
 void ql_dump_stat(struct ql_adapter *qdev)
 {
@@ -1578,12 +1578,12 @@ void ql_dump_stat(struct ql_adapter *qdev)
 #ifdef QL_DEV_DUMP
 
 #define DUMP_QDEV_FIELD(qdev, type, field)		\
-	pr_err("qdev->%-24s = " type "\n", #field, qdev->field)
+	pr_err("qdev->%-24s = " type "\n", #field, (qdev)->(field))
 #define DUMP_QDEV_DMA_FIELD(qdev, field)		\
 	pr_err("qdev->%-24s = %llx\n", #field, (unsigned long long)qdev->field)
 #define DUMP_QDEV_ARRAY(qdev, type, array, index, field) \
 	pr_err("%s[%d].%s = " type "\n",		 \
-	       #array, index, #field, qdev->array[index].field);
+	       #array, index, #field, (qdev)->array[index].field);
 void ql_dump_qdev(struct ql_adapter *qdev)
 {
 	int i;
-- 
2.17.1

