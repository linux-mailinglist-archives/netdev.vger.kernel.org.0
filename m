Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4B2621CC3
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 20:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiKHTOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 14:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKHTN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 14:13:59 -0500
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260C91BEAF;
        Tue,  8 Nov 2022 11:13:56 -0800 (PST)
Received: from 104.47.11.174_.trendmicro.com (unknown [172.21.173.179])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id A558010000077;
        Tue,  8 Nov 2022 19:13:54 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1667934834.030000
X-TM-MAIL-UUID: 5442a119-ea81-4474-82a3-d9e6f08fcc2a
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.174])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 078D8100003D2;
        Tue,  8 Nov 2022 19:13:54 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N50oXncHXMPi1UlMSritKV6Y+oZK8uoJvcKxnAnW56WkjrkVL8k1Du7m9SNN2aarlZ1wQ2D2MWnqVlC7uhBwv/501Lofub0ezbVktOQt+QTg3D7LRlVtxm7EXM1pk46tbeE7yY5t54DaWifMsJAy4q7vaS1WOCInAQpbFfBjbX4TaK8JnjsOahrhmdPnoytm3J2VDCh+Kvwxscl6SwN8iQCCKoyUkqjFH50yEyRUHPzHwO9G/CiT1bPcVUfpnekYWRUN/s0lYo6kT0lnR9RJ4r+507IBrEI89sPAlHOh2/M8kctvqS+9ceWqAwu8+f+MSbsknWHb7WJ0Q+jbdFa0pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgR95SpLxVCAR934tASv4hjK4m2pnFOL5fIFEZyY53I=;
 b=UA0wzyFTHVyIXRakwyUxpPQPGNYYJXb3eQ90Uu1XE8srBWbth52xzGPwMex6mPY3nZuRv8O3dWGCHqA+FWYOzR5avFeBGQKw0JcJnjM41GJK9ddxxOJQLooaH3fOAwELM3yE/htWDvTHYfcIXj0LYtawnv/fxkpQqmE/SZC3kns6/38qE/EOjGIl6OWRRB2Aa0W27eMPmGoucGNUWi9Y/YahzmHYDDb1ndrsrYSnD4l9CsiPqPjniXmsLEudYMjV94nMm0vHERkVjtElQQKtlgCY0hHGZBPJfqqhttWp0jyT+tsR/HiuA46Gi8F4of+P/tfV2+QKbCnK2/h7PVQwMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <9008244e-10ea-7983-50da-4716e213d119@opensynergy.com>
Date:   Tue, 8 Nov 2022 20:13:51 +0100
Subject: Re: [RFC PATCH v2 2/2] can: virtio: Add virtio_can to MAINTAINERS
 file.
To:     Vincent Mailhol <vincent.mailhol@gmail.com>,
        Harald Mommer <Harald.Mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>
References: <20221104172421.8271-1-Harald.Mommer@opensynergy.com>
 <20221104172421.8271-3-Harald.Mommer@opensynergy.com>
 <CAMZ6RqLUCs0W8ZP2jAUsFMUXgHTjce649Gu+jnz_S1x_0ER6YQ@mail.gmail.com>
Content-Language: en-US
From:   Harald Mommer <hmo@opensynergy.com>
In-Reply-To: <CAMZ6RqLUCs0W8ZP2jAUsFMUXgHTjce649Gu+jnz_S1x_0ER6YQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BEXP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::20)
 To FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:5f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB2479:EE_|FR2P281MB1573:EE_
