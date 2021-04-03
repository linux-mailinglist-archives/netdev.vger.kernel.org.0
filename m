Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620693531C2
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 02:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbhDCA31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 20:29:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235689AbhDCA31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 20:29:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1330FvSI015626
        for <netdev@vger.kernel.org>; Fri, 2 Apr 2021 17:29:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=RdsVRbNzjeirpfyPIdX85ZAiOT6bbZFUWOo4gkwmKqs=;
 b=k+Utd+Mx1jTMkuLDiV70rc9+MGwGmOVOP9jUF4vpnNM5ckhzEGqHBGplGlHtoUbycXib
 /83dQR73Woec2DORrlp4EA3XdGUQWNrdTw4XhoRCNubJ4L1CDIGciLu+Mglb7HLIJjZA
 bISjaTcw8+k4StbYzfMGZ7VLEWN4D2nPEjk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37nsn9dtf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 17:29:25 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Apr 2021 17:29:24 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A0CB42940BEE; Fri,  2 Apr 2021 17:29:21 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next] bpf: selftests: Specify CONFIG_DYNAMIC_FTRACE in the testing config
Date:   Fri, 2 Apr 2021 17:29:21 -0700
Message-ID: <20210403002921.3419721-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BZ_f1MeDaFPsrV-KEenq4GleGpaCjuJ3
X-Proofpoint-GUID: BZ_f1MeDaFPsrV-KEenq4GleGpaCjuJ3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_16:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0
 mlxlogscore=846 bulkscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tracing test and the recent kfunc call test require
CONFIG_DYNAMIC_FTRACE.  This patch adds it to the config file.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests=
/bpf/config
index 37e1f303fc11..528af74e0c8f 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -44,3 +44,4 @@ CONFIG_SECURITYFS=3Dy
 CONFIG_IMA_WRITE_POLICY=3Dy
 CONFIG_IMA_READ_POLICY=3Dy
 CONFIG_BLK_DEV_LOOP=3Dy
+CONFIG_DYNAMIC_FTRACE=3Dy
--=20
2.30.2

