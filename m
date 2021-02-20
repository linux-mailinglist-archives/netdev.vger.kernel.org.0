Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA2A320334
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 03:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBTCnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 21:43:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44246 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBTCm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 21:42:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11K2eWt7025564;
        Sat, 20 Feb 2021 02:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : cc : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ULm+jw7W/Hk7YAdPpTLglb+aLz8d193SGPpVmK6pluA=;
 b=Sxmi0CmZS2RawTU0Cl5qPZMg3UAGzVxQqsV2v1LmFMGGaoljzvhguBmz6GyHiuS3iB9F
 ODrvzLstJP0fe6r5RaxVbk90NFDmHj4ur+sb+tEaMCnSp8NoMqsP/dXnLCcWpBQaSPrM
 JoJfvb8+ksqpFjFD6S8euIzobo2tlO8m9/ISU9Clj6hYQdT9CF9Bz+lT0y/7VSO9jzE6
 uyYvHsbp9LlKcK1BOQugVg+G/ZGrhXz033onZJVvFyuM8RAdEu/PVctdWdQmYYkue8uu
 DZ9Zq3htM0O2S9QNRdscLqakAPhPrRSPXGnnVUF3jTuFjUhDHroejl1iusE3j/WHsBsa Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36tqxb83a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Feb 2021 02:42:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11K2eMKU122282;
        Sat, 20 Feb 2021 02:42:10 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by aserp3020.oracle.com with ESMTP id 36prp3ke67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Feb 2021 02:42:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTh28cGZcFf8XjhgzYCqHAQjDyz5xYmpTO72d/mDK1p9oti+aXmV9aGfmrGnkWTjJbdGA0iQI0qa2PLsw0kHS4gNE2g1FCJAc7SVzP6sos4y4Y0Yt+5PmfNuMT2EVdGr12TdIBWawdrg04NjOs8v+ETA82p3bpkc+MPdQTMkzDesIjUgeT6IpJrekkG1MM3BdquLrI16mvQDFNi63Bj0+3zHF7i9z22MWTy7asqgCNbItn4k2Bk80vaqAc4r0/lbQOWRMvAM0gyPz06Aa6b69re9lvjZRekHG8nxy5lA2ouzmhjiVJa4G6bgs2NXrrp6cIlvpfhe5HMdVDbrUDfLkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULm+jw7W/Hk7YAdPpTLglb+aLz8d193SGPpVmK6pluA=;
 b=BrmREe5M37CWFRA86/rL7vBQ6I2/Xq3nJAS0btOUMzt8pNI/kBxPtbUL5M3+u+5zRzcN9xWp8Bo+2OLU/sDwLFgJEP2+YLkaNdZyFfLLUO0JeNRUrjK9xj3llH79tMCExe8KeWSZqbFD+4KTpMikq2Y4sGD75gAZdgBEYO+YScVWJh4v3ebWDr3FGvYlDR1cZltkn9Vd0ASo65PpYKQMPGl93Oe5s1nL4BY3Xq/UOzsijI3ct+CZx8uKh8eelStRN81F7t2ECpzKfAc1e3jNbCeddv/rtaTRl0FNC0U2RG96HcsONpzS/M58ZhWzepvor34mQpNi2+iXu+T+IiH+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULm+jw7W/Hk7YAdPpTLglb+aLz8d193SGPpVmK6pluA=;
 b=TfZoWXL45Esii8qBCij3lrm9Cukf8cU+erKnVUdhr6NUjhJ05+6RNzy3xXjvWhgCbWBVqCw4ZH7GPX2Pe4rhncFMf7ldEjnA6MbNV/xLxwvt2/2VpmDBLvu8cyuwJIEHNLGZZ5vFLaOyvOseMS7Vsz8dJlZWMOqJ06P2hzbuX6Q=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3288.namprd10.prod.outlook.com (2603:10b6:a03:156::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Sat, 20 Feb
 2021 02:42:08 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3868.029; Sat, 20 Feb 2021
 02:42:07 +0000
Subject: Re: [PATCH 1/2] vdpa/mlx5: Fix suspend/resume index restoration
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     Eli Cohen <elic@nvidia.com>, jasowang@redhat.com
References: <20210216162001.83541-1-elic@nvidia.com>
 <4ecc1c7f-4f5a-68be-6734-e18dfeb91437@oracle.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Organization: Oracle Corporation
Message-ID: <033b0806-4037-5755-a1fa-91dbb58bab2e@oracle.com>
Date:   Fri, 19 Feb 2021 18:42:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <4ecc1c7f-4f5a-68be-6734-e18dfeb91437@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: CY4PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:903:18::23) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by CY4PR02CA0013.namprd02.prod.outlook.com (2603:10b6:903:18::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Sat, 20 Feb 2021 02:42:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c8190a6-2660-473a-0d95-08d8d5491d6c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3288:
X-Microsoft-Antispam-PRVS: <BYAPR10MB328857EC93A84835C5B6A65BB1839@BYAPR10MB3288.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKfIjVjeZNbUujIsMq5YHULcGtwXjJ58N5dl10vN6M0BM33m3QC29lQKmqmUJDq9cfZhLzjX/4ANujb03Aku49tLRJTb1b6Ek5IpXO0dEtHwJ5hapdGleA1FUdZi/hPyknjf1rWsjmOd3n+DRgyNPSX9lWrYspkSfjrXxc5gJNpe+J/9js8B4yax5Ld3UCVlBaOcW+QlN1cSBVqjudwOwOb/LMT2J1R+IOIdsSac5s2PSkROWhovvbmaOsmoRrO9faE+zaVhIhs1HXy5H+Fa4TvvN7DlXRB+4CT2OJMu+Wz2U+mSlLXw5bjA2/FNPP/0/eH3P9LvTMwXsbLYfruqkD+sZrQnNaSdKShwyvpp8Og44kR9xLOsEN02Orx8pK6lUYE2r/0x2GKnVQpnxrELtXk5qAAKz6YbFLqq31qFkAghuNrm9NAfi1c6BiZa2WKawT9zPQV7284f6vzWwuDIB1T6Sx9hqXbxEAkm+AqyqSwRJQpoz109la1nL20XbOH12sYOX5CETKrEwp9fSAdy0TtWbotHBzjy5wiUXqro5U4gisHYREwebEUaY8fqyyncpaMyFBmEs1BUJrOp1o2mGYPhNNfl7IoDcUG3Wc2ckS4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(16526019)(31696002)(186003)(66946007)(4326008)(8676002)(8936002)(66556008)(66476007)(36756003)(83380400001)(2906002)(53546011)(36916002)(86362001)(6486002)(15650500001)(26005)(478600001)(5660300002)(956004)(2616005)(31686004)(16576012)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OWF2ajNBWmhBRFkvT256U04rRVJSRTU5YVMvVmlieW1NT2drbXZXR3MxMnlt?=
 =?utf-8?B?Z2poVnpJNExqa3FCbnFkTnZlcGZiTmgzVW45NENIRWdBekRSK3E5TzJrU2lx?=
 =?utf-8?B?eDVicVp4L3JBbk9wTHQvQmpKTENmOEpXVXhhN1RSL21ndlkwUWJVamFGMVVY?=
 =?utf-8?B?eDZ5cmNDM2FWaWlWUnllK3VCZkdMUHBWMFNKS3k4QjVjVTZGcDJkUzBLeSsy?=
 =?utf-8?B?SXlUcFpBZnYvMnJuZ3dPdzJDbkFlMEloMDdlRXhTZU00SmVUNWQxS2gwdFFl?=
 =?utf-8?B?U1AwZW4wd3M3MkkzckpXL2doR2Z3NTNPOXJhbjFYTkViWmlMSDlFenROaXJ6?=
 =?utf-8?B?OHlDbjN2MXJqS3VBNjBRdjZHQmZaTHV2SktmbWF4VS9MYXNVTCtpbFc0T1F1?=
 =?utf-8?B?cUxDQnlDWDdmaVVCSUl4d0NFaXprTzZVVnZNbml4bWJ3QnVLMThnU2ZRbWEw?=
 =?utf-8?B?RlBVT1dwemV2cXlDZ2hoWDlMS0Y2NzFTc3JobHVaREZERjdlK0c1RkFMQi95?=
 =?utf-8?B?dEk4aDNkSHBjZ1E4WmcvMWpGdGJiWVdUUDJBVkFTdWhXSHhpU0wxcCtJNytx?=
 =?utf-8?B?R3hZM3hNZW80ZkVqUnlnS3c1QW0vUmUwQm02eUoxaXdvYzZISlRNaFY0emd5?=
 =?utf-8?B?bmxTY3VObEtFMGM1UVQ4RE0wRURhVC9aK3JGY3pCMTk0S1dwZTFmTXNrSyta?=
 =?utf-8?B?M1dBeXlTZG9GWnFKRGgrNWxiSkc1VzlCRGhnaDhDU1M5dlJpb05pWWM5K05W?=
 =?utf-8?B?Q1I0aFZiUXNFT3VVS21KREdaS0lXMjBueGhWd0R2aTQzR09weVBZa0czTjJn?=
 =?utf-8?B?emxtZUd5Q0ZOTklmSDBiaE0zVDZoczV3MzhWaUZYQVBpczlOTkNsRkhad2hU?=
 =?utf-8?B?cXQzREYvRUVzb3hzTllRK0RyeFlpVktPQW94QkVrWEF6Q0RCUkZxUVdUbWZP?=
 =?utf-8?B?YkNEaFRJMnNiTTF6cWtwOUJ0TGI0VFBUOUwyL2h1Mnd0YWozMC8vV3RiaHJI?=
 =?utf-8?B?ZXRVRnJGTHVHRTJ1V21ZU0RjZEpub0FmVkdSK1g0WFJEVjlRSEJyKy9QQ0d0?=
 =?utf-8?B?aFJRNG1YcXordFdXd2t3Z2krTTNPV1J3QWplcUZwUFBURFlCZmFQMElrUFJs?=
 =?utf-8?B?ZjRxNFBNdmJnWDJxYzQ4WmsyUkJJSGRzYkVub0xyNnRPWFdOalhOak8raVh5?=
 =?utf-8?B?YXlxY09jeTdsZkc3NktwYzkwTS9OZlQrdk0xNDdvMmZjc3JpcUxsWlhaK05Q?=
 =?utf-8?B?alB0eW5ZWGFNaUIyWnBRTjFGMUZrSEQ4L3NmdEtIbjlxQ0J5K1ZESXU3VzZk?=
 =?utf-8?B?RnJmVC90MDZlVG9PaHEwaVJHTE9hdXJ3Y0s4WC92dTdQSGtTWk1URktsTjhr?=
 =?utf-8?B?TXRVTytFMVVibFliQWRJZ0ZGTkJuS2k0K01nWDlzdHJxdlZrS2lKMHpTZmVY?=
 =?utf-8?B?WE0wZkMwamUrUXA5L09SME12VjY4NlFvcWQzbXV0SWFRb0RRbHZwMDBiS1Fy?=
 =?utf-8?B?RlhjZWVWWXVzVGFMeDBmd0xmUXlCbTlDZ2FKaXo4TlJLa1dqZUxtSTAwaUlZ?=
 =?utf-8?B?OWdPd2JZWGpYV2ZMMGtIWUdIQittS0JyZ1JhcFB2NzRwL1d6QUF1cjJRSFgz?=
 =?utf-8?B?cjc4MFYwVEI2OSsxMEpmWUhNUmFvZDRtbVR5dWFhTGhKV2R3R2JZTFUzdHRC?=
 =?utf-8?B?MHVuRjBuaVFoSWE0K2QyN0psUHJRb1VWNXdVMFBlZVczVHorY3Z3c0hLVlJB?=
 =?utf-8?Q?F+a399V4l0cNNwcvzc4wB+OnpQCGrTMZ98LHK5w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8190a6-2660-473a-0d95-08d8d5491d6c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2021 02:42:07.7433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b776r3UTQOqvFNInjNjkauQ/jFG5U7mJuJx/gt7YifxrHDik7OvOHxWel4RJ75YfD/aijNNPVztqA9E2FzieSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3288
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102200021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102200021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/2021 11:42 AM, Si-Wei Liu wrote:
>
>
> On 2/16/2021 8:20 AM, Eli Cohen wrote:
>> When we suspend the VM, the VDPA interface will be reset. When the VM is
>> resumed again, clear_virtqueues() will clear the available and used
>> indices resulting in hardware virqtqueue objects becoming out of sync.
>> We can avoid this function alltogether since qemu will clear them if
>> required, e.g. when the VM went through a reboot.
>>
>> Moreover, since the hw available and used indices should always be
>> identical on query and should be restored to the same value same value
>> for virtqueues that complete in order, we set the single value provided
>> by set_vq_state(). In get_vq_state() we return the value of hardware
>> used index.
>>
>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 
>> devices")
>> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Acked-by: Si-Wei Liu <si-wei.liu@oracle.com>

I'd take it back for the moment, according to Jason's latest comment. 
Discussion still going.

>
>> ---
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 ++++-------------
>>   1 file changed, 4 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c 
>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index b8e9d525d66c..a51b0f86afe2 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net 
>> *ndev, struct mlx5_vdpa_virtqueue *m
>>           return;
>>       }
>>       mvq->avail_idx = attr.available_index;
>> +    mvq->used_idx = attr.used_index;
>>   }
>>     static void suspend_vqs(struct mlx5_vdpa_net *ndev)
>> @@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct 
>> vdpa_device *vdev, u16 idx,
>>           return -EINVAL;
>>       }
>>   +    mvq->used_idx = state->avail_index;
>>       mvq->avail_idx = state->avail_index;
This is where things starts getting interesting. According to Jason, the 
original expectation of this API would be to restore the internal 
last_avail_index in the hardware. With Mellanox network vDPA hardware 
implementation, there's no such last_avail_index thing in the hardware 
but only a single last_used_index representing both indices, which 
should always be the same and in sync with each other. So from migration 
point of view, it appears logical to restore the saved last_avail_index 
to the last_used_index in the hardware, right? But what is the point to 
restore mvq->avail_idx?

