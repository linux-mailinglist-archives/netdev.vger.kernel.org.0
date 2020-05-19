Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABF81DA0AD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgESTKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:10:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3734 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726474AbgESTKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:10:23 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ4KJ7193341;
        Tue, 19 May 2020 15:10:20 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312c23jp44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 15:10:20 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04JJ6R0U017571;
        Tue, 19 May 2020 19:10:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 313xas273x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 May 2020 19:10:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04JJAFcM29884546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 19:10:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFE77A405E;
        Tue, 19 May 2020 19:10:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 804FCA4072;
        Tue, 19 May 2020 19:10:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 May 2020 19:10:15 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: [PATCH net-next 1/5] net/iucv: remove pm support
Date:   Tue, 19 May 2020 21:10:08 +0200
Message-Id: <20200519191012.65438-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200519191012.65438-1-jwi@linux.ibm.com>
References: <20200519191012.65438-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_08:2020-05-19,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 cotscore=-2147483648 lowpriorityscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 394216275c7d ("s390: remove broken hibernate / power management support")
removed support for ARCH_HIBERNATION_POSSIBLE from s390.

So drop the unused pm ops from the s390-only iucv bus driver.

CC: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/iucv.c | 188 ------------------------------------------------
 1 file changed, 188 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 9a2d023842fe..19250a0c85d3 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -67,32 +67,9 @@ static int iucv_bus_match(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
-enum iucv_pm_states {
-	IUCV_PM_INITIAL = 0,
-	IUCV_PM_FREEZING = 1,
-	IUCV_PM_THAWING = 2,
-	IUCV_PM_RESTORING = 3,
-};
-static enum iucv_pm_states iucv_pm_state;
-
-static int iucv_pm_prepare(struct device *);
-static void iucv_pm_complete(struct device *);
-static int iucv_pm_freeze(struct device *);
-static int iucv_pm_thaw(struct device *);
-static int iucv_pm_restore(struct device *);
-
-static const struct dev_pm_ops iucv_pm_ops = {
-	.prepare = iucv_pm_prepare,
-	.complete = iucv_pm_complete,
-	.freeze = iucv_pm_freeze,
-	.thaw = iucv_pm_thaw,
-	.restore = iucv_pm_restore,
-};
-
 struct bus_type iucv_bus = {
 	.name = "iucv",
 	.match = iucv_bus_match,
-	.pm = &iucv_pm_ops,
 };
 EXPORT_SYMBOL(iucv_bus);
 
@@ -434,31 +411,6 @@ static void iucv_block_cpu(void *data)
 	cpumask_clear_cpu(cpu, &iucv_irq_cpumask);
 }
 
