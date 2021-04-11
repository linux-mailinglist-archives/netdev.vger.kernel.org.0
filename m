Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8893A35B70D
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 23:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhDKVjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 17:39:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42648 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbhDKVjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 17:39:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13BLc0tn166985;
        Sun, 11 Apr 2021 21:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KOtxo/G9T8IVc8P0/DORCfCHkUQpPS7ymA1cdr3FT0Q=;
 b=vLMxrvC5ZHynokoW2RbWtcI32eoVCyBi2p3QLDj5amNUXvOhHPG+NGehMBXNO0DYAQH8
 4LSn1IVG8nBXFNCGGGu5J0fjACAQ7gcJ3OkOqlLo4Zti1bvY3FNDAvhqRHxQzKjcWfee
 Cq203OhzIi0JjmdYx8UJMQyzFFPFzj9OzBfn+CtfwQbZC7x2+iq6QZcuU8cSzk46pxAt
 EBE/grb64GhX/bI3NFj+RRsZItIBAyvAJlkX0HoqAthiJIzn1HkdtPnLnqtnVFuBXfXD
 hCq/l8gRcSAZq5wAxkuGEpay5vz3pOiyxHW/OgQSE9j+SvKCEZ5L/PuL1YtgAFB3HJsm /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ym9w43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 21:38:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13BLVYTp053946;
        Sun, 11 Apr 2021 21:38:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 37unwwmfn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 21:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQjk6ZorSPXfkSwKze8518Arqm2OiY6bYxymRiHrQtVtRKX6CxiU99rjj57ZjMRpm5x8yHYM7OXhrYtYXHaHFDclYZLq6CLbSl7kUk4E7MZuPuDOfsT7dk7nZPptcqmBkjr3d9NTx/VbBaWEam2RB4w2DH9q/YYdfrE1FE78tl8XMUDekrROX4BdBJJjVLzTAi3LOSoQXwjyWu39uDlgv5xrs+XcnxJc3eyPIkKhPwHfU1qpRv73n4lnOdlPYxuSD012qlqCQcMaGKTQiKB7dzxtmm5zvbhUge7NC7ORFLxms1cVJMTlGX0+MZikXhNgdGYznqHeihkculMughtHqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOtxo/G9T8IVc8P0/DORCfCHkUQpPS7ymA1cdr3FT0Q=;
 b=k5x2tmeJyjMO3bOXgojPIPBoe/zQPKAe5SQ4Jok+rR1qkyO6YvVrZNX9aINKFs9kZb6OBJ5sEdZ550vVFjiKBiN54m0Ve4gEoyR/1J0ChRiB1dtnCVh//E9hLBwlqMIZXTPmi2x//c44NrnkmJ/vAJ7sffyRvRjiZThUyto2x3+z4wYrm2Cx4BEjRNXOCq7AzbWs0KRBdTD6c0zMxGm8NViiXsgLmG7Fhp8q4Exg0THxIwM+YspCkZS8EhgpF2aAv8Q88C1MWNK7HntkVpk+q4npK6j9p4T2uGs7zgF57mSjmnOSYCe5Rw+DlzA9FHcaLjbNE9CGDKgygy0t7zLv3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOtxo/G9T8IVc8P0/DORCfCHkUQpPS7ymA1cdr3FT0Q=;
 b=DTjqgQz5vwOsxRUoEyc9LnF6Wq23LmFoOQiWMTDboDGBcBqGBtipUtYTXohUBxxy0RBJn0bYMk5SvmQGZAk16dnMU4/faIZNAogDZrwhzKoGz2rGIGGfvmsBaW3QT6waD32rC14CKIerWm1oOdF2FmkvelmJDwq77nPmbbYmd3g=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR1001MB2133.namprd10.prod.outlook.com
 (2603:10b6:910:43::27) by CY4PR10MB1303.namprd10.prod.outlook.com
 (2603:10b6:903:28::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sun, 11 Apr
 2021 21:38:31 +0000
Received: from CY4PR1001MB2133.namprd10.prod.outlook.com
 ([fe80::40a:b796:4a86:d0cc]) by CY4PR1001MB2133.namprd10.prod.outlook.com
 ([fe80::40a:b796:4a86:d0cc%3]) with mapi id 15.20.3999.034; Sun, 11 Apr 2021
 21:38:30 +0000
Subject: Re: Re: BUG: Bad rss-counter state (4)
To:     syzbot <syzbot+347e2331d03d06ab0224@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000071203205a5eb4b43@google.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
Cc:     Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Song Liu <songliubraving@fb.com>
Message-ID: <8673c64a-108e-ffc3-0566-407479b95594@oracle.com>
Date:   Sun, 11 Apr 2021 23:38:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <00000000000071203205a5eb4b43@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2a01:cb18:5d4:4d00:8100:b7d0:537c:a76a]
X-ClientProxiedBy: MRXP264CA0006.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::18) To CY4PR1001MB2133.namprd10.prod.outlook.com
 (2603:10b6:910:43::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb18:5d4:4d00:8100:b7d0:537c:a76a] (2a01:cb18:5d4:4d00:8100:b7d0:537c:a76a) by MRXP264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sun, 11 Apr 2021 21:38:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62eee7a6-94ff-4c16-3998-08d8fd32265a
