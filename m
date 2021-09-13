Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCB34086CD
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbhIMIes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:34:48 -0400
Received: from mail-mw2nam08on2066.outbound.protection.outlook.com ([40.107.101.66]:47168
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238397AbhIMIeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DG/aQ5+O9qiVQSUG0eVHd80AWEwQcQmsBQuihWgmNUNgc4BnLGeETuOzuGR4oBbxWtvKJWHQvzr9DWsi7ZvbcEcT0Ilh0RoRhUb/lTsNPEWdhzqnOIGhLTUUQHqcO2Ek2mgwwBwrbDIi93rASOcPEK0w1yPqDKQ6NTqWwWlf40y+072glw8UJk3s1MJCuTs6Xm52aUwzsppS7X/G8qrPYctT2fClyHvVvybfM0WjFf6utCMmRTntSrvhpLhxfLK4HaCJSrTbzQY2tPPARkz3pzDd1Eo9Jrzz6eCUBO7bGlZBXacDKpXy7zlnu9yR0RDYHkR6ZjrkzNXVWZWAIaBMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ji/Ro3T4EFvudESNOp7gumDhL+e49DGbfmq68yR81Dw=;
 b=UDklZ8c/tIvhfwDyd9TF2fqiDaiE/kJf82YKyWbTdzfSeP1dEEWn3/GIZOi2YO3uyXNyOg9IKM1949Q2tcbOSgEF6THUSWGG4axVCZMZ/vxnFTSaQfxeeG/ZxIUYtF37pisFbjKyIb3rpC563dPdGyQRgMeGfSY7Q0OmHqnBg+tEZZcCc055vZjy7Qa4X/wzFIuzpkkrJTLPGqeHCNCVVY096v/WHy5wWiCu2L7xbL8K60lxxigzOYkZ0MO/jFKQ4/sTR+kNUdvGRh9Z++9O9HZ8/YilKUHTiTA9vhjCdF+VReVFnbeCY5w0muyAbjigu+v+/H62ktk8DTUZjJaytQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ji/Ro3T4EFvudESNOp7gumDhL+e49DGbfmq68yR81Dw=;
 b=HBuTO+92LuEp3M88ST0OeIy++Mnfr/64b6vVY8KPE7uOs4k8oA8oeDxLWrSoV+5N2oqux8ptPtcMbQ3FIE/TPi4ncgVz9H9L8F57rHX6JOkAAuTyt/cvFlj66dyCqgqkFo58tYxTIz2bVWOu1DgPJhXXnpJBi3hOSVrof3h5mlU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:32:00 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:32:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 25/33] staging: wfx: update files descriptions
