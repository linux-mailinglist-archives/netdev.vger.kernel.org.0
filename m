Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149FD1DE5A2
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgEVLhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:37:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729547AbgEVLhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:37:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBVu2m132476;
        Fri, 22 May 2020 11:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+FjdjgYcVi4r98g3F91Ao5Gxe2VO+XK+5v8S74uZUwQ=;
 b=dia318lqqlUayI26djSwcS7DiCmxcjaa+SwLEC/HruQiIGLszZcF8b+rNJqfT15t+8bi
 fnoa5l+gW5TJaiMp+sgyKUWX6TnOOzZ1Kq6QRYQ8J8XwvmpjywZLX/qfKSfvOPd0vQsy
 c431FO5BQC0QhW6ssqC0ZGawQ9cSYpaNmjobT6Hk7SEsV1lIeKkeMhsj7D7XqRjwmhFy
 vDCPdIoPdk2B0HdS67noD/Zlc6qc4b5pMWxRPiF9n6q0EKrYaaRvXsZt50mjzRQIKh94
 JaiNkxe5PaA2Ozc0YVSrEojyOHvQ91Kolty2AmvqBgpi+SyG/uMG+JqMiCu+HgJCwbqH SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284md9be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 11:36:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBWcgI038387;
        Fri, 22 May 2020 11:36:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gmb0f66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 11:36:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MBae3X005884;
        Fri, 22 May 2020 11:36:40 GMT
Received: from localhost.uk.oracle.com (/10.175.194.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 04:36:40 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        shuah@kernel.org, sean@mess.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf 1/2] selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o
Date:   Fri, 22 May 2020 12:36:28 +0100
Message-Id: <1590147389-26482-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590147389-26482-1-git-send-email-alan.maguire@oracle.com>
References: <1590147389-26482-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_seg6_loop.o uses the helper bpf_lwt_seg6_adjust_srh();
it will not be present if CONFIG_IPV6_SEG6_BPF is not specified.

Fixes: b061017f8b4d ("selftests/bpf: add realistic loop tests")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 60e3ae5..48e0585 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -25,6 +25,7 @@ CONFIG_XDP_SOCKETS=y
 CONFIG_FTRACE_SYSCALLS=y
 CONFIG_IPV6_TUNNEL=y
 CONFIG_IPV6_GRE=y
+CONFIG_IPV6_SEG6_BPF=y
 CONFIG_NET_FOU=m
 CONFIG_NET_FOU_IP_TUNNELS=y
 CONFIG_IPV6_FOU=m
-- 
1.8.3.1