X-MS-Office365-Filtering-Correlation-Id: 1477b99c-3826-44ec-0608-08dac1bd5fcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uPK2e5OUchHd6WnwapJD/mjv3ML3ssWW+yrc79IBxH5sSdhIDmWQEDmvjB0jkCEjeh5i0IBCf2erpLnm1s/lnh+S7FuT01YPIvkukdH7dFLkj7TyWN7oW6VqWBYOysuKwuiuCg/crIvJ8R8zx0l2qPjdjQrGMXTYt3DYVnPsDMS1ip+GKLyP1Z9NBImWnG3q9/ZmrZMO60vWVDWgSR9XFeklQ7T13K4ub1rXHh5sMUGAvi4zXLbiObaRbh7q/iNqcPEX11sOQNx1eoJTNaigZyVkf5NCTP/LE28TIKaoifi1eBEDS9bA27wcbnLyF5SBF4h5oPOlGrqPCLsHTbwVHpBpg79EzFfXBVzQ1SmTk1G7UwCbVMcMWgK4Q0S3qNJ7vPW4PnGIXPlSSzw7tcJSgMyrvSOanWitL5+X8lPaY7ULGLuKpCeUSJ/Rf68x4yMHam/vS/mSnROQ/pEmj4Mms1+VA9l1Us7KFf2roVU6GfmcPE+TDNxVcuvL2NGMoHcvN3M2cHDBvCF5Azwc9Kjvo2744vAp56K6ZRfjdLs+ubPeedsMMq8OM2329NQvb7rVf7YCjZMVwifoAKDKBS46e6s0XGIG5K8zCozj1vYHHcAxuJbE6kLK/lbFpjZ9mVgVAFseBm/+363Vqlhyq0C3kUDCUFpJ02PdyuUOkBdh9MrpYx/sQ0HoOah1nG1zsnikWUPaP3+vkRmHaaE9Ro8+Qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(39830400003)(366004)(396003)(346002)(376002)(451199015)(66476007)(8676002)(4326008)(31686004)(31696002)(7416002)(41300700001)(6636002)(5660300002)(110136005)(66946007)(66556008)(8936002)(54906003)(83380400001)(186003)(478600001)(2906002)(42186006)(2616005)(36756003)(107886003)(316002)(38100700002)(26005)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTFveFMrZWxhWm5iZWlseEt2ZVNyQlJ0bS9DaVp0V0hIY2kvVmNZTEtSUzhQ?=
 =?utf-8?B?RDc5NnZtSGNrNncwZllVVDZmYUhHdW5yYUU0ajd0SE1JNFNXWkN5Uis0MURw?=
 =?utf-8?B?a0ZNYkY0VFIxajgvdytzL0pESVVPU2VCL2Jua0E1WkRzMVdsVU9KaWhEdTJu?=
 =?utf-8?B?eW1SUXg1bjZxTVk4d3dlcVg4SVNlQlNWejFRZWttQ2lrY3BaeUFaZXVUWUp3?=
 =?utf-8?B?MDJjemxnWlFOSWNZU2FMei9VZkhtVDV6L1kvOHgwR3JoeTM0K0NQaE40SUE1?=
 =?utf-8?B?bUttc0wwb3hmZEt4MlhqSGpmd3l1Nmt3RWtSTWQ5YlllM2hURVlGNFE5VklL?=
 =?utf-8?B?bUNLOGUzNWNadThCQ01JclB3U3RhT1R2RWtMUlpocjZoaml3dmFWNTlXTytV?=
 =?utf-8?B?N09uNzcyUUREWkg3ZjJLTXoxTXRCT3ZjVE85S2JDbGdYOUFRN0F3SlJBYmhh?=
 =?utf-8?B?a0FZeU90VzlpMHhIQUpldWh6SXd2SVJiSmt3T3B3QXUzOGhhdWpVREhEVytx?=
 =?utf-8?B?ZjNkQnRIWElMb0YvZEg0RHRnWHQyVHIrdWE5aFk0d3ZIVDFUL2VkcDBKQWxi?=
 =?utf-8?B?U3hpVy9lK01qZlFkZGg2YXQ1cXIvV1N1eFFkcFh2RXl2QllsVm5wY2l3VGhS?=
 =?utf-8?B?aHY5SXRJbmtGSzc0UU5KSi9GOHN0Wkk3enphL1N4Z1JmM2dHR1hPRVlYR1VP?=
 =?utf-8?B?emp3TFBsMzErTzFRWFR4OEwrNk9EQXhYUEpFV2R0UHZQVGJNdUhaY3lUeUh0?=
 =?utf-8?B?RmxFb1ErcG45UUhGbUd3UlRTWm9STlFJc29hSko2Q3ZISmVpTk9GU1RENXhW?=
 =?utf-8?B?YUxrTXB6SFU4cXNzMFdmYzE1cTl2OWdlYkNIUW9zdlBpQkNqQzBpT29zeUQ2?=
 =?utf-8?B?ekNSeCtGRE9mWFgrYnFiN3RCc1BKaGpaaEtENUZKN3U4NUdSeEM5Y2RtU3Fn?=
 =?utf-8?B?cUVPeWYrblErVmFUaFFKckNORGJodUUvTEFudVE4RlpBR0VYMjdHZFZnR21J?=
 =?utf-8?B?L3pYbStpaStBOFg4Uy9tTms3TEhXeHBBbFlEU1dmRDlSamp5M0wwbWhPaCs4?=
 =?utf-8?B?dndmaHJqdHcxekIzSm9OanRGaDQzc3htL2pvYkVvUmRIb1MvSHdOREFiNVBr?=
 =?utf-8?B?NVIvckc4UUd3UkIrM004aTNRWTZUZjhOTngzamd6YWlEOUtEQmkxRGU0c3F6?=
 =?utf-8?B?aGtDU09yWjFzbTlpeWdFUEt1U2FXMmFmNTZ6UTNlaEEzMGtka0p6YXlZMEQy?=
 =?utf-8?B?OUEzbW9ROW8xb3A5S2orWXM1L01mTk4ybnNKWE9yNXdyTGo2SzFSRlAyUklq?=
 =?utf-8?B?NDFRQUhCUlMvQnlHSkV4eDk2a2xmUXlFQTJtbWdlWlF1c2g3RkxlaUFQaG9J?=
 =?utf-8?B?UEFkYWd4cC9FS1V0VjlqU1ZWZHdTcm56L1ZrZHNZQkFoa1lVd1hjMHByTmVM?=
 =?utf-8?B?ZjVJYXBHdnEvbWNpRDZ2L0c0eVRyd29VWFNqMkRQeENHenh0cXV2eDBUUUlr?=
 =?utf-8?B?RzNEa1p4eHBRbkhDeXkwbStsNGc4dGEzZTJ3bzE2MWxiR3NsUWZBcHJzRHk5?=
 =?utf-8?B?WGI5TEFIeU5iQlFDQlFUUkpPOGRrckxUR1BpcEFyOEJmNVlYMEMwQVJkT29s?=
 =?utf-8?B?RTJncEVLUFc1SEQyd2tsNklZb2FRL3pLeWhqRk1DZkhOR2l6dWx3anhJZjIx?=
 =?utf-8?B?Y29kVWVVR1B3NW5JajJjOGdTZnVyRzhqV0U5ZXlHRUZsWlB2dnFpWmhVT2lq?=
 =?utf-8?B?Nyt1RkxoYTJvVk5ubUZQV3hNZGNZRk9LMXBzZnFwcHdTRUNGcG1hV1R5QVJB?=
 =?utf-8?B?U2Q4MTdYMnR6MG1LK0RMYURvTXJiOWowWkswRHlBRXpWbEdxaFZMbFpyS3l6?=
 =?utf-8?B?d2l4QUZKWjU2WTVlT2gvR2o2aTJmdHBGcnQrVTMzZnh5cVBsbFB4a1lVMlVm?=
 =?utf-8?B?dWNYY0dOdk5wZ280b2J4dkpPOXR2WlFBaTV0RkN5RDA1SGZOT2dvSjFYSzNP?=
 =?utf-8?B?dk1QY3p5Zk9laVhnd0kwOFl5ejNjeTh2dzg0OU9YY3V1alROb3hLeWxCQzBF?=
 =?utf-8?B?U2VYbFJ1T0RTbStQQlBRSUpJZXNDajRKOVZoUVVwSzBXV1ZWbkwrMUF1MHIx?=
 =?utf-8?Q?SKDx3DjiSPxullYXzxPUqaRqD?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1477b99c-3826-44ec-0608-08dac1bd5fcc
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 19:13:52.7939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewT0RlYr2EUfvchhH3gFoxAEEAU049Wgqtk5xrFglVL7TMmd+3TBFZD2HqtE5UZQ6Ap1mCJjrEyJSsvEokmwqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1573
X-TM-AS-ERS: 104.47.11.174-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27252.002
X-TMASE-Result: 10--10.064600-4.000000
X-TMASE-MatchedRID: y/2oPz6gbvj/9O/B1c/QyxfqkKQlk1I5yeUl7aCTy8gtferJ/d7Abyxz
        RYsJiUavXObdKWhVpNQh7dnpNZ2lgBMNYLce+hsxxi///JpaHQPk7kL8Bkx9+pF2kRRKjUQ9/L4
        h+S8DcywHKWdS7YRsIrXYdqC9vAOOL/tBTZzO5Q0D2WXLXdz+AfSzAdIVxUno4Cfg9OGQwiw/Wi
        q2fPW6wdInOZzevFRl30EC1BEEsimyUEn8khnAN9+pUF0HsjxRN6i7v/DQHPyD1hLxlLxt3Tgzd
        3q0An8gondEiTFJ7F+98F7d8+3Dt5cFdomgH0lnOX/V8P8ail1ZDL1gLmoa/PoA9r2LThYYKrau
        Xd3MZDWagNc9ySCU/mAAfdwlecA9JIPZ1fdrP7PWF7lBiD4jjQxAFWmbE2gI
