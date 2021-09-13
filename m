Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A09A408BF8
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbhIMNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:07:52 -0400
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:42816
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236017AbhIMNGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:06:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZW/ea27/fMLS2H65WcH8fFYXDsEkXFH/yEEn0VLjdMO7wQBn8RCi8jK/72XjsYWYa6CM75gVj2nmae8Ly7ISsela3oW5TirSiyRwZhia96OO3MsdQcmrhk+Ev4e8co5GHBSzR3/4VOgmsusyezbdD91HteCMgzSYB9vY2VJ8gHw0wdnlQAv4rkUKHiSBdvwmHd8jRceX9H3kKnskFY/fRGvNw7TkqZpfkI9YKQFM1GCgyWmVcp8s1EYnxyI6639ETmhgw0skhUI1IQLZYOZl4ZvrjIxtWm1cNgfRxoH+RBghFO7j/Ysw91pLfxuPwsKIEOY4ar6io/NOgcYd07BOhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=D/nDiHmFKBga19SVvGURvJf4nlMmkEyaiImUJbEKvFU=;
 b=GhjeLjIv4GyX/TJDDsWMl6u53eQvaKXCP7MS4RsgLIAEkCzrN5tnohjKs38aTt9r5s34CsjOXSr73zYyC20BJdq6wAe3kWl5c/XjIZFeY1aiXUpC8pH71qCOB9y6rDjz6LKTc4lsO10qklP85GJFkHMJXHY6Bv7kHUJaN9EWz0Ufi8AGv24pyuk/gYElyYJgYLx8TBTvRBxUoll/v6Rgx0+xHmoDRMFy8UVs+sgXy2BJrhFRIgNNJ+X6tgA+H9ADK3Z87B7HmnDZsWH+CbJELzHKBu8tCUoebdj1IUDbExr15YLVR3vARah25pVNh+Qsan2o7YVUjoTJScSXz2mvqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/nDiHmFKBga19SVvGURvJf4nlMmkEyaiImUJbEKvFU=;
 b=WZS0uHER3e8VMqOhTZwjord49kVxgUaitdBzAE+L8t9xTA8XcfKGpk0cJqJr498WkJW1lMNL+Ls3eHNlosmNSWp2jblBQcOqx3NpRF0RATuyYY5ehzmqyQEUSc6bt8olCg2FoSRxSipoXt+be2ZbZP4NbhbnMwqSHF8NMbdOoAs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:03:15 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:03:15 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 31/32] staging: wfx: indent functions arguments
