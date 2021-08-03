Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318673DF6D4
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhHCVYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:24:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21824 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232105AbhHCVX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:23:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173LGuBU030858;
        Tue, 3 Aug 2021 21:23:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=E6DeURSZVof20oKuDsV6mFSCQNs2Qu9qxInJPWzCE18=;
 b=cHdghCC9hWLGpb2UqJI1yuZjheGIiLcVCMFo4unDScSLp3Bhoza1io6/SGyAOAYq2FVc
 uEJmcTUIZ807D2+JyDvTKGOgMzWvtVIxFMGM6a/tG1yFzWCswxRmEB1t9tAt4CcvBeEu
 FX68PRNCMVsaFW6+fzVzi4tVGFtgapftSegSWcD5MEOdxE/5LqqAdDf6sbmQw3xLZsDh
 gS4LVKNM2xJ4CqHD9e7Uro74xR/8qZjEGjkH7MumrzYTvXXjF9Zk/fIUJZFtH+OFPlxn
 fI1qe26zag2AGXak2RcGYBpzdT6nbclizeCKGtoRly/1eP89YpRYjc7lZvlu/ZhKzLVN +w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=E6DeURSZVof20oKuDsV6mFSCQNs2Qu9qxInJPWzCE18=;
 b=loXee2PHe59eFIgLE+oAw2GcVhHlibq0SxX+/+xM7R1QVja7ZRQCtuvGCHrK2yepTd+E
 kR0GqoTxFtzglwTGHjiNFitNJkZ5nc24zow0xR3nprsZSFPe2F/BmNYtv8RCHU5vbOUj
 iny5pk/o4FB33gvDBnJTnc0tJ4uEVd9/lOhmUnQ3TiJZBe8XrM5K+1LVKFbAZea8cX2M
 5Wnme/XXO2BCDDIHPxtj9j75IALxoTgi/ZWPSdqBjeXqvAJA4QIOu7hWHTVaC6lkgm0s
 /+u6MO3RiaHbdzwxjB3PyMz20tcS5kIGLtIrZvnwGqKrxSFoJKwQcVEYSdEaWUW+zhC4 JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6fxhcanq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173LFthr170291;
        Tue, 3 Aug 2021 21:23:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 3a4xb7denj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LygEdfjvSub70gzhWsdGhH0h+LBJa53USTyZ/OkJ06VwIVpv+cjI/I5EX3ipV0vIXKsDl2hWhjVLKSILwX7z18iykGM7bTo+fi4gjd40eDjfM3UKHvePnx0ifrS98I94G4riB0ZEiK9lnPaIGlB9u+EWEX5Sn0vE8BXbNVIonIOks9eDFG2PVb3JfYGLvX+LcKmUHgWlXDZLEQkfZo8vrtAL7owhhs6S17ycZE63kUk+b/iveF7DQbf2Hj4IW4LILbg7/u2tJCdOePA+Xs5LW7dNTjNGff5HnbrJR0gcqeajyiLXH+6rrH3+kyekU8Jud6Od9wtafh83hywvQhdFsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6DeURSZVof20oKuDsV6mFSCQNs2Qu9qxInJPWzCE18=;
 b=iyN9/KFpBFcdomBdTtq6TxjLsRe5Pu272fW80RYZZjVXQ6YbXGAnlhZUoABHo1+dmhB0wKC0DVEPd5fwKPzHJ9z5sg47qHFsr7sNFAmOQee+TQz7aGa4cqjG+TEcfVDqQHxojLoXrzXa+fvYHG+f4mtppMONTF24VIu0H6fGatUx/wCGmm9cp48o071HqH6/Nym3pWV0PFBW0xLF9QQlWrA8S4tNUZFLS7C9Mk4cGp0wSgPH034Rc3DC4StOdjENKI86sAN43kyuXJ5LOAZP3IMIbhsyagjPwEIXDhuf4/QsJF1ELrsHHpW2zHu0UMJ3TfEXy4hbctspyrHaX9tK0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6DeURSZVof20oKuDsV6mFSCQNs2Qu9qxInJPWzCE18=;
 b=ly5O4071RZwnQXP2mDthNyQJH6NZy7yePC0dJ+4Csk1cVe5mGHg4n05Yo26udsaOHIffQMhrYxDKfz/WEnBq2smZs68yUDHim8+1MxztmoPxuOSUuRgrely2UG7Drge3wFq5UCpatm0pG/eLsa/yK/+A18/PdY5dtHEutzvdnQU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 3 Aug
 2021 21:23:24 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 21:23:24 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, toke@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 1/3] tools: ksnoop: kernel argument/return value tracing/display using BTF
Date:   Tue,  3 Aug 2021 22:23:14 +0100
Message-Id: <1628025796-29533-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
References: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37)
 To BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 3 Aug 2021 21:23:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 271a1aa7-5f46-4245-e751-08d956c4ecec
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB49487201BF87BB23529A5060EFF09@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOqNRp4PAAa7xze4cDTrof8ytJyaQawX5St+NEWaCJ5jg4zZtFZL5+bK1jWC8Wyh8xnHSHJleAnpBoHVFUPx9h166xDyx4M4PZTwPCjFpHbf8l+AYew/SSgeq+KQ8PLw7OBpXwUFaJC1En0PWsYs9q3yfKlQ5JoizvicUeFVV+bxCIZd2oygTuynVXp+InHlMml4xUQvncFofpo071bLKRpOX798skpFL+kflP+nXxMatBSaBx0mUsByBg+GdCp7lE//0sH5qTY2FRhSlIcYZzSukY5SzlpeH6J+Zx1tn/m2bPV/vtZuNUM8uKXHT7QWM+cafnsYNgA9SC5Z6ANS+Tsf+Tk7wlpnUBYgNMboxSU7tN1omV9+EDefIm7eGeGwWEITHdYg0VnYsdwDPeSPoLF83yQcZhDhAljZaJSO/BDyPKQFeuMtFXSvIhFiVPmRBS5DMtnzC7cIyU17i998Y22RiJIkkcj2pdpc1wf1NMNMdrdqJ0QXVV+O1K8cxImOZrzWRsv89FlBqB8/i911nZaUOmUl/Kr2OYQNaJmgyv5Iwwp2f7Ua6kvNGHII2/QBdkezQc51C+L691VpSNpEW8R9/sFHCOIshwutOesiIG7chIRZeaZqjOWOg/7tIxz/UBXngTLUv927thdsUK5b/LC9lQVWjn1BRw+ACDaf3bp7CtEp51txSuWdgm5q3qZNXX2Knd7dGUWLjdWgQzQDFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(86362001)(6486002)(8676002)(4326008)(8936002)(36756003)(6666004)(478600001)(83380400001)(956004)(5660300002)(44832011)(2616005)(7416002)(38350700002)(38100700002)(30864003)(107886003)(316002)(2906002)(26005)(7696005)(52116002)(66476007)(66556008)(66946007)(186003)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hbjcdchSsU0RrwA1u6BpfYhgawmPI03eccJPooN3mvi7N0Inbqb9kUtAM8SP?=
 =?us-ascii?Q?9Mc9vDdKljZg+nE/pY3cj9tdt2YEZNnC31W27Uwdkne2A9abkPuY6USNLZTs?=
 =?us-ascii?Q?YVUEsgyynrbzcrlEF29CI/NRbwCtLtZHUy6T9xWjmhZ9j8aJyrb3o2LwGRYl?=
 =?us-ascii?Q?pmoHpgypi5CzWBiqOY74wN9+Jwt/GcPdAFO8FkToi1rhet6eL+BU6wdvqsTm?=
 =?us-ascii?Q?T+VUOYoldnw7ZxWpJpo8JME2gIbozMHR/VUGZSim2pwT1vzfjbBCtYqY36iw?=
 =?us-ascii?Q?ESNNzSwZZY92Nkl7auiVMSa2tK1RDArY/fxAiWIsSP36U0a61i5io1QNuBkM?=
 =?us-ascii?Q?JMI9lHvwAi/e412f565yf+fFSZRKAY8WrrK2bCKUg/UcOVETy7X0YNnP0SOF?=
 =?us-ascii?Q?oUZ6hh9l6OSdHpkqap09rqUKD9/5ynWDOUIvvL6yYONmsXGGSKvgxB14XXdK?=
 =?us-ascii?Q?m2rn/4VYlyxdeg5oDUm1fKwFTyzlXWqoIlxIf8cX6ezFgVOTeQ6ghuVjIdCz?=
 =?us-ascii?Q?FbzzfYEQP4+7Fbv92suhIOSjfp9hdME/eI4VMgulW+pKvKI//cDyersvx5Qg?=
 =?us-ascii?Q?tYuXsuRRdmGAqsqTCMEy8/r3xK5f8ICzdmyMsLz03JdI9z+igUlS/IIsvkAP?=
 =?us-ascii?Q?3YScg0/RdPMz2vsUoN529cvMWCul91zcERF5DvaNk09V4F0qD1uAR0FuCFxX?=
 =?us-ascii?Q?/fkcBNnUkFcoFF/eEA+XjxVP5yCcx8K9/qmThFvUzGQY957CUxdFidSPV+p1?=
 =?us-ascii?Q?dJJP/ApDvFpv5UiJPWqXj+Gp7XtvJI4tRlUHeJiFTfPKX1gqyxfBDkDrpZLa?=
 =?us-ascii?Q?+4gROxegKnpbmS/wDviww9Q8LhSrmJCJA+IahgvDC3aY/djuJ1UJaf9y6FDc?=
 =?us-ascii?Q?o7G04Yqiy21qW+BcUkO0p5Eg8HTmOWvcYpmP41v/1AOx6UJzIellj0jk5ozd?=
 =?us-ascii?Q?nYlfrnU1WEpHGQEVbgDIXT20DbYqTUsq6ewRFqnr6yzR9X1hKgZCbX7DvGDm?=
 =?us-ascii?Q?K9r/4k6I8fdV/x07CrkJxgVzmo2BgDkGi+e7IgdlbLQW8UYv00mKs1AVeT69?=
 =?us-ascii?Q?X1KkZz78lNrQgLQ/RSEA/BBmaT48XvVTIS5ePqlFZcgKyQjWWoXH2bl+NuSG?=
 =?us-ascii?Q?Zf9MXVsgPFk0L+krKuPTZWjDjrEOMbiN+rJ6AOzWHQ1GyOvXFDOXSXw1nb59?=
 =?us-ascii?Q?XbXsfj790Ux99i0wwA5JXI0+Wxa8DgdLowT1fpuVPJIXi750FLVdixuXlEyE?=
 =?us-ascii?Q?aLqk0odeD5/RO/LLXOxmIvt3GGDHX0NBqkJArmk0UtDkYu7O1fU4OyHslYAf?=
 =?us-ascii?Q?KAm9qjWwwmRQah859vfkcCj/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271a1aa7-5f46-4245-e751-08d956c4ecec
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 21:23:23.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZQFHZNEtOzj47HYNTjGOptu/isKU3R0cmr8KCtBNGENeRvR8r8yEUmB+y2SK/gyxRT49r9olKe6W8dyJkciAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030134
X-Proofpoint-GUID: nNTbDyQBwfGoTAUhM3Z685GXFcGKnh8z
X-Proofpoint-ORIG-GUID: nNTbDyQBwfGoTAUhM3Z685GXFcGKnh8z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF Type Format (BTF) provides a description of kernel data structures.
libbpf support was recently added - btf_dump__dump_type_data() -
that uses the BTF id of the associated type to create a string
representation of the data provided.  For example, to create a string
representation of a "struct sk_buff", the pointer to the skb
data is provided along with the type id of "struct sk_buff".

