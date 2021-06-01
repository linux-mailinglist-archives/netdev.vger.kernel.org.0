Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0925639759A
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhFAOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:39:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20244 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234191AbhFAOjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:39:13 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151EaDE6020449;
        Tue, 1 Jun 2021 14:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Xp3jW8R4NyJzTIaciHJhMKEs83QVIUm8NjRAHPh7kSk=;
 b=aoD6ld26q3QSg9xd+5ZRM7fM9B3ACJw40rHmLhKJ6FYCsCZzefKU6Hysr59DL6Pwc8wO
 zKO/95tqmF2ZJUgFNPNrBBg3VNzYKNfVv5/2xgadRTDz60RH19zdrVZa5akEjA4GY31i
 FUkEtVex2bK8AzOMzSyUasH4Rszn2a8e1hFtkulvZKdKSVg7U32gqQaIs7ggSOdyc9k8
 RM6GooEgpjieRebYs7Hu9XxWIIQC4F19+Iyp4VzfuofV+ThHN6aQNDHGASfKF7VrtP/u
 Wcxh+1SThZZWn4vegb95PLFqMD1diD06b9S84InTs70O5y1GFgnjI5MevgsoRFn7E/U3 2w== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38vmrgrmcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:37:12 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 151Ea4oS171823;
        Tue, 1 Jun 2021 14:37:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by aserp3020.oracle.com with ESMTP id 38ude932vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 14:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2+YzEeEO3jCVrvqv1BeXI+Ehe1IBwVDzAsHfaJU3rnSHudxQBie9IFdWEJ+gfyudkJEMKdm4ofR6637Y9kdxQvmUr5m8LnEaueNPXK+m6zzo2dSonFaj4N2kpOuGA08yziD/8+S3lB+++FRmw5CPgm/63Kdcv9i/+V1ZYHWmQstCDzEIl3x72iu29cUW5+ZKFDpjJpvQNi7aN1z+GTuMnuHp+hxyPRDa+d6JNymjiVAuvHkZF0nkupSo8x34v9f87Rkb2d3JjCABqbagEJqdkjJRg2yR/vQ/ZQvtHygfftj24/GZWD5WA/rPqn6lv8NrinXCREEdc7OHXj8ceoclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xp3jW8R4NyJzTIaciHJhMKEs83QVIUm8NjRAHPh7kSk=;
 b=isNYcXX01LOnm46GYbqr8HRtILysvCw2FCUeD9wy1WWQLp5k93/pe6UV7Gwp4KFnDbWgwG2xxtnl6wAgxA8YHzesn3mz424obBRCBtMjFL4aFMqaXYzOcG92fm6272vp3tNNVSLVfr95RD2Lu5cfVE1l9AKCAq9SH/KrbmIL8s4gWwo6NaKbAF7JOg2ZxsWWYDjHd2JN5Ad7ZqeWZJhVa9RATEo+btI8Ws+rLG/lYp7fqtWgevabttjVX5msqiU3V8sYMQxHjES4ciB8q/Pl//T0/mWwgGnm6urCDbyaDA52AMfTLc1RO8tyg/Zm8z5mKAPHYjfCBuSGQ+km6iyGvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xp3jW8R4NyJzTIaciHJhMKEs83QVIUm8NjRAHPh7kSk=;
 b=INfQv44zieH65gNHtRub3JBaWUfQL272WU9+KV/lN3A6kztkpD1ratBbN/J9bbvs9apPNdL0g/nfFPi3Y0UzVb4a9aERmNVW8wsyrrwo2nzA6fecX8nW5/dhloz5Ln2dFMjqJcjBVt3b065mt45Ip6hoIjitBlRhSLXUWceFnM4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5283.namprd10.prod.outlook.com (2603:10b6:208:325::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 14:37:09 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::9da7:f131:1f41:657c%4]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 14:37:09 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 1/2] libbpf: BTF dumper support for typed data
