Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3651ADB55
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgDQKnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:43:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729501AbgDQKnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:43:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAfvq3025045;
        Fri, 17 Apr 2020 10:43:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qw8IZncjpwTWli0q85XcKz6mw/3n+oHjf5vrDCtua+E=;
 b=jANd7rIJgfO6V5/uTtdMNnTWPVEjtedQHTIOndAoYVNYK3q/KGEqmE+PKy2ouQFT2oBV
 IIdjpd5hyetjcUuZHyQOrjD4YnmSP+cVG//0P7GcN9Qv+GBoxrGyFiocPOe2XoCHCJ0Q
 gDDoD1yV4fLvG1F1pJvf2PwawrKdtWYLN6gCGa4uqJH5xADfcwUSbwXGATaGYYTfJKVj
 L9fAY1EHK2SyGR4m9sodd/SprWLsa9rv5DSP6uGL5jOqSNV29Ylgf9V06WYdNaeeQfpO
 0Bwm4Kki/V/L52G4ob/htlXnj1TFRYLVx1ShgTODQCE6y9AM+Ah7nezVSltW5vYAjUlw pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30emejp7du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HAbHRw051211;
        Fri, 17 Apr 2020 10:43:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30emeqk3b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 10:43:04 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03HAh3sl015853;
        Fri, 17 Apr 2020 10:43:03 GMT
Received: from localhost.uk.oracle.com (/10.175.205.33)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 03:43:02 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 4/6] checkpatch: add new BTF pointer format specifier
Date:   Fri, 17 Apr 2020 11:42:38 +0100
Message-Id: <1587120160-3030-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=757 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9593 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=809
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkoatch complains about unknown format specifiers, so add
the BTF format specifier we will implement in a subsequent
patch to avoid errors.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a63380c..1683a26 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6028,7 +6028,7 @@ sub process {
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

