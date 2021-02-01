Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E830AC3A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhBAQEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:04:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60896 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBAQEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:04:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111FdTPh002079;
        Mon, 1 Feb 2021 16:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=d0kWJDuormIwpUPZZtYMjOZdCeJxjvmiUtkloSbA/wM=;
 b=v5M5anzWijPZcdVJZPvWGvmZ1a3vx+FmPnGvuY58pPALutjqkZM1qttS4s3OPzWH8kJr
 A40so8nuCiDV9G4xRyFQ+nhNOqlRwfRsWeXCnkgVEzhH8ytfEby1qJ2LDqL9jni2A0F3
 fwqUeBEnD/A4JBewUOlU4ZiKiOgSpi5PXtIliXnotnoZopsormx6OczXoO1mF/oSK8zY
 nzcE5tJi5YEGC9f0+J8n8dTZ6lZOa+Uj9r+gyYf/j1JvPjg78rhsuy35/442pt9mSTdI
 6RwLGRBdj3Mjmf2bPfhjKxVdGbKUFNW5HMmAOOJ//wejSDww9EwXnLnQ1OIk5Ns4atyg 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36cvyap7mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 16:03:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111FfRV5162451;
        Mon, 1 Feb 2021 16:03:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3030.oracle.com with ESMTP id 36dh1mjd4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 16:03:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISH8XQXyojhhCASnveylQ+VcKSYIkoUG++C3bTaxjXmB7yeVwLvPVDDCUspU41u6YcGqvZFTDj1acvGVoa48MmCOSQERx+DRBmhqOR/RL1wUoDhY3J0tgSmnQQ6JBBWiun/YnkqJwcaRY5Er8hD820BekLrERAjwrSRXbuWmuOvYB/RI61iwkd9P/tJ5yQmyvw9KGPVf99pPXv4x+H9Ib0EooJ1L6BRqwxlB6EAa6Y7KENVyYO9b7pKhH2oGvVs0FVeS00hq4X2upBrf+5Uf15iJSoewXCBU5bEg1usa1YLaDGT8jtHL7yoA64bEt3fq5ATZz4iJRZSV5o6h0EEY7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0kWJDuormIwpUPZZtYMjOZdCeJxjvmiUtkloSbA/wM=;
 b=eKqNu5hxlga/AFdxiqM99Aud2Rqs0ey3vA0H2+2xFDJPaX62IyWjCZb80AhS1oqxUDFMwoe37fibwpRNsYujifxZmtbt6Dkb6Ogej1U3FvsB4UgTM3b6NQWqjR01CrPL0WsHIp8GaflMVBMsP3S9u29W3NXLr4yZiwn3G7ILb/Kawz4kKxR2fbLN6zBonrJINd4E6nfXNCV4MYmL5rAf5afmrJbFWkFN6QA9ohk3535X5/QVbKZPhYS+7HKIHBqg/q5q7lGeCCug9MXjijYP/Tyly5/yKLNmgR/ti+bLa3NwUyrUrFflrLnbO+AUDL2Ex+uKfOIF1QDD80ykP7ps6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0kWJDuormIwpUPZZtYMjOZdCeJxjvmiUtkloSbA/wM=;
 b=HxeAqs7jfnBqHfTXY3Ac+6jng4XFn8rdDfeZiwAW+ktnWvYhpdYWguZJzqTv1awMaOhB5byu1H+DwD3EOGycIYmYK2ZyPuSYjQm2+F/KjY/wxfbhbP8H6RFOuuC4+1cp/NfrpYYDyAk+B/4Ga1TQVHDrPOgkMcHAf/X1GzbR9gQ=