X-TMASE-XGENCLOUD: 979b573b-f55d-98a3-b868-4062ca5d8372-0-0-200-0
X-TM-Deliver-Signature: 85D69DCC3A21336F8B8F98620840EE96
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1667934834;
        bh=gAqfg8MoL5PoJ7UB2yZpgSfroT6regLOG1tAPTvgc3o=; l=2615;
        h=Date:To:From;
        b=JwGwNxNPnsH2fdLMQ3hNcvlpIWytDFPPmfoiEazJwcS17ePGIc/6GrgJNHBnxEM8P
         TX1ir8kXlo97ZTYzaHsR/guRskRb3EuBYN2cRL40YMsOg1X+Cx3+3F1urz+y6UoOFK
         xNUO4a5RuZXJO5KyB2cOtTq2FJphs/TFYFAEDFHtJMk7Zpxw1Zw/P/I3qTMV632j30
         4KnmawOS8JevRxMTilsdkyMF699/s2Br8BIMKPbC/LLUYjIcUbLFvULaDsBSJu4+Qi
         rYXIdgwEcBnPoxIDaWCtiey4sSvyEm1nUINmCWURYOGc3WzpUBd764QNlDT+OdjogJ
         JT/tVkhnXHIyw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vincent,

what I see here are places from v1 which should be now obsolete and of 
no further interest. There was a patch v1, this has been reworked and 
now comes v2 which supersedes v1. Squashing is something I could do if I 
had 2 commits which should be joined together but here is probably not 
meant to squash the virtio_can.[ch] code file commit with the 
MAINTAINERS file commit.

