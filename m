Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFE53CF663
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhGTINf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:13:35 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59536 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234772AbhGTIKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:10:10 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K8gacX004206;
        Tue, 20 Jul 2021 08:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=pGhWB5bcncVREjAK9TApj4gVNNhAcvSlsJPdPyvx1qM=;
 b=nuvdoJFkWfjS21snh/wZUgA36Ju2EGpvRZs03p5K8Cv8VzKL+XZpSiroFaqsNbTyWNRe
 ayqQQHHg3rKgSCfx6EeTVr+Q1i8elyPa6CfBTAy8QMLWWLsUH6eA/k8ewSemuVkCd5It
 y8TBX5voHecRKV6gW9/myi80TWKuQ2P8RHKv2+HLoiaaIs3NOjOoFleae+P7if1rAOM0
 jQBfnJYWgndeTjlTm7F9+z9jR9Uwin3IDahYfMPFSsj3RA+UYoWnPpJFM5Y/dJFafNEZ
 ZmkS80nfiH/HGW+lEIfJBYeT/crOhXt8v5Qoh04oaC3wiZUxp7d9cvMZZ00eLXHhoIWg Ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pGhWB5bcncVREjAK9TApj4gVNNhAcvSlsJPdPyvx1qM=;
 b=WhVuIJs3X7UtSyfMuCAIcSPzPSZvLL6Kc6OeB8aITnp7Xr8oB4DBt9kOa0DztNFtT1WY
 Od3O6+TY5dv+qX0OIP0IDoghA/Rhz5rJG3sZQVzdaxqsQbT6hy2d5hCHxaWqaxaKvtC+
 9ozz/iXwJHcT74+3l0n65YArtvaBApHpBAErXgMAFRL+dHfyoDIm81czhUTmA7rKnC3Y
 683qMDHK9+vCyrgfLTNMEDekH34uePBdjnb9Nh3yz+nQguCfii58zVjOfNE1OYQzmp7z
 prlOG0Br6bcyPrEVghnz8qFFVGHPN1DGG3457tVJ+NyPA+ru8Vu8vJNIBCWbtfg/VGuE sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w8p0t5jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16K8fHhK048484;
        Tue, 20 Jul 2021 08:50:10 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3030.oracle.com with ESMTP id 39upea14nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c78g/jXZuGYV+gFI8WJrZ9aUCQJAC+EfxAaBXSLG64KTiuKiBFZJs+cV8f0zj4QmPB9jTxMn+4kAHv0M1ppjY70a6YJb0KuWdoQk2maXz4gmbUN0WBlKwt0sPCovFKQW4i+ap07e7wb5vKwbHG6ZPHwjfrCjPFfNqSThp/g//8CFyT9X9Uh8PwJxQtu7SImEhShwRGld/ezrR5TCHZhyrM1OvjUmxBwYwXr4ieCRZKg5LvTpaBhfIZniTirur659A2TbY6fVhYLEzrNdH4Ci/DuNEN2N2XXoxbjxr5xszJiOLG/5vJnWOAqqpPmaOiP0UYtWnGhvKnWaQTCbJSYMcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGhWB5bcncVREjAK9TApj4gVNNhAcvSlsJPdPyvx1qM=;
 b=dhExrFFBQPVvWUPCfjhDc6uj1JdtgAYgv3Pigq4aXZK6tK3C4f/g5u5Es2LtHY1eKLwEmJPeOdkFUzzl7ROzDHBFEslGsLuGiS8/KRT5HuERyBEW0540WmkjZSdV3GizOtjMC3Pnp4/4QJ8BHKOn/XbqdHZvgbk+eALE6qDK8usX3OvsaP6wxDcItfeGt6F2TEYwSF9LjKDb2koe/5u5UJhAGLcvXNfsJZzcY1ePlfFRVXwnuhpv6bQkSCfV0TZcCmEqEOnxONXcnyDnzZPdyeJdn6O6P916NeTZlcZKFM+v+6cgGBbBEQI91C2GEh/ojFNpvH17/Wt+rwLJxFlgiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGhWB5bcncVREjAK9TApj4gVNNhAcvSlsJPdPyvx1qM=;
 b=kHnMKd0CahaWCF54ppkoYhnw38kt0vwJecb4gDPSR+fXsfmKjaNSn58CmQg6e8sD30dgcxLenlwajJVBNifzLdAGUnxZq5tjQldU+v7eRcJFuIpnDZKBo4hee9fgGFyOcw8FyRcOG9CK7hUYj/fqNYx3tl7TC6mxw2rXy6aoxsg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3470.namprd10.prod.outlook.com (2603:10b6:208:10d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Tue, 20 Jul
 2021 08:50:08 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 08:50:08 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 1/3] libbpf: avoid use of __int128 in typed dump display
