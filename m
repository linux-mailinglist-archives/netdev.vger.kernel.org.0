Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE7D3CA147
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbhGOPSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:18:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38826 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238478AbhGOPSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:18:51 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FF5pxJ019335;
        Thu, 15 Jul 2021 15:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+g708tQUhRvCLRR/zXQJKeQYHQW80wAQtdH19L6jVHU=;
 b=vylXS5tW3MCSXnpYU7/H5ZxgvNmJXFuzoqdEs6CdFJRymW/ijHiV469cRY8Qd1L8zE+6
 PmSpG0d0ItVLxBpiSBCUmi/UZSw47+IzAU0YYO2U1HHT+da9YTFeCuQde72YDMYk+/CN
 i6zK2gAS8cLlixYat/YQkzmQdOvdMhiQB0bQ2FrClLLkN9bThb6YRx6QKWWn1Z/cXbxR
 9d4y290/z1DvCN5DNJKw8Vrh0xK5iSrfdhFFjkMnuTCjNJYiUfPgYLa4QncxXxG//WYa
 MZSAsKI252+PuI+Rx1QcdNmy2hJ5IsWtTngpo4J8BRU8eIccLpSBsTJd9ySGeoXFJcR8 Mg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+g708tQUhRvCLRR/zXQJKeQYHQW80wAQtdH19L6jVHU=;
 b=ta6EPk/lQ4nZdiHnYtGuz7lUlR3SqqmD9NW6NZtZmcbAh5FPjrGasBAgIf9n7h0B4vDw
 kFAOg8353e09r0fJ8+EMhq7inhVgauESn6y317lC4SGro/AWnR24M0nA7evymCSyJFLD
 iPqSM4Gk5OJp6vhXKoI9p6RB04Y4d/2wKJAmkESuvcr3+0B68CZemAhWlKBXpD2dPGZh
 zqdBVe5pxvsUjZxOxU2s0xugYaXp1OLp+uqQyUzGI/+TrHMZ49inC0stbrOoXGu2a9Ji
 6OlQUQeNsXjgqfeMJZMf1ezMjyJ9kNsf0o4td/M0tLxKB6jDIHUahxhyN95rb3sFGSVR vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39tg51100f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FF6pQr092372;
        Thu, 15 Jul 2021 15:15:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 39q3chuheq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 15:15:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaV7jc0x95LIRUSKSgQ2SbWDoMm89gtlnw5YP3xqlV9hygHUhntKBTuWXoYJu7pzBB3snrV7SrJIV/dtG+UyZwnf7biGJ+Ta9o6lTZ01eeZtsOzxc+87DG4d4dWZFAF1JVu24tMtFnv79NuWQ9A4Z+3UEe1MnpQPLSfx9X2eJumDoJEafOQg4v60lcavsMGLseuUrvAeVDxYh+1PgaB+Vd6boustUfVl58GzD6euPOmSUDD8pAx6OardFvfBl/b7ByuNc4Z5bOp/CC/og15inBN9IG5Wz79uqfCNJcljsLRHcgfOk7EzhT3jfGxN7DxYYUFTzrQa6tCykRSQkCTTOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+g708tQUhRvCLRR/zXQJKeQYHQW80wAQtdH19L6jVHU=;
 b=UxHqo6ydrtpbKt2KGCzW+HyfA7OcM1NaTnUkF/NzVdAd5Wt5L+gs9PB7bTqdrTz+Rap2fvjturIV7pDLcvDbSvMOoNR/9ZvM89Qh1DPFz6sScFjC0XwGIVufL/L36okf90yaA0JaNkRdZu4vclG8x4kKrrb7vqKbgZ2ctHr+4UGw6zH2PKv5vItnioLZ3jqKLO9Bg0YFXDShqIkPcu/x0siFL99XF/cugKb0GtcNnadBMHduiDZgEFOD6Wj0AQ+WMk9/iiXoaBD7+mhgwt/waRUPtulBRs1Yh/FRnDfwblXwdELOgULgYBe4tstIVGnuhfIxD5eT0WKfLfTeInry+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+g708tQUhRvCLRR/zXQJKeQYHQW80wAQtdH19L6jVHU=;
 b=JW36iPlvCXAVhZaPM6tB0hJCpP1KM2etjkYKDefd4YWgPLUXHPECmPpJ6uZqIRHzES7TqMIK+Abv4KhgFuzfYTfMv2pu5gQdTC0ONlSLgSLoU0lN+ANkx00/WjbUrBpB1mp/CiEVmNocoS1elfEbSH+iXYejejbrXh9v54AGYw0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3376.namprd10.prod.outlook.com (2603:10b6:208:12e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 15:15:34 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 15:15:34 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v6 bpf-next 1/3] libbpf: BTF dumper support for typed data
