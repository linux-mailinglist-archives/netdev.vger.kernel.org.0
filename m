Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF951CECB2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgELF7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:59:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgELF7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:59:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5wF0B136159;
        Tue, 12 May 2020 05:59:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yJuAmPZM1OUF3tRynJ8B547l0BWMftUiitExbm+onbQ=;
 b=ApbcGl6fyOla9VRTSrjXGTw6xfkNw9sIjPEcZ9eYEZ6dR2fBputLjcjZfE89EyPWNnTb
 vU4ZlJ08K8+jvMMI91zTQbZQmHVzc/fLD5VUr4Fvg35V4tQdk0MWf6cqyrp2XL6EICJh
 BMdKp+a927y8HqcGQky9cZ+4BwX/lgrI9J0zLfaCc3Urw2FGvUMk7VPQ5hSmG6U2bppF
 LJZw1STTfGiFbDTBpxe9O/nu9fVAVLc1aLkTMh+fUqHk0cc0qlA2JScES7MldQ66CZ74
 RPUwhEtnRRpF8eqg590a5tTihfRSFYjtEA2lY8IfyeK9PJAIqB5BMY9a7mGMOkgdi4ba Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x3gmgwjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 05:59:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C5rtoT051900;
        Tue, 12 May 2020 05:57:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30ydspr2ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 05:57:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C5vC5R013762;
        Tue, 12 May 2020 05:57:12 GMT
Received: from localhost.uk.oracle.com (/10.175.210.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 22:57:12 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     joe@perches.com, linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com,
        yhs@fb.com, kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 3/7] checkpatch: add new BTF pointer format specifier
Date:   Tue, 12 May 2020 06:56:41 +0100
Message-Id: <1589263005-7887-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=837 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=872
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120052
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
index eac40f0..8efbb23 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6085,7 +6085,7 @@ sub process {
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

