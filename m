Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E903D621CF5
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 20:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiKHTWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 14:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKHTWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 14:22:32 -0500
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162A67721B
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 11:22:31 -0800 (PST)
Received: from 104.47.7.176_.trendmicro.com (unknown [172.21.188.236])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id CD31A10000D17;
        Tue,  8 Nov 2022 19:22:29 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1667935349.091000
X-TM-MAIL-UUID: e7fea5b5-83ee-4ee3-81f0-ddbadf8c1c9f
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.176])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 165FB1000030C;
        Tue,  8 Nov 2022 19:22:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqEuOkSeqfjGxPKIcJ3VzVs6EkHNJtHSRtnpZ3+J8wKXxlDAvBlsYFJ9BPFGTwGRaGBMBNSIKoDym7HbOe8EaShlw9Pw6QTHS9DyXSL6jWLnFF2fngvtViVcxvyNqzBqLculJQwGxLmXg3us8FYc77pLCm8mygLG9PNbWQYQiLCVLwkLQtxgiXOrlVJcptpLt5ucU5JMEKDQdiL95YisO/LyM8H6MkobmLfGofpq/wyfRB/SFSJY0WVTh9a9ouOGlWIC7Cndj/pDu37DfJg7n/L1DsFDEzAUXCmRhpUtd4iwhq9XbnmdP2ZP56kMi0Zc81NutCHaXZmkQBaelVlu3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wkk6t8a7JS2hhrG7WASG57pY41QR+vaBjtTXgiFkzrs=;
 b=ATm2rtXH0jGl9mAruHKiLf0FDfgolg5CWcWDrra0Pasc/it6ezX6co1G8oRihCTUzaTre0Z+MbJtyk1rZ6rulAGyYUmmxY1qo6NUVFdrykRADGVEpC76jR6VYAJ+ijHRwfzLUi+uBxS9bjar4DIdwsxCY1gm1v+8KYtRfNTEYW34j1saLt4cKxR17SerI2NcwRA2wUwHgJsiM+PbQMd/gpXnJLJr/Nuyog++gN203qNfEFhfmjEY33FHObBAXCF5XYHRzkjRN1jHdads20drPZJ72/KwSnppf4646V01B38rTXVBMV2SlXa0FZoF1ZcdoT77Hcj5z4edi1k/qUGvcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <bcf9fd32-1078-2c7f-0c2a-5848ac6571e8@opensynergy.com>
Date:   Tue, 8 Nov 2022 20:22:25 +0100
Subject: Re: [RFC PATCH v2 2/2] can: virtio: Add virtio_can to MAINTAINERS
 file.
Content-Language: en-US
From:   Harald Mommer <hmo@opensynergy.com>
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
 <9008244e-10ea-7983-50da-4716e213d119@opensynergy.com>
