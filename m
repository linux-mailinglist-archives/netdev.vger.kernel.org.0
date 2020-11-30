Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755AF2C8381
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 12:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgK3LuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 06:50:11 -0500
Received: from mail-eopbgr40107.outbound.protection.outlook.com ([40.107.4.107]:13710
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728459AbgK3LuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 06:50:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MY0VvmmxklsFMQQQkwsY6LtcPtioWzR9rn3QakVbslw8iaeahrRx3rbdERuXmACjeroFoSd5qem29d3hhm2RTCIMPKMLHjEaRVfia8mjFtajUnxzINEpGZ8ZiIcXsrccH001+XewxSlpxuhqhaEUq2kT8iFyQbJP6+gIxGATqqs6XkBK/GfgR6loDatz/9NkH5lkKPQr5iuLKTRR2Sp3FeH7IB0/pgvxt5mPLgudS/q1m+jTDIo+swhbuGoDKryNLuW/bGCMDAO4Ppm5gbW5+S0HFuhsWmqMsHhnNdSlTH5cSr1pl5SNE3WPS1dkY5trCOcSMHXhzRvpdgKw/Vpx1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZdIu0CUxJC8GYJxH04kMAoSdeS+IYXr7+KJac/OwDM=;
 b=LQcrZd8PnvY6ylE9OWGtt9LKcz1Wqk6eNAqVXsZbyno2J23uXc1bFwHt8zenhnB3KLGm9qQ9/d5lea2yC9XAmQtgoVRtnF/9w7mGcOfHXNpo6pxH3tdh+1zAppzdekUlLSyLsBzPHRkJ4Cg6FMAhLhccQRlD5lVLww9IY3eUcQsMeRSjyoB5dD0ggFhOiYZKzhbwZ7ESaWdFQPFB/sDCMysestwatnV8+LXqDW6eIGl9xEH6l+rg1qjVERynI46kId76Dpd+JQKd6LiUIdIcXmrPsD+1kAtPJtXqP9ifwgIPCPGXz4DvCMjCAN00WlSWkY52LuQ+g0X2evbC8aPCjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZdIu0CUxJC8GYJxH04kMAoSdeS+IYXr7+KJac/OwDM=;
 b=MCmJnUNRgH9FkcnqNL+bab3ID4PCGbxiuoAnf6waOneQRmQbDnXmO+hYPnqeQo2kemE96NIbpqlSLF6UTKhtT8MtXUOLDC3oyEGOFBaFh9rTGME68tObhzOKcYA4NrdYSn/JiQUUxCgMJsV/vIxrY2Jvu6BGl2TKtxT9FMqSj0E=
Authentication-Results: gerhold.net; dkim=none (message not signed)
 header.d=none;gerhold.net; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB3617.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Mon, 30 Nov
 2020 11:49:19 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9d5:953d:42a3:f862%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 11:49:19 +0000
Subject: Re: [PATCH] NFC: nxp-nci: Make firmware GPIO pin optional
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        =?UTF-8?Q?Cl=c3=a9ment_Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfc@lists.01.org, netdev <netdev@vger.kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>
References: <20201130110447.16891-1-frieder.schrempf@kontron.de>
 <CAHp75Vfwp_uvVW51FwwRWorDibJTu4zRpMhQ9iF3sTe1yrmsTw@mail.gmail.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <991f6ede-fe3c-91b5-317c-de6c0c767400@kontron.de>
Date:   Mon, 30 Nov 2020 12:49:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAHp75Vfwp_uvVW51FwwRWorDibJTu4zRpMhQ9iF3sTe1yrmsTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.142.77.113]
X-ClientProxiedBy: AM5PR0101CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::20) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.17] (46.142.77.113) by AM5PR0101CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:206:16::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 11:49:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fa0039b-3c2b-4b51-e78f-08d89525f8bf
X-MS-TrafficTypeDiagnostic: AM0PR10MB3617:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3617783D37579386B472120EE9F50@AM0PR10MB3617.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGO3R85cT/QbqsJ1w4hgoN2mz265uSJ1xnUdd1U9YacTJGoY7fcLfBRgSDAUbIPacW1Nkbvrb6uzDxOQ4ulK/Kk97z+A5nOwX46bVXYxZZQcqgZ7HAZo91vXI2lIhimZj3g3FgmJWuWAiOQdeOD58sljwcv46X7sNNrDAgIyiC12vIUMzoik3DfWAvac3VdYI4gjv/JJ4S6lsaA2YtJRT7nq7bmaN13mkcaRsrvDMsxxQ8EdkUIe+t90/3VDAMoQU+2LNfDIN1xKVbiUXahIWoZSkmJBR/MpXdNZ5YrURX0+B5EGtkyNmfuL63n+cuJAfibTNF6NLQowUSqnd6DMY4c3fpBlXzV+9sR3S3do6oAIIxpQpNeBzSkq+hnLQ/f6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(2616005)(4744005)(44832011)(86362001)(66556008)(2906002)(31696002)(66946007)(5660300002)(66476007)(956004)(478600001)(8676002)(6486002)(6916009)(54906003)(26005)(16576012)(52116002)(186003)(53546011)(16526019)(4326008)(8936002)(316002)(31686004)(36756003)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGN3eThQK0NxNldIcUhUSlVuT1AxK3dHTitmb1VBaTlERFpMelpMQkR4anI3?=
 =?utf-8?B?VGJBYmNydHNTemZjcUYwRml3eGRSWkh6V1JsaFhYY05oQjZyY2YwWS9TUzNm?=
 =?utf-8?B?RzdoWlUrQm5HWjQ1QytRdjk3WmtKNTdYeWhJaDk5b3RLVjdGc2lDMVJPemE1?=
 =?utf-8?B?QVlQdjJrRG5HVFZ3SzRUOWpTcWIvdHhtVGZIT1BiWUM3L1d5N2JEZWdBWDNW?=
 =?utf-8?B?SDlYMCt4dmZwei9RT3VVdE9VOTRMZ1NpMng2dXJEOVIzbU5KVjZhN3dDV3Y2?=
 =?utf-8?B?N21JczVrN3lSNFJJTkN2dHpMY01zTDRCZExGaG9YWHZnTFE1dmVjbXc5SHVj?=
 =?utf-8?B?ZWZsUmlpV0l5eUEzTm1iQk1zT2J6MHhBMjJremdjOUVKdmh5TnhXMlN0UVMx?=
 =?utf-8?B?VnZNZHJhRklMV0h1eFdicTZQQmJ3TzVkYTJOZ0NManFmVmNsSFRUbTIrWG0z?=
 =?utf-8?B?Q1ZmanpjQkNvVHdudDZ2a0VneDRScDAvN2o3cFFNeHFKbmpseVkzckUxdXFa?=
 =?utf-8?B?SWNDd1FXVnR3UjNFUlkwZGFtdDlKM3N1VkYvOFdETU00RVBuWEdlbVZYay9I?=
 =?utf-8?B?UzlhR0xaN0hRc1FqYVQ5Rmt6bHNBN2ZrZHJkZUNLVWlzTVU4b0NVZ2xUMUlH?=
 =?utf-8?B?czFVdHJ0elJUWmZuTThJazhvdy9pWTNSMCsvd2tzT2ZTcGZmdTNuUVdPTEZh?=
 =?utf-8?B?S0tzQWZWdDFGbDA3S2tubFpOZ1pCTmlIRDl3VlpobWR2bUljcU8zcGt5Y2Q3?=
 =?utf-8?B?cGZaOVFsNlN0U2dIbWpHVExkTHcyYUtpVUNNd2JLT0I4OTdzZmxPZ1VxdDFj?=
 =?utf-8?B?THJuby94bXVtRzl0TXRXMlNMSzN2TXZrWlBLWEt6TmVQN3U4WFpjeFRyTlNC?=
 =?utf-8?B?NE5hUU1NZk1KNzZBczZDU2Jlb0wwY3AwVGNLUjRJWWM0S1E1STR2d3AxT2Er?=
 =?utf-8?B?U2g0eEJKZWtoVVdlb0Z0bFUxWkVQODEyMGYydXpDT25lOWRkQVVrN0lYeUE2?=
 =?utf-8?B?V2JGeVZqV3NpQ0RxZ2dZa1k0MlJ2c2Q5eUhYV21DaXZFS0hudzg1VjEzUGtz?=
 =?utf-8?B?UVBQNFZzbEtwWFJuRlVmUmtoRzFnclU0ZC9JQWpnWTNNL1kvemNTdk5EWElL?=
 =?utf-8?B?WS8xVFRkam9jdUJJSjVHc0tuUDdKTmI4eXRVM2YrQlJYN2s3dktyMnVPcWFw?=
 =?utf-8?B?ZkJGU2x0RzVneHhUWnFIay9CVHlYTDVjOWt5Sy83UW1rY1ZJNlh0RE05TnVv?=
 =?utf-8?B?RlNidXVBSzNGam9ac29ld3ArMm8rNldCRU4zMzVWa0xNcVQrVi9NSG5UQkFl?=
 =?utf-8?Q?wqu/viBAUmWREYzgaQH/JPbpKnOO0glabm?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa0039b-3c2b-4b51-e78f-08d89525f8bf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 11:49:19.3699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Mk2jou+QzNh29miw5si44fKo9SEggnsw5XRsVTbFFipOntl4YOh/FDH7XJFIcYT9rOxReOqiYpwJ5eotSOQBzMcWeZd9ojAk/vznrGHKOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3617
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.20 12:44, Andy Shevchenko wrote:
> On Mon, Nov 30, 2020 at 1:06 PM Schrempf Frieder
> <frieder.schrempf@kontron.de> wrote:
>>
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> There are other NXP NCI compatible NFC controllers such as the PN7150
>> that use an integrated firmware and therefore do not have a GPIO to
>> select firmware downloading mode. To support these kind of chips,
>> let's make the firmware GPIO optional.
> 
> ...
> 
>> -       gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
>> +       if (phy->gpiod_fw)
>> +               gpiod_set_value(phy->gpiod_fw, (mode == NXP_NCI_MODE_FW) ? 1 : 0);
> 
> This change is not needed.

Indeed, thanks!
