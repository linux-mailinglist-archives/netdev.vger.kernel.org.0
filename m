Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178FD3FEBDD
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhIBKK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:10:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:62764 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232113AbhIBKKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 06:10:21 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1827ORm6029901;
        Thu, 2 Sep 2021 10:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=vYsOdJb8Clil6Rdy7eeUvoE9Rwzzx6p2/GrvPj5Vec8=;
 b=yvn+JrXYvMnR7GBO5/6EY7NCIommKaS0ZsbQteUtIw0QRZ5MUQUYfJpWj8j3HxM0zsQb
 RWyOF9CzVXOADooQCJxIvAEPSVJrIkBxFczK7YW6foMo2/m8SVUwo56gUFyeG0eEm09t
 ZViY8RkPnQCuYj8hRLGuRtvGpfmpufdBoxc0RUGq+EkxqhSUTYt2QX0XasPUd6SW5I+A
 mRGbxhexuN2ibfoES47svaXQtVdFSJ068nuLI/RLroRacbQRI83cn0539qIkbqPSiMN2
 A7TDxM9n+rZJ2GYzTQPAGcvAYdX+OtzpfkKYCzmWyZCwKik0vuTvDklDRw5/NTt5iE+K ng== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=vYsOdJb8Clil6Rdy7eeUvoE9Rwzzx6p2/GrvPj5Vec8=;
 b=spdc5RPXZde8YibgpXb9t2FfWP9pV0cQmfswHjtjtFrHMw16MnGCK/MhpIQgRtupkUgA
 HPAoRgJVeYEtLTzs6+3jgUEz1WfnQBa0Cg4ij2G9RwcrwMw1byyMGj5Qb7HCRAHtD0ci
 xHvjEETQC9/B0Ak9tGsiiWuqn7oJJUsXNuQO18EfbuyDyqkfVQLr8OPbpij4Sdkh5oOj
 yXjPVbwrMXevyMxcZy+h96gj7+ne0qFX6L7uNPPZ8qBwsE/Tvm0e5/XwqtHxUQXt/ZFf
 QnGK2kZXBVnh166v42n91cOiZuUepJSTy4ARmquOQsl5DoDzrTmbKR42jQavmUHdYKW2 qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw026n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Sep 2021 10:09:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 182A5qlr036219;
        Thu, 2 Sep 2021 10:09:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 3atdywrj9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Sep 2021 10:09:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfHaurVtXu0zTpGDeIuup9TF5HKNzPWcDlnekPeovU0h+08r2ABuFLKrKLRp1yx44xvsOlVyLlJx06Lnrx3kVXG01nNcQ9SXVO/PFxdoEKj9Oz9aRXXnQa8NfB4Xr/Q/fUbAwnt1aoFuWlYDL+mYUGqlny6Oy4WaH7TLweZtOwpEXykGI8BRbXblobkgo2GkhVLECrpqQqE31UFQmo//iZyK8axnyXt4UFLD0YTs32ANEhmbTxkQv/iWL/U0g0c5E1RyCwY4YQk0JMEllcM32fAJEO6UdQzkGHJFxREj6DL6ZqlNomAgDbgDKcs5bXtyMH2a+Ij4MeqjG+mRRHEMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYsOdJb8Clil6Rdy7eeUvoE9Rwzzx6p2/GrvPj5Vec8=;
 b=jWnHW927HJc0OwZk3V8GpSz2AbtwYaS5Tg/WOi80WOdpbZATiormcvesIGT/5YEFsMC69C8V14o1wc1i908x9Q6DcGkyRDZ0NqOPWhk2KsjbjSDFjzx5oKK2YC7O09uKlDc6R3OJcuvkOQSpNR/AYgwTO2Qp88pKpfOUxlFwIfPKvw/mV2G7tsQ8jm1un7kxoEKQlK+T4dEPcZilY0DtbDIqDS3g2Ul51q1XGBu9/olNUX75cs4HCx4xlUUNfWW1OONgNO5idoC38ZKsMDa9o6NVSRTLtnZqtfAHYmJgsnZsBi4SqLyxZRCpFdqqXQY9gy/+HgdnqPqtROmNGdgO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYsOdJb8Clil6Rdy7eeUvoE9Rwzzx6p2/GrvPj5Vec8=;
 b=BIYTnUmbFRxcaHjSA9FSTJ0AFAUz49IStpbLYp9BpJQcdxqrHZCKgoq8qYcO2UNSr9P+6jIZHEd73GAuiUJTzOGNYj8KaTz6NJsSVw7HCqEXzfkW8sCAcfQ1duw6MreAGD9oxQU3iBRTEY1nJOgNitiRbAcaWMn9ma6YkIUHjKw=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2368.namprd10.prod.outlook.com
 (2603:10b6:301:2f::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 2 Sep
 2021 10:09:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.020; Thu, 2 Sep 2021
 10:09:12 +0000
Date:   Thu, 2 Sep 2021 13:08:51 +0300
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
Subject: [PATCH net] net: qrtr: revert check in qrtr_endpoint_post()
Message-ID: <20210902100851.GD2151@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38288aff-71d4-bde2-7547-dff5ca20091c@linaro.org>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0037.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0037.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 2 Sep 2021 10:09:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93df9a12-aa1f-4205-4a49-08d96df9b651
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB236808009C6529EDB4FFC3D18ECE9@MWHPR1001MB2368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: neRTHYmV9hV4zyhJnqi42E70f2xRz18QZy45YSPJ0cFrk8t3UoMKXgH0edHHz9JfZUlAcrlhwDntXaTAItQeGrayPSDKeneTk0Igv/pLxI9OLy3dIclKBAp6/G4XImxiGfRFuHIIyIdqSy1X5pC270p5i1Q4DOR7LT4hEU90+xc9UjLBAwVGM1oCd0bBVw9Pmjn18rxRtLbVEYt5uuasibGJTaOhbFcbF+EgxR0Zg6F7K7+Hj78No00vm4pm8A+65v9aY5gsmsdFQo18LLRjvmreQR+0yQ2Y4YryFcHPNWLiUZBnyCx39DnaVCYoRvH1MJ3TzLdH4xaU6xI/W3QLlyNTowd0hMeL2t6UnOcNwMFCN5OrrdvfARYNwyK/7cwO/0xAi1MFMTVsN38EfspE4JlQHV5MAwsAT+e39XkVj6k7b+WiWrPAtdzgaTPed0Fkim9uyMAzb+Yon8jjaSRscoc9XCb9QnOQtwl8xjVyKhGwjdNv2vC27lS14djIKC6c5DL0PJcJpHgTnz0PIFOdk+IylZmWGeJmIPgvJrpJd8CiJUsaxZFQqpGLzDFBUZ6OY8eX2ySaMadM4dZ9zoZYHyuuQdwQWENVcIhgn8XhjP/oZjTxISh7SS5lCd2HmU++9RY8+0ChBx6mYdtjAr3Vj20GewyXYV1NTXKlBQJJY94MWTLYGnlPf7pjorP5a7vWbaNRdJsKMS6oyhXiRGBnNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(6916009)(478600001)(66946007)(1076003)(9576002)(52116002)(6666004)(26005)(8936002)(956004)(66476007)(66556008)(4326008)(9686003)(6496006)(44832011)(5660300002)(55016002)(54906003)(2906002)(8676002)(186003)(33716001)(83380400001)(38100700002)(38350700002)(4744005)(33656002)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JbZRJbZ6EmQ+1bHkHZXPj7KqQANq1nghXJrOu+h6G4i099mU+nzZH/iHnpa6?=
 =?us-ascii?Q?7NoLDWKyKzKgTLxSwOfXkzog1PU278It9v3mpsExlyyiOUdqfxiqhOpeeBuT?=
 =?us-ascii?Q?++ihtGO/OG6g1HLbDw1fkp11f2feuUZzxgGjbDEsti6E/grQ66Lyz2pTbC12?=
 =?us-ascii?Q?jfQzPu4UlzVZKqPYueUIlNk1iulya+PLg9EqdSSyN3TZ74wbbQKRWHEOpEyr?=
 =?us-ascii?Q?+WIIZjx15gBfAlJK6+lHBydQPpsZTiftha5NLTNLQo2psO9Oae96Y6FiH2Dg?=
 =?us-ascii?Q?xeAjGnMT9Yy3vU5SZMbjcWddgOzG9sVokfDCgSqEefXGC64wfHO79leWCjaM?=
 =?us-ascii?Q?fJSStVbnO9Xn6allHhP75C+RBleHaKSh6XqtbdN/5GOUtFNkdb+Kr0MgLqzZ?=
 =?us-ascii?Q?eyyFDGocuxKz27V02P4KjhhPZnAi61QJw8zj2/n0ZBhh74dA8t2JyPROWsCi?=
 =?us-ascii?Q?Lng073vnAAXmMPxPCEnsJ2M+pXqLTwOMkL11v/URrYd5coO34UBH12CgycWB?=
 =?us-ascii?Q?dgdiQb82IK2Hjswmrxo5OrRC7JbLheAyfMuofrfPGo2Cn8dgfNruPepiepRL?=
 =?us-ascii?Q?5s2w5tgFRm0c0+g7DMHh0MjMm8O0DlPHBj6IZa+SNrNDXK74e+cqJ3Ui+VNz?=
 =?us-ascii?Q?0EgMAh15hSj5AZPbUUPl37l48j/Zmu6CCGO/PbvdJpBC6erdeEPdgxHQS96A?=
 =?us-ascii?Q?F+9oxBNQ17uNtL29UQ5ni/RZ5tAlxdWTE82PiMNnbfWs3r/FtF/qYdvNu5ni?=
 =?us-ascii?Q?QGpBlI2xhkg1znLC/Gs7Qlp+eOJyvmqKkMRUuDLGUaQmoReVPGyUOqvpxJsJ?=
 =?us-ascii?Q?XN1Kd6pswNMqvGnW6jWbmGuJVjC51hUhLabBuJglPCjtFfKEAyLe4flun5pz?=
 =?us-ascii?Q?qrlRSvxIy+3RcztQZLIeop/CA/K1Z44LEEli0sSnM24VcqGj8kS/QMw+a09b?=
 =?us-ascii?Q?Wym4VjoUTZxIgvVWuJecT9reY3Ong09H+7gADgeaKfc1zJ+f95XaiNIeFzUr?=
 =?us-ascii?Q?RgD272J97r6pYX0nxpPR10G5uuVizoNv1RfOLiCybt4i/DJYq2CQ/ZfqRuMJ?=
 =?us-ascii?Q?usV/KpNAscNuLTL/Mlm/lwbl3O3er6SMTneHM41a4/1jHvyu8f2V/M6HDcwM?=
 =?us-ascii?Q?q3wHQOMPvOq9JRy/C761CfLLOPTetaUr/hTywhax3f/ZD5usgnxyE6VtIbFR?=
 =?us-ascii?Q?sYUAb58R/lDyflC1ZBR4Fdb4odLxuhgbi0YwSw/5C2uWkVxd0xsMHvarnsHa?=
 =?us-ascii?Q?amzQf2K2yHLCim8ai21YkPvl6sZrCTyE587KI5FyxPq/TObFGl+9Zqw/P9St?=
 =?us-ascii?Q?OwlFp+U3B1kut9+zhqyq2Qr0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93df9a12-aa1f-4205-4a49-08d96df9b651
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 10:09:12.4160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Al0JV+lhx5gIZzkVmy26xS4S2dTtPJlfNRvUfj9fXb0slwVsIIX9xzoIxiKysb2FXbBzNeO/9zktbfsky1Z9mztHLMKJXAPhUzvYVMrpLdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2368
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109020063
X-Proofpoint-GUID: 8FWFZTESGLkwMqIHeuk7eM_WVIjaEmsw
X-Proofpoint-ORIG-GUID: 8FWFZTESGLkwMqIHeuk7eM_WVIjaEmsw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I tried to make this check stricter as a hardenning measure but it broke
audo and wifi on these devices so revert it.

Fixes: aaa8e4922c88 ("net: qrtr: make checks in qrtr_endpoint_post() stricter")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
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
