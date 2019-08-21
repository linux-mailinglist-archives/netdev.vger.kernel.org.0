Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3EF977F1
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 13:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfHUL3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 07:29:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726349AbfHUL3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 07:29:39 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LBS7cA139136
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 07:29:38 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uh3rtkrft-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 07:29:38 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <rppt@linux.ibm.com>;
        Wed, 21 Aug 2019 12:29:36 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 12:29:34 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LBTXFM59572278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 11:29:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E301F4C046;
        Wed, 21 Aug 2019 11:29:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A54E54C04E;
        Wed, 21 Aug 2019 11:29:31 +0000 (GMT)
Received: from rapoport-lnx (unknown [9.148.8.59])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 21 Aug 2019 11:29:31 +0000 (GMT)
Received: by rapoport-lnx (sSMTP sendmail emulation); Wed, 21 Aug 2019 14:29:31 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH] trivial: netns: fix typo in 'struct net.passive' description
Date:   Wed, 21 Aug 2019 14:29:29 +0300
X-Mailer: git-send-email 2.7.4
X-TM-AS-GCONF: 00
x-cbid: 19082111-4275-0000-0000-0000035B79BE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082111-4276-0000-0000-0000386D9C99
Message-Id: <1566386969-6813-1-git-send-email-rppt@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=989 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'decided' with 'decide' so that comment would be

/* To decide when the network namespace should be freed. */

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 include/net/net_namespace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index cb668bc2692d..ab40d7afdc54 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -52,7 +52,7 @@ struct bpf_prog;
 #define NETDEV_HASHENTRIES (1 << NETDEV_HASHBITS)
 
 struct net {
-	refcount_t		passive;	/* To decided when the network
+	refcount_t		passive;	/* To decide when the network
 						 * namespace should be freed.
 						 */
 	refcount_t		count;		/* To decided when the network
-- 
2.7.4