Actually, this code path is being repurposed to address the index reset 
problem in the device reset scenario. Where the mvq->avail_idx and 
mvq->used_idx are both reset to 0 once device is reset. This is a bit 
crossing the boundary to me.


>>       return 0;
>>   }
>> @@ -1443,7 +1445,7 @@ static int mlx5_vdpa_get_vq_state(struct 
>> vdpa_device *vdev, u16 idx, struct vdpa
>>        * that cares about emulating the index after vq is stopped.
>>        */
>>       if (!mvq->initialized) {
>> -        state->avail_index = mvq->avail_idx;
>> +        state->avail_index = mvq->used_idx;
This is where the last_used_index gets loaded from the hardware (when 
device is stopped).

>>           return 0;
>>       }
>>   @@ -1452,7 +1454,7 @@ static int mlx5_vdpa_get_vq_state(struct 
>> vdpa_device *vdev, u16 idx, struct vdpa
>>           mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
>>           return err;
>>       }
>> -    state->avail_index = attr.available_index;
>> +    state->avail_index = attr.used_index;
This code path never gets called from userspace (when device is running).

-Siwei

>>       return 0;
>>   }
>>   @@ -1532,16 +1534,6 @@ static void teardown_virtqueues(struct 
>> mlx5_vdpa_net *ndev)
>>       }
>>   }
>>   -static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
>> -{
>> -    int i;
>> -
>> -    for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
>> -        ndev->vqs[i].avail_idx = 0;
>> -        ndev->vqs[i].used_idx = 0;
>> -    }
>> -}
>> -
>>   /* TODO: cross-endian support */
>>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev 
>> *mvdev)
>>   {
>> @@ -1777,7 +1769,6 @@ static void mlx5_vdpa_set_status(struct 
>> vdpa_device *vdev, u8 status)
>>       if (!status) {
>>           mlx5_vdpa_info(mvdev, "performing device reset\n");
>>           teardown_driver(ndev);
>> -        clear_virtqueues(ndev);
>>           mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>           ndev->mvdev.status = 0;
>>           ++mvdev->generation;
>