In-Reply-To: <9008244e-10ea-7983-50da-4716e213d119@opensynergy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::22) To FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:5f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB2479:EE_|FR2P281MB1606:EE_
X-MS-Office365-Filtering-Correlation-Id: 9380f27b-4ea5-42f5-811d-08dac1be9269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7GQVMODv4DttNJHXRc99KyOTa5KQgt56sStVeavM/RoqQmycD5+U8pXp5800iM6A/dBupmEvg9Q/z1AJr5NsSbqgPVnipwc7Uw7czTgebZbtbaw32jcbFnerH7MIhiBJytzqpdgvKrw+k9672rKjXtonuuYQPJ5aUAJ3VVUtcrnQlqr90W6DP7t+tPDe1cHnoS44iaFlQYYTGXnj2eZQQNwRvCmW5cYR/J9Vpm2f9y0NBynHCDYSp1kwzDNt0ZdEv8quj74lMTNNLYmacVW9ySKbh83R9cDfOsCHowVpE9n8XOWhzPJYyfXz9ytEubxqftJfeBOWJYNj0PSQyUc/Ypt1UkNwsSak8s1NrZK0M3+pya6aaSejE+0WaUDYBiKeUvOGp68wlZoiUyuzFUb1/yLie4qQgGSYk0919bgQ7gI+1//57uw4Mo9vooSwFcvCaiAcL/aoAavmOrjDc2SWshhattTDephCSrzwyDhvPvAU9N5kT8KoPqZAoisPeWId6TJMCQzt3VquehpMW9zZcrjK2ZxF1RlN/lJ7ZUcplw948ZojRj1FVvAx0y8kdbXwjyPF+2v4M5LHG3kf72qqoM7f5j2xJaoZT9hoBHhvW7+8e2He4ldHcnAqle/AwpPpt7mhFNS17ja+7NwgAmaawiGDRs5vDlMGMG8IWqoDG+j7/5yUPJxqRuFdjAuOyac8xwbUUmgcgYjXVs60kCl0xPDyrfFvptvz7jjwA1avj0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(366004)(39830400003)(346002)(451199015)(107886003)(8676002)(4326008)(42186006)(83380400001)(316002)(66574015)(2906002)(31696002)(38100700002)(53546011)(15974865002)(36756003)(66556008)(66476007)(66946007)(31686004)(54906003)(2616005)(8936002)(41300700001)(478600001)(7416002)(186003)(110136005)(6636002)(26005)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlJOV2xsUVpGUzhMMGpadVZ6M041VlFYVzhLN2F1am5KNjVCYnJQdnhXSmdE?=
 =?utf-8?B?azdhbWlPS3J3WjN0ejdnOXFuMnVwNHp2QnA4cUQ4OVFnQmYxVkEyVkc3MTVZ?=
 =?utf-8?B?ZVF1QWhtcXc4VnlqSkZ3elFKTDB3cEtFMjB4MElQQ2t3R2FmQStwZWNxYnkx?=
 =?utf-8?B?U0IyRGxHbWtyOXhrK25hdGsvU0JyaFhIZ1F5TjZEd3ErTUlkRXhlV1M5QzJh?=
 =?utf-8?B?c2hLNHBvcWdhTUx6N2lzK0ZCTXpQMExJcmo3LzJ3WWtMK0FEck41aVdUc29I?=
 =?utf-8?B?ZFVlZmJlMHAxbDFqL1ZIRmpOVWZEK1BIdUVneDZzL0ZDTkJiTEZzQnFJam1Q?=
 =?utf-8?B?aFloeXlOOUR0a3hPaVdCL0NCUVBOSE0rOEdwZEp5L2JYM3I5c1VqbDRnUHBM?=
 =?utf-8?B?cy92S0xaQ0VyY1FTcE5vZVhjU1RxemMzL25QaGt0QjNBL3Myb0NPb2V6cVJo?=
 =?utf-8?B?SUdKeUdLZE9oWWlXMDA2T004a3hwZGRuSjFYWnhvdHJPYlRkOVZEUXRFQTIz?=
 =?utf-8?B?NWtyc2Nkb3FEZmRNTDI4M2lrRlI5ZmNqekdna1czTHR4a2w4K2tJekp4MGFm?=
 =?utf-8?B?OGt5N3FZNlJaSHgwTDgyYmo1VDZiNUNZek5NL3F0MnMxTUZqcFpYUFIxZFZ4?=
 =?utf-8?B?SjJBNVNTSkdPT3NxSjRhT1FlcGV0Vld6aUZKaitkYng3Y2FLVWVNRzhocjV3?=
 =?utf-8?B?V3JEcEZDd2d4ZnJRTlEybkRvazR0ek5XS2VHa2JyYkhXNzhnNUZXSkVaWk5l?=
 =?utf-8?B?VXB4QUtRZExtc3FiMFZNeTdEeWZvK1ZsN0hhbmZyMURZcnVjbE5rZ2NWR1Uw?=
 =?utf-8?B?TmdHOFZUTDEyVWVOdFMveVFhdkxOaEZZR3dkbklyMzJ6azF0amduWHlLTTlI?=
 =?utf-8?B?TmdMcnVmUnBkZEFRaExONVFKcG1FM0FPaG1oZC9OUjBkUXAxMFA2bVhpZHlI?=
 =?utf-8?B?d3EyK3lSVGZqTDNFdmlTTUFLdHBBdnVhTjc1THluM1MxVVUzNmswN2FWRWJL?=
 =?utf-8?B?NXFIZjJ4MW9kamo5YjBZRTVrTXNLSE1oczlCaUdQMDA4RlI5VllHWXk2V253?=
 =?utf-8?B?WGlQMEtvQ0pYdndFK1JQS25yODduWkRpWGlrQU9BenRIM1NXVGxvN3c4VHpy?=
 =?utf-8?B?aW5Ka1NWUVA3NVRTSVV3U2IzSzJyTnF4ajJCa0VFa0kxMUQ1cGdYd2JQbVV1?=
 =?utf-8?B?MHk1dFJHRzZhTzFkNVZCS2kxRkZtSW9QYVdWZUVJSEZva28wTEF5cUVZTHEz?=
 =?utf-8?B?dVV5dnV6bVFyYmFXT051SFJ6aUZMU2w2b1dWRVRTM1RWYUlGaE8wdWMzR1J0?=
 =?utf-8?B?N0xwdE1WeWJTdWdJNWE0ZDA2RHRYeGhuUTZsbkdaQ29FR1R3WmFQYklTRlVu?=
 =?utf-8?B?RlMyU0lLRmgyNU9xN1RwTEoyZHFjc1EwQ3lLNnpZOU9BbVIycHlueGkrc1pX?=
 =?utf-8?B?TGhiakJEWDZtRUlXVERza01GQmUvOGRxU254d0pJalh5V3JhOEY1amZPWEY0?=
 =?utf-8?B?K0MvaVlzcDlGWDJEV0kwWjF1UVFqb3VJYnduK3RSaEFmRzRxVzJkSk56MjZh?=
 =?utf-8?B?NG5PditTaXBEVGZxS3pKVnd4YkEyK0xnakRMdjlYQW5YTXRFdGpLa1FnR2tE?=
 =?utf-8?B?cDdIUjZNbTBzRXNINVlWRy9NaWFtV1pJS0RKYmUyc0RhdmxvazNlOVl5UmlO?=
 =?utf-8?B?Y2pZTDNyVjNPWkpmK0NqN0puU29sanZvbkZzbmF0UjJsM2lKaklxbEdpVlZr?=
 =?utf-8?B?MEZ1QjQybHFmdG9YNksvanROSnREdm1FbEVnUVp4SGt4ZU1KZ3pCWDRlak1K?=
 =?utf-8?B?OHM1Qnh1Q2RQYjJzUlBLeCtabCtncmpSdUV2OENBSEZPVHJEc1FiZXpMbnRT?=
 =?utf-8?B?WWlJSEpYMXpRQld1OUxUQ21CK0s0TTJNOXQ3NnlQdnIyVXZNaEM0dFRFWG5D?=
 =?utf-8?B?ZmFNaDZnUk5pL0dNRWE5UVhwR2JsV2JoL0hhaWh0Uk5KSUtnQ2c2U1pVaU8z?=
 =?utf-8?B?cVRIcVVLWTJ3dWd1RXdLNmg2S3NaUnY1dmVrZk1ieGd6UXhOcnVYckdVQ0xz?=
 =?utf-8?B?eW0vTGRxT2h3V0FPRVhwblFPaFFONTgrYzlsMXVvMWx2enB1bU5RQTBaRTVJ?=
 =?utf-8?Q?eyCcbRRRSnpe4XPbguUwqtJKe?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9380f27b-4ea5-42f5-811d-08dac1be9269
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB2479.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 19:22:27.1618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgR/QHEHBVbuyBVJBZJ30EViNZhfOtbhY5CG/nYGGXiL5vnni0WDWgh1/g2Qhhm1JKzGQgnXWo4G5KS48Ksb2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1606
X-TM-AS-ERS: 104.47.7.176-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27252.002
X-TMASE-Result: 10--11.495800-4.000000
X-TMASE-MatchedRID: 6lay9u8oTUP/9O/B1c/Qy8p9Bgr5ONKhyiKgKtIyB4p4cbnZlATT0S4X
        epmu1hPLPsj5qjS+dCFcHyoC9xsa8muqF0uWEJST8eSmTJSmEv3bLuvAgD3xvFc/CedjlcvkLHN
        FiwmJRq9c5t0paFWk1CHt2ek1naWAEw1gtx76GzEiLmf+ghTG/wmWvXEqQTm5wLkNMQzGl5B+Kr
        WCPbERPxfDSmuAMQpg/2yKc9qkSI3OtS99eBvZ8LxygpRxo469bo9qnUw920cvQQTWKJzDNxDSN
        tOTt0GFA/KpErKDNEqOpvWBCtxpVOtsQZv7lD9530kDaWZBE1Sd2Wz0X3OaLRdidqgv9+A7IGlR
        +tiic9sMfsF34CdiVz30VFQY70sLTJzMBIRDQjRwJy1CuqvGVA1bi9r2Kq3eG1h5LatqS4mFWK3
        CKcvE/P11Tj/BVX6iX7bicKxRIU23sNbcHjySQd0H8LFZNFG7bkV4e2xSge6w68jL7IpprMcbC3
        /f+BaEs/Lk4UC9Yzqp3GmNWyQ4s0uFvzEYSdV+
