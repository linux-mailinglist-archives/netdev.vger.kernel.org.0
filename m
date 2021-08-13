Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1492E3EBDBC
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhHMVK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:10:26 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21370 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234547AbhHMVKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 17:10:25 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DL1BTW021149;
        Fri, 13 Aug 2021 21:09:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=dGXzcssF5FkRLb59x+pQ+esr0VkDnGIDsMpNSdOWyrg=;
 b=l6h/u4lTA4fYE7ZtgDadWGgyOJbUqdDr8wZa4QsAhyF97TvuCjlFAaDyOExh552cULeI
 twCDaMlhk/TVC0B8l3Ohgzmoc+ZLOCQxs/0lEM1pNU0VOmcjBCyhn2JH3tgcbyoc0mMW
 e21ZfDKkJaQ8US4Nzx2fIQK+UCIm3ZtcUIH6HSKqYWi5AW+HWydH5moKtneqzrw70G4f
 3U0QaahI4IcEzGYNDqak5u0GppnoEsg+WmcrXxvkZ0DtU3ZZI+sJwmZqYEji62P75REo
 6SaYD+POUOkqFm9fA9THqfV7AHelcLQl3Ej5juk6JaYIJB6y3rpLRW7ghtkZ2Z80kVqS hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=dGXzcssF5FkRLb59x+pQ+esr0VkDnGIDsMpNSdOWyrg=;
 b=OrIXTcj6lKomVcIPe7o9R6zi88qDtbOwlFTgoc9BB7KAoQsR2hOcqm8a4O7EPOCoPcoo
 MBVHnPxSzsPf9P/6EsLbnhytRa1F2amm5Bf1ERePgIfrX3mjxkPB7/3pFPlTX9Nhd6Nt
 Gyy4jvS1zAFvb0hAM/AbSay+gULPhe+By11ejxrdDtbyieDCHynC5ARRy4iPEa+F+VkV
 +JiTaxlhdNq8wwQ0wIm/qw+MyBvOcRE2TnSESxCi6d+YYmVVhXWCf+8bE0RStQ599fzJ
 0DofGXWB0xQKwdN8AHlPkkUyFliAuRSH//G+QaN6vi5sD/G9hcDflCTkKYgaF/K6oSk/ MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acw9p4ew5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 21:09:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DL0avA102348;
        Fri, 13 Aug 2021 21:09:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3adrmduf3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 21:09:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afNktRr7sdkt9Owj+Lrc7S6qaWv7QYPh8P6/AyVVKh5DM1w/j1wsXDJMQhv7jsghQ42/PViTLwE5Yv1DRjfn8QrhVI9PwkMKgAfK2g6XjKPXbClTQ/vECgBnMx31D+pTLxPtD/6d55T/Wh6WnkS5YHBYUf7QhBbeKc4rhw/GzuebwdpRAzTkazpZJ3fgoe6Oar/1HzyA4XxcHXG1015HcDaS869d95UEivcKcb2h0roFewzyeElIP2zUUIEiBV6dyXYXkoHr0b2QHU/UaAbHU/rn8aKUCVDsRKCZRmK308p4J7HxSxHwwl1WHYDJLB+xUOaBzPIFjoZyWqgv+vi3JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGXzcssF5FkRLb59x+pQ+esr0VkDnGIDsMpNSdOWyrg=;
 b=BrF8kCBiOdJd38NVEcj86yZ+IZSRPC+R1aO5Rs4y1bErfrNCLP2+m6gHSUl19ygU2gPEVBaJ+uQv3+wd61F0K3CiUNx6MyBDaSAYDMUggdFgdUOlw1IrzHwZosaaX8C+sKzBis5xPUVP4GXA4VDjLhW4K8mj8xavoXqQObRnG/tnSm8YMWTjQwI2bVqr+tC/2tr4oVNGWTGKKuCJ7TgbXNSqcvsnL2LxtfqoshAbG2Y9x95J6gn+4KpAt597p9LIiF+tL2JhngKULoaSVVzkhQ+av8EAm7rkc82h/LhyR46gM0liCYY00fKzxaZ54qQfg/uiCvK0vJYvp4Y+V0WNog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGXzcssF5FkRLb59x+pQ+esr0VkDnGIDsMpNSdOWyrg=;
 b=SV/8NSFohSd7EhMDPkHtq14BNiEHgBfyPqMIGX3sw6c8KwhtO2+OxnLNVh6yNN/biCwahsll6Lk4r+O6o8vNrOW8KSzTm0ud6qp0TOe6/Rx0/kIqOMFA19pLLt46qEd48i4i0gv/EnkzqDeNZBRQirStgfNW6k6o59OuQML9b/U=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1359.namprd10.prod.outlook.com
 (2603:10b6:300:1f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Fri, 13 Aug
 2021 21:09:40 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 21:09:40 +0000
Date:   Sat, 14 Aug 2021 00:09:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net: 6pack: fix slab-out-of-bounds in decode_data
Message-ID: <20210813210922.GD1931@kadam>
References: <20210813145834.GC1931@kadam>
 <20210813151433.22493-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813151433.22493-1-paskripkin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0068.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JNAP275CA0068.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Fri, 13 Aug 2021 21:09:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6f70fe3-7518-4634-f477-08d95e9eaa32
X-MS-TrafficTypeDiagnostic: MWHPR10MB1359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1359407B12E1B009D3B991318EFA9@MWHPR10MB1359.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJz8i4mnS7Y1BnkevE8a2fODU1YVcQQK9HcNwvbHPyhJ4pAwo0WMyNsHutMza2Qsrg7qZYx2pwfbcMbRb4qJaMR4ujpbC8v1eSXipSe7SxufdVFlsVMMZjC1BF+y8eQLOr6RGWyvlMT7QHpvW9cMhMEtB8SV9E7zwOMeD8VLmhuQM/KWoLv1mvfWJvsPVRmzv36j4oMJ4Xvrkh4h77RROqehzBfqnC31igggYHVD0jC0qgf+vJHswnLk/PRigNp+lAwUXAeuqllUi+c8PBUdMBassjCKLPqWblE7NwoW+Vv0K1Dpq0yxEjuzb2iOu8YXbxermZkcnvJFCrt2CXCoM/CdCRog/BTJnkt1UT/n5IWqRB2LeTY2FoNWG/OwLBgK1Vyi1GYGe7x8yw49kyaaDOlGeHcl8NogkSeKFt86KWlNrlBVF1lfsoV3/IDYyoF9JcpsHpiaddwMJGK2xhmp/QVYezWCfW1rp+9NJsw6AJBSjkvbGodn4PlR3QyVuqXp75gh7/fHVX1fRy2wPxFIjAB+5fa1/4TE1CQ/sj6y2+yiA9EViVfKiCcpUWA1eS/AwjqYJNlHEVEO7UAJi7qe+p5CBGrkPqGm/dpQWRDGZxw1mn5Ip5LAvDpoYhXsiLXxF0rK5kGtkBmNV+06iGjNozOrsXVrYXlDj/xNVdD+6BmtyGqAgEi62fnM78BBpphVJ+//uOjNYYATozRtRltcjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(136003)(366004)(4326008)(66556008)(66476007)(4270600006)(2906002)(66946007)(9576002)(44832011)(52116002)(33656002)(8676002)(8936002)(956004)(316002)(38100700002)(5660300002)(38350700002)(55016002)(6916009)(33716001)(558084003)(1076003)(6666004)(9686003)(6496006)(86362001)(26005)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wOFqPX736GAjbnoek7xeCZIRSs73ygOsHYieRrhfKrVpA+ruSYG+tnyZoaEL?=
 =?us-ascii?Q?hKtQ/NhBNmDYIdUIqMqR6FNq2jWXMdzlfWRpzW5CnEnnBEBLrPtuwxkOs3zm?=
 =?us-ascii?Q?s42X9GDj2LRn2OVNO/2vxqesFzEizSUJTgVVnP+JvPk13TLoF6Plcp5hNYFM?=
 =?us-ascii?Q?NACJSXi0q/R3A/yY3bu0CdlVbffuKgb+btoJAkqSmOEwP5NnWSTDg8Sz1TRv?=
 =?us-ascii?Q?RsF27ISl6OqeVO21DDlK3etMYBxTmj3OjB12ZFeHoekXc4sSKX+vpkzDi+yS?=
 =?us-ascii?Q?EiDkib0hfkkjY4Z4FGnOztyRVgRBYsw4ZPW6smcM5IC529m12ijHlTMJIIen?=
 =?us-ascii?Q?x0qPpa9Bdnk/fgChVHZnElZjfUcVQnZlb4dXOjABal2CU5RKA4gFfEhO1lNG?=
 =?us-ascii?Q?jUqnSgQ2C/aGZcnUWQuBUPoBdpLolV1ub59E5I3lY/z23QkSr6WdR55kc9YT?=
 =?us-ascii?Q?kuSkdZLVoNdEhxAYS7QapuO3b+Ia8obUrvVuLcC08P989mtnyXDx5vkW7DvE?=
 =?us-ascii?Q?QteLysGejSOoAMyV9sQ9VHX6y4Zbr2My6jkaQo195vurq0voGrSsg+3SU2YH?=
 =?us-ascii?Q?4qRK1MP1khnLR0e8q/GR/M3pIA92RKzXR+LMROUhP0Cnz5L6iIhh2diGreaS?=
 =?us-ascii?Q?9A2YohyPywGSErWx/ng4ek2oG6fgVANpsxDW7CEHBU14uEiJhSWslU7oB9sC?=
 =?us-ascii?Q?9nUfXR/s84EHJx2hfDwsqR7jswEupvykfcjZ9aOUZ98lsIhohgRKeo/YtkbK?=
 =?us-ascii?Q?MAf04lI/wm+Bk+p6UhZimjzEwv667iw57WARfHzjoE14bXQ8QUhlqjb/p8tF?=
 =?us-ascii?Q?5dfjQ0DYyhpwOTL8jM69obQdlgP1Pr4lXBgccUCDzoo8KnZUBb1/eLdz4Wkx?=
 =?us-ascii?Q?oW3EnmsON1/d2qt3QtJRsBNKEPcI+SBkAB80WdQOuH4Y0+uctOZSGZYyoBSg?=
 =?us-ascii?Q?4IP46gonb72mI3eHv3EUiO2ARmVNkqgL0MFYx5hxf5R08n1Hmseo3iVA0+r1?=
 =?us-ascii?Q?BtW/frdqj2PmyAX4TUdod9xyJ43G82ILvOQcipkX0VL6wBlhT2zqayJKNHsK?=
 =?us-ascii?Q?C2jIQNhuoPkKUXuqOEB7iwjVnm1HOVPQr+pcJkkQuECVgsVmddKRcA+yRr/l?=
 =?us-ascii?Q?EjyVr8GB5YOU7zRSjSSzPO8FNf533R8WI9TT9+esUMufD+vMzohVUhZlS45y?=
 =?us-ascii?Q?juiygKsjzquXGIv6Jd8yU3FDF3obgv/Ch56krxOVq1ztMEKDcru//Bg/9ArS?=
 =?us-ascii?Q?1GQpUYOV307aBj03WkbDKCfhH4WquLTkheF3FHCypBKWIF4vBZoi6AyRoYjI?=
 =?us-ascii?Q?NPK5rMz7miSVYRxeSYNu4/z9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f70fe3-7518-4634-f477-08d95e9eaa32
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 21:09:40.4934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OPqgTccnqQFuZpCfJGMlY4M9zFPeKo9j9t0JtRG8CatoERyOW2OF5ZJNPyL9yT3mN136pwZgj1IUV1e0K3fVJN11VsEkgfDScg4xVhOmIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1359
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10075 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130123
X-Proofpoint-GUID: pbfVlCy1bYUcivwDgIjI24khocDHJvdZ
X-Proofpoint-ORIG-GUID: pbfVlCy1bYUcivwDgIjI24khocDHJvdZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Great!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

