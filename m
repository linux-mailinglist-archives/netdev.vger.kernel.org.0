Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4B13E8304
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhHJScF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:32:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62042 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234094AbhHJScE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:32:04 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17AIVGKR004185;
        Tue, 10 Aug 2021 18:31:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=j6iqoBDGi15W9+wc5Uic8wlvzvRoE0iQGkzCgXe5J5A=;
 b=tJmoj8+y4UsT9e/KIuCNDzXxbao8dj/OSvFtjkvPZFso+vznFSJC28xQMbRUuk8arRId
 v58YcBgCIzV034LrQ/4ObPYqB7bMiTsAdWmiZCfrBm1ZCTTET2P5A5Gm6Vqgl4BHPY3E
 uTJP7OtY8YQeNsKZsbemewU/HknGZtMRWKfaCLj15zLYbedYKVtRPv/dhqXGvjq3VaRm
 ynnPszwzzewNy6f4PYdyQsrJma4Qqh7kw5NRV4PJWsL6KWBTpzgMt0PRQg0BoMFfOKcE
 jUCrvkzCK+0Vx72p8qQKTxMwMmGs393zFSMptqOBT6uHt4oXd7Ka2PJtlqPXd2sqOXDh AA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=j6iqoBDGi15W9+wc5Uic8wlvzvRoE0iQGkzCgXe5J5A=;
 b=TM1qarbX2z7UTtEDOQmp2CcRfGdNYxZLuOS/Z2pyA2zUC3mQBMGW+N52ikeQ/9SVjkuQ
 o/xYBZlKPL6NBHISaez1Sf1yUcc6sLqJsJaMsUrCYOtyBpxV5Yd50goAuuMvIABa+bJN
 5UQmAj4DOtsT0J7cL45hB8IUH9dnLR6ngdnL4cF71l417Wt7ut4ndsR9N58fdm8mSBTg
 Q8tL60ctk9qDUDUgx1Fi3Bch+QZS/cAAxc3t1NtKE/UA5wArMB43XMjMILghn8M/sD4V
 wL8ZFVJj6e/WN/khoUKD6HIIrXEtMNLJYb3SeChnoD8Y3Qi31oK3cI9mX7DiZJfR0IFm 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3abwkg86bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 18:31:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17AIUWGu131403;
        Tue, 10 Aug 2021 18:31:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by userp3030.oracle.com with ESMTP id 3abjw4vmpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 18:31:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+N0YkR6JgE1GbYdUzmeslaNrqVOddd6ngEj0fCtytaWzHPb2RADxEeIs1vvpErCIE0vLjUWd76IhLdR5F7Jt4QAaacEoFVOT3nSyNRTyOiioPnbye6wHk5nLH/Oopa1olXjzhRWL9a1ZRT83mNf1MU0VmDsX2726k5TvyXzwm38f8+BdO0zKomevcX9P8q2yWrxmkZQf/Y1DdlFuoSI/kh2PgLVVQ+MqbrHiTLhbJnDphwY58dxO+NWw5xWFo+pnpABAC1dIJwXJSPNOAK8nhi3rBkKr68Cl1PIlNuxIg6gjAS9er+LQmy2yNoKcc6/YMruuGWGCdITyb5NXZRmIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6iqoBDGi15W9+wc5Uic8wlvzvRoE0iQGkzCgXe5J5A=;
 b=FAvSgpQRQKa7lozSLv75zr5OyOz7ZAYhbX5P2jovJF/IaarV0jS7llf6wq1oUikBllHyPJZOO4wuJNF8lI21ZCTaiiQ7FjvDffA6p+yp/9PmV9f1gth1z08MFprGt2F2shhuxdpVIldnfAaLZwnMjbWbtBhSkglSBGiiaJb1uMhJfs9i1FKnWnEKohOo7XdaORsjwOs26AnDok5nNunsL9H4mq7AwXa4jnbVKU40TVRyKO+O+PxX3VKYAbkTI6JmXgTehazv3kDIITShseGwcfxHz+XiLrsDM2u9ipD4F/NWn4hEBSiIt79gC6Nue19ucDDyew7bHXnarAP5FJ3juw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6iqoBDGi15W9+wc5Uic8wlvzvRoE0iQGkzCgXe5J5A=;
 b=yXTdUT3SQh17YU5gl3Q9ZmPb5w6Eld8EWycjN/bDJV09CMtlboE8+sRPRzWBz51VAvWSz7CwHaOijRjf9UBF0gEzYlSQ+Rmcq6ido2ktEEypVVel3aAkJpuZvml7M1ktefaA1k6Ai3OxyoGz+b4DVQ3qseKw7fTR80+nn825DeI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 18:31:32 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 18:31:32 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     dvyukov@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        edumazet@google.com, viro@zeniv.linux.org.uk, rao.shoaib@oracle.com