X-TMASE-XGENCLOUD: 295a80ae-7075-4dc6-a82c-dff42a82e159-5-0-200-0
X-TM-Deliver-Signature: AE9A71CF9904D6313439E6DA6198B0CD
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1667935349;
        bh=jQjomTYRLzXb8oX1EycHFjTs8YPqHK8cF+fOCy372qQ=; l=3522;
        h=Date:From:To;
        b=s1xLbSuYHPMfI8b6QCDluUzpTzIWCQ7u5zg4ug5ZLCoxVZllypTZ95Ue+3qnXKzH5
         acjzHmSZxqhre19m/4W5OgTRDrWNKfvcC8wIlwGy+f4h9HtQ7sPaRzmup2scyYi89t
         v7Eb9VztAAXT0oIRIt3iYjFSHzUiGRhTIt5Lk4z+tJwOJYoA5QCULeRLAzE2TdoWfp
         LRvmaant5QZnSVflEc6DH8E1i/SN1zULSjOFN6TMotZtoTeqNa0b60UYmNzjpR16Nf
         3ZtIgIYXmWvEVczDAv+oI2pCfb+6DfvszUpX5TZLqnAIAN18us9opqjLEYANkY2us7
         UdUd95Ryqne9w==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vincent,

sorry, my mistake, got it. I was absolutely convinced that commit 1 only 
contained the code changes and commit 2 only contained the maintainers 
file. But this is not the case, there was a last minute change and then 
I did it wrong in git.