Could be that I misunderstood the way how is worked with patches on the 
mailing lists, don't know. I do absolutely not understand what you mean 
here.

Regards
Harald

On 05.11.22 11:14, Vincent Mailhol wrote:
> On Sat. 5 Nov. 2022 at 02:29, Harald Mommer
> <Harald.Mommer@opensynergy.com> wrote:
>> From: Harald Mommer <harald.mommer@opensynergy.com>
>>
>> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
>> ---
>>   MAINTAINERS                  | 7 +++++++
>>   drivers/net/can/virtio_can.c | 6 ++----
>>   2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 379945f82a64..01b2738b7c16 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -21692,6 +21692,13 @@ F:     drivers/vhost/scsi.c
>>   F:     include/uapi/linux/virtio_blk.h
>>   F:     include/uapi/linux/virtio_scsi.h
>>
>> +VIRTIO CAN DRIVER
>> +M:     "Harald Mommer" <harald.mommer@opensynergy.com>
>> +L:     linux-can@vger.kernel.org
>> +S:     Maintained
>> +F:     drivers/net/can/virtio_can.c
>> +F:     include/uapi/linux/virtio_can.h
>> +
>>   VIRTIO CONSOLE DRIVER
>>   M:     Amit Shah <amit@kernel.org>
>>   L:     virtualization@lists.linux-foundation.org
>> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
>> index 43cf1c9e4afd..0e87172bbddf 100644
>> --- a/drivers/net/can/virtio_can.c
>> +++ b/drivers/net/can/virtio_can.c
>> @@ -1,7 +1,7 @@
>> -// SPDX-License-Identifier: GPL-2.0+
>> +// SPDX-License-Identifier: GPL-2.0-only
> Please squash this in the previous patch.
>
>>   /*
>>    * CAN bus driver for the Virtio CAN controller
>> - * Copyright (C) 2021 OpenSynergy GmbH
>> + * Copyright (C) 2021-2022 OpenSynergy GmbH
> Same.
>
>>    */
>>
>>   #include <linux/atomic.h>
>> @@ -793,8 +793,6 @@ static void virtio_can_populate_vqs(struct virtio_device *vdev)
>>          unsigned int idx;
>>          int ret;
>>
>> -       // TODO: Think again a moment if here locks already may be needed!
> Same.
>
>>          /* Fill RX queue */
>>          vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>>          for (idx = 0u; idx < ARRAY_SIZE(priv->rpkt); idx++) {
>> --
>> 2.17.1
>>