Date:   Tue,  1 Jun 2021 15:36:59 +0100
Message-Id: <1622558220-2849-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622558220-2849-1-git-send-email-alan.maguire@oracle.com>
References: <1622558220-2849-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-Originating-IP: [95.45.14.174]
X-ClientProxiedBy: LO2P265CA0461.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::17) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by LO2P265CA0461.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 14:37:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65c1ca5e-6e85-4aa2-8680-08d9250abc33
X-MS-TrafficTypeDiagnostic: BLAPR10MB5283:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5283B9C85D3246CEF4453D15EF3E9@BLAPR10MB5283.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ybydm5BSPnPhX9X5ORCXUx1p8v+18ZQAGpoOOPLW916vWRYzIdk/K/RaYpv1DFUkgz5d0HvFJ5Nh/at7TPImbOIjf2TXVmRJ5KsHfxoYmMzW8KN+uMV6a13AMbDwVC5FqXP2VL2sVY0oWnPKqW+U1q/IshoBMIrX8Zh6YJm8ElqlZkufgQwU59DR/FPlvXGLkxGn+0aELzKlU4Cguhv3Zuzh3911xV3mkFOyH96ugtpcxy7bEI+d6JrUfZYEgvNRqMvH+s0f846j3TliHda76DA2R9yq534639WuU7D+XXdmYvu/gyuWw9eGEnQOhU5V/BM1I0e1JB1Rxmz6ZzVNwXyyPJeANcHE9CaHhTWdhQvE4NxennwRe1of+wCVRJ0p2RZPzo5MXX9xE6ZmiEdhZMFnQC4cYftzWOiGLY8RMGSYXbOgHHv5lbT16ciA1EkrZLlR1pxGTxJge1D7ceybuR+ajDpRO9YZnT/vpigmp1/9ktjnhOw//Ow9jzEsrACMwnzHx0XLc3wFmPP/rU7IekLi8EFGNqkSOGMUK2G3woF1d4qAh+P7SND8Ty73DCFmEaRvlM1BFhFds0nrkX01dhOUG6AT59Lz1s6HEk0Swce5WvZ1oBeLrFQB6hQJBYQM9Q6JZZ2GCBM9Xl5upWcEtIipKK/LHHAEzbPJznnX2dk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(366004)(376002)(6666004)(38100700002)(38350700002)(956004)(6486002)(7416002)(83380400001)(186003)(86362001)(16526019)(316002)(8936002)(2616005)(8676002)(66946007)(5660300002)(7696005)(52116002)(66556008)(4326008)(26005)(36756003)(2906002)(30864003)(66476007)(478600001)(107886003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1tHJzeMcGxcKNQf92kdkVwgfkk4UGZk7V/R1l3xxUXbEmlkmptR91xG9T1DO?=
 =?us-ascii?Q?s7yTFpykmeUCOhOmxSwu5tP9i+jJbCayKoU8NVM5/E7W6P8PtthdA+ifZDB5?=
 =?us-ascii?Q?MofZNsPy6g7q7NX0zRGfY6TgglbrgIeLhCFXTQeQswY5xwqjTkvcPbmvFe2w?=
 =?us-ascii?Q?tMJ66l2Lcxz2l8mNP61Qt84Xw1DzA07NEe52ox4B4cxuzZdQfOYN1JNwRpk1?=
 =?us-ascii?Q?smhsuy+TmbFEycVPDOMPeWuaPXWEc6k7fzH1tSnwL7j2uraPu5uiE1lc8gMQ?=
 =?us-ascii?Q?dJTjAO0mf68pkDlN8h/vLmRwzU0/5Y2CApoW/GJPjBeOvW4LxnkGDfhfZn2v?=
 =?us-ascii?Q?JzmOFqKxXoWqDahAKIZq+8lpaNZ2T76nD+5p+cRJqNRdGfZ33Q2qTMG+fRWy?=
 =?us-ascii?Q?AhuUQ6saqZbngWcuUMA6Yz06ZzVY2+s0yhuhx+r7l/qhnuSQBZvvkZY1S87H?=
 =?us-ascii?Q?wRMtm1uwHMXdJkzK5haRSsa2mpzp4JyvVYAq2jDXkHSlTiKFu6yh+RKueedL?=
 =?us-ascii?Q?Ma4RB8Z60QEsh6xqiv+FYD1OQctQIBvTdfAGD/3KYShQ4VNFbqOUuBX9Vtjw?=
 =?us-ascii?Q?H+OO6cVPL8ebAKqwDd+YnCh6C3/RxdKELkHViTLzIqw+GwZDtYHGqoBym8BW?=
 =?us-ascii?Q?mYyTXbdDljC3R8u5UeO3uJQuaMkcfR04Qr3Qy5o40ts+zqmxChl8+7bXoUW9?=
 =?us-ascii?Q?hvzeEtZxw/G4vQv+stxmv7yB5YaauvIvlBMQH7W8O95bkgyjw3NxHBEo5Wxg?=
 =?us-ascii?Q?7bSFfTJVRn4Zqj0VYuqYyALifAzxlwD3uRuf7Hwi37Zi5aO+MUKWP8W8oY/h?=
 =?us-ascii?Q?m3MgMaEb/4EMMtmFTDkoSsFxiVTRLm/vc4jf4Kse9QeNZkkMqSS/fd6lRI2L?=
 =?us-ascii?Q?dbRx0NYSNR4fjEAFqIBBZwt1Zesy/Iz9fSsjYTcDS3FGXpt76qznHJJ73N/T?=
 =?us-ascii?Q?0Yo2eubDeffqUBOcCibS+JTIyk5/MvLnM13RD2paW7Ui7zhY9EaFYPMIXnCu?=
 =?us-ascii?Q?kMd2qdiJxFvQCNQEZv4fp1o5qjzM9tNHeFY4zgkXuYCzxtURDf3EavFI4rZE?=
 =?us-ascii?Q?XyUOKwwzi2LMwCe3ajhzA7yeA8iou1HzfXd9SPHcf+Iff0ddKVgLroDT53qg?=
 =?us-ascii?Q?GPcX7VPaH+zNYKFH/rlSeeSv83Q/qptkoi3wry0wnZyaQzPYFsVkurhbviWl?=
 =?us-ascii?Q?rAGJilZH9h2teOyzsgq/qlKBmET6+KcCPixjQXsXva3QS7u9Sn9ov2RnRqk2?=
 =?us-ascii?Q?Ox0u8RaSSNmA6dp0hC66zJZWQQvQUyh9M0Nnh/x55f7czG/eq9kQyOxXdcRz?=
 =?us-ascii?Q?q7H/GD8EF2gZ25at26Q5UU53?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c1ca5e-6e85-4aa2-8680-08d9250abc33
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 14:37:08.9459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gNm3h+D0FiEQT1C6JbezWzGFDZ9OV4XAPyxzMerTozJzQ5M0mC6B5A9pFDKVVEyb221u+BaFQTaT6Fh0pZ72g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5283
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010099
X-Proofpoint-GUID: 7bpY8AcrNXQ7JcVLfokGZMEn4oz6yIBn
X-Proofpoint-ORIG-GUID: 7bpY8AcrNXQ7JcVLfokGZMEn4oz6yIBn
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
   indent level; by default tab is chosen but any string <= 4 chars
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
 tools/lib/bpf/btf.h      |   22 +
 tools/lib/bpf/btf_dump.c | 1008 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.map |    1 +
 3 files changed, 1029 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index b54f1c3..10470e0 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -184,6 +184,28 @@ struct btf_dump_emit_type_decl_opts {
 btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 			 const struct btf_dump_emit_type_decl_opts *opts);
 
