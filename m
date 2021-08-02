Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48AE3DD67C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhHBNIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:08:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13018 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233718AbhHBNIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:08:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 172D1HKh028080;
        Mon, 2 Aug 2021 13:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Q9ZBUhg1LK0z1heQNXxYh1j73JsSHk6rkbtV9O7kV8c=;
 b=hl439AKrCKssYWt0Gtgdle2UFUF7VfEALhMs3sFn5ihDq3n28v1pCgibpSGLJeWPWGVV
 9S08ujARZz6Pgv31s3kJlqg4i/z4b0RxWLYSbKayvZvl8Jm3jOC+9nhkrNnCncU5OAez
 qy2STLKPXH4uNwPDRjS71P3F4uvofYwOFEx++ywfhGkT1okvxPKkrJCefLMzTjWfX08t
 D16RcJ1NGANqGlHUUUpaHkDpf8qnMNkOpVHnPFla3zNHkTNHbM73i4pUoDn7hlB0KVqn
 MteKf5MiskWZtbyjm+p4j2vTpV+3YyeFzToryznh6eoz1d0thAfdkRPERauOM3fw/RVK AQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Q9ZBUhg1LK0z1heQNXxYh1j73JsSHk6rkbtV9O7kV8c=;
 b=emVgII1uc1IERxY3o++Kv1eMAqGG5k63VtNk5liUyXSQiNQEt+J4Iiz0AiGprvX33K63
 1jFuTe9v6Q5oHMSCagk6RyiM7xhz87ECTo8lCdNbU2kgWKOr77vWecVlk1YGLwqxeuRa
 vpokEhM4WY5VuZKoisxx2QXJ5zU4XHVU1IO8o4hxb6mqhC6wSQJFsfBFodmUDbC4p4yz
 2VEtmrXvVzGvzLPUkeaDtD+DwIZPlOIo5kymW0AWgtFcFInlyR3qyaKixzMhc2OWJ2Xx
 8n6pM/X0EOKVVpcvwRCzCCxGnuCa/s3s6vETR52Cm2J0PyAuETW4kd1r1c3SSynWfBdE mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a65vd975r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 13:06:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 172D5rHY025118;
        Mon, 2 Aug 2021 13:06:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3020.oracle.com with ESMTP id 3a4xb4upbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 13:06:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipqQqAdtkrHrw53rJup/e1rMdPpPbskowkaKasngA0dVFdWvvnDHmuQingns8us1alWzTIk6VJkEYcsTfi04zbk5RZw4DSTuG2RL2RpKRMQC3K+80wpsfAZPGvnXj0nTO0ROaeuwy+Iz8ypMPTzEG3qKv0fcHFTIZciso1p3zvrhog/409CWdsXFwV2bYXtVe6YLXuMLKEfSW0wzRCTVxIsKlrbWDO4x/1odnU8C0WjE5MOv8DkePneaFelHKxjJj6f4Ddx2NB4wwtYEhQJfu+/EJsBw7HaWnT78oZKTlcoYBMj/GyFPUcsIbQdQFGUa6HvsoIr1uKC2i0M9odOQBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5W7Rt23VbQ7Mj8HWXmATUJEbSZASSn2vfTtnLqvcMA=;
 b=luW0cSXxHZrzCcfpPmNxgqfJhmU3/ftf+08o3zEpkdqayBQUDBpZwy6yLd3OBzdx/Oo8tZUp2tB4bSckkSRHrnUXIn2GBi08T5R8Rf8M+yt1UD3x+CrEx7xefhqsGODk0Np+SqkrJkjQIyqZ4FZCl0b8akNUKr+DZ7MO8b6Xn02m2FBIDhS/3ssYYUn+dKWUwxvngPzoIK7iGvqTse4n7iPKiCpyO03AfR35vzAZswtFzbObGYiuzxov0T4EPkDMUDlyNc4ugaLIkj3h1bXYBhCtqLkRRAoIPII4VWbdb/BrFO9awRzI4LbNdVZUjBc7jVkSX6fbDrrJKlX0taF82Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5W7Rt23VbQ7Mj8HWXmATUJEbSZASSn2vfTtnLqvcMA=;
 b=pX856HZ+QxlSUKjYYeXuExEdh6++R+B9RlqLJdH1lymUIJQIFrk5ZISPCt5siz3U17t6M/yNyJhXRoJKDYQqnDSBZYTMwl4Snjd9iu4X+ZFppEoZEeun4snm7cga84o3f1Mq+5v44VHEf1FXNi/eCzsyyIK7n+y0qMoy8Z+W6Os=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4400.namprd10.prod.outlook.com (2603:10b6:208:198::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 13:06:52 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f10d:29d2:cb38:ed0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f10d:29d2:cb38:ed0%8]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 13:06:52 +0000