X-MS-TrafficTypeDiagnostic: CY4PR10MB1303:
X-Microsoft-Antispam-PRVS: <CY4PR10MB1303E04EDBCF35BC8FE4D4F797719@CY4PR10MB1303.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2AUCh/idsRXY3GSagzBUeUcTBFaAZQ1Ja7IdJkgVL0zNA+fuGkxhfx1AHePKopWBc05imXemokJ7+m6yWA1AVWBVjX2H0VX6Q5qx0KlPJxYuha4zHhEbr1Cm/b/LMlVjggdx17yt4CwWj0ZWELov+rivDtVc5ikl9bxQdCX0p0navIhabC5ymfo6JChZJx/EFEm3c0wvpdcxlIWchFSV3nLCdjzYy6ikjX97gyACSM9ibZaoit7Cb2iauPfg8E0x3/DMZeNrwKdho6jN5fsp/ILeGK3pqw5wcT9dUYjf92/7sf7Jkz2XSnyug/BU52FbkjH9mM/GIryrmnUf5/xzsz0w7OUn75j4cdiy5pdqVpnDag2E1WJYPEg6eZO3H/KKL5CTtzaBed+8AvUOhBXQLaFfGpI2cx2V5Gfqs/9J1vje1v5q0585j5NdUsMtonAyGdTjP8pt1tAcpBgxv0Mwccw73qW6O9xitWuGh8Z6KkfS3HbEDS0cJ1vlj2yTZmbKcOnLs60f5QlUw8fuPfvwAn3iCA7I/oqEq2Txg7GBh9EGIoAXvjHtM+IsETm4UynGFL+GyPCMS+BAdvSjtsjmrDNJPuwhmc+oC1TVEblX9aXk0Xsp5AzUr3gmD9VHA17nMrGQn18mKX7oVNilkFKnmlEd+FRVNF4spe9nSVTN0HbQD8s6FYA4SH8vrjt1DUC/5Syg72p2eFR9m5qo530V2XmTQuY7mLQLhzxKwOYQ6xa1zb4asdmHZQAJfXpkIRZS70Ehbh2aW7me7sds2yk9EzmdD7M/ecRhUeMN7g867iA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2133.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(83380400001)(86362001)(66476007)(36756003)(16526019)(7416002)(186003)(66556008)(38100700002)(6666004)(478600001)(66946007)(44832011)(6486002)(8936002)(2616005)(53546011)(8676002)(52116002)(316002)(31696002)(31686004)(4326008)(54906003)(5660300002)(966005)(2906002)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OTF2VWFoSHhDSVdMOWg3MGZaSXViYm10Z0hGVkFjc1QrZG10aFBKMzRyZVQ2?=
 =?utf-8?B?NWw3UWN6OG05NDBZTXgrVzMrK1JtUU1SUG84TDk0bFVzcUlOdUJmUnJqeDB0?=
 =?utf-8?B?L3dhcmc4dEU5akNtVkxseExIZCtCZCtadVNKaFZaazdUcUl5ejNrZlBaN3R5?=
 =?utf-8?B?Zmp2akVtVlVudVg2RlZSVzFlQjRKemZzRnE3SWE4MVV2c1F4ZFdpQzMzaFZa?=
 =?utf-8?B?UEN6dDdzWUc3MmtVWmdMNThNbFNuL1FycExZZFJyWUYxMStmekxmdnhUTmhm?=
 =?utf-8?B?Z0xMeDI2YTBmOGFQN2ZDQ3BNeEJzbmM4UlBkRkJzOXFzVytTVHB0UHJneGEz?=
 =?utf-8?B?M2ZTQklWcEY3Rjdqa3NTbkh0WVFyVFpuVGdENlZZWnN2ZzlPOTY3V0xmSTlm?=
 =?utf-8?B?L3lBakpBRnZWOEdDVGRONVZ0alRBNUJGU1dyYnRRalFpT1dKQVFkWmZMa3d0?=
 =?utf-8?B?d0hjWG41ZWIrQnRDQjdSc0oxZDdCZS92eUZnSlVVTlpmVkJnUFQyV3JqemU5?=
 =?utf-8?B?TTB4ckhuMlZZVGxSWWpyakhBeThaR1B5cVRWa0xSanhDNGFPVHdVMGNjRU03?=
 =?utf-8?B?YktDU3hrcTNGb3FZMnRudU1QOFhLem53bDZSK09oaTJaUll4NURiNXA0SWZI?=
 =?utf-8?B?RGZmMzNyQlB2RjlXajU4dURuQjlUT2NZckgxY3UvVmZyM3h6WUhnTm9GYnRw?=
 =?utf-8?B?SlhuT2JBOGZIWGFvcEFXR2tTMEIvOTZZT0s5dlZoL2UvVWRoS3IxT0pWMXhF?=
 =?utf-8?B?aVV3amFYRkFMTXU3YlFQUGJVeUdNc0RtNDRoaFhDSnBmK25GQUpyZEloNmpz?=
 =?utf-8?B?TmowRXdVVjBHQ3NlTllHWDFVbUlkY1F4dXZ2Uzh6c2hHTFlBZFdIVk96dnNr?=
 =?utf-8?B?aUtzS2oyL1Nnd0FIZ3RDeTFsMXdEa0UySDF5Skl3S0tPR0J4WTJMSmphM1h6?=
 =?utf-8?B?bzUzdndqRitwWHlvYVk0QVFnaVo0T3B5K2R4d1F3Wkw3d0ljd2xtaStBdE1F?=
 =?utf-8?B?Y1UwSU9SVi9wVGl1ZzFFeENSL1FmWW1SVmdoL1Z5UElSU1hvYzB1SnhDZkhT?=
 =?utf-8?B?aXZPcVFnbnRwMXJCbURlSUZhMmtHcXJYNkovTDg5QWZaUlZQWTBxYUdNM0Nx?=
 =?utf-8?B?SjhTWWFrVVl4Yk56Mk40K01aZlpkdEduaG11RUxyQmtmTE1rekxQMzFhcDdG?=
 =?utf-8?B?eHI4WmpYc2Y2dFBnREMyb2hBcXpjNisyc09ZbFNCSGRvZXZRZnlzaWMwZ0kz?=
 =?utf-8?B?ejhCMVVPOXJHL3d0TGowWm1NN1BvSWpWUGZPWkhJL3VBc2NwNTNLUXFRZVUw?=
 =?utf-8?B?dnJwQU9SVEUxNlNSTFJWdDJNdVNPZ1pxMTYxQ3JtRU9pYVRxNzJGL2NRSTdK?=
 =?utf-8?B?SlRxamw2SnRDeStDWHFkZ2diRG8vb3B0cldYTlNhZG9oc2lKQ0k1am9TZEcv?=
 =?utf-8?B?L244N09aZGRYRTZkTmlwaHhPZzZuT0JNVzdDSDRJcXJrTENJbWlZbkMrNkd4?=
 =?utf-8?B?Yno5WXRyYnBpTlNCV2JLdytLOEwwTXdYR0ZPMW91MWpvNDlNUmRWUS8ycU9E?=
 =?utf-8?B?aFZiY09qSTNnQVFpVEl4YXVhdk1NNXhPWGNITm5qYzRUUTFBb1FQS0pPbFZt?=
 =?utf-8?B?c1pKSjdHWVBrRVloempMY3BDTlFpaHlCK2R5TE9nK1cvMUFGWmpLL2grTkFS?=
 =?utf-8?B?dExiS3FSOEp5bjh6aVVUbUJBWUdGU25rR1ZBMno3OGtzYlNTWXVlZUF4ajhK?=
 =?utf-8?B?MC9zeDVGZkZ3d0VRUlM1MExrTTlNeTk4eHpLR1hVaHNEc0dsY2RtYjJhUFBv?=
 =?utf-8?B?dVNELzBxeUpFeDlFT0JjN3J0UWI4Z3BYNlNKY0xZVzZyZFJDYW5jM3g0Mk1V?=
 =?utf-8?Q?Xq4guARUB1fUu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62eee7a6-94ff-4c16-3998-08d8fd32265a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2133.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 21:38:30.8533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qhrjEBgC6Gvm0nea0Ok4EmTT6KSn9vQm/tN37Teb/UqQaOs56tHVBoRGUCC9IJgF0FizLyOWz8s4S+xkp+YnRmtO0C0CZeH05b7QfF3ZaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1303
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110168
X-Proofpoint-GUID: 3Us0G-U4iPb-WZYoReycz6IA7LFN2SQF
X-Proofpoint-ORIG-GUID: 3Us0G-U4iPb-WZYoReycz6IA7LFN2SQF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110168
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(trimmed off the batman/bpf Ccs)