+
+/* indent string length; one indent string is added for each indent level */
+#define BTF_DATA_INDENT_STR_LEN			4
+
+struct btf_dump_type_data_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	int indent_level;
+	char indent_str[BTF_DATA_INDENT_STR_LEN + 1];
+	/* below match "show" flags for bpf_show_snprintf() */
+	bool compact;		/* no newlines/tabs */
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
index 5dc6b517..b1b356a 100644
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
@@ -19,6 +21,12 @@
 #include "libbpf.h"
 #include "libbpf_internal.h"
 
+#define BITS_PER_U128			128
+#define BITS_PER_BYTE_MASK		(8 - 1)
+#define BITS_PER_BYTE_MASKED(bits)	((bits) & BITS_PER_BYTE_MASK)
+#define BITS_ROUNDDOWN_BYTES(bits)	((bits) / 8)
+#define BITS_ROUNDUP_BYTES(bits)	(roundup(bits, 8))
+
 static const char PREFIXES[] = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
 static const size_t PREFIX_CNT = sizeof(PREFIXES) - 1;
 
@@ -53,6 +61,26 @@ struct btf_dump_type_aux_state {
 	__u8 referenced: 1;
 };
 
+/*
+ * Common internal data for BTF type data dump operations.
+ */
+struct btf_dump_data {
+	const void *data_end;		/* end of valid data to show */
+	bool compact;
+	bool skip_names;
+	bool emit_zeroes;
+	__u8 indent_lvl;	/* base indent level */
+	char indent_str[BTF_DATA_INDENT_STR_LEN + 1];
+	/* below are used during iteration */
+	struct {
+		__u8 depth;
+		__u8 array_member:1,
+		     array_terminated:1,
+		     array_ischar:1;
+		__u32 bitfield_size;
+	} state;
+};
+
 struct btf_dump {
 	const struct btf *btf;
 	const struct btf_ext *btf_ext;
@@ -89,6 +117,10 @@ struct btf_dump {
 	 * name occurrences
 	 */
 	struct hashmap *ident_names;
+	/*
+	 * data for typed display; allocated if needed.
+	 */
+	struct btf_dump_data *data;
 };
 
 static size_t str_hash_fn(const void *key, void *ctx)
@@ -765,11 +797,11 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
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
@@ -1392,6 +1424,112 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 	btf_dump_emit_name(d, fname, last_was_ptr);
 }
 
