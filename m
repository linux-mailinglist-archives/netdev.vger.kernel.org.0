Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631C53DA32B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 14:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhG2M3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 08:29:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47206 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236868AbhG2M3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 08:29:51 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TCRMnY005202;
        Thu, 29 Jul 2021 12:29:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=VHwb0IK/0Ns7PyTNnli4tI9tvISKlvzlQBuk/r4H4wA=;
 b=og9ChdWqUGEx2O5fKFfsonHo9Xn08+U908GJKVYM5XyIu8vVNj6GQjDYmy7WdhuvJQJe
 ByHwnpJ+8OWMiB6M6WtLnYitEtyOD1he+veIrPalLzHbEgX7NQebU/1X1JJ+1Zr+76j6
 z4hvcUu4eqAy/Hm3X2+KKpsQgItmjA7iLV7avXZT8N3kvx0MZpmFqyMcNl0+TeHiWOHt
 GsK0UVSfQNiox/zMyJEokweaPSUpb4y9KaHwiqpPyWWnvG/RCxmBhKs7JhFGQOdYCBO4
 OOidvA2XFmV2BkcYm89AO8UEr7zLnXP7LMavKEbNapeTEtNORcOl84KI/oNt0qHq7chV cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=VHwb0IK/0Ns7PyTNnli4tI9tvISKlvzlQBuk/r4H4wA=;
 b=jnhpkksw7Bnjt/Yirry26N70pZ5T1HH6BpcjWCDouBj1iCL6QL08qAAb4kNckSD21NIZ
 FbaXf0DqKxv7/wFmZ3wed4s7Pxx+EGea7i6xIq6m7JKJIly3tEZdKb1HPHLjFLfcrQ+l
 sQ39EEygy6R38tfK90KNMwUuAj2JnHmqh7Z4cXZ1AqhdxUBOLWFcdQ7oHLjMf877b78W
 +Rn1KuMoESA39gjEH5wK98pEY9uq9UqSn322/S5je2y5kLdLev9zaj8L9UD+ncH7Q7uX
 c0IAeBJ0Qr0PkkaoYfw/NlOAEhk6JMCh28Nf9D4WO/dSpnRYflgSO/1gOmH7csmvrjp8 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfdax6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 12:29:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TCPo04061987;
        Thu, 29 Jul 2021 12:29:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3030.oracle.com with ESMTP id 3a234edwje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 12:29:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gR7WxTmAQZ93oF94AwSnTq+TrrKk+IOXVSWE1M1dHVbS+siWao86EzH+oWaz/4jKUyBTT4yQvGaPvFb6/Q/u66aPwwjtEJGIAA+3xTX5q5Dx8cNueP0Mu6Ybw8JUnw4jTLqgGPAn0HtgSGQXy9WrQMKnpxKKWxRkWBMYLO/QCRjNkEiNZcTADQ/nIqatxNJ4IDxGEumYsLz34iXriFUt0AmaBp5+IbgjU27AvFXYbM1lab3JEu8uA/FMopASRTFVc+5veYQsb8yRBvApXKe6lLGTddkZ5MuVi8mv4m0A47m8mGo+s0YqrgNHfBLtmlyRlM/81ty2gsg0F3ewuSP5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHwb0IK/0Ns7PyTNnli4tI9tvISKlvzlQBuk/r4H4wA=;
 b=UwuVzwf/lWq0CYYNdFOslaDoElitldZfowjbNcu6fx79/7x/gwWdLquZpjoGFLxijY2nxoGBpt1taLHTv1dq5t6CWcm8XBFLCOQWPjVW6mqYLRMaYrzdAa0jt+KvbTceMVXZ6Gv6i11fodM3f7xBDMd44HPhceHAiy/fgNugbdRbIXn3CNF6sKPM0CpGiXfKJGofZLQdp7cZA55toOCdn92sz9kcKFepONcSEJj1n2shz6SRLARYRVmGbCWdPVZsoSmw4zGco4iZ4qVTpbsncE1SobJnpvQFhR8pJp8JvPr00FzU2Atg/i08X+QJbkgm8nqeyiBAJRKurG609EUi1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHwb0IK/0Ns7PyTNnli4tI9tvISKlvzlQBuk/r4H4wA=;
 b=UxQJdS728HVNPMtidn6LlLt3UiTy+UW5D9OZbHC9u2WC7vhoCDvFazit8AohgSNHvhZsPh9+JspK1PshbarLossdFOWHiVsXqDWvyopyt9rZtxqNhS6wHygJEdIXwWswGMFDWB/DBfFbh+l6v4dk35SpUJNUw+Bsglo3wrAgUXs=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4692.namprd10.prod.outlook.com
 (2603:10b6:303:99::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 12:29:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Thu, 29 Jul 2021
 12:29:21 +0000
Date:   Thu, 29 Jul 2021 15:28:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        angelo@kernel-space.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] can: flexcan: Fix an uninitialized variable issue
Message-ID: <20210729122855.GV1931@kadam>
References: <a55780a2f4c8f1895b6bcbac4d3f8312b2731079.1627557857.git.christophe.jaillet@wanadoo.fr>
 <20210729113101.n5aucrwu56lyqhg7@pengutronix.de>
 <20210729114442.GT1931@kadam>
 <20210729115744.ta5lo42d4metzxtf@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729115744.ta5lo42d4metzxtf@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JN2P275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 12:29:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb29e50c-7429-4584-bc82-08d9528c7e21
