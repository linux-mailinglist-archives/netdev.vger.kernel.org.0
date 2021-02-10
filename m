Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31AC3161C0
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhBJJCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:02:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56040 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhBJJAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:00:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A8rv3R045332;
        Wed, 10 Feb 2021 08:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FfcqhDBwQWgPiOEEnxf221gCCLTu9NIE01EDtUWHGHs=;
 b=BlY0bDpheRsebNqEg9wyAjFhHNfMBF61/pSOgWVTWoSkqth3fa+jh9MUFLJyngitFi6S
 3JhIuddwmC60Lpbgqdw6OYcbDWpPwAm0v1aN0BPqC+NvW9RsxbLzPYEL6K63oTYwo3C8
 ZQCVrtCjrVxhbo+q5YcHNSYU9I136zn8k0YTmfg0mnt9xZEE/CyGOcFuziUwuaF01Gyv
 q7rA4CgUTxwO69OTGtCZwwtfPHw2aWwP+o//L3VJUjDnkCnMsUK7vSAeD/Nkajs4YMTX
 pBMHtvSgx51tuVo0gEzt/zF1FZRbBKPUbvwAD8syp0Cn4GOI7FEHxp61B3W/x+K3JR01 cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmajm9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 08:59:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A8u2Cq133188;
        Wed, 10 Feb 2021 08:59:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 36j4ppvfjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 08:59:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dh06UElMhKKbPaWhR56UckSIpeOF7jp9XTXLdMDmyyXZQdZ8OnxDFIfudnYQwK/U7xvsw2+pQJJ8HAvEwWut4oM6mVFcuEYFURYkPegK/6/69ARnHImbdhmYvsAS7Qja3iYDuJdZAlkuPIvGsybxoAegwe/XDa3GQ9+RidJ03bGzAJ4B0s9JCVaU9chUuzdQbOa2aMuzDb/8Ps+T+HcgP6NK5tZuwuzzxGX5sWRCU/2hly9qBHAKifsZVKCo35r5uoJ2t9Qm/rQ3zQFlhq6mUUCHidOKcCCxUNsoVaxsWBHauC4a6yD7yEm/p0hzpks8bgkdT6tfHEFwbEmARh9Nxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfcqhDBwQWgPiOEEnxf221gCCLTu9NIE01EDtUWHGHs=;
 b=Wxd0BWW4r8B2meohqK8PkFzEIqdqKq9u1zREKrd+U59P2zpWJRJ6bMWUqe+bNZxHYq0SkXVbVqobiYDco63xM1Luv996Cf0Sp1RfY/y/2njyNTYd86vQo94xEFORgZHazlCFSLYfwbURMVdYQXO6wnnztAD6W0J+W201mnTf5V+tFhy9ZAxoYDMlZ3TNlI/9Jwfpas+wEEzafAgFDS09YhvNYQr/ZeFKtLDxHDpixM9oR6dovl7JLAh/5eOjav64p/iqrnG+C2Dd5yuwx/xTwp1ZoNxfnYLioEfzjw3RSob4FfOejeEqyXOCZ2SX6ZA4AoPY1UZ7Mw8dFNUS1H9GXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfcqhDBwQWgPiOEEnxf221gCCLTu9NIE01EDtUWHGHs=;
 b=WRKIprSGtg5oA0ieup7kPm0WkDuJ0eo31z20Jyp0dJMhX6lmuyNnbR8tJG4A1/hZs7afsEX0AZzwSorEI7jSf6JzAMHWCOHo5XpiuIyZfdo4eG9sBsSDuGYxsSpGIgPNwOJlJySSS48LsUU9d9UMWfOai6+LnpPvIwsLUuJJYEY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3319.namprd10.prod.outlook.com (2603:10b6:a03:150::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Wed, 10 Feb
 2021 08:59:14 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3846.026; Wed, 10 Feb 2021
 08:59:08 +0000
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com
References: <20210204073618.36336-1-elic@nvidia.com>
 <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
 <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
 <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
 <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
 <a90dd931-43cc-e080-5886-064deb972b11@oracle.com>
 <b749313c-3a44-f6b2-f9b8-3aefa2c2d72c@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <24d383db-e65c-82ff-9948-58ead3fc502b@oracle.com>
Date:   Wed, 10 Feb 2021 00:59:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <b749313c-3a44-f6b2-f9b8-3aefa2c2d72c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: SA9PR13CA0234.namprd13.prod.outlook.com
 (2603:10b6:806:25::29) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by SA9PR13CA0234.namprd13.prod.outlook.com (2603:10b6:806:25::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Wed, 10 Feb 2021 08:59:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e8ca782-ab33-443f-0fb8-08d8cda2200e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3319:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33196481AEF8154504E610C1B18D9@BYAPR10MB3319.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kE+6IzIpsAlHMoucJfjGLROJjJvV/z+ohIT4uRmH6qqZMfEilsCMPyzThPrqU6KtKi/GAzkvv/Ui+sMuFhSILjwezXqJX62m3JNcBFwXt/lXKUlPPIC+ZYrLc/GY/aABTc8/CsY9YeHfcvHCmj6LPThIoAN6PkS+8kdpTSYVR868J9LUfkB63+XOouKgLrSiMzfLjphF20gC50GYlHcqaogMAGk7NBPd5wUUjbQm/9Cnyuf2sABdowKKMqyI0XVyB++ODWJtP2KFtDaoTJHV+vPDE7c3gzU5wWcIJ693Biiaza6qAsEVsgc7SAxzuoFgudelRMhSKGtneWPeHCjC3XU/t04EPV9mUKeY478FQGR3kTlH1jvoPmt5LUEQ4u6zPxd4kvz/1uNTBi6jpuAytQNNIg4E2cNUlf5lv5bPl76LaBHTsEerNZZfc2Iy4UG6TsKs0CI02oNtbPWPMThiAfv23ayr2kwvp5R3hDGj1OUf/oJWRG9lgwzUX/ikzMb7+7F30sORHwcz79jZ94hC9DZv0qtT5BgwWDQqWZrS5IFrZeZl6ZNGaQuc5clROnWsb1Lby87/KCUppOw22OYh0u+CTppaqpsBEYdK7SIVoc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(376002)(346002)(86362001)(5660300002)(26005)(478600001)(36916002)(2616005)(956004)(186003)(30864003)(31696002)(36756003)(16526019)(8936002)(6486002)(66946007)(16576012)(316002)(110136005)(66556008)(66476007)(53546011)(4326008)(6666004)(2906002)(8676002)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Sm4chjTqQ3fzkKB8o4BfA5Aj8HjhD9iu0HGUg7DGM8vcax7yziAt1k6c06hIE3qqYzS+JToaMx+VD5ianFht3/hjmvJGRz1umtD82os3G7g3/boJpEAqwaNDOQJL6W59v4reWfN1JnDxZQ3DBBECLDzSz5AnsnDStiwrkK7oU5ICwv8DPVRsExk2NMClFi09jSpGHfI43cm6Kq/xfmIjeebsRygb/VMfwOOB5OhzMoPSwO9ygL7zKQsA0YK9Ou/GsLtAaPU6II5qNxR+GdqzbQaJqbFuR+DtXW6QJYB4SSFnrBeSDQ60pxpH9FfT/1IP4KDxdbyEIcBXYJZgae+BhVAOpR/PS47I1j03so93NSwe5cKbdVO8ktgmov9leoCMePeDCKfbr2Nyd5QjPuyd1mAmUPjhS6IPbFa09QalOYDfW3nQ9IfoTDHRnvjQJ/hSZQXUUmpr32S9z/9PasgHBPis7d8cwD0l6vXuFALNSbGI/bx8ePyuIWa/uRmBiTCWPORfirQE1ezw/NiYsS0wdcIDa6WMIoz7bpvrEACra0PJP2yHGAvOaRkAPFJgryaPkSo2t2BR5AmGNIO3sd/TFnFoZFFTdeVrVOGB3v65NSKRTaXSioLBQ4LRQ9rvZoIWgq7hy6VKestQtg/tnL0Lw9fpx8akSYEO9ajAB1G2CAHG8odvK2an2p89wkCOoAAupTLTAIwwa5F1Im0q5PY6fUmBlnpP283QCyWdsnmuUOkh55L2Wj0+G9xLOTwAtkmK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8ca782-ab33-443f-0fb8-08d8cda2200e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 08:59:08.1362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +D4xoEjeTTeUNoEAyCjML1W6HBivrUy4ESgtGLXHe66zFfBsM1GUbw9rt1qgXoy0iZ/+F7bqKANvGS1x5AoK0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3319
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/9/2021 7:53 PM, Jason Wang wrote:
>
> On 2021/2/10 上午10:30, Si-Wei Liu wrote:
>>
>>
>> On 2/8/2021 10:37 PM, Jason Wang wrote:
>>>
>>> On 2021/2/9 下午2:12, Eli Cohen wrote:
>>>> On Tue, Feb 09, 2021 at 11:20:14AM +0800, Jason Wang wrote:
>>>>> On 2021/2/8 下午6:04, Eli Cohen wrote:
>>>>>> On Mon, Feb 08, 2021 at 05:04:27PM +0800, Jason Wang wrote:
>>>>>>> On 2021/2/8 下午2:37, Eli Cohen wrote:
>>>>>>>> On Mon, Feb 08, 2021 at 12:27:18PM +0800, Jason Wang wrote:
>>>>>>>>> On 2021/2/6 上午7:07, Si-Wei Liu wrote:
>>>>>>>>>> On 2/3/2021 11:36 PM, Eli Cohen wrote:
>>>>>>>>>>> When a change of memory map occurs, the hardware resources 
>>>>>>>>>>> are destroyed
>>>>>>>>>>> and then re-created again with the new memory map. In such 
>>>>>>>>>>> case, we need
>>>>>>>>>>> to restore the hardware available and used indices. The 
>>>>>>>>>>> driver failed to
>>>>>>>>>>> restore the used index which is added here.
>>>>>>>>>>>
>>>>>>>>>>> Also, since the driver also fails to reset the available and 
>>>>>>>>>>> used
>>>>>>>>>>> indices upon device reset, fix this here to avoid regression 
>>>>>>>>>>> caused by
>>>>>>>>>>> the fact that used index may not be zero upon device reset.
>>>>>>>>>>>
>>>>>>>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for 
>>>>>>>>>>> supported mlx5
>>>>>>>>>>> devices")
>>>>>>>>>>> Signed-off-by: Eli Cohen<elic@nvidia.com>
>>>>>>>>>>> ---
>>>>>>>>>>> v0 -> v1:
>>>>>>>>>>> Clear indices upon device reset
>>>>>>>>>>>
>>>>>>>>>>>      drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
>>>>>>>>>>>      1 file changed, 18 insertions(+)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> index 88dde3455bfd..b5fe6d2ad22f 100644
>>>>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>>>>>>>>>>>          u64 device_addr;
>>>>>>>>>>>          u64 driver_addr;
>>>>>>>>>>>          u16 avail_index;
>>>>>>>>>>> +    u16 used_index;
>>>>>>>>>>>          bool ready;
>>>>>>>>>>>          struct vdpa_callback cb;
>>>>>>>>>>>          bool restore;
>>>>>>>>>>> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>>>>>>>>>>>          u32 virtq_id;
>>>>>>>>>>>          struct mlx5_vdpa_net *ndev;
>>>>>>>>>>>          u16 avail_idx;
>>>>>>>>>>> +    u16 used_idx;
>>>>>>>>>>>          int fw_state;
>>>>>>>>>>>            /* keep last in the struct */
>>>>>>>>>>> @@ -804,6 +806,7 @@ static int create_virtqueue(struct 
>>>>>>>>>>> mlx5_vdpa_net
>>>>>>>>>>> *ndev, struct mlx5_vdpa_virtque
>>>>>>>>>>>            obj_context = 
>>>>>>>>>>> MLX5_ADDR_OF(create_virtio_net_q_in, in,
>>>>>>>>>>> obj_context);
>>>>>>>>>>>          MLX5_SET(virtio_net_q_object, obj_context, 
>>>>>>>>>>> hw_available_index,
>>>>>>>>>>> mvq->avail_idx);
>>>>>>>>>>> +    MLX5_SET(virtio_net_q_object, obj_context, hw_used_index,
>>>>>>>>>>> mvq->used_idx);
>>>>>>>>>>>          MLX5_SET(virtio_net_q_object, obj_context,
>>>>>>>>>>> queue_feature_bit_mask_12_3,
>>>>>>>>>>> get_features_12_3(ndev->mvdev.actual_features));
>>>>>>>>>>>          vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, 
>>>>>>>>>>> obj_context,
>>>>>>>>>>> virtio_q_context);
>>>>>>>>>>> @@ -1022,6 +1025,7 @@ static int connect_qps(struct 
>>>>>>>>>>> mlx5_vdpa_net
>>>>>>>>>>> *ndev, struct mlx5_vdpa_virtqueue *m
>>>>>>>>>>>      struct mlx5_virtq_attr {
>>>>>>>>>>>          u8 state;
>>>>>>>>>>>          u16 available_index;
>>>>>>>>>>> +    u16 used_index;
>>>>>>>>>>>      };
>>>>>>>>>>>        static int query_virtqueue(struct mlx5_vdpa_net 
>>>>>>>>>>> *ndev, struct
>>>>>>>>>>> mlx5_vdpa_virtqueue *mvq,
>>>>>>>>>>> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct
>>>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>>>>>>>>>>>          memset(attr, 0, sizeof(*attr));
>>>>>>>>>>>          attr->state = MLX5_GET(virtio_net_q_object, 
>>>>>>>>>>> obj_context, state);
>>>>>>>>>>>          attr->available_index = MLX5_GET(virtio_net_q_object,
>>>>>>>>>>> obj_context, hw_available_index);
>>>>>>>>>>> +    attr->used_index = MLX5_GET(virtio_net_q_object, 
>>>>>>>>>>> obj_context,
>>>>>>>>>>> hw_used_index);
>>>>>>>>>>>          kfree(out);
>>>>>>>>>>>          return 0;
>>>>>>>>>>>      @@ -1535,6 +1540,16 @@ static void 
>>>>>>>>>>> teardown_virtqueues(struct
>>>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>>>          }
>>>>>>>>>>>      }
>>>>>>>>>>>      +static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
>>>>>>>>>>> +{
>>>>>>>>>>> +    int i;
>>>>>>>>>>> +
>>>>>>>>>>> +    for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
>>>>>>>>>>> +        ndev->vqs[i].avail_idx = 0;
>>>>>>>>>>> +        ndev->vqs[i].used_idx = 0;
>>>>>>>>>>> +    }
>>>>>>>>>>> +}
>>>>>>>>>>> +
>>>>>>>>>>>      /* TODO: cross-endian support */
>>>>>>>>>>>      static inline bool mlx5_vdpa_is_little_endian(struct 
>>>>>>>>>>> mlx5_vdpa_dev
>>>>>>>>>>> *mvdev)
>>>>>>>>>>>      {
>>>>>>>>>>> @@ -1610,6 +1625,7 @@ static int save_channel_info(struct
>>>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>>>>>>>>>>>              return err;
>>>>>>>>>>>            ri->avail_index = attr.available_index;
>>>>>>>>>>> +    ri->used_index = attr.used_index;
>>>>>>>>>>>          ri->ready = mvq->ready;
>>>>>>>>>>>          ri->num_ent = mvq->num_ent;
>>>>>>>>>>>          ri->desc_addr = mvq->desc_addr;
>>>>>>>>>>> @@ -1654,6 +1670,7 @@ static void restore_channels_info(struct
>>>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>>>                  continue;
>>>>>>>>>>>                mvq->avail_idx = ri->avail_index;
>>>>>>>>>>> +        mvq->used_idx = ri->used_index;
>>>>>>>>>>>              mvq->ready = ri->ready;
>>>>>>>>>>>              mvq->num_ent = ri->num_ent;
>>>>>>>>>>>              mvq->desc_addr = ri->desc_addr;
>>>>>>>>>>> @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct
>>>>>>>>>>> vdpa_device *vdev, u8 status)
>>>>>>>>>>>          if (!status) {
>>>>>>>>>>>              mlx5_vdpa_info(mvdev, "performing device 
>>>>>>>>>>> reset\n");
>>>>>>>>>>>              teardown_driver(ndev);
>>>>>>>>>>> +        clear_virtqueues(ndev);
>>>>>>>>>> The clearing looks fine at the first glance, as it aligns 
>>>>>>>>>> with the other
>>>>>>>>>> state cleanups floating around at the same place. However, 
>>>>>>>>>> the thing is
>>>>>>>>>> get_vq_state() is supposed to be called right after to get 
>>>>>>>>>> sync'ed with
>>>>>>>>>> the latest internal avail_index from device while vq is 
>>>>>>>>>> stopped. The
>>>>>>>>>> index was saved in the driver software at vq suspension, but 
>>>>>>>>>> before the
>>>>>>>>>> virtq object is destroyed. We shouldn't clear the avail_index 
>>>>>>>>>> too early.
>>>>>>>>> Good point.
>>>>>>>>>
>>>>>>>>> There's a limitation on the virtio spec and vDPA framework 
>>>>>>>>> that we can not
>>>>>>>>> simply differ device suspending from device reset.
>>>>>>>>>
>>>>>>>> Are you talking about live migration where you reset the device 
>>>>>>>> but
>>>>>>>> still want to know how far it progressed in order to continue 
>>>>>>>> from the
>>>>>>>> same place in the new VM?
>>>>>>> Yes. So if we want to support live migration at we need:
>>>>>>>
>>>>>>> in src node:
>>>>>>> 1) suspend the device
>>>>>>> 2) get last_avail_idx via get_vq_state()
>>>>>>>
>>>>>>> in the dst node:
>>>>>>> 3) set last_avail_idx via set_vq_state()
>>>>>>> 4) resume the device
>>>>>>>
>>>>>>> So you can see, step 2 requires the device/driver not to forget the
>>>>>>> last_avail_idx.
>>>>>>>
>>>>>> Just to be sure, what really matters here is the used index. 
>>>>>> Becuase the
>>>>>> vriqtueue itself is copied from the src VM to the dest VM. The 
>>>>>> available
>>>>>> index is alreay there and we know the hardware reads it from there.
>>>>>
>>>>> So for "last_avail_idx" I meant the hardware internal avail index. 
>>>>> It's not
>>>>> stored in the virtqueue so we must migrate it from src to dest and 
>>>>> set them
>>>>> through set_vq_state(). Then in the destination, the virtqueue can be
>>>>> restarted from that index.
>>>>>
>>>> Consider this case: driver posted buffers till avail index becomes the
>>>> value 50. Hardware is executing but made it till 20 when virtqueue was
>>>> suspended due to live migration - this is indicated by hardware used
>>>> index equal 20.
>>>
>>>
>>> So in this case the used index in the virtqueue should be 20? 
>>> Otherwise we need not sync used index itself but all the used 
>>> entries that is not committed to the used ring.
>>
>> In other word, for mlx5 vdpa there's no such internal last_avail_idx 
>> stuff maintained by the hardware, right? 
>
>
> For each device it should have one otherwise it won't work correctly 
> during stop/resume. See the codes mlx5_vdpa_get_vq_state() which calls 
> query_virtqueue() that build commands to query "last_avail_idx" from 
> the hardware:
>
>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, 
> MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, 
> MLX5_OBJ_TYPE_VIRTIO_NET_Q);
>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mvq->virtq_id);
>     MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
>     err = mlx5_cmd_exec(ndev->mvdev.mdev, in, sizeof(in), out, outlen);
>     if (err)
>         goto err_cmd;
>
>     obj_context = MLX5_ADDR_OF(query_virtio_net_q_out, out, obj_context);
>     memset(attr, 0, sizeof(*attr));
>     attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>     attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, 
> hw_available_index);
>
Eli should be able to correct me, but this hw_available_index might just 
be a cached value of virtqueue avail_index in the memory from the most 
recent sync. I doubt it's the one you talked about in software 
implementation. If I understand Eli correctly, hardware will always 
reload the latest avail_index from memory whenever it's being sync'ed 
again.

