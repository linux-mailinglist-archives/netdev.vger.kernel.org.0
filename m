Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1B2408BE0
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbhIMNHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:07:00 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:9633
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240008AbhIMNFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:05:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjGT9TSCdR28qrGrEOuQJ1CHyzbGL6EwK8qz8arl07MBgkElZJsNlR24NVzamV40MDVZZVqOy4Iocdrd3VdvalEIOon26VSpvx9b1YlR4EGtptPF0bPvLVtGCkNWuIm0ma5i1q6c03RCnMoLp0jsj4ydUb6/baGG5co+isClGDWIIT4NFOFoZZAJvCCYDbqT48s4YXFhK4AE7AhbkaXkt13EdjcXJPzYCNqka23Vevpcsg/jqHIPYggW+3dNgtF827OqCK2xmS2v1ARJUnfQlGHY9RqatiJC/Vx+bqhPG+CmLpayQ3TYpuj9p3WZ7ZLSrf+42q4hWsA8tMG4S9ZWyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cfofvTSkHjYDsU3jyU6ThliW4B7lrnRRP6krW+vV/8o=;
 b=oD7BUreyrakiIKjxkGGAD3nNAcE3ie/xFvszm5zf/3/vmPLo5zqmQPvYCQxL/2eAZHT7wsXnIIYFydE9j1+WxgGR1bQA0EpsTfP5vrjQ8y/++aT/sq8NAffdUP+nsjADRkA7xpAHoVIdJjhPV5UyigyaHOKXZBBx4IoXj3e/E7jsaPhsNEM8VLuUmVEMYkQkjaiBiXJiSICHS/X6yiyi44FTpGM/ha+yR+GrQMd1NkPgfqfOtX6l1t3yyChytQYKHAUIs28VSRGaYM7HziZao0chB/X39OGBuQ325CS3kdq4SWuhWA4L8ALxI9/Yok/XKsan+hbizmtF3HrHLkblrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfofvTSkHjYDsU3jyU6ThliW4B7lrnRRP6krW+vV/8o=;
 b=lqKee5FjaJUwjy97Esu9G8INWIvIDQg20ZEHtEVxOqB6lP2KZbQHv+tVEI3O09WiLKoqnGnx87/9NE2fGzXbIgbfdjUcSFuHBqxU8NZlGI07BkVD0SvVud0Dj+byPXWHSVKO9Hg73epRsFymD6NsbRWuhGty6YeaUd71Jb7s5WE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:03:12 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:03:12 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 29/32] staging: wfx: remove useless comments after #endif