-/**
- * iucv_block_cpu_almost
- * @data: unused
- *
- * Allow connection-severed interrupts only on this cpu.
- */
-static void iucv_block_cpu_almost(void *data)
-{
-	int cpu = smp_processor_id();
-	union iucv_param *parm;
-
-	/* Allow iucv control interrupts only */
-	parm = iucv_param_irq[cpu];
-	memset(parm, 0, sizeof(union iucv_param));
-	parm->set_mask.ipmask = 0x08;
-	iucv_call_b2f0(IUCV_SETMASK, parm);
-	/* Allow iucv-severed interrupt only */
-	memset(parm, 0, sizeof(union iucv_param));
-	parm->set_mask.ipmask = 0x20;
-	iucv_call_b2f0(IUCV_SETCONTROLMASK, parm);
-
-	/* Clear indication that iucv interrupts are allowed for this cpu. */
-	cpumask_clear_cpu(cpu, &iucv_irq_cpumask);
-}
-
 /**
  * iucv_declare_cpu
  * @data: unused
@@ -1834,146 +1786,6 @@ static void iucv_external_interrupt(struct ext_code ext_code,
 	spin_unlock(&iucv_queue_lock);
 }
 
-static int iucv_pm_prepare(struct device *dev)
-{
-	int rc = 0;
-
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_INFO "iucv_pm_prepare\n");
-#endif
-	if (dev->driver && dev->driver->pm && dev->driver->pm->prepare)
-		rc = dev->driver->pm->prepare(dev);
-	return rc;
-}
-
-static void iucv_pm_complete(struct device *dev)
-{
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_INFO "iucv_pm_complete\n");
-#endif
-	if (dev->driver && dev->driver->pm && dev->driver->pm->complete)
-		dev->driver->pm->complete(dev);
-}
-
-/**
- * iucv_path_table_empty() - determine if iucv path table is empty
- *
- * Returns 0 if there are still iucv pathes defined
- *	   1 if there are no iucv pathes defined
- */
-static int iucv_path_table_empty(void)
-{
-	int i;
-
-	for (i = 0; i < iucv_max_pathid; i++) {
-		if (iucv_path_table[i])
-			return 0;
-	}
-	return 1;
-}
-
-/**
- * iucv_pm_freeze() - Freeze PM callback
- * @dev:	iucv-based device
- *
- * disable iucv interrupts
- * invoke callback function of the iucv-based driver
- * shut down iucv, if no iucv-pathes are established anymore
- */
-static int iucv_pm_freeze(struct device *dev)
-{
-	int cpu;
-	struct iucv_irq_list *p, *n;
-	int rc = 0;
-
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "iucv_pm_freeze\n");
-#endif
-	if (iucv_pm_state != IUCV_PM_FREEZING) {
-		for_each_cpu(cpu, &iucv_irq_cpumask)
-			smp_call_function_single(cpu, iucv_block_cpu_almost,
-						 NULL, 1);
-		cancel_work_sync(&iucv_work);
-		list_for_each_entry_safe(p, n, &iucv_work_queue, list) {
-			list_del_init(&p->list);
-			iucv_sever_pathid(p->data.ippathid,
-					  iucv_error_no_listener);
-			kfree(p);
-		}
-	}
-	iucv_pm_state = IUCV_PM_FREEZING;
-	if (dev->driver && dev->driver->pm && dev->driver->pm->freeze)
-		rc = dev->driver->pm->freeze(dev);
-	if (iucv_path_table_empty())
-		iucv_disable();
-	return rc;
-}
-
-/**
- * iucv_pm_thaw() - Thaw PM callback
- * @dev:	iucv-based device
- *
- * make iucv ready for use again: allocate path table, declare interrupt buffers
- *				  and enable iucv interrupts
- * invoke callback function of the iucv-based driver
- */
-static int iucv_pm_thaw(struct device *dev)
-{
-	int rc = 0;
-
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "iucv_pm_thaw\n");
-#endif
-	iucv_pm_state = IUCV_PM_THAWING;
-	if (!iucv_path_table) {
-		rc = iucv_enable();
-		if (rc)
-			goto out;
-	}
-	if (cpumask_empty(&iucv_irq_cpumask)) {
-		if (iucv_nonsmp_handler)
-			/* enable interrupts on one cpu */
-			iucv_allow_cpu(NULL);
-		else
-			/* enable interrupts on all cpus */
-			iucv_setmask_mp();
-	}
-	if (dev->driver && dev->driver->pm && dev->driver->pm->thaw)
-		rc = dev->driver->pm->thaw(dev);
-out:
-	return rc;
-}
-
-/**
- * iucv_pm_restore() - Restore PM callback
- * @dev:	iucv-based device
- *
- * make iucv ready for use again: allocate path table, declare interrupt buffers
- *				  and enable iucv interrupts
- * invoke callback function of the iucv-based driver
- */
-static int iucv_pm_restore(struct device *dev)
-{
-	int rc = 0;
-
-#ifdef CONFIG_PM_DEBUG
-	printk(KERN_WARNING "iucv_pm_restore %p\n", iucv_path_table);
-#endif
-	if ((iucv_pm_state != IUCV_PM_RESTORING) && iucv_path_table)
-		pr_warn("Suspending Linux did not completely close all IUCV connections\n");
-	iucv_pm_state = IUCV_PM_RESTORING;
-	if (cpumask_empty(&iucv_irq_cpumask)) {
-		rc = iucv_query_maxconn();
-		rc = iucv_enable();
-		if (rc)
-			goto out;
-	}
-	if (dev->driver && dev->driver->pm && dev->driver->pm->restore)
-		rc = dev->driver->pm->restore(dev);
-out:
-	return rc;
-}
-
 struct iucv_interface iucv_if = {
 	.message_receive = iucv_message_receive,
 	.__message_receive = __iucv_message_receive,
-- 
2.17.1

