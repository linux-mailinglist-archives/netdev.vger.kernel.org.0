Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14B33CF032
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443235AbhGSXCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:02:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36278 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1388658AbhGSVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:01:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JLbDWK025503;
        Mon, 19 Jul 2021 21:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=BMCQAcGi+XpIOfDFzuQKvvGSLfBRX8LfHhbyOuwmqFHtpdP//eH7nmV8hJhjHJtMB5JU
 vXd+LimhMUyGteYelOjWU+H9PcYXgx6aM0TTrSae/mnmq5VW77qgsy8DP+GzWtHdsYLc
 Xa6dsViCPr46WBx2XvolJTh+4wD3lBgkuR9OlnZLRyWcJ6FhDLdIVmuEeo5JEzbclykw
 9SLtgjbe1dJJHAj1lVvPu1mEgnm345ODBpHPnfkqhDbiC3GTK8x2p65MZnkl0BzLVssB
 7wM3QDaRPlhrW4jrHYvISURtv4J98MSRW/K75GzNSCDD246mFeLtrmqRhWbEyS6sK7FY hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=Xl7fr0iXldH4xO8PVuM88NGJz8b1XinDRkgpfWy8TF+rMtcCh5XKjjxOmuhlHGBpZaid
 GCbB8ePMZt2Ap8/iwKN9yrJmxzm4JjhkGHZINBllxuVWCq66k2vo+bcZ2s75G6HdRbur
 DGZ/X26URPuEakA929VT1juFKNztpDnLuThCO9NDo0/OjnT5yU1GfVfSqgMCl3+W9hyV
 Y7CrVuhAavzhmFCBHW+4qwZZJNIB7HxLJIkZZ+5K3tmtSdq2xKIpssNsl9Kt+vLPXjqp
 Nqci0w/ynSacLOE2cJ8OKWlvdWGkAjLTmlUB8leb/Uc7SyQMjoQbexwbhDntKLtn4clL /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w83csa85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JLePb4085089;
        Mon, 19 Jul 2021 21:41:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 39umaxsubt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEi2u7Aww2Q+Fa1dnH8D/e4CpBhSwPcIfD4ljJPhMg+C4yX0XfaMpGn5X3RflblxxRYI68OOpqsofclcVPsFpKQwRErcmH7sZitTwQLDEL8MhLB4S7bfmxRA1o2F7h8Fb4hmHJzsiCd0VNk+6kmQEs1I/3iZ3mWoVjrudHdOzjht1EIvxRQFTY+Npl+Fj9Sfsjs7VPZ8aoud3B90x/FuQbXBxaXkEkn1Xldjlmv3YybS4+AvNqnsRDXHEOcoK69l1LJEkI52HEdplrrIVcWOQ8vP+3yekAcvgQNASK0I1rcgK7ZW5KAONzbzrHPQwGVBP5DP+PXVqoyjbIAK3Vs22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=dPyn4A4C2ykjRC/Ps7VDL59d5X8OY6uXP0VAe9wQMFR5V5wDgcdTEGWT4c1pZ3C6DiuFP7lTBKC1m4+QVpUIaCKrKa2nY9fhG3MpWtJLgiOIqASkQ7wu1eb5e4NcN6P5IkOppnOstMgS47Tb6TfmWx1awGm0Kdk32D1jSQSl7t//fv0u0MKxn8XbxXWNjCpmUCSvZErmL0m861iE3sIg/KBUjsLSNxn0EQtSWJCThaqC8m36dHr35RMFvC2SrJt8/f9B0DylkW3GWO0rbtmx4DrcBnXWIUQVP/SuIQtAAmSDkHIFG4cfZi4BwRFBPG7YmVEW4W3kSE4jTWBnz9wsLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Kxgyz1cBR1FVhlGxpQZPYoZeqUSJwYJGNBOMS3cMeM=;
 b=zpox5IXwoYnZrF8keaanMUYST4ZEVsIG0mqSJUS7Nug38liHvmBqmWJlS7B7TGnwleY3e88KCU9z9gm+G+r2FpDDS4bNaPuV9t8iK1N5RNXGArEs/LV6yefB4yGJ5+SM8hVYUPGuj3FOvNNSHjnWtl6HLrJ5cmURoe+UmlN+QTI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3312.namprd10.prod.outlook.com (2603:10b6:208:126::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Mon, 19 Jul
 2021 21:41:38 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 21:41:38 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 2/3] selftests/bpf: add __int128-specific tests for typed data dump
