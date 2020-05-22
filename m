Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8771DE59F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgEVLhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:37:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55900 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbgEVLhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:37:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBW37e132629;
        Fri, 22 May 2020 11:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=DeAbre2jARiyf9UdDRdSXujSZ67HDDT/6z08Mt9kRHY=;
 b=IgL5x1AARlcACCa+k39+v+S+1mGaHsdaj5KKYItw4Z5Qli0mSp/5x5bahAkhoH7kl/MP
 ERR5cGZbYrRX6n2i0a9NCNYhy6tuZh5pkB9CzazKf7NKGvHLEiyOZJvpPSaDGUtPvO77
 H+mbynWg0zNJCfTVc/tpE81lhm5GUE5V/qdcG9TScHGXEEa4bOjwsmzUR0SntWvbBm6t
 3J+iyWD04T0w6Bv6g6GiPzwriiYS2vwYZkXB1NqT85P4nX1dN5Zc/NgBT+4l1hT/UJBx
 aNymmVULbpGmM93VyEo+ru+yeU+sDADWbuNMEJx3kKtAhcl8h8ykLOidu26W4MUFRln5 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284md9bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 11:36:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MBTJcu180618;
        Fri, 22 May 2020 11:36:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31502461cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 11:36:45 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MBahRj005929;
        Fri, 22 May 2020 11:36:43 GMT
Received: from localhost.uk.oracle.com (/10.175.194.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 04:36:43 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        shuah@kernel.org, sean@mess.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf 2/2] selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh
Date:   Fri, 22 May 2020 12:36:29 +0100
Message-Id: <1590147389-26482-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590147389-26482-1-git-send-email-alan.maguire@oracle.com>
References: <1590147389-26482-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220095
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

test_lirc_mode2.sh assumes presence of /sys/class/rc/rc0/lirc*/uevent
which will not be present unless CONFIG_LIRC=y

Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 48e0585..2118e23 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -38,3 +38,4 @@ CONFIG_IPV6_SIT=m
 CONFIG_BPF_JIT=y
 CONFIG_BPF_LSM=y
 CONFIG_SECURITY=y
+CONFIG_LIRC=y
-- 
1.8.3.1