<quote>
The hardware always goes to read the available index from memory. The 
requirement to configure it when creating a new object is still a 
requirement defined by the interface so I must not violate interface 
requirments.
</quote>

If the hardware does everything perfectly that is able to flush pending 
requests, update descriptors, rings plus used indices all at once before 
the suspension, there's no need for hardware to maintain a separate 
internal index than the h/w used_index. The hardware can get started 
from the saved used_index upon resuming. I view this is of (hardware) 
implementation choices and thought it does not violate the virtio spec?


>
>
>
>> And the used_idx in the virtqueue is always in sync with the hardware 
>> used_index, and hardware is supposed to commit pending used buffers 
>> to the ring while bumping up the hardware used_index (and also 
>> committed to memory) altogether prior to suspension, is my 
>> understanding correct here? Double checking if this is the expected 
>> semantics of what 
>> modify_virtqueue(MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND) should achieve.
>>
>> If the above is true, then it looks to me for mlx5 vdpa we should 
>> really return h/w used_idx rather than the last_avail_idx through 
>> get_vq_state(), in order to reconstruct the virt queue state post 
>> live migration. For the set_map case, the internal last_avail_idx 
>> really doesn't matter, although both indices are saved and restored 
>> transparently as-is.
>
>
> Right, a subtle thing here is that: for the device that might have 
> can't not complete all virtqueue requests during vq suspending, the 
> "last_avail_idx" might not be equal to the hardware used_idx. Thing 
> might be true for the storage devices that needs to connect to a 
> remote backend. But this is not the case of networking device, so 
> last_avail_idx should be equal to hardware used_idx here. 
Eli, since it's your hardware, does it work this way? i.e. does the 
firmware interface see a case where virtqueue requests can't be 
completed before suspending vq?