Date:   Mon, 19 Jul 2021 22:41:28 +0100
Message-Id: <1626730889-5658-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
References: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DU2PR04CA0278.eurprd04.prod.outlook.com
 (2603:10a6:10:28c::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0278.eurprd04.prod.outlook.com (2603:10a6:10:28c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 21:41:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4064da92-87f4-4ac2-7976-08d94afdfd32
X-MS-TrafficTypeDiagnostic: MN2PR10MB3312:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB331259DAF0EF6EF2810244E5EFE19@MN2PR10MB3312.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snZmDOsXUTl12IaF0KgeZbhgkXAofaUF9fBZAdfXDaxgruSFLQEmT1ED93ptf3NLbYr9mIuU4ap9WoiFAj9KuwkkjlJRzffMOCLIbYOlNnPfSCRkBPyIbsvqNTELed+s8NFEeXFc9qs1i9ly1c02iIoFQHrcCy7PNIIwSPslkNOVISi1OYHZWAaPdOCzmw1LxGih5cktkHNpDiPpSga91KCkFZm/fXMohlckx287zAaW0wczVYRJYU3Ziq+vttF9sa514prdw8r2jWvnWY8HqUGBeQWdx/HDWHMV9KEAvcoYzz+OJEqDod2J6Ioja6DvzuVwY6Q22sESb064jHk4lHoyuIW42YaZoOMd44xK0CJ6NEPWrq+QoUEMr3tqRF54VCCh34mg3I6Qn6jVN06Sz4H9yyTr2Nscy9bQ4N8BA7DqvNYTZgfsKGKA7vXyjQq1ZP5VSk7BkyXmofvF7SgWNJ353JrmFwHNmamMZ4Ch6Yl8JTnaIUGtb/RyUBYoFA69dCrAmR6Nq6BYOaa6qsTe4efMel6vLeI4NK60kb0vn1TO5eg0Z+1+6r65znKQIOUvRdHJW9lsdihagw3LlcJwDhxYuhC+spnuH2DmYG24dUX6ml3qVD+DLstBeNnKDAPUUCKvNEe9VoXYyAO6eaqedAA9sv/pCcPl0DXf2kSrw7nZInlL27NDE3djLrswUIGyGhDZnkWJtymqhKa88Ff50g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(316002)(2616005)(956004)(36756003)(6506007)(186003)(44832011)(38100700002)(107886003)(38350700002)(86362001)(6486002)(8936002)(66476007)(8676002)(6666004)(5660300002)(4326008)(2906002)(52116002)(7416002)(66946007)(26005)(66556008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gAcLoLMChrxmmWYR/CwI7SuBh8wkS1z8sYtJAkGrsF8GsXsxMy7PJiMu/DzY?=
 =?us-ascii?Q?+v0cWNdfryujSenWhUtlY4MlGRa2/b6mTVhyZnlrwS5SuDlAuEa0d4dGrcxT?=
 =?us-ascii?Q?hpW+S2jE9IzO8FR/hwBWrbEREVKz4QXuLC5OMHc1MP/ZbLAH8FXFoIT0R6cc?=
 =?us-ascii?Q?7YeWJlPZNlzkKYCfSE5jODugrrnDA0Ec6aGs+dnIdbMj8utOhZ5a9h13i80t?=
 =?us-ascii?Q?BwAW8XhImqd9NBK3aNcIzzLUKGS+zlkXdeLnj5uwchV7qK+Kuno1iZG/nMvA?=
 =?us-ascii?Q?4V0pMFzbxEY9EKKDtDF+jF3Ruak2lHlBbxMGWQCxaneIoM4SHd3cK8quFl5d?=
 =?us-ascii?Q?qAmg16MA8T8R3OzETUm+B4CJXJEnI+zDm+CCMhdlSHGrEyRqGDmwMbhhe4nO?=
 =?us-ascii?Q?VPojMzWa6KgeMT9yTU9urMt+YKRHLEpJBD3muNyvbPyAZ7v+VgRWXlnaJj9m?=
 =?us-ascii?Q?TCk2qYjCYTTO5SPeWFXUD8/7+cILcQIJJF6pPDAD2KSQ7YiwnOHGrc1rwna3?=
 =?us-ascii?Q?H6aAXBgq85tL54lhpKKuA8SMTq5j7US6vJzIja9SGz/BibDEfO/ymLRgbgS0?=
 =?us-ascii?Q?qOY+81rjhMB67z2/ZPhGN5zqVswO7oXt5fSIPAJJN8cOu2Pudpr/tC7Q6MAr?=
 =?us-ascii?Q?FetGAde4eQvFaqUl9lkrL1LkaTPtNBGhs6PK0AJ/x5tJaACoS9+vtCOIfxLm?=
 =?us-ascii?Q?S1pRlUBAXjd8mPbm/ESwFPRQAs4E4hCN2le1PI7DB7ja72ysQPSsYFnDxkHO?=
 =?us-ascii?Q?Ei46FR1MEoiemMbLe5Y1Loe6g+tbzFDlRO6bi4UbF06/tzHnW1OSG/RnuLF5?=
 =?us-ascii?Q?eu5EPC/jgcCNdWoGVlPohxMkLa6eOT4pBybpWypPER7NH216aqadFFESyhrA?=
 =?us-ascii?Q?Y4VloyL5PlB/LJlP2Xfl/ne7YV9VcmJM4K2gm794MmHw059OAcdQbCSJP1s4?=
 =?us-ascii?Q?dcpyR9zW6IzmpEr78fNhAirFQ2C1DBzbSZ7sVyU3SLWEW59NARrErIUHdLpF?=
 =?us-ascii?Q?1RP62RZRcTn7ewLnvsJCfS56G+GBhGKbqjPYkHfoZIrFQfIAu7dkyc09bcuj?=
 =?us-ascii?Q?tJl1+pHy0swGhmj6RB24z5lu1yPGWAvVxXf5nuEdM8TfuGgKh1nh7NCbwp0r?=
 =?us-ascii?Q?uz0x33zpYvgJim7fMbyjHFtvVqMaBoh2HMAxEf1voieTr90lF5991/kkbUxt?=
 =?us-ascii?Q?+/0IyUCr9+3K3VBZL7ClQ/y9bxZjhs/GqzmmVi/JD3eNMZ6v19CdBoXxIQMv?=
 =?us-ascii?Q?jvsg6CETStQvEFbKS0dSxZqKaLThnjParM50wZ74U6opmPnXLHpg5Dh+cne7?=
 =?us-ascii?Q?l2bi/NxA9gWonlEPGkc3lc25?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4064da92-87f4-4ac2-7976-08d94afdfd32
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 21:41:38.6114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSjXJ30NbkaWrzYL2e9H+yPIxfr/2RWjIGU9ru6UVeoR4YELnnsaZtXVeSH8+KkYtJZ3kiRlviNMYA1wkE/gnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3312
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190124
X-Proofpoint-GUID: 3308haAD8-puiMAUPnM87A0EnkZSqaxu
X-Proofpoint-ORIG-GUID: 3308haAD8-puiMAUPnM87A0EnkZSqaxu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for __int128 display for platforms that support it.
__int128s are dumped as hex values.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index 0b4ba53..52ccf0c 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -327,6 +327,14 @@ static int btf_dump_data(struct btf *btf, struct btf_dump *d,
 static void test_btf_dump_int_data(struct btf *btf, struct btf_dump *d,
 				   char *str)
 {
+#ifdef __SIZEOF_INT128__
+	__int128 i = 0xffffffffffffffff;
+
+	/* this dance is required because we cannot directly initialize
+	 * a 128-bit value to anything larger than a 64-bit value.
+	 */
+	i = (i << 64) | (i - 1);
+#endif
 	/* simple int */
 	TEST_BTF_DUMP_DATA_C(btf, d, NULL, str, int, BTF_F_COMPACT, 1234);
 	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, BTF_F_COMPACT | BTF_F_NONAME,
@@ -348,6 +356,15 @@ static void test_btf_dump_int_data(struct btf *btf, struct btf_dump *d,
 	TEST_BTF_DUMP_DATA(btf, d, NULL, str, int, 0, "(int)-4567", -4567);
 
 	TEST_BTF_DUMP_DATA_OVER(btf, d, NULL, str, int, sizeof(int)-1, "", 1);
+
+#ifdef __SIZEOF_INT128__
+	TEST_BTF_DUMP_DATA(btf, d, NULL, str, __int128, BTF_F_COMPACT,
+			   "(__int128)0xffffffffffffffff",
+			   0xffffffffffffffff);
+	ASSERT_OK(btf_dump_data(btf, d, "__int128", NULL, 0, &i, 16, str,
+				"(__int128)0xfffffffffffffffffffffffffffffffe"),
+		  "dump __int128");
+#endif
 }
 
 static void test_btf_dump_float_data(struct btf *btf, struct btf_dump *d,
-- 
1.8.3.1

