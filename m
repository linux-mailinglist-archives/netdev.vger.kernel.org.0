Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3494408BAE
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbhIMNFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:05:10 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:38187
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240108AbhIMNEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0Si6+4a6mM7Yd3zzLyJI/2uu4vv3lYHxF2MVjsq/2gURgCimejvzTI96jl/aF1LqXAt2qSfcxvI2lyuKfthxj7stZLGB24yuQ3aGw3Mm58V3pg24tilKvHOeiy8yjbDFszd5sf59f/2ZmFQrEFJN0bUvxyZ/gxs9B8JgeUpkMHz7+UjMzvrPepna+3vKaFxdzKwlrwU3TTSeAATOp6Rex79cb7idOS6Yg1Nai7KKXWDAv0zMhE93lBTHRWkbK/ewAYiYD9ev9n0RZtieMlSfKnAVuFtt2LeSMH7VxseHrR8kMbHB6YWwaVKxZ4Ehn6PopGRJzjBcL2svK2J0bfftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rtRjvSlyXDToLuWg9t+Q5N9m2nkpKJd5T4sJtezrxTw=;
 b=VkxZwqTyjpKxHt5JmHRhMDewk2DHGQ36RUpU8B/tUyt7vd6SnA/dVKTvSnhJ5iwUc+vsZzMNO7R2+Bls6pSawBGiZDpv4DXMg4Y9UZ1lhGDY4d/2Sv6k+x2y/4ZZF54dqbyH9uHy6G85pQvK4ZGPwb/bd5ScV02T3ARIj0Yf9418jB+Ss/6a/k0Ue/H4oUSCjCiYPgz0TnodjYTYcEoiu34K7qDRrHPWE4ebGXSliJJry5xkXVBJcQzJ7okoyOZ/TjEWNylZdJRhorhWddqbTysVaYpSpo3lAM+E4enJ7AY73h/enbF0ETSI4+MaP/0lm6gpU07Q562W2Bhag0wvzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtRjvSlyXDToLuWg9t+Q5N9m2nkpKJd5T4sJtezrxTw=;
 b=nIfIRXXlE1YYFMGifHGGBypENxnqwFhHaNe01iNq6E7KtKaleiF+iFk4OwD9DVm27rO/qjKKQqdnhsa+Yk/bZurPGPPifHChvo5akfs99OJXtHqaX98dug2o6wJc8kAvHxa7A8utF5fD80FP7aj00Gwz9wI/5HM6lRBbBzRiwz4=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:03:01 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:03:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 23/32] staging: wfx: fix space after cast operator
