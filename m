Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FEC37C587
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 17:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhELPlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 11:41:13 -0400
Received: from mail-eopbgr40127.outbound.protection.outlook.com ([40.107.4.127]:50048
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232263AbhELPdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 11:33:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjfwfEt/ELpoyh2Bhoo7YQeKZzzsycz5P9P4jfot1vRZPt0ZefLVbJRYqGMG1g77+7WX3yztedNG1De4YBtCcTUqr9CRZyLUvQBdLf3HU81O5lylEB81nPNdf6sEyo3LrvfMwfy6WWt2+y5Nqstv9kn8thUfqHw3QaBtmGRIaeaC5x9a68vAH2SkMTCICaSeHpgeR80vBIvrJjKxcF4zWtSo7BPcy/EZ9Pcd4fuF3zFVyEto2aOs0vkmsyEmlsl4NPRfIqNj3deNCF9z8v3yZ6cS63nn221Dbb8hi6qEc8NpEc1wRckxPho/hiBXscoDynbWG1zW19pRXoA8Ju6Znw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMPMyS7K8mk26BU2BDB4pYDgJqUedzBB3tFnQJa1YUY=;
 b=XpXpVmPIzQOguBwHNfHGi+6VGceoEv/H5GONawm+Pj8x0Rmms+rv/kOSEvW6ykiKgapRfz3MxBJl5U+O7ytiRLHN+MkPiw3WjDRYzHT5m5r8H44b4BZAG6M0Zul/n8xDVC8fT7f/Z6ymh1WPNrR0Mt1ixhDef2Mz6kX1IVlSUMZm85Wi3g2ReJbQlMO6HCgTUY/VDQxYazbyg4k634AJKC94/MAo7/EIfIntuQ/y4aiLaHaPEmGsPb3zNMKHNxnrl/VMyQCfMvPLacB0HWoqlHTmjiNZVhSPdb2/P+GGlZmjhGwSXVrVvh/df8akXGk6Sr6wPUAyULG2kWbrllXHTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMPMyS7K8mk26BU2BDB4pYDgJqUedzBB3tFnQJa1YUY=;
 b=lhgijwgg/JUiD77yxi8HAkH2B8fL9E91N8j3iZB4V9P3FK+w/NGoNGZ97k8+7Q58NEOoO2Dy81d/A68wueqxEICxaNdvNq7o6V3H56cJ7NJsUBg0FO1Oyey0zc8bdFZUe/LkWbGOPTNKZjWJP6m6z8mqb04EDXtPGFMQ8jMCQvA=
Authentication-Results: animalcreek.com; dkim=none (message not signed)
 header.d=none;animalcreek.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2962.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 15:32:42 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3d8a:f56b:3a0c:8a87%7]) with mapi id 15.20.4129.026; Wed, 12 May 2021
 15:32:42 +0000
