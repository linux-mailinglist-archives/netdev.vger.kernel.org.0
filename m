Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC1F31E1AC
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhBQV4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:56:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59372 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBQV40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:56:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HLg0lh108684;
        Wed, 17 Feb 2021 21:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8Zu9SEQHhuhbvbvaM/5omTKjZmx+hjC5srEapnLfGzY=;
 b=MqWDLjfARavsibRMCOZl9EXP1cg8xTIbNI5USBbq700AQtip+6H8wimjg2/wLGdgCdxj
 JNZ58Z0PDrs2B/zbjOV0+RWCSOgWLP4PPxQE3cP5z+osjzpZjR+D+x86Pz5iA6bRqqFB
 FTKOCJn6WNXnm0v3yj6ZGSrnZBr9m6bslGBe5hc6iAmT5TCiJGTsidaMxGYoznX3TODw
 nw3GjRmmsxKwlehlZlcBZLt3ii3+cbFCMQAQwi1+brr8zUjZTXo0w2LfGTvKp9gk2uI1
 5KmDc+6bDogEq/DJgR9Pb8DtCRqZV8RzdQZrdOovASzBU927J9kXod83eqc16E+oiBw/ Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36pd9abf07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:55:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HLeQOb120238;
        Wed, 17 Feb 2021 21:55:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 36prbq0ejj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:55:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUNmuOTndeitLqiJPpCHPkun3eWC8VOVGWtRQr23oh8ZWMmg1uIL1HsEwCG0COXHvWcz1iQELmJA/a+I/VdQieuEQJRgYCHp3hKvmPtYyrANjVS9fPWtZl1gnGOtDZy7aKq8wL7gMje6bmoye5W6eprXk/0SbN800HfSJ6nwozyAiCS7+bMGLZS+c9SBOFM6MeAjXBy3Xwgmk8in4FYuQ5H1orozmJKfSVDphMsOTm8jhPYyh/9TYGG8cVHf4xtNNf0AI945eb7W1fZDjHozwqX5pZ8gyYJGgARw4Pq4lvWqhAP4QjchavL4BP/JK4XCni5nkJMQcPY7Q9VJ7U0H1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Zu9SEQHhuhbvbvaM/5omTKjZmx+hjC5srEapnLfGzY=;
 b=LrWerEuI3uZcSiR3T/GpDGiupMIr+OoWlPE1iEA3+YjdUcFxdfD3VtC0Ne1+Sweo8FeVjj0DN94hkIE5B4yIsstuRGTIyv76EGaacONy+J3sHoMVevTfYgMoPBWqVSmj/2WDJ1/CB24dwvhG/gKKdSQuaIIms4Q2E7xJg7cOAFqfQ83M1aKuTbzVQlkizWGfn6cC4ZTocXoRdt9VHCIpJh3X8zC61ieA3isOKXwx0pTQRpPiyuotXbqU/ZLU8bPwdd0LbzaYRY0MjtrwFCeeeQNDQaP4nnNHRBkOJcQwB9EMXVhr8XaD1d1UsdFKlNb8t2mdgRLyWiJClWH3I2AZfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Zu9SEQHhuhbvbvaM/5omTKjZmx+hjC5srEapnLfGzY=;
 b=Orooiy0rHeXzcyYC9TD8XJRLiqOyxqtJqe59d7Gr/3OkDeNhSWSemuncQ4Kj9j+1HNWYvw08U+PD451fW+HyTFw1uMhIGK4g+JbpANx3bccPVHd07axVJtoccg1rlb8jAX8kVNvS8HD5sX5XAeS//dqGk06Zhy6PFfp/iPRyKh8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Wed, 17 Feb
 2021 21:55:39 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 21:55:39 +0000
Subject: Re: [PATCH v2 3/3] vdpa/mlx5: defer clear_virtqueues to until
 DRIVER_OK
To:     Eli Cohen <elic@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
 <1612993680-29454-4-git-send-email-si-wei.liu@oracle.com>
 <20210211073314.GB100783@mtl-vdi-166.wap.labs.mlnx>
 <20210216152148.GA99540@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <88ecbbb6-a339-a5cd-82b7-387225a45d36@oracle.com>
