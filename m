Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971F73DF6D0
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhHCVXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:23:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37848 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhHCVXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:23:54 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173LHUhH000814;
        Tue, 3 Aug 2021 21:23:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=GsfpkSaxUSmWhjyF3bobQ9nwVK2+VO7ODJPa5DJ1Ybc=;
 b=Q43ZjeL8zBA5rLpB81EQt6CKx2WZHJsNw45gicOtJ8a9ULjF2kF/LKkdIqZFQ5xjbHTj
 VKay88F31VHmwcQQrF7hUKhMwLK/gDSQBQuZLCNT+5Q5e23OdzIMaBzRCzXdqFyZ9QN9
 ejkZZ8Cp0VXPIM+xDTadPWwqraaurjfBpYXDu7Tpxau+WLZTEIxHx0VB/3ZMETrQMoRp
 rSWRGlgvFybOlgHffklqiwl0KH+MxSgJnQ9zsEe3kdKZTPVnFTJRNMVoiWlH9Ioh9/Xn
 /lu6/E27cnKOpWtVZBezOMspBhclaPJUTLZ7Fl9lp85ypsficffiz9ehjeEtM8uPdICm gw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=GsfpkSaxUSmWhjyF3bobQ9nwVK2+VO7ODJPa5DJ1Ybc=;
 b=JmkaOXKibvmH7OyGAdRyj3HU0TFBgnEH79+UBHGEQflHhHSiqA7A9c+t+n9raNLTjWWH
 4DfTNmgqe+qIFmHZ1VqjEvVPu1HF6SFO4WdjNgVD4TXpNqS2HNXGeUonbYkrm0xeVi6E
 A7cK7EQpnpzwC8VDklQRf/xq6GM5+8jyb70LT8enQUYBAeMMZfG8KV6sspCXiwkZTX0C
 o1ckYI+zyibNs1VvzvlhSF2W+v+3mHo6UfQgvP1xe2yKduVvAaFjJtHs8QZUA7WQzgSM
 F6U5ALgoTFEb55SsFZSm2Yh4OIxTycW+D9jRzpvPpjbf1if2FRulzTWosXqXSu8RiMoA cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq08cwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173LFLOP056819;
        Tue, 3 Aug 2021 21:23:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3020.oracle.com with ESMTP id 3a5g9vsea4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKdBp4ELY4Lg/XKw2zcYluVv28ClKfPHbJoQYs4OaCc8JGvFr4VccZB1j1EOmrvQCUWWULelZ5xFbyrdcDtQOLUHVZkAhddH8L9pcgx2ovPPB5JDSLNIBY0DCho3bV2vutsbZTaAgmhYoc+0onPHZJa4PcZtu6TW/HtSxsdh9yGsbCIoz4FtUeueZJ06aNhvUIOQojygkbCcOGJiPbMriBEmlsqcaCSbiVKfuv0oC22wxK7Fmz66mqCZeVOGHxA1Z7etv+N7bw4gW8fQPrizFHpbeaxmNMWelqnJRh3tYEg1g9PVLEKK7mS3J4cbfLlrHY1kT1ryLss/LjXTFXNhPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsfpkSaxUSmWhjyF3bobQ9nwVK2+VO7ODJPa5DJ1Ybc=;
 b=BMHUJGauOHSbEE448peWP29E//KVeOJfDC/fSrCHCmIug+nWr/ZlW/i0BywzfP2yR+0AqXbXL6tdR8EJ9qAS9FgzwfEngjWCXOxHRHEDxRVwfS84bnlDebXLqb4lBnt1BPxYrltffV6FiCxBcWrWygw3Fd65o4NIbMyrIKoCU1TDv3PJGqrjmowTm6Bkz17MBdSgMLSctri+/SoQVC0zLBdD24P0ifBKSMSSJo0dkAMqWLOIRpQwZhKbGFBC/uAwVNLnhAmhzOePfZe1b38UaoSu2O5pMO3s5WtZYUe5sCZKqkB704PLN7vlYp6UZ1xld+cK5ULjsFyw6a7i4ICtcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsfpkSaxUSmWhjyF3bobQ9nwVK2+VO7ODJPa5DJ1Ybc=;
 b=BqKUjtbON/cOqDv7fjS+BpYzt60MX+G6XUL4nJOZnU0x/vv+76o80+ltW/5Hl/MQqDX6mJIMhX6gUxNVJ0zf4d629ebLUNVS8ScnefKFx3ekmWGNy1YL2JV8yhpCc5OHBL2JdxI6mjkspq6pdjeQ8b+t/ZMzjHAsEH7MdUJ2WeY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3102.namprd10.prod.outlook.com (2603:10b6:208:126::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 3 Aug
 2021 21:23:22 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 21:23:22 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, toke@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 0/3] tools: ksnoop: tracing kernel function entry/return with argument/return value display