X-MS-TrafficTypeDiagnostic: CO1PR10MB4692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4692DF1ED8AF8F4952690CAD8EEB9@CO1PR10MB4692.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /walQ04Ez6MbRnHqiMjBW5ouARwfCvE6ZHg4BfHEBm1hjMPzA/3FzQxqaWtHAWwQPDU47C2mhTT8wpVrclrTrQ/wnWLDUpHUmsRtszpni9WAgMOoDH1hnppaqjnbK1nuFlVUqKH7yecS1aKkThi5q89jisUGiYA4tmQhs1wIjEQdhl5oq7ks9mTzOAJLwQP7H9uW+qehtALxlGP5d8owb8gehCSNh7mmvAlJRfIcLeMnIv0aQtYepu1LvLBvUyP0zoxR0VjpgmHHsesxKk7Bb3GRz/j+zfysxXyGhyAvppQ8T3h6C8JkpugPFmQoObqiXGqta/Swk9hOrR43M/fTkMCaBW5n9tpdYK+v1FpIQVQ3/fx7M6DBZ7Gog9G3ihDyqSOLfyA56Yx2KliX4lYhzblBjZNN2nW9vztlCAGHg/AksvbUANmX5Az6ZQdk5qpx4dMzp0jktPbYk02dtTiSUKRgIRggFITAUs0nnNyXMGJyzAtSCPg7Sqj7mo7J6C1RiaDvpywpsyvm+jJapo1zrkGM2y4iBfb+0Hoy291OsQVRKgjR0/AGiBlckL/6o2O5mc5WJUucG4e/DD3foA4RltEioZelE/Cvv2elRI7Id5skTERpqT9SVXsmj3pmiORVNkuIKWzSCE0QhvZQS0oYgH6VMtCIxBL0TJD7WXC+DQMSFcSWkT7OdxrGIPnTqllfrAeeDm/k7Qmw1kD2dWiOOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(376002)(136003)(396003)(5660300002)(316002)(33656002)(1076003)(54906003)(7416002)(478600001)(44832011)(956004)(4326008)(558084003)(8676002)(2906002)(38350700002)(33716001)(66476007)(66556008)(26005)(55016002)(86362001)(66946007)(52116002)(6496006)(9576002)(38100700002)(9686003)(186003)(6666004)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BsNV510275P/gWczzdK/NVEm+jFIKrSg7WqfUjPEZO5kdwGFDpTwmFCAVkyv?=
 =?us-ascii?Q?W4UY3F7Oj6muLUUzAizrRjJvHBDdFSBhCXZB8PGByHBh92hTQmAWy/geiwFF?=
 =?us-ascii?Q?gqNTpmYF8zcnBFzYvdaePA93p0KMWjbXIhLJUAK213HEOEp9y9HI6lrISHZ+?=
 =?us-ascii?Q?TVO/5dHWRl9v9/ZIcbLKMs2BbqPLrPEbMKmO9TmICUAmdPGiCVC5uxamHDRv?=
 =?us-ascii?Q?K0NiQ/0Ne6JUlYMcGJEJJ6OF07VjRt0D6K6MIQ/rhwFG7Eftt6RpOAYI/mL1?=
 =?us-ascii?Q?qnnJ/i0eUQoZaxF5rL7p7DTc01Aoc1/fRbgiQISaMKbvCgP8ehaB4KmwMsyl?=
 =?us-ascii?Q?T4LWZdqroRHe937ExBdkhcyIqgD9ySRbh83U67FCS6Jb08fnxIUPy603DPAf?=
 =?us-ascii?Q?7tp7toudRrd1Uffj9cs4Z4+Y/LEhrUQN3mT5gO9YU53O/nKK6VzMzV6hR93G?=
 =?us-ascii?Q?vsm2VzlUMDuMDs3PBJBIBFkZSLLchweVmRfq/Wxz+dOFw6PbdldthtT5a79e?=
 =?us-ascii?Q?lO+gQlMcUFsV9dgdYRnlA86AxVY0LlaKOy+k4CMHhMxbB/SSMuas6qXYjVbB?=
 =?us-ascii?Q?qVusomb5Is5cOPq1JPbwKgdWsq0XYdrEqxBK26Iu+/sc8FawhGG4IZRl++aW?=
 =?us-ascii?Q?CWhceIhaQloXmarTcjTvhetamT6Vr8ewJPDWcgiJ/fC0H/rh0hXEbRstGGKS?=
 =?us-ascii?Q?Duigu3oUjetCk2knHTG7IWN82uJ9ivfmGnZ4P9ZQ5UzB8fhCixG6Dn7halV3?=
 =?us-ascii?Q?dlEmxeR+CKRzHe3bejaGOydZ4WntNBoNhWJbNl2lRa8u9BvL07VLHdXY30g1?=
 =?us-ascii?Q?1ASO0LZKIxGb3rod9aQHdLrG2F3aElfFJKjEUXfMEdMuzyCmeRKiSgGneVbe?=
 =?us-ascii?Q?1FWM2WPUFz4BX1sCTkhKpfwFFibrWlR2TNJWwEWwjULTnA81G+NXMgWnCQ5m?=
 =?us-ascii?Q?xRCiPZL8EUdTWrpdlnayCE3h+VmMkrp4uCt3ZEwidkgGKI3indBIu+AjVX85?=
 =?us-ascii?Q?O8tq4353cSorGSP2+pfsWQMv25FDfffC148h1CkceGo/v7RBGt85AQP4GFHH?=
 =?us-ascii?Q?oANYO7ZxweJj5OOrWCNGd21zb6Lzz5YOFY5NGpXsEU2IYBd3py8PyhuB0kn9?=
 =?us-ascii?Q?2s/ZaKXxy5bkXteqIkisrHBbahIugehbPFYqsVYldCI/A5yFM8ZeErbhGguX?=
 =?us-ascii?Q?pEPPp2TUoyE1Kx1DJVXcGOOMAxMtFqj5bpw9Qakx2ugr8XduUyyIE5DqcVFG?=
 =?us-ascii?Q?gGck2y1FuaEhCFWdoi6QlZQ3zmJjxnqm5oLsUAZUOm6GWmW1B9NYRI6uzyo7?=
 =?us-ascii?Q?cDS3bDJVCmJJZ7zK8PgEDOdK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb29e50c-7429-4584-bc82-08d9528c7e21
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 12:29:21.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8ChKsUKJ7+K8LNFqePU6HbL3kR2iPC1E9nyF+58n26zt2QUk8fSnYnyFwjmKlriE4tTZz4m3cZ4IOWBRpc/TW38b0YeP9+4BIDH3w9YhnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4692
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=980 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290080
X-Proofpoint-GUID: Id_t4AR7MuYcnai6NRi3YnNUzbo_K16p
X-Proofpoint-ORIG-GUID: Id_t4AR7MuYcnai6NRi3YnNUzbo_K16p
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:57:44PM +0200, Marc Kleine-Budde wrote:
> Maybe it's time to fix the mcf5441x's clk_enable() as Geert pointed out.

Ah.  Thanks!  I'll send a patch for that.  In the mean time your patch
which sets "ret = 0;" is the correct fix.

regards,
dan carpenter