Date:   Mon, 13 Sep 2021 15:02:02 +0200
Message-Id: <20210913130203.1903622-32-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:03:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa716e16-c369-407e-d405-08d976b6d987
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502FFDACA3609CE7C9A1D3393D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:378;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GIJ5NXI1NcUNBv0xQtMX6uUK2KE+NCsfx94HuRc5DNlcrY2fPE9v2pWRFW7QIO4MkTdaHAremP67Zpx/EsQlkU3NdpAA9Yt89UGFqqHUCIgKI9wAyLmyL0Gj/MKfAi0mgXTp82/4FVyiUeDStZqMSJLIQwkVEr0ncz7CiOvb+e7EaHZo/WuJXoYvVNbcTtO7eX3Hl2iefKrUv5SpQSwdZAGi4wHMq7dqIFS2gfDle+NNZGc8ehiesrVWt2H25Jq0jQcWwBfTk3aBnfQQvsZcnP75/mJyHgQyXKgbNNY1hIqjwbgHnN+SBVtv2FRWs+iayhAf7e0YaXZuJdVeB9dcxp9GMR6EXLv4TgizN2IBWpn3cHj3wOfdBxhV2QNejhx9C+6KsBe75PQjjIA/p8zDWDVl2kgl/LN+B4rt10qIM04XKSOGZ8cgpD3fEb0slYM166D9npq+s9YWujyplz866sMEXstM45rPcggu1oX90G9LvkgWMwLOBVJsI2TJfRHEoAHKcCcC+kk8OBo5Mr6om9QVvHFZNYLQ6p3+p5Sw1392fCaEajHfU3kcJuLCXBeP3JV7G+bL5jKWpuYzdsYd+gr9czRCDsmZRXLlNn3Z8xUpTas+cNFuW9oNE7xIw9ILuB5LyXYi5ONv89Lwk18xlJ1xaO6UCxF4zm9mOgIZMpZPrCEjq7cZQKEDIvOeplSkOJIdX7uPEQaqL/Ch9WjAeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3BWMjR4TFphdk1PODNFTFVRWmJOeHRWaG92TXk3Rlpac2NMeWlsejJGRkNt?=
 =?utf-8?B?MVJtcmJ4bFU5ODFuSnZWeTZ1Z21OcUduUW9pT256bWtkWnpuWTdyS2pSSDFV?=
 =?utf-8?B?WmxqS1VRQ3kxZmtBVWl5S1YyM3hFNDdSY0dyaHR0RXFNTVhYOGJMTENNd1F4?=
 =?utf-8?B?UGRscFJ3UW1QcHUwWmZDZzFFdGFVNG1rcmlVZEhXNFJEMUpPSHhGcFNYZHJv?=
 =?utf-8?B?STNjNU9zSUZOc0ZHUzkrSzhkWlp3QTVHNmdlUW5MQWtZWGNuZkdhOE5JdDZN?=
 =?utf-8?B?L1AvaUVxWm8rQmtGRlhMS2NQTVRTbU5zNkRRMVlaSWdLZjI0eWFwaHhkbW93?=
 =?utf-8?B?WHcwYzRBRzIzbkYzNzJtVWNVTFFEODVDQWVrOStiZlFvQWJ3UzM4RU1rNG1R?=
 =?utf-8?B?MmVOZ2EyNGFjSExRdEhuYWdDQkdOeW5aQ2tJbStIZlJCb0J5OUxmWEMyZUx3?=
 =?utf-8?B?MVlUL004d0ROMTY4ZE9nYUtZdWZNTzhoeTVZZzRYYjNsVS9tVHhUOFZCTnQ0?=
 =?utf-8?B?MGNPRUZTY2RhcHpnSFkzalhSYStIelZiMVo2NkE0WHRjTVdrT2d4c00xOUJU?=
 =?utf-8?B?WFNNTG15M05QSE9OaW5WR3ZmYlh6VlpicnAwUDd1VTltOHd4MS93THlsSGI1?=
 =?utf-8?B?Rkk5aG12Ym82MmdJSkpIYThYWHpoM1NHNkIveDlMaGk1dHl4dDl6NU1BTWJp?=
 =?utf-8?B?V1pjTUhEQ1NLQ2hEMjh5Z21jKzdCc0tCeVgyQmpGb1ZvUTNFcTZUcXFUbDRS?=
 =?utf-8?B?bVVyRnh4bGtLL2hBRUZKNFNTaE9NQ0VBNnk1Ujc3Z2swTGl2S1R3VFM1cTZS?=
 =?utf-8?B?N0NzcVBWekI4ZnFBb0ljOVEzSVpBeUVDclFGSG9Rb2ZDRFZlNUxHdzFPNDhB?=
 =?utf-8?B?bDIrK2tSbTZuMm5CZVJnanlPdSsxd1Q3aURXVFRiam81TmllZkhVbzNPc0VZ?=
 =?utf-8?B?VXFxTmcycVRUOWVEU214VzFxU0dqVXVKUUlRT1VBbmpiVWNES21oVG1Ocit2?=
 =?utf-8?B?eS9aaml3cGNPQ1B1Q29BODNXRUdaSGcxUFk3YktsT1YzQ3RtdzBTSDE2ODRW?=
 =?utf-8?B?VlNrVnJpSWxZbE1oMElyc0JONWF4cmNNSE9KSW11QzNZbGNXYjAwVUhvZlEx?=
 =?utf-8?B?RVRJMlRVSWs4Rk1LQjJYLzVmWHVtejhDWkx3M25kWUY3NlBNK25sclFXcDRz?=
 =?utf-8?B?SHlaTGxwS2o3NUtmZGk4dEROcENHQVpJWEx1dEJCbUszVVRxQjQ0bEs3SEh2?=
 =?utf-8?B?YmdSZGJXR0hGRXY2T0gvU2Z4MXduYXlEK0hqY0hGUjd6OTU2b2V6ZStGdlhY?=
 =?utf-8?B?UDJjRFd4TjFPV1BaQ3N4MGF4bjZaZzRqeU8vanRiUFA0dmw2b1VtVW5tR1JK?=
 =?utf-8?B?Tm5DVmtxV3F3MUNIZ0FkRjJxQVI3emM5VktsMFRnVE1Odkg2aTBEd2Q0RUU3?=
 =?utf-8?B?ckVldkttQklPNlU2SGFhWjdVR2hJMVNoZkFLMjRERDZKTXhPUStxTFFiVlVD?=
 =?utf-8?B?aURaTGxtZWhIdFVSY3lHSWErZGVnY2RsWXloeVpwTzZadTJzQlh5dkhkUHJX?=
 =?utf-8?B?eHJxOTRHV3o1T1E2SGx3QzZDQXVpaTU2STdyVjVKcVJOT25rRFBzRDI1aU15?=
 =?utf-8?B?MzJPeDVEOFFNWUY4UWRrNXNnVVNzUjNVYUcrblFEeUxCazlzK0FNem5OeHZR?=
 =?utf-8?B?TkR3SkFOWUc2QnNJVlVEYjd4dThWWkdKak0zaHE5Q25EY2R5RDJjaFFtdmho?=
 =?utf-8?Q?HL90CbWKYP4sBvluAz+6isiPtb9r7SM1zHDUcix?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa716e16-c369-407e-d405-08d976b6d987
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:03:15.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2GAGUZVKOTtvVrbX1vXpfa1O2ph+B7iVb/HTVliHdRCFH8wpwghTMAYwT4OP/csxogDxgCStGawQRYa7FBUFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRnVu
Y3Rpb24gYXJndW1lbnRzIG11c3QgYmUgYWxpZ25lZCB3aXRoIGZpcnN0IGFyZ3VtZW50LiBBcHBs
eSB0aGF0CnJ1bGUuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMg
fCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYyAgICAgICAgfCAyNiArKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxNCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
YyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jCmluZGV4IDQ1ZTUzMWQ5OTZiZC4u
OTdlOTYxZTZiY2Y2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYwpAQCAtNzUsNyArNzUsNyBA
QCBpbnQgaGlmX2dldF9jb3VudGVyc190YWJsZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZp
Zl9pZCwKIAl9IGVsc2UgewogCQlyZXR1cm4gaGlmX3JlYWRfbWliKHdkZXYsIHZpZl9pZCwKIAkJ
CQkgICAgSElGX01JQl9JRF9FWFRFTkRFRF9DT1VOVEVSU19UQUJMRSwgYXJnLAotCQkJCXNpemVv
ZihzdHJ1Y3QgaGlmX21pYl9leHRlbmRlZF9jb3VudF90YWJsZSkpOworCQkJCSAgICBzaXplb2Yo
c3RydWN0IGhpZl9taWJfZXh0ZW5kZWRfY291bnRfdGFibGUpKTsKIAl9CiB9CiAKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93Zngva2V5LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5j
CmluZGV4IDUxYTUyODEwMjAxNi4uNjUxMzRhMTc0NjgzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2tleS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngva2V5LmMKQEAgLTMxLDcg
KzMxLDcgQEAgc3RhdGljIHZvaWQgd2Z4X2ZyZWVfa2V5KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBp
bnQgaWR4KQogfQogCiBzdGF0aWMgdTggZmlsbF93ZXBfcGFpcihzdHJ1Y3QgaGlmX3dlcF9wYWly
d2lzZV9rZXkgKm1zZywKLQkJCSAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1
OCAqcGVlcl9hZGRyKQorCQkJc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVl
cl9hZGRyKQogewogCVdBUk4oa2V5LT5rZXlsZW4gPiBzaXplb2YobXNnLT5rZXlfZGF0YSksICJp
bmNvbnNpc3RlbnQgZGF0YSIpOwogCW1zZy0+a2V5X2xlbmd0aCA9IGtleS0+a2V5bGVuOwpAQCAt
NDEsNyArNDEsNyBAQCBzdGF0aWMgdTggZmlsbF93ZXBfcGFpcihzdHJ1Y3QgaGlmX3dlcF9wYWly
d2lzZV9rZXkgKm1zZywKIH0KIAogc3RhdGljIHU4IGZpbGxfd2VwX2dyb3VwKHN0cnVjdCBoaWZf
d2VwX2dyb3VwX2tleSAqbXNnLAotCQkJICAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAq
a2V5KQorCQkJIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSkKIHsKIAlXQVJOKGtleS0+
a2V5bGVuID4gc2l6ZW9mKG1zZy0+a2V5X2RhdGEpLCAiaW5jb25zaXN0ZW50IGRhdGEiKTsKIAlt
c2ctPmtleV9pZCA9IGtleS0+a2V5aWR4OwpAQCAtNTEsNyArNTEsNyBAQCBzdGF0aWMgdTggZmls
bF93ZXBfZ3JvdXAoc3RydWN0IGhpZl93ZXBfZ3JvdXBfa2V5ICptc2csCiB9CiAKIHN0YXRpYyB1
OCBmaWxsX3RraXBfcGFpcihzdHJ1Y3QgaGlmX3RraXBfcGFpcndpc2Vfa2V5ICptc2csCi0JCQkg
ICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpwZWVyX2FkZHIpCisJCQkg
c3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVlcl9hZGRyKQogewogCXU4ICpr
ZXlidWYgPSBrZXktPmtleTsKIApAQCAtNjgsOSArNjgsOSBAQCBzdGF0aWMgdTggZmlsbF90a2lw
X3BhaXIoc3RydWN0IGhpZl90a2lwX3BhaXJ3aXNlX2tleSAqbXNnLAogfQogCiBzdGF0aWMgdTgg
ZmlsbF90a2lwX2dyb3VwKHN0cnVjdCBoaWZfdGtpcF9ncm91cF9rZXkgKm1zZywKLQkJCSAgICAg
ICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksCi0JCQkgICAgICAgc3RydWN0IGllZWU4
MDIxMV9rZXlfc2VxICpzZXEsCi0JCQkgICAgICAgZW51bSBubDgwMjExX2lmdHlwZSBpZnR5cGUp
CisJCQkgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwKKwkJCSAgc3RydWN0IGllZWU4
MDIxMV9rZXlfc2VxICpzZXEsCisJCQkgIGVudW0gbmw4MDIxMV9pZnR5cGUgaWZ0eXBlKQogewog
CXU4ICprZXlidWYgPSBrZXktPmtleTsKIApAQCAtOTMsNyArOTMsNyBAQCBzdGF0aWMgdTggZmls
bF90a2lwX2dyb3VwKHN0cnVjdCBoaWZfdGtpcF9ncm91cF9rZXkgKm1zZywKIH0KIAogc3RhdGlj
IHU4IGZpbGxfY2NtcF9wYWlyKHN0cnVjdCBoaWZfYWVzX3BhaXJ3aXNlX2tleSAqbXNnLAotCQkJ
ICAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVlcl9hZGRyKQorCQkJ
IHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwgdTggKnBlZXJfYWRkcikKIHsKIAlXQVJO
KGtleS0+a2V5bGVuICE9IHNpemVvZihtc2ctPmFlc19rZXlfZGF0YSksICJpbmNvbnNpc3RlbnQg
ZGF0YSIpOwogCWV0aGVyX2FkZHJfY29weShtc2ctPnBlZXJfYWRkcmVzcywgcGVlcl9hZGRyKTsK
QEAgLTEwMiw4ICsxMDIsOCBAQCBzdGF0aWMgdTggZmlsbF9jY21wX3BhaXIoc3RydWN0IGhpZl9h
ZXNfcGFpcndpc2Vfa2V5ICptc2csCiB9CiAKIHN0YXRpYyB1OCBmaWxsX2NjbXBfZ3JvdXAoc3Ry
dWN0IGhpZl9hZXNfZ3JvdXBfa2V5ICptc2csCi0JCQkgICAgICAgc3RydWN0IGllZWU4MDIxMV9r
ZXlfY29uZiAqa2V5LAotCQkJICAgICAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X3NlcSAqc2VxKQor
CQkJICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksCisJCQkgIHN0cnVjdCBpZWVlODAy
MTFfa2V5X3NlcSAqc2VxKQogewogCVdBUk4oa2V5LT5rZXlsZW4gIT0gc2l6ZW9mKG1zZy0+YWVz
X2tleV9kYXRhKSwgImluY29uc2lzdGVudCBkYXRhIik7CiAJbWVtY3B5KG1zZy0+YWVzX2tleV9k
YXRhLCBrZXktPmtleSwga2V5LT5rZXlsZW4pOwpAQCAtMTE0LDcgKzExNCw3IEBAIHN0YXRpYyB1
OCBmaWxsX2NjbXBfZ3JvdXAoc3RydWN0IGhpZl9hZXNfZ3JvdXBfa2V5ICptc2csCiB9CiAKIHN0
YXRpYyB1OCBmaWxsX3NtczRfcGFpcihzdHJ1Y3QgaGlmX3dhcGlfcGFpcndpc2Vfa2V5ICptc2cs
Ci0JCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpwZWVyX2FkZHIp
CisJCQkgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVlcl9hZGRyKQogewog
CXU4ICprZXlidWYgPSBrZXktPmtleTsKIApAQCAtMTI5LDcgKzEyOSw3IEBAIHN0YXRpYyB1OCBm
aWxsX3NtczRfcGFpcihzdHJ1Y3QgaGlmX3dhcGlfcGFpcndpc2Vfa2V5ICptc2csCiB9CiAKIHN0
YXRpYyB1OCBmaWxsX3NtczRfZ3JvdXAoc3RydWN0IGhpZl93YXBpX2dyb3VwX2tleSAqbXNnLAot
CQkJICAgICAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSkKKwkJCSAgc3RydWN0IGll
ZWU4MDIxMV9rZXlfY29uZiAqa2V5KQogewogCXU4ICprZXlidWYgPSBrZXktPmtleTsKIApAQCAt
MTQzLDggKzE0Myw4IEBAIHN0YXRpYyB1OCBmaWxsX3NtczRfZ3JvdXAoc3RydWN0IGhpZl93YXBp
X2dyb3VwX2tleSAqbXNnLAogfQogCiBzdGF0aWMgdTggZmlsbF9hZXNfY21hY19ncm91cChzdHJ1
Y3QgaGlmX2lndGtfZ3JvdXBfa2V5ICptc2csCi0JCQkJICAgc3RydWN0IGllZWU4MDIxMV9rZXlf
Y29uZiAqa2V5LAotCQkJCSAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X3NlcSAqc2VxKQorCQkJICAg
ICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LAorCQkJICAgICAgc3RydWN0IGllZWU4
MDIxMV9rZXlfc2VxICpzZXEpCiB7CiAJV0FSTihrZXktPmtleWxlbiAhPSBzaXplb2YobXNnLT5p
Z3RrX2tleV9kYXRhKSwgImluY29uc2lzdGVudCBkYXRhIik7CiAJbWVtY3B5KG1zZy0+aWd0a19r
ZXlfZGF0YSwga2V5LT5rZXksIGtleS0+a2V5bGVuKTsKLS0gCjIuMzMuMAoK