> But using the "last_avail_idx" or hardware avail_idx should always be 
> better in this case since it's guaranteed to correct and will have 
> less confusion. We use this convention in other types of vhost 
> backends (vhost-kernel, vhost-user).
>
> So looking at mlx5_set_vq_state(), it probably won't work since it 
> doesn't not set either hardware avail_idx or hardware used_idx:
The saved mvq->avail_idx will be used to recreate hardware virtq object 
and the used index in create_virtqueue(), once status DRIVER_OK is set. 
I suspect we should pass the index to mvq->used_idx in 
mlx5_vdpa_set_vq_state() below instead.


Thanks,
-Siwei
>
> static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>                   const struct vdpa_vq_state *state)
> {
>     struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>     struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>     struct mlx5_vdpa_virtqueue *mvq = &ndev->vqs[idx];
>
>     if (mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY) {
>         mlx5_vdpa_warn(mvdev, "can't modify available index\n");
>         return -EINVAL;
>     }
>
>     mvq->avail_idx = state->avail_index;
>     return 0;
> }
>
> Depends on the hardware, we should either set hardware used_idx or 
> hardware avail_idx here.
>
> I think we need to clarify how device is supposed to work in the 
> virtio spec.
>
> Thanks
>
>
>>
>> -Siwei
>>
>>>
>>>
>>>> Now the vritqueue is copied to the new VM and the
>>>> hardware now has to continue execution from index 20. We need to tell
>>>> the hardware via configuring the last used_index.
>>>
>>>
>>> If the hardware can not sync the index from the virtqueue, the 
>>> driver can do the synchronization by make the last_used_idx equals 
>>> to used index in the virtqueue.
>>>
>>> Thanks
>>>
>>>
>>>>   So why don't we
>>>> restore the used index?
>>>>
>>>>>> So it puzzles me why is set_vq_state() we do not communicate the 
>>>>>> saved
>>>>>> used index.
>>>>>
>>>>> We don't do that since:
>>>>>
>>>>> 1) if the hardware can sync its internal used index from the 
>>>>> virtqueue
>>>>> during device, then we don't need it
>>>>> 2) if the hardware can not sync its internal used index, the 
>>>>> driver (e.g as
>>>>> you did here) can do that.
>>>>>
>>>>> But there's no way for the hardware to deduce the internal avail 
>>>>> index from
>>>>> the virtqueue, that's why avail index is sycned.
>>>>>
>>>>> Thanks
>>>>>
>>>>>
>>>
>>
>