Subject: [PATCH] af_unix: Add OOB support
Date:   Tue, 10 Aug 2021 11:31:22 -0700
Message-Id: <20210810183122.518941-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0154.namprd04.prod.outlook.com
 (2603:10b6:806:125::9) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SN7PR04CA0154.namprd04.prod.outlook.com (2603:10b6:806:125::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 18:31:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f88fd5f-abbe-499a-47dd-08d95c2d12f3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB311255C25BB0F54C52555A76EFF79@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:254;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrAa235JUpT6DZHKlHQQi/KWDq0dc4hSulIpIqLPpGcWntp1gfZnogXxS2qszYGNmUYgoI6o3Eh4dqzCBpWo4eiiRz06XG6ZML5qpRjADmTsTIy8hKuoQWE+rt8Ym80lxADv8KLBuARJ6u8kiIP59QXSV6KoK27A7G5Xb6M6Z0sGPZO6AT3cuiVhaEQWkA2oTnn/YnTCYsayBEeMYoq+TmuImyz+dADYjht4kodDJAna+EgTl1b4lO1F/YcNILcZ1yIgKsrHB1x/fh10GRAWDYDCLuAMy9VEtTHTyDlxOIpPaL5aXeaqQPM8UrsNZiL06w9mZpR5BMUPfyN8gha1G+1CSqIeJRIV0C71PShRTbyKQ2cE/pgOudU4i+k8hncnlkEIppR+nsAJs+BHrdEA9G7Qv+MqA4NCbFCepop+taf6w3EofwsyE9AXqVqidlHaPkGwxm5W2pKRdOuhF4xa5X/+97WF4Bn2Fga8eAbWCXIT90ckeIpI2n5DkfsyK0CRID8mYtH19qpkLHTZqAtEfw4JC7hINKpmD5siZ+xZYrJAFnbBu+jdNBY26ToF+i+EtiKWv+OVKah44RcXpgKrCgvdXBy2kyKnt/X6so64v11bBk0DnLfuLD9zcat9T9SV6SBITluR6MceLmgVsTnlJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(508600001)(5660300002)(8936002)(86362001)(66476007)(52116002)(7696005)(6666004)(66946007)(66556008)(38100700002)(83380400001)(316002)(1076003)(2616005)(8676002)(2906002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SomfKYrCeWejZFmFFTQznzLlA8QCRKUJEF27I4cFieXs73Iqwe85Dlx0Qa1Y?=
 =?us-ascii?Q?v4fqUvfOp/bNhWTT+iblkRz21sWJRSz2iYdC8K/iORrMUaaiD/8c8kwSel0e?=
 =?us-ascii?Q?4x/w117hb+/tymncJ171tasSCvN3T2g3vlbv4gnHolH68Sj9IBfjxM9AZRFB?=
 =?us-ascii?Q?li4984R0So6DnHn7AY5XsFcHO0DQ8PpYeS/7Pj8mGwV+sNK5D9KE4N59dcHW?=
 =?us-ascii?Q?k58K56RhUuIQJrjC5/C4M/tTnodl0rEus7g84K2dMarRnRelOVogb2nWKuW4?=
 =?us-ascii?Q?Z6tl2Vzo8QVAOICMzzOrDNB9hBk/cKrrvGVwu6524GerKUm0G0s1AYARlpyV?=
 =?us-ascii?Q?U/kefjFZkCYTWBNTw92AvPDXzFVcEbRnFuwEHgeN2fMLOun1qwFUGpLXSZX5?=
 =?us-ascii?Q?FBAeGGnfZrmrmMXDxsw0NpMOXjMI6AO5F8JVvn/RP5ZX7X1Ik8JMC6cxi9yE?=
 =?us-ascii?Q?hMOFI6c2L0Jm3+NMBLI4IdwBAYOnWsn5bJL120OR6pY1bxt/oWGw+R7uW5hK?=
 =?us-ascii?Q?09rA8bv/SLsu6LA8jZZRlFTW/8myH/wg0QWmi1ADMkiO4Ejck6TLx9mdlHV+?=
 =?us-ascii?Q?bWMxZHD18tfhZjqKvopLEzr0Z3+kVuBPI1ZvpdBTOeS+l4C5OpFABH8ZM8tK?=
 =?us-ascii?Q?/PzBFg4d5frFh9zEcI3v1Cb4gtjXngH7Q+xfBnqdwBUmITS66jdyj1K3dVgz?=
 =?us-ascii?Q?pYkQsSBIXqriViMQrqCzub+5JlRpcrqoXJDZqOMhqdVqyp17opxN/diqMOc6?=
 =?us-ascii?Q?HlOI/M7jCzdWnfZSGsWr8IoXe2XOEovGvvHT4eWY3oWUrV7MCBdMs9t0IzaF?=
 =?us-ascii?Q?nr0lacez/CyZTFwEqJWYLvle1Gps0lCYIb6j6ystN+nkNIGB5OWRe0j3obEH?=
 =?us-ascii?Q?CbToxQXFg3ML7BK+rCg3WwiKVV7/94zquFSoFpNk7ZeeOzzqZ5kTh9bskwjn?=
 =?us-ascii?Q?Dv+7czim4OvztIqiT8YXA9h0xN0IL+Hzy2tPFqBcTLm+YrYhBbPgAJy/xd4w?=
 =?us-ascii?Q?2GFZcrsynK5PHO2Nkxx3okR4OLnrcAt3XXSPiqi5XPnmSahnRwNyAk7pXEon?=
 =?us-ascii?Q?Fnbj5tYQMORtjq0hnCsbJQ6FAKhThzuuCfKkrD702BNxHNsY2Z/OpMNPRahV?=
 =?us-ascii?Q?oe96LdAQp/ZMP6vboB8dPgJxTJUeIG3jWCS6ixG5nwCeV+qxwoUQOUhQ+rsJ?=
 =?us-ascii?Q?6B0OyWwqozWUii5yo+sycgfep+EkaV0U0Lq1NsijW4z+BBAFXfx+q4JkYyOx?=
 =?us-ascii?Q?zABnANX2GgtjTKcQSLfRybIssYpuKLtSM4L38O1cokf9VGbHrLLqS1gxOg1G?=
 =?us-ascii?Q?rCUJd2rAT/UpaTtWhW/XTyVNTWEOYpzxCx5jKnMDuabRGv7JfuLuxze0BwT9?=
 =?us-ascii?Q?c3daDaM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f88fd5f-abbe-499a-47dd-08d95c2d12f3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 18:31:31.2306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57mI9tn4TbGo5NygJi6JJAxqwxYGHnY3Mjmax6kJyYeeGAhbfUd6Z/z8DE0hmwgzufAjVL3i7NurDrGv2n1Wbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10072 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100121
X-Proofpoint-GUID: fZU9F-FQ_U2Ed1S9Sg_jcmQ1_hJjzzrW
X-Proofpoint-ORIG-GUID: fZU9F-FQ_U2Ed1S9Sg_jcmQ1_hJjzzrW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

syzkaller found that OOB code was holding spinlock
while calling a function in which it could sleep.

Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
Fixes: 314001f0bf92 ("af_unix: Add OOB support")

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 net/unix/af_unix.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 00d8b08cdbe1..a626e52c629a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2362,19 +2362,37 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	struct sock *sk = sock->sk;
 	struct unix_sock *u = unix_sk(sk);
 	int chunk = 1;
+	struct sk_buff *oob_skb;
 
-	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb)
+	mutex_lock(&u->iolock);
+	unix_state_lock(sk);
+
+	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb) {
+		unix_state_unlock(sk);
+		mutex_unlock(&u->iolock);
 		return -EINVAL;
+	}
 
