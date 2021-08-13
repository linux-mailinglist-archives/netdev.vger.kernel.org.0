Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747003EBBA6
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhHMRrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:47:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32910 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229919AbhHMRrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 13:47:11 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DHWEkn024222;
        Fri, 13 Aug 2021 17:46:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=UJkFw0L/GY+LzgGNhYapHZ3JQmMnBpfhv7NsPVlf+igrU3ajOLbMQzbSzEFKFAxfun2m
 yMYl2uLk/4P3gPEJaRS8sD3Dxikemip51EfLNWujDiPHhQBP7lulqpy4yEW0ENwa7RHb
 /xcd3LRt4GO2PtoIA021vxszjJfqiittG+QeoNQ8Us9QCM/MemFOyuOs+xfXO7eKlxEK
 gDfMQKAuu51rEH4M2SpflPQC9D3mj2IAr3nzsa+FjAIGxrsrfVXz1qAtuDjKujcdTVe4
 OJPBOaVNrjqV7AyXjeZmOYiVfyNQPuJwLTRab0mcT59Zu6MFMDCh3dO1x3j71/QASFXA Rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=KaTlqVZmIB1RryXBjeDTtxNP9Bi7gxLSGk0RxNnjOj1nZUdcquCbbZVn6uKxknq5EMaN
 mWbfU7ZWW/YjmZstqXxk8+ZuL0dQsRpXnuoEUO8VaW8jZUMdCIIpsMbu1CNxgO7lmdGk
 +YDkgL8LO+dfwpBWzzy+E8An7kLG4PjgYEqFB1VWoLZde6dUgmMU5alzu6h1esK1Dbap
 c68AaGQuoIqza0V42uSrfn10lEmSov7M+MvTOpw1DMSdqzYhRimmMQ9m8+NuFbDSi15/
 k3FGhFtuvAuDjQ6Jk+B7x+h5sgaEurGUVLtMul0aPxih+Fdz4KZDK4ODYDCgi1RWjva0 WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajkgf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:46:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DHUYJe155988;
        Fri, 13 Aug 2021 17:46:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 3abjwb2htq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:46:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5uyDPv/btm773Gc8uPJjy/ec/WstsAIsrU4YbQIHN5gTemGZ+fSvOOVU3AkX1j1J/Bi3puaLF/pleNxmn2ooo6WPn5oSAgRljv/UHkbxR/BWgvKfqVdhTtqVgC+LzaduZBsDnd35K5WHVOVSAQmHQMKWPyFDLDfkPSAqaD1UuZ5qc+sgJvTFQGajax+ZoMNZkgQulNn9l6nML+4w7tBgctdv2X/mys7VNS1aCM0b5yks1+pvCAfFH8fNCJFn9vrTL86EnqHQkL42U8/Q+DIpJJpSpXEdfPSQkYLC2ygYaow5i4dp4QtB7TyqZ/RxBDsgnZ54AdRreVzROlZx4g6jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=aBrZujB/cqZnYVt7RGSr/7MhXO5alkdUyFZ95qX4TaMXqDxHKazDYJqskQ989n5pZ/L72ShUBSOtq1AQr43creU8ByHB3NsLgjo43U6HxlhFKzP3+eqz9sVe8sjkAb/YtDW6BDt87TdZzKC1KUuzarikQotkTmMtm6hahFOwEfROdqieFlnvZKLSCzbqXSM0Sh9HuS8JksvIqMG5ZjScJNuVS0//m/rM4WF6ZWKrPRDF9fqySdMDddKCvwcICrOX4VwbvwVMUSTSOBtkf6K+jpTAILZu1mXMZ6G9ncqR0HcTELhaOJH3ShUQnMOZ1o0uPhOBK7ImpIEntn3pMAf6+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lllsV3yvBPiS5QJCbWTFg/cwngVKoOzGXHT30mhVE1g=;
 b=bQcrYxFJ8OUvZyvTr8048GMPmsj9w8vFJSoSOKAiBLraYc92+E5mX3gjBHhU773t8wZaYT6Y0bOZk8SBFPuwhD8JkGM36rmmt3QhXto2fFhAyokXbyOeNdZXSwuf44N+RcRX4UehoHztgJDoC4uiFBqrRDhDsA0TK74zUNpUAiM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3671.namprd10.prod.outlook.com (2603:10b6:a03:11c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Fri, 13 Aug
 2021 17:46:37 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.020; Fri, 13 Aug 2021
 17:46:37 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, rao.shoaib@oracle.com,
        viro@zeniv.linux.org.uk, edumazet@google.com
Subject: [PATCH] af_unix: fix holding spinlock in oob handling
Date:   Fri, 13 Aug 2021 10:46:29 -0700
Message-Id: <20210813174629.646768-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:806:f2::15) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SN7PR04CA0010.namprd04.prod.outlook.com (2603:10b6:806:f2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Fri, 13 Aug 2021 17:46:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89d759e5-dc48-42a4-0340-08d95e824c92
X-MS-TrafficTypeDiagnostic: BYAPR10MB3671:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3671C2DDE86491145F38CC55EFFA9@BYAPR10MB3671.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zM6kCUhrWYimOXCHM45LLZ+q01iTXQhX8z8hkgiM9GqqycwKXc4hVDIpvoXpb8+BnTsjBRRp/92giopindf5QXqY5Xf1thW37VWfhSFfA3ryG4xuaTErl7WNCoEbw0XV1NGtmrk4EnA7Nl+ZlnDIUK60+j6+GJwGbgtBmjvWe0qT7Flx4Aa9eMlubcY1+rW7k2DA1koZYzn8v5y7PWEXF2QMLN4hs8dOyjZ/2PL8Pjg4XpHk90dr3gYARXjUNMzF6iJFjb2sg8sy3tuK2eieEchB+YcuIXVJXLdCd+DAV1M+oZ0pqaIVr3uCzkrmdWgYhyMvKbBLk0Scvv0MZ8M2tw3X79B3QTPxMQNDXSOZyfidoe20lF9OdXi0VfmFHnLO8oJqQAvvQAN2qmP/dRGEH79Qz/dQASVo7+Spkky7nQXsKhXn4pb5ZyZhT5nR9mkfDts+VGQwKQ+LuENIVifIGAdd9XwY8bm3tjn6a5siBOGoVK3r1yV4takCxFS3ZsrXQSdcSe4zzi/nj5wtf+PwllcTXjEREx2EfW6alpGEBRUs0zawlaJCs56hBN9jQP+xQ0y0iykasU5aQBP9LgCKZxk03tAEQrHvhUBcWAkC7c5kDq9x+QY1bwgBGXjF+jE4L5zeFvzRs+OVB9df53lZUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(478600001)(52116002)(36756003)(1076003)(66556008)(66946007)(66476007)(6666004)(7696005)(2616005)(186003)(38100700002)(316002)(2906002)(8676002)(5660300002)(6486002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4c8Nzsh2C2JVFSCTldohXnkAm/CZu8VS/Dt7Qr+Ihs36N7YIRJJkK7TH1L/X?=
 =?us-ascii?Q?n0pYjmBJ01TTijr/tFxQxDrQLuKal4a7DVxCCZiP6L05bLiUaKo+pSchnCS8?=
 =?us-ascii?Q?J+sXtYERtfthYJNxGkAuot7nJPILoWMvoMCZV00pocnE4uBsAHh64wGIjZ6R?=
 =?us-ascii?Q?fUgVNdpbg2NZqg7mbbshVwutoaaqIh5HjUfhT82U/DLx/SQBi7YLlVVGG0n6?=
 =?us-ascii?Q?G3W4YSvO3JXKe25u/VGjmfAWpZwLKE4CpPe4aVciW0zZ1iXl7dgUzglGfLdN?=
 =?us-ascii?Q?zXST9JRcVCUctGKKYSAQdg0UgTaACKSW+S4/tAj1TWfrX/YQ1lY+X/zprBoV?=
 =?us-ascii?Q?reI/6FH3N12y19mPzS8QkieCNKeVO4JvhERjmEV6tmTYtlk9ZjEgZREk62om?=
 =?us-ascii?Q?6XAxQ13ll4V3Yq/jFl07ol0LGT2UIR9RCKiz0aXmkxy8HoCV48BPs+ujylow?=
 =?us-ascii?Q?8QWeHAVpBHk2P+ig3WRZ9NZMTSrXxHQoXqSH/gI7fAy3Io8+EeqYujPpbRd6?=
 =?us-ascii?Q?jykj64TgjwOKb5XDdZYpVYY56w3Quktma2gTSAb534elDX5OKggfiwjUcj6k?=
 =?us-ascii?Q?7KyDfXIvKuPRItNfW6YOeStFHmqz+npcc726q54IKabAKHKEWEiQho/N+eq9?=
 =?us-ascii?Q?sUTBgN4RMA6yYeQA0HcCkhMjIrJ5itwxHCHVGGUItM4MgHtFwsgwkXYR0cwH?=
 =?us-ascii?Q?YyvYSsiNHdhkIqCKfUFNOCLHf+wnx/KX+NvbPw2ZdfyTqPnslPXUHyny4UUD?=
 =?us-ascii?Q?QBjNcMF0JSfMmzsor1eTSOlzmFIKYZ53ZKrKC+A6JM6WPfPQafw2WStUgyUN?=
 =?us-ascii?Q?B/E1MT2VJ7HcmeauMmJQLaLrNpXQZbCyKgd/SrOoP8OyxtPR8RcM9Kx7rOhQ?=
 =?us-ascii?Q?3ZZL529g/Ms6lnz+faQcUoZ4+TJkkul+Ro5mD9cw447XxAwJd2Nb4dBIQwQF?=
 =?us-ascii?Q?hzXBL6PXsOLscbeLanf+p3EyI9pi3VTwKo+mlmIqC5OQv9SYwQFf/hY4QUTw?=
 =?us-ascii?Q?ISdnu88ewl19EUl5IrmSUE5nrxbaDQAIfG0s/68axLu7YQYn0CmTfV7qMf5n?=
 =?us-ascii?Q?Tmg6e1eKsIjIhbWaXtEGBMGHceTeDKn/hliV8nDzJ5HtJYPcR5w5zYUlVVaO?=
 =?us-ascii?Q?4/eGcYBXmlYPRMMEWfBTNUIhQRQk7HKVQhiqkgfqZD13WN8sBMflIYdWftiP?=
 =?us-ascii?Q?qtnboEseda26ofMLugGzYztDd58rvZoy+k6TpLUDKuD3/OPbKYLixJAFYNwr?=
 =?us-ascii?Q?C0dSLWWyNNcooywQQGsIf9eKlxM7mTJWlgWh/Xk5/VNcfcgXYRYCHp4aXDto?=
 =?us-ascii?Q?DefSErW2cuCYzDTjX34cXDT5sOPM1eIoxRRIoe2IGYBp82cmy/v/5aMDMbt4?=
 =?us-ascii?Q?XSVGymg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89d759e5-dc48-42a4-0340-08d95e824c92
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 17:46:37.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwMGfilKfAF8/XedJOFXiunhvwCDHFJJaub9/fB9qCttPi2KveyvyVi1TV4Ud3PMtHRcNVCDr9m2W4CVkdnlzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3671
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10075 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130105
X-Proofpoint-ORIG-GUID: fDXTPGRe-nBpVBnkrmJJ4mASQKvfg22K
X-Proofpoint-GUID: fDXTPGRe-nBpVBnkrmJJ4mASQKvfg22K
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

syzkaller found that OOB code was holding spinlock
while calling a function in which it could sleep.
Also addressed comments from edumazet@google.com.

Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 net/unix/af_unix.c | 47 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 00d8b08cdbe1..0f59fed993d8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1891,7 +1891,6 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 		return err;
 
 	skb_put(skb, 1);
-	skb->len = 1;
 	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
 
 	if (err) {
@@ -1900,11 +1899,19 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	}
 
 	unix_state_lock(other);
+
+	if (sock_flag(other, SOCK_DEAD) ||
+	    (other->sk_shutdown & RCV_SHUTDOWN)) {
+		unix_state_unlock(other);
+		kfree_skb(skb);
+		return -EPIPE;
+	}
+
 	maybe_add_creds(skb, sock, other);
 	skb_get(skb);
 
 	if (ousk->oob_skb)
-		kfree_skb(ousk->oob_skb);
+		consume_skb(ousk->oob_skb);
 
 	ousk->oob_skb = skb;
 
@@ -2362,19 +2369,37 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	struct sock *sk = sock->sk;
 	struct unix_sock *u = unix_sk(sk);
 	int chunk = 1;
+	struct sk_buff *oob_skb;
+
+	mutex_lock(&u->iolock);
+	unix_state_lock(sk);
 
-	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb)
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
@@ -2434,13 +2459,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
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

