Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999CD45602A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhKRQJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:09:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232973AbhKRQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:09:33 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFIV2N005279;
        Thu, 18 Nov 2021 16:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=F6HckeyXeZaZHMsQFsGgNpilOsihzSfaR3LRKMf7ErY=;
 b=XjnXFAGkhIy5qBqVi/Fb8YuOU7kjl2haWQxvHUr+iq0WlOuQSEk9O3GhBgpp+gc0fwtk
 5Z0IW2jTZASkl2OH8kqy5wgSVR7yKC1FOslEE/kmMCAZyvneLsv1zk7asFdBCWopFzsY
 rTdaR+ObdLMHuw3P3B/s9JbqSdl9Z5/RFprE23LwvXAeHhilKtXJNT15rNF1a4PhwTDR
 5qlXRQ319ROIHDJSs1oK/rNQCTSiL+rSwRsPyJjZS3QYUKV9NskVPiM5yVPzZS7v9FeU
 oT+LsM8bqHuYANkeDqr24l5hTP8yeEoLKd/dseGI9k4P2t0pc/BZNkgPy88RYixIFcRu Jw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cds8n9gev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIG29iN029864;
        Thu, 18 Nov 2021 16:06:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ca50aduu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIFxPwD34472292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 15:59:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4575AE064;
        Thu, 18 Nov 2021 16:06:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E428AE057;
        Thu, 18 Nov 2021 16:06:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 16:06:25 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/6] s390/lcs: add braces around empty function body
Date:   Thu, 18 Nov 2021 17:06:07 +0100
Message-Id: <20211118160607.2245947-7-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118160607.2245947-1-kgraul@linux.ibm.com>
References: <20211118160607.2245947-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LoWeeUYIG5wYdww2hPX4xPzC2Z3yKgPF
X-Proofpoint-ORIG-GUID: LoWeeUYIG5wYdww2hPX4xPzC2Z3yKgPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Fix allmodconfig + W=1 compile breakage:

drivers/s390/net/lcs.c: In function ‘lcs_get_frames_cb’:
drivers/s390/net/lcs.c:1823:25: error: suggest braces around empty body in an ‘else’ statement [-Werror=empty-body]
 1823 |                         ; // FIXME: error message ?
      |                         ^

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/lcs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 2a6479740600..a61d38a1b4ed 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1808,19 +1808,20 @@ lcs_get_frames_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
 			return;
 		}
 		/* What kind of frame is it? */
-		if (lcs_hdr->type == LCS_FRAME_TYPE_CONTROL)
+		if (lcs_hdr->type == LCS_FRAME_TYPE_CONTROL) {
 			/* Control frame. */
 			lcs_get_control(card, (struct lcs_cmd *) lcs_hdr);
-		else if (lcs_hdr->type == LCS_FRAME_TYPE_ENET ||
-			 lcs_hdr->type == LCS_FRAME_TYPE_TR ||
-			 lcs_hdr->type == LCS_FRAME_TYPE_FDDI)
+		} else if (lcs_hdr->type == LCS_FRAME_TYPE_ENET ||
+			   lcs_hdr->type == LCS_FRAME_TYPE_TR ||
+			   lcs_hdr->type == LCS_FRAME_TYPE_FDDI) {
 			/* Normal network packet. */
 			lcs_get_skb(card, (char *)(lcs_hdr + 1),
 				    lcs_hdr->offset - offset -
 				    sizeof(struct lcs_header));
-		else
+		} else {
 			/* Unknown frame type. */
 			; // FIXME: error message ?
+		}
 		/* Proceed to next frame. */
 		offset = lcs_hdr->offset;
 		lcs_hdr->offset = LCS_ILLEGAL_OFFSET;
-- 
2.25.1

