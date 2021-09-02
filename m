Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D108A3FEB28
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245411AbhIBJ0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:26:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50424 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245222AbhIBJ0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 05:26:47 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1827OG7u029873;
        Thu, 2 Sep 2021 09:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=8fsHhuc83FTU6GWim4iwayQWp7BoHbJ1ZfPOrd1w42k=;
 b=Md7m+IaJ+izL7WMDrTk5ND6wHNQiEqkKf8FPBqPz/fN6AV2/8/J2aw5sTXXIz6Oq79Fn
 0Nf8zjULTfz04aJ2mSLE0q+dYRYuLCvQXbLIRvdYU4ali/Nh0l+k4bT9IrwGTqT0m76X
 /OfZnUD010U8EXXhlu9mA8PgVl1xVqzCvCgUPRbGsyr5cRkQhG0JY99xpa06QQn5O+jz
 hH0+knhoid6SXcCSIUkGB0XFyFZHHgST/gu1TjXFf3Lex56Q/qPbP+XfY2umukAs0fvU
 yXN3j9L3NXOGHZsT+G3hciZ8qCprofxu/MuIxHSemc8rTt+VcxlfmqiK9se5DzRFM7Ug kA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=8fsHhuc83FTU6GWim4iwayQWp7BoHbJ1ZfPOrd1w42k=;
 b=M2mzfhrtNiEF3wBf4iE3DNG9O5SPcHV33VP5uTN2xbDKvS3ofkxgpb3trGVwDIWnIM1T
 HcfzCzIFXYmfla9M/BGAdwAS/HlTeLJoeNB0Jx5WSmZ7kKC7/E1mJsHGfeyvUg1Exj7h
 bCs/64qyH6ysOOqBrsXP+jSCTdfxLzif5wmtkr+kTpU0HtJLPnjAFEYupMoqrTK9BpNt
 lP2dO8FqgNwcuVGksW8yOZABJQONUysUE0KWIQf3fMjCiPk6oDoXdujoHhh0etQrTxGh
 E2gplJh5m9gxVmX94DT58LzM1vNcg3S4NjMeb3MCrINLklk8YlXvOOQmXgA92meDKoY0 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw0j3a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Sep 2021 09:25:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1829Jibf109784;
        Thu, 2 Sep 2021 09:25:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 3atdyv8bjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Sep 2021 09:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMfiyOzegPm5m1x6YTzhRaYFcy+jDG72zBCRel8RW17E0jx7Q95Ewj3ISnxv5hTR9d7X7GVkQRJA+19IB4ExUtUXIIf4ACweqq3xYeZlf2TQzyWJSOPDKWdV84aiCTmdI2qRMGri/C2Gg6+2VZhyCgM6G48lqyTS4oddllKaOCjCeU7TorwdY3ASitHyIg9RmgmDc0KRb49wah09k4KusdRCHHgSs9qRflsMhWZah69GVTT7ReXDPxR25Oa6GEtTD785fi6wg8b0mZlf+fnaisknT5+h96mOnvO3kGsbIIkjD+Iz2uQfV4NoQ4X1NnwowVtXm+3V13CWLjtAOh1xFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8fsHhuc83FTU6GWim4iwayQWp7BoHbJ1ZfPOrd1w42k=;
 b=IgOl6l60ZLMKb0uVM15z/UY/dN719GXwGZ4guFEK6v5hV8xRehCTSl8uLxwRRNvg5vhTmE1cPu6nDpUDmzYq5YrTAQTie9SSvUD7eGDNGNtslLMYCvf1NszTFVWzQX7i1OMSYam4L2lJD1RAPRq1wf1tf9XFiOafKuBldvywjsrghI9SJxDUzTsbglK/Jpx7zQp35vv3IaBMmLkiOVJBWvsv8AqM0s40mzvb0KtBx52TWG+agmERFqqYOdgHfpfgvBBA4XDYzglgGUcQcn5B/QepcWCg0R7d3kbdbn50/E/gEQrLybFjNLjvz8cd2bHDUAgHwnVM7hYKesGGA9w8Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fsHhuc83FTU6GWim4iwayQWp7BoHbJ1ZfPOrd1w42k=;
 b=ElV5imwz0ijm5HRSw5Xmk3g4b5b4WiKKUrZu6VBT4jEcu+QKfp0ZWlnd2sdMAy8/fOf9lsamzD+VSECq6LYgJlvmyTVoLCzgztI2zVsfNOPDrHG9F7c2B7mPiIlEuwolM0BT9N9NTAIxdOzr8n1w1Cv03W0mRIZSsIv1ZfPRvvE=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1568.namprd10.prod.outlook.com
 (2603:10b6:300:26::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 2 Sep
 2021 09:25:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.020; Thu, 2 Sep 2021
 09:25:39 +0000
Date:   Thu, 2 Sep 2021 12:25:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srini Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [GIT PULL] Networking for v5.15
Message-ID: <20210902092500.GA11020@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZBOymZNNdFZqPypC7r+JFgDWKgiD6c125t3PnP1O309AA@mail.gmail.com>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (2a02:6900:8208:1848::11d1) by LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Thu, 2 Sep 2021 09:25:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 133d47b3-95c1-4a4e-cb76-08d96df3a0d4
X-MS-TrafficTypeDiagnostic: MWHPR10MB1568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB156816DF141AAAE9D0CA1CDA8ECE9@MWHPR10MB1568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:177;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vu/8webNYA4EnBZ0yCF2iOpdrJODomzhj7jdGKob8izSQphy/mY6gkDBjvToe6yeizDDOh3giWA6fqD4ffm5I9YzZH2jwlYiyrAbE9fo1n9Lc6fjaEec1xTDhhGmII9/rMe8uSsENehXZPDIgFfP127JChX4zJgM6Y0aWg6bKxrwgSC4MkqxjWdSC9KDGRGiZ1w5DvHcTFE3jvXkJqirYvZ1k5b84umoCyKoqPOMOipxqZOpbXojeeJbbV/jh88/BbI77fDfwrAOhalkoRMu8FBSxlr9xMs7Zgm4lSaRz2r6ZDFliKNvWgp7M+ilp0qtMBB7wVaj+Mlsel0qRPKvl9Dv44RmUw9CtwiIFSnAeHANzlOSsBlNC0kAWRYPquXjCNv8qAw4WeObY0oKiyMfs9ld339SE98LQZXxm2yFqTZHNeZk/hdADzmbzi8zFuMy9XBKuZ7GNuzTOniyyvF+YgyKKFCPRTAFKq7KymWD5nK+vQz4lTq5RMObth6Yv3SzEZryan0lxvJUxzZ1l1hHXARzEL/fJwHTPhfyMkee4PVuOsGn1Kgk9dUY7+iNA6AAaqu6YIxYdHiPf9WMJSLq85dnTQys8PqRFimuQZj4SLu4o+SIu8XLLH0qUTy9T9m+w7mCKBHCYoGnEr4s+PDujQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(366004)(376002)(39860400002)(66946007)(66476007)(66556008)(8676002)(83380400001)(6666004)(478600001)(54906003)(55016002)(6496006)(52116002)(33656002)(9576002)(316002)(33716001)(9686003)(86362001)(38100700002)(2906002)(44832011)(6916009)(186003)(5660300002)(1076003)(8936002)(4326008)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ULJ56He/GtYehqf54OIOj53PL94TIL01itcTaJmaMPFNA/ePRL/eRfoJmrOi?=
 =?us-ascii?Q?AIb61AEt0jalR5dDi02xpAX1bCb9Bv7RbIegqdPsEBkY/BFjWEHHLP5gWXn3?=
 =?us-ascii?Q?/fOWhrwk/ughL8jh8f+MTLDg/UgMih+RqDwJ1M2qGKZyseKm9WoIoNRtLrLe?=
 =?us-ascii?Q?bpQenAap+SZAjptFUupa2gXSCnEqv0nehjEDChO9btF/3LgqATwSPostbi/9?=
 =?us-ascii?Q?yoqhoUnZSdMcB5KowAotX1hcerYfoxc5Kd/A51U/r0Ygw33HSwPP3RB5oK7j?=
 =?us-ascii?Q?Ztew5iFL8qBo7Mp7Dk+NWe/wIXNB1XHxae7uJiYu5ABRbTT09k1xsH+l7+RU?=
 =?us-ascii?Q?w33BiMKTcAZwbb1y12oCzM666VpNdt+DE7HguASsbFhjf/T3jWJ65/D21OBB?=
 =?us-ascii?Q?zhrTiD+pNXP7iS+bUR73Xx0NmZW9EAN8o752Sih4+mshS1PRt9imTFEZxxre?=
 =?us-ascii?Q?7dD6QkarXWIPvr+ztfhw3oiOK9d1XmUBTGsJUm2IZ+alKuK9cbAVchKO8H7M?=
 =?us-ascii?Q?GJdILSk9713rL8rStT+RnRpooS1B6PvpVnsN0nl536wKiSy18lyME7heN0/I?=
 =?us-ascii?Q?HMy9hPtZRjVJ5Dlr5gGNQEYw+lGmzAZ1OOMpgH5T20N0ik9ypoVEjx/0fjTx?=
 =?us-ascii?Q?yYuYn9SgPy9PjBjBG/35GmLZwzK5PS5hcLjtAzEm8HWxJBamusH8BKUeUnnv?=
 =?us-ascii?Q?NQl6RHI5cr+nBbyUCCoI00+43hk0J7AdvZ+tICn2LOKGKqUcz5Mr2FDwiMej?=
 =?us-ascii?Q?O1nL5T0kCS/z74Bzodq6EUWYTM1BPSzdM4YF4v7MMTYUZYDnc3MwBsWtEOc1?=
 =?us-ascii?Q?OB/2l2bIQ4lYMSH/mJ7x5WSvtPY/OE++E7845C/Mo87G3i3GidBli30KrLfE?=
 =?us-ascii?Q?ni0aX6D+CR5p6d31nXfxSmVVSXbiAE/6boAQMSqwy3OUopb00tIizOH1GSFr?=
 =?us-ascii?Q?tmz/d91BqGthAUFm3ILWbGvZzyEoG83tw7Kz+57MRBbeLGVJdvLIiDj6gYC/?=
 =?us-ascii?Q?TpEvT2pWWPZN5F+8cQPq+wpF0gZJkvBP2QbE8f0/lw3J4WEPn022pAhGjudO?=
 =?us-ascii?Q?KvbRzKQzBCWlQM97pVChBhh9fIc0ww6JhT3B5t0gXgO71nTYLLC4VbVPA/b2?=
 =?us-ascii?Q?PU2cWYmc7nHvdUDm68hmDqbXMlq/UUFw5k1sErfKHZt6tjhV4UNdXepC9XrD?=
 =?us-ascii?Q?zHhgkCFhgRfI8weXuIImwNxTefKWbtyPtr7Ne+D1uTUSs/IUOe7x6BYNwCGg?=
 =?us-ascii?Q?iNfZ2XRMR7j4bsTkk/V1iBmyzRncCNDSjtoDi9gVP7LbiABZQbiYC1bhYkXB?=
 =?us-ascii?Q?CLjUvFfAaWzH+KzDKQmxQ1dmqKHkSr2Hoxb0O8ASBCKIww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133d47b3-95c1-4a4e-cb76-08d96df3a0d4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 09:25:39.5214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kJmR/HoQRJKvMnm11F/ZBr5LQe/9aSIJV9LHtuXi0o9abTbV9LVOgSaBpC/hy99BxapD0+l5SN6C8llCH3ZOsO8QMCb0no8HR53wHAm8j0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1568
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109020058
X-Proofpoint-GUID: 2SwRgvwdlyZLfCyDaIc-y0wIv7wPy6ft
X-Proofpoint-ORIG-GUID: 2SwRgvwdlyZLfCyDaIc-y0wIv7wPy6ft
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry John,

Can you try this partial revert?  I'll resend with a commit message if
it works.

---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 525e3ea063b1..ec2322529727 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 	}
 
-	if (!size || size & 3 || len != size + hdrlen)
+	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
-- 
2.20.1