Regards
Harald

On 08.11.22 20:13, Harald Mommer wrote:
> Hello Vincent,
>
> what I see here are places from v1 which should be now obsolete and of 
> no further interest. There was a patch v1, this has been reworked and 
> now comes v2 which supersedes v1. Squashing is something I could do if 
> I had 2 commits which should be joined together but here is probably 
> not meant to squash the virtio_can.[ch] code file commit with the 
> MAINTAINERS file commit.
>
> Could be that I misunderstood the way how is worked with patches on 
> the mailing lists, don't know. I do absolutely not understand what you 
> mean here.
>
> Regards
> Harald
>
> On 05.11.22 11:14, Vincent Mailhol wrote:
>> On Sat. 5 Nov. 2022 at 02:29, Harald Mommer
>> <Harald.Mommer@opensynergy.com> wrote:
>>> From: Harald Mommer <harald.mommer@opensynergy.com>
>>>
>>> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
>>> ---
>>>   MAINTAINERS                  | 7 +++++++
>>>   drivers/net/can/virtio_can.c | 6 ++----
>>>   2 files changed, 9 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 379945f82a64..01b2738b7c16 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -21692,6 +21692,13 @@ F:     drivers/vhost/scsi.c
>>>   F:     include/uapi/linux/virtio_blk.h
>>>   F:     include/uapi/linux/virtio_scsi.h
>>>
>>> +VIRTIO CAN DRIVER
>>> +M:     "Harald Mommer" <harald.mommer@opensynergy.com>
>>> +L:     linux-can@vger.kernel.org
>>> +S:     Maintained
>>> +F:     drivers/net/can/virtio_can.c
>>> +F:     include/uapi/linux/virtio_can.h
>>> +
>>>   VIRTIO CONSOLE DRIVER
>>>   M:     Amit Shah <amit@kernel.org>
>>>   L:     virtualization@lists.linux-foundation.org
>>> diff --git a/drivers/net/can/virtio_can.c 
>>> b/drivers/net/can/virtio_can.c
>>> index 43cf1c9e4afd..0e87172bbddf 100644
>>> --- a/drivers/net/can/virtio_can.c
>>> +++ b/drivers/net/can/virtio_can.c
>>> @@ -1,7 +1,7 @@
>>> -// SPDX-License-Identifier: GPL-2.0+
>>> +// SPDX-License-Identifier: GPL-2.0-only
>> Please squash this in the previous patch.
>>
>>>   /*
>>>    * CAN bus driver for the Virtio CAN controller
>>> - * Copyright (C) 2021 OpenSynergy GmbH
>>> + * Copyright (C) 2021-2022 OpenSynergy GmbH
>> Same.
>>
>>>    */
>>>
>>>   #include <linux/atomic.h>
>>> @@ -793,8 +793,6 @@ static void virtio_can_populate_vqs(struct 
>>> virtio_device *vdev)
>>>          unsigned int idx;
>>>          int ret;
>>>
>>> -       // TODO: Think again a moment if here locks already may be 
>>> needed!
>> Same.
>>
>>>          /* Fill RX queue */
>>>          vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
>>>          for (idx = 0u; idx < ARRAY_SIZE(priv->rpkt); idx++) {
>>> -- 
>>> 2.17.1
>>>
-- 
Dipl.-Ing. Harald Mommer
Senior Software Engineer

OpenSynergy GmbH
Rotherstr. 20, 10245 Berlin

Phone:  +49 (30) 60 98 540-0 <== Zentrale
Fax:    +49 (30) 60 98 540-99
E-Mail: harald.mommer@opensynergy.com

www.opensynergy.com

Handelsregister: Amtsgericht Charlottenburg, HRB 108616B
Geschäftsführer/Managing Director: Regis Adjamah

