Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0033573F67
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbiGMWHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbiGMWHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:07:25 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE81459B8;
        Wed, 13 Jul 2022 15:07:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nA5KXotuGADe6JhJBckApCLKadaQqrDUgu8X0ebUUj6ohdVHflaNG9j35GAx4sHvfteQuITq2hlVXuFjMLuwH6lkM+mImD9bB0F2wrSY9fPWvgcvu9CQUlpydjfZcWthuHfgdowJyUqE12YAUcQWTjJFrrwygIbbOja2z4aSMF3COrgOAbkXzMpk/CKj/+5ZQKDKzC7TKnmkcYA5+oe1+ta9qLt+7BJoBeX/HHSjQGAsrpTRvFl/FAUrxSnINLLyRUlL9bfQjLWMRhoCo+m0xtSQdMyw297tfSXoUDLsTncl109U+6r6McQWUgpoljGJsXklBAFyav+ffb4n9GaOhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9hUX7yYqQe31HZy1vEHDzOR1uguw+M+jIBvWiRxGxw=;
 b=ULKk46cjSTxIJOiymgmEsG+Ljl85wSItjmwpYQPu25q/5jztbHc1puHXNUD9MFhXb40hmXQNDKFNl9zSh/CbRYDm7E6oii7CAJ+sCT5HC6FVQHCFx1UQ8hBCoR848gB97Lgbc3HtvLuBN5JLOxaHOsHza1vaEWa+VIbHliP/v648eCorB1juTR6dUFlYQQc6XefVz5lZe34PJBnU3PXAiWfDHu+dblf30cK4Oy48ZTgvDm4MpGpykvugWZnQESBIdo+Kpx5gI1YhxG8+LrbhoTfrLsWADzK4/cge+rqZaCn7JBrUmJtG8ob0OkbdQceAiZ568CXsJb8Je1ATkPcv/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9hUX7yYqQe31HZy1vEHDzOR1uguw+M+jIBvWiRxGxw=;
 b=Ab3SDDo3C7Eix4vduS6KOV/Vhzg2xmfXlmGD2l30gAUdfwZ4RRAyByAXA2kyKN/Hki3QHAivLdG8rUkF0nqmNUzqszy61cpBEvigFIGK90YGy4761HqMf2AaKT8/6y1Vsg1HMBdQKfEgF0xMB+/2uq4wHaSVPmEPrncLJgTdYpE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY4PR12MB1525.namprd12.prod.outlook.com (2603:10b6:910:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Wed, 13 Jul
 2022 22:07:22 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 22:07:22 +0000
Message-ID: <d4ee9422-e06c-a579-a242-c15d73395584@amd.com>
Date:   Wed, 13 Jul 2022 17:07:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next] MAINTAINERS: Add an additional maintainer to the
 AMD XGBE driver
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
References: <324a31644b29f7211edb13f26b5ad9ab69a7f0e9.1656422252.git.thomas.lendacky@amd.com>
 <59f9c1674f2cd55b8182333ccb75536c365879ea.camel@perches.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <59f9c1674f2cd55b8182333ccb75536c365879ea.camel@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0372.namprd03.prod.outlook.com
 (2603:10b6:610:119::10) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1947f8cb-be17-4ddb-2844-08da651c0f85