Date:   Mon, 13 Sep 2021 10:30:37 +0200
Message-Id: <20210913083045.1881321-26-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6873400-b805-4faf-11a9-08d97690ee20
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2717FAF6BE2D5D511EBFBDA593D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sj9b5eyYBginveUajB/krAtAcXilWz/QaYO5ZOxJEmdr47Y9x4g9/EQLtVe1BNG0x3e7Sl2ddMxQMYJlcLXvylK4ypUncgRTBhnoG+c8UxD8tqc5lapJviWML8AEyR/7ChOVGIJYQfSG/Lvaedv6ATRdhWG2JzVuHO6WGoUNWUgLHJIjd8jLz4QqeD1rBchZ6Of9RJJJiGziHuq6iUtgvSxeNGyhVDkJjJBzc8IgC8+61qkjOF2YTAQGUusxNIZWnyZYTVVjCYR0A5ZZGBvSLt9UorK5EtPK5VhG7MV5LKkwUEUsSy25m9t6y0zftGTjXzAVyfsPQ5IIzWuNf6WxlXFPgLZhMyo4Lnd+/CoczZ4kS3hTEfu7uybvBICZaFELiy5+s2y+tgAeBNY8LUMibtpRwr6RhtIWbCtXtIfc2jSgCQub8tHfPvOb01pz5NsFwaJswDs6u7xw59Es9t50ych3qGkZni8iy1ACn2OYNNA1ZsudgJ79Q2YsJU76Qa1B7cJ+vNhdPZGHGSkZau6djcbfSxPKY1ChWn+daVP9WKTUhHScu1lSzVG/lGIqDcj0Kga41LzZTdeo6D0vxTNYYwN1s/LkU8ilWRrox7hrDAY/Bn9m05/MRt2VdVB75+ZUcm/yJabHPLiov2uad6/Ffq/tvK8yphGMUzlzjKFaGuVG2pKDtVWqx3O93AefJ5bRLhYpnAlxHK/4ozwZOrnZrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHRHQ2xXZUswaFAxcm9ZWlFpR0E0ZFo0TFJiVkVIamFsNEdRcFk2MGo3Z0Yw?=
 =?utf-8?B?eml6QjUrZ1dVSHJJaFVMeUZyKy9VTEZXVlYxcEs2Nmg0SVVoT0R5TldzbW1I?=
 =?utf-8?B?N25yZzY0OEx1cXYyaHdndTYwMFBSUHhKSGdJUGhDVDZpWGt5Wm9BVTdkOUx5?=
 =?utf-8?B?aVdkTmp5OWw3OERTVGx4dWpIV285bU1lNDdiS1I5cEpjcENzRWgrVmc0K1di?=
 =?utf-8?B?bUhkN2dYV0srSVlxMGdJNzRRSTljeERVcC9oVVB6MlFhL2VGcEZ4eFhoQkN1?=
 =?utf-8?B?dFBnOUJpS0V0MXg2Uktaem9yNklIa3EwS1Q5Rm9wR1dqWmUrOWVkZ1VPTUJi?=
 =?utf-8?B?Q0dpdHZDNTVybDI5NFd0NW1qelhwQTZsU3FlNTg1WStiaFBkdmVpZzBjMmF5?=
 =?utf-8?B?TitHTjdiWFpxejRERGFxWFFtZGxLRi9uZy9MTXR0TzBFRityZ1hubHNPdmt1?=
 =?utf-8?B?UXIxeE93SkNmbW55VG5Bb1NVajc1WDZqdGUwTXBldUlvZFN0WUF4RjFRM04x?=
 =?utf-8?B?VzZNSDZHcXgvdHI2UTZnRnNvUlZod1dGc3duaDR2a21JQ2VSc05TaVBLNW0z?=
 =?utf-8?B?Um1PcWY1dTA2ek81WFNCREdkbHFFa1F2aEEzY3lic3FWRzFYbzMwYnhOOThC?=
 =?utf-8?B?THlUbkhPVUJCam9OSUl3TmQwaUNMdmhHL0l4WW9VMmZtYVFaQTZoTkJVV0lX?=
 =?utf-8?B?ODVFVzZ3aEhIekZTV1dlQ1FRTGF6bUt4R3JLUmNGdjZ2YWc0Rzg1TkRnYWQ5?=
 =?utf-8?B?Q0NrblVqZkZ0UVZtOUpvbFk3MWtUdUdZZUhUTHRZa2VNeVVjRzN1cmJQVHlp?=
 =?utf-8?B?K1RMakJ3dzNId3ZuTlZyS2NCVDdqbjNGanNXOXAvMVdZcXo2dmcwejk2ZXRs?=
 =?utf-8?B?Y3lXRFRIVjBvV21ERktTQ3Q0aEFTL2NiMkQ1UUV2ZXRxMkltbWV6TnRleEtN?=
 =?utf-8?B?UHJySWVWcXpPTWJtSHBrcE9aenNtdGY3bnNDbGU0R2ZIZ1B2d3RzVE5aK0Yx?=
 =?utf-8?B?T3BNVnE4Wm55V3JmUTdEdmpDalRLTGF0UHNYQUlsZlJtdTlMRUZBVWpIRDJO?=
 =?utf-8?B?Y3VhWEVIT2xpOWxST1F0SDRoVGppbzh2SXdhWUtLYVZuSW9ZdlNNMkc2Sms2?=
 =?utf-8?B?SjNXVTZ1WjhHRlRwZFpiZVpUVGhseVRrYklKaENqNVVFQytkL1lEMHE0VkZ3?=
 =?utf-8?B?dHdSM01tRWdzdUd5SjQ0eVdzbUVqOEZVY0VYZk95QVo3S3htQWxqU3FSZWNM?=
 =?utf-8?B?WXZxajJqdVBNdldNa1dKU213K0d6UmZqakczSVpMTkY4M2loc2VtZkk3RDcw?=
 =?utf-8?B?Q1ptWU1uSk9jSkhnbTN3eEdRYjFuTlc4eHNhRkNNWlpBSE1lQzlqMHlFTFBM?=
 =?utf-8?B?ZUlCUlhuTXlDNFpHWEltbFJDOFpFUmdXaW1FVHpNNmlpeTFlUXFmOExkMUFE?=
 =?utf-8?B?RXVBYzUzelRYTEg0a1hMeHhLcytUVU9BTzExZi83b1dMVEg5THJCMlBxVTBP?=
 =?utf-8?B?WFVCOFV4V3hIajFrSVlxYW5HZkZVV2l5RzdyNmxTSFpUWnNPRUtuY3lEREsy?=
 =?utf-8?B?TVlDRlVKdzFKS3QveXVpazlFNU0xT3NiaHgrOFNBTk10WCtOQjdWcXFiTUc2?=
 =?utf-8?B?eHl5cGFJcUkzWDdVL0RNNnhBYXR4YisxVytnQ3FReW9MN2l1VzBnQ1cyTk1h?=
 =?utf-8?B?em4wU01JdnBCVGRRNWpEMGw1V3ZyNk9XRlJwbFIvVmx2cm95N0ZxL3NQWHU5?=
 =?utf-8?Q?Eja+A6W3Cm+wHik2r0F47y8fVUXPvGdipq+YY57?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6873400-b805-4faf-11a9-08d97690ee20
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:49.3292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZPflldRdNrVhiUZrgr33a+a88FkjsrW0gWf5Uxte/45EkL6nJJILNAEDj6MFcR9mJZPrcc1N7SiCmLXEsYd8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRWFj
aCBmaWxlIG9mIHRoZSBkcml2ZXIgY29udGFpbnMgYSBzaG9ydCBkZXNjcmlwdGlvbiBvZiBpdHMg
cHVycG9zZS4KVGhlc2UgZGVzY3JpcHRpb24gd2VyZSBhIGJpdCBvdXRkYXRlZC4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmggICAgICB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV9yeC5jIHwgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmggfCAyICst
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5oIHwgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmggICAgfCAyICst
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5oICAgICB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvcXVldWUuYyAgIHwgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgfCAyICst
CiA5IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Jo
LmgKaW5kZXggNzhjNDkzMjllMjJhLi5mMDhjNjJlZDAzOWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvYmguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmgKQEAgLTEsNiAr
MSw2IEBACiAvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCiAvKgot
ICogSW50ZXJydXB0IGJvdHRvbSBoYWxmLgorICogSW50ZXJydXB0IGJvdHRvbSBoYWxmIChCSCku
CiAgKgogICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFib3JhdG9yaWVzLCBJ
bmMuCiAgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5j
CmluZGV4IDM4NWYyZDQyYTBlMi4uNTA5ZjQ1Y2RiYWI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2RhdGFfcnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYwpA
QCAtMSw2ICsxLDYgQEAKIC8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkK
IC8qCi0gKiBEYXRhcGF0aCBpbXBsZW1lbnRhdGlvbi4KKyAqIERhdGEgcmVjZWl2aW5nIGltcGxl
bWVudGF0aW9uLgogICoKICAqIENvcHlyaWdodCAoYykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9y
YXRvcmllcywgSW5jLgogICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1Fcmljc3NvbgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2RhdGFfcnguaAppbmRleCA0YzBkYTM3ZjIwODQuLmY3OTU0NWMwNjEzMCAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3J4LmgKQEAgLTEsNiArMSw2IEBACiAvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BM
LTIuMC1vbmx5ICovCiAvKgotICogRGF0YXBhdGggaW1wbGVtZW50YXRpb24uCisgKiBEYXRhIHJl
Y2VpdmluZyBpbXBsZW1lbnRhdGlvbi4KICAqCiAgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwg
U2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KICAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJp
Y3Nzb24KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggZjE0MWFiNTBmNGZkLi4wNDI0MTQyMmVkYzgg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0xLDYgKzEsNiBAQAogLy8gU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAtb25seQogLyoKLSAqIERhdGFwYXRoIGltcGxlbWVudGF0aW9uLgor
ICogRGF0YSB0cmFuc21pdHRpbmcgaW1wbGVtZW50YXRpb24uCiAgKgogICogQ29weXJpZ2h0IChj
KSAyMDE3LTIwMjAsIFNpbGljb24gTGFib3JhdG9yaWVzLCBJbmMuCiAgKiBDb3B5cmlnaHQgKGMp
IDIwMTAsIFNULUVyaWNzc29uCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCmluZGV4IDQwMTM2M2Q2YjU2My4u
N2RjYzkxMzJkN2NkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaApAQCAtMSw2ICsxLDYgQEAKIC8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KIC8qCi0gKiBEYXRhcGF0aCBp
bXBsZW1lbnRhdGlvbi4KKyAqIERhdGEgdHJhbnNtaXR0aW5nIGltcGxlbWVudGF0aW9uLgogICoK
ICAqIENvcHlyaWdodCAoYykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgog
ICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1Fcmljc3NvbgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9od2lvLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uaAppbmRleCAwYjhl
NGY3MTU3ZGYuLjVlNDM5OTNiMTRkOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
d2lvLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmgKQEAgLTEsNiArMSw2IEBACiAv
KiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCiAvKgotICogTG93LWxl
dmVsIEFQSS4KKyAqIExvdy1sZXZlbCBJL08gZnVuY3Rpb25zLgogICoKICAqIENvcHlyaWdodCAo
YykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgogICogQ29weXJpZ2h0IChj
KSAyMDEwLCBTVC1Fcmljc3NvbgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXku
aCBiL2RyaXZlcnMvc3RhZ2luZy93Zngva2V5LmgKaW5kZXggNzBhNDRkMGNhMzVlLi5kZDE4OTc4
OGFjZjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngva2V5LmgKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9rZXkuaApAQCAtMSw2ICsxLDYgQEAKIC8qIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KIC8qCi0gKiBJbXBsZW1lbnRhdGlvbiBvZiBtYWM4MDIx
MSBBUEkuCisgKiBLZXkgbWFuYWdlbWVudCByZWxhdGVkIGZ1bmN0aW9ucy4KICAqCiAgKiBDb3B5
cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KICAqIENvcHly
aWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwppbmRleCAwYWIyMDcyMzdk
OWYuLmU1ZTc1OTU1NjVlZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpAQCAtMSw2ICsxLDYgQEAKIC8vIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKIC8qCi0gKiBPKDEpIFRYIHF1ZXVl
IHdpdGggYnVpbHQtaW4gYWxsb2NhdG9yLgorICogUXVldWUgYmV0d2VlbiB0aGUgdHggb3BlcmF0
aW9uIGFuZCB0aGUgYmggd29ya3F1ZXVlLgogICoKICAqIENvcHlyaWdodCAoYykgMjAxNy0yMDIw
LCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgogICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1F
cmljc3NvbgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9xdWV1ZS5oCmluZGV4IDgwYmExOTQ1NWVmMy4uMjRiNjA4MzM4NjRiIDEw
MDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmgKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5oCkBAIC0xLDYgKzEsNiBAQAogLyogU1BEWC1MaWNlbnNlLUlkZW50aWZp
ZXI6IEdQTC0yLjAtb25seSAqLwogLyoKLSAqIE8oMSkgVFggcXVldWUgd2l0aCBidWlsdC1pbiBh
bGxvY2F0b3IuCisgKiBRdWV1ZSBiZXR3ZWVuIHRoZSB0eCBvcGVyYXRpb24gYW5kIHRoZSBiaCB3
b3JrcXVldWUuCiAgKgogICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFib3Jh
dG9yaWVzLCBJbmMuCiAgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCi0tIAoyLjMz
LjAKCg==