Here that functionality is utilized to support tracing kernel
function entry and return using k[ret]probes.  The "struct pt_regs"
context can be used to derive arguments and return values, and
when the user supplies a function name we

- look it up in /proc/kallsyms to find its address/module
- look it up in the BTF kernel/module data to get types of arguments
  and return value
- store a map representation of the trace information, keyed by
  function address

On function entry/return we look up info about the arguments (is
it a pointer? what size of data do we copy?) and call bpf_probe_read()
to copy the data into our trace buffers.  These are then sent via
perf event to userspace, and since we know the associated BTF id,
we can dump the typed data using btf_dump__dump_type_data().

ksnoop can be used to show function signatures; for example:

$ ksnoop info ip_send_skb
int  ip_send_skb(struct net  * net, struct sk_buff  * skb);

Then we can trace the function, for example:

$ ksnoop trace ip_send_skb
           TIME  CPU      PID FUNCTION/ARGS
  78101668506811    1     2813 ip_send_skb(
                                   net = *(0xffffffffb5959840)
                                    (struct net){
                                     .passive = (refcount_t){
                                      .refs = (atomic_t){
                                       .counter = (int)0x2,
                                      },
                                     },
                                     .dev_base_seq = (unsigned int)0x18,
                                     .ifindex = (int)0xf,
                                     .list = (struct list_head){
                                      .next = (struct list_head *)0xffff9895440dc120,
                                      .prev = (struct list_head *)0xffffffffb595a8d0,
                                     },
[output truncated]

  78178228354796    1     2813 ip_send_skb(
                                   return =
                                    (int)0x0
                               );

We see the raw value of pointers along with the typed representation
of the data they point to.

Up to five arguments are supported.

The arguments are referred to via name (e.g. skb, net), and
the return value is referred to as "return" (using the keyword
ensures we can never clash with an argument name).

ksnoop can select specific arguments/return value rather
than tracing everything; for example:

$ ksnoop "ip_send_skb(skb)"

...will only trace the skb argument.  A single level of
reference is supported also, for example:

$ ksnoop "ip_send_skb(skb->sk)"

or

$ ksnoop "ip_send_skb(skb->len)"

Multiple functions can be specified also.

In addition, using "stack" (-s) mode, it is possible to specify that
a sequence of functions should be traced, but only if function
A calls function B (either directly or indirectly).  For example,
in specifying

$ ksnoop -s tcp_sendmsg __tcp_transmit_skb  ip_output

...we are saying we are only interested in tcp_sendmsg() function
calls that in turn issue calls to __tcp_transmit_skb(), and these
in turn eventually call ip_output(), and that we only want to
see their entry and return.  This mode is useful for investigating
behaviour with a specific stack signature, allowing us to see
function/argument information for specific call chains only.

Finally, module support is included too, provided module BTF is
present in /sys/kernel/btf :

$ ksnoop iwl_trans_send_cmd
            TIME  CPU      PID FUNCTION/ARGS
  80046971419383    3     1038 iwl_trans_send_cmd(
                                   trans = *(0xffff989564d20028)
                                    (struct iwl_trans){
                                     .ops = (struct iwl_trans_ops *)0xffffffffc0e02fa0,
                                     .op_mode = (struct iwl_op_mode *)0xffff989566849fc0,
                                     .trans_cfg = (struct iwl_cfg_trans_params *)0xffffffffc0e05280,

The goal pursued here is not to add another tracer to the world -
there are plenty of those - but rather to demonstrate feature usage
for deep data display in the hope that other tracing technologies
make use of this functionality.  In the meantime, having a simple
tracer like this plugs the gap and can be quite helpful for kernel
debugging.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/bpf/Makefile            |  20 +-
 tools/bpf/ksnoop/Makefile     |  98 +++++
 tools/bpf/ksnoop/ksnoop.bpf.c | 391 +++++++++++++++++++
 tools/bpf/ksnoop/ksnoop.c     | 890 ++++++++++++++++++++++++++++++++++++++++++
 tools/bpf/ksnoop/ksnoop.h     | 103 +++++
 5 files changed, 1497 insertions(+), 5 deletions(-)
 create mode 100644 tools/bpf/ksnoop/Makefile
 create mode 100644 tools/bpf/ksnoop/ksnoop.bpf.c
 create mode 100644 tools/bpf/ksnoop/ksnoop.c
 create mode 100644 tools/bpf/ksnoop/ksnoop.h

diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
index b11cfc8..e72bfdc 100644
--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -38,7 +38,7 @@ FEATURE_TESTS = libbfd disassembler-four-args
 FEATURE_DISPLAY = libbfd disassembler-four-args
 
 check_feat := 1
-NON_CHECK_FEAT_TARGETS := clean bpftool_clean runqslower_clean resolve_btfids_clean
+NON_CHECK_FEAT_TARGETS := clean bpftool_clean runqslower_clean resolve_btfids_clean ksnoop_clean
 ifdef MAKECMDGOALS
 ifeq ($(filter-out $(NON_CHECK_FEAT_TARGETS),$(MAKECMDGOALS)),)
   check_feat := 0
@@ -73,7 +73,7 @@ $(OUTPUT)%.lex.o: $(OUTPUT)%.lex.c
 
 PROGS = $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg $(OUTPUT)bpf_asm
 
-all: $(PROGS) bpftool runqslower
+all: $(PROGS) bpftool runqslower ksnoop
 
 $(OUTPUT)bpf_jit_disasm: CFLAGS += -DPACKAGE='bpf_jit_disasm'
 $(OUTPUT)bpf_jit_disasm: $(OUTPUT)bpf_jit_disasm.o
@@ -89,7 +89,7 @@ $(OUTPUT)bpf_exp.lex.c: $(OUTPUT)bpf_exp.yacc.c
 $(OUTPUT)bpf_exp.yacc.o: $(OUTPUT)bpf_exp.yacc.c
 $(OUTPUT)bpf_exp.lex.o: $(OUTPUT)bpf_exp.lex.c
 
-clean: bpftool_clean runqslower_clean resolve_btfids_clean
+clean: bpftool_clean runqslower_clean resolve_btfids_clean ksnoop_clean
 	$(call QUIET_CLEAN, bpf-progs)
 	$(Q)$(RM) -r -- $(OUTPUT)*.o $(OUTPUT)bpf_jit_disasm $(OUTPUT)bpf_dbg \
 	       $(OUTPUT)bpf_asm $(OUTPUT)bpf_exp.yacc.* $(OUTPUT)bpf_exp.lex.*
@@ -97,7 +97,7 @@ clean: bpftool_clean runqslower_clean resolve_btfids_clean
 	$(Q)$(RM) -- $(OUTPUT)FEATURE-DUMP.bpf
 	$(Q)$(RM) -r -- $(OUTPUT)feature
 
-install: $(PROGS) bpftool_install
+install: $(PROGS) bpftool_install ksnoop_install
 	$(call QUIET_INSTALL, bpf_jit_disasm)
 	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/bin
 	$(Q)$(INSTALL) $(OUTPUT)bpf_jit_disasm $(DESTDIR)$(prefix)/bin/bpf_jit_disasm
@@ -127,6 +127,16 @@ resolve_btfids:
 resolve_btfids_clean:
 	$(call descend,resolve_btfids,clean)
 
+ksnoop:
+	$(call descend,ksnoop)
+
+ksnoop_install:
+	$(call descend,ksnoop,install)
+
+ksnoop_clean:
+	$(call descend,ksnoop,clean)
+
 .PHONY: all install clean bpftool bpftool_install bpftool_clean \
 	runqslower runqslower_clean \
-	resolve_btfids resolve_btfids_clean
+	resolve_btfids resolve_btfids_clean \
+	ksnoop ksnoop_install ksnoop_clean
diff --git a/tools/bpf/ksnoop/Makefile b/tools/bpf/ksnoop/Makefile
new file mode 100644
index 0000000..0a1420e
--- /dev/null
+++ b/tools/bpf/ksnoop/Makefile
@@ -0,0 +1,98 @@
+# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+include ../../scripts/Makefile.include
+include ../../scripts/Makefile.arch
+
+OUTPUT ?= $(abspath .output)/
+
+CLANG ?= clang
+LLC ?= llc
+LLVM_STRIP ?= llvm-strip
+BPFTOOL_OUTPUT := $(OUTPUT)bpftool/
+DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bpftool
+BPFTOOL ?= $(DEFAULT_BPFTOOL)
+LIBBPF_SRC := $(abspath ../../lib/bpf)
+BPFOBJ_OUTPUT := $(OUTPUT)libbpf/
+BPFOBJ := $(BPFOBJ_OUTPUT)libbpf.a
+BPF_INCLUDE := $(BPFOBJ_OUTPUT)
+INCLUDES := -I$(OUTPUT) -I$(BPF_INCLUDE) -I$(abspath ../../lib)        \
+       -I$(abspath ../../include/uapi)
+
+INSTALL ?= install
+
+ifeq ($(KSNOOP_VERSION),)
+KSNOOP_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
+endif
+
+CFLAGS := -g -Wall
+CFLAGS += -DKSNOOP_VERSION='"$(KSNOOP_VERSION)"'
+
+# Try to detect best kernel BTF source
+KERNEL_REL := $(shell uname -r)
+VMLINUX_BTF_PATHS := /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_REL)
+VMLINUX_BTF_PATH := $(or $(VMLINUX_BTF),$(firstword			       \
+					  $(wildcard $(VMLINUX_BTF_PATHS))))
+
+ifeq ($(V),1)
+Q =
+else
+Q = @
+MAKEFLAGS += --no-print-directory
+submake_extras := feature_display=0
+endif
+
+.DELETE_ON_ERROR:
+
+.PHONY: all clean ksnoop
+all: ksnoop
+
+ksnoop: $(OUTPUT)/ksnoop
+
+clean:
+	$(call QUIET_CLEAN, ksnoop)
+	$(Q)$(RM) -r $(BPFOBJ_OUTPUT) $(BPFTOOL_OUTPUT)
+	$(Q)$(RM) $(OUTPUT)*.o $(OUTPUT)*.d
+	$(Q)$(RM) $(OUTPUT)*.skel.h $(OUTPUT)vmlinux.h
+	$(Q)$(RM) $(OUTPUT)ksnoop
+	$(Q)$(RM) -r .output
+
+install: ksnoop
+	$(call QUIET_INSTALL, ksnoop)
+	$(Q)$(INSTALL) -m 0755 -d $(DESTDIR)$(prefix)/sbin
+	$(Q)$(INSTALL) $(OUTPUT)/ksnoop $(DESTDIR)$(prefix)/sbin/ksnoop
+
+$(OUTPUT)/ksnoop: $(OUTPUT)/ksnoop.o $(BPFOBJ)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $^ -lelf -lz -o $@
+
+$(OUTPUT)/ksnoop.o: ksnoop.h $(OUTPUT)/ksnoop.skel.h	      \
+			$(OUTPUT)/ksnoop.bpf.o
+
+$(OUTPUT)/ksnoop.bpf.o: $(OUTPUT)/vmlinux.h ksnoop.h
+
+$(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
+	$(QUIET_GEN)$(BPFTOOL) gen skeleton $< > $@
+
+$(OUTPUT)/%.bpf.o: %.bpf.c $(BPFOBJ) | $(OUTPUT)
+	$(QUIET_GEN)$(CLANG) -g -D__TARGET_ARCH_$(SRCARCH) -O2 -target bpf \
+		$(INCLUDES) -c $(filter %.c,$^) -o $@ &&		   \
+	$(LLVM_STRIP) -g $@
+
+$(OUTPUT)/%.o: %.c | $(OUTPUT)
+	$(QUIET_CC)$(CC) $(CFLAGS) $(INCLUDES) -c $(filter %.c,$^) -o $@
+
+$(OUTPUT) $(BPFOBJ_OUTPUT) $(BPFTOOL_OUTPUT):
+	$(QUIET_MKDIR)mkdir -p $@
+
+$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF_PATH) | $(OUTPUT) $(BPFTOOL)
+	$(Q)if [ ! -e "$(VMLINUX_BTF_PATH)" ] ; then \
+		echo "Couldn't find kernel BTF; set VMLINUX_BTF to"	       \
+			"specify its location." >&2;			       \
+		exit 1;\
+	fi
+	$(QUIET_GEN)$(BPFTOOL) btf dump file $(VMLINUX_BTF_PATH) format c > $@
+
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(BPFOBJ_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) $@
+
+$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C ../bpftool OUTPUT=$(BPFTOOL_OUTPUT)   \
+		    CC=$(HOSTCC) LD=$(HOSTLD)
diff --git a/tools/bpf/ksnoop/ksnoop.bpf.c b/tools/bpf/ksnoop/ksnoop.bpf.c
new file mode 100644
index 0000000..815e334
--- /dev/null
+++ b/tools/bpf/ksnoop/ksnoop.bpf.c
@@ -0,0 +1,391 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+#include <asm-generic/errno.h>
+#include "ksnoop.h"
+
+/* For kretprobes, the instruction pointer in the struct pt_regs context
+ * is the kretprobe_trampoline.  We derive the instruction pointer
+ * by pushing it onto a function stack on entry and popping it on return.
+ *
+ * We could use bpf_get_func_ip(), but "stack mode" - where we
+ * specify functions "a", "b and "c" and only want to see a trace if "a"
+ * calls "b" and "b" calls "c" - utilizes this stack to determine if trace
+ * data should be collected.
+ */
+#define FUNC_MAX_STACK_DEPTH	16
+
+#ifndef NULL
+#define NULL			0
+#endif
+
+struct func_stack {
+	__u64 task;
+	__u64 ips[FUNC_MAX_STACK_DEPTH];
+	__u8 stack_depth;
+};
+
+/* function call stack hashed on a per-task key */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 512);
+	__type(key, __u64);
+	__type(value, struct func_stack);
+} ksnoop_func_stack SEC(".maps");
+
+/* per-cpu trace info hashed on function address */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 8);
+	__type(key, __u64);
+	__type(value, struct trace);
+} ksnoop_func_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(value_size, sizeof(int));
+	__uint(key_size, sizeof(int));
+} ksnoop_perf_map SEC(".maps");
+
+static inline void clear_trace(struct trace *trace)
+{
+	__builtin_memset(&trace->trace_data, 0, sizeof(trace->trace_data));
+	trace->data_flags = 0;
+	trace->buf_len = 0;
+}
+
+static inline struct trace *get_trace(struct pt_regs *ctx, bool entry)
+{
+	__u8 stack_depth, last_stack_depth;
+	struct func_stack *func_stack;
+	__u64 ip, last_ip = 0, task;
+	struct trace *trace;
+
+	task = bpf_get_current_task();
+
+	func_stack = bpf_map_lookup_elem(&ksnoop_func_stack, &task);
+	if (!func_stack) {
+		struct func_stack new_stack = { .task = task };
+
+		bpf_map_update_elem(&ksnoop_func_stack, &task, &new_stack,
+				    BPF_NOEXIST);
+		func_stack = bpf_map_lookup_elem(&ksnoop_func_stack, &task);
+		if (!func_stack)
+			return NULL;
+	}
+
+	stack_depth = func_stack->stack_depth;
+	if (stack_depth > FUNC_MAX_STACK_DEPTH)
+		return NULL;
+
+	if (entry) {
+		ip = KSNOOP_IP_FIX(PT_REGS_IP_CORE(ctx));
+		if (stack_depth >= FUNC_MAX_STACK_DEPTH)
+			return NULL;
+		/* verifier doesn't like using "stack_depth - 1" as array index
+		 * directly.
+		 */
+		last_stack_depth = stack_depth - 1;
+		/* get address of last function we called */
+		if (last_stack_depth >= 0 &&
+		    last_stack_depth < FUNC_MAX_STACK_DEPTH)
+			last_ip = func_stack->ips[last_stack_depth];
+		/* push ip onto stack. return will pop it. */
+		func_stack->ips[stack_depth++] = ip;
+		func_stack->stack_depth = stack_depth;
+		/* rather than zero stack entries on popping, we zero the
+		 * (stack_depth + 1)'th entry when pushing the current
+		 * entry.  The reason we take this approach is that
+		 * when tracking the set of functions we returned from,
+		 * we want the history of functions we returned from to
+		 * be preserved.
+		 */
+		if (stack_depth < FUNC_MAX_STACK_DEPTH)
+			func_stack->ips[stack_depth] = 0;
+	} else {
+		if (stack_depth == 0 || stack_depth >= FUNC_MAX_STACK_DEPTH)
+			return NULL;
+		last_stack_depth = stack_depth;
+		/* get address of last function we returned from */
+		if (last_stack_depth >= 0 &&
+		    last_stack_depth < FUNC_MAX_STACK_DEPTH)
+			last_ip = func_stack->ips[last_stack_depth];
+		if (stack_depth > 0)
+			stack_depth = stack_depth - 1;
+		/* retrieve ip from stack as IP in pt_regs is
+		 * bpf kretprobe trampoline address.
+		 */
+		if (stack_depth >= 0 && stack_depth < FUNC_MAX_STACK_DEPTH)
+			ip = func_stack->ips[stack_depth];
+		if (stack_depth >= 0 && stack_depth < FUNC_MAX_STACK_DEPTH)
+			func_stack->stack_depth = stack_depth;
+	}
+
+	trace = bpf_map_lookup_elem(&ksnoop_func_map, &ip);
+	if (!trace)
+		return NULL;
+	/* clear trace data before starting. */
+	clear_trace(trace);
+
+	if (entry) {
+		/* if in stack mode, check if previous fn matches */
+		if (trace->prev_ip && trace->prev_ip != last_ip)
+			return NULL;
+		/* if tracing intermediate fn in stack of fns, stash data. */
+		if (trace->next_ip)
+			trace->data_flags |= KSNOOP_F_STASH;
+		/* otherwise the data is outputted (because we've reached
+		 * the last fn in the set of fns specified).
+		 */
+	} else {
+		/* In stack mode, check if next fn matches the last fn
+		 * we returned from; i.e. "a" called "b", and now
+		 * we're at "a", was the last fn we returned from "b"?
+		 * If so, stash data for later display (when we reach the
+		 * first fn in the set of stack fns).
+		 */
+		if (trace->next_ip && trace->next_ip != last_ip)
+			return NULL;
+		if (trace->prev_ip)
+			trace->data_flags |= KSNOOP_F_STASH;
+		/* If there is no "prev" function, i.e. we are at the
+		 * first function in a set of stack functions, the trace
+		 * info is shown (along with any stashed info associated
+		 * with callers).
+		 */
+	}
+	trace->task = task;
+	return trace;
+}
+
+static inline void output_trace(struct pt_regs *ctx, struct trace *trace)
+{
+	__u16 trace_len;
+
+	/* we may be simply stashing values, and will report later */
+	if (trace->data_flags & KSNOOP_F_STASH) {
+		trace->data_flags &= ~KSNOOP_F_STASH;
+		trace->data_flags |= KSNOOP_F_STASHED;
+		return;
+	}
+	/* we may be outputting earlier stashed data */
+	if (trace->data_flags & KSNOOP_F_STASHED)
+		trace->data_flags &= ~KSNOOP_F_STASHED;
+
+	/* trim perf event size to only contain data we've recorded. */
+	trace_len = sizeof(*trace) + trace->buf_len - MAX_TRACE_BUF;
+
+	if (trace_len <= sizeof(*trace))
+		bpf_perf_event_output(ctx, &ksnoop_perf_map,
+				      BPF_F_CURRENT_CPU,
+				      trace, trace_len);
+	clear_trace(trace);
+}
+
+static inline void output_stashed_traces(struct pt_regs *ctx,
+					 struct trace *currtrace,
+					 bool entry)
+{
+	struct func_stack *func_stack;
+	struct trace *trace = NULL;
+	__u8 stack_depth, i;
+	__u64 task = 0;
+
+	task = bpf_get_current_task();
+	func_stack = bpf_map_lookup_elem(&ksnoop_func_stack, &task);
+	if (!func_stack)
+		return;
+
+	stack_depth = func_stack->stack_depth;
+
+	if (entry) {
+		/* iterate from bottom to top of stack, outputting stashed
+		 * data we find.  This corresponds to the set of functions
+		 * we called before the current function.
+		 */
+		for (i = 0;
+		     i < func_stack->stack_depth - 1 && i < FUNC_MAX_STACK_DEPTH;
+		     i++) {
+			trace = bpf_map_lookup_elem(&ksnoop_func_map,
+						    &func_stack->ips[i]);
+			if (!trace || !(trace->data_flags & KSNOOP_F_STASHED))
+				break;
+			if (trace->task != task)
+				return;
+			output_trace(ctx, trace);
+		}
+	} else {
+		/* iterate from top to bottom of stack, outputting stashed
+		 * data we find.  This corresponds to the set of functions
+		 * that returned prior to the current returning function.
+		 */
+		for (i = FUNC_MAX_STACK_DEPTH; i > 0; i--) {
+			__u64 ip;
+
+			ip = func_stack->ips[i];
+			if (!ip)
+				continue;
+			trace = bpf_map_lookup_elem(&ksnoop_func_map, &ip);
+			if (!trace || !(trace->data_flags & KSNOOP_F_STASHED))
+				break;
+			if (trace->task != task)
+				return;
+			output_trace(ctx, trace);
+		}
+	}
+	/* finally output the current trace info */
+	output_trace(ctx, currtrace);
+}
+
+static inline __u64 get_arg(struct pt_regs *ctx, enum arg argnum)
+{
+	switch (argnum) {
+	case KSNOOP_ARG1:
+		return PT_REGS_PARM1_CORE(ctx);
+	case KSNOOP_ARG2:
+		return PT_REGS_PARM2_CORE(ctx);
+	case KSNOOP_ARG3:
+		return PT_REGS_PARM3_CORE(ctx);
+	case KSNOOP_ARG4:
+		return PT_REGS_PARM4_CORE(ctx);
+	case KSNOOP_ARG5:
+		return PT_REGS_PARM5_CORE(ctx);
+	case KSNOOP_RETURN:
+		return PT_REGS_RC_CORE(ctx);
+	default:
+		return 0;
+	}
+}
+
+static inline int ksnoop(struct pt_regs *ctx, bool entry)
+{
+	void *data_ptr = NULL;
+	struct trace *trace;
+	struct func *func;
+	__u16 trace_len;
+	__u64 data, pg;
+	__u32 currpid;
+	int ret;
+	__u8 i;
+
+	trace = get_trace(ctx, entry);
+	if (!trace)
+		return 0;
+
+	func = &trace->func;
+
+	/* make sure we want events from this pid */
+	currpid = bpf_get_current_pid_tgid();
+	if (trace->filter_pid && trace->filter_pid != currpid)
+		return 0;
+	trace->pid = currpid;
+
+	trace->cpu = bpf_get_smp_processor_id();
+	trace->time = bpf_ktime_get_ns();
+
+	if (entry)
+		trace->data_flags |= KSNOOP_F_ENTRY;
+	else
+		trace->data_flags |= KSNOOP_F_RETURN;
+
+
+	for (i = 0; i < MAX_TRACES; i++) {
+		struct trace_data *currdata;
+		struct value *currtrace;
+		char *buf_offset = NULL;
+		__u32 tracesize;
+
+		currdata = &trace->trace_data[i];
+		currtrace = &trace->traces[i];
+
+		if ((entry && !base_arg_is_entry(currtrace->base_arg)) ||
+		    (!entry && base_arg_is_entry(currtrace->base_arg)))
+			continue;
+
+		/* skip void (unused) trace arguments, ensuring not to
+		 * skip "void *".
+		 */
+		if (currtrace->type_id == 0 && currtrace->flags == 0)
+			continue;
+
+		data = get_arg(ctx, currtrace->base_arg);
+
+		if (currtrace->flags & KSNOOP_F_MEMBER) {
+			if (currtrace->offset)
+				data += currtrace->offset;
+
+			if (currtrace->flags & KSNOOP_F_PTR) {
+				void *dataptr = (void *)data;
+
+				ret = bpf_probe_read(&data, sizeof(data),
+						     dataptr);
+				if (ret) {
+					currdata->err_type_id =
+						currtrace->type_id;
+					currdata->err = ret;
+					continue;
+				}
+			}
+		}
+
+		currdata->raw_value = data;
+
+		if (currtrace->flags & (KSNOOP_F_PTR | KSNOOP_F_MEMBER))
+			data_ptr = (void *)data;
+		else
+			data_ptr = &data;
+
+		if (trace->buf_len + MAX_TRACE_DATA >= MAX_TRACE_BUF)
+			break;
+
+		buf_offset = &trace->buf[trace->buf_len];
+		if (buf_offset > &trace->buf[MAX_TRACE_BUF]) {
+			currdata->err_type_id = currtrace->type_id;
+			currdata->err = -ENOSPC;
+			continue;
+		}
+		currdata->buf_offset = trace->buf_len;
+
+		tracesize = currtrace->size;
+		if (tracesize > MAX_TRACE_DATA)
+			tracesize = MAX_TRACE_DATA;
+		ret = bpf_probe_read(buf_offset, tracesize, data_ptr);
+		if (ret < 0) {
+			currdata->err_type_id = currtrace->type_id;
+			currdata->err = ret;
+			continue;
+		} else {
+			currdata->buf_len = tracesize;
+			trace->buf_len += tracesize;
+		}
+	}
+
+	/* show accumulated stashed traces (if any) */
+	if ((entry && trace->prev_ip && !trace->next_ip) ||
+	    (!entry && trace->next_ip && !trace->prev_ip))
+		output_stashed_traces(ctx, trace, entry);
+	else
+		output_trace(ctx, trace);
+
+	return 0;
+}
+
+SEC("kprobe/foo")
+int kprobe_entry(struct pt_regs *ctx)
+{
+	return ksnoop(ctx, true);
+}
+
+SEC("kretprobe/foo")
+int kprobe_return(struct pt_regs *ctx)
+{
+	return ksnoop(ctx, false);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/bpf/ksnoop/ksnoop.c b/tools/bpf/ksnoop/ksnoop.c
new file mode 100644
index 0000000..7906347
--- /dev/null
+++ b/tools/bpf/ksnoop/ksnoop.c
@@ -0,0 +1,890 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#include <ctype.h>
+#include <errno.h>
+#include <getopt.h>
+#include <linux/bpf.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+
+#include "ksnoop.h"
+#include "ksnoop.skel.h"
+
+struct btf *vmlinux_btf;
+const char *bin_name;
+int pages = PAGES_DEFAULT;
+
+enum log_level {
+	DEBUG,
+	WARN,
+	ERROR,
+};
+
+enum log_level log_level = WARN;
+
+__u32 filter_pid;
+bool stack_mode;
+
+#define libbpf_errstr(val)	strerror(-libbpf_get_error(val))
+
+static void __p(enum log_level level, char *level_str, char *fmt, ...)
+{
+	va_list ap;
+
+	if (level < log_level)
+		return;
+	va_start(ap, fmt);
+	fprintf(stderr, "%s: ", level_str);
+	vfprintf(stderr, fmt, ap);
+	fprintf(stderr, "\n");
+	va_end(ap);
+}
+
+#define p_err(fmt, ...)		__p(ERROR, "Error", fmt, ##__VA_ARGS__)
+#define p_warn(fmt, ...)	__p(WARNING, "Warn", fmt, ##__VA_ARGS__)
+#define	p_debug(fmt, ...)	__p(DEBUG, "Debug", fmt, ##__VA_ARGS__)
+
+static int do_version(int argc, char **argv)
+{
+	printf("%s v%s\n", bin_name, KSNOOP_VERSION);
+	return 0;
+}
+
+static int cmd_help(int argc, char **argv)
+{
+	fprintf(stderr,
+		"Usage: %s [OPTIONS] [COMMAND | help] FUNC\n"
+		"	COMMAND	:= { trace | info }\n"
+		"	FUNC	:= { name | name(ARG[,ARG]*) }\n"
+		"	ARG	:= { arg | arg->member }\n"
+		"	OPTIONS	:= { {-d|--debug} | {-V|--version} |\n"
+		"                    {-p|--pid filter_pid}|\n"
+		"                    {-P|--pages nr_pages} }\n"
+		"                    {-s|--stack}\n",
+		bin_name);
+	fprintf(stderr,
+		"Examples:\n"
+		"	%s info ip_send_skb\n"
+		"	%s trace ip_send_skb\n"
+		"	%s trace \"ip_send_skb(skb, return)\"\n"
+		"	%s trace \"ip_send_skb(skb->sk, return))\"\n",
+		bin_name, bin_name, bin_name, bin_name);
+	return 0;
+}
+
+static void usage(void)
+{
+	cmd_help(0, NULL);
+	exit(1);
+}
+
+static void type_to_value(struct btf *btf, char *name, __u32 type_id,
+			  struct value *val)
+{
+	const struct btf_type *type;
+	__s32 id = type_id;
+
+	if (strlen(val->name) == 0) {
+		if (name)
+			strncpy(val->name, name,
+				sizeof(val->name));
+		else
+			val->name[0] = '\0';
+	}
+	do {
+		type = btf__type_by_id(btf, id);
+
+		switch (BTF_INFO_KIND(type->info)) {
+		case BTF_KIND_CONST:
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_RESTRICT:
+			id = type->type;
+			break;
+		case BTF_KIND_PTR:
+			val->flags |= KSNOOP_F_PTR;
+			id = type->type;
+			break;
+		default:
+			val->type_id = id;
+			goto done;
+		}
+	} while (id >= 0);
+
+	val->type_id = KSNOOP_ID_UNKNOWN;
+	return;
+done:
+	val->size = btf__resolve_size(btf, val->type_id);
+}
+
+static int member_to_value(struct btf *btf, const char *name, __u32 type_id,
+			   struct value *val, int lvl)
+{
+	const struct btf_member *member;
+	const struct btf_type *type;
+	const char *pname;
+	__s32 id = type_id;
+	int i, nmembers;
+	__u8 kind;
+
+	/* type_to_value has already stripped qualifiers, so
+	 * we either have a base type, a struct, union, etc.
+	 * Only struct/unions have named members so anything
+	 * else is invalid.
+	 */
+	p_debug("Looking for member '%s' in type id %d", name, type_id);
+	type = btf__type_by_id(btf, id);
+	pname = btf__str_by_offset(btf, type->name_off);
+	if (strlen(pname) == 0)
+		pname = "<anon>";
+
+	kind = BTF_INFO_KIND(type->info);
+	switch (kind) {
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		nmembers = BTF_INFO_VLEN(type->info);
+		p_debug("Checking %d members...", nmembers);
+		for (member = (struct btf_member *)(type + 1), i = 0;
+		     i < nmembers;
+		     member++, i++) {
+			const char *mname;
+			__u16 offset;
+
+			type = btf__type_by_id(btf, member->type);
+			mname = btf__str_by_offset(btf, member->name_off);
+			offset = member->offset / 8;
+
+			p_debug("Checking member '%s' type %d offset %d",
+				mname, member->type, offset);
+
+			/* anonymous struct member? */
+			kind = BTF_INFO_KIND(type->info);
+			if (strlen(mname) == 0 &&
+			    (kind == BTF_KIND_STRUCT ||
+			     kind == BTF_KIND_UNION)) {
+				p_debug("Checking anon struct/union %d",
+					member->type);
+				val->offset += offset;
+				if (!member_to_value(btf, name, member->type,
+						     val, lvl + 1))
+					return 0;
+				val->offset -= offset;
+				continue;
+			}
+
+			if (strcmp(mname, name) == 0) {
+				val->offset += offset;
+				val->flags = KSNOOP_F_MEMBER;
+				type_to_value(btf, NULL, member->type, val);
+				p_debug("Member '%s', offset %d, flags %x",
+					mname, val->offset, val->flags);
+				return 0;
+			}
+		}
+		if (lvl > 0)
+			break;
+		p_err("No member '%s' found in %s [%d], offset %d", name, pname,
+		      id, val->offset);
+		break;
+	default:
+		p_err("'%s' is not a struct/union", pname);
+		break;
+	}
+	return -ENOENT;
+}
+
+static int get_func_btf(struct btf *btf, struct func *func)
+{
+	const struct btf_param *param;
+	const struct btf_type *type;
+	__u8 i;
+
+	func->id = btf__find_by_name_kind(btf, func->name, BTF_KIND_FUNC);
+	if (func->id <= 0) {
+		p_err("Cannot find function '%s' in BTF: %s",
+		       func->name, strerror(-func->id));
+		return -ENOENT;
+	}
+	type = btf__type_by_id(btf, func->id);
+	if (libbpf_get_error(type) ||
+	    BTF_INFO_KIND(type->info) != BTF_KIND_FUNC) {
+		p_err("Error looking up function type via id '%d'", func->id);
+		return -EINVAL;
+	}
+	type = btf__type_by_id(btf, type->type);
+	if (libbpf_get_error(type) ||
+	    BTF_INFO_KIND(type->info) != BTF_KIND_FUNC_PROTO) {
+		p_err("Error looking up function proto type via id '%d'",
+		      func->id);
+		return -EINVAL;
+	}
+	for (param = (struct btf_param *)(type + 1), i = 0;
+	     i < BTF_INFO_VLEN(type->info) && i < MAX_ARGS;
+	     param++, i++) {
+		type_to_value(btf,
+			      (char *)btf__str_by_offset(btf, param->name_off),
+			      param->type, &func->args[i]);
+		p_debug("arg #%d: <name '%s', type id '%u'>",
+			i + 1, func->args[i].name, func->args[i].type_id);
+	}
+
+	/* real number of args, even if it is > number we recorded. */
+	func->nr_args = BTF_INFO_VLEN(type->info);
+
+	type_to_value(btf, KSNOOP_RETURN_NAME, type->type,
+		      &func->args[KSNOOP_RETURN]);
+	p_debug("return value: type id '%u'>",
+		func->args[KSNOOP_RETURN].type_id);
+	return 0;
+}
+
+static int trace_to_value(struct btf *btf, struct func *func, char *argname,
+			  char *membername, struct value *val)
+{
+	__u8 i;
+
+	strncpy(val->name, argname, sizeof(val->name));
+	if (strlen(membername) > 0) {
+		strncat(val->name, "->", sizeof(val->name));
+		strncat(val->name, membername, sizeof(val->name));
+	}
+
+	for (i = 0; i < MAX_TRACES; i++) {
+		if (!func->args[i].name)
+			continue;
+		if (strcmp(argname, func->args[i].name) != 0)
+			continue;
+		p_debug("setting base arg for val %s to %d", val->name, i);
+		val->base_arg = i;
+
+		if (strlen(membername) > 0) {
+			if (member_to_value(btf, membername,
+					    func->args[i].type_id, val, 0))
+				return -ENOENT;
+		} else {
+			val->type_id = func->args[i].type_id;
+			val->flags |= func->args[i].flags;
+			val->size = func->args[i].size;
+		}
+	}
+	return 0;
+}
+
+static struct btf *get_btf(const char *name)
+{
+	struct btf *mod_btf;
+	char path[MAX_STR];
+
+	p_debug("getting BTF for %s",
+		name && strlen(name) > 0 ? name : "vmlinux");
+
+	if (!vmlinux_btf) {
+		vmlinux_btf = libbpf_find_kernel_btf();
+		if (libbpf_get_error(vmlinux_btf)) {
+			p_err("No BTF, cannot determine type info: %s",
+			      libbpf_errstr(vmlinux_btf));
+			return NULL;
+		}
+	}
+	if (!name || strlen(name) == 0)
+		return vmlinux_btf;
+
+	snprintf(path, sizeof(path), "/sys/kernel/btf/%s", name);
+
+	mod_btf = btf__parse_raw_split(path, vmlinux_btf);
+	if (libbpf_get_error(mod_btf)) {
+		p_err("No BTF for module '%s': %s",
+		      name, libbpf_errstr(mod_btf));
+		return NULL;
+	}
+	return mod_btf;
+}
+
+static void copy_without_spaces(char *target, char *src)
+{
+	for (; *src != '\0'; src++)
+		if (!isspace(*src))
+			*(target++) = *src;
+	*target = '\0';
+}
+
+static char *type_id_to_str(struct btf *btf, __s32 type_id, char *str)
+{
+	const struct btf_type *type;
+	const char *name = "";
+	char *prefix = "";
+	char *suffix = " ";
+	char *ptr = "";
+
+	str[0] = '\0';
+
+	switch (type_id) {
+	case 0:
+		name = "void";
+		break;
+	case KSNOOP_ID_UNKNOWN:
+		name = "?";
+		break;
+	default:
+		do {
+			type = btf__type_by_id(btf, type_id);
+
+			if (libbpf_get_error(type)) {
+				name = "?";
+				break;
+			}
+			switch (BTF_INFO_KIND(type->info)) {
+			case BTF_KIND_CONST:
+			case BTF_KIND_VOLATILE:
+			case BTF_KIND_RESTRICT:
+				type_id = type->type;
+				break;
+			case BTF_KIND_PTR:
+				ptr = "* ";
+				type_id = type->type;
+				break;
+			case BTF_KIND_ARRAY:
+				suffix = "[]";
+				type_id = type->type;
+				break;
+			case BTF_KIND_STRUCT:
+				prefix = "struct ";
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			case BTF_KIND_UNION:
+				prefix = "union";
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			case BTF_KIND_ENUM:
+				prefix = "enum ";
+				break;
+			case BTF_KIND_TYPEDEF:
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			default:
+				name = btf__str_by_offset(btf, type->name_off);
+				break;
+			}
+		} while (type_id >= 0 && strlen(name) == 0);
+		break;
+	}
+	snprintf(str, MAX_STR, "%s%s%s%s", prefix, name, suffix, ptr);
+
+	return str;
+}
+
+static char *value_to_str(struct btf *btf, struct value *val, char *str)
+{
+
+	str = type_id_to_str(btf, val->type_id, str);
+	if (val->flags & KSNOOP_F_PTR)
+		strncat(str, " * ", MAX_STR);
+	if (strlen(val->name) > 0 &&
+	    strcmp(val->name, KSNOOP_RETURN_NAME) != 0)
+		strncat(str, val->name, MAX_STR);
+
+	return str;
+}
+
+/* based heavily on bpf_object__read_kallsyms_file() in libbpf.c */
+static int get_func_ip_mod(struct func *func)
+{
+	char sym_type, sym_name[MAX_STR], mod_info[MAX_STR];
+	unsigned long long sym_addr;
+	int ret, err = 0;
+	FILE *f;
+
+	f = fopen("/proc/kallsyms", "r");
+	if (!f) {
+		err = errno;
+		p_err("failed to open /proc/kallsyms: %d", strerror(err));
+		return err;
+	}
+
+	while (true) {
+		ret = fscanf(f, "%llx %c %128s%[^\n]\n",
+			     &sym_addr, &sym_type, sym_name, mod_info);
+		if (ret == EOF && feof(f))
+			break;
+		if (ret < 3) {
+			p_err("failed to read kallsyms entry: %d", ret);
+			err = -EINVAL;
+			goto out;
+		}
+		if (strcmp(func->name, sym_name) != 0)
+			continue;
+		func->ip = sym_addr;
+		func->mod[0] = '\0';
+		/* get module name from [modname] */
+		if (ret == 4) {
+			if (sscanf(mod_info, "%*[\t ]\[%[^]]", func->mod) < 1) {
+				p_err("failed to read module name");
+				err = -EINVAL;
+				goto out;
+			}
+		}
+		p_debug("%s =  <ip %llx, mod %s>", func->name, func->ip,
+			strlen(func->mod) > 0 ? func->mod : "vmlinux");
+		break;
+	}
+out:
+	fclose(f);
+	return err;
+}
+
+static void trace_printf(void *ctx, const char *fmt, va_list args)
+{
+	vprintf(fmt, args);
+}
+
+#define VALID_NAME	"%[A-Za-z0-9\\-_]"
+#define ARGDATA		"%[^)]"
+
+static int parse_trace(char *str, struct trace *trace)
+{
+	struct btf_dump_opts opts = { };
+	struct func *func = &trace->func;
+	char tracestr[MAX_STR], argdata[MAX_STR];
+	char argname[MAX_STR], membername[MAX_STR];
+	char *arg, *saveptr;
+	int ret;
+	__u8 i;
+
+	copy_without_spaces(tracestr, str);
+
+	p_debug("Parsing trace '%s'", tracestr);
+
+	trace->filter_pid = (__u32)filter_pid;
+	if (filter_pid)
+		p_debug("Using pid %lu as filter", trace->filter_pid);
+
+	trace->btf = vmlinux_btf;
+
+	ret = sscanf(tracestr, VALID_NAME "(" ARGDATA ")", func->name, argdata);
+	if (ret <= 0)
+		usage();
+	if (ret == 1) {
+		if (strlen(tracestr) > strlen(func->name)) {
+			p_err("Invalid function specification '%s'", tracestr);
+			usage();
+		}
+		argdata[0] = '\0';
+		p_debug("got func '%s'", func->name);
+	} else {
+		if (strlen(tracestr) >
+		    strlen(func->name) + strlen(argdata) + 2) {
+			p_err("Invalid function specification '%s'", tracestr);
+			usage();
+		}
+		p_debug("got func '%s', args '%s'", func->name, argdata);
+		trace->flags |= KSNOOP_F_CUSTOM;
+	}
+
+	ret = get_func_ip_mod(func);
+	if (ret) {
+		p_err("could not get address of '%s'", func->name);
+		return ret;
+	}
+	trace->btf = get_btf(func->mod);
+	if (libbpf_get_error(trace->btf)) {
+		p_err("could not get BTF for '%s': %s",
+		      strlen(func->mod) ? func->mod : "vmlinux",
+		      libbpf_errstr(trace->btf));
+		return -ENOENT;
+	}
+	trace->dump = btf_dump__new(trace->btf, NULL, &opts, trace_printf);
+	if (libbpf_get_error(trace->dump)) {
+		p_err("could not create BTF dump : %n",
+		      libbpf_errstr(trace->btf));
+		return -EINVAL;
+	}
+
+	ret = get_func_btf(trace->btf, func);
+	if (ret) {
+		p_debug("unexpected return value '%d' getting function", ret);
+		return ret;
+	}
+
+	for (arg = strtok_r(argdata, ",", &saveptr), i = 0;
+	     arg;
+	     arg = strtok_r(NULL, ",", &saveptr), i++) {
+		ret = sscanf(arg, VALID_NAME "->" VALID_NAME,
+			     argname, membername);
+		if (ret == 2) {
+			if (strlen(arg) >
+			    strlen(argname) + strlen(membername) + 2) {
+				p_err("Invalid argument specification '%s'",
+				      arg);
+				usage();
+			}
+			p_debug("'%s' dereferences '%s'", argname, membername);
+		} else {
+			if (strlen(arg) > strlen(argname)) {
+				p_err("Invalid argument specification '%s'",
+				      arg);
+				usage();
+			}
+			p_debug("'%s' arg", argname);
+			membername[0] = '\0';
+		}
+
+		if (i >= MAX_TRACES) {
+			p_err("Too many arguments; up to %d are supported",
+			      MAX_TRACES);
+			return -EINVAL;
+		}
+		if (trace_to_value(trace->btf, func, argname, membername,
+				   &trace->traces[i]))
+			return -EINVAL;
+
+		trace->nr_traces++;
+	}
+
+	if (trace->nr_traces > 0) {
+		trace->flags |= KSNOOP_F_CUSTOM;
+		p_debug("custom trace with %d args", trace->nr_traces);
+	} else {
+		p_debug("Standard trace, function with %d arguments",
+			func->nr_args);
+		/* copy function arg/return value to trace specification. */
+		memcpy(trace->traces, func->args, sizeof(trace->traces));
+		for (i = 0; i < MAX_TRACES; i++)
+			trace->traces[i].base_arg = i;
+		trace->nr_traces = MAX_TRACES;
+	}
+
+	return 0;
+}
+
+static int parse_traces(int argc, char **argv, struct trace **traces)
+{
+	__u8 i;
+
+	if (argc == 0)
+		usage();
+
+	if (argc > MAX_FUNC_TRACES) {
+		p_err("A maximum of %d traces are supported", MAX_FUNC_TRACES);
+		return -EINVAL;
+	}
+	*traces = calloc(argc, sizeof(struct trace));
+	if (!*traces) {
+		p_err("Could not allocate %d traces", argc);
+		return -ENOMEM;
+	}
+	for (i = 0; i < argc; i++) {
+		if (parse_trace(argv[i], &((*traces)[i])))
+			return -EINVAL;
+		if (!stack_mode || i == 0)
+			continue;
+		/* tell stack mode trace which function to expect next */
+		(*traces)[i].prev_ip = (*traces)[i-1].func.ip;
+		(*traces)[i-1].next_ip = (*traces)[i].func.ip;
+	}
+	return i;
+}
+
+static int cmd_info(int argc, char **argv)
+{
+	struct trace *traces;
+	char str[MAX_STR];
+	int nr_traces;
+	__u8 i, j;
+
+	nr_traces = parse_traces(argc, argv, &traces);
+	if (nr_traces < 0)
+		return nr_traces;
+
+	for (i = 0; i < nr_traces; i++) {
+		struct func *func = &traces[i].func;
+
+		printf("%s %s(",
+		       value_to_str(traces[i].btf, &func->args[KSNOOP_RETURN],
+				    str),
+		       func->name);
+		for (j = 0; j < func->nr_args; j++) {
+			if (j > 0)
+				printf(", ");
+			printf("%s", value_to_str(traces[i].btf, &func->args[j],
+						  str));
+		}
+		if (func->nr_args > MAX_ARGS)
+			printf(" /* and %d more args that are not traceable */",
+			       func->nr_args - MAX_ARGS);
+		printf(");\n");
+	}
+	return 0;
+}
+
+static void trace_handler(void *ctx, int cpu, void *data, __u32 size)
+{
+	struct trace *trace = data;
+	int i, shown, ret;
+
+	p_debug("got trace, size %d", size);
+	if (size < (sizeof(*trace) - MAX_TRACE_BUF)) {
+		p_err("\t/* trace buffer size '%u' < min %ld */",
+			size, sizeof(trace) - MAX_TRACE_BUF);
+		return;
+	}
+	printf("%16lld %4d %8u %s(\n", trace->time, trace->cpu, trace->pid,
+	       trace->func.name);
+
+	for (i = 0, shown = 0; i < trace->nr_traces; i++) {
+		DECLARE_LIBBPF_OPTS(btf_dump_type_data_opts, opts);
+		bool entry = trace->data_flags & KSNOOP_F_ENTRY;
+
+		opts.indent_level = 36;
+		opts.indent_str = " ";
+
+		if ((entry && !base_arg_is_entry(trace->traces[i].base_arg)) ||
+		    (!entry && base_arg_is_entry(trace->traces[i].base_arg)))
+			continue;
+
+		if (trace->traces[i].type_id == 0)
+			continue;
+
+		if (shown > 0)
+			printf(",\n");
+		printf("%34s %s = ", "", trace->traces[i].name);
+		if (trace->traces[i].flags & KSNOOP_F_PTR)
+			printf("*(0x%llx)", trace->trace_data[i].raw_value);
+		printf("\n");
+
+		if (trace->trace_data[i].err_type_id != 0) {
+			char typestr[MAX_STR];
+
+			printf("%36s /* Cannot show '%s' as '%s%s'; null/userspace ptr? */\n",
+			       "",
+			       trace->traces[i].name,
+			       type_id_to_str(trace->btf,
+					      trace->traces[i].type_id,
+					      typestr),
+			       trace->traces[i].flags & KSNOOP_F_PTR ?
+			       " *" : "");
+		} else {
+			ret = btf_dump__dump_type_data
+				(trace->dump, trace->traces[i].type_id,
+				 trace->buf + trace->trace_data[i].buf_offset,
+				 trace->trace_data[i].buf_len, &opts);
+			/* truncated? */
+			if (ret == -E2BIG)
+				printf("%36s...", "");
+		}
+		shown++;
+
+	}
+	printf("\n%31s);\n\n", "");
+}
+
+static void lost_handler(void *ctx, int cpu, __u64 cnt)
+{
+	p_err("\t/* lost %llu events */", cnt);
+}
+
+static int add_traces(struct bpf_map *func_map, struct trace *traces,
+		      int nr_traces)
+{
+	int i, j, ret, nr_cpus = libbpf_num_possible_cpus();
+	struct trace *map_traces;
+
+	map_traces = calloc(nr_cpus, sizeof(struct trace));
+	if (!map_traces) {
+		p_err("Could not allocate memory for %d traces", nr_traces);
+		return -ENOMEM;
+	}
+	for (i = 0; i < nr_traces; i++) {
+		for (j = 0; j < nr_cpus; j++)
+			memcpy(&map_traces[j], &traces[i],
+			       sizeof(map_traces[j]));
+
+		ret = bpf_map_update_elem(bpf_map__fd(func_map),
+					  &traces[i].func.ip,
+					  map_traces,
+					  BPF_NOEXIST);
+		if (ret) {
+			p_err("Could not add map entry for '%s': %s",
+			      traces[i].func.name, strerror(-ret));
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int attach_traces(struct ksnoop_bpf *skel, struct trace *traces,
+			 int nr_traces)
+{
+	struct bpf_object *obj = skel->obj;
+	struct bpf_program *prog;
+	struct bpf_link *link;
+	int i, ret;
+
+	for (i = 0; i < nr_traces; i++) {
+		bpf_object__for_each_program(prog, obj) {
+			const char *sec_name = bpf_program__section_name(prog);
+			bool kretprobe = strstr(sec_name, "kretprobe/") != NULL;
+
+			link = bpf_program__attach_kprobe(prog, kretprobe,
+							  traces[i].func.name);
+			ret = libbpf_get_error(link);
+			if (ret) {
+				p_err("Could not attach %s to '%s': %s",
+				      kretprobe ? "kretprobe" : "kprobe",
+				      traces[i].func.name,
+				      strerror(-ret));
+				return ret;
+			}
+			p_debug("Attached %s for '%s'",
+				kretprobe ? "kretprobe" : "kprobe",
+				traces[i].func.name);
+		}
+	}
+	return 0;
+}
+
+static int cmd_trace(int argc, char **argv)
+{
+	struct perf_buffer_opts pb_opts = {};
+	struct bpf_map *perf_map, *func_map;
+	struct perf_buffer *pb;
+	struct ksnoop_bpf *skel;
+	struct trace *traces;
+	int nr_traces, ret;
+
+	nr_traces = parse_traces(argc, argv, &traces);
+	if (nr_traces < 0)
+		return nr_traces;
+
+	skel = ksnoop_bpf__open_and_load();
+	if (!skel) {
+		p_err("Could not load ksnoop BPF: %s", libbpf_errstr(skel));
+		return 1;
+	}
+
+	perf_map = bpf_object__find_map_by_name(skel->obj, "ksnoop_perf_map");
+	if (!perf_map) {
+		p_err("Could not find '%s'", "ksnoop_perf_map");
+		return 1;
+	}
+	func_map = bpf_object__find_map_by_name(skel->obj, "ksnoop_func_map");
+	if (!func_map) {
+		p_err("Could not find '%s'", "ksnoop_func_map");
+		return 1;
+	}
+
+	if (add_traces(func_map, traces, nr_traces)) {
+		p_err("Could not add traces to '%s'", "ksnoop_func_map");
+		return 1;
+	}
+
+	if (attach_traces(skel, traces, nr_traces)) {
+		p_err("Could not attach %d traces", nr_traces);
+		return 1;
+	}
+
+	pb_opts.sample_cb = trace_handler;
+	pb_opts.lost_cb = lost_handler;
+	pb = perf_buffer__new(bpf_map__fd(perf_map), pages, &pb_opts);
+	if (libbpf_get_error(pb)) {
+		p_err("Could not create perf buffer: %s",
+		      libbpf_errstr(pb));
+		return 1;
+	}
+
+	printf("%16s %4s %8s %s\n", "TIME", "CPU", "PID", "FUNCTION/ARGS");
+
+	while (1) {
+		ret = perf_buffer__poll(pb, 1);
+		if (ret < 0 && ret != -EINTR) {
+			p_err("Polling failed: %s", strerror(-ret));
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+struct cmd {
+	const char *cmd;
+	int (*func)(int argc, char **argv);
+};
+
+struct cmd cmds[] = {
+	{ "info",	cmd_info },
+	{ "trace",	cmd_trace },
+	{ "help",	cmd_help },
+	{ NULL,		NULL }
+};
+
+static int cmd_select(int argc, char **argv)
+{
+	int i;
+
+	for (i = 0; cmds[i].cmd; i++) {
+		if (strncmp(*argv, cmds[i].cmd, strlen(*argv)) == 0)
+			return cmds[i].func(argc - 1, argv + 1);
+	}
+	return cmd_trace(argc, argv);
+}
+
+static int print_all_levels(enum libbpf_print_level level,
+		 const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+int main(int argc, char *argv[])
+{
+	static const struct option options[] = {
+		{ "debug",	no_argument,		NULL,	'd' },
+		{ "help",	no_argument,		NULL,	'h' },
+		{ "version",	no_argument,		NULL,	'V' },
+		{ "pages",	required_argument,	NULL,	'P' },
+		{ "pid",	required_argument,	NULL,	'p' },
+		{ 0 }
+	};
+	int opt;
+
+	bin_name = argv[0];
+
+	while ((opt = getopt_long(argc, argv, "dhp:P:sV", options,
+				  NULL)) >= 0) {
+		switch (opt) {
+		case 'd':
+			libbpf_set_print(print_all_levels);
+			log_level = DEBUG;
+			break;
+		case 'h':
+			return cmd_help(argc, argv);
+		case 'V':
+			return do_version(argc, argv);
+		case 'p':
+			filter_pid = atoi(optarg);
+			break;
+		case 'P':
+			pages = atoi(optarg);
+			break;
+		case 's':
+			stack_mode = true;
+			break;
+		default:
+			p_err("unrecognized option '%s'", argv[optind - 1]);
+			usage();
+		}
+	}
+	if (argc == 1)
+		usage();
+	argc -= optind;
+	argv += optind;
+	if (argc < 0)
+		usage();
+
+	return cmd_select(argc, argv);
+
+	return 0;
+}
diff --git a/tools/bpf/ksnoop/ksnoop.h b/tools/bpf/ksnoop/ksnoop.h
new file mode 100644
index 0000000..caed7fe
--- /dev/null
+++ b/tools/bpf/ksnoop/ksnoop.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021, Oracle and/or its affiliates. */
+
+#define MAX_FUNC_TRACES			8
+
+enum arg {
+	KSNOOP_ARG1,
+	KSNOOP_ARG2,
+	KSNOOP_ARG3,
+	KSNOOP_ARG4,
+	KSNOOP_ARG5,
+	KSNOOP_RETURN
+};
+
+/* we choose "return" as the name for the returned value because as
+ * a C keyword it can't clash with a function entry parameter.
+ */
+#define KSNOOP_RETURN_NAME		"return"
+
+/* if we can't get a type id for a type (such as module-specific type)
+ * mark it as KSNOOP_ID_UNKNOWN since BTF lookup in bpf_snprintf_btf()
+ * will fail and the data will be simply displayed as a __u64.
+ */
+#define KSNOOP_ID_UNKNOWN		0xffffffff
+
+#define MAX_STR				256
+#define MAX_VALUES			6
+#define MAX_ARGS			(MAX_VALUES - 1)
+#define KSNOOP_F_PTR			0x1	/* value is a pointer */
+#define KSNOOP_F_MEMBER			0x2	/* member reference */
+#define KSNOOP_F_ENTRY			0x4
+#define KSNOOP_F_RETURN			0x8
+#define KSNOOP_F_CUSTOM			0x10	/* custom trace */
+#define KSNOOP_F_STASH			0x20	/* store values on entry,
+						 * no perf events.
+						 */
+#define KSNOOP_F_STASHED		0x40	/* values stored on entry */
+
+/* for kprobes, entry is function IP + 1, subtract 1 in BPF prog context */
+#define KSNOOP_IP_FIX(ip)		(ip - 1)
+
+struct value {
+	char name[MAX_STR];
+	enum arg base_arg;
+	__u32 offset;
+	__u32 size;
+	__u64 type_id;
+	__u64 flags;
+	__u64 predicate_value;
+};
+
+struct func {
+	char name[MAX_STR];
+	char mod[MAX_STR];
+	__s32 id;
+	__u8 nr_args;
+	__u64 ip;
+	struct value args[MAX_VALUES];
+};
+
+#define MAX_TRACES MAX_VALUES
+
+#define MAX_TRACE_DATA	2048
+
+struct trace_data {
+	__u64 raw_value;
+	__u32 err_type_id;	/* type id we can't dereference */
+	int err;
+	__u32 buf_offset;
+	__u16 buf_len;
+};
+
+#define MAX_TRACE_BUF	(MAX_TRACES * MAX_TRACE_DATA)
+
+struct trace {
+	/* initial values are readonly in tracing context */
+	struct btf *btf;
+	struct btf_dump *dump;
+	struct func func;
+	__u8 nr_traces;
+	__u32 filter_pid;
+	__u64 prev_ip; /* these are used in stack-mode tracing */
+	__u64 next_ip;
+	struct value traces[MAX_TRACES];
+	__u64 flags;
+	/* values below this point are set or modified in tracing context */
+	__u64 task;
+	__u32 pid;
+	__u32 cpu;
+	__u64 time;
+	__u64 data_flags;
+	struct trace_data trace_data[MAX_TRACES];
+	__u16 buf_len;
+	char buf[MAX_TRACE_BUF];
+	char buf_end[0];
+};
+
+#define PAGES_DEFAULT	16
+
+static inline int base_arg_is_entry(enum arg base_arg)
+{
+	return base_arg != KSNOOP_RETURN;
+}
-- 
1.8.3.1