Subject: Re: [linux-nfc] [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski
 as maintainer
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-nfc@lists.01.org, Mark Greer <mgreer@animalcreek.com>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
Message-ID: <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
Date:   Wed, 12 May 2021 17:32:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.247.44.83]
X-ClientProxiedBy: AM6P195CA0006.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::19) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.27] (89.247.44.83) by AM6P195CA0006.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:81::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 15:32:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8479ea4-e509-4cb1-9094-08d9155b2ecf
X-MS-TrafficTypeDiagnostic: AM0PR10MB2962:
X-Microsoft-Antispam-PRVS: <AM0PR10MB29626251D48D538B7DE94DE2E9529@AM0PR10MB2962.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAak+kpfXxTG0qrJFgqE3NRJh6RWiQPiltXMb/fhvsuMs+HgRJOk5BSmQYSzcxKDjAfdNWhN3qjuS2PiLUgXjZ0LB+0Ee2RYl1kocq0Jlnfil0aFS6VTrRXGqjJenyCFGOR4Mf2ifCQ15oKY+Qirvk/FOZV1ObPgeBcOae/BzGj+0A8MCq+DhEg/lWmjFWatLDzdFifCrzCXnzE7Msjtx2852+HRScbIQWGhbU0uIJlrb3U93WwoSuZ6CevbP0lbeCsli4+SYCRo9TVoUk4ClF9y/ybstRKfbxkNmIEY8jIq/rtwa2keAOhKIWy4yY0y4GXIdiJtUfb7ieIC1PTm6c/W3JiU6rurI0dFNrn+LT+X+EJGrIuMoXnhpJJtusZPWDsmSKqsvGRlrSC8SoykbfR5KhEjUwGVdhXDj+vAPcZTYK0dmNR48ijDf+52O6ARIF87zRnqQWvZNv6qQfVNIZNXV73HGbgGSmpR4QbdvKtQtqKXBUmRrPYaFTC+Bp8of8+wc5ev+52y+Kley/5c/XaHxZAdRtSmxuntE1chtKiRPo1BFmvw1nN/t04qdFEDGBwzvo+diG7HeoQV8rWzZPm6yXaLZzuYjWF8OdubqzokinShzG4FzdiXvd3fqGI1Nw2Lm06jQ5xMvGezTqVK0tEG7MA+Q2iptVUag045SIXEPrt/fcppbx2lK03+5Jgr7an92DpUBmU/EbOPAkEeDRRVNwmy8/Mdm7RKEwGzbE+4q7PhbfZJ0FVfYZoAtY96F7PQllFFnzUSpmDoFdffvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(346002)(136003)(366004)(31696002)(86362001)(66476007)(83380400001)(6666004)(5660300002)(6486002)(36756003)(66946007)(316002)(45080400002)(956004)(2616005)(38100700002)(44832011)(16526019)(478600001)(966005)(2906002)(8676002)(186003)(31686004)(4326008)(26005)(110136005)(53546011)(66556008)(8936002)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aWloQ1ZkdjZhVXNUUGtiaXVNeDJZMW41RkZSWmx1dGhYOVgvcEVDeno2cC9i?=
 =?utf-8?B?c1U0Tm45NFFTc0RjTU4zM3dZUGdLamdtM0lZRjFpT3hVNXBaL0Zvd2QrdXRm?=
 =?utf-8?B?aVF0YmxYMDFlSXpwbzJqVERBdld1Ui95SHlqTU1DU3JFUTBSdDRzaTRlNlFS?=
 =?utf-8?B?bUhwMHd0SjN0WEZBTTE2MllVZ2tJZEZqRUkrMk9wcCs4dk5zTGNRWUtyRWU4?=
 =?utf-8?B?VlA4RDZjVVUzSFBaajVQNEQrS1dqQTM5OFZiWFM1SDBKMXZnQ0R2NjlJVDdG?=
 =?utf-8?B?dmFtR2E0aUxjMjRwR2JIQjRNamZic1h3SGxiWlNncU9GVkc3bFMvVC95N3hu?=
 =?utf-8?B?M1JpQlh3b3R6TUpmUnJPZTJhc1JvRmdCTzlXRG14WXF3a1g3Vmxrdy8rUXFE?=
 =?utf-8?B?ZU1UTkM2OXBlZTF1OWxrWUhxejlTaWVkd0t4UWZMRGpPcUdra3pFdWljaFYw?=
 =?utf-8?B?NGsrKzFuRzY4eG14U1lVY2hOZXc5ekJPWEUzampKUElpNkU5b1gyNGdHYVRX?=
 =?utf-8?B?a0xkY1UzMjdyaUsybGloaEZTSjNQNC9ZeG1xbkFjZERZb1hudlBtSFlNdzN4?=
 =?utf-8?B?ZExXMjlZM1g0Y3d2QXYzZW5vSFcvWHZLVEZpSklpOGczdFRJSmY5dXI1dzcw?=
 =?utf-8?B?Vi8rUHdkQ3l6dnJ3dmNVTVhYZk5HQkx2YlFsREhYL0kwNlNadzl4dldFQkor?=
 =?utf-8?B?RmdlT2VlTDdha3FhU0dSUmpyZWpRWjdacGdPZDRyTmhmQjNzQnlUeEtiK2pN?=
 =?utf-8?B?d2xUZ2VFWTM5NzNId09JSW43MlB0cm0wQW9mTnN4VUtSMW1yYWNhbFJqNUxi?=
 =?utf-8?B?cDE1ZjZvYUJFYTFQdnYzc0xhcFZ4d2EvZmx4eXpjbTRKLzN1amxwZEVoSENu?=
 =?utf-8?B?VzlVaUhsQmp6c3ZlMHdwcWYrU0VtSTVUYzFqU3RIMDdTVko4UW9lQ1lLTlFW?=
 =?utf-8?B?UmF4K0QyUS9VRWhNTTBUZnZ2SnZtcEpEMjZlU0t5REJVRVhrQi9sa28xZ0tZ?=
 =?utf-8?B?ZTRpNVJ2dmQvRzAwNjZyeTdlbmNSSy9tTW0rN2Z2WUxmMmY5K2ZjOVVtbmFQ?=
 =?utf-8?B?VmVWT1R6T1RUOGhiMkwrVlQza3kvak1DVU5MTVhvQXNzQ055Q2lJelJuWlNk?=
 =?utf-8?B?alhXTTN4RHB3ZUhWNDE3NjgvV1dmRUpWT2JjWlZxb2hLKzZkN3QvQ3VHOTNt?=
 =?utf-8?B?dWJKdzNRc0RFd09KaGsyRW1BaGJqaVBuKzBNM3BibjFJd0pidTdKaXlhR25t?=
 =?utf-8?B?WUVBa2ZwSkl5YytTeWphU0lKU0F1Q0VlS1lNbjNsL0hyanlxejR0RkRZZnAr?=
 =?utf-8?B?UExjSWxEY1A5M1RnWFIvWFBrd0FhU2h0MnJ4bmhRZ1IvWWFVVlR2TWE4VldZ?=
 =?utf-8?B?ajZKY2tKR3RJVituMTZPZXczbWpWdnFUNmUzT0JpUk9qQmZMV1FvNVltdFZM?=
 =?utf-8?B?QWZxNVFHMkF1VFBIRnh5VXdnUExtQy9nL2FvUFdOYWNVNHZyTjRuMER4NHZ5?=
 =?utf-8?B?WWpjWkhMMXNVeFgwOVhIRnNlZEdWOGZYM255MDhndGJLejhxWWtNNllrQzJZ?=
 =?utf-8?B?OWpCUitzWnlBQzhaeUVGVWg2eEVvZGVVRHkzRXZuTmxqUUF0bGdXeEcyaGdO?=
 =?utf-8?B?VTV0RmF1QjJzTk5OWkg0VXZvdlNPQWErRWtMMFRhaFFLcG9PUDBZOWtiN2lQ?=
 =?utf-8?B?V0s1UkhITVRmcFVsUTRMTWt1UG5mYmU4bC91TGJYdnZ5NHBQck5BbmFOYlpY?=
 =?utf-8?Q?Ri/E5UvxnzxEuYFX9MP+7uJaHWa7iEcF+snnbVW?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f8479ea4-e509-4cb1-9094-08d9155b2ecf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 15:32:42.2717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enkl/thF0p8zlj4sOFSqBpMN1Dp5flQwSxMcPhLmj2mg6BXN8Q2GsBGWu4KLnpEpJqNkNrTXjBDZClo4op4fLoS8kbghyqPrRzu10Hy/los=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2962
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.05.21 16:43, Krzysztof Kozlowski wrote:
> The NFC subsystem is orphaned.  I am happy to spend some cycles to
> review the patches, send pull requests and in general keep the NFC
> subsystem running.