Date:   Wed, 17 Feb 2021 13:55:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210216152148.GA99540@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 21:55:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12017a1c-beff-413a-c533-08d8d38ec34d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4129:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4129211ABB9B4AA14D88FD6EB1869@BY5PR10MB4129.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlSVbgZSWR4NzTBwdFeX7OJpHK6OQ0sxwQjBA87jBFey1KKf7IT6YWByCOQwNtsMA4rXPrwyoVZcnVLCMBpdlPN4Z1TR86EKXSgxpH2ly/vOH81qB588PPgq6c4/e5bRFjxpsQcEqlTTpQn8bLbrQ0INMdcPu+HKDOnUThOUYuOTWAIEIa/WnSWs2L+De5gNPrNel9xTlnh0ABkjfHtzDThKmd5sWmVz/0LN3PPyhuz8NkRizjLCFNHWsu87RUdoQiMNRdXZKEXvmEnX7MMpZldi1hJZ4xYPnpwm5uebELilcTm19ARAsnwxMwzsgUUxfKlSx2NfgPsQ4OFzLTBnLB8sc5mrGDeprKNq8gZVP/t5Ak/RnNubaZYRsV96+P3VLhJLwi241MsuM/dSxcHAH1gPl76kbM6FdUEtNpo++v+/4pbf1A6o+pArS+HMstuMlfp8YNWk4T/Eoe01r2mew1lAx5jlG0PcfBNDA3BiLfH9MatBtkF/buToEk7ytEVlicOYFfr2NF85sj1Hv1du13SHpp5vCpC2RlIAeeSKDgBqeR6DTL9gooZJr7kmD9AuePFm8EcL9Ej6fcEAESIKBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(6486002)(36756003)(186003)(2906002)(2616005)(16526019)(6666004)(478600001)(110136005)(31696002)(86362001)(956004)(8936002)(31686004)(83380400001)(4326008)(66476007)(53546011)(8676002)(66556008)(36916002)(5660300002)(26005)(16576012)(66946007)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U2NOMHFNUm12cWJ4akRiRUNyUStveTZiVUY5VG9aY2JLb2ZZSzdrUEx5cWR1?=
 =?utf-8?B?YlhabUNFc1VrNkdrK3pxenUwTjVxeGtNeUNvV2tCQ3lDeXhid2twZ1hxTEtz?=
 =?utf-8?B?RGY1SUtlc1Y5WG83RWhJWmtJdi9tdVhRTEhDcEZMNThZU2xkdllSbzVpS1Uy?=
 =?utf-8?B?VWJXUXVHTzVXRUV4aTc5bXNOcG1ZK2FNWUxTcmN5bnl4V3FRWTNnZ0VKMjNS?=
 =?utf-8?B?NEljVEVBYzZBUURuVFI2YkQ3M1dSQkVDd0VhaVdTOE9oOHdrRXlObVUxOUNP?=
 =?utf-8?B?WWYyNlpJS3M2ZnJsK2o2NUY3UUU5UVVmS2N0S2hSRWovczhmclhYNkc5a1Bx?=
 =?utf-8?B?S1lJdTF3ZExuT3cweHBwWHkwbndSWW0vVnZpTmpXL0c5MmR0d0RPZUU3Q2oy?=
 =?utf-8?B?M0J6YXM0VFpoNnZIUVJ0UjhROUNPL2dzc1RpMTNVZzRVYWEreGNCMTMwV2dx?=
 =?utf-8?B?WlhSN2FWL21NRVZIS0wwd2p1cDdnK1FWeVJJczg3RG44enhJS0luL3dpMFlz?=
 =?utf-8?B?NWYwQVZDaWgxaHNPYU9JWVo1bmp4U2J3ajhvTXZIOUJUMzB4OHV4eW5FNCtt?=
 =?utf-8?B?amVHWFJ1dkNqTk1zRTY0aVZPWnl6Wnk2TmhwRVNWYkQ5WnVsbEpiSXF3UC8x?=
 =?utf-8?B?SmVoeHh6QTh2SUxsT3d2am1SWEtlVDU2a01YOEhvelA5aDhnaGJYeU5TWnB3?=
 =?utf-8?B?Mkd1c21JeVBZMWJUMFEvVXoyRG1IRXRBNENLR0YvSnFFTzl2NmVkQ2ZyOFB1?=
 =?utf-8?B?bWF2R1NUTUEzT3liNWNXU2hXdDFiTWo4OCs5aXgvTGJWR1JYSDV3ajkyeitl?=
 =?utf-8?B?QkJPd3BFbUI5Z0hKOUxpNkNBSmJpcEJsS1pHcnN6emxheE5hVlI4UCtsNjZ5?=
 =?utf-8?B?aWRaRnpNd21IYXBCbEpWL3J2YUs2UUNGWDh2bEx1TnR3NmVVSVhCOUNDVEpX?=
 =?utf-8?B?dGN1aTZFNXZtRmJNbXAwSGxmdWora05jQS9mRmlaMHFjNzNtUmFPbWxUbkNK?=
 =?utf-8?B?R0g3aWFzY3NpSjhZK0YxU3BZejc1Ym1zcTdkM3FRU1JpTFN0OGtXWU55ZmQ5?=
 =?utf-8?B?bzJtdkxrbXJFSW4ySXFUaUZEeGplVHc0aWJLRzJIWUxROWpkQnJvSmxqcXBV?=
 =?utf-8?B?U1RCSDhtRTRsSFUyU3NkcTJyNnpPeW5lelNhVzl5U1AyRDBxNXhqcm1CZkxh?=
 =?utf-8?B?VlVhTVpmYkN3SldGa0hFVGp3dk16dys5ckR0MDZEWXVXNXcwZk1qL3JUQlhD?=
 =?utf-8?B?ZFF4MUNNa3Bkam9vODBxc0htbm9JNzlxOXBxWFF4SnVQQUM5SlcrbjBndThL?=
 =?utf-8?B?bVRSekhoNHRyWGhHa0dvRTgwR3Q2L3B3ZVN0UGo3S0VjYlRWQ0w5VnV6UGR4?=
 =?utf-8?B?MlhEL3BpNWZOZDJSRVowNmdzUGpGeFdOMW45VFBoUG13azJPZzdDSkhidFpT?=
 =?utf-8?B?OGY3WUlPZG1OOWpZeVhnOTJpQWNRVFdPRi9RLzRkVnM2dUtNcUR6THlQc0Ft?=
 =?utf-8?B?d1gzNlR6bXdpd2NrTGJocnNRcS9KK0ZlMW8wUnRDdmxBeTZZWFltSXVYbUZX?=
 =?utf-8?B?TjhPcEdKak1UbGhmNmgwYmxONmVodktzRUxhUjNqWUpvaEl4TFhjUU03MGx5?=
 =?utf-8?B?WW1kd1QwOE92VHpJRm56TWtpRDdzbjhISjhncnFYWFRpZ1BkWCtneEgvMFNj?=
 =?utf-8?B?MWdtd3UvOGY3TGYrcnJVMDF1RkNYWjBKd3JsQTQ4OGJMVGpkWmtSemhGb21m?=
 =?utf-8?Q?DmJiqYETlZFoQyoQjdSQFCACy+niHeVKi9XMDIB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12017a1c-beff-413a-c533-08d8d38ec34d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 21:55:39.0484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /FA4wYIHshby6jucIwDWOh1nrbHZ6BgLAIJa/dfg6SsnwNo5Ba+bQwqJ36FMP8C3R6dB/wPiEa7m93FSweSNVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4129
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170161
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170161
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2021 7:21 AM, Eli Cohen wrote:
> On Thu, Feb 11, 2021 at 09:33:14AM +0200, Eli Cohen wrote:
>> On Wed, Feb 10, 2021 at 01:48:00PM -0800, Si-Wei Liu wrote:
>>> While virtq is stopped,  get_vq_state() is supposed to
>>> be  called to  get  sync'ed  with  the latest internal
>>> avail_index from device. The saved avail_index is used
>>> to restate  the virtq  once device is started.  Commit
>>> b35ccebe3ef7 introduced the clear_virtqueues() routine
>>> to  reset  the saved  avail_index,  however, the index
>>> gets cleared a bit earlier before get_vq_state() tries
>>> to read it. This would cause consistency problems when
>>> virtq is restarted, e.g. through a series of link down
>>> and link up events. We  could  defer  the  clearing of
>>> avail_index  to  until  the  device  is to be started,
>>> i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
>>> set_status().
>>>
>>> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
>>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>> Acked-by: Jason Wang <jasowang@redhat.com>
>> Acked-by: Eli Cohen <elic@nvidia.com>
>>
> I take it back. I think we don't need to clear the indexes at all. In
> case we need to restore indexes we'll get the right values through
> set_vq_state(). If we suspend the virtqueue due to VM being suspended,
> qemu will query first and will provide the the queried value. In case of
> VM reboot, it will provide 0 in set_vq_state().
>
> I am sending a patch that addresses both reboot and suspend.
With set_vq_state() repurposed to restoring used_index I'm fine with 
this approach.

Do I have to repost a v3 of this series while dropping the 3rd patch?

-Siwei
>
>>> ---
>>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index 7c1f789..ce6aae8 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -1777,7 +1777,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>>   	if (!status) {
>>>   		mlx5_vdpa_info(mvdev, "performing device reset\n");
>>>   		teardown_driver(ndev);
>>> -		clear_virtqueues(ndev);
>>>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>>   		ndev->mvdev.status = 0;
>>>   		++mvdev->generation;
>>> @@ -1786,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>>   
>>>   	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
>>>   		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>>> +			clear_virtqueues(ndev);
>>>   			err = setup_driver(ndev);
>>>   			if (err) {
>>>   				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
>>> -- 
>>> 1.8.3.1
>>>