Date:   Thu, 15 Jul 2021 16:15:24 +0100
Message-Id: <1626362126-27775-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com>
References: <1626362126-27775-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::20) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:18d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 15:15:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15dbb2d1-cc88-46d8-b144-08d947a36498
X-MS-TrafficTypeDiagnostic: MN2PR10MB3376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB33768F6444E8EFEC033FB298EF129@MN2PR10MB3376.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09n+3ek3m39jr6Z+Sv/jiNN26uImAECEJk4K8eTiWJRmOxyx1lQJ1/zUBXc3nClQOns0lzgxuWE3L+T24W+M/i2mGJSLxKrm6Ma3ScI5M/7VnwQWsQVutMIx4laotQwie53vZa1vFAM4277uAx2V2GJD6sQX2R7fZyBbwOdgqRhQb2nh9j7SxfF/6dbpwsT7Ia3MdtV2wRdK7iMkVWUu4MqYj/tbq+wyIX9LQ/8SQXUhICbR9W+6kYNHW/mek3y4eFAliDEhIydqInCFD85oFKigULCUiCRetnf3fPzH0LXZg4kYzCnI14FS+q38aIlSbPuDn5dU2jjqjzdmdTBYv3IBxcXqf4+d2uRwYiwqt82ImZeLQK9bfqxI6cQfgk+TdBnd9nTnuheVyqz/WpA0Dq6LH5E3cYzEgJSuuTMI4l/ohXSU7uCeCHrGQVy6lWQDVSX8SLqt4cnrtWzSMfy/VDjTLMfCxjyfHU5VL8kxrX3dHO3y2dWjlCPEpeQgjS+hxKmfQ/ZUNzKExpImN1mGuHXNjMxPdSZ+uNnEGCoPnYXJOd6IWUOt/AJpu904L7cpRHY5+0zmEjBNb6NHUJKXHINCxrCnxW4pf6cxAraKO604tJJaXTMgtLmlAHrvtiK+MLuwpjTYTBfF5Gubio8vAAeoygxtkho8ah1XKOqNp67uBpez3JD9FGYr5ohA4AlDTdON5NFZK3Q368eNJTm5Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(186003)(5660300002)(2616005)(956004)(83380400001)(38350700002)(38100700002)(8936002)(4326008)(6666004)(86362001)(30864003)(52116002)(478600001)(2906002)(44832011)(7696005)(316002)(66946007)(66556008)(66476007)(7416002)(107886003)(6486002)(26005)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvVoj7V+MIcirqcT3px+N3EEhEof0eSl0NwV1JZNI6U0u98TTxbx0TdW4CIp?=
 =?us-ascii?Q?gGRfOKTMR/+Am29jIdn0Wsj+j4Rl/1/t32ur8uarqLucpKq/tb24SWQgZf/s?=
 =?us-ascii?Q?AZx2QF/Zjomz6BKPARlqkEHRClBTD+u1ybxbPomaIuBvL86SgvTjci0yNoFl?=
 =?us-ascii?Q?VW9P53dUMgKvCfj+DnWkR4A6M1px5pAMiJdqw3RtyCoX33lqstp+aLGm3ubd?=
 =?us-ascii?Q?FleMpDaS7EYvG/phG00QdbAaEL9y84r94IiyBds/0Teoi9A1bA4Hq8f7Gz3p?=
 =?us-ascii?Q?r7mGG6WBUOrtg6kaELTaR49E7eqGOXa+xVfCcIo+qbGwPMqx5wHblOSlZlug?=
 =?us-ascii?Q?BZoyPBQd4Ie1EG7tLTR8kOx/YgMI7i4IsVCdWhCD43+zpUX1VkX7OSB9Zl4D?=
 =?us-ascii?Q?LqkMcqLPGqusAZac+jQLtW9oyXtbHWpoHvMAwdf/vhBn/XrRuzZ7gUeaX8Nh?=
 =?us-ascii?Q?dwV3NXZu++OLKfRYALJ48mJILUBhNhXIRL6yenj1vUmxvof0s0ycRbvD/4Be?=
 =?us-ascii?Q?iqDOhBx/BjnWsZfwUd5q/ABplOFoVpHBKjzhoI4OEhQ8FrqE07FDahKJU6+E?=
 =?us-ascii?Q?bl0ojB85OK4XJ12139riHBRys/eBYbNV7wmF4ICgAscXvZbdRmCHtP8KI1pZ?=
 =?us-ascii?Q?yHua2eyWEa0L3O/QRpEtGciUbhK4N3eMfPEP+2F2Dc3e62sk/jL7/pJNjTY2?=
 =?us-ascii?Q?JFmcMqdqvSOTA5UmMCOkWUUD0EiuXQmOte0y6fNwbMavxmGQoZmWtICR7T9w?=
 =?us-ascii?Q?Gq3bRlW+UcZ/6DdzVE5hBY8UvUgvOdNc3UD5Ep92lN3QpMWuADcgsoZ8H/AD?=
 =?us-ascii?Q?P4PNln5/DXcT3DBaGeHpcCxxVU7fW8i7wlE9oihfRQmVxt5veCkrJLY7fWvl?=
 =?us-ascii?Q?uymjfuk92hueLsXMLJ2CaxEVgcwMbjEG75hA3Z1mMo4UbCqVkvNg0rscwO3Q?=
 =?us-ascii?Q?Iv2HWGQGfAvQxwJCS3efTSGLasvY/DXo5esU1wdm9pMa4U3MkWz9Jpwjwe2n?=
 =?us-ascii?Q?dgJm9qDaTsdhrbxj9UfBE4e6/BmSux6mDUJ1N/GkIGnkqtkj0Cnm1giTVIJV?=
 =?us-ascii?Q?L8Ed4/8ayZayyDe1rXZo0u8c3p7E6AGPGwzmS2CVak83d8mqmm4rb8iE5i+D?=
 =?us-ascii?Q?mek8zUr++BIg+DSPruCNMse+ouyKXqDYcfF9p97q5nnWtTcEZiHaDY0z2bnT?=
 =?us-ascii?Q?Olmbf5f6sHK1tApQsUQkCAiG/A6G6chhzffAxplq+3UEz2LsdIJ7r3YneiQg?=
 =?us-ascii?Q?/4y42FYGplTmC6CxvKSHZE9G3flp3ko8yyanKiUDM19vrKm8yzuaMN39K0ZH?=
 =?us-ascii?Q?wMfD5V85X5dmFS/Ke1LG1SOP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15dbb2d1-cc88-46d8-b144-08d947a36498
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 15:15:34.3790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKiYGqjbrzmapdogDTAaRTWc5Sy/HIv1z0LiKP6ey43OXe3Ykn3vgb2TKW81o8N3dDg0DOe9ErAuER36d3INpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3376
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150107
X-Proofpoint-GUID: 3Tj6AWL1r4ZdxML2AGQJBi-bGC4jAntu
X-Proofpoint-ORIG-GUID: 3Tj6AWL1r4ZdxML2AGQJBi-bGC4jAntu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a BTF dumper for typed data, so that the user can dump a typed
version of the data provided.