That's great, thanks!

Maybe you also want to have a look at the userspace side and talk to Mark Greer (on cc). He recently said, that he is supposed to be taking over maintenance for the neard daemon (see this thread: [1]) which currently looks like it's close to being dead (no release for several years, etc.).

I don't know much about the NFC stack and if/how people use it, but without reliable and maintained userspace tooling, the whole thing seems of little use in the long run. Qt has already dropped their neard support for Qt 6 [2], which basically means the mainline NFC stack won't be supported anymore in one of the most common application frameworks for IoT/embedded.

[1] https://lists.01.org/hyperkitty/list/linux-nfc@lists.01.org/thread/OHD5IQHYPFUPUFYWDMNSVCBNO24M45VK/
[2] https://bugreports.qt.io/browse/QTBUG-81824

> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> ---
> 
> I admit I don't have big experience in NFC part but this will be nice
> opportunity to learn something new.  I am already maintainer of few
> other parts: memory controller drivers, Samsung ARM/ARM64 SoC and some
> drviers.  I have a kernel.org account and my GPG key is:
> https://eur04.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Fdocs%2Fkernel%2Fpgpkeys.git%2Ftree%2Fkeys%2F1B93437D3B41629B.asc&amp;data=04%7C01%7Cfrieder.schrempf%40kontron.de%7Cb7a843cdd3a9421a4fa908d9155456fe%7C8c9d3c973fd941c8a2b1646f3942daf1%7C0%7C0%7C637564274699221204%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=dJy3BljqfnZfwekCSGDdUy2kNcr7XxoDUUXJJwydq9c%3D&amp;reserved=0
> 
> Best regards,
> Krzysztof
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc81667e8bab..adc6cbe29f78 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12899,8 +12899,9 @@ F:	include/uapi/linux/nexthop.h
>  F:	net/ipv4/nexthop.c
>  
>  NFC SUBSYSTEM
> +M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>  L:	netdev@vger.kernel.org
> -S:	Orphan
> +S:	Maintained
>  F:	Documentation/devicetree/bindings/net/nfc/
>  F:	drivers/nfc/
>  F:	include/linux/platform_data/nfcmrvl.h
> 
