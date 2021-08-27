Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B573F9672
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 10:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244675AbhH0IuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 04:50:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56476 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244510AbhH0IuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 04:50:19 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17R6Io4t025608;
        Fri, 27 Aug 2021 08:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Lo2LmUwwIEhKYcnPzXF4BKEpF0KR/dXy/Jh2Nyr2WD4=;
 b=JEuEJCyE1tzULvtSmn4Ht1eMKjwNP+k0ktLIL9gg/LN4FipxCoDUmfQ2RIe7/CUxI3j/
 HLcRw3Wr8lwP4uOCslc3zvSOv+ZUSr9HziOyZrWYLV5ozNuRPKH95WPHqFN40TsUc/9+
 x+VAsaab+gMJg8QfM6iKule9ZuPHVs6RnLqtTX0txbb43sekALPim+svTkAya1GL3aEZ
 Q3pXILQ5W2ukxs0chyAEkODXr8ps6ZFWh8N9tPlZ3qEWXv9ugau0NKrJvOWoDUqrwgpZ
 HB5yDQZHI6EJMsbgvLQj/gEhdfIfM9dVe1pQtLTDyKzgaUY4h4sf2htB93mGLtWGaSER iQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=Lo2LmUwwIEhKYcnPzXF4BKEpF0KR/dXy/Jh2Nyr2WD4=;
 b=AZueuJDD5Yo4o1FfkmcdnKvReO3mVyclRBIujI1NN67ctVPpiOc8JpZlGROKRoy9TRXn
 AHgY4uN5uHChoQ0XIQ05WkkzUMa7e4UDTNSOYUEOCFkh0iawlE8iYYhexU+90zT3VZ87
 DEeIsutUSQkzwyqsIP4xKUDPzoOOST1ViURyIsQ1RJO+ygoQk6A+HP3k+664LuwSvrNj
 /hVOQjm0GBmsNq+jH8U9dxrDFSumBlFYrr9k8zK3aYhK+A16CaWOUG8adkR5HC+1ioAH
 NK5skR6l11CeR3uHd7WvviB+RJ+ICXgY6BFtwDDsQu3KWK7zryRUqbpiCFvOLtPjhOY2 LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ap3eau6fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 08:49:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17R8jllv071634;
        Fri, 27 Aug 2021 08:49:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3030.oracle.com with ESMTP id 3ajpm4a5da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 08:49:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIxg2sfsOSZExq4hPjWvWOjS2+9mzrGDAAxZgTcBA5lmlHF6Ls7JXJOjPADxDKwfGV1KTyOEIaVajzWPNKjRNuA4ZBudz9YbVzda1MHMdKFjO18/E/w0PGQgJCcMQJspP2Mg+y+8EBWimdB2LNHhM941HqW2zztM9HGRMsyZoWkGWVFm3+yriKnLAiqZksefnrQYuKei6C+sBuKYYH2vJ+tPQzcRA1mMP2mbf18VRL3SOB/2I7Gp97U2Vcop/lsJEvlVso6PonhWtavExfKTixbKhC8X3et8C/yzJgNe0asbLOpCqtza3rrn6o1SlInTsbQrm31fdCp+nlGXlVR20w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lo2LmUwwIEhKYcnPzXF4BKEpF0KR/dXy/Jh2Nyr2WD4=;
 b=f2zA4c9ui0tgnXCcaBd3pRsCX38kLTuda5oUQpMv5RidlY4+si3Cn0upzVPJafYoQrMD6GvICqhkljf8DvamECWp8Ay5w6/oWHBUVNdRDyEk974ld7x1rwwgUz982CINCPU7kjcNH6099OsKn6pgsaYlncMKoJdIBC/T6Zh7iQKC9rvjXzn1UmlH5Cauhjfe76I2MIrSW8LpAa6at0GqdTMLhPK8U1/XOMo8kj+WydJyIQ4nTZ7TscXYANKYBXpjHtD/hUVmmDK6NBjvZysEspJtd9eKwjby9SkY7Wt0RqnZuoFjZNECw47nDLr53GRygr69Us6+mWiP3ItsPpTDgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lo2LmUwwIEhKYcnPzXF4BKEpF0KR/dXy/Jh2Nyr2WD4=;
 b=T9p/W6mxz/um5npVXHMxmy+ZEytIE5v8g6JUtTx+WTW2JRzSrs0xFkQPDEFvwftG00T4LB6YLzyiz2ByMhj5vtEWbI/cKdXL7MO5MmQ3OM7FgpA1JJZqRDB/Q9uygB+R+MP5ilPiosgxw5eTilqs1d4ZvP+vGndXrDHu/lH12/U=
