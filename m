Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0D92FBB83
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731752AbhASPnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:43:40 -0500
Received: from mail-eopbgr20092.outbound.protection.outlook.com ([40.107.2.92]:9071
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728709AbhASPnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:43:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2/yI0jO4W85V4sXRx7cY1KPrlopwtOU4wQBpoZd6XTVa8Kfv7r0qEGihUshr7l9rXgPvMYdtlr2Mw+McQ81HmvJbkUNXdHaHFqnBoMA8Yk9Bk8y1mqlVD66eOTmmq/RbuZHzUhEafnH804IMUzENUbrpj+9A/9gRm1+Zhf0MnBwSN5CheIGY/sblL8thezaPGQ3ol0BNi1ss8ASDGHDawmb9Jqz23bT7oEB+uX4fFsdDrU96XgPwN79AS7xwrFHCY7hLnZhKofsQmnBn6MnhtSRhXcTfRenxJuX8QeBDQRSPffYfaah2yyABW+1cLViitccWV8AtHCBHKdDIew2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfoFvAtC9hNbKr8JY2RrspmXycFnxOJV8Q6ebLn/6Vc=;
 b=ecDz0kNklCaKz5xrt/Tu/+b2nMUHzsSWkbXRkWKUuK83rVM5pnqcXsxKekQuneF3rjUyM5RNZdYbh05PVJ6TjXSrfU1giSpmVdXy9rrfAh0LuaDuPACH2QXWCgsQSPGQUZSKzGankdrFGU8E3zThKFdyEcvCYRD781KnTOT/ylzvMJkZjJCWygbUDGyCyv8uHetWLd2Q0sVHqKIXboc4gGz70sz5QmVJDjzq2lr0p1PhZb4C2BOODXCGsR6AHa5CMjBY/PrewsAvIILeEkjYQEtErIBlnNQwHEoW7Ly/ykNIBqgqSjirFnhXSHVwynUwE3LQ9y0nJT+8453bztA15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfoFvAtC9hNbKr8JY2RrspmXycFnxOJV8Q6ebLn/6Vc=;
 b=ZIAbuyzHpcb52HjJSG/26fduLr/X04TUMSU3HXarY9zzyEGQvO86XgsCXEHvUz6CGS5XgSgxPmzYaNGXNzIFzbyIyNAyv7Jofc/8Z9Y3TBHDSuxTeQMrOS/YAPv06EUROKYSgxSk15Ew8UZeYGGkcAjEK1qroPttdETnQeWTB0c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3170.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:180::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:42:15 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:42:15 +0000
Subject: Re: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
 <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
 <20201228142411.1c752b2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <50d2a1b0-c7b5-cd12-e288-977fbfdea104@prevas.dk>
Date:   Tue, 19 Jan 2021 16:42:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201228142411.1c752b2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM7PR03CA0011.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::21) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM7PR03CA0011.eurprd03.prod.outlook.com (2603:10a6:20b:130::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Tue, 19 Jan 2021 15:42:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3cd7d35-297e-431c-8192-08d8bc90cbc3
X-MS-TrafficTypeDiagnostic: AM0PR10MB3170:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3170CBDB3F073C37E2DAFE3B93A30@AM0PR10MB3170.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3VZTvoFbMqzcu8IKX3s5JoKd2+sQSH4YdaD+4/si0io2C4XE+UBzs4LMBcxekaIo5NXDPF8Dgohbtr9FG1gUJChIkSamEzbzbf1Cw6D2QQmhNl118mNmmvYdQiSVz7N/lxDjxSGHJ9EvTAun5xnDJN5u2GZF4t0dae1WkmSPrRJi9Wdc9AduSZNBJqCoEfGvqTEnyA8urhnTR4tw/7C13SUjhVykKNMxkfIvp+7dvEM81zfLmS1AruOcatTr0x04NlP5ymD8BQpBmWFcM4XhSCmau1cdOF7tkdBqtfSolK/BcUwMyXdkylVzhRxdsDYBhI9s7N6umyC25VJx4GmhNRhCNVkZ7O6HcFzCjINmceNbnOGdKVwrSFxCmadss4FfredYgBE78o66j4g4ESKVn15sUkWsi2ThO3JS50rhil7xbAhOcngXHQAHwm7rFzZioiH0ebNWVkWHpKJQ3peyl4tuy+QVuL1bwp6onVD4Zg1m3geuUoYx0IwV4bwmIKkINKlvF7HKP/lfDq7PR3PkVTXstIWxjm/l835jmM2KbaDEbJ50gPM+MphA50Fs/oo/+yX2pUfbKJBlyLMQNw+uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(346002)(39850400004)(66556008)(4326008)(26005)(31686004)(16526019)(956004)(36756003)(31696002)(6916009)(15974865002)(186003)(6486002)(316002)(8676002)(2616005)(54906003)(52116002)(2906002)(83380400001)(66476007)(8976002)(8936002)(5660300002)(86362001)(478600001)(44832011)(16576012)(66946007)(43740500002)(45980500001)(18886075002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?YJfYcyU80GAmPuIsCCCM2pfdFRjJ/dZPDK7x4FI2B6qiKcPV3/yKN1w9?=
 =?Windows-1252?Q?wZePHB2StlV3yhGhAdUvnIxwHsl3Htrhga/FLGYDriGcCsI6TVtnh34n?=
 =?Windows-1252?Q?gJ60jKfRwFuSeAsjU8N5W36E1dSmHP5mtxk0JGJVxx5/w4j3KUdkcEP4?=
 =?Windows-1252?Q?8IgM7dg97LFYmm+Dx0GptmOePR9/xKpjf4aJCamO3uHFUWhKNAmvRLX7?=
 =?Windows-1252?Q?zaclsWt2lQVAN6HwTD+iqIX9t6GqRCNJi1IMF9mR0Nz8sD9bXA3XYis5?=
 =?Windows-1252?Q?Szn1xSb07alNdEnHB2nk4QFAY9qlQP2K1akdZJhwk7q+IfC+dJtgGOjQ?=
 =?Windows-1252?Q?oKr402RKX/6WI5OoLn24SwYyf4SMSEHzE0XrFi+GSb3Hu8T0DGLT388u?=
 =?Windows-1252?Q?GH3s2VjX9p5Fjo1J0qKd4BCnoEUBgxZWKiqJGmEPK/Ww4N0YTe/U1t0D?=
 =?Windows-1252?Q?yUme/gWok6AFDgUX1AIdCKVRgcAMnFlScRlKKmyf7RiV3kUYBoOXbhqN?=
 =?Windows-1252?Q?tYW7nb5ytMAw9x4lCUsIgiY9/uIxhDhg2lWi9bLSxuqsYUxoL/F/GsmE?=
 =?Windows-1252?Q?jfEEW2vGLWOv4+s4yQrzaLZ7qcXvOTsgG5EWEhDyMhs70gpP4NYqmOb8?=
 =?Windows-1252?Q?pD3igBfsX9DAJyFnP0R/m9O+n2q3PqtYvRQj9HsU0wPETzBKEIc/V5vS?=
 =?Windows-1252?Q?HpF6MdzFQgY2nBuYnF4KrfHf6VM4JgJ45dYbBi0ANDVEYX6Fm4VUYA40?=
 =?Windows-1252?Q?TtbrOvRK0rsz+xhvCBFpfxFpXNSzHgo6TexvsFRtgkZSyuLLgT9wWDDN?=
 =?Windows-1252?Q?v5VFfTF+fK0hULUwy0I/q6CgjPhllhTx8JEOzJ4BI4SbtbxTTe3KVNho?=
 =?Windows-1252?Q?EvzrJ2+rO/teNa0ku3Tot1+2jqFn8k9SquWDprcRO+2sqUnkF9zz3M5W?=
 =?Windows-1252?Q?kzhpcF1wb0sSgkTkEFDs/IyoVmLzwUUp9NlJjdWNixsEbjgg97ciQc/b?=
 =?Windows-1252?Q?g9Juhvtl0s53rlMGK4iUSTzMtI/jcVVNoWdNGPLY3JicKYpqgYhOkJcb?=
 =?Windows-1252?Q?gsyyOcydSpyO+T7R?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cd7d35-297e-431c-8192-08d8bc90cbc3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:42:15.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oM+zyujWkTpQeHMVMiEuxAiLQ/ztHJWD/XJr98GsuHyoIT/OkwMnaluD2OdJhiKeAVrlfDv91D7j4b4aHg4sfnsk5SUe0URtgPNDkNIlhMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3170
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2020 23.24, Jakub Kicinski wrote:
> On Wed, 23 Dec 2020 15:45:32 +0100 Rasmus Villemoes wrote:
>> Wireshark says that the MRP test packets cannot be decoded - and the
>> reason for that is that there's a two-byte hole filled with garbage
>> between the "transitions" and "timestamp" members.
>>
>> So Wireshark decodes the two garbage bytes and the top two bytes of
>> the timestamp written by the kernel as the timestamp value (which thus
>> fluctuates wildly), and interprets the lower two bytes of the
>> timestamp as a new (type, length) pair, which is of course broken.
>>
>> While my copy of the MRP standard is still under way [*], I cannot
>> imagine the standard specifying a two-byte hole here, and whoever
>> wrote the Wireshark decoding code seems to agree with that.
>>
>> The struct definitions live under include/uapi/, but they are not
>> really part of any kernel<->userspace API/ABI, so fixing the
>> definitions by adding the packed attribute should not cause any
>> compatibility issues.
>>
>> The remaining on-the-wire packet formats likely also don't contain
>> holes, but pahole and manual inspection says the current definitions
>> suffice. So adding the packed attribute to those is not strictly
>> needed, but might be done for good measure.
>>
>> [*] I will never understand how something hidden behind a +1000$
>> paywall can be called a standard.
>>
>> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
>> ---
>>  include/uapi/linux/mrp_bridge.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
>> index 6aeb13ef0b1e..d1d0cf65916d 100644
>> --- a/include/uapi/linux/mrp_bridge.h
>> +++ b/include/uapi/linux/mrp_bridge.h
>> @@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
>>  	__be16 state;
>>  	__be16 transitions;
>>  	__be32 timestamp;
>> -};
>> +} __attribute__((__packed__));
>>  
>>  struct br_mrp_ring_topo_hdr {
>>  	__be16 prio;
>> @@ -141,7 +141,7 @@ struct br_mrp_in_test_hdr {
>>  	__be16 state;
>>  	__be16 transitions;
>>  	__be32 timestamp;
>> -};
>> +} __attribute__((__packed__));
>>  
>>  struct br_mrp_in_topo_hdr {
>>  	__u8 sa[ETH_ALEN];
> 
> Can we use this opportunity to move the definitions of these structures
> out of the uAPI to a normal kernel header?
> 

Jakub, can we apply this patch to net, then later move the definitions
out of uapi (and deleting the unused ones in the process)?

Thanks,
Rasmus



-- 
Rasmus Villemoes
Software Developer
Prevas A/S
Hedeager 3
DK-8200 Aarhus N
+45 51210274
rasmus.villemoes@prevas.dk
www.prevas.dk