+/* show type name as (type_name) */
+static void btf_dump_emit_type_name(struct btf_dump *d, __u32 id,
+				    int lvl, bool toplevel)
+{
+
+	const struct btf_type *t, *child;
+	const char *name;
+	__u16 kind;
+
+	/* for array members, we don't bother emitting type name for each
+	 * member to avoid the redundancy of
+	 * .name = (char[])[(char)'f',(char)'o',(char)'o',]
+	 */
+	if (d->data->state.array_member)
+		return;
+
+	t = btf__type_by_id(d->btf, id);
+	kind = btf_kind(t);
+
+	/* avoid type name specification for variable/section; it will be done
+	 * for the associated variable value(s).
+	 */
+	switch (kind) {
+	case BTF_KIND_VAR:
+	case BTF_KIND_DATASEC:
+		return;
+	default:
+		break;
+	}
+
+	if (toplevel)
+		btf_dump_printf(d, "(");
+
+	if (id == 0) {
+		btf_dump_printf(d, "void");
+		goto done;
+	}
+
+	switch (kind) {
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+		name = btf_name_of(d, t->name_off);
+		btf_dump_printf(d, "%s", name);
+		break;
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		name = btf_dump_type_name(d, id);
+		btf_dump_printf(d, "%s%s%s",
+				btf_is_struct(t) ? "struct" : "union",
+				strlen(name) > 0 ? " " : "",
+				name);
+		break;
+	case BTF_KIND_ENUM:
+		btf_dump_emit_enum_fwd(d, id, t);
+		break;
+	case BTF_KIND_TYPEDEF:
+		btf_dump_printf(d, "%s", btf_dump_ident_name(d, id));
+		break;
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_CONST:
+	case BTF_KIND_RESTRICT:
+		/* modifiers are omitted from the cast to save space */
+		btf_dump_emit_type_name(d, t->type, lvl, false);
+		break;
+	case BTF_KIND_PTR:
+		btf_dump_emit_type_name(d, t->type, lvl, false);
+		child = btf__type_by_id(d->btf, t->type);
+		/* no need for '*' suffix for function prototype */
+		if (btf_kind(child) == BTF_KIND_FUNC_PROTO)
+			break;
+		btf_dump_printf(d,
+				btf_kind(child) == BTF_KIND_PTR ? "*" : " *");
+		break;
+	case BTF_KIND_ARRAY: {
+		const struct btf_array *a = btf_array(t);
+
+		btf_dump_emit_type_name(d, a->type, lvl, false);
+		btf_dump_printf(d, "[]");
+		break;
+	}
+	case BTF_KIND_FUNC_PROTO: {
+		const struct btf_param *p = btf_params(t);
+		__u16 n = btf_vlen(t);
+		int i;
+
+		btf_dump_emit_type_name(d, t->type, 0, false);
+		btf_dump_printf(d, "(*)(");
+
+		for (i = 0; i < n; i++, p++) {
+			if (i > 0)
+				btf_dump_printf(d, ", ");
+			btf_dump_emit_type_name(d, p->type, 0, false);
+		}
+		btf_dump_printf(d, ")");
+		break;
+	}
+	default:
+		pr_warn("unexpected type when emitting type name, kind %u, id:[%u]\n",
+			kind, id);
+		break;
+	}
+done:
+	if (toplevel)
+		btf_dump_printf(d, ")");
+}
+
 /* return number of duplicates (occurrences) of a given name */
 static size_t btf_dump_name_dups(struct btf_dump *d, struct hashmap *name_map,
 				 const char *orig_name)
@@ -1442,3 +1580,869 @@ static const char *btf_dump_ident_name(struct btf_dump *d, __u32 id)
 {
 	return btf_dump_resolve_name(d, id, d->ident_names);
 }