The API is

int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
                             void *data, size_t data_sz,
                             const struct btf_dump_type_data_opts *opts);

...where the id is the BTF id of the data pointed to by the "void *"
argument; for example the BTF id of "struct sk_buff" for a
"struct skb *" data pointer.  Options supported are

 - a starting indent level (indent_lvl)
 - a user-specified indent string which will be printed once per
   indent level; if NULL, tab is chosen but any string <= 32 chars
   can be provided.
 - a set of boolean options to control dump display, similar to those
   used for BPF helper bpf_snprintf_btf().  Options are
        - compact : omit newlines and other indentation
        - skip_names: omit member names
        - emit_zeroes: show zero-value members

Default output format is identical to that dumped by bpf_snprintf_btf(),
for example a "struct sk_buff" representation would look like this:

struct sk_buff){
	(union){
		(struct){
			.next = (struct sk_buff *)0xffffffffffffffff,
			.prev = (struct sk_buff *)0xffffffffffffffff,
		(union){
			.dev = (struct net_device *)0xffffffffffffffff,
			.dev_scratch = (long unsigned int)18446744073709551615,
		},
	},
...

If the data structure is larger than the *data_sz*
number of bytes that are available in *data*, as much
of the data as possible will be dumped and -E2BIG will
be returned.  This is useful as tracers will sometimes
not be able to capture all of the data associated with
a type; for example a "struct task_struct" is ~16k.
Being able to specify that only a subset is available is
important for such cases.  On success, the amount of data
dumped is returned.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf.h      |  19 ++
 tools/lib/bpf/btf_dump.c | 819 ++++++++++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 834 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index b54f1c3..374e9f1 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -184,6 +184,25 @@ struct btf_dump_emit_type_decl_opts {
 btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 			 const struct btf_dump_emit_type_decl_opts *opts);
 
+
+struct btf_dump_type_data_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	const char *indent_str;
+	int indent_level;
+	/* below match "show" flags for bpf_show_snprintf() */
+	bool compact;		/* no newlines/indentation */
+	bool skip_names;	/* skip member/type names */
+	bool emit_zeroes;	/* show 0-valued fields */
+	size_t :0;
+};
+#define btf_dump_type_data_opts__last_field emit_zeroes
+
+LIBBPF_API int
+btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
+			 const void *data, size_t data_sz,
+			 const struct btf_dump_type_data_opts *opts);
+
 /*
  * A set of helpers for easier BTF types handling
  */
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 5dc6b517..929cf93 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -10,6 +10,8 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <string.h>
+#include <ctype.h>
+#include <endian.h>
 #include <errno.h>
 #include <linux/err.h>
 #include <linux/btf.h>
@@ -53,6 +55,26 @@ struct btf_dump_type_aux_state {
 	__u8 referenced: 1;
 };
 
