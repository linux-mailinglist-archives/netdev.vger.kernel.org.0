Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76ECF408BEE
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240403AbhIMNHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:07:20 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:64256
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240226AbhIMNF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:05:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOgB/WT6RiWKWRI/68IKKsLeachQcfJ+dpQ7QkBxudU1vbaZKTUVJ7R3md2pNGgRJ2O9jR2C6mHf6V97/EtTmr/BY/6MXHbtI36lgQlYQYc5+qqXtNLYjzbhXjr7h3kpsjJhazT5Vw/7wMrFyU6lG1ZSQiS6Q1owmSeqLlCudp4KpGIjn6rozznPPZHe1batLXZc9WD9gF8hJGHBiDLQK/+RtQTsuPsKWadoFSsohjHousuRszrswzoQL1DYHH/ImiOWpnyXDbhYuxeYOr392S62tl2wcxGzFl7ynF5eyzF+D3FQCOLACt+uTiQ0Xs2/qLdzRnm8jn5u6a8/y3aNqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6exHReMQZVm3Rqfp26e85943fuLvP90YScIDvmR1Gxs=;
 b=n2GlFvfGxDrk6CPHlp8FppPPsjYY7fAN3cCk6unJAqRIZZ4l+JdG3yoj9aJC1NONLK8N8c8kC3SOmDLEoobGqUhuKJxPRb38GIAKf5SsJfwJnKsYa4ZJYI7Y468t+y7ZNlL0TfjGL93pm9mMy9crZ+2wUG0ZsNp5zExSt1iX+BGXGfK8xxLYUVgdzD7CTQPoUla87s1374O1QupGnxmx1UoZ7n4UmhkUcqhJnMeLkpbNV7/qb4CA6U6FeQH9CuUNLcZL97P7CwR3ydxsw3FNEzjFfIgT0iJ1stAZxDPcdtYBkGnaY/rEgRcX6yWrukDEKiG7ARHst0PA3RMnqRaqMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6exHReMQZVm3Rqfp26e85943fuLvP90YScIDvmR1Gxs=;
 b=nRe2B8LPakd5mz0pemlJkEb5ZvXVpbk7cNyHqeloOaThpEyKeNgjEtgUL7yQcQZTLKY8yqyN9CCDQlYUfi2L3v4HTJrq/klGN4BhzsBd0Y86Hm7twbp7h/WBRkafeC5tDBl/RoSkUKqtycfCCjwNq8x5Zq3xMtYf2CB8tJxV7Wo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:03:10 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:03:10 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 28/32] staging: wfx: fix comments styles