-	chunk = state->recv_actor(u->oob_skb, 0, chunk, state);
-	if (chunk < 0)
-		return -EFAULT;
+	oob_skb = u->oob_skb;
 
 	if (!(state->flags & MSG_PEEK)) {
-		UNIXCB(u->oob_skb).consumed += 1;
-		kfree_skb(u->oob_skb);
 		u->oob_skb = NULL;
 	}
+
+	unix_state_unlock(sk);
+
+	chunk = state->recv_actor(oob_skb, 0, chunk, state);
+
+	if (!(state->flags & MSG_PEEK)) {
+		UNIXCB(oob_skb).consumed += 1;
+		kfree_skb(oob_skb);
+	}
+
+	mutex_unlock(&u->iolock);
+
+	if (chunk < 0)
+		return -EFAULT;
+
 	state->msg->msg_flags |= MSG_OOB;
 	return 1;
 }
@@ -2434,13 +2452,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 	if (unlikely(flags & MSG_OOB)) {
 		err = -EOPNOTSUPP;
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-		mutex_lock(&u->iolock);
-		unix_state_lock(sk);
-
 		err = unix_stream_recv_urg(state);
-
-		unix_state_unlock(sk);
-		mutex_unlock(&u->iolock);
 #endif
 		goto out;
 	}
-- 
2.27.0