+/* indent string length; one indent string is added for each indent level */
+#define BTF_DATA_INDENT_STR_LEN			32
+
+/*
+ * Common internal data for BTF type data dump operations.
+ */
+struct btf_dump_data {
+	const void *data_end;		/* end of valid data to show */
+	bool compact;
+	bool skip_names;
+	bool emit_zeroes;
+	__u8 indent_lvl;	/* base indent level */
+	char indent_str[BTF_DATA_INDENT_STR_LEN];
+	/* below are used during iteration */
+	int depth;
+	bool is_array_member;
+	bool is_array_terminated;
+	bool is_array_char;
+};
+
 struct btf_dump {
 	const struct btf *btf;
 	const struct btf_ext *btf_ext;
@@ -60,6 +82,7 @@ struct btf_dump {
 	struct btf_dump_opts opts;
 	int ptr_sz;
 	bool strip_mods;
+	bool skip_anon_defs;
 	int last_id;
 
 	/* per-type auxiliary state */
@@ -89,6 +112,10 @@ struct btf_dump {
 	 * name occurrences
 	 */
 	struct hashmap *ident_names;
+	/*
+	 * data for typed display; allocated if needed.
+	 */
+	struct btf_dump_data *typed_dump;
 };
 
 static size_t str_hash_fn(const void *key, void *ctx)
@@ -765,11 +792,11 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 		break;
 	case BTF_KIND_FUNC_PROTO: {
 		const struct btf_param *p = btf_params(t);
-		__u16 vlen = btf_vlen(t);
+		__u16 n = btf_vlen(t);
 		int i;
 
 		btf_dump_emit_type(d, t->type, cont_id);
-		for (i = 0; i < vlen; i++, p++)
+		for (i = 0; i < n; i++, p++)
 			btf_dump_emit_type(d, p->type, cont_id);
 
 		break;
@@ -852,8 +879,9 @@ static void btf_dump_emit_bit_padding(const struct btf_dump *d,
 static void btf_dump_emit_struct_fwd(struct btf_dump *d, __u32 id,
 				     const struct btf_type *t)
 {
-	btf_dump_printf(d, "%s %s",
+	btf_dump_printf(d, "%s%s%s",
 			btf_is_struct(t) ? "struct" : "union",
+			t->name_off ? " " : "",
 			btf_dump_type_name(d, id));
 }
 
@@ -1259,7 +1287,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 		case BTF_KIND_UNION:
 			btf_dump_emit_mods(d, decls);
 			/* inline anonymous struct/union */
-			if (t->name_off == 0)
+			if (t->name_off == 0 && !d->skip_anon_defs)
 				btf_dump_emit_struct_def(d, id, t, lvl);
 			else
 				btf_dump_emit_struct_fwd(d, id, t);
@@ -1267,7 +1295,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 		case BTF_KIND_ENUM:
 			btf_dump_emit_mods(d, decls);
 			/* inline anonymous enum */
-			if (t->name_off == 0)
+			if (t->name_off == 0 && !d->skip_anon_defs)
 				btf_dump_emit_enum_def(d, id, t, lvl);
 			else
 				btf_dump_emit_enum_fwd(d, id, t);
@@ -1392,6 +1420,39 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 	btf_dump_emit_name(d, fname, last_was_ptr);
 }
 
+/* show type name as (type_name) */
+static void btf_dump_emit_type_cast(struct btf_dump *d, __u32 id,
+				    bool top_level)
+{
+	const struct btf_type *t;
+
+	/* for array members, we don't bother emitting type name for each
+	 * member to avoid the redundancy of
+	 * .name = (char[4])[(char)'f',(char)'o',(char)'o',]
+	 */
+	if (d->typed_dump->is_array_member)
+		return;
+
+	/* avoid type name specification for variable/section; it will be done
+	 * for the associated variable value(s).
+	 */
+	t = btf__type_by_id(d->btf, id);
+	if (btf_is_var(t) || btf_is_datasec(t))
+		return;
+
+	if (top_level)
+		btf_dump_printf(d, "(");
+
+	d->skip_anon_defs = true;
+	d->strip_mods = true;
+	btf_dump_emit_type_decl(d, id, "", 0);
+	d->strip_mods = false;
+	d->skip_anon_defs = false;
+
+	if (top_level)
+		btf_dump_printf(d, ")");
+}
+
 /* return number of duplicates (occurrences) of a given name */
 static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
 				 const char *orig_name)
@@ -1442,3 +1503,751 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
 {
 	return btf_dump_resolve_name(d, id, d->ident_names);
 }
+
+static int btf_dump_dump_type_data(struct btf_dump *d,
+				   const char *fname,
+				   const struct btf_type *t,
+				   __u32 id,
+				   const void *data,
+				   __u8 bits_offset,
+				   __u8 bit_sz);
+
+static const char *btf_dump_data_newline(struct btf_dump *d)
+{
+	return d->typed_dump->compact || d->typed_dump->depth == 0 ? "" : "\n";
+}
+
+static const char *btf_dump_data_delim(struct btf_dump *d)
+{
+	return d->typed_dump->depth == 0 ? "" : ",";
+}
+
+static void btf_dump_data_pfx(struct btf_dump *d)
+{
+	int i, lvl = d->typed_dump->indent_lvl + d->typed_dump->depth;
+
+	if (d->typed_dump->compact)
+		return;
+
+	for (i = 0; i < lvl; i++)
+		btf_dump_printf(d, "%s", d->typed_dump->indent_str);
+}
+
+/* A macro is used here as btf_type_value[s]() appends format specifiers
+ * to the format specifier passed in; these do the work of appending
+ * delimiters etc while the caller simply has to specify the type values
+ * in the format specifier + value(s).
+ */
+#define btf_dump_type_values(d, fmt, ...)				\
+	btf_dump_printf(d, fmt "%s%s",					\
+			##__VA_ARGS__,					\
+			btf_dump_data_delim(d),				\
+			btf_dump_data_newline(d))
+
+static int btf_dump_unsupported_data(struct btf_dump *d,
+				     const struct btf_type *t,
+				     __u32 id)
+{
+	btf_dump_printf(d, "<unsupported kind:%u>", btf_kind(t));
+	return -ENOTSUP;
+}
+
+static void btf_dump_int128(struct btf_dump *d,
+			    const struct btf_type *t,
+			    const void *data)
+{
+	__int128 num = *(__int128 *)data;
+
+	if ((num >> 64) == 0)
+		btf_dump_type_values(d, "0x%llx", (long long)num);
+	else
+		btf_dump_type_values(d, "0x%llx%016llx", (long long)num >> 32,
+				     (long long)num);
+}
+
+static unsigned __int128 btf_dump_bitfield_get_data(struct btf_dump *d,
+						    const struct btf_type *t,
+						    const void *data,
+						    __u8 bits_offset,
+						    __u8 bit_sz)
+{
+	__u16 left_shift_bits, right_shift_bits;
+	__u8 nr_copy_bits, nr_copy_bytes;
+	unsigned __int128 num = 0, ret;
+	const __u8 *bytes = data;
+	int i;
+
+	/* Bitfield value retrieval is done in two steps; first relevant bytes are
+	 * stored in num, then we left/right shift num to eliminate irrelevant bits.
+	 */
+	nr_copy_bits = bit_sz + bits_offset;
+	nr_copy_bytes = t->size;
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+	for (i = nr_copy_bytes - 1; i >= 0; i--)
+		num = num * 256 + bytes[i];
+#elif __BYTE_ORDER == __BIG_ENDIAN
+	for (i = 0; i < nr_copy_bytes; i++)
+		num = num * 256 + bytes[i];
+#else
+# error "Unrecognized __BYTE_ORDER__"
+#endif
+	left_shift_bits = 128 - nr_copy_bits;
+	right_shift_bits = 128 - bit_sz;
+
+	ret = (num << left_shift_bits) >> right_shift_bits;
+
+	return ret;
+}
+
+static int btf_dump_bitfield_check_zero(struct btf_dump *d,
+					const struct btf_type *t,
+					const void *data,
+					__u8 bits_offset,
+					__u8 bit_sz)
+{
+	__int128 check_num;
+
+	check_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
+	if (check_num == 0)
+		return -ENODATA;
+	return 0;
+}
+
+static int btf_dump_bitfield_data(struct btf_dump *d,
+				  const struct btf_type *t,
+				  const void *data,
+				  __u8 bits_offset,
+				  __u8 bit_sz)
+{
+	unsigned __int128 print_num;
+
+	print_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
+	btf_dump_int128(d, t, &print_num);
+
+	return 0;
+}
+
+/* ints, floats and ptrs */
+static int btf_dump_base_type_check_zero(struct btf_dump *d,
+					 const struct btf_type *t,
+					 __u32 id,
+					 const void *data)
+{
+	static __u8 bytecmp[16] = {};
+	int nr_bytes;
+
+	/* For pointer types, pointer size is not defined on a per-type basis.
+	 * On dump creation however, we store the pointer size.
+	 */
+	if (btf_kind(t) == BTF_KIND_PTR)
+		nr_bytes = d->ptr_sz;
+	else
+		nr_bytes = t->size;
+
+	if (nr_bytes < 1 || nr_bytes > 16) {
+		pr_warn("unexpected size %d for id [%u]\n", nr_bytes, id);
+		return -EINVAL;
+	}
+
+	if (memcmp(data, bytecmp, nr_bytes) == 0)
+		return -ENODATA;
+	return 0;
+}
+
+static int btf_dump_int_data(struct btf_dump *d,
+			     const struct btf_type *t,
+			     __u32 type_id,
+			     const void *data,
+			     __u8 bits_offset)
+{
+	__u8 encoding = btf_int_encoding(t);
+	bool sign = encoding & BTF_INT_SIGNED;
+	int sz = t->size;
+
+	if (sz == 0) {
+		pr_warn("unexpected size %d for id [%u]\n", sz, type_id);
+		return -EINVAL;
+	}
+
+	/* handle packed int data - accesses of integers not aligned on
+	 * int boundaries can cause problems on some platforms.
+	 */
+	if (((uintptr_t)data) % sz)
+		return btf_dump_bitfield_data(d, t, data, 0, 0);
+
+	switch (sz) {
+	case 16:
+		btf_dump_int128(d, t, data);
+		break;
+	case 8:
+		if (sign)
+			btf_dump_type_values(d, "%lld", *(long long *)data);
+		else
+			btf_dump_type_values(d, "%llu", *(unsigned long long *)data);
+		break;
+	case 4:
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s32 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u32 *)data);
+		break;
+	case 2:
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s16 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u16 *)data);
+		break;
+	case 1:
+		if (d->typed_dump->is_array_char) {
+			/* check for null terminator */
+			if (d->typed_dump->is_array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				d->typed_dump->is_array_terminated = true;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_dump_type_values(d, "'%c'", *(char *)data);
+				break;
+			}
+		}
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s8 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u8 *)data);
+		break;
+	default:
+		pr_warn("unexpected sz %d for id [%u]\n", sz, type_id);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+union float_data {
+	long double ld;
+	double d;
+	float f;
+};
+
+static int btf_dump_float_data(struct btf_dump *d,
+			       const struct btf_type *t,
+			       __u32 type_id,
+			       const void *data)
+{
+	const union float_data *flp = data;
+	union float_data fl;
+	int sz = t->size;
+
+	/* handle unaligned data; copy to local union */
+	if (((uintptr_t)data) % sz) {
+		memcpy(&fl, data, sz);
+		flp = &fl;
+	}
+
+	switch (sz) {
+	case 16:
+		btf_dump_type_values(d, "%Lf", flp->ld);
+		break;
+	case 8:
+		btf_dump_type_values(d, "%lf", flp->d);
+		break;
+	case 4:
+		btf_dump_type_values(d, "%f", flp->f);
+		break;
+	default:
+		pr_warn("unexpected size %d for id [%u]\n", sz, type_id);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int btf_dump_var_data(struct btf_dump *d,
+			     const struct btf_type *v,
+			     __u32 id,
+			     const void *data)
+{
+	enum btf_func_linkage linkage = btf_var(v)->linkage;
+	const struct btf_type *t;
+	const char *l;
+	__u32 type_id;
+
+	switch (linkage) {
+	case BTF_FUNC_STATIC:
+		l = "static ";
+		break;
+	case BTF_FUNC_EXTERN:
+		l = "extern ";
+		break;
+	case BTF_FUNC_GLOBAL:
+	default:
+		l = "";
+		break;
+	}
+
+	/* format of output here is [linkage] [type] [varname] = (type)value,
+	 * for example "static int cpu_profile_flip = (int)1"
+	 */
+	btf_dump_printf(d, "%s", l);
+	type_id = v->type;
+	t = btf__type_by_id(d->btf, type_id);
+	btf_dump_emit_type_cast(d, type_id, false);
+	btf_dump_printf(d, " %s = ", btf_name_of(d, v->name_off));
+	return btf_dump_dump_type_data(d, NULL, t, type_id, data, 0, 0);
+}
+
+static int btf_dump_array_data(struct btf_dump *d,
+			       const struct btf_type *t,
+			       __u32 id,
+			       const void *data)
+{
+	const struct btf_array *array = btf_array(t);
+	const struct btf_type *elem_type;
+	__u32 i, elem_size = 0, elem_type_id;
+	bool is_array_member;
+
+	elem_type_id = array->type;
+	elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
+	elem_size = btf__resolve_size(d->btf, elem_type_id);
+	if (elem_size <= 0) {
+		pr_warn("unexpected elem size %d for array type [%u]\n", elem_size, id);
+		return -EINVAL;
+	}
+
+	if (btf_is_int(elem_type)) {
+		/*
+		 * BTF_INT_CHAR encoding never seems to be set for
+		 * char arrays, so if size is 1 and element is
+		 * printable as a char, we'll do that.
+		 */
+		if (elem_size == 1)
+			d->typed_dump->is_array_char = true;
+	}
+
+	/* note that we increment depth before calling btf_dump_print() below;
+	 * this is intentional.  btf_dump_data_newline() will not print a
+	 * newline for depth 0 (since this leaves us with trailing newlines
+	 * at the end of typed display), so depth is incremented first.
+	 * For similar reasons, we decrement depth before showing the closing
+	 * parenthesis.
+	 */
+	d->typed_dump->depth++;
+	btf_dump_printf(d, "[%s", btf_dump_data_newline(d));
+
+	/* may be a multidimensional array, so store current "is array member"
+	 * status so we can restore it correctly later.
+	 */
+	is_array_member = d->typed_dump->is_array_member;
+	d->typed_dump->is_array_member = true;
+	for (i = 0; i < array->nelems; i++, data += elem_size) {
+		if (d->typed_dump->is_array_terminated)
+			break;
+		btf_dump_dump_type_data(d, NULL, elem_type, elem_type_id, data, 0, 0);
+	}
+	d->typed_dump->is_array_member = is_array_member;
+	d->typed_dump->depth--;
+	btf_dump_data_pfx(d);
+	btf_dump_type_values(d, "]");
+
+	return 0;
+}
+
+static int btf_dump_struct_data(struct btf_dump *d,
+				const struct btf_type *t,
+				__u32 id,
+				const void *data)
+{
+	const struct btf_member *m = btf_members(t);
+	__u16 n = btf_vlen(t);
+	int i, err;
+
+	/* note that we increment depth before calling btf_dump_print() below;
+	 * this is intentional.  btf_dump_data_newline() will not print a
+	 * newline for depth 0 (since this leaves us with trailing newlines
+	 * at the end of typed display), so depth is incremented first.
+	 * For similar reasons, we decrement depth before showing the closing
+	 * parenthesis.
+	 */
+	d->typed_dump->depth++;
+	btf_dump_printf(d, "{%s", btf_dump_data_newline(d));
+
+	for (i = 0; i < n; i++, m++) {
+		const struct btf_type *mtype;
+		const char *mname;
+		__u32 moffset;
+		__u8 bit_sz;
+
+		mtype = btf__type_by_id(d->btf, m->type);
+		mname = btf_name_of(d, m->name_off);
+		moffset = btf_member_bit_offset(t, i);
+
+		bit_sz = btf_member_bitfield_size(t, i);
+		err = btf_dump_dump_type_data(d, mname, mtype, m->type, data + moffset / 8,
+					      moffset % 8, bit_sz);
+		if (err < 0)
+			return err;
+	}
+	d->typed_dump->depth--;
+	btf_dump_data_pfx(d);
+	btf_dump_type_values(d, "}");
+	return err;
+}
+
+static int btf_dump_ptr_data(struct btf_dump *d,
+			      const struct btf_type *t,
+			      __u32 id,
+			      const void *data)
+{
+	btf_dump_type_values(d, "%p", *(void **)data);
+	return 0;
+}
+
+static int btf_dump_get_enum_value(struct btf_dump *d,
+				   const struct btf_type *t,
+				   const void *data,
+				   __u32 id,
+				   __s64 *value)
+{
+	int sz = t->size;
+
+	/* handle unaligned enum value */
+	if (((uintptr_t)data) % sz) {
+		*value = (__s64)btf_dump_bitfield_get_data(d, t, data, 0, 0);
+		return 0;
+	}
+	switch (t->size) {
+	case 8:
+		*value = *(__s64 *)data;
+		return 0;
+	case 4:
+		*value = *(__s32 *)data;
+		return 0;
+	case 2:
+		*value = *(__s16 *)data;
+		return 0;
+	case 1:
+		*value = *(__s8 *)data;
+		return 0;
+	default:
+		pr_warn("unexpected size %d for enum, id:[%u]\n", t->size, id);
+		return -EINVAL;
+	}
+}
+
+static int btf_dump_enum_data(struct btf_dump *d,
+			      const struct btf_type *t,
+			      __u32 id,
+			      const void *data)
+{
+	const struct btf_enum *e;
+	__s64 value;
+	int i, err;
+
+	err = btf_dump_get_enum_value(d, t, data, id, &value);
+	if (err)
+		return err;
+
+	for (i = 0, e = btf_enum(t); i < btf_vlen(t); i++, e++) {
+		if (value != e->val)
+			continue;
+		btf_dump_type_values(d, "%s", btf_name_of(d, e->name_off));
+		return 0;
+	}
+
+	btf_dump_type_values(d, "%d", value);
+	return 0;
+}
+
+static int btf_dump_datasec_data(struct btf_dump *d,
+				 const struct btf_type *t,
+				 __u32 id,
+				 const void *data)
+{
+	const struct btf_var_secinfo *vsi;
+	const struct btf_type *var;
+	__u32 i;
+	int err;
+
+	btf_dump_type_values(d, "SEC(\"%s\") ", btf_name_of(d, t->name_off));
+
+	for (i = 0, vsi = btf_var_secinfos(t); i < btf_vlen(t); i++, vsi++) {
+		var = btf__type_by_id(d->btf, vsi->type);
+		err = btf_dump_dump_type_data(d, NULL, var, vsi->type, data + vsi->offset, 0, 0);
+		if (err < 0)
+			return err;
+		btf_dump_printf(d, ";");
+	}
+	return 0;
+}
+
+/* return size of type, or if base type overflows, return -E2BIG. */
+static int btf_dump_type_data_check_overflow(struct btf_dump *d,
+					     const struct btf_type *t,
+					     __u32 id,
+					     const void *data,
+					     __u8 bits_offset)
+{
+	__s64 size = btf__resolve_size(d->btf, id);
+
+	if (size < 0 || size >= INT_MAX) {
+		pr_warn("unexpected size [%lld] for id [%u]\n",
+			size, id);
+		return -EINVAL;
+	}
+
+	/* Only do overflow checking for base types; we do not want to
+	 * avoid showing part of a struct, union or array, even if we
+	 * do not have enough data to show the full object.  By
+	 * restricting overflow checking to base types we can ensure
+	 * that partial display succeeds, while avoiding overflowing
+	 * and using bogus data for display.
+	 */
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+	if (!t) {
+		pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
+			id);
+		return -EINVAL;
+	}
+
+	switch (btf_kind(t)) {
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+	case BTF_KIND_PTR:
+	case BTF_KIND_ENUM:
+		if (data + bits_offset / 8 + size > d->typed_dump->data_end)
+			return -E2BIG;
+		break;
+	default:
+		break;
+	}
+	return (int)size;
+}
+
+static int btf_dump_type_data_check_zero(struct btf_dump *d,
+					 const struct btf_type *t,
+					 __u32 id,
+					 const void *data,
+					 __u8 bits_offset,
+					 __u8 bit_sz)
+{
+	__s64 value;
+	int i, err;
+
+	/* toplevel exceptions; we show zero values if
+	 * - we ask for them (emit_zeros)
+	 * - if we are at top-level so we see "struct empty { }"
+	 * - or if we are an array member and the array is non-empty and
+	 *   not a char array; we don't want to be in a situation where we
+	 *   have an integer array 0, 1, 0, 1 and only show non-zero values.
+	 *   If the array contains zeroes only, or is a char array starting
+	 *   with a '\0', the array-level check_zero() will prevent showing it;
+	 *   we are concerned with determining zero value at the array member
+	 *   level here.
+	 */
+	if (d->typed_dump->emit_zeroes || d->typed_dump->depth == 0 ||
+	    (d->typed_dump->is_array_member &&
+	     !d->typed_dump->is_array_char))
+		return 0;
+
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+
+	switch (btf_kind(t)) {
+	case BTF_KIND_INT:
+		if (bit_sz)
+			return btf_dump_bitfield_check_zero(d, t, data, bits_offset, bit_sz);
+		return btf_dump_base_type_check_zero(d, t, id, data);
+	case BTF_KIND_FLOAT:
+	case BTF_KIND_PTR:
+		return btf_dump_base_type_check_zero(d, t, id, data);
+	case BTF_KIND_ARRAY: {
+		const struct btf_array *array = btf_array(t);
+		const struct btf_type *elem_type;
+		__u32 elem_type_id, elem_size;
+		bool ischar;
+
+		elem_type_id = array->type;
+		elem_size = btf__resolve_size(d->btf, elem_type_id);
+		elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
+
+		ischar = btf_is_int(elem_type) && elem_size == 1;
+
+		/* check all elements; if _any_ element is nonzero, all
+		 * of array is displayed.  We make an exception however
+		 * for char arrays where the first element is 0; these
+		 * are considered zeroed also, even if later elements are
+		 * non-zero because the string is terminated.
+		 */
+		for (i = 0; i < array->nelems; i++) {
+			if (i == 0 && ischar && *(char *)data == 0)
+				return -ENODATA;
+			err = btf_dump_type_data_check_zero(d, elem_type,
+							    elem_type_id,
+							    data +
+							    (i * elem_size),
+							    bits_offset, 0);
+			if (err != -ENODATA)
+				return err;
+		}
+		return -ENODATA;
+	}
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		const struct btf_member *m = btf_members(t);
+		__u16 n = btf_vlen(t);
+
+		/* if any struct/union member is non-zero, the struct/union
+		 * is considered non-zero and dumped.
+		 */
+		for (i = 0; i < n; i++, m++) {
+			const struct btf_type *mtype;
+			__u32 moffset;
+
+			mtype = btf__type_by_id(d->btf, m->type);
+			moffset = btf_member_bit_offset(t, i);
+
+			/* btf_int_bits() does not store member bitfield size;
+			 * bitfield size needs to be stored here so int display
+			 * of member can retrieve it.
+			 */
+			bit_sz = btf_member_bitfield_size(t, i);
+			err = btf_dump_type_data_check_zero(d, mtype, m->type, data + moffset / 8,
+							    moffset % 8, bit_sz);
+			if (err != ENODATA)
+				return err;
+		}
+		return -ENODATA;
+	}
+	case BTF_KIND_ENUM:
+		if (btf_dump_get_enum_value(d, t, data, id, &value))
+			return 0;
+		if (value == 0)
+			return -ENODATA;
+		return 0;
+	default:
+		return 0;
+	}
+}
+
+/* returns size of data dumped, or error. */
+static int btf_dump_dump_type_data(struct btf_dump *d,
+				   const char *fname,
+				   const struct btf_type *t,
+				   __u32 id,
+				   const void *data,
+				   __u8 bits_offset,
+				   __u8 bit_sz)
+{
+	int size, err;
+
+	size = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
+	if (size < 0)
+		return size;
+	err = btf_dump_type_data_check_zero(d, t, id, data, bits_offset, bit_sz);
+	if (err) {
+		/* zeroed data is expected and not an error, so simply skip
+		 * dumping such data.  Record other errors however.
+		 */
+		if (err == -ENODATA)
+			return size;
+		return err;
+	}
+	btf_dump_data_pfx(d);
+
+	if (!d->typed_dump->skip_names) {
+		if (fname && strlen(fname) > 0)
+			btf_dump_printf(d, ".%s = ", fname);
+		btf_dump_emit_type_cast(d, id, true);
+	}
+
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+
+	switch (btf_kind(t)) {
+	case BTF_KIND_UNKN:
+	case BTF_KIND_FWD:
+	case BTF_KIND_FUNC:
+	case BTF_KIND_FUNC_PROTO:
+		err = btf_dump_unsupported_data(d, t, id);
+		break;
+	case BTF_KIND_INT:
+		if (bit_sz)
+			err = btf_dump_bitfield_data(d, t, data, bits_offset, bit_sz);
+		else
+			err = btf_dump_int_data(d, t, id, data, bits_offset);
+		break;
+	case BTF_KIND_FLOAT:
+		err = btf_dump_float_data(d, t, id, data);
+		break;
+	case BTF_KIND_PTR:
+		err = btf_dump_ptr_data(d, t, id, data);
+		break;
+	case BTF_KIND_ARRAY:
+		err = btf_dump_array_data(d, t, id, data);
+		break;
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		err = btf_dump_struct_data(d, t, id, data);
+		break;
+	case BTF_KIND_ENUM:
+		/* handle bitfield and int enum values */
+		if (bit_sz) {
+			unsigned __int128 print_num;
+			__s64 enum_val;
+
+			print_num = btf_dump_bitfield_get_data(d, t, data, bits_offset, bit_sz);
+			enum_val = (__s64)print_num;
+			err = btf_dump_enum_data(d, t, id, &enum_val);
+		} else
+			err = btf_dump_enum_data(d, t, id, data);
+		break;
+	case BTF_KIND_VAR:
+		err = btf_dump_var_data(d, t, id, data);
+		break;
+	case BTF_KIND_DATASEC:
+		err = btf_dump_datasec_data(d, t, id, data);
+		break;
+	default:
+		pr_warn("unexpected kind [%u] for id [%u]\n",
+			BTF_INFO_KIND(t->info), id);
+		return -EINVAL;
+	}
+	if (err < 0)
+		return err;
+	return size;
+}
+
+int btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
+			     const void *data, size_t data_sz,
+			     const struct btf_dump_type_data_opts *opts)
+{
+	const struct btf_type *t;
+	int ret;
+
+	if (!OPTS_VALID(opts, btf_dump_type_data_opts))
+		return libbpf_err(-EINVAL);
+
+	t = btf__type_by_id(d->btf, id);
+	if (!t)
+		return libbpf_err(-ENOENT);
+
+	d->typed_dump = calloc(1, sizeof(struct btf_dump_data));
+	if (!d->typed_dump)
+		return libbpf_err(-ENOMEM);
+
+	d->typed_dump->data_end = data + data_sz;
+	d->typed_dump->indent_lvl = OPTS_GET(opts, indent_level, 0);
+	/* default indent string is a tab */
+	if (!opts->indent_str)
+		d->typed_dump->indent_str[0] = '\t';
+	else
+		strncat(d->typed_dump->indent_str, opts->indent_str,
+			sizeof(d->typed_dump->indent_str) - 1);
+
+	d->typed_dump->compact = OPTS_GET(opts, compact, false);
+	d->typed_dump->skip_names = OPTS_GET(opts, skip_names, false);
+	d->typed_dump->emit_zeroes = OPTS_GET(opts, emit_zeroes, false);
+
+	ret = btf_dump_dump_type_data(d, NULL, t, id, data, 0, 0);
+
+	free(d->typed_dump);
+
+	return libbpf_err(ret);
+}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 944c99d..5bfc107 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -373,5 +373,6 @@ LIBBPF_0.5.0 {
 		bpf_map__initial_value;
 		bpf_map_lookup_and_delete_elem_flags;
 		bpf_object__gen_loader;
+		btf_dump__dump_type_data;
 		libbpf_set_strict_mode;
 } LIBBPF_0.4.0;
-- 
1.8.3.1