+
+static int btf_dump_dump_type_data(struct btf_dump *d,
+				   const char *fname,
+				   const struct btf_type *t,
+				   __u32 id,
+				   const void *data,
+				   __u8 bits_offset);
+
+static const char *btf_dump_data_newline(struct btf_dump *d)
+{
+	return d->data->compact ? "" : "\n";
+}
+
+static const char *btf_dump_data_delim(struct btf_dump *d)
+{
+	return d->data->state.depth == 0 ? "" : ",";
+}
+
+static void btf_dump_data_pfx(struct btf_dump *d)
+{
+	int i, lvl = d->data->indent_lvl + d->data->state.depth;
+
+	if (d->data->compact)
+		lvl = 0;
+
+	for (i = 0; i < lvl; i++)
+		btf_dump_printf(d, "%s", d->data->indent_str);
+}
+
+/* A macro is used here as btf_type_value[s]() appends format specifiers
+ * to the format specifier passed in; these do the work of appending
+ * delimiters etc while the caller simply has to specify the type values
+ * in the format specifier + value(s).
+ */
+#define btf_dump_type_values(d, fmt, ...)				\
+	btf_dump_printf(d, fmt "%s%s",					\
+			__VA_ARGS__,					\
+			btf_dump_data_delim(d),				\
+			btf_dump_data_newline(d))
+
+static int btf_dump_unsupported_data(struct btf_dump *d,
+				     const struct btf_type *t,
+				     __u32 id,
+				     const void *data)
+{
+	btf_dump_printf(d, "<unsupported kind:%u>",
+			BTF_INFO_KIND(t->info));
+	return -ENOTSUP;
+}
+
+static void btf_dump_int128(struct btf_dump *d,
+			    const struct btf_type *t,
+			    const void *data)
+{
+	/* data points to a __int128 number.
+	 * Suppose
+	 *	int128_num = *(__int128 *)data;
+	 * The below formulas shows what upper_num and lower_num represents:
+	 *     upper_num = int128_num >> 64;
+	 *     lower_num = int128_num & 0xffffffffFFFFFFFFULL;
+	 */
+	__u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = *(__u64 *)data;
+	lower_num = *(__u64 *)(data + 8);
+#else
+	upper_num = *(__u64 *)(data + 8);
+	lower_num = *(__u64 *)data;
+#endif
+	if (upper_num == 0)
+		btf_dump_type_values(d, "0x%llx", (long long)lower_num);
+	else
+		btf_dump_type_values(d, "0x%llx%016llx", (long long)upper_num,
+				     (long long)lower_num);
+}
+
+static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
+			     __u16 right_shift_bits)
+{
+	__u64 upper_num, lower_num;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	upper_num = print_num[0];
+	lower_num = print_num[1];
+#else
+	upper_num = print_num[1];
+	lower_num = print_num[0];
+#endif
+
+	/* shake out un-needed bits by shift/or operations */
+	if (left_shift_bits >= 64) {
+		upper_num = lower_num << (left_shift_bits - 64);
+		lower_num = 0;
+	} else {
+		upper_num = (upper_num << left_shift_bits) |
+			    (lower_num >> (64 - left_shift_bits));
+		lower_num = lower_num << left_shift_bits;
+	}
+
+	if (right_shift_bits >= 64) {
+		lower_num = upper_num >> (right_shift_bits - 64);
+		upper_num = 0;
+	} else {
+		lower_num = (lower_num >> right_shift_bits) |
+			    (upper_num << (64 - right_shift_bits));
+		upper_num = upper_num >> right_shift_bits;
+	}
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	print_num[0] = upper_num;
+	print_num[1] = lower_num;
+#else
+	print_num[0] = lower_num;
+	print_num[1] = upper_num;
+#endif
+}
+
+static int btf_dump_bitfield_get_data(struct btf_dump *d,
+				      const void *data,
+				      __u8 bits_offset,
+				      __u8 nr_bits,
+				      __u64 *print_num)
+{
+	__u16 left_shift_bits, right_shift_bits;
+	__u8 nr_copy_bytes;
+	__u8 nr_copy_bits;
+
+	nr_copy_bits = nr_bits + bits_offset;
+	nr_copy_bytes = BITS_ROUNDUP_BYTES(nr_copy_bits);
+
+	memcpy(print_num, data, nr_copy_bytes);
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	left_shift_bits = bits_offset;
+#else
+	left_shift_bits = BITS_PER_U128 - nr_copy_bits;
+#endif
+	right_shift_bits = BITS_PER_U128 - nr_bits;
+
+	btf_int128_shift(print_num, left_shift_bits, right_shift_bits);
+
+	return 0;
+}
+
+static int btf_dump_bitfield_data(struct btf_dump *d,
+				  const struct btf_type *t,
+				  const void *data,
+				  __u8 bits_offset,
+				  __u8 nr_bits)
+{
+	__u64 print_num[2];
+
+	btf_dump_bitfield_get_data(d, data, bits_offset, nr_bits, print_num);
+	btf_dump_int128(d, t, print_num);
+
+	return 0;
+}
+
+static int btf_dump_int_bits(struct btf_dump *d,
+			     const struct btf_type *t,
+			     const void *data,
+			     __u8 bits_offset)
+{
+	__u8 nr_bits = d->data->state.bitfield_size ?: btf_int_bits(t);
+
+	data += BITS_ROUNDDOWN_BYTES(bits_offset);
+	return btf_dump_bitfield_data(d, t, data, bits_offset, nr_bits);
+}
+
+static int btf_dump_int_bits_check_zero(struct btf_dump *d,
+					const struct btf_type *t,
+					const void *data,
+					__u8 bits_offset)
+{
+	__u64 print_num[2], zero[2] = { };
+	__u8 nr_bits = d->data->state.bitfield_size ?: btf_int_bits(t);
+
+	data += BITS_ROUNDDOWN_BYTES(bits_offset);
+	btf_dump_bitfield_get_data(d, data, bits_offset, nr_bits,
+				   (__u64 *)&print_num);
+	if (memcmp(print_num, zero, sizeof(zero)) == 0)
+		return -ENODATA;
+	return 0;
+}
+
+static int btf_dump_int_check_zero(struct btf_dump *d,
+				const struct btf_type *t,
+				const void *data,
+				__u8 bits_offset)
+{
+	__u8 nr_bits = btf_int_bits(t);
+	bool zero = false;
+
+	if (bits_offset || BITS_PER_BYTE_MASKED(nr_bits))
+		return btf_dump_int_bits_check_zero(d, t, data, bits_offset);
+
+	switch (nr_bits) {
+	case 128:
+		zero = *(__int128 *)data == 0;
+		break;
+	case 64:
+		zero = *(__s64 *)data == 0;
+		break;
+	case 32:
+		zero = *(__s32 *)data == 0;
+		break;
+	case 16:
+		zero = *(__s16 *)data == 0;
+		break;
+	case 8:
+		zero = *(__s8 *)data == 0;
+		break;
+	default:
+		break;
+	}
+	if (zero)
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
+	__u8 nr_bits = btf_int_bits(t);
+
+	if (bits_offset || BITS_PER_BYTE_MASKED(nr_bits))
+		return btf_dump_int_bits(d, t, data, bits_offset);
+
+	switch (nr_bits) {
+	case 128:
+		btf_dump_int128(d, t, data);
+		break;
+	case 64:
+		if (sign)
+			btf_dump_type_values(d, "%lld", *(long long *)data);
+		else
+			btf_dump_type_values(d, "%llu",
+					     *(unsigned long long *)data);
+		break;
+	case 32:
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s32 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u32 *)data);
+		break;
+	case 16:
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s16 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u16 *)data);
+		break;
+	case 8:
+		if (d->data->state.array_ischar) {
+			/* check for null terminator */
+			if (d->data->state.array_terminated)
+				break;
+			if (*(char *)data == '\0') {
+				d->data->state.array_terminated = 1;
+				break;
+			}
+			if (isprint(*(char *)data)) {
+				btf_dump_type_values(d, "'%c'",
+						     *(char *)data);
+				break;
+			}
+		}
+		if (sign)
+			btf_dump_type_values(d, "%d", *(__s8 *)data);
+		else
+			btf_dump_type_values(d, "%u", *(__u8 *)data);
+		break;
+	default:
+		pr_warn("unexpected nr_bits %d for id [%u]\n",
+			nr_bits, type_id);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int btf_dump_float_check_zero(struct btf_dump *d,
+				     const struct btf_type *t,
+				     const void *data)
+{
+	__u8 bytecmp[16] = { 0 };
+	int nr_bytes = t->size;
+
+	if (nr_bytes > 16 || nr_bytes < 2) {
+		pr_warn("unexpected size %d for float\n", nr_bytes);
+		return -EINVAL;
+	}
+	if (memcmp(data,  bytecmp, nr_bytes) == 0)
+		return -ENOMSG;
+
+	return 0;
+}
+
+static int btf_dump_float_data(struct btf_dump *d,
+			       const struct btf_type *t,
+			       __u32 type_id,
+			       const void *data,
+			       __u8 bits_offset)
+{
+	int nr_bytes = t->size;
+
+	fprintf(stderr, "printing float size %d\n", nr_bytes);
+	switch (nr_bytes) {
+	case 16:
+		btf_dump_type_values(d, "%Lf", *(long double *)data);
+		break;
+	case 8:
+		btf_dump_type_values(d, "%f", *(double *)data);
+		break;
+	case 4:
+		btf_dump_type_values(d, "%f", *(float *)data);
+		break;
+	case 12:
+	case 2:
+		/* although 2 and 12 are valid BTF_KIND_FLOAT sizes,
+		 * display is not supported yet.
+		 */
+		pr_warn("unsupported size %d for id [%u]\n",
+			nr_bytes, type_id);
+		return -ENOTSUP;
+	default:
+		pr_warn("unexpected size %d for id [%u]\n",
+			nr_bytes, type_id);
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
+	const char *l = "";
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
+		break;
+	}
+
+	/* format of output here is [linkage] [type] [varname] = (type)value,
+	 * for example "static int cpu_profile_flip = (int)1"
+	 */
+	btf_dump_printf(d, "%s", l);
+	type_id = v->type;
+	t = btf__type_by_id(d->btf, type_id);
+	btf_dump_emit_type_name(d, type_id, 0, false);
+	btf_dump_printf(d, " %s = ", btf_name_of(d, v->name_off));
+	return btf_dump_dump_type_data(d, NULL,
+				       t, type_id, data, 0);
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
+	int array_member;
+
+	elem_type_id = array->type;
+	elem_type = skip_mods_and_typedefs(d->btf, elem_type_id, NULL);
+	elem_size = btf__resolve_size(d->btf, elem_type_id);
+	if (elem_size <= 0) {
+		pr_warn("unexpected elem size %d for array type [%u]\n",
+			elem_size, id);
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
+			d->data->state.array_ischar = true;
+	}
+
+	btf_dump_printf(d, "[%s", btf_dump_data_newline(d));
+	d->data->state.depth++;
+
+	/* may be a multidimensional array, so store current "is array member"
+	 * status so we can restore it correctly later.
+	 */
+	array_member = d->data->state.array_member;
+	d->data->state.array_member = 1;
+	for (i = 0; i < array->nelems && !d->data->state.array_terminated; i++) {
+
+		btf_dump_dump_type_data(d, NULL, elem_type, elem_type_id,
+					  data, 0);
+		data += elem_size;
+	}
+	d->data->state.array_member = array_member;
+	d->data->state.depth--;
+	btf_dump_data_pfx(d);
+	btf_dump_printf(d, "]%s%s",
+			btf_dump_data_delim(d),
+			btf_dump_data_newline(d));
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
+	btf_dump_printf(d, "{%s",
+			btf_dump_data_newline(d));
+	d->data->state.depth++;
+	for (i = 0; i < n; i++, m++) {
+		const struct btf_type *mtype;
+		__u32 bytes_offset, moffset;
+		const char *mname;
+		__u8 bits8_offset;
+
+		mtype = btf__type_by_id(d->btf, m->type);
+		mname = btf_name_of(d, m->name_off);
+		moffset = btf_member_bit_offset(t, i);
+		bytes_offset = BITS_ROUNDDOWN_BYTES(moffset);
+		bits8_offset = BITS_PER_BYTE_MASKED(moffset);
+
+		/* btf_int_bits() does not store member bitfield size;
+		 * bitfield size needs to be stored here so int display
+		 * of member can retrieve it.
+		 */
+		d->data->state.bitfield_size =
+			btf_member_bitfield_size(t, i);
+		err = btf_dump_dump_type_data(d,
+					      mname,
+					      mtype,
+					      m->type,
+					      data + bytes_offset,
+					      bits8_offset);
+		d->data->state.bitfield_size = 0;
+		if (err < 0)
+			return err;
+	}
+	d->data->state.depth--;
+	btf_dump_data_pfx(d);
+	btf_dump_printf(d, "}%s%s",
+			btf_dump_data_delim(d),
+			btf_dump_data_newline(d));
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
+static int btf_dump_get_enum_value(const struct btf_type *t,
+				   const void *data,
+				   __u32 id,
+				   __s64 *value)
+{
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
+	default:
+		pr_warn("unexpected size %d for enum, id:[%u]\n",
+			t->size, id);
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
+	err = btf_dump_get_enum_value(t, data, id, &value);
+	if (err)
+		return err;
+
+	for (i = 0, e = btf_enum(t); i < btf_vlen(t); i++, e++) {
+		if (value != e->val)
+			continue;
+		btf_dump_type_values(d, "%s",
+				     btf_name_of(d, e->name_off));
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
+	btf_dump_type_values(d, "SEC(\"%s\") ",
+			     btf_name_of(d, t->name_off));
+	for (i = 0, vsi = btf_var_secinfos(t);
+	     i < btf_vlen(t);
+	     i++, vsi++) {
+		var = btf__type_by_id(d->btf, vsi->type);
+		err = btf_dump_dump_type_data(d, NULL, var,
+					      vsi->type,
+					      data + vsi->offset,
+					      0);
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
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_INT:
+	case BTF_KIND_PTR:
+	case BTF_KIND_ENUM:
+		if (data + (bits_offset/8) + size > d->data->data_end)
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
+					 __u8 bits_offset)
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
+	if (d->data->emit_zeroes || d->data->state.depth == 0 ||
+	    (d->data->state.array_member && !d->data->state.array_ischar))
+		return 0;
+
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+	if (!t) {
+		pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
+			id);
+		return -EINVAL;
+	}
+
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_INT:
+		if (d->data->state.bitfield_size)
+			return btf_dump_int_bits_check_zero(d, t, data,
+							    bits_offset);
+		return btf_dump_int_check_zero(d, t, data, bits_offset);
+	case BTF_KIND_FLOAT:
+		return btf_dump_float_check_zero(d, t, data);
+	case BTF_KIND_PTR:
+		if (*((void **)data) == NULL)
+			return -ENODATA;
+		return 0;
+	case BTF_KIND_ARRAY: {
+		const struct btf_array *array = btf_array(t);
+		const struct btf_type *elem_type;
+		__u32 elem_type_id, elem_size;
+		bool ischar;
+
+		elem_type_id = array->type;
+		elem_size = btf__resolve_size(d->btf, elem_type_id);
+		elem_type =  btf__type_by_id(d->btf, elem_type_id);
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
+							    bits_offset);
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
+			__u32 bytes_offset, moffset;
+			__u8 bits8_offset;
+
+			mtype = btf__type_by_id(d->btf, m->type);
+			moffset = btf_member_bit_offset(t, i);
+			bytes_offset = BITS_ROUNDDOWN_BYTES(moffset);
+			bits8_offset = BITS_PER_BYTE_MASKED(moffset);
+
+			/* btf_int_bits() does not store member bitfield size;
+			 * bitfield size needs to be stored here so int display
+			 * of member can retrieve it.
+			 */
+			d->data->state.bitfield_size =
+				btf_member_bitfield_size(t, i);
+
+			err = btf_dump_type_data_check_zero(d, mtype,
+							    m->type,
+							    data + bytes_offset,
+							    bits8_offset);
+			d->data->state.bitfield_size = 0;
+			if (err != ENODATA)
+				return err;
+		}
+		return -ENODATA;
+	}
+	case BTF_KIND_ENUM:
+		if (btf_dump_get_enum_value(t, data, id, &value))
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
+				   __u8 bits_offset)
+{
+	int size, err;
+
+	size = btf_dump_type_data_check_overflow(d, t, id, data, bits_offset);
+	if (size < 0)
+		return size;
+	err = btf_dump_type_data_check_zero(d, t, id, data, bits_offset);
+	if (err) {
+		/* zeroed data is expected and not an error, so simply skip
+		 * dumping such data.  Record other errors however.
+		 */
+		if (err == -ENODATA)
+			return size;
+		return err;
+	}
+	btf_dump_data_pfx(d);
+	if (!d->data->skip_names) {
+		if (fname && strlen(fname) > 0)
+			btf_dump_printf(d, ".%s = ", fname);
+		btf_dump_emit_type_name(d, id, 0, true);
+	}
+
+	t = skip_mods_and_typedefs(d->btf, id, NULL);
+	if (!t) {
+		pr_warn("unexpected error skipping mods/typedefs for id [%u]\n",
+			id);
+		return -EINVAL;
+	}
+
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_UNKN:
+	case BTF_KIND_FWD:
+	case BTF_KIND_FUNC:
+	case BTF_KIND_FUNC_PROTO:
+		err = btf_dump_unsupported_data(d, t, id, data);
+		break;
+	case BTF_KIND_INT:
+		if (d->data->state.bitfield_size)
+			err = btf_dump_bitfield_data(d, t, data,
+						     bits_offset,
+						     d->data->state.bitfield_size);
+		else
+			err = btf_dump_int_data(d, t, id, data, bits_offset);
+		break;
+	case BTF_KIND_FLOAT:
+		err = btf_dump_float_data(d, t, id, data, bits_offset);
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
+		if (d->data->state.bitfield_size) {
+			__u64 print_num[2], upper_num;
+			__s64 enum_val;
+
+			err = btf_dump_bitfield_get_data(d, data, bits_offset,
+							 d->data->state.bitfield_size,
+							 print_num);
+			if (err)
+				break;
+#ifdef __BIG_ENDIAN_BITFIELD
+			upper_num = print_num[0];
+			enum_val = (__s64)print_num[1];
+#else
+			upper_num = print_num[1];
+			enum_val = (__s64)print_num[0];
+#endif
+			if (upper_num != 0) {
+				pr_warn("enum value too big for id [%u]\n", id);
+				err = -EINVAL;
+				break;
+			}
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
+	d->data = calloc(1, sizeof(struct btf_dump_data));
+	if (!d->data)
+		return libbpf_err(-ENOMEM);
+
+	d->data->data_end = data + data_sz;
+	d->data->indent_lvl = OPTS_GET(opts, indent_level, 0);
+	/* default indent string is a tab */
+	if (strlen(opts->indent_str) == 0)
+		d->data->indent_str[0] = '\t';
+	else
+		strncpy(d->data->indent_str, opts->indent_str,
+			sizeof(d->data->indent_str));
+
+	d->data->compact = OPTS_GET(opts, compact, false);
+	d->data->skip_names = OPTS_GET(opts, skip_names, false);
+	d->data->emit_zeroes = OPTS_GET(opts, emit_zeroes, false);
+
+	ret = btf_dump_dump_type_data(d, NULL, t, id, data, 0);
+
+	free(d->data);
+
+	if (ret < 0)
+		return libbpf_err(ret);
+	return ret;
+}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index bbe99b1..dfdf51e0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -374,4 +374,5 @@ LIBBPF_0.4.0 {
 LIBBPF_0.5.0 {
 	global:
 		libbpf_set_strict_mode;
+		btf_dump__dump_type_data;
 } LIBBPF_0.4.0;
-- 
1.8.3.1

