Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5DB315B55
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhBJAfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:35:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34708 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbhBJA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:27:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A0NtxX013657;
        Wed, 10 Feb 2021 00:27:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9/y2xqYZdAVA2eLu4Eady3GhobXAy4M+KrLahjlb+/o=;
 b=DZRHX4Bj+gPxa/YInq6tgwkPy4PgE99d79WQLIUYtFvP/LxOgEd5ozAjFiyAg4UzuL6z
 fljWBc4QoIjg2QWtkgB014R5DW01IAVfnysxKA2vAeQfnnmePtpF3cMeiZ4oZsblA0pw
 pleyQ60LTVAnm9Ww8SUDOKV4s4UARYKBwCOKAY/hjv6sNCgaE8FXvyqxnlrN8ohZZltp
 GMSIYNO3nL3JdcOOD01OF+Nm2Z/4HmjJizZ8jFOUFJ0PlFm1MH7P82KzP9sL7/ehsK63
 LyPvlS/8cQUWpEc3F8k83zABQQDMMGPFDIpUIQ9vBIxOe7SE6+8mp0WlsA4fk3c7bbD0 eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmahksa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 00:27:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A0PwKv180540;
        Wed, 10 Feb 2021 00:27:05 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        by aserp3030.oracle.com with ESMTP id 36j4ppfrgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 00:27:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0YKJrEcBP9zxTApeEzME8i2Pj85HUiarWQSDpkppnFuciTe4uf7RCYZW/S+OwoLoP8IqZWiNV21y5IiW38R8MIWZb034a/B0qh2/2e/yug07JJdsGmKc+Klaf04IwZXhs4lP/h+rHfiAnhiKrHE30k8FtFU2+mDWagrFI0A9XL6Z7JvpMmN9F3tRqUHqoi4sQNr0zkVUUHgIhgKO0GP2xPaDVb3BfyrRDEoWGN2ECp+gxhrs2lTSB6BEZzk81yjX/kv+1l8ARvWWqHFxSv0P4Iz4N+4EuFseSOgLNEtRqdFpP0DMrpS1WHhBYaPWUelg4e6RYrlwWhhu/vF5RKGbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/y2xqYZdAVA2eLu4Eady3GhobXAy4M+KrLahjlb+/o=;
 b=cnOp5Ok8cW4SFQM448poVecP6P2HCZT2niTyYgs5AYK2Gar06g7lQwShuAmo0332wOY4rRQXKoPcxTmGqs+r2So00XfVEMu2oUiu3huABLe3pNyX7qncOwilBG4GauK+uWK9zW3BVQSrnuIoxtuYXS0B5L1nKASOXFnCRyDa+JrEWN8J1o62AutTxqTeSVCeZwkCkiRnFFkruelS2vTYZlerLdwpL0NYUuP3mGxkGzVymr1IFYD//I0AKKSPdY9x/Vp1IF0NynlILQQSdXBglpHjr5tgIHoerqVMxbn3tB8QmT6aEOMZSOSzFK5/kh5Jiae60oSyZRGxO4XnDKM9Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/y2xqYZdAVA2eLu4Eady3GhobXAy4M+KrLahjlb+/o=;
 b=wrs96b6sr/+PwpAI5GBFGHW8Nf91NlQk6J1oO/4Sg5zKS81JpY5ZRC368WtOzuHzbEwkW3XXDEdssuCnmpJnoupGay0p/JcKRq8AXSYkzdx/xh9lEKaWhPvpxWI0aW+ud6E/k5dffifp6QwTHyLZIn6od/5QW03ISn8aFdIY1wI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3285.namprd10.prod.outlook.com (2603:10b6:a03:159::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.24; Wed, 10 Feb
 2021 00:27:03 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3846.026; Wed, 10 Feb 2021
 00:27:03 +0000
Subject: Re: [PATCH 3/3] mlx5_vdpa: defer clear_virtqueues to until DRIVER_OK
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-3-git-send-email-si-wei.liu@oracle.com>
 <2e2bc8d7-5d64-c28c-9aa0-1df32c7dcef3@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <00d3ec60-3635-a5f1-15fc-21e6ce53202b@oracle.com>
Date:   Tue, 9 Feb 2021 16:26:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <2e2bc8d7-5d64-c28c-9aa0-1df32c7dcef3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: SN7PR04CA0073.namprd04.prod.outlook.com
 (2603:10b6:806:121::18) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by SN7PR04CA0073.namprd04.prod.outlook.com (2603:10b6:806:121::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26 via Frontend Transport; Wed, 10 Feb 2021 00:27:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83b9d6e9-73ac-4ea1-afe8-08d8cd5a9684
X-MS-TrafficTypeDiagnostic: BYAPR10MB3285:
X-Microsoft-Antispam-PRVS: <BYAPR10MB32853F84E97E924FC07130C1B18D9@BYAPR10MB3285.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zLiNl76kN9leIVhcGh8EsKGkC+JJBlCpFCNt+/CoXB+qdNXOkUPGKpTJKuGn5GSpYGajgvkWPPF19MFCGPuSfuPU21s/rlF4MU0NqR1Wj8IFxRAxKrSRhODfGubye1QZFCcYQT4sbHtfY7SzRAHvK5od1+hb5YsjDtQNl42BE0w8a1SCdJZgYMcuu3hYPQtAv5jNFxHryjKtuHL0FPE0hciaDMS5nYKXRALOFvmxdqBSf7ZBujE/wwG3OKwIO4LPz3t/tiwAyFT7+oKKJAbLgDGjUNgV6BqK9Nz57xVrCvUa63mQW5+FVZW36hgfL9OjjAOigYyPu4d8MfPxzKD2ySatyURTGFZ1dNEYDJDs+k+amglfuTjvgyJxKgPLvJVpcFrQSpOCHHVdXZ/2eDVxsmesbViNoJbBGcAY+bxMqZPuXNBTlAPRfuS70cGdkzFq/hygIExdKFVIGPWLMOFyyP1TDXIdqkq41iI4RNZbkXVS0CngTVu+30Pd3cU0/GU2gNW9MPeuEHDj8hOf3N2m/V0ouQ/Rl0M4LAbmCBpBrKLmxobpa1l50kunjxx3NVqJXLQCCMSdhmsR4c6lwQLMstw4HJ4PDP+FijhkPQ6QNDE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(396003)(346002)(16526019)(2616005)(66946007)(66556008)(66476007)(478600001)(31686004)(36756003)(6486002)(26005)(186003)(956004)(8676002)(6666004)(5660300002)(4326008)(53546011)(36916002)(2906002)(8936002)(31696002)(83380400001)(16576012)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SjdubG5vRUd6K3lJaFROOGtHVHIwNEVyMTN5aVdEWkR4c3d2bmFEZUNYRm5I?=
 =?utf-8?B?ZkxaZGorVWVROFpzb0tXMzRDNi85WVFpQlp2YVFaZHFJR3E2aGVyRlg0S2p3?=
 =?utf-8?B?cU9WbTEyaVZ3MG9yT0dJVnR0eGQyVnYxeGN4dlJsZWoxaTRDNE9RUE1GR2dQ?=
 =?utf-8?B?elpIc21MZ3lMSklGdHAvbGlwTEpSNEFsMHkxYUZDWGxlVmREb2dUdmxrZVZ5?=
 =?utf-8?B?SGttOURkSUVFVVFkaTFMUGZIeFlqRjcwWE5YU0pkT1NkeFBDS3dlemlsRnNM?=
 =?utf-8?B?aG9WY3JhOHNMTk1LQndrQ3gyeEdzazhHNnJFQlI2OTZ2cG5FKzBiaTJzbVc5?=
 =?utf-8?B?anplRGFnaGVGTGgrSEdacDExRzRtZ3cybmsxQTluMHpZdTRUOGR6YmZnR0Nj?=
 =?utf-8?B?K0MwN01FUXR4WnlSbDFteGNGb3pYWVlzaXM2S3VocEtyTnZseVR3Nzc3dElW?=
 =?utf-8?B?cUpWelZGNGRDWFRlVnloYmdmOFkxVG1adjVXUzdEVUpjRHV0V2xOME9hU0E0?=
 =?utf-8?B?c0wxWUFiR1FlcDFycVJxRlZhZFowcDhMQWZnazlRRlkwNTQzRUQyQUZ5ZUtD?=
 =?utf-8?B?SWp6bENGM2dlZWNoRTF3ZG9yY1pmM1NWOXRJb0pjRDVBS28xSEZnUGZ2ZFJM?=
 =?utf-8?B?UWhVNXg3bEU4empISDU1Rm1xU28rTkpFM3VuK1ZmQ0RXS1BQRlpNaGRmQWdU?=
 =?utf-8?B?Q0w0V1lWQXlLdEFmSWpOSC9JQlFWR2M1dlNQMzFlZ1RPOU9tN1dIYk52T2RN?=
 =?utf-8?B?eUZEb1JSZmwxT1NIanFDT1NNVzRvUXFBbVgvbTlabFhyRnhKdWVCSGFrdnhH?=
 =?utf-8?B?RDN1Ynp5VGpXT2hwNkQ2OWhHZUFCcHpWWVZJU0ROcnNDbXNzV2prQjV6OEhn?=
 =?utf-8?B?aXFBVUExNHVxcm95dnBxQTB2cHpZQ2RsckFiTHpxNXJpd2hjVlllajlSMEQy?=
 =?utf-8?B?a2wyK1Y3WGdSU29HVm05MzVkNGcvbzFLR0t6QjBEVm85V3NOS3hSVzBMSCt6?=
 =?utf-8?B?c1lXd0lTNDYrTThsS0w5aUZhcTNEUEx6UkdJaFRZdktxdkFQMmRUdzRsd3Ba?=
 =?utf-8?B?eGZ6bDA5NWVCNnIxQUFKWk8zZ21WRTFmd2NROWtING5XVUNTd0dZbXB4bEZl?=
 =?utf-8?B?SmdJb2VJYVdJRUp1bzVnOE5NWWMyejFXazREMzJyVFBWTEI4MlAxN3liRFla?=
 =?utf-8?B?NUswUDVhNlU3bE1CZmllSVpGMDVqVml0V25QRlJhK0JuVFJtRTBhdysxNnFG?=
 =?utf-8?B?VFplZVMzcURSNm9EVXJZYUhybzYycjVHSkVISUVWVzJvcUNYdGUrdFlxTVE3?=
 =?utf-8?B?TU1lejNnWjgzZ05qOFVENHEzeUYwb0FxcDlGK3Y2MEkxeDhyZk5qRnZKbW9N?=
 =?utf-8?B?NERQTXhvb3Q4cHdPdHJBYU00RTVCeVhJMklmZ0w2YVplTUVGRWI5VWdWdnE2?=
 =?utf-8?B?SFh0c1VGa2tJdDhxeGR1QU9OMlV1VjJnM1pGcDcyMHVXY2c3bTd0cFFWZlJP?=
 =?utf-8?B?U3J6WkhoL1ZYdnphMU96dEtFMVkzMGJUbWxpbGdxNWxKMmtSVWdmNUxVK1F2?=
 =?utf-8?B?VkdYaVltVDJlcUlHRTlKOHFPejFKbWJmcHVxYmxHb3BaVGlxZmh6TUNMVTZM?=
 =?utf-8?B?L3A0azhMY3FRaUJXSkNyQm53dVVQV213TmlMZFEzd281ZXRFczRDKzhBTFpt?=
 =?utf-8?B?UkZraUZ1Z1lLSzRhTXlEQlJBZGxpRnpoU1VzOGNXSTVHNDR1UnBJZjFkTStj?=
 =?utf-8?Q?xNBen8YqstB1ecmrL+pM4qFndqxs6A6qCCHChoZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b9d6e9-73ac-4ea1-afe8-08d8cd5a9684
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 00:27:03.1262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +un4OSHraDT9dE8Gd4z90qW9xWcbbgEVyO17ALVQIxIVVh5xxwkElAtTyp8K4oyCYkN32UT2KMQZ/eJU/Oh4fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3285
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/2021 7:37 PM, Jason Wang wrote:
>
> On 2021/2/6 下午8:29, Si-Wei Liu wrote:
>> While virtq is stopped,  get_vq_state() is supposed to
>> be  called to  get  sync'ed  with  the latest internal
>> avail_index from device. The saved avail_index is used
>> to restate  the virtq  once device is started.  Commit
>> b35ccebe3ef7 introduced the clear_virtqueues() routine
>> to  reset  the saved  avail_index,  however, the index
>> gets cleared a bit earlier before get_vq_state() tries
>> to read it. This would cause consistency problems when
>> virtq is restarted, e.g. through a series of link down
>> and link up events. We  could  defer  the  clearing of
>> avail_index  to  until  the  device  is to be started,
>> i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
>> set_status().
>>
>> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index 
>> after change map")
>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>> ---
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c 
>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index aa6f8cd..444ab58 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1785,7 +1785,6 @@ static void mlx5_vdpa_set_status(struct 
>> vdpa_device *vdev, u8 status)
>>       if (!status) {
>>           mlx5_vdpa_info(mvdev, "performing device reset\n");
>>           teardown_driver(ndev);
>> -        clear_virtqueues(ndev);
>>           mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>           ndev->mvdev.status = 0;
>>           ++mvdev->generation;
>> @@ -1794,6 +1793,7 @@ static void mlx5_vdpa_set_status(struct 
>> vdpa_device *vdev, u8 status)
>>         if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
>>           if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>> +            clear_virtqueues(ndev);
>
>
> Rethink about this. As mentioned in another thread, this in fact 
> breaks set_vq_state().  (See vhost_virtqueue_start() -> 
> vhost_vdpa_set_vring_base() in qemu codes).
I assume that the clearing for vhost-vdpa would be done via (qemu code),

vhost_dev_start()->vhost_vdpa_dev_start()->vhost_vdpa_call(status | 
VIRTIO_CONFIG_S_DRIVER_OK)

which is _after_ vhost_virtqueue_start() gets called to restore the 
avail_idx to h/w in vhost_dev_start(). What am I missing here?

-Siwei


>
> The issue is that the avail idx is forgot, we need keep it.
>
> Thanks
>
>
>>               err = setup_driver(ndev);
>>               if (err) {
>>                   mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
>

