Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF96E27C54E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 13:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgI2LeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 07:34:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46236 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbgI2Ld1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:33:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TBORjQ163313;
        Tue, 29 Sep 2020 11:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HVb5LyBGgi3fU77zrxjv0Gn2ESkyJHXWAtQJVfno9vY=;
 b=mA1TO9XK9CFlHIQ1Yun1Dnxw6N9cPBw5zNjBXPKLstW5CEK/dCMyjqHZwn1UJUWLL/P/
 jTp3pOYAXd2XxG3lhmwYu+9gNyPRBLsbWNG2C0qUa/aLZqAHvhO5slRvkQQMXdEYhK4Y
 L0r0k5OaaMZo52ijgFKoZ+wCZWi5AeE+fF4YdhMvUQnvAprlNese8j3GFylPmhQ4tux/
 +sl5yJIH7vdH652YMp8LBEjgJPZqUeFuimTGztbVxqy2v+Y+QkPM1Z4wHo0xqA+D7gvD
 NuF+Tf2yIb34NM9e09QfdmSWXfp09a+YLngpiT4zDxi4ztlrkjxZqOELC1L/5pzS267g ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33su5at8h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 11:33:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TBUpIB173331;
        Tue, 29 Sep 2020 11:33:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33uv2drd3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 11:33:10 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08TBX9K5015999;
        Tue, 29 Sep 2020 11:33:09 GMT
Received: from localhost.uk.oracle.com (/10.175.172.184) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 29 Sep 2020 04:32:47 -0700
MIME-Version: 1.0
Message-ID: <1601379151-21449-2-git-send-email-alan.maguire@oracle.com>
Date:   Tue, 29 Sep 2020 04:32:30 -0700 (PDT)
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/2] selftests/bpf: fix unused-result warning in
 snprintf_btf.c
References: <1601379151-21449-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1601379151-21449-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel reports:

+    system("ping -c 1 127.0.0.1 > /dev/null");

This generates the following new warning when compiling BPF selftests:

  [...]
  EXT-OBJ  [test_progs] cgroup_helpers.o
  EXT-OBJ  [test_progs] trace_helpers.o
  EXT-OBJ  [test_progs] network_helpers.o
  EXT-OBJ  [test_progs] testing_helpers.o
  TEST-OBJ [test_progs] snprintf_btf.test.o
/root/bpf-next/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c: In function ‘test_snprintf_btf’:
/root/bpf-next/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c:30:2: warning: ignoring return value of ‘system’, declared with attribute warn_unused_result [-Wunused-result]
  system("ping -c 1 127.0.0.1 > /dev/null");
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  [...]

Fixes: 076a95f5aff2 ("selftests/bpf: Add bpf_snprintf_btf helper tests")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/snprintf_btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
index 3a8ecf8..3c63a70 100644
--- a/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
@@ -27,7 +27,7 @@ void test_snprintf_btf(void)
 		goto cleanup;
 
 	/* generate receive event */
-	system("ping -c 1 127.0.0.1 > /dev/null");
+	(void) system("ping -c 1 127.0.0.1 > /dev/null");
 
 	if (bss->skip) {
 		printf("%s:SKIP:no __builtin_btf_type_id\n", __func__);
-- 
1.8.3.1

