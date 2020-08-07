Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B423ECED
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgHGLvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:51:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36502 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgHGLvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 07:51:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 077BmC3q067021;
        Fri, 7 Aug 2020 11:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=BzRCQKw4HJidRU+uGZjtCmLzqvvN9xHo3BaIpDfHdFI=;
 b=eC3rj+WqLjibfxMc8cBJn3xQ7T5RWcR9Fi15EaKyTm3zJsjjs7fJmMcg8ohGQvKzdZFJ
 Og8lRTpa0h4W3dX+/Vh+DsTgo0JKdFbRAyqQBt9xbs7p0reXCUN0OTUAlbaFdghOE3J6
 yp3LMKkv3LxUY8/MHjTcUr8fNgemJyml4rNVywNyd1vdX9VHe566w7cOU1QfTRXU7sc7
 TgLDBkczJBpfDIPezM9A8O04JcrCm30jQotAMyqXNA8CPmTXBILPQInF5lmA0FNZH6oa
 SPzgvASaHBWOGA5mxqRCU/p4Vn161eY+rpexvUNPHSbGyl24IKMQenr5bzjMHKjnQicP 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32r6ep84af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 07 Aug 2020 11:50:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 077BnEcx045454;
        Fri, 7 Aug 2020 11:50:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32qy8qfmuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Aug 2020 11:50:59 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 077BosmC014478;
        Fri, 7 Aug 2020 11:50:54 GMT
Received: from localhost.uk.oracle.com (/10.175.183.82)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Aug 2020 04:50:54 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf] bpf: doc: remove references to warning message when using bpf_trace_printk()
Date:   Fri,  7 Aug 2020 12:50:29 +0100
Message-Id: <1596801029-32395-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1011 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070085
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF helper bpf_trace_printk() no longer uses trace_printk();
it is now triggers a dedicated trace event.  Hence the described
warning is no longer present, so remove the discussion of it as
it may confuse people.

Fixes: ac5a72ea5c89 ("bpf: Use dedicated bpf_trace_printk event instead of trace_printk()")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 Documentation/bpf/bpf_design_QA.rst | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 12a246f..2df7b06 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -246,17 +246,6 @@ program is loaded the kernel will print warning message, so
 this helper is only useful for experiments and prototypes.
 Tracing BPF programs are root only.
 
-Q: bpf_trace_printk() helper warning
-------------------------------------
-Q: When bpf_trace_printk() helper is used the kernel prints nasty
-warning message. Why is that?
-
-A: This is done to nudge program authors into better interfaces when
-programs need to pass data to user space. Like bpf_perf_event_output()
-can be used to efficiently stream data via perf ring buffer.
-BPF maps can be used for asynchronous data sharing between kernel
-and user space. bpf_trace_printk() should only be used for debugging.
-
 Q: New functionality via kernel modules?
 ----------------------------------------
 Q: Can BPF functionality such as new program or map types, new
-- 
1.8.3.1