X-MS-TrafficTypeDiagnostic: CY4PR12MB1525:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W3NKjrrpMOpRmt/bEbwED7T6BwXcl1wJFscw6wfrI8POh7/JPKgvvAXnQNVj4yP2iezKljV6o3B7VFx3DAlXHHk3TmvE8saqQ0z+Jc3WGWo4qBH884IkrSdP0tUpPWHzLfVy4UChEROvwUDQgeGerJ3i7WpD2o0SqaS5Lewucy5ooVcOCtCHz8GwoeZzWKt5yBPPhDrq1Qy92iFtkqxVFBSz9DIVrsFXsHRCw4w/qnFfHKknqVXUWgZ84IumF4/YafOf6y2CwGncBp1+2tbyzQUzqgjP4ibx4d/DgjjRo5Vq5vs2RubaluveKjbYsd5uQnnSrEYcTlvyHfYlznlCdjdQlOMt0gpIPyCR5f5xWetQOD7+04rkBLAvre6bBGQla66trekJQkeWqMRqj9xeme8/UCxdJa8jDytGBx0bHfyuOH7e7VOl9BGpBgyBhGUCokHSJYETeuTd1+DW+zfiCsFQdOiH5ebz3CzyashK+SyUfidUqYx3AWXqnENBIaxTkMBtTQL7zCVb9Vk3Zscq3Kp4H2TaE5ltfaH28fKlVWJddPJGq7t9QECdN8hnmQxz419tg+VPZjj3FLij9nQfdh4WCr6GvKS1nknlb5bZNpMO/k8hs3FCjg9I5J1g24kqjnhhGm8TDEhfc+ON/Qb989I5MbcSqVFJEdh45RW/ibTvH8g87iQ9FN/2qdEGZBq+wvLWxR8Zts4HRmW7gNGzDOKglLr23TTbOLp9At3rKe59OhEvtspfDq4d6Bh0Z6kjkVGGz0Mvaz5ocRlSrmKTkynM7sVE0xpqoza+JSOIlx5mLR6TOKqmMT7jKKOjFizeE/GM0cI8KLuJdqCplfXqrn++wPFy/Ccb7I6sYyC0x2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(66556008)(66946007)(66476007)(316002)(4326008)(36756003)(2906002)(8676002)(53546011)(6486002)(8936002)(4744005)(5660300002)(41300700001)(478600001)(26005)(6512007)(31686004)(2616005)(186003)(6506007)(31696002)(83380400001)(86362001)(38100700002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVlUUHpNblA2M3U5SEZVZjdTWldNYkhTa3JzT3JtdjlMVzBDRXR1UUdNeFNW?=
 =?utf-8?B?NHRSbGtTaDg1WkgrMDhBdytIek9HRTRTL3FTNjU4Y3BWUUozZlVjcHNFNkZo?=
 =?utf-8?B?Sm9FQ0FqU0x3K29Xd1Y4aVdIVmNRT1llSENZWmpPV3VqWTlPeE12eG9LNWgx?=
 =?utf-8?B?cEl3N0JtTFJKdmlXdVpYVHZPY3lKOXZRaWVMa3NLUUNHcjQxOEppbzcrNmZn?=
 =?utf-8?B?K0RaUGlESy9iWTNXWjJza2hsWFdrYnNMSnFvOVBaSFE0YWQ5VnhYUUR5ZU92?=
 =?utf-8?B?VnVZdjB5YW5JK0t0MmlBYkZFTEZOSlY1cHNqaEZIMGoydHhNUUlqcVFiYlNr?=
 =?utf-8?B?dDN1aXYrWkdTZTg5WUdWeU1LVUttNzhJckpUMkxWeEtXQmZ0TkxPT2NucWhx?=
 =?utf-8?B?STFLNHRWN2pmTzRFUVU4cjdiQ1lIVUlvZlI5d1Nqd1VBdDc3NkJtQVJVdEd3?=
 =?utf-8?B?aUNyaTVMVEs2bEZTbVY1MEszMkRtdlFLLzZTd1owR1NCL3cxczMvS3BWdlNK?=
 =?utf-8?B?QnU1S1hHYnlEYVQrdmRXM0k5RXY1SS9QWmNxTUZ3RTFaOTdmSmdJODBvMWVE?=
 =?utf-8?B?c1VGK2FYbDNZc2NsMVQ5eW5oZWdxL05nY2p4bitQT3lnYXpRVzBjMENuWlVI?=
 =?utf-8?B?Z3RUd3Q5MlU5UTJYVFhMUnU2ZUpQd25WVDJ5cWRLSGNtcGlod1FPUDN4QXJa?=
 =?utf-8?B?cUhTRjRaRUtXOFcyMVh0UHZ5TzFLQ1poaWFFc3kzTXU4cXVlOGhOZUFNL29v?=
 =?utf-8?B?UmZnZFhFM201TFNDdTNkcFh0U3RnV1ZQNUZsWkNQcTRFaDJEOXdsL0RjZG9o?=
 =?utf-8?B?Z0VIQXU3d3hNeWZkZ2NVMFdOS1VnWWtSbFd6NnVLMnA1cU82NExCaGNIRmVS?=
 =?utf-8?B?Q0hueEVEcEovMnBWd2J3aXJvZVF5Ly9aWEUweG9Qd1ovNVJhTkxRdVB4M01w?=
 =?utf-8?B?Um5aSmJkWVlOdTQ3VlNDY0UzakZLSWdXcGtJV0ZIVDRBSmU1ZnlDWUhTUTdm?=
 =?utf-8?B?RXZJWUxtdEwwRDFqVFZmT244OXlDaXFDVjk3YzNoS0xkWXZBZ3J2Vm82b2J3?=
 =?utf-8?B?SFBRck5aSUdyZEl4djVZZzlmMUM0cVkxTGlTSThvcTJUYU4zZHg3clhkbXVU?=
 =?utf-8?B?MHB3L0w1TVMvcUo2aTRxMXo1RlM5UHR2ZHVwRW95MUhmMnF4Sm0xblVSQ2JB?=
 =?utf-8?B?dEdxOUQ4NldPMUFpRUN6L1lySHVnMjJib3hTc09vZlNHM0J5WjhsRVozQTds?=
 =?utf-8?B?SllyczkzYWhYVWp6bGdVelRsbDdCeXcreDRKTWl6Sk1UQ1NVUWNabktqUmh5?=
 =?utf-8?B?bzZyd1ljSWt5d2VBbEdDY05PaUhCZWlJbkdReWN5UUJnZGltZlhxZkhYaDI3?=
 =?utf-8?B?TDg3cFhHLzJJcTZxYnBXang1QzhYbWJsTytDMGsvNmtNaGFpYkNpU3NyN1V0?=
 =?utf-8?B?d2dNMDhFK29xb0tqTUZoMCtCdnYyQWgrWjliWE0yVGVOdllJMTJWbThYRUE4?=
 =?utf-8?B?Wmp4bTZzNTZJSG1HUTlEbzlVZmlWekt6dTlKNkFCTmhSTjh5M2Mwa3ZMSld2?=
 =?utf-8?B?TE5JaHd2SHlQVlpTbDM5ckFSand3bURMMGJmNm5PamY4cTNUYkFKVmhwaUhC?=
 =?utf-8?B?aWN0R3VuY2hjWUZRNzhoS05RbUY2TFBDcUJ1cno5NmhrRHV1NHJHS2dUQTZz?=
 =?utf-8?B?M0wxNE5aK1pYWUZ6cmpQN21QY0U1Q2RnMjczRUlpU08vdGZFbDlsRWR5Q3V4?=
 =?utf-8?B?b1M5M2RxMkdSMFhYL3FMYnpaN0NEazZEZ2ZnRkhYUW9zOHF5dSszc3oyWjNi?=
 =?utf-8?B?N2ZKQnFBNk9PRzJSbkk5N1lQYjdicDRNa2xEWUpyakZ6L0xsVjMwNUpwRFBp?=
 =?utf-8?B?OVlsNm9DbE9ReWh0WkZiMllBQlNjY3BXY0M0N05IVUI5S1ZuanVvWnB0ZEhK?=
 =?utf-8?B?Vm80RDhhTzJDMElqai9EYjhuY01TS0NkeVpldUNoVWEveGZac083Vk15eEd2?=
 =?utf-8?B?TTBVMGdzUFJQSEZ0OUh4WGpETnoyRkJtOGprRTJaQmMwd3pMMnBsSDBKK1ZY?=
 =?utf-8?B?WS9TSmhOSmJhM29LOGlWdmxxMXZKQTFSQjRGMHhtKzlmdWIwL3NIVGttVm9x?=
 =?utf-8?Q?jg5e3pjvm+hPmShV8t0uIUprD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1947f8cb-be17-4ddb-2844-08da651c0f85
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 22:07:22.2720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfZPNXMAPX8zNC9pTMCPRJ5fyCrHXF1jYyyJucuoDI3sq1FrkKxeUJcPmKK/as21B7ii+1h119UG4TEdOGg2Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1525
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 12:37, Joe Perches wrote:
> On Tue, 2022-06-28 at 08:17 -0500, Tom Lendacky wrote:
>> Add Shyam Sundar S K as an additional maintainer to support the AMD XGBE
>> network device driver.
>>
>> Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -1037,6 +1037,7 @@ F:	arch/arm64/boot/dts/amd/
>>   
>>   AMD XGBE DRIVER
>>   M:	Tom Lendacky <thomas.lendacky@amd.com>
>> +M:	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> 
> While this is a valid email address, get_maintainer assumes
> name formats use "first middle last" when parsing a name
> before an email address. (look around line 2460 in get_maintainer)
> 
> Perhaps this should use quotes around the name like:
> 
> M:	"Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>

Totally lost this in my Inbox, I'll submit a v2 with the quotes.

Thanks,
Tom

> 
> 