Date:   Mon, 13 Sep 2021 15:01:54 +0200
Message-Id: <20210913130203.1903622-24-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba01d1eb-d0eb-41e8-9c9d-08d976b6d0ac
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502C4B852E528872B686AA393D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QqAEuXNXZ22scLiIX72B5cChYNCNx8rJHIUQWYhfBmsToL4tMSejhWtAHilFeiaNRXDDPz98NzVmHkFYyd+xdDdOKMUSzua4BxszgoMg4fIsRMjzKE71KSCCzHA12K9RtaXL7LVK235z/Q25NfV1rRQIInLRBRHn58WQWd/lI3b3qa7S0LhVyPNJ3jfWqnz6mshYep0DRBpZD/4MFi9mXU2VGVttt4I9RjSbaKleBY+D2CGvlijqeMMrulMnO/8y1pMVuccKP+J+rAH4cT2RkWOJqy3lTYCHSoeqYC4uevm9VYJuiOQTAUaby5nIetZWz2BHu7RU9ieK3vfu4ziHSy7/auw0WHJAj7GyGxPyn1YIA6Wrwmu22wWRHWWCSpMsTaihJvlgDENSHQvamyhVai70I8ypRXkD5dDkqBKhf/JtiH4TXmu6zlGseHg+Y9DTH7rfnXhR0B20oQo5F088jk73HQ/Up6tJsNsspr70e8APJaRhLvYkFF+d3CqIsVQUmzzzlRl29LZIYoqIaMku8OGWM1KUm2YUCev7En1L3KdOy8BYItKZ0yNOqxJY0B3svSUisBIOo4oZKOg8fstshU2+OLA3+CE7zTC4B37wIQ4igXa2z/wa1votVo/mMNcZvRSw0CdT3dYq7p6PPnDRS306zQGiVB01a1iwqCmzUorUvJsouht+03S68w0hl1I/IHt42t7Clf8Ws3cmnnHENQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(4744005)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(66574015)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE1XeEE0NkN3RkRiWUpZclVIb1RXK3BmeHBVYWFETVpWSHJPY3ZiWWNTelFM?=
 =?utf-8?B?aWpTS0hyYTBpQ2lETkdzY2YrNHRibklPM1NqVUhSbjFLNjQvc1pKT1NEdWc2?=
 =?utf-8?B?d3ovLzh1U0JVSTRMa2NydnVQM1FRQk1sak1YNEo2RWNsQU0zdWIrN1M1NDFK?=
 =?utf-8?B?V3NaRTRJZHpOVzVWYjJNNmk5VVNVaWtyL0FlU3lOSmlZZkw0U2M5YWR6b3Nn?=
 =?utf-8?B?Z094d2tpMW1PcUl0UE9Ia0VpUnVaNmRhNkRlK0VWUkMxcFRLOHNCQmNYY0tS?=
 =?utf-8?B?QWpBd2E5WDdPKzlScVZaSDJLNDh6a2NDWjZGZlhpL1FWd2tyb2JMNm0wQnYy?=
 =?utf-8?B?RUhNaEhIWnpvamNBQjMxb1pIY05PZFVIN2l2UHFkajdtNE9uNDlreWVROUJZ?=
 =?utf-8?B?Tlh3cHppSi92dUplU0prd3JQWDNxblNjUW43RE5MT1Q0MWI3QnZKMzFlN25k?=
 =?utf-8?B?MDJvalBmdWRrSTVEZlo0b0ZCMWMxOUNiK0F5cWU5YUVCbEhsQmxmZ1EveXlo?=
 =?utf-8?B?WUFpbXBSdzdCVkIzSlZnOEsxbktFQjNUN1BvMDlURmhUTjk1azAwWVNXYlBY?=
 =?utf-8?B?NVV6eEk4K1RXSTV4UW1UUGVRYnFicjNqY0ZmUDJaSEh1SWNhbjJhWVkvNk1F?=
 =?utf-8?B?aE1yN0RGdWcycnlTa2lRbUh3WjhnWmdPeHhLVzNKekxKSlhUdmJPbU1laWk1?=
 =?utf-8?B?QWJFbnRkQkJweG13VyszRlBsV0UzWXJkNzBUVmMrRUptSnZhbjRlaU56T3k0?=
 =?utf-8?B?VlQ3bk9FRDhoTnlsc0IwWENQVnpQRmJSc0l3WVNEdEs4ZnN6YlNkbmhqM0lS?=
 =?utf-8?B?NXNodFl3K0pRRi81dytERnd5YmgvWXVyVWRaUk13NlJNb24rWTF0azRwajNq?=
 =?utf-8?B?YmxkUitCcW96NGtiYm95TGwwV1FJWjZWS0taR0VzaG9DNlZTbkxNZVZ2TDlR?=
 =?utf-8?B?R20zLzhoU3lSQjZJOEFhZThIRUlEYSsrVDRKUVFtdkNnSUNpa1F3ZG5Fd3JC?=
 =?utf-8?B?UTNBM2lLYk9aTmhvelZuaS9EWW4xSVd4T2pvWmpWMXVSUVlCK3BINjF0U1RH?=
 =?utf-8?B?VHNyM0Voa1RidFFLWHZPQjNERC82dTBkZG9QZXUvNEtrYi9EalZ0NWVYU0RD?=
 =?utf-8?B?V2t0VkthZnJFMGExcVJUeVNoMjA5RjZzRmdoakE3K0UvTlZPZHlxT1A4UURY?=
 =?utf-8?B?R2VkMVBhVEpadG1GOGhMMWJabXBwWEJHL1luRFNTQmxYRktXQU41SEp0cTlH?=
 =?utf-8?B?Q09QQ2NjVVRseXNJeHpuMnprazVQd2VaNENxUVNCa0pBamx4bGF4c0ZabFZo?=
 =?utf-8?B?TmdadWlYUzJwTWV0UHY4czZCLzI0OWFLeFBuZ2dCSFRiS0s1dmsxQ3BrWHp6?=
 =?utf-8?B?cmpvZXkyS2N2THFscDhXYmoxd25HODZLN3pDcXBsY0YzR3FVWnJtcjRLbG9K?=
 =?utf-8?B?RVNJS2tZRFpERVl5cnloK2g1eHZ4SzgvbkNSc0taSFlWOTR6cFozTnNHZWs3?=
 =?utf-8?B?Vld1ZG84LzFOSUpzR3dKN0REYjBscStvQ0hWZWtFdk80ajdIcldiZlFvbE1H?=
 =?utf-8?B?eW9EdWZSUFh4elMxVjVHV2pCcnU4SGozRVhrbmxEcDk5L0hZS3pYQzZDbEx5?=
 =?utf-8?B?VHpGeEFhMEM1U2JBcFhoVjA2a0FpRWxhM0t1bmw3SDZqcTFsbGlsL01kRVpt?=
 =?utf-8?B?YTBMcnhxSWE2c0preXpiQ2FHenMybGdqL3pydGROdEpVQXBDWkNtTVpQREtt?=
 =?utf-8?Q?ImgBQac+mroOSVIFftfEpY8iiYgoglwGwj/jtfG?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba01d1eb-d0eb-41e8-9c9d-08d976b6d0ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:03:00.9802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfFZryMMUkucnRWmP4RF9coKNsEO94mVj5PeWrFkBEO5fkhQQa6cZpA2eoWeWZfMD149jIK2uCLSHjH3DuY+WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKY2hl
Y2twYXRjaC5wbCByZXBvcnRzIHRoYXQgY2FzdCBvcGVyYXRvcnMgc2hvdWxkIG5vdCBiZWVuIGZv
bGxvd2VkIGJ5IGEKc3BhY2UuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCB8
IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oCmluZGV4IGE4ZWZhMjVhMzhhYy4uOTc0OTYwMmY2Y2RjIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAg
LTEwMSw3ICsxMDEsNyBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCB3ZnhfdmlmICp3ZGV2X3RvX3d2
aWYoc3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQpCiAJdmlmX2lkID0gYXJyYXlfaW5k
ZXhfbm9zcGVjKHZpZl9pZCwgQVJSQVlfU0laRSh3ZGV2LT52aWYpKTsKIAlpZiAoIXdkZXYtPnZp
Zlt2aWZfaWRdKQogCQlyZXR1cm4gTlVMTDsKLQlyZXR1cm4gKHN0cnVjdCB3ZnhfdmlmICopIHdk
ZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKKwlyZXR1cm4gKHN0cnVjdCB3ZnhfdmlmICopd2Rl
di0+dmlmW3ZpZl9pZF0tPmRydl9wcml2OwogfQogCiBzdGF0aWMgaW5saW5lIHN0cnVjdCB3Znhf
dmlmICp3dmlmX2l0ZXJhdGUoc3RydWN0IHdmeF9kZXYgKndkZXYsCi0tIAoyLjMzLjAKCg==