Date:   Tue,  3 Aug 2021 22:23:13 +0100
Message-Id: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37)
 To BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 3 Aug 2021 21:23:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16488ebd-ed68-47d8-695f-08d956c4eba1
X-MS-TrafficTypeDiagnostic: MN2PR10MB3102:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3102D2D919DC0BA25778B395EFF09@MN2PR10MB3102.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMKKm4ATrQk4b1Rd/wkmqQ/TYXbwHxkQoG2eZSROPRgZQL/tlGkvQ/ZzPM7L71o84c7ExOzZl/Y3B8lScSJjC4Kmr/xbakAPui9SH2aUlY05jb4l8ub6qd7KvS1GufhFdauPl3XZ32ICMdWWlgu4ecoxpj9nA7zosJaPHsBrR97OsWnXlVeoXm3Oi+K7pF0crwvAR4O+rorPFPj9kcVhAfguvgoRCfgbJ7GkFkEhNS6KYWrSJDNHlxu3vvO8IZ8/TRrS5wJbuMVu2/0vDYlLgKOxijDkGmAKQoE+cYkZ4YkTDvVRfnM6fDHvi/r4d1WsjwNq6Int9If1ThvsOJjFoFPdi8Rd80sHVfxb7anA6wL8HL8QbrowWK01ON4sAsg8Zz7+UoZvyoASFWpfG2dSsMzCRvwroildvT0Sqi2m0G4nDp5WVVoHmNcJeCfCptRajvERZWFd33aBMvFTVdhbuszSO/nTfchcrRMgwzdrGoiH/+8149ARztJxsv5uD9zK1qxfION3KOcpz1ExFhsAkTIlXY+UAo5wKbG5DvnpruOumaGho64vZ7Cm+VBV+hyXbAeWyjJrAySw9M3tv0WNQbbLVwZVHPtizFgJLcZLB9SRmHGkd049DkaBxnC5Bzpi4I+qZ87apYA6oyW6KU1wMBP7QwgK/iz/upULHDtyz5jSPCpMyqWbclpZlJx1h5o0iTwitTqZDenfzI1zbNQ63AfKH5nXDpNSJ5zXE6s4TceFD6p1HCDEJe1X90QLXkk/lnFCiu87KmpLPfduuEnW7XJrEQFqBI9ql+comV23e5TGjjcl4rqTcGjDT6qAKGt4xva+L6UgioS4Of4ZlqcIew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(366004)(39860400002)(316002)(2906002)(107886003)(38350700002)(38100700002)(66476007)(66556008)(52116002)(186003)(66946007)(7696005)(26005)(6666004)(36756003)(8936002)(86362001)(6486002)(8676002)(4326008)(44832011)(7416002)(2616005)(966005)(83380400001)(478600001)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MxBxM0x4uGgpAzzkdUbQOGWnSc2vHJX9RrO3oyvzTrxxWr/KBaopkWjuVn2B?=
 =?us-ascii?Q?ItqiIaKT1Rj0l6CGpU3KncXz/k0Qi7VfGK4lGvDDG5/kOylQfTFECd+Lnbri?=
 =?us-ascii?Q?RduUlqhoAnNeUL7AUxtELsNYWc2PzVXBnZvnh1keCKvjGYxQBpOlHurs0fpz?=
 =?us-ascii?Q?39y/XMam2qJx3c9LXp6+r+2UriW5JCSWNmSGwnPwmh5SNxW850sKGtOxLolR?=
 =?us-ascii?Q?UccooygHy7wtJq4HyMv86OfDVC7bE7l+wVEGVMV41zBfdRdxX8L5hroAWZzz?=
 =?us-ascii?Q?522AyYUQupPxZsyki8b1tjFwIZwm1AEUln29WTaxcnZHsnDuGRp8+XxSdxSO?=
 =?us-ascii?Q?IGShOr3dGeqK2rNnVlGtvOGC+DhyAAaEGD1JfYG4D8N45SQDQOZoJfyh000X?=
 =?us-ascii?Q?ztfUaNb0skIBNom9yQ//uUoXiJfPx1Ba4zgzWzXanY7EErYQLI1LU2L1HNFs?=
 =?us-ascii?Q?OLLRr/Itw3xCf7umsynbzo6Pty4JUWiIQLPIdG6k/ckWpk7CgMPNMABM9NWv?=
 =?us-ascii?Q?sgXyvOLOoUkzUArDsBdCuR/ciAlUT1oMzy93jwp871e+p7FuEjSVcpXTlLp9?=
 =?us-ascii?Q?8pjfSDib4KQNLv/skEYCU74s2cevfernUbY9dksX7U0WbBBmlxiTI/ylAFJK?=
 =?us-ascii?Q?EcKyky1cWOjME+GAAOVAUIeoguF3Zpmcb+6m7UZH6RVA/66Gc0L0kLLbURKr?=
 =?us-ascii?Q?zB22vcp62FyWhsEnK7awtcRbu/hCOiIiWm4Sgjxpf1dqtg3gQ+VdFIlwftp9?=
 =?us-ascii?Q?sRwukR9YLevuj2HZ5MlLHXBS63vlOTF8hLfbKOf/omSPwiVGbhvWsNHlNDnu?=
 =?us-ascii?Q?y/LVcfH3TlujJrjqnSn0Cb7Hj4DYDqEhlUpN6eTMK7DY3y1X5F3Go0PUL4aZ?=
 =?us-ascii?Q?hg0m0iOrIRDFcA9NXs9ptG0czYwbIlGbEoNLVmmFJY1PaS7OZu/EXyVBSeCI?=
 =?us-ascii?Q?L2Kng7cZf1bTYNJH8HgxwNGFvVnWjBhEl5qGgAlTpVDq5qomLCxzJL854uA1?=
 =?us-ascii?Q?akHhsNHHWRxGprPrVpciJQSEIqXokeC1FBzti1bmBVsW9hroe5FD9b9SkKTU?=
 =?us-ascii?Q?8QPOzdDxZLswo4gSQnMt1ilIPoS4K5koNBa49PkVERujvV/efZlYAuy0Q0Qg?=
 =?us-ascii?Q?ebDrD4C7knU0sYDF1y6HAyuy3ca02m66e3w5VJ7VPlqcBBrUxXw5svYxESjS?=
 =?us-ascii?Q?kNsVZCZOYaVoIv7q1/nfWT/RAoZv6qeNoI0jXlk/NK4btD9QYhWjgnKIbX2b?=
 =?us-ascii?Q?4rlZaJT5s68cmNtf4LSZvAzGIIMdVifyWr9H4exlVC4KSNcc2xCOuvTbd/jI?=
 =?us-ascii?Q?Z1YB5TmBR58gEO62gL8/JO6v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16488ebd-ed68-47d8-695f-08d956c4eba1
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 21:23:21.9077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCfwLx9xAW3Dk78+ESMViPzJAw7zjuUKjJYljcbVXqauCKVsg2W1mdT0hQ6AqcwMgC1pJjHwhZpMulwKRgYKnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3102
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030134
X-Proofpoint-ORIG-GUID: cYvqNbhbqP49i1GiORFyrHirke2sorSL
X-Proofpoint-GUID: cYvqNbhbqP49i1GiORFyrHirke2sorSL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent functionality added to libbpf [1] enables typed display of kernel
data structures; here that functionality is exploited to provide a
simple example of how a tracer can support deep argument/return value
inspection.  The intent is to provide a demonstration of these features
to help facilitate tracer adoption, while also providing a tool which
can be useful for kernel debugging.

