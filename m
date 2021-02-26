Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27459325B12
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 02:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhBZA5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 19:57:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33802 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhBZA5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 19:57:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q0snZ6131144;
        Fri, 26 Feb 2021 00:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eLVBK9YR4+DnB6hZ0H1EjQA1s9JeAWF/H+tgA2Qg4kM=;
 b=sVdAX3b8j+2psQw8yzQixeiH1X0IJPvadPMMAoJfr6nTf7jIiyY85bXxvMvckw0MvfTc
 y+OxFG7T9H2BbBM+k+BeQAjh9iw2pEaTal+lAOWYs079j91HiuYCfVdNmTWRIcPVYac+
 c4v+Qt8KZZpAJz6FYMRe3/T0SUhgA668tMw5wpA3oiIc5YkaqgTfsgUceCleX5nU/2AF
 x/yVOkdoEOccoY1aw9uM7N0993tfALOPUkPXRq0XiM+fhADXWKxu/bkECVRniUgj1Azk
 ZIxNc2CjcliZWkFb+CQjXpQQIocXb4ooPEgtujWuf+JtQlqB303HZLEccSzqIbXMQwYE ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36vr62as4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 00:56:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q0sgIA126682;
        Fri, 26 Feb 2021 00:56:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by aserp3030.oracle.com with ESMTP id 36v9m7ywx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 00:56:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfJH6blDRKCADvgAOKw96u/x+du+jSIDsTauLJnjxr0Xna0n7QAPw0BPDOxJ6p4xXA3vT91sTiTseQkFyC+Sv9Bzfsw2Bu9lPwblHzKPeQ2IPwUedkOPV1sSGYqbi8KAo4powDi2D1KgcwzJKt1enGwiN6rXsB8NTeC1k85S/UHdQiBLYq+zonYaScMjPktNccoLtxGCXqGqWOdFTsGYus3jZOPaRHtecfKJSDK4ZLpYfw7SCCgggN7vf/pWSHNhS40NeirbPX0oWSdhsRxuPh64lH1ot8pOlf+gi0JGvvr0LIkB86pNtJ58/jqF47i9SIktVxF/ylMsQwd5Algy0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLVBK9YR4+DnB6hZ0H1EjQA1s9JeAWF/H+tgA2Qg4kM=;
 b=dRFntRfC+PlHUWOCUILm6f1RAayosrHMKlj8PM5wUcZwlgNrB9lLyhUTZcwakHCo+lI/cuJ1zwRx6kUi1VkoEgvpCOQIgxzsFssRB4DZu+FGBSI2m0Ifxkc/u8d6Y3YTi+i6xNZ7hlQoiLqoPcRzUAubv8hdHCBBvpcTSzsBa/73UXSqz2y084AYwEnR6cNWc14llnKjWcBJsJPHQQRuW8k3CKFGwsJDPIOaAJLzlCROWwGqLgpbLhjiKSzIk1lIhw0gQABIb7DFLdHJAsqjniNWrIGoOr3wXm5mexNpdRjWiiP5bFp1KKX1Pv6mJcbVGUJ2iF3dqBKkgHq/T3V6Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLVBK9YR4+DnB6hZ0H1EjQA1s9JeAWF/H+tgA2Qg4kM=;
 b=SoqB/Nl8ljAT2b1Pzaaip76mrLI8chyKEqsiILC61Yhp/n2dDbP/YwwOgB1RkOyk2xbVE8K+ybPoq/O6DIjCtV/LCDWE+s7rkDXAp7s4VvtPWb3+zErylw0vpHItXX6vx5odk+947xeKuqdk8SFJNB+jW34TpvWANsghZLwbD34=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3061.namprd10.prod.outlook.com (2603:10b6:a03:83::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Fri, 26 Feb
 2021 00:56:45 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 00:56:45 +0000
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
Organization: Oracle Corporation
Message-ID: <3e833db8-e132-0b00-34d0-7559bab10123@oracle.com>
Date:   Thu, 25 Feb 2021 16:56:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [24.6.170.153]
X-ClientProxiedBy: BYAPR01CA0069.prod.exchangelabs.com (2603:10b6:a03:94::46)
 To BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (24.6.170.153) by BYAPR01CA0069.prod.exchangelabs.com (2603:10b6:a03:94::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 00:56:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e54cd3d-6342-46af-236f-08d8d9f16385
X-MS-TrafficTypeDiagnostic: BYAPR10MB3061:
X-Microsoft-Antispam-PRVS: <BYAPR10MB30612245680934E69B83E5D4B19D9@BYAPR10MB3061.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HlBDedhqGxJFTp6fnl2kVlAVs8vnWyi3Uo+XL/WRmvgGIs9zbnEqax1xlQQcxjU+n+yR81IJvaxuyGSkEgE5tIzyc4t8vmRVeVrRFCmGAORWooDUXYjkjh9/53xH9CDMLNNZtRkE6nCRe+uZxfyljpiQGnUZs/2qtUiR2aweQ267CFvj8u2h2SfFb55ZHz7NeuPur5A3LpGhqGlxs3B+/PR0To4kDJeB3VIiXXESEprDNbzN/2Fxer2JeJCPQvAJIzkHVAAZ0vZqHCX/Sq/0jvCi0qgCOcMn8JbMPrZZHVq0HSC6ZiKB1N9RuxY0re+0GAGtoAHjjDAehFE8VWOtvjIcrlyr2nSGKQz1OYDMqPD1RKg1wvSj0zWPHa7L3QfnEXHG75a6HNX0SxHldljmGbxRO/6NaqdjLIP6vn8M0W6IdsOfT14uJ5bEDC7/SnKW4Zijf1f7/njKy0rQm7OPDhzRd4hvx370mjSY4EJ1WVqytzUmdWOFDUBjh2+cKbagOi/pKGerrG1LPdj9Fgv9GHnqtc0aweGny4nLpjUSICVAtV3ArvE/tWe2Q7kUljnUQqs3Y3lF2hsgyguj0g8gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(136003)(39860400002)(83380400001)(8676002)(4326008)(2906002)(8936002)(16526019)(66556008)(6486002)(2616005)(66946007)(86362001)(16576012)(26005)(5660300002)(36756003)(316002)(478600001)(31686004)(53546011)(31696002)(36916002)(956004)(66476007)(6916009)(6666004)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c2cvV3JEU0gxSmV5c0FSSWkvSlRTTUF3VHdWT2VoaHd6cUREVzFxU1NmNFJY?=
 =?utf-8?B?THhSQitvKzRia3NBZnZYOWswTEtsNUpKS1lJMUlBa0N6amgzdEY2SnVhcWtk?=
 =?utf-8?B?YTFDTU5zVDE2dmhIQ3V4WTNpTGNRWm1SVUxVQ3RmRm4xNWRPM1g5RFNmM1E4?=
 =?utf-8?B?em84T3hCSmx6enR2Tm5ZSmlTQkNmcUpBMDg3THc1Ry9Na2VLZXhCOGJzSHVQ?=
 =?utf-8?B?Z0c4T2p2VHZHOUNQeDc5c2ROZmpnZ01BTzc5N2xwOTZycGgyUmdjaDRwb211?=
 =?utf-8?B?bityWHk4dXg2Z3hsdlU2NHJGYWY1RUVPaE1nc0hzbGZXUkFqeGRrcTdPaW9W?=
 =?utf-8?B?eGZ2K3ZVU2xtVkJ1c3phcHRLLzlaWm5DRDlmRHpkYjR3Sys4MnpiUTk5TGtN?=
 =?utf-8?B?WW5LRW5oRzBON3FBZk5sSys3VmY5cmM5SkxuV3ViMjk2L0MxWlBYd2ZJS1Rh?=
 =?utf-8?B?UCtmeFJjcU80L0cxZmViT2piRCtWK2VyclJHSHlmemxMNitJSWNzTFdJbnN0?=
 =?utf-8?B?aEZuWTRLc0VhZ1ZjckthQlNRREhGRVNLY3JwMUhPUmc1TVRhSW9FMDZrVnB6?=
 =?utf-8?B?bGpTWVdhcHJNejNJRDViR0dNaEgrR1VkYWpHaW93TldHUnJmQ3NIY1Rrb0dy?=
 =?utf-8?B?eWZvd0kvY0MrZDF4YkVCN2pIYzZRSnBsWU9pQmtrUWRpak5HR3hFVHdrZWR3?=
 =?utf-8?B?em0wOTJPM2JuWlMyVStxckxlNFp4SGRyNnNyWlp2V3UweGZSazN4QU41b05l?=
 =?utf-8?B?dVN2TTNiMHhGSVYxM3ZpcVUrQWFITjcxZnVoYXMvdGprVUN1RTVtTlNDWXVs?=
 =?utf-8?B?NlEzOTlLelpCckFRQTJWaDJnNUpOeGVQZ1FJZnhUNG9DTXNZVXFsZFhCZGx6?=
 =?utf-8?B?MWhUMHpPbXFic0F6ZnQ2MG5CaDNUc0FnNEdNV0tlY2llNytGK0lMZWJ6OStm?=
 =?utf-8?B?UDZxZDBwb1FCL0lHNzhHMjlrNU1ZendTOE13Y0tsRm9TbWMvN29SdmszR0RC?=
 =?utf-8?B?bGw0eWlNdzhGS0ZzZVNyMW16UktyRTYwQlVjUit4UXZSTVZXSGY5bnNnaGg1?=
 =?utf-8?B?ZmY5cVJOUW5oeUlWZ2hzQXR2RG0zckd0Z0Jtb3M2aFo5Y09WK2N1RHI1OWth?=
 =?utf-8?B?bng4blJRUkRyN3ZMeE9iRTRZQkNXTVNERWxscnZqNUR6MXNxQTE5TE93dUJv?=
 =?utf-8?B?Ni9UVEE5cE1kZVhxQVBVT3NBUjZzNmlqUW1lWk1JYTZ0VmdyemhWM1Bkalgv?=
 =?utf-8?B?aWRON1cyazhRck1rRWtaRTd2Zm9DTy8zSndMK1ZjSVlyUFd1blBuSk0rdFBw?=
 =?utf-8?B?TjE4UUc1UmR3a0JXSTJ4bHJ1a3UxWkNsamUydFZGTUZTT0xMM2ZBWXB5NTFa?=
 =?utf-8?B?SHUyMkVJbTVGRW9IZlFacHJRbFE3aEJsZkkyekQ3Y3pBL2lEaVh3K0dKVzBq?=
 =?utf-8?B?Y1dpeUZzdG5ocjRXc2hTOGtWZWNXMGVidXJMUHZjNHJOOFBGZTlZeHFKRmtI?=
 =?utf-8?B?QUJqbFdaOFQzYzIrT3pjOFk3VDZwRDlINGRYWUZrK1NIVkJsSG81U1I5YjJG?=
 =?utf-8?B?cEl1LzA1aFQyYnRtdGhORjB4Um04Nmo4dUVFR1RQa1A2VEQ4eEhvNnZIMWhY?=
 =?utf-8?B?bzBVM1phNFhBR3RzVndDZU92YlFMVVZ0RkNkeHNESUU0c1pTWlhmTmV0cXVs?=
 =?utf-8?B?bW9uV2QzUWJlT3ZmS1NtaUJ2ZldhamlaQytTMS9aNDVrTDdtQldEY1NmMHZQ?=
 =?utf-8?Q?TQfrgqfFMSUAIeS+c2/Oo2uiMyoyEZ68tN26JwH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e54cd3d-6342-46af-236f-08d8d9f16385
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 00:56:45.5119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmNopqlevF4xEQNMwya0FwPhPm8+S7Hx0Hm8jyaWo/VvhfzzQNKRU+q2HcHkTWZlOMsmxpMeNZja7uvuEViu5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3061
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260003
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Michael,

Are you okay to live without this ioctl for now? I think QEMU is the one 
that needs to be fixed and will have to be made legacy guest aware. I 
think the kernel can just honor the feature negotiation result done by 
QEMU and do as what's told to.Will you agree?

If it's fine, I would proceed to reverting commit fe36cbe067 and related 
code in question from the kernel.

Thanks,
-Siwei

On 2/24/2021 10:24 AM, Si-Wei Liu wrote:
>> Detecting it isn't enough though, we will need a new ioctl to notify
>> the kernel that it's a legacy guest. Ugh :(
> Well, although I think adding an ioctl is doable, may I know what the 
> use case there will be for kernel to leverage such info directly? Is 
> there a case QEMU can't do with dedicate ioctls later if there's 
> indeed differentiation (legacy v.s. modern) needed?
>
> One of the reason I asked is if this ioctl becomes a mandate for 
> vhost-vdpa kernel. QEMU would reject initialize vhost-vdpa if doesn't 
> see this ioctl coming?
>
> If it's optional, suppose the kernel may need it only when it becomes 
> necessary?
>
> Thanks,
> -Siwei

