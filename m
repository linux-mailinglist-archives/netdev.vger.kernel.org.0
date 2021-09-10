Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD3406EF3
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhIJQJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:09:17 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:5472
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229877AbhIJQIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtISoqiPdNM9iyx3UuJkMPl4zVIYXKrXb/hgMOvJzr81AcfjXo6PoLxjuoqUyzbZ7u1QbZiLy94OTFJR26wN0M2JDLuG9dlYScF9WjTLll2YMfVzAWUV5YgM9Ab0Dyuc4rLOrtzqjl8o1W0iBjNv8DqhxXqA0ruVxguakE7CUJeqJNgjbwAdLsovV/LY7GwArSMX5yea1o6qV42feAwenLqEC3X4bCSiyeoaV4oCAS69VnpWDS9grc984PJb5W7n34AdMT3yNklH2wvUCuwL3PJY92DPLNA1xDgt2DPuIILhxVplqu8000E4GxRRrrONepnXaFeu8w6qRiMFXJnhHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cfofvTSkHjYDsU3jyU6ThliW4B7lrnRRP6krW+vV/8o=;
 b=WrB6UF8xnHVqVkVzbKOhIkbiJQaobIQ/ll4mczuM/8PU3xr1o7Cy7V7jxIC8Giga+KBe2qLvCezWVJUoRxjTEvlVn+HFrcN5FqKl+ICtf+nsX7XfLHPj+HH0f3Asfkg6TLVFNvqq9HVqSy9clN+sisLBi2PzEASgjHEJP0AyPHsxzsaJa5vOPxxPF6xbxDFnbvWrL7+EU5D6rj7pNZ5DEQmV0xWIog4/ixIZTQuwTBKRomidYTxDwF5XfsEky4XKekEV28JPTAfe9h9qqckd9tpgIkkPTs13f8SEDeE3swNWDf/4OUArBvXAp4hMqaeNtzDpA/PoK1JaFNXeVrqcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfofvTSkHjYDsU3jyU6ThliW4B7lrnRRP6krW+vV/8o=;
 b=PXFUeXasAfCIPvLMZ89OgjgT61AIDfnN9JqcLGwriJB48iMTkfld966b30vyNp4ngfu3moX4RO0Ls1nQVvzLd6mTxcLHiXc3RmhWVf+xvjjxrYkpEuUajxhZRboUt4gK1ksHhb5k9VwHFJREnZ3rXdjd6vZJeXbl84ClyFIbu28=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:06:28 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 29/31] staging: wfx: remove useless comments after #endif