Changes since RFC [2]:

- In the RFC version, kernel data structures were string-ified in
  BPF program context vi bpf_snprintf_btf(); Alexei pointed out that
  it would be better to dump memory to userspace and let the
  interpretation happen there.  btf_dump__dump_type_data() in libbpf
  now supports this (Alexei, patch 1)
- Added the "stack mode" specification where we trace a specific set
  of functions being called in order (though not necessarily directly).
  This mode of tracing is useful when debugging issues with a specific
  stack signature.

[1] https://lore.kernel.org/bpf/1626362126-27775-1-git-send-email-alan.maguire@oracle.com/
[2] https://lore.kernel.org/bpf/1609773991-10509-1-git-send-email-alan.maguire@oracle.com/

Alan Maguire (3):
  tools: ksnoop: kernel argument/return value tracing/display using BTF
  tools: ksnoop: document ksnoop tracing of entry/return with value
    display
  tools: ksnoop: add .gitignore

 tools/bpf/Makefile                        |  20 +-
 tools/bpf/ksnoop/.gitignore               |   1 +
 tools/bpf/ksnoop/Documentation/Makefile   |  58 ++
 tools/bpf/ksnoop/Documentation/ksnoop.rst | 173 ++++++
 tools/bpf/ksnoop/Makefile                 | 107 ++++
 tools/bpf/ksnoop/ksnoop.bpf.c             | 391 +++++++++++++
 tools/bpf/ksnoop/ksnoop.c                 | 890 ++++++++++++++++++++++++++++++
 tools/bpf/ksnoop/ksnoop.h                 | 103 ++++
 8 files changed, 1738 insertions(+), 5 deletions(-)
 create mode 100644 tools/bpf/ksnoop/.gitignore
 create mode 100644 tools/bpf/ksnoop/Documentation/Makefile
 create mode 100644 tools/bpf/ksnoop/Documentation/ksnoop.rst
 create mode 100644 tools/bpf/ksnoop/Makefile
 create mode 100644 tools/bpf/ksnoop/ksnoop.bpf.c
 create mode 100644 tools/bpf/ksnoop/ksnoop.c
 create mode 100644 tools/bpf/ksnoop/ksnoop.h

-- 
1.8.3.1

