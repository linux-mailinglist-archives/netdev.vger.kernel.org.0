Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C991205206
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732626AbgFWMKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:10:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51164 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgFWMKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:10:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7jPW052010;
        Tue, 23 Jun 2020 12:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=3v+guURZcQeoX4+Becn71DmwodRpWYWGGi1qwgFgOAo=;
 b=ncUvLhBFO1Ek73eaATN83HIEVCSyc00zmwiA6f2bzlK1AxHDedbCJqoR4FB6/2yHYJyY
 4gjo8T8PYeJ0L8GpEyA7aSojAe/rI1NwGzAGqZSTnR/JQiwGhkPJPR79nlb//Nljh9Oo
 6fwkTYWwtjvYHnw4swGP1IRCXMBcSP4VT2PBRHP2FHm0xsKka2rRsnf6J2u27/PlYGOS
 jgDZLxRiQrqkttXPRMwkjCvPaNoVIBZ3Ow+JDsK4gxKi53sp/rhU3fGgixa8Alrqy20B
 C/ERFsGRtyZX+dniD8Jlwvh5erKejK3VAaFjRlNNN/7bMxNKnd9WOmerrYH4tjHjlf6K UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31sebbcv9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 12:09:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NC7gg6185241;
        Tue, 23 Jun 2020 12:09:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31sv1n7gwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 12:09:16 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05NC9E90022514;
        Tue, 23 Jun 2020 12:09:14 GMT
Received: from localhost.uk.oracle.com (/10.175.166.3)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 12:09:14 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com
Cc:     kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux@rasmusvillemoes.dk, joe@perches.com,
        pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 bpf-next 3/8] checkpatch: add new BTF pointer format specifier
Date:   Tue, 23 Jun 2020 13:07:06 +0100
Message-Id: <1592914031-31049-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=975
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=998 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230097
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch complains about unknown format specifiers, so add
the BTF format specifier we will implement in a subsequent
patch to avoid errors.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4c82060..e89631e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6148,7 +6148,7 @@ sub process {
 					$specifier = $1;
 					$extension = $2;
 					$qualifier = $3;
-					if ($extension !~ /[SsBKRraEehMmIiUDdgVCbGNOxtf]/ ||
+					if ($extension !~ /[SsBKRraEehMmIiUDdgVCbGNOxtfT]/ ||
 					    ($extension eq "f" &&
 					     defined $qualifier && $qualifier !~ /^w/)) {
 						$bad_specifier = $specifier;
-- 
1.8.3.1