Date:   Mon, 13 Sep 2021 15:01:59 +0200
Message-Id: <20210913130203.1903622-29-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:03:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc298e08-ec54-486b-4fa8-08d976b6d652
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502421B2AB44091329C229793D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+N2tt/OlauzLxD/yOF0ozI4MmHgdxEeSnjuld/U0ZocjGU3oeCN108dIGempSfNDuxMxBY45eBxSwP12BUKxXhiVFcLBMd2unfL2xMsk+lW54sAvEkBKMakatmgb2Cuiyp3MtKovUSiBXlUH8uIePgvC2awVANtZFrIVOtmUdel/iZgVp0EMzZX1wDNzKRQVge9SpUBRC5zbakaWiGziYfKMn4XcM9g+llY2TxGrOtYwbRVF8YSx006a0JSElIT1qoT/utI4EX6cGMsbwQMp5Lqpc2GWmkoHsAdypCBvjKKj3IKcQXucyksphHs9KHNfy/Hy/4S1uWXzHp71rN/hwJG9ZvKPD/yRF8Nmtk26l+Sd8oeqS36jVy7gXGTbYYmbLKGsuoab8/BT5s9wIVgch/KWvGUNJFIgiIhaGgiB3HY7TNyewsiG3V9qs6gMdHO1z34v/jlz5H+n/Id+8wsTu/qjCCATMGdE+0kOr9Rd1FaJTfgytH7ymfr/Kdn9vqiTpB1YrNH2qtGDmaR33duJEqEmgAkJ/tQ8CZrPn4V/7yWQAXkaiqp043Zq1Mt3W0wdSTPhDoEiZQcok6kymtVV9gaqwIpdILt3G9AWXR2uOFJTWIMzUGsJXhTHBPw8/CyzwPLK+2f/YzhhXvCkcZxB2I6yLwyKzZtFmfVURe46L3JMIoViFCBV5zsLAziPo8EzQ+6cFG/n8NkV5mOeJ7pHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(66574015)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDl4WHJENzlkUXdhREZxVlg4ZUVPU0xmZnRkK25tSkNjaDEvaHhvNmU0QTVU?=
 =?utf-8?B?Z3R3cmlXVnZMWTdxQ3hORGowb053M0tJcG5mU0F3eHplZHZJZGFlVCtEM1BK?=
 =?utf-8?B?U3d5THRnKzJFSVFkaFJ3dnJJbE5CaVRBc0pGNE9nZE1sdXlUL0xJWFNGZjYr?=
 =?utf-8?B?ZFVYdXJjSTM4MUg1NENBTzE5OFl4M3grZEswd2FBZE11ck0yU1F4VHdUWnQ5?=
 =?utf-8?B?VzhQN1N6WStyb1B1NnZCR1YzbjlIcUt0a2loVUZpTis3bUJaTVUrVzcyWEpI?=
 =?utf-8?B?MjdXeDFPY2NDN2pOQUZGR3RjVksybHJVTkVPZTM0RS9CTXoxanR4a0lHRG9Y?=
 =?utf-8?B?L2VLRENkalZMTmxQQVhWWXhnOTE4OGE2Vnp4YkxDZFU3bm02SHMrTDZOUTJJ?=
 =?utf-8?B?czVDTnpxdEZuaTkwUG1RK2NrcEY2bkJwVnFzTDVKNlZKaXdIZGIwbEt3bGFu?=
 =?utf-8?B?aGxKWWNJQjd4SGt3U1JJQnJybXVWVFR6dGprYVdGTWxDaGw4alllbEsxT09S?=
 =?utf-8?B?T3VOMXRTYWdQaktXL0llRU9teEsrUWtjbDNDeEw4Z1JvbFJHRHJIZVkvcmtY?=
 =?utf-8?B?UGlzb08vR1VYaGhyV3cxSWhRZnczZndVNERGQ0xZNUlKNUZJbXdLTkRQb0FW?=
 =?utf-8?B?cjFHQUFOc0NObmFLTG45eXI2MDluL1JLZDRiUXdWdmpxZzVpeTl1cUpsSmtX?=
 =?utf-8?B?Tkw1ODBMZlJxcEtmN2VyZ0cyODRiSnJJUmJGeHZhYWc1bjVFWk1nc1Y3Kzc0?=
 =?utf-8?B?T0VYL2Z6UUppeXNiVTF2U3ZteEJDOEFlK2JwNUR3TklrMXY3eGVKWWN6bVox?=
 =?utf-8?B?amZUU1BrRFNCN3RxaU01SmVlQkViZFhUZkxKWllCWVVVV1B1OVlSNWNCQWVF?=
 =?utf-8?B?aXpIeU9BZi90VWRZRVhSN0NaRkRwaGhFbnc3aHZUbXpISmtXQ2hBT2xXTnIz?=
 =?utf-8?B?T1VVSDJPelJ6V2lYM0ZIMkhQQ2hDL1cxMlZ5WmhmRVgvT0IrUHJnTUUwV1R2?=
 =?utf-8?B?bXdOYVhBcmIzVXhINlVITkxQVU9hZE5lZWN4QTdnYys0bFFBUjV1aEMvUzV3?=
 =?utf-8?B?dUNtV1ptb2E0WXlZaEZTejB0MGdFcUpsZmV4STNwakkrV2NQOWM0Nk5qMjRX?=
 =?utf-8?B?c1kzR3BtR3JiLzZOeW1kaG02NXRubUxLdkd3S2p3dUNMa3p0RWFGcnlzeEp4?=
 =?utf-8?B?U0JMdTNjQTdDcXVTaG5aWUF3V09NdDl0MkFnMEJnNHZkWEZqVnM1Ykg2bHFw?=
 =?utf-8?B?TnNjYUljR0dYRngvME1HT2hPQWpsSFJJOEtFaHlwZzhFelBrOFpRZ2IrSTFP?=
 =?utf-8?B?TDZvZWZpeGRmekFzU05LOW1UN2FrQ3ZiN1ZtSFplVEZVR01rejZ0dHZDamVv?=
 =?utf-8?B?TG92cXlCdURBVG1ETE1aRFg4YzFEcVpqVUgxNlA1MTFCQU9XZXZERVpZQWth?=
 =?utf-8?B?bVFNQW5PR3VsZGZKNHg1K1FnM3pSU3BObTM3WVlodTFXSzgrQzY0aThteWhN?=
 =?utf-8?B?VENvdzRQNlRNTk1TSmdHYzBhVWdOallLbnI4RUhyVSs3bldBY0UyeHJtQnhH?=
 =?utf-8?B?YWdjMklpMWpFUXg2K0t6eTBxK2JTdEMrZG1rb3NSQlBxdFN0UW5TbEN0WWhm?=
 =?utf-8?B?TER3TWRJYmU2TTlrc3ZUVGova0xoamIzdDV3VVkrd2tYR2toN3J6alhsVW1H?=
 =?utf-8?B?YWlGQnAzWnQ2VmFHR2o1N2I2Uk1qV2VTQ0xJY0hSSkVtNEUyNWZsMlFRSkJR?=
 =?utf-8?Q?Pw+2CEaEz43vou4Dy70FYos3iA/oB1FRGVvkqlZ?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc298e08-ec54-486b-4fa8-08d976b6d652
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:03:10.2829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UriL9I+oka6o2IzyqWKRFzsfpCYI3VAmpz0nFHT3aySlkS2lVOw2T7jH5nOOEZsmfw62hCA+W6Us2dguihNrbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW5p
ZnkgYWxsIGNvbW1lbnRzIG9mIHRoZSB3ZnggZHJpdmVyIHRvIHVzZSB0aGUgc2FtZSBjb21tZW50
IHN0eWxlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgIHwgMTEgKysr
LS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIHwgIDYgKystLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyAgICB8ICAzICstLQogZHJpdmVycy9zdGFnaW5nL3dmeC9t
YWluLmggICAgfCAgMyArLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jICAgIHwgIDMgKy0t
CiA1IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9i
aC5jCmluZGV4IGU5NTZiNWE1Y2NhYy4uYTBmOWQxYjUzMDE5IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2JoLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCkBAIC0yNjUs
OSArMjY1LDcgQEAgc3RhdGljIHZvaWQgYmhfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
CiAJCQl3ZGV2LT5oaWYudHhfYnVmZmVyc191c2VkLCByZWxlYXNlX2NoaXApOwogfQogCi0vKgot
ICogQW4gSVJRIGZyb20gY2hpcCBkaWQgb2NjdXIKLSAqLworLyogQW4gSVJRIGZyb20gY2hpcCBk
aWQgb2NjdXIgKi8KIHZvaWQgd2Z4X2JoX3JlcXVlc3Rfcngoc3RydWN0IHdmeF9kZXYgKndkZXYp
CiB7CiAJdTMyIGN1ciwgcHJldjsKQEAgLTI4NSwxNiArMjgzLDEzIEBAIHZvaWQgd2Z4X2JoX3Jl
cXVlc3Rfcngoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAJCQlwcmV2LCBjdXIpOwogfQogCi0vKgot
ICogRHJpdmVyIHdhbnQgdG8gc2VuZCBkYXRhCi0gKi8KKy8qIERyaXZlciB3YW50IHRvIHNlbmQg
ZGF0YSAqLwogdm9pZCB3ZnhfYmhfcmVxdWVzdF90eChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHsK
IAlxdWV1ZV93b3JrKHN5c3RlbV9oaWdocHJpX3dxLCAmd2Rldi0+aGlmLmJoKTsKIH0KIAotLyoK
LSAqIElmIElSUSBpcyBub3QgYXZhaWxhYmxlLCB0aGlzIGZ1bmN0aW9uIGFsbG93IHRvIG1hbnVh
bGx5IHBvbGwgdGhlIGNvbnRyb2wKKy8qIElmIElSUSBpcyBub3QgYXZhaWxhYmxlLCB0aGlzIGZ1
bmN0aW9uIGFsbG93IHRvIG1hbnVhbGx5IHBvbGwgdGhlIGNvbnRyb2wKICAqIHJlZ2lzdGVyIGFu
ZCBzaW11bGF0ZSBhbiBJUlEgYWhlbiBhbiBldmVudCBoYXBwZW5lZC4KICAqCiAgKiBOb3RlIHRo
YXQgdGhlIGRldmljZSBoYXMgYSBidWc6IElmIGFuIElSUSByYWlzZSB3aGlsZSBob3N0IHJlYWQg
Y29udHJvbApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYwppbmRleCA2MWY3M2IzZWJjODAuLjU1ZmZjZDdjNDJl
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9idXNfc3BpLmMKQEAgLTM4LDggKzM4LDcgQEAgc3RydWN0IHdmeF9zcGlf
cHJpdiB7CiAJYm9vbCBuZWVkX3N3YWI7CiB9OwogCi0vKgotICogVGhlIGNoaXAgcmVhZHMgMTZi
aXRzIG9mIGRhdGEgYXQgdGltZSBhbmQgcGxhY2UgdGhlbSBkaXJlY3RseSBpbnRvIChsaXR0bGUK
Ky8qIFRoZSBjaGlwIHJlYWRzIDE2Yml0cyBvZiBkYXRhIGF0IHRpbWUgYW5kIHBsYWNlIHRoZW0g
ZGlyZWN0bHkgaW50byAobGl0dGxlCiAgKiBlbmRpYW4pIENQVSByZWdpc3Rlci4gU28sIHRoZSBj
aGlwIGV4cGVjdHMgYnl0ZXMgb3JkZXIgdG8gYmUgIkIxIEIwIEIzIEIyIgogICogKHdoaWxlIExF
IGlzICJCMCBCMSBCMiBCMyIgYW5kIEJFIGlzICJCMyBCMiBCMSBCMCIpCiAgKgpAQCAtMjQxLDgg
KzI0MCw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NwaV9yZW1vdmUoc3RydWN0IHNwaV9kZXZpY2UgKmZ1
bmMpCiAJcmV0dXJuIDA7CiB9CiAKLS8qCi0gKiBGb3IgZHluYW1pYyBkcml2ZXIgYmluZGluZywg
a2VybmVsIGRvZXMgbm90IHVzZSBPRiB0byBtYXRjaCBkcml2ZXIuIEl0IG9ubHkKKy8qIEZvciBk
eW5hbWljIGRyaXZlciBiaW5kaW5nLCBrZXJuZWwgZG9lcyBub3QgdXNlIE9GIHRvIG1hdGNoIGRy
aXZlci4gSXQgb25seQogICogdXNlIG1vZGFsaWFzIGFuZCBtb2RhbGlhcyBpcyBhIGNvcHkgb2Yg
J2NvbXBhdGlibGUnIERUIG5vZGUgd2l0aCB2ZW5kb3IKICAqIHN0cmlwcGVkLgogICovCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
Zndpby5jCmluZGV4IGM1YmEwYTUwYjQ3NC4uOThhOTM5MWIyYmVlIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYwpA
QCAtNjksOCArNjksNyBAQCBzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IGZ3aW9fZXJyb3JzW10g
PSB7CiAJW0VSUl9NQUNfS0VZXSA9ICJNQUMga2V5IG5vdCBpbml0aWFsaXplZCIsCiB9OwogCi0v
KgotICogcmVxdWVzdF9maXJtd2FyZSgpIGFsbG9jYXRlIGRhdGEgdXNpbmcgdm1hbGxvYygpLiBJ
dCBpcyBub3QgY29tcGF0aWJsZSB3aXRoCisvKiByZXF1ZXN0X2Zpcm13YXJlKCkgYWxsb2NhdGUg
ZGF0YSB1c2luZyB2bWFsbG9jKCkuIEl0IGlzIG5vdCBjb21wYXRpYmxlIHdpdGgKICAqIHVuZGVy
bHlpbmcgaGFyZHdhcmUgdGhhdCB1c2UgRE1BLiBGdW5jdGlvbiBiZWxvdyBkZXRlY3QgdGhpcyBj
YXNlIGFuZAogICogYWxsb2NhdGUgYSBib3VuY2UgYnVmZmVyIGlmIG5lY2Vzc2FyeS4KICAqCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uaCBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5oCmluZGV4IGEwZGIzMjIzODNhMy4uMTE1YWJkMmQ0Mzc4IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4u
aApAQCAtMjMsOCArMjMsNyBAQCBzdHJ1Y3Qgd2Z4X3BsYXRmb3JtX2RhdGEgewogCWNvbnN0IGNo
YXIgKmZpbGVfZnc7CiAJY29uc3QgY2hhciAqZmlsZV9wZHM7CiAJc3RydWN0IGdwaW9fZGVzYyAq
Z3Bpb193YWtldXA7Ci0JLyoKLQkgKiBpZiB0cnVlIEhJRiBEX291dCBpcyBzYW1wbGVkIG9uIHRo
ZSByaXNpbmcgZWRnZSBvZiB0aGUgY2xvY2sKKwkvKiBpZiB0cnVlIEhJRiBEX291dCBpcyBzYW1w
bGVkIG9uIHRoZSByaXNpbmcgZWRnZSBvZiB0aGUgY2xvY2sKIAkgKiAoaW50ZW5kZWQgdG8gYmUg
dXNlZCBpbiA1ME1oeiBTRElPKQogCSAqLwogCWJvb2wgdXNlX3Jpc2luZ19jbGs7CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5jCmluZGV4IDllMmQwODMxN2M5ZS4uNjY4ZWYyYzYwODM3IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAt
ODUsOCArODUsNyBAQCBzdGF0aWMgaW50IHNlbmRfc2Nhbl9yZXEoc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAJcmV0dXJuIHJldDsKIH0KIAotLyoKLSAqIEl0IGlzIG5vdCByZWFsbHkgbmVjZXNzYXJ5
IHRvIHJ1biBzY2FuIHJlcXVlc3QgYXN5bmNocm9ub3VzbHkuIEhvd2V2ZXIsCisvKiBJdCBpcyBu
b3QgcmVhbGx5IG5lY2Vzc2FyeSB0byBydW4gc2NhbiByZXF1ZXN0IGFzeW5jaHJvbm91c2x5LiBI
b3dldmVyLAogICogdGhlcmUgaXMgYSBidWcgaW4gIml3IHNjYW4iIHdoZW4gaWVlZTgwMjExX3Nj
YW5fY29tcGxldGVkKCkgaXMgY2FsbGVkIGJlZm9yZQogICogd2Z4X2h3X3NjYW4oKSByZXR1cm4K
ICAqLwotLSAKMi4zMy4wCgo=