Date:   Mon, 13 Sep 2021 15:02:00 +0200
Message-Id: <20210913130203.1903622-30-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:03:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c126864-061d-45e3-fef6-08d976b6d769
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502AA56DDCD836D711D46EC93D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QN4ueOhni6wMhs+kF3sw9Dh7QKJBzA/xNhBtfaJwVI2OPCU16CoZ+PWb9e1NQ+KPYeBMvcYAFj+l+KqNRXmE4NkAy5oj2E2Z5eHcmmnoLJm2twgAbjdcj9GmHYJ5zwVwByBGeNnrlptUp8jRwBOkFtU9J5I/ncR7lTJ6XBSEtm6uCqZ/PX/fH1i59+/gXzNpPAB4Le3E5rWUoJ7y+Rw1I5esCEWQjhjB0/x68ni7nT9K0neZwB1XQ03bQiBsNySTka7I74OwkAA2JAsE5xJbetXSMzuMRVuMgeMObVoR8ho/14Eich3IdudRJr8MYsPnWv0CD71Bakyentjds7gl+9h1x1JEukNXmhUr0CaYVPE2zLsDkdCoFvh108ZrIA5id9Y4n5FqcVss3dqvutkQryNYJZMqeKGbWpehx695yO6lv5EeZ9Z3kF5wkmiNXzx0PlYwVPUtvk/bFGzsZdCx+uobWtKTn14k964tcAKqgMFIqFHCd0yBh6m1IVhdLKMJFjXYpksASkOVVIyi1gKRhboaI856t4uK8WFuHIAr2l8OLklA+xqkG9h5ow5d6SnTuVq0f1yPKeFq5xjHAfwEVdSJZLSYSwxCmLXFUdcJp0Hs8mWzFSPzWldCUOX/V0yzG4WKb7ZZyD5d99R6Jj8M2XtYAbQsVVCSkP+JP0MFybeOpwnCk2WB+oHuS7QwW/zcWSyw8YBFkf/Uvlids54Rbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(66574015)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnJKbzJGRFlmUm5iTWloNS8yT2dkSnl4ODVKdWVQOGRMejNuR1N1TldQMi9r?=
 =?utf-8?B?eDVQbGJqL2V6ZHZUMVF2QmVFZ1R2Zmw5RWtvbjFBdy9mVzhpZ0pUamxMSWNa?=
 =?utf-8?B?ZE05alljMXgwM1FlRElFS2Z0Q0h5Y1F3cW9TL1dWb1ZGYkl5dWUxS1Bza0ky?=
 =?utf-8?B?OVdGZUhSTjYrM1hZUzdNNUtDNXVDYjhHNUNwMjdEalliRUN5ZVhHSllyekFW?=
 =?utf-8?B?SnMrbHc4RkZqeHpjRWZWTUpUY1ZIUFVMYlBhQm1IRWV3czc3K1dtRDVteWpZ?=
 =?utf-8?B?amJIb1ArQ3ZIWWR2MW5tTWI4ZFJoYzRLdkpaamZKNkQ5RndKZ2hibTFGUThC?=
 =?utf-8?B?MmJETDRHZlkzV0JrOWxTWXgwMWd4ZmZnQXB3TDNScC8zYlZJYWFpSVdQMUtR?=
 =?utf-8?B?M1RJQkdxR1FqYkVMK1EydzZxS2ZsTWRxayt4aWNaV2NIVS9kampLY3MzMngx?=
 =?utf-8?B?dG1JVG5YYnU5QTM1YUxFZE9vWGtBclh5YllCa3RIWStaV29WUHVyZWZWYklM?=
 =?utf-8?B?VzJMSEpGUlk5c0gxT1ZsYUlPOVhxZ1k0YTdwRHZhc1FtUkxRQm11Uko4VGRK?=
 =?utf-8?B?QkZnZnJGRkdsZ3d6d29LaXIxTWM0UTZNTThRNG9FejV2NkNLcmhKWnFvTndq?=
 =?utf-8?B?b1Q3aUE3R0ZYNUZpVTk5bFVjTGYxUFBBV3Z6MnRBc1lNNHZWNXRYLzVrSjZ4?=
 =?utf-8?B?RzA3ZkRuSGFTL3JBYjRnODJRRHl2ak5sVlEyQ1RGTmJmMk9ZdkVwN2Z4cXlo?=
 =?utf-8?B?TWs1c1NjSjJ1b1gvM1VoMkc3M0lZT202eHJNaE5LUHd1VCt0VjRIbWxIWmdh?=
 =?utf-8?B?NURpa1pZR0k3Y0JIS1VvcUhBOEVZV09pdEpGTTB5ejlYMXVtUmVPS1MydWN6?=
 =?utf-8?B?dko0ZVBEdkR5Rjh4M0FNQVBjbHBBdnA2VHE5QTdLQ1hBOWcxeTFlVUprcExV?=
 =?utf-8?B?T09PcVV0WEh0cFVRQWZxVVBNLzArQWlsclNrMDA0YkxQTi9tYllmUG5wR3Ja?=
 =?utf-8?B?dUVNczY4VTVTTU4zN1NFTHZkdWVDenprVi84eFBtMUE1T2VWdFJIaGFkWjc2?=
 =?utf-8?B?eE5kRzJ0SnNaZGM0TkV0cEx2ZTBEMyt3TkU4M21IMmpGbzBkMWlQT1FIQW9M?=
 =?utf-8?B?T2J3bjlQeFFxNG5TUGloRnNsQ2h6eEpEZi9wMThGSU9YMWpQWGsvV1pBc2Nj?=
 =?utf-8?B?UEZPRjFEWlZ2aVJhNzZZR1hmUWRXeXNWYS9rUzR0NU9maE1xVFVEZnZBcUU1?=
 =?utf-8?B?VFp5cUw5dEV3elpQNjFsVUgrU3h1Ris2aXdlbUoxc0djd2xLR0JsQnBXNmFT?=
 =?utf-8?B?UWxISDltTFcwTzVoUHNPOTNCd1plU0x3VXhPWmd1QVdmZUFrbVF5Q291aDQ5?=
 =?utf-8?B?Qy8vVi9kdmtoTTMxVE5vOGUwVEcwa21PRFl1MGhYZExkaDZYVGFtQjJNUkVn?=
 =?utf-8?B?VGpGMWw1QSt0ZTN6TWlHcnZacUpmdHhsNE9qUUoxa3FVS3NhQTBHT2VIT1Ry?=
 =?utf-8?B?RkR5eDdnUFJqU1gzUGFIMEpaQmxZVVUxcWZ4SUthK3ZCRk1nTmcwY1RCNjJ3?=
 =?utf-8?B?ZU82NHN3enZMd0F2UlB6d3BielFwWjdlSDVPbXBVMlhWaVVzZ2NlbHpoeEVK?=
 =?utf-8?B?enpMdGlUOElmQWdBS3ZDN09pMjJ4ZjUzNUFzbW9SUWdBVnBTU090MmszYzcv?=
 =?utf-8?B?bXUvVm8zZ0ZwY1RPeUNmdTU2c1hMK2tDV0JOSVFXM0JPZmswOUdGY0FkS1U0?=
 =?utf-8?Q?NKMiZb7MJW30O2dxdYIomil8vua6QawuOfesTO2?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c126864-061d-45e3-fef6-08d976b6d769
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:03:12.0998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBZ7Ef/OZ4QUB7lsf8niZ4Pyop4u5oKPkwhLHQWN8pWLg9L48jJxz3/bOyPxxse5vznYD3PVNfp8lGlZMEOusw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ29t
bWVudHMgYWZ0ZXIgdGhlIGxhc3QgI2VuZGlmIG9mIGhlYWRlciBmaWxlcyBkb24ndCBicmluZyBh
bnkKaW5mb3JtYXRpb24gYW5kIGFyZSByZWR1bmRhbnQgd2l0aCB0aGUgbmFtZSBvZiB0aGUgZmls
ZS4gRHJvcCB0aGVtLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguaCAgICAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmggfCAyICstCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguaCB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuaCAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmggICAgfCAyICstCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2h3aW8uaCAgICB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngva2V5LmggICAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgfCAyICstCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L3NjYW4uaCAgICB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmggICAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCAgICAgfCAyICstCiAxMSBmaWxlcyBjaGFu
Z2VkLCAxMSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2JoLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmgKaW5kZXggZjA4
YzYyZWQwMzljLi42YzEyMWNlNGRkM2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
YmguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmgKQEAgLTMwLDQgKzMwLDQgQEAgdm9p
ZCB3ZnhfYmhfcmVxdWVzdF9yeChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldik7CiB2b2lkIHdmeF9iaF9y
ZXF1ZXN0X3R4KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIHZvaWQgd2Z4X2JoX3BvbGxfaXJxKHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIAotI2VuZGlmIC8qIFdGWF9CSF9IICovCisjZW5kaWYKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3J4LmgKaW5kZXggZjc5NTQ1YzA2MTMwLi44NGQwZTNjMDUwN2IgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV9yeC5oCkBAIC0xNSw0ICsxNSw0IEBAIHN0cnVjdCBoaWZfaW5kX3J4Owogdm9pZCB3
ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZf
aW5kX3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2IpOwogCi0jZW5kaWYgLyogV0ZYX0RBVEFf
UlhfSCAqLworI2VuZGlmCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHgu
aCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCmluZGV4IGRhZmQ4ZmVmNDRjZi4uMTU1
OTBhOGZhZWZlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaApAQCAtNjUsNCArNjUsNCBAQCBzdGF0aWMg
aW5saW5lIHN0cnVjdCBoaWZfcmVxX3R4ICp3Znhfc2tiX3R4cmVxKHN0cnVjdCBza19idWZmICpz
a2IpCiAJcmV0dXJuIHJlcTsKIH0KIAotI2VuZGlmIC8qIFdGWF9EQVRBX1RYX0ggKi8KKyNlbmRp
ZgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5oIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9kZWJ1Zy5oCmluZGV4IDZmMmY4NGQ2NGM5ZS4uNGI5YzQ5YTlmZmZiIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9kZWJ1Zy5oCkBAIC0xNiw0ICsxNiw0IEBAIGNvbnN0IGNoYXIgKmdldF9oaWZfbmFtZSh1bnNp
Z25lZCBsb25nIGlkKTsKIGNvbnN0IGNoYXIgKmdldF9taWJfbmFtZSh1bnNpZ25lZCBsb25nIGlk
KTsKIGNvbnN0IGNoYXIgKmdldF9yZWdfbmFtZSh1bnNpZ25lZCBsb25nIGlkKTsKIAotI2VuZGlm
IC8qIFdGWF9ERUJVR19IICovCisjZW5kaWYKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvZndpby5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmgKaW5kZXggNjAyOGY5MjUwM2Zl
Li5lZWVhNjEyMTBlY2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZndpby5oCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZndpby5oCkBAIC0xMiw0ICsxMiw0IEBAIHN0cnVjdCB3
ZnhfZGV2OwogCiBpbnQgd2Z4X2luaXRfZGV2aWNlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIAot
I2VuZGlmIC8qIFdGWF9GV0lPX0ggKi8KKyNlbmRpZgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9od2lvLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uaAppbmRleCA5YTM2MWVk
OTVlY2IuLmZmMDk1NzVkZDFhZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9od2lv
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmgKQEAgLTcyLDQgKzcyLDQgQEAgaW50
IGNvbnRyb2xfcmVnX3dyaXRlX2JpdHMoc3RydWN0IHdmeF9kZXYgKndkZXYsIHUzMiBtYXNrLCB1
MzIgdmFsKTsKIGludCBpZ3ByX3JlZ19yZWFkKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgaW5k
ZXgsIHUzMiAqdmFsKTsKIGludCBpZ3ByX3JlZ193cml0ZShzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwg
aW50IGluZGV4LCB1MzIgdmFsKTsKIAotI2VuZGlmIC8qIFdGWF9IV0lPX0ggKi8KKyNlbmRpZgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuaCBiL2RyaXZlcnMvc3RhZ2luZy93
Zngva2V5LmgKaW5kZXggZGQxODk3ODhhY2YxLi4yZDEzNWVmZjdhZjIgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngva2V5LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuaApA
QCAtMTcsNCArMTcsNCBAQCBpbnQgd2Z4X3NldF9rZXkoc3RydWN0IGllZWU4MDIxMV9odyAqaHcs
IGVudW0gc2V0X2tleV9jbWQgY21kLAogCQlzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLCBzdHJ1
Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCQlzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXkp
OwogCi0jZW5kaWYgLyogV0ZYX1NUQV9IICovCisjZW5kaWYKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvcXVldWUuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaAppbmRleCA1
NGI1ZGVmMmUyNGMuLmVkZDBkMDE4YjE5OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaApAQCAtNDIsNCArNDIs
NCBAQCB1bnNpZ25lZCBpbnQgd2Z4X3BlbmRpbmdfZ2V0X3BrdF91c19kZWxheShzdHJ1Y3Qgd2Z4
X2RldiAqd2RldiwKIAkJCQkJICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsKIHZvaWQgd2Z4X3BlbmRp
bmdfZHVtcF9vbGRfZnJhbWVzKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCB1bnNpZ25lZCBpbnQgbGlt
aXRfbXMpOwogCi0jZW5kaWYgLyogV0ZYX1FVRVVFX0ggKi8KKyNlbmRpZgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaApp
bmRleCA1NjJjYTEzMjFkYWYuLjc4ZTNiOTg0ZjM3NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zY2FuLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmgKQEAgLTE5LDQg
KzE5LDQgQEAgaW50IHdmeF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qg
aWVlZTgwMjExX3ZpZiAqdmlmLAogdm9pZCB3ZnhfY2FuY2VsX2h3X3NjYW4oc3RydWN0IGllZWU4
MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpOwogdm9pZCB3Znhfc2Nhbl9j
b21wbGV0ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IG5iX2NoYW5fZG9uZSk7CiAKLSNlbmRp
ZiAvKiBXRlhfU0NBTl9IICovCisjZW5kaWYKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCmluZGV4IGYzNTlmMzc1Y2M1Ni4u
NGQ3ZTM4YmU0MjM1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgKQEAgLTcwLDQgKzcwLDQgQEAgaW50IHdmeF91cGRh
dGVfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYpOwogdm9pZCB3ZnhfcmVzZXQoc3RydWN0IHdmeF92
aWYgKnd2aWYpOwogdTMyIHdmeF9yYXRlX21hc2tfdG9faHcoc3RydWN0IHdmeF9kZXYgKndkZXYs
IHUzMiByYXRlcyk7CiAKLSNlbmRpZiAvKiBXRlhfU1RBX0ggKi8KKyNlbmRpZgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgK
aW5kZXggYTQ3NzBmNTlmN2QyLi5mOGRmNTlhZDE2MzkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtMTYxLDQg
KzE2MSw0IEBAIHN0YXRpYyBpbmxpbmUgaW50IG1lbXpjbXAodm9pZCAqc3JjLCB1bnNpZ25lZCBp
bnQgc2l6ZSkKIAlyZXR1cm4gbWVtY21wKGJ1ZiwgYnVmICsgMSwgc2l6ZSAtIDEpOwogfQogCi0j
ZW5kaWYgLyogV0ZYX0ggKi8KKyNlbmRpZgotLSAKMi4zMy4wCgo=