Received: from CY4PR10MB1717.namprd10.prod.outlook.com (2603:10b6:910:c::16)
 by CY4PR10MB1782.namprd10.prod.outlook.com (2603:10b6:910:8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Mon, 1 Feb
 2021 16:03:13 +0000
Received: from CY4PR10MB1717.namprd10.prod.outlook.com
 ([fe80::96d:fd40:560c:3b0e]) by CY4PR10MB1717.namprd10.prod.outlook.com
 ([fe80::96d:fd40:560c:3b0e%11]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 16:03:13 +0000
Subject: Re: [PATCH v2 1/1] vhost scsi: alloc vhost_scsi with kvzalloc() to
 avoid delay
To:     Jason Wang <jasowang@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, James Bottomley <jejb@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, aruna.ramakrishna@oracle.com
References: <20210123080853.4214-1-dongli.zhang@oracle.com>
 <61ed58d6-052b-9065-361d-dc6010fc91ef@redhat.com>
From:   Joe Jin <joe.jin@oracle.com>
Message-ID: <7f9c745b-6944-ab6c-e231-ae0c55687c6d@oracle.com>
Date:   Mon, 1 Feb 2021 08:03:08 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <61ed58d6-052b-9065-361d-dc6010fc91ef@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2601:646:c601:8dd0:74df:cf15:e9d8:2385]
X-ClientProxiedBy: CH0PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:610:76::13) To CY4PR10MB1717.namprd10.prod.outlook.com
 (2603:10b6:910:c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c601:8dd0:74df:cf15:e9d8:2385] (2601:646:c601:8dd0:74df:cf15:e9d8:2385) by CH0PR04CA0008.namprd04.prod.outlook.com (2603:10b6:610:76::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Mon, 1 Feb 2021 16:03:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4e04dde-db1e-4c16-609e-08d8c6cae0f9
X-MS-TrafficTypeDiagnostic: CY4PR10MB1782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR10MB17828241C6EBCED7F2CF59C380B69@CY4PR10MB1782.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r83ZeQ374nsqwyfgZV494hMshxo/IjnwuEDJ10qrIV4hA2XHrhJdMCstZ4E3PQlSYzxS5CDRBMLmJeBkxoKA3nvaWaf88ZEXhKaYk91pbfR7Mb+o9yhnEODfJ8+9RUYGDv8lTPdv2ifzre3UK8mZlZdCA8/jHfAXXl/Sy6FJYEZ9Z06XDNeB1MDOG4o4OxCG5Ey4oZwVpUg1qQdRqmA7gQRLRsH3CwZU8n+PJTvd6LGytvacz4f8fiKUb3fXC6tC9XGUitxf+RnL+K+TYSGyYpdog+9dZrJ/IqOFbDU95npQCZMkginfl5mMWqK00xxNUUBNQZ8VM96T9h6Nu47/A+UaQrCClkYHQ+AoDyLBJIDi5C1Ndvs/xGxyJGurSrtoFjaMSpsa8YeBiuGJK7nb1lwMM/TpEYJSlFRPRjoPt7HyuiNuQ9cMKPk0CGUir4n1Fs1grlsUgp7rtbsuPSNEc8JiiZKOG8N25Fply5wQunMynU6wjFRK8VmWulqUZ4kjQLi9fXU6vmLPURPlYJnNFb5JJYr1RU/C2fKAelZzAufaWRmQc4ksVFnbAjTrtJDLc3cM5onA2v0hrMH8nHDfiyLqR/+1wHDwGzLbHd+xcd8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1717.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39860400002)(346002)(86362001)(31696002)(36756003)(44832011)(478600001)(2906002)(4326008)(6666004)(16526019)(186003)(107886003)(8676002)(2616005)(6486002)(53546011)(66476007)(66946007)(316002)(110136005)(8936002)(5660300002)(31686004)(83380400001)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OTdtR2NIVmlBeURoeEE2UjJMMVhWZWZVMCtFa3g0cWM3bE9NTExDZUp6WTV3?=
 =?utf-8?B?VFg5TnN5bGlGN3FQMEdJY2loRjlZN0FzU2ljSE0yOE55NTRabm42MTdLRWVP?=
 =?utf-8?B?aHFlSSt3aUNQazV3SEtsVE9EaG8zeWZodkRubmcrNzVoc0Q5bXdiSzEvSnEz?=
 =?utf-8?B?Sll0ZXJLLzRwb2xDaGUwN3I5SDk3YWtzUVVRbE94MEx5d0xpQ3RuWU5hc3Ro?=
 =?utf-8?B?RStWaHFQbzhMcnl1cUhUSGorYmI3OTNEVk5mc2dKZmIwcVkxYkFJTmlWTE1j?=
 =?utf-8?B?V0E0Skc5bk9hVWc3VDVsK2NITUxLMzN6alAwcU43UVFic0FMS2EzclRsM3pl?=
 =?utf-8?B?bEpMaFlwSWJwNnc2azYxNkcrMlJXaHNGekxpOEhqSHZkQ2RUd1huNE9wZ2R3?=
 =?utf-8?B?RlJxSDZjcDhwTUhKRWlGZFByR1JUUGFGUTJmeWNEQlhlWFU4d1MxVnVBQTNZ?=
 =?utf-8?B?cUZkWnhKSVRtNHJsSy92dy9xeTF1NWVuY0NYbFpGOVoyQjVaOUEwOGRKRnhx?=
 =?utf-8?B?V2VsZGdLRzl5K1dDakFBVXF5dU5WQlQ0c1QyRU9nS2FrT3UrMnZsVVNQTHlX?=
 =?utf-8?B?OVpkNkM5cTJTUmF1VmpVcmlsQnlJMGNVd2x6aVFxZHg5bGE0QjRiRStzNi95?=
 =?utf-8?B?RmE4Ry8zYlJubWpob2FkMXAvZTlsb0pGRGRCbWNFekdtUFJwVFd1RWJjclU4?=
 =?utf-8?B?NnBXZ1ZyMzdhQjdWSDZPdzZ5cGFhNW5JTE04QjdEUU44VVM2bjdIMy92YW1I?=
 =?utf-8?B?S0d2TExuN3BpQXZyWmdyT2M5MjFSTDQwK083RGJrbjVjdHNBN1h3UzBPYk9S?=
 =?utf-8?B?T2I1eXhPUTcwZm92RHBvQzR3bVNGL0ZaaXFuM0Znb2NaWldEdEFLMWhhWG9Z?=
 =?utf-8?B?VDZsRDU2K09wUHNvb3NWb0g5NEJvN2hqL2l1MzB6d2JpMjFUcGtiY1BKRVdt?=
 =?utf-8?B?VTRVMEg3QTk1RTZsd2ZjaGVaZlpIeVIyN2JmaldVemg0NFBvOFZVa094VFJ2?=
 =?utf-8?B?MlZOU2NNVis5YW1pYjBMOHRaQWpsNjlnTjlyMmNRd2dIOExaMGEvM2hSMlNS?=
 =?utf-8?B?aEVsdVNKSnlIQU81SThybUlDeEQvQmEyNzJmWkxIbENpTEg1bGQzN0JjQWds?=
 =?utf-8?B?UU1HOWJTZFVOVnh4U0dqRnVNNmdOVDlGNnRaUXN5RW1DN0xQY2E5a0ZkR0FW?=
 =?utf-8?B?WEF3Q2YwR0NOVnVjTXRRNktKOWxXMWpKV0xXNkdDMko1bVlWNGlBZnZSSUhv?=
 =?utf-8?B?MGlwSlMvd1d2MGJUVjIzeGtoMnI4NkFtdExOSklDM05Kc3padW5GTVJUcFBz?=
 =?utf-8?B?R3ZLUnk2d3FiSDN0WEVhZldYaTYydDZkVGRqSzBnTHBtR1c5dm94NXB1cTRS?=
 =?utf-8?B?NzFqb0NSbSsrZnQ4SXl4akJmU0lRdkljSmxRY2xCQmJtQVMvQ1NtQllPWWw3?=
 =?utf-8?B?RDZoaTNHM05wZUMrd3hwS2RLcXExVmorb0t5MWR1MFdZVEw3WFc5S3pyblhp?=
 =?utf-8?Q?E6kKAFTIJsOqZdDmDGfOkRjaYF6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e04dde-db1e-4c16-609e-08d8c6cae0f9
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1717.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 16:03:13.5147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Zdqk7VSypfW+P3/byr5NpXl5Pm37CIT6c6yP8/QSEtayL5AkIcUmdVs775BAooYEOi7fTfzwiNkS567zI2IRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1782
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102010084
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can anyone help to review this patch and give a review-by for it please?

