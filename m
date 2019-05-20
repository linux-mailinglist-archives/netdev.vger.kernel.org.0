Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05D8244BD
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfETXwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:52:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37884 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfETXwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 19:52:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNiSvo170895;
        Mon, 20 May 2019 23:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=O+tJxqlUjzABw3lOkORNAtDMSCN0ydyzH7rxMfH7MEg=;
 b=eg2ulj6KvwHsMt1JC6AhAGTepuT6VQbjhPCnoVzDzVo+ruxf5WjqP4d7bfea38IJ/X9W
 5pKdWQ47h4LtQk0lEkSHbIsTLW0a/yzLf6QC25LXqNcrQLdG69BgdsZxrr0mCH5TZePN
 56GtpNMYOl3ja4KfojaLXecJu9PmOdQspGIRZ/jAAQOW6nhvR00PLECVUiwtiI4ipsC+
 8aWrjqSaPfZ8Qreog1bP+Mahjs/L1peNXQXHaEpwuALSGypQU34XsqiI4fXRR4TSxAY0
 xdf1zHQJLNXx8Pyb6RVMQelLVqCM2wWkKl0WXb4n2LMOqLMbba4aEb9paTE5jbYhY9Hi WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj8c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:51:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNo7lp017604;
        Mon, 20 May 2019 23:51:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2sm046nevw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 May 2019 23:51:20 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4KNpKjn019713;
        Mon, 20 May 2019 23:51:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sm046nevs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:51:20 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNpJfL032370;
        Mon, 20 May 2019 23:51:19 GMT
Message-Id: <201905202351.x4KNpJfL032370@aserv0121.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 20 May 2019 23:51:19 +0000
MIME-Version: 1.0
Date:   Mon, 20 May 2019 23:51:19 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 05/11] trace: update Kconfig and Makefile to include
 DTrace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=948 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds the dtrace implementation in kernel/trace/dtrace to
the trace Kconfig and Makefile.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 kernel/trace/Kconfig  | 2 ++
 kernel/trace/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 5d965cef6c77..59c3bdfbaffc 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -786,6 +786,8 @@ config GCOV_PROFILE_FTRACE
 	  Note that on a kernel compiled with this config, ftrace will
 	  run significantly slower.
 
+source "kernel/trace/dtrace/Kconfig"
+
 endif # FTRACE
 
 endif # TRACING_SUPPORT
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c2b2148bb1d2..e643c4eac8f6 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -82,6 +82,7 @@ endif
 obj-$(CONFIG_DYNAMIC_EVENTS) += trace_dynevent.o
 obj-$(CONFIG_PROBE_EVENTS) += trace_probe.o
 obj-$(CONFIG_UPROBE_EVENTS) += trace_uprobe.o
+obj-$(CONFIG_DTRACE) += dtrace/
 
 obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
 
-- 
2.20.1