On 2020-05-18 14:28, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 0d8dd67be013727ae57645ecd3ea2c36365d7da8
> Author: Song Liu <songliubraving@fb.com>
> Date:   Wed Dec 6 22:45:14 2017 +0000
> 
>      perf/headers: Sync new perf_event.h with the tools/include/uapi version
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13240a02100000
> start commit:   ac935d22 Add linux-next specific files for 20200415
> git tree:       linux-next
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=10a40a02100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17240a02100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
> dashboard link: https://syzkaller.appspot.com/bug?extid=347e2331d03d06ab0224
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d18e6e100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104170d6100000
> 
> Reported-by: syzbot+347e2331d03d06ab0224@syzkaller.appspotmail.com
> Fixes: 0d8dd67be013 ("perf/headers: Sync new perf_event.h with the tools/include/uapi version")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

FWIW here's a nicer reproducer that more clearly shows what's really
going on:

#define _GNU_SOURCE
#include <sys/mman.h>
#include <linux/perf_event.h>
#include <linux/hw_breakpoint.h>

#include <fcntl.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <syscall.h>
#include <unistd.h>

// for compat with older perf headers
#define uprobe_path config1

int main(int argc, char *argv[])
{
         // Find out what type id we need for uprobes
         int perf_type_pmu_uprobe;
         {
                 FILE *fp = 
fopen("/sys/bus/event_source/devices/uprobe/type", "r");
                 fscanf(fp, "%d", &perf_type_pmu_uprobe);
                 fclose(fp);
         }

         const char *filename = "./bus";

         int fd = open(filename, O_RDWR|O_CREAT, 0600);
         write(fd, "x", 1);

         void *addr = mmap(NULL, 4096,
                 PROT_READ | PROT_WRITE | PROT_EXEC,
                 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

         // Register a perf uprobe on "./bus"
         struct perf_event_attr attr = {};
         attr.type = perf_type_pmu_uprobe;
         attr.uprobe_path = (unsigned long) filename;
         syscall(__NR_perf_event_open, &attr, 0, 0, -1, 0);

         void *addr2 = mmap(NULL, 2 * 4096,
                 PROT_NONE,
                 MAP_PRIVATE, fd, 0);
         void *addr3 = mremap((void *) addr2, 4096, 2 * 4096, 
MREMAP_MAYMOVE);
         mremap(addr3, 4096, 4096, MREMAP_MAYMOVE | MREMAP_FIXED, (void 
*) addr2);

         return 0;
}

this instantly reproduces this output on current mainline for me:

BUG: Bad rss-counter state mm:(____ptrval____) type:MM_ANONPAGES val:1

AFAICT the worst thing about this bug is that it shows up on anything
that parses logs for "BUG"; it doesn't seem to have any ill effects
other than messing up the rss counters. Although maybe it points to some
underlying problem in uprobes/mm interaction.

If I enable the "rss_stat" tracepoint and set ftrace_dump_on_oops=1, I
see a trace roughly like this:

perf_event_open()

mmap(2 * 4096):
  - uprobe_mmap()
     - install_breakpoint()
        - __replace_page()
           - rss_stat: mm_id=0 curr=1 member=1 size=53248B

mremap(4096 => 2 * 4096):
  - install_breakpoint()
     - __replace_page()
        - rss_stat: mm_id=0 curr=1 member=1 size=57344B
  - unmap_page_range()
     - rss_stat: mm_id=0 curr=1 member=1 size=53248B

mremap(4096 => 4096):
  - move_vma()
     - copy_vma()
        - vma_merge()
           - install_breakpoint()
              - __replace_page()
                 - rss_stat: mm_id=0 curr=1 member=1 size=57344B
  - do_munmap()
     - install_breakpoint():
        - __replace_page()
           - rss_stat: mm_id=0 curr=1 member=1 size=61440B
     - unmap_page_range():
        - rss_stat: mm_id=0 curr=1 member=1 size=57344B

exit()
  - exit_mmap()
     - unmap_page_range():
        - rss_stat: mm_id=0 curr=0 member=1 size=45056B
     - unmap_page_range():
        - rss_stat: mm_id=0 curr=0 member=1 size=32768B
     - unmap_page_range():
        - rss_stat: mm_id=0 curr=0 member=1 size=20480B
     - unmap_page_range():
        - rss_stat: mm_id=0 curr=0 member=1 size=16384B
     - unmap_page_range():
        - rss_stat: mm_id=0 curr=0 member=1 size=4096B

What strikes me here is that at the end of the first mremap(), we have
size 53248B (13 pages), but at the end of the second mremap(), we have
size 57344B (14 pages), even though the second mremap() is only moving 1
page. So the second mremap() is bumping it up twice, but then only
bumping down once.


Vegard
