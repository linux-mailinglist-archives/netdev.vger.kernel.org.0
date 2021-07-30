Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14113DB59C
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbhG3JBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:01:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34626 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhG3JBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 05:01:49 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U8vCqH019001;
        Fri, 30 Jul 2021 09:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=nW/RBoDYU/F4d5MdZ4Q40k7+uZ3USdML/ZcFZDUO4Rc=;
 b=YJGvWVHx+0/R/EvZjE+nryapfuSfbED7hZ8iPQMXonVikal74Qr4eTOYyCPVDasg9Nmp
 Av+pENGVflIDYyVoM7yfprmBzUWZRHmvtqWdzZeU5RhkCSdeuKLhRoSgDRkrhpzMDD69
 45sTutLZ2sqqz7WDaeujIMQqNz74LfKY7TWZ/R6AHKgrQsDnvyhPd2WJzCz1TgP1NxeO
 VsjgljDSDL6phxCe9cnSbGalEeTK5zlOpkyv2DJ5ANcm/EpKopAbRobGDsPUsJq8KFWT
 K+6DJh8bkud3TcjzG4xndfLkVPl2/3PXbWN7s8bdyPLfiuFcTppn9PYEmi9EOIG02YmE Fw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=nW/RBoDYU/F4d5MdZ4Q40k7+uZ3USdML/ZcFZDUO4Rc=;
 b=mOUy3wHPPP8q6WcOF/z/nRmfM84XIHgMKLHoQtaYjKptzn7fSOIjw74AP1UScRvTiVS3
 nUVVAIjQYRWFiTVfKgNgTHNqKfJym6obCMj4OPRhb6S7+0oHIs8Ka++Of2wa38dzv2u7
 5ehjCCcTtDTw/i0t4ZlM/DrWQH7zNaPFz/hkIoE07DBHaKDf/plRq/MxK/wf/TGfBu22
 9ebfK+hnW6AB+5NExdf/IJUhr0ow2r2CvwuoZKR/KVJS6zT0Ma90Cpt5voiK8Bsz6o9T
 RXWPA9P0j2w24Tnwtmfo+0TA+8k6AuLOndPHSnWXh44Y31VObk3ijMpY6050SeWdr39h ZQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3cdpuwag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:01:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16U8tfEK108797;
        Fri, 30 Jul 2021 09:01:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 3a234dw9tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:01:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8KnduMs/OcDHelqu0SOg5UeOla/KOZFP/UiyvFs3ZAKysmU/hzEu3EA7zy9Me6tc+RFFj1jtT7tni1R5ZtMsMsP0MYIDR3pKjXJrZsNjGDRQpoPh9z5toXu9yK3NNCqihjfSrL04HTjgCJH13hn1JKggTopL+cINtw+e3WEsBpRRkxz4xTEX+ULOYrYR7zT5a8SiLAJBzey9qhu+APMw2HM3bn4/uMQ2bBhNhc91QmI4jBWq8Exhy9IldedjuGDWC10EacVwyXwjrIL2flMAJVXe4BaskPGMG94CBv3nY6V0aUeMSWBpgH0vXCCMUbdOzcX16G9tat1J9gJoCfR6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW/RBoDYU/F4d5MdZ4Q40k7+uZ3USdML/ZcFZDUO4Rc=;
 b=ZeuziZY6ooN/X1Vx/pKp2c9i/0ispIca3qzVzu3TtVnNAytH/zzWzHHZPdDaY3343loEsiOar0Dm0L+RQNF4HKEkeYiJORZ1cn2fS9PvoBl41BZ59LmIRAId8DXENMaPIRxPaFiItw6MXOf9F8sJN+eQ5cM9lG6tPv9ESvi4QgXwkW85x3XhuJ+/W0eu7Sy/wVmsQ/cJ+6W4cZndW6ZY3z+O4FjarfE5O1Kx/7XbSyOW+1bsO2mJAjkA1tg6Z+AZ0wnxpyAmkk8BX8wj6qELgmAOmGkm7Zbp+3/6eTzhj0NkIYZctlw3aguAdFFPt4VgOFLyBVXBsUfWJ50YJ3I/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW/RBoDYU/F4d5MdZ4Q40k7+uZ3USdML/ZcFZDUO4Rc=;
 b=B1zIBYgrx7Y2ljHj/awG0fqCVIiTFK6E0OlvPwexv7jy1alzKjZYarTOv9VN3fzCkOT8kWdHBnKfeUw51/jaW4C+Ji5YwBeJWQv78TMKJubJeFPwLlwUuFwiRPEWS7lDP1ze1orRTT+qPcH1AsyX0ghLWBkd8ZR/4mNj/wsTbVA=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1485.namprd10.prod.outlook.com
 (2603:10b6:300:25::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 09:01:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.035; Fri, 30 Jul 2021
 09:01:20 +0000
Date:   Fri, 30 Jul 2021 12:00:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <20210730090054.GX1931@kadam>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
 <20210728085921.GV5047@twin.jikos.cz>
 <20210728091434.GQ1931@kadam>
 <c52a52d9-a9e0-5020-80fe-4aada39035d3@acm.org>
 <20210728213730.GR5047@suse.cz>
 <YQJDCw01gSp1d1/M@kroah.com>
 <20210729082039.GX25548@kadam>
 <202107291952.C08EAE039B@keescook>
 <20210730083845.GD5047@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730083845.GD5047@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0041.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0041.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 09:01:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4b4b54d-4c7c-41a9-d81d-08d953389905
X-MS-TrafficTypeDiagnostic: MWHPR10MB1485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1485312BF32F4F8957AB023F8EEC9@MWHPR10MB1485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umad6nrrY6Y8XU4TP3KXFC1b6wtc9yyV8/jJKXFvurLfH5AM4QdCa0AnTcJ/mGXw+e1wT6oNEpbKMpmdB2pTCnqomxwyU3XyUDL9ygZodv6oT+bTRIgwAoae0OCxvxFa0cIzEIfffXfIdOtfSOU0xII+MAg21GOTCUzdLtE8OZ0ylmJ/5EKyLBXbRAsWi/63iwgj/auqsF+d125wHAgA7J9Zqoj7bEWg4p9i+NZLSpT67s09h4BHWbffmhdjlBcgMmNPNw+tNaStVDvzKK6eELPoSyfuu2gorVm79KKASYJSTEbBBFYKmTdmpy4kcwi2w5f7SFuppuAJU/NVbHzqKN9iJVlCjcLGMFgXM5zTK19bQ1EX+lFV2YLbNnnuQnjLMcbaFmlxruCUmW8ARnn65MhEBGWUeldvAI2G9infU2FXvCtAPz+FsRPzb0ohD3ERHBZitP7994/DXAE+NfhASH59yutDYNUA7ihOZvEHQvIituPZ209ukyuGfUhpLXbLzJSIM57ZBjusW1eZZguS4xKQ+gftjoGVuW1q4HURMvSTE+2pvToizalOBM3bOTmCR70Iztel3kCrD1/31qKtxUtyhLRmhCWYn7W5AEstEa0eawmi4MsxuCvKCUAWL+ZPqNyTZYafT3rRelr6S8lZk6Q34gIkKru/v1NA0jrdth0dmKkqMnLKQCZ4uufIemagetHKQhpej+/tGpMPlVaH2cQ6gMumBBeYNreuDcgEEcrxq/R1mccc3n1sFGt7rews
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(376002)(366004)(8936002)(2906002)(8676002)(86362001)(66476007)(4744005)(1076003)(66946007)(26005)(33716001)(9686003)(316002)(66556008)(956004)(921005)(6666004)(9576002)(7416002)(33656002)(6496006)(38350700002)(110136005)(55016002)(38100700002)(478600001)(186003)(5660300002)(44832011)(52116002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XJa9lMV0XzODWcWsaDd+HH8pCjY9RtVyO0YHpcGRxwnWCH4h9UQV501gVsGm?=
 =?us-ascii?Q?GE5psZ8EF5VhbUqy3/VHR8ZfK24mnBBXV7c5XETtKnLexSsA4B7ugXg0g5C1?=
 =?us-ascii?Q?r9uH3I7MEpNT2WRbXUwTeP2N8XZfgQrokEA6tj2U5jQLxGpHU08jwtYe2HaF?=
 =?us-ascii?Q?anNaGQfTRa2/ZJWg+//Ri11+RxqORi/03kFgfpkhSbXRG1KRPFxY5Aqk2E6y?=
 =?us-ascii?Q?nAh5dd1/kdOy88baleKv8NccBdMF452TM+YDA7V9yNoUG2xhKwdkmgH6ATma?=
 =?us-ascii?Q?lXSTjUiEc+xpoO/MW4EzGWjeIyoMmp5CwNpTzdiCfLVwdxUI6gU/rW5Q+QSD?=
 =?us-ascii?Q?lKpOw4vjju3rFvSqXf3SXeUh/LhilN01/d+qkAfUx0EvKHeGe15w1SuWIjxv?=
 =?us-ascii?Q?QajTZYnpe64n20v04IbhTMDS/LMcWIGX5TxrtcCUmxAHzmnTV8Maow/1VQ+h?=
 =?us-ascii?Q?MNTAgffpWImuf3ETybYkjWam4k7dhH/iWt9QpO+wH8WG7JzfkjPl7cZdZaI0?=
 =?us-ascii?Q?L1LBJhP2Xy83vFsnnBWrNw8KeVozAfq4H4CqGpa0jUxkqjnH6W/w2zCsgyn5?=
 =?us-ascii?Q?es0Ij21jOIyqlipN/ETgHIktNpXPzAWJVSXtdqwfksfmoiUQKh3SEbOL4/N0?=
 =?us-ascii?Q?3KK08hs57zU5hCWAdN+efuDmMs/722QY4/YtEfGPM3amvYYoIzA5ICtL0Yit?=
 =?us-ascii?Q?fuvfMOUiKmkST4HtmSD+zg3yO4PZvwNc4j8+hcYw23RlRUANByvPbI6RyDFx?=
 =?us-ascii?Q?aldt+uDDcBvCpV7RexCCkWkTHS3UfkoX2rqaMXC/5poBh6S3C+NCk7K/o43y?=
 =?us-ascii?Q?W3KzTuXxMbqdR0jn6F8iGABjyt6nL9uGbYDJ3zLxj7w9kisMhWiqiFcmKYK5?=
 =?us-ascii?Q?n6rHIzQaDoZzWaDQqqvi/Xh+l4+rVwL7EDctoGXR/PcAm9MBzrpf6JTpWH21?=
 =?us-ascii?Q?sTdke6wQsa0DTfaMdIg11W+pgTq+m7w/Ni59pP4O4XrLVxPIME/qlwWvsk7W?=
 =?us-ascii?Q?q8rq0a7lqDLlgjbwv7l5Q8vU9IlP/y+waetBAe5lEk09pOHxa9Cqd5AtHBr2?=
 =?us-ascii?Q?kmOIFEthVv+sIbCoQRHsZdxkLUjWsmUuAuTdi3k5Ct63WvBQyMSWj43TB/5p?=
 =?us-ascii?Q?Byb/b2DsRCCK5Lvmh8s2tVqMl6HKx3RP7u3AQmvaGnBccURavHK6HTXUzAeP?=
 =?us-ascii?Q?DzYC2zwl0VVo9QH030bl/ppckx6Md0Y2X7ZGqRQkt/eH3js9ioXkFdj7dOxr?=
 =?us-ascii?Q?oyBJ78jDSmpALa5+UR7qHb5S25Q4PgmpAjDNVnmUPFwJ1OXTw6sLSVwWqV7t?=
 =?us-ascii?Q?nde11VyJXs3xxoKoV2nZRMzs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b4b54d-4c7c-41a9-d81d-08d953389905
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 09:01:20.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXN0rPyfpfP2X2+6zRQ3ToTSkY++E0+7Vn/TrPiX9+k/Xjd8cnRuN8aOwF99ZcmRzO63Y3Oy1wvCjjOuo8TZSl9+/KTQ+PSkoIEraIH5tn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=793 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107300054
X-Proofpoint-GUID: 8yhbn7ynu11gXeAqSK2Nzbi57_Wl-bMa
X-Proofpoint-ORIG-GUID: 8yhbn7ynu11gXeAqSK2Nzbi57_Wl-bMa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 10:38:45AM +0200, David Sterba wrote:
> Then is explicit memset the only reliable way accross all compiler
> flavors and supported versions?
> 

The = { } initializer works.  It's only when you start partially
initializing the struct that it doesn't initialize holes.

regards,
dan carpenter