Subject: Re: [PATCH v1 4/5] PCI: Adapt all code locations to not use struct
 pci_dev::driver directly
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Russell Currey <ruscur@russell.cc>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        oss-drivers@corigine.com, Oliver O'Halloran <oohall@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-perf-users@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Ido Schimmel <idosch@nvidia.com>, x86@kernel.org,
        qat-linux@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        xen-devel@lists.xenproject.org, Vadym Kochan <vkochan@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
References: <20210729203740.1377045-1-u.kleine-koenig@pengutronix.de>
 <20210729203740.1377045-5-u.kleine-koenig@pengutronix.de>
 <2b5e8cb5-fac2-5da2-f87b-d287d2c5ea81@oracle.com>
 <20210731120836.vegno6voijvlflws@pengutronix.de>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <d9dfe855-a2a5-c48b-b4c4-8109d7289809@oracle.com>
Date:   Mon, 2 Aug 2021 09:06:34 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210731120836.vegno6voijvlflws@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:805:f2::28) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.101.14] (160.34.89.14) by SN6PR04CA0087.namprd04.prod.outlook.com (2603:10b6:805:f2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Mon, 2 Aug 2021 13:06:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d6de3c4-6f98-4c6f-2e64-08d955b6654d
X-MS-TrafficTypeDiagnostic: MN2PR10MB4400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4400A5E9184CD5BC55012BC28AEF9@MN2PR10MB4400.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mh9lttD8PHCHFtbhor09IMvlqtOLt2k1ZQPqGoJoNP1JHi6njLVTS9AAfNYrhXu0Hj5Al9Y075k61p3h4eiv2JP8oiHMjaMLkrlopRWRtcotv0McNha3QJuYRV/Xl/SkxbobKP+ctDC711ILml1r6Al58ZkDld+0jtTUSkFuWCHZbb3CE63dEffimycsPMEGhUolXOx3vs1cAk1A64Lw/3ll84i7+R2yTl19lmh0LPoUp5ckRBshW8FjlcOGFesTTucGW3O7bNpMI63O7pB8jwQ4P+CYpUJOfksIY4BNmhm1307bicNsUctQ2iBqf6mFhoYoWSgrFfO3rARBPW6gJnVC5pPb1kMEJ+LHqMadVxqsiOHueZTQEwhZMDD6YKzkzGUyBXO8dYTseEZ6odHvUSwJWRC2IuJu2VVRawlgePgy1eAM6UTWi8Mu1UdGQpvWhUibxHYKy6K/Kjc2uOCOVv5zvYgHxYWVLmbyh3DNiHmZOhr5meMXw+DoOj0c/hH6MKnsJIXrlWwMBopeK4+Iurg5aMiKj5O1TNBuFpTrmMFRnv+2gaBwyAIuV4cyNi7X/9LOJ1vwNszRSqQ5amnVJwLmkch/ycOUtsAFjU27tcUa5/DxXN9hYkiiVe0lCA7RYv83AroI8StHfiwVEGLqZ+zb/dvyjqxbs3fn4YG7KNvy66mFKzGU1CeRhrgTQVOXnEus2SMP0dcDB3M/iTy5lE0Amzq2nvdVnMoGBamSlZc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(136003)(366004)(6916009)(186003)(36756003)(54906003)(5660300002)(38100700002)(8676002)(26005)(478600001)(6486002)(83380400001)(4326008)(31686004)(66476007)(6666004)(31696002)(16576012)(66946007)(2616005)(956004)(316002)(7416002)(7366002)(44832011)(53546011)(2906002)(66556008)(8936002)(7406005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?rcNtk0kzhjsCG5MAuUYd78NhRJ2btE+WRp7OgQ7GCAVtNOGg2NgNfzeN?=
 =?Windows-1252?Q?3o9rEXpQJNysR/gTElyHvB4f/XxlbI0UO6ccGokQ9vBPDgu4OXbOQnTv?=
 =?Windows-1252?Q?Q0ltA2jZ0Q6KyWVojNvlpKyd6Nku4FZCaS2UHZiDcbMG3Y42PvFRYAZy?=
 =?Windows-1252?Q?fmKufJ7LUBcl8DqV2uOT35yurVRG0/Fsurewhao+oa3ZYAuQ207sH0Vu?=
 =?Windows-1252?Q?gnN8I6T+lojHlav33CiYPqc7gvUlrzTTZALiL7cUYASaJK3Lt3UNvRSz?=
 =?Windows-1252?Q?LAZkkFmjCkjaQXfPN7Rb576WiVi5wpih+017cRK9ToPe5MoSb020X1BO?=
 =?Windows-1252?Q?rUxANcFtPWz546unMNUR2673dZYNGfYEQB5SxKO96OLVmneS4iTpu43j?=
 =?Windows-1252?Q?ti2ZVdj2EAnCMCcdA52f2YdZFX72Njj9PGs30NhTaEoSSEBfIYLhi8w7?=
 =?Windows-1252?Q?XsiPuGBy9mHZtTpRVGGfTCA667C1GgyCGsLHS4KkTZNDHpt2DUZi8PzJ?=
 =?Windows-1252?Q?VmqXdIBUunuL5YBFUibpOFhHHu40BN4w0JdF3ZQyQzeqXOHqEYoX0ho0?=
 =?Windows-1252?Q?jM7YBHqmR42sfiduM+LF2Eu6UHUp/ocMhFbQFsqnvH1sx4nkVVt/R6JQ?=
 =?Windows-1252?Q?So8DR07C6henvOo2xyxEq3yHAkCtOa8zW1KpyqfRGaXsvCtYjIO99yQs?=
 =?Windows-1252?Q?gK6dRhkDtZl0jOHQpkCNsN3Hm1H2hqrsYbjtdhm4VxJrQmSzo3SBn2Fp?=
 =?Windows-1252?Q?7MUeIRHYpg6pdCBSwhf7EEF37JZ6d/1ky4CC022rVR77ZsYnlXyTp/aI?=
 =?Windows-1252?Q?xkZf5YnmZJwRYG2IlRZO6nsTBnJX+aqb6qgfmgAqTcz7CJs+PG2USfdq?=
 =?Windows-1252?Q?5yTkxuBE6n8xnJbiVwkN+qXRL3/YyF6h3buteo710yHwenUkD78L/VrZ?=
 =?Windows-1252?Q?02sb8ezoMfvIgCb76ilv5+/vOkVwYQ5dB4TY4Pd2B4fB40dxg/9C3dIH?=
 =?Windows-1252?Q?uugYyizHKZNGBJOQZaUPrJfFcVhCZiuZ55rLkK7hIjlmk40K0fiad6Dq?=
 =?Windows-1252?Q?+MwBNgyUUeIdzQ+VQJmax9jbvdELms3815Ff2r3wr82P6NzM1INdgoEa?=
 =?Windows-1252?Q?moB2XIAZbWDPsD4NPS1tI6LQkqD5c8EqW6xoqRxH5Qm/D2Rz+jShLrjN?=
 =?Windows-1252?Q?0KTwRjyd7f4T/IIQJNreafs7kUHCjGaJpO6SzCg+1jOq8vz9dXeJjqm0?=
 =?Windows-1252?Q?2snzBrNeBf5u46L7bVblicBEi55ZiaSlCfLWxof4PxNRB+cCz/TpFPVW?=
 =?Windows-1252?Q?HjhUKEgKQ3D5OJHZUJh2c7reJB4vE1NaZQHijtLL7p65dBQEAfXvfrXk?=
 =?Windows-1252?Q?AOdj+7B9yO/iyqEaq8S0jXjniBq3iONcPU0JBRM3rmBfFskO/9WB9Vuk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6de3c4-6f98-4c6f-2e64-08d955b6654d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 13:06:52.5454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2OnNT6q3yqdtGadtAo3vZIPgtDyvQxqnxYrttQ11vZL556exA0nVFhGxXF2buUtsq6pyWbMmwCMB3WyE5VMs0uzcq5pVDXEc77LySMJyRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4400
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=896 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020088
X-Proofpoint-GUID: wAR5ySqhpQ-thK5-cyYz49DWDX4QJIq0
X-Proofpoint-ORIG-GUID: wAR5ySqhpQ-thK5-cyYz49DWDX4QJIq0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/31/21 8:08 AM, Uwe Kleine-König wrote:
> Hello Boris,
>
> On Fri, Jul 30, 2021 at 04:37:31PM -0400, Boris Ostrovsky wrote:
>> On 7/29/21 4:37 PM, Uwe Kleine-König wrote:
>>> --- a/drivers/pci/xen-pcifront.c
>>> +++ b/drivers/pci/xen-pcifront.c
>>> @@ -599,12 +599,12 @@ static pci_ers_result_t pcifront_common_process(int cmd,
>>>  	result = PCI_ERS_RESULT_NONE;
>>>  
>>>  	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
>>> -	if (!pcidev || !pcidev->driver) {
>>> +	pdrv = pci_driver_of_dev(pcidev);
>>> +	if (!pcidev || !pdrv) {
>> If pcidev is NULL we are dead by the time we reach 'if' statement.
> Oh, you're right. So this needs something like:
>
> 	if (!pcidev || !(pdrv = pci_driver_of_dev(pcidev)))


Sure, that's fine. And while at it please also drop 'if (pdrv)' check below (it's not directly related to your change but is more noticeable now so since you are in that function anyway I'd appreciate if you could do that).


Thanks.

-boris


>
> or repeating the call to pci_driver_of_dev for each previous usage of
> pdev->driver.
>
> If there are no other preferences I'd got with the first approach for
> v2.
>
> Best regards and thanks for catching,
> Uwe
>