Date:   Fri, 10 Sep 2021 18:05:02 +0200
Message-Id: <20210910160504.1794332-30-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2f7835a-3722-49cb-70b1-08d97474f228
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5099ABED8239F41C1F67FEF293D69@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZx0K0gjuiLTJ1RlAQal8g58VOdJLel6WiecZbKSLiDjpr7JLAqbyiUi3S3FTihl8V1zUR9qUMWNsHzHSYOTDRmhj7L7KIX8chX+PyE6uyaSK1tQghUY33RH7Fmb8ASEZPWTvZF7sIKmE2hupBKy8w6+PKGMkUwsdaOiC0YZGOsmd9CifywEjyjcEU3HdNHh+LCdwjj7kSHpIaYHdxhlaFb+93NJfrB/McTKbd2ph1ZxkKL4Y/pQpu47Gw0AZAmuPiV4PSnMHvqz5Bi6Lqow/kXkl2JnKB+0dnISvGsRK5rKRL5nkF7suhkSX6YxpsuWeFHip0e+YWMMTFfeIynFDXmnk9kL3XaVd7FWe/Pia3PzGpqxbgngbOw5+sIkRRS1IBTxeA2+/xDQbstLjitgX3s1FuJelecXVIIXwYg8agrCs+h7X7wYL/0D6827qC7xjy1UaH4qEknVccpKmSUMgvHyjhLSFQGzGPvB1WLAmW2YEyA1v7dBh6Z0fMcOXuv3GuWai+Z4AoGQVTlXIZCM+eImUdl0RM1aNilAHfCh2zSAZ2FQQHeMwIMK5tPzy11quaGRfGSbhyyduV7qaqyY55Acvy9T24r2NPsfITEqJO+nfmxRr3+yTxp0QXMV3uXirNWOUWUV4DJD8hqWp7g7bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39850400004)(396003)(136003)(346002)(83380400001)(316002)(66556008)(2906002)(6666004)(6486002)(86362001)(66946007)(54906003)(36756003)(1076003)(5660300002)(38100700002)(186003)(8936002)(66574015)(2616005)(4326008)(8676002)(66476007)(478600001)(52116002)(7696005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2pscll1ekRsNTZNalRwb05wUng0cHU0Nkcvb2lFZVRSTTVaMTRBWDhidExV?=
 =?utf-8?B?cDZmd2FhVm9MaUl5RU5Kd0JPVU1OTm1iZnJlU3AwRmlKakl4ZGtzWm4veFY5?=
 =?utf-8?B?ZWxaZkhrMzlqc0UxeHMzdGo4Qk1YMVVzUVRlbUY0blc3MGsvQkpySERrQTFy?=
 =?utf-8?B?ajFIZ3VIVTVPY01FTUR4WXpWQ0ljUmExc3ZHSkR3OGx0UUpJRDE4d1h2UmFs?=
 =?utf-8?B?Zk9DcGgwTEtIa2VHSWVkTW1oQTFhbDBTSys3QUpPWDMycTFkUHFlMDNLK3Nv?=
 =?utf-8?B?RTZoKzVmVHVsaEpCSlMvNC9mRkFOMk5qU3FUZWdxL3hzM014VTE0R285SE5W?=
 =?utf-8?B?UnZzNTZEOXNLWXhmcml4RkNERy9wYVl0cFBzOStuZU5FaysyU2pWSEpsWTAz?=
 =?utf-8?B?WURib1p0eW9FTDN2eEhGRWsrVENwM2lGaHAwZTN0OFZhZlQ2a0R3bW9PVWhF?=
 =?utf-8?B?cjZEeWNhQlFlUVdnOUduWTZDc1J3cisrMyt0MUdXNjkxajBUM3pLR1QrUnI0?=
 =?utf-8?B?MnlPcUJINEQ5WThLQnNyMVFKRlV4U2k5eVVTUHh5UU9PTTBRYmU4dnFwQjVJ?=
 =?utf-8?B?VEJOZThBbWM2YVdyUkJxUUR4VFZWNStkVHFYQWJIM0g2QUtDU0VMNHJGTW44?=
 =?utf-8?B?UklNeHpVS211bG9EQWhjTmkyZ3ltWmhqQXdUTVphQjVlV2FRWk9Yeit0a1Nk?=
 =?utf-8?B?UzB5cWpQUWV4S2RWcG5iVklaSHU1VEQ4eGJrRURrenJMTFQ3Q2l5T0g5WjVY?=
 =?utf-8?B?V0FBeU9CWDRQMmxwcEp2WkVMMVlBODFObTNtclJhR2hOcnNTV2dPMVkxclNT?=
 =?utf-8?B?RWF0aW9MT3N3U2drN3JUTWd1TnBzbWFlVXhlT1ppL01iMmRCRUQ5Z3BteElN?=
 =?utf-8?B?K2ZiVWx6TUtkRGwwdlVMUlVMY0JybXZVSXFrak15UTNZR2hRNzFsYzR6aWVa?=
 =?utf-8?B?MWVwSGZmUDNkdml2ak1zcTVvdnlDMU1qbm9wdzJueTJ4MXNndXZnazVYRTdW?=
 =?utf-8?B?d2hSSmZMckJ5emxyLzNwR1B6bFJ2VXJtMTNTUXZtQjAxaW4yRTZ1S3JDM2oz?=
 =?utf-8?B?MHFYakhJZktSMFdFVGZTdldQVjlSeENtdVk0bllYU1EyT2duUEhPS083ZSt1?=
 =?utf-8?B?NmkvdjBVVDZQOEpzRi9zeXNJakJPS2dOOER3M25JRytwRktrM29DVjBpMDZD?=
 =?utf-8?B?RzhlV2dXU3p5dW5PUmMzUjRmM1J1dS9ERGYyak5KQkRGN1JoUkF6TzlLVUl5?=
 =?utf-8?B?MmxjbU40Y0Via3NaOHFoTmI0RHZ6ZElIbmFTb2EzZ0M4S2lRanQvU2ZUY0dG?=
 =?utf-8?B?RnJRWUtrdUhsb21oUUVOSm9VejRJZVdSUm9OQmJ5Q05rd3hmd1YvMGJsR1ho?=
 =?utf-8?B?ZXdzdzJMZ2JQcEFpZStVSFRGTENwaGkrZ3NjVmthd0lnaWtkN2YxWlA1dE5K?=
 =?utf-8?B?SFU3VVV6ZFJvTGdLZmw4RjlxM3RERGphMFZoczBONFo0TU9tK2FaaDA3dmRq?=
 =?utf-8?B?VENmUnpVckZGZ1hXRk4zRXBWaHZzeHA1WmRtV3BHVm5OQ0lTMEdlWVprdkVX?=
 =?utf-8?B?RGpTRmpOOWVRS21CV3BzdEYwTitrWDY1SkpCQTc5Tm1vYzlSd3dVbHNTeEJl?=
 =?utf-8?B?NXJTN0hPQXRVemh0eFRsUHNoZHN3VlkxbWJxRWhtK1d5TS81NW83T0RXY3ha?=
 =?utf-8?B?M0RQMXk1RzdJbENBcjd6NXFmNW1hNmZsL3M1Y1BOZ1VGMGg1T05oS1BWUXE5?=
 =?utf-8?B?Y21nUU1sSG5UZ1ZCZFkyMFdyQ0ZIakhaZkJrTGhQT1ZKbWN4eWlaUndIK2dh?=
 =?utf-8?B?Lzl2emtic3B4MW43ekNHTStmZktvNHBGNXZkdnRKQ0wwbEY2ZkxvbXJXSGpV?=
 =?utf-8?Q?oybLxy9ve9wX0?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f7835a-3722-49cb-70b1-08d97474f228
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:27.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXqFjLORLLqbKaunVXWRrn8RAN0b/SXtVeCiHZcoXdQSQqhUvEFBSryrliFIszjhgsI/vQl485IiQeSsZaFYzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
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