Thanks,
Joe
On 1/24/21 7:12 PM, Jason Wang wrote:
>
> On 2021/1/23 下午4:08, Dongli Zhang wrote:
>> The size of 'struct vhost_scsi' is order-10 (~2.3MB). It may take long time
>> delay by kzalloc() to compact memory pages by retrying multiple times when
>> there is a lack of high-order pages. As a result, there is latency to
>> create a VM (with vhost-scsi) or to hotadd vhost-scsi-based storage.
>>
>> The prior commit 595cb754983d ("vhost/scsi: use vmalloc for order-10
>> allocation") prefers to fallback only when really needed, while this patch
>> allocates with kvzalloc() with __GFP_NORETRY implicitly set to avoid
>> retrying memory pages compact for multiple times.
>>
>> The __GFP_NORETRY is implicitly set if the size to allocate is more than
>> PAGE_SZIE and when __GFP_RETRY_MAYFAIL is not explicitly set.
>>
>> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>> Changed since v1:
>>    - To combine kzalloc() and vzalloc() as kvzalloc()
>>      (suggested by Jason Wang)
>>
>>   drivers/vhost/scsi.c | 9 +++------
>>   1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
>> index 4ce9f00ae10e..5de21ad4bd05 100644
>> --- a/drivers/vhost/scsi.c
>> +++ b/drivers/vhost/scsi.c
>> @@ -1814,12 +1814,9 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>>       struct vhost_virtqueue **vqs;
>>       int r = -ENOMEM, i;
>>   -    vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
>> -    if (!vs) {
>> -        vs = vzalloc(sizeof(*vs));
>> -        if (!vs)
>> -            goto err_vs;
>> -    }
>> +    vs = kvzalloc(sizeof(*vs), GFP_KERNEL);
>> +    if (!vs)
>> +        goto err_vs;
>>         vqs = kmalloc_array(VHOST_SCSI_MAX_VQ, sizeof(*vqs), GFP_KERNEL);
>>       if (!vqs)
>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
>
>