Authentication-Results: linux.dev; dkim=none (message not signed)
 header.d=none;linux.dev; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 08:49:24 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4457.019; Fri, 27 Aug 2021
 08:49:24 +0000
Date:   Fri, 27 Aug 2021 11:49:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     yajun.deng@linux.dev
Cc:     netdev@vger.kernel.org
Subject: [bug report] net: ipv4: Move ip_options_fragment() out of loop
Message-ID: <20210827084915.GA8737@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0117.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (62.8.83.99) by ZR0P278CA0117.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23 via Frontend Transport; Fri, 27 Aug 2021 08:49:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e200d606-812c-4818-51ef-08d9693791cd
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2365D682571FA4C5FEB19EF28EC89@MWHPR1001MB2365.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAx1zyYp/4TkwxkaMS3cebKRYF4JESuR1Nq3MGVD0vdWEJIwJ/J9yZlcJ5KdyRDAuf9XUG6TU2sFWiOW4Rr2EG49gnwRlHON+kH3RHAD3cz4kvzb+KHRb/PO6xBxnCg43lpO+MZH+EA/gj0sacnUyAXLFYGas57O5rimsLDQ6wSizRRObmAzA8+Sg6Yvq4RMC8EqJkv92BRm8GlG8YhilcHqbdyXCO98Gyvj6yoaD8+5O4Q59YSBeNeHAE3MpwU22qXiLx8MgA4G41imXOeSP2Lb/HKqUH+Up/nctGW/ildnHDcT3lxvZL4SHBxmchj54fB2jv4/HenBxljq96GbgGkykOyi5eFkstQ3dhuQcAIjLeNM1F2h2uSn1aYfRoxij6dWStyxVV9QrQNjNUTAlW1P7NjN6+AsiFj5pqHw2oSLPLGfMdkzvjRsq+oR/4TYiE5ynBKofKzpe0jo0aeCroAuI/WSpKtHp7URuEvyNCuLu7PD1WnXaOVXj8WnaEnBY9HOw65nNFxx2n5/o0aSu8//NQnGtTVbW925HM6z2PjBlIJTfLJO7J9M/lRGHIJb6VtNscrWgAFuU/T1DQZhMONz3JaZEaVs+MsmQb6a346Den3cRbfofGtSPrNvh3zr6GKCPQ0/3/SlBOlB8r2uoLBxUU5dENWlCRQV/9lcrL680Hhmmqn6odhjMnktrm2XVoBoT8NGZ8VbcnPuUqbyQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(136003)(396003)(9686003)(186003)(316002)(6666004)(478600001)(9576002)(4326008)(956004)(33716001)(52116002)(8676002)(1076003)(6496006)(8936002)(86362001)(5660300002)(55016002)(66476007)(66556008)(83380400001)(26005)(66946007)(38100700002)(38350700002)(33656002)(6916009)(2906002)(4744005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1xOfk2Sc4o5lzeyd19I4fjBnfb8Vpxt5wewECWsLS8Ixr2oC1yCxdY6qTOXD?=
 =?us-ascii?Q?S9TOYkyZD+dQiBLtmXDMIAyziO2jjOLba0GRTdnRQ5HucBiVjk6wiT0JWkXT?=
 =?us-ascii?Q?YTTQSgppuknsz0g7TF3J+2yIwZ+xX20+CcqxfwaGRXuDdC4Pz9RGlELdHxXi?=
 =?us-ascii?Q?ItiowHLGZjhoj8vPoux2RC+B6aC85pqf6CXQmhzMOHlg7AJ8FXh7Hl53Hsms?=
 =?us-ascii?Q?aDInb0i+bpzBKMwj2oNBvJuLqLLnJQi7Og9d/NofRbK8D2skK+dx88Yowhdr?=
 =?us-ascii?Q?fSklR+FxRPMTZHaG31vpIM7X3i7zcoYpdzbpMCjXPckRYb7Sa5q6D1sWLxa1?=
 =?us-ascii?Q?R9t+1S7zooXUkNH7ptOeBYmgFcKX4Zu23itsRh3rOdwq7wRYTMTld6agar99?=
 =?us-ascii?Q?zif6stSijdvMkeKURhK0PIaPNN5SoO/PtxISkt0Zchr+WyFHfY59zcwpHWqU?=
 =?us-ascii?Q?xrDszb57mKZV59cndVdZlCobCuzfI3e5xnAqheWdXtRFQ4roYrFz2IjuyBEu?=
 =?us-ascii?Q?YG/LRpl/Rq9FlFC1GAXMJ25/YOhpMX1raSn7JDtbnZQbpGm4/nS0Ay2iSHfN?=
 =?us-ascii?Q?baMPIsVPhgfEY5skFSix+44VGd7AU2baza8wDo0HhRBiieB1pgblGwqzwWwo?=
 =?us-ascii?Q?m1QHCjNptb29fmpnlwz4R5H7O/AV3pZU2lYQZi6BSFzvpUROqCGGjbf608ah?=
 =?us-ascii?Q?jdJUSTD49Cjd2aTEcXOq0iFpWdoE8BX7zFDGkpDafJdn14o9xFfXcPRKpojn?=
 =?us-ascii?Q?xuvQ5hieVJbMsUFmKedIbYc7ZZ4HM4t3sWsp5T96JIWyrJT/MpPUOihw+m+6?=
 =?us-ascii?Q?/SJjxjbTch5nO2TsShkGe31pJY7hUD16i+ryqjbIOv+OyDax6e/zr50xutcs?=
 =?us-ascii?Q?6Z+WxEesXXGPecpcJHQ6OWB7USbJUHfZdiYvZBBDJ++J+WMH2S1hAXstaPEQ?=
 =?us-ascii?Q?20nty4JBCIXQ/FvpPiAajmsgJDtn/Ix8s61GaigMK5qXH3SbwV7CcmdlEpnp?=
 =?us-ascii?Q?YscmhLkiR1811xzHZAbWgmoDBbVZK/du/muut7DpTCiUAx6Ju4ue8BqQab5i?=
 =?us-ascii?Q?35tlCaNLoQ3g3q30B6lSXmmMWiDluiA+atHUtHs3yjWb2U1ph67ctcJSxW9q?=
 =?us-ascii?Q?87GKjS9VhCSFrAPteXXDP6tjTVl4e481ikB5TE8dQLYjClhezTEXPdGv1jjp?=
 =?us-ascii?Q?vFe84lSwdcrBs5HSM5tcOibkXFzDGxRuE9GEXM1S4enlW4yeZ1ruPbGnCGQY?=
 =?us-ascii?Q?lpv2u8FuFqDYkGAekbpNwdOj8fCks00VgMS3jSYM7ZdkYCfEk6xxa5ifJPv6?=
 =?us-ascii?Q?tqxRa94EHZyGzmF0FsfsIKBA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e200d606-812c-4818-51ef-08d9693791cd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 08:49:24.1033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fjkp0qT5c0vQpeiM5sExUD9f2/mQwSBvsTrNE5F5qvyRuVryTCHG+ABeBcdEJgKbMjI5e0WiLRMRVYD2BdCmzsJZppmrvE0ls2cskNqymEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2365
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=643 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270056
X-Proofpoint-ORIG-GUID: EORGJRQxUO7PQs9XYG8Go0DD_WoWNXvP
X-Proofpoint-GUID: EORGJRQxUO7PQs9XYG8Go0DD_WoWNXvP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Yajun Deng,

This is a semi-automatic email about new static checker warnings.

The patch faf482ca196a: "net: ipv4: Move ip_options_fragment() out of 
loop" from Aug 23, 2021, leads to the following Smatch complaint:

    net/ipv4/ip_output.c:833 ip_do_fragment()
    warn: variable dereferenced before check 'iter.frag' (see line 828)

net/ipv4/ip_output.c
   827			ip_fraglist_init(skb, iph, hlen, &iter);
                                                         ^^^^^
iter.frag is set here.

   828			ip_options_fragment(iter.frag);
                                            ^^^^^^^^^
The patch introduces a new dereference here

   829	
   830			for (;;) {
   831				/* Prepare header of the next frame,
   832				 * before previous one went down. */
   833				if (iter.frag) {
                                    ^^^^^^^^^
But the old code assumed that "iter.frag" could be NULL.

   834					IPCB(iter.frag)->flags = IPCB(skb)->flags;
   835					ip_fraglist_prepare(skb, &iter);

regards,
dan carpenter