Date:   Tue, 20 Jul 2021 09:49:51 +0100
Message-Id: <1626770993-11073-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
References: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DB6PR07CA0158.eurprd07.prod.outlook.com
 (2603:10a6:6:43::12) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DB6PR07CA0158.eurprd07.prod.outlook.com (2603:10a6:6:43::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Tue, 20 Jul 2021 08:50:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 532d8f30-cf9c-419d-6988-08d94b5b6030
X-MS-TrafficTypeDiagnostic: MN2PR10MB3470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB34705A5E0161332A2E32735CEFE29@MN2PR10MB3470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8iX6H1S0X1RmrcCNJVsxZG+NfQhctQ9BoFyCk1weEFDmNTPx3/os7Ptl7JHP1fbJyLgDOvSxom62MEfAGYK1J+maBhNqLJL7KNB9kxH5OF1RxflNlnocpC7dsiedHFOwpKeEukbKwcydams/Ybn/PC366Eh1nmZy9z5iZqjfh3LJEKE2tGWP86Ls7dbb7XJkC4xXWOqnHvi8RZMddEVKljyriMVUV0A2ZcB/MujS5k7aemg4jb2HYXAbVp1cns4G+z0wf54lvUMLIEbLtO+30KK8X2uNf0IrfL28a/6BbCgFqnDBe5aUiRH3oiLLmsLM66erTLDSep8TF4wp2phLNym1ifcs/HLId9AD76S4m8KhlG/NebhEG6aa6BAsAGd51pAlUcfSj6uHTq5jmxplXUOHUM/MGO3CeFbio7yHeh9CununXSqZF/uOXggoN4hz7LnTF4Lb2ERC11+Tdv9X8evE1GNiSvzpe4vCNHt3E+XF59rfy4mRa5QQxFPqpwI5hg2XiAdyj/AqSiGARaMSKZECMmUB6IjRRVAils6TDIsmNu+BPzfiMZyh+cVxYlXEu7NYUIFFC8kXwh7uADfuC2OTQB2v4Yf1CZxSfSxw/j4+1Qxq12SDRnBFlp8qTtjLrRK3eteC8D5q8IY3jAkcoyf7FnncWI7c82VwFfbtQyllx0KPrz27uYH4DsHXO9wQRcfk6W/TzX8r74cdLsiC5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(6506007)(6512007)(8936002)(2616005)(107886003)(26005)(66946007)(66476007)(956004)(6666004)(83380400001)(2906002)(4326008)(66556008)(86362001)(5660300002)(36756003)(52116002)(38100700002)(38350700002)(8676002)(6486002)(44832011)(186003)(316002)(7416002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2EBLvzGUWgFGDJ0R5wCkI4ifrzu69Hb3w5iE0XD5J3jvjrmg9GU/Qm91SK+R?=
 =?us-ascii?Q?O5mDpbdi2KF92NsCoTTLBv5wN1+pLgg6iqPaeO7V0qZiqkpB72TUkOUSE1Ap?=
 =?us-ascii?Q?egS2Z70z5YWRYZjFAZ7l8clxx7L9hObO2chv4+Gz54l+HcJnDzepQENvZnb7?=
 =?us-ascii?Q?PUL78BtxmFxYkJ1yTV34bNi54rqWDHZhxJJrs52SgR9xToomz1cm+WKOKzvQ?=
 =?us-ascii?Q?QTUqkuIrAKweDyeeKHNgmokBIjfaJdp0quVr5l6TfSzDqw7WVTTMsIjbTL/j?=
 =?us-ascii?Q?47ScEF9sUWSsyXqHmnEnfsgL4yQ7YH8LdufWa7RPjhMcOoci8sHawm8CbYI6?=
 =?us-ascii?Q?y/TLm7is+D+WsgiHY8b8MGzpg/eLchAX0gXbcCt9VMpbbneqQT4X5ZM+xGve?=
 =?us-ascii?Q?FH6Xw36BempeUN1dLF8gUsLdsd4FOU24tPgT/oUzij7ORjsS1en1yvclmL9a?=
 =?us-ascii?Q?KVDPpUhXxqREL4vMVhyM77YnCT25zUoqi5PfLFhHP6JtMCkxG6ksCUWARbsp?=
 =?us-ascii?Q?14MegvABIlzuLN1Kvmq7ILI8TQwJwsOzlAZKRCIM4g0l+YqHHFCI32zi0dPW?=
 =?us-ascii?Q?JzW3yhjMKGH8GBvn4i9kvtZ7D0SGb4wc76+MRD2Q6oJkG/Bn3crxSG12KAgz?=
 =?us-ascii?Q?0L9QO07H49oI96Dzs74Zy9skjBNMBHao66lFLLaEuukPjxeJtM91u1Tb9h2K?=
 =?us-ascii?Q?oNmkECeYOlEhMcQhUgUZe6NYonG1ST4BUnQZ1UrLJ61oYhJpM4oTbUnUXocQ?=
 =?us-ascii?Q?2i92iQyzYu4oWTTE2i48dkb8TmGpXmHnG9ePJmJeaboUvy+VeWAZvfDtlmxR?=
 =?us-ascii?Q?x1DXrMxDugox/CN1cQMxFNsA6EwD6+iPRnb2xYZwYW7AYY8fBdHm0GMRHhv3?=
 =?us-ascii?Q?+JAEshX0MLpkzY2QqfCrygeM7AqRJJyyOumVAHuG3SLzLyL3Ka+2TbyH2Li9?=
 =?us-ascii?Q?84qLovqYmAcP7NdMwP/1HUvf6iesZ/XWoYvAQW/TuJ5uEBdWmH1l/uf6ctNO?=
 =?us-ascii?Q?aRpoWmcppUhr7dbtC2Nxm+sXjV0m/LkEfejpM8tTJrO05yMikSeMtXyvcEPK?=
 =?us-ascii?Q?UCqax0jonOSJEIGahmuV5gWU7j2Om4/D6NpKEJqtukDqJagDU+lv/gl89tEZ?=
 =?us-ascii?Q?d0JBqnNWzLeWVqbklrxUKeBQZ1E870TUoh5UPc182X038HRDni9TQbkKsnUa?=
 =?us-ascii?Q?8idLiysIJtJLt25k7a5FgcPWNqrCdvn6iv8BTu888gFspk+B4FosyNfvCqdS?=
 =?us-ascii?Q?nrQDANNpGloFkRZm6JJj9tZfhGYdY3pq124ETvCCa7YWqUJonMV5QSjMAovd?=
 =?us-ascii?Q?G4o8Z46j4JvWK0bkzYqQwymD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532d8f30-cf9c-419d-6988-08d94b5b6030
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 08:50:07.9280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJR1LY3zBAwx+1aMcNm/RffyuD7YyNsng28KBrEW5lS5HXqQT+OWN4AFRzgPqLAJrBlkcnAvZmUO5grzIDcAaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107200052
X-Proofpoint-GUID: TWNp38e0tTLjsIUbuEeZBsvkhkgI6zeN
X-Proofpoint-ORIG-GUID: TWNp38e0tTLjsIUbuEeZBsvkhkgI6zeN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__int128 is not supported for some 32-bit platforms (arm and i386).
__int128 was used in carrying out computations on bitfields which
aid display, but the same calculations could be done with __u64
with the small effect of not supporting 128-bit bitfields.

With these changes, a big-endian issue with casting 128-bit integers
to 64-bit for enum bitfields is solved also, as we now use 64-bit
integers for bitfield calculations.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 98 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 65 insertions(+), 33 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index accf6fe..d52e546 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1552,31 +1552,26 @@ static int btf_dump_unsupported_data(struct btf_dump *d,
 	return -ENOTSUP;
 }
 
-static void btf_dump_int128(struct btf_dump *d,
-			    const struct btf_type *t,
-			    const void *data)
-{
-	__int128 num = *(__int128 *)data;
-
-	if ((num >> 64) == 0)
-		btf_dump_type_values(d, "0x%llx", (long long)num);
-	else
-		btf_dump_type_values(d, "0x%llx%016llx", (long long)num >> 32,
-				     (long long)num);
-}
-
-static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
-						    const struct btf_type *t,
-						    const void *data,
-						    __u8 bits_offset,
-						    __u8 bit_sz)
+static int btf_dump_get_bitfield_value(struct btf_dump *d,
+				       const struct btf_type *t,
+				       const void *data,
+				       __u8 bits_offset,
+				       __u8 bit_sz,
+				       __u64 *value)
 {
 	__u16 left_shift_bits, right_shift_bits;
 	__u8 nr_copy_bits, nr_copy_bytes;
-	unsigned __int128 num = 0, ret;
 	const __u8 *bytes = data;
+	int sz = t->size;
+	__u64 num = 0;
 	int i;
 
+	/* Maximum supported bitfield size is 64 bits */
+	if (sz > 8) {
+		pr_warn("unexpected bitfield size %d\n", sz);
+		return -EINVAL;
+	}
+
 	/* Bitfield value retrieval is done in two steps; first relevant bytes are
 	 * stored in num, then we left/right shift num to eliminate irrelevant bits.
 	 */
@@ -1591,12 +1586,12 @@ static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
 #else
 # error "Unrecognized __BYTE_ORDER__"
 #endif
-	left_shift_bits = 128 - nr_copy_bits;
-	right_shift_bits = 128 - bit_sz;
+	left_shift_bits = 64 - nr_copy_bits;
+	right_shift_bits = 64 - bit_sz;
 
-	ret = (num << left_shift_bits) >> right_shift_bits;
+	*value = (num << left_shift_bits) >> right_shift_bits;
 
-	return ret;
+	return 0;
 }
 
 static int btf_dump_bitfield_check_zero(struct btf_dump *d,
@@ -1605,9 +1600,12 @@ static int btf_dump_bitfield_check_zero(struct btf_dump *d,
 					__u8 bits_offset,
 					__u8 bit_sz)
 {
-	__int128 check_num;
+	__u64 check_num;
+	int err;
 
-	check_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
+	err = btf_dump_get_bitfield_value(d, t, data, bits_offset, bit_sz, &check_num);
+	if (err)
+		return err;
 	if (check_num == 0)
 		return -ENODATA;
 	return 0;
@@ -1619,10 +1617,14 @@ static int btf_dump_bitfield_data(struct btf_dump *d,
 				  __u8 bits_offset,
 				  __u8 bit_sz)
 {
-	unsigned __int128 print_num;
+	__u64 print_num;
+	int err;
+
+	err = btf_dump_get_bitfield_value(d, t, data, bits_offset, bit_sz, &print_num);
+	if (err)
+		return err;
 
-	print_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
-	btf_dump_int128(d, t, &print_num);
+	btf_dump_type_values(d, "0x%llx", (unsigned long long)print_num);
 
 	return 0;
 }
@@ -1681,9 +1683,29 @@ static int btf_dump_int_data(struct btf_dump *d,
 		return btf_dump_bitfield_data(d, t, data, 0, 0);
 
 	switch (sz) {
-	case 16:
-		btf_dump_int128(d, t, data);
+	case 16: {
+		const __u64 *ints = data;
+		__u64 lsi, msi;
+
+		/* avoid use of __int128 as some 32-bit platforms do not
+		 * support it.
+		 */
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+		lsi = ints[0];
+		msi = ints[1];
+#elif __BYTE_ORDER == __BIG_ENDIAN
+		lsi = ints[1];
+		msi = ints[0];
+#else
+# error "Unrecognized __BYTE_ORDER__"
+#endif
+		if (msi == 0)
+			btf_dump_type_values(d, "0x%llx", (unsigned long long)lsi);
+		else
+			btf_dump_type_values(d, "0x%llx%016llx", (unsigned long long)msi,
+					     (unsigned long long)lsi);
 		break;
+	}
 	case 8:
 		if (sign)
 			btf_dump_type_values(d, "%lld", *(long long *)data);
@@ -1931,9 +1953,16 @@ static int btf_dump_get_enum_value(struct btf_dump *d,
 
 	/* handle unaligned enum value */
 	if (!ptr_is_aligned(data, sz)) {
-		*value = (__s64)btf_dump_bitfield_get_data(d, t, data, 0, 0);
+		__u64 val;
+		int err;
+
+		err = btf_dump_get_bitfield_value(d, t, data, 0, 0, &val);
+		if (err)
+			return err;
+		*value = (__s64)val;
 		return 0;
 	}
+
 	switch (t->size) {
 	case 8:
 		*value = *(__s64 *)data;
@@ -2209,10 +2238,13 @@ static int btf_dump_dump_type_data(struct btf_dump *d,
 	case BTF_KIND_ENUM:
 		/* handle bitfield and int enum values */
 		if (bit_sz) {
-			unsigned __int128 print_num;
+			__u64 print_num;
 			__s64 enum_val;
 
-			print_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
+			err = btf_dump_get_bitfield_value(d, t, data, bits_offset, bit_sz,
+							  &print_num);
+			if (err)
+				break;
 			enum_val = (__s64)print_num;
 			err = btf_dump_enum_data(d, t, id, &enum_val);
 		} else
-- 
1.8.3.1

