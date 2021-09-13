Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A5E408BDB
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbhIMNGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:06:31 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:9633
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240085AbhIMNEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxDPpLE1k/VMZRD+fxHWJlUolIKuyCi2+QdwqRjkL+VxRF1sHoCisxSWipe4snLymIdULq+QgHLYNVfMJJnFof+Xq2QOuYTD1Tk8PiA1ZvEsXMOa1VbUhaWmRnv08I6tdHtLBoUJGiESYb/QC3osYymJXRYKJB8e69n0xx5gPU2fxA3Yy8sYX0AQxPGoKr1oMAkGvvG6cHvnYVBrVZEn7sfWPALTigrzg019+f4NyH0GidWZLiMESmeXpYeFyXV2fWFs71sZVCXwnh2xR4V6X1k8iogOuqX41yvtq8ASNtV4YyViXKOB16ztIZ20brHHM601mH2kkhEQ4IVRfbfBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ji/Ro3T4EFvudESNOp7gumDhL+e49DGbfmq68yR81Dw=;
 b=f88O7fLEm7kJAGqqBhsCO8D9bh6O53NOXniyUh0/IWbjgghz1MitXB6aU3K4vHx5z+5WWvqiCc0WPH4rB6LIXs6471Jf2+0j/NAlMZGn0DVdK6ASHcY6+4mkgF/8Dr1x5B2E7clvQmf1Ujaw4rLgGjy9iwDgQsPMK1N61GHMlu1TWX7nt5PbR/xrhDLRTSLli2IPhbXHQgT7TSTty/iv64hN2GtR9H27cQpNPY2lCkWPKE8aV72S7aJwNrdALZgZUIzCdpeDQUinfUJz/nrN1jLVVejgOtwf35KH88NN6QOrOWjzKi6CdE4vMc6A5ECIq2z2ReyprPCos6CrsWW+qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ji/Ro3T4EFvudESNOp7gumDhL+e49DGbfmq68yR81Dw=;
 b=qVYJcEY+VL3UT3kgOWDhTP29Xgif9ftl5EV+OJs4Og9ylClXlW2tHb37CMasTMhqoqO7k02boY9ZozTaliKmvvdTjsaZpOcVizIHhNJo2ZsJAxN6lgz1hemv6AKi7LxNoi1LWFT4gPMgagcMOc6s5Udyy7qOJTPS1YNj0ub/Y+E=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:03:04 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:03:04 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 25/32] staging: wfx: update files descriptions
Date:   Mon, 13 Sep 2021 15:01:56 +0200
Message-Id: <20210913130203.1903622-26-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:03:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 817a923c-c256-4b70-e391-08d976b6d2f7
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502B035D55F06C8CB43EA4C93D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3f9GhBH037V1f67r4z0NgUrgzts2lLTsTAUiaITM8wvFGwMkIAfC32GgkzSD2qM1JQUf6mnpMfZVf31RYmcMmB4fZXmzJcH9rkCBM13iI4SuWsRMGD3Qw+Dr8r213OVIPPn7CKDCBQnI6s3nrYRkZUuupVNPOhVOb7BXTprKzvSNNZ5XUUxPPmg0E0dbqN+yxA7s+3ryi0k3McwtZmWLta7KOtlsOAJbTAkiANgWcKkBbQ8/XcOXy4RGGPFWTqiB1PjwzrWj35C1DF9NVQpTROC6Mh9KNS4Pc50Be2qiuYTuP2NEVilmVNdUQk6/GP+kp5HP6UylX6+U5TCwNXpRkdSgu8bWLmATCSTZ/AfZun1txznUh9hBWf+2jwwbJILYSXOvSGnr8dkmzdvZdj9CMiemy5IuStia540uc6v7IkkUmFtq+n54kouyjkmECEb5vZqKc2PX3QLPdKX/ZpP5UDlx0Hl6xgKnXVh+vhX62TmVdAtGJqx7ewsyaPYMGfmCeLNUxGnn3Dk7KBqrT0psBwWJNKJGvKNQilVb8sRvvAqvtDE5rs/BJeHFApi2LrMY1vR4AUbjoXlHy/Xrh0uNBp3O6PNCo76VQeSCpETYx7WdIjcsXeASvHwVNUA3KjfkmSh3iVQNxhJYotJmUCAcC8dNVf3fpwB6OybIuLA1d75suV+GCYga0uWDhe7+sWBtVQUjfckBKj79Xmy7ZtVOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b09jbTQwbksvWXhCRlNHOVV6RGhCbW44cXR5N2tGN1Z2bmJDN1NFZFVvd1FR?=
 =?utf-8?B?ZXRYbkxFejVYeitJUXYyWU92b3RiUGNMejZtMlZ3eU5LWnFXT0ZTVnZHNHl6?=
 =?utf-8?B?NkJTUUFTZVhnTU41b3dobVM2QVJwUkRvdmZKNnBnUXBQbWE1NjQzalNWSHdw?=
 =?utf-8?B?blFVaEVvWHJsQ3BnVDU2eWY5NVYwMHpmSkFFYVBxMXJQMnhNYVdQSUs2YjM4?=
 =?utf-8?B?Y01aS0FralUxV2ttTC83SU1memtLVWVYS1Fld0xNbUg0TzNKN3dOY0tvTEho?=
 =?utf-8?B?RVgxdzkwb2hmcUVRVXphRTNNekM5dWY2dnplREtwM0pyOEZtcDBVYVV0cFRN?=
 =?utf-8?B?UFFWSURMbTFNVjQwOEhRUVdmNnB1bFJUZHEwMWJ1LzRYMWtRcVNmUTVtSkZt?=
 =?utf-8?B?K0pyU3ZtcXBiaG55bm44RkxQK2pmVDRxdXFndmtZM3p5Ui9jeWRRVHdpajl3?=
 =?utf-8?B?VVVQdXhXeUo1L3VicVF0d3d3Ui9LT3JRYkZHYlJwYzhRR2JjV3VmQ2NBM0NB?=
 =?utf-8?B?b3BMNmQrS01WelA5TERMR01zM0ljbEVaLzVoL1c0NWRjNGR6STd5U0E2RHhl?=
 =?utf-8?B?L3g1bTdjVkFna0pjVXFsUWpNOUp0L1VnNWVZdE5qc3dqYWZ3SEZVYXNBNlZ5?=
 =?utf-8?B?bTQrdTB2d2tlU3NGTW9hWEFrd1ZWUURSczRxV0F3QWV3WjhjN0V5TVpmSFhX?=
 =?utf-8?B?V3MvYmtONlg3eUhEVkZLNENDUUtnWDAxTkJramxSNHBTb3k0S20xTnE1RDl6?=
 =?utf-8?B?MXJxeGhjSmI1ckNSMTZuMEFyRDJDWGI2TU0wTW9xWnFaWEUwL21iM2RaV1pm?=
 =?utf-8?B?aXE0bjZ6UmpaL0R0UFVpVmhJekN0RGVFUVpTa2hud1o2K1FXYUVoamFWTG4r?=
 =?utf-8?B?SnRPeHdoU0U1cWtFR2Z6TmFyRmw5U0NWU3lpVmV3L0thL3ltcnByUTl2VXNV?=
 =?utf-8?B?S1JuRjlNSkRTWXFWdTA2N1d1V1hsZXRwcW1OdnhHM3I2Nnh5dGxKWGp3MC8y?=
 =?utf-8?B?UThETDBpVWYzZGZLNGdrQlZ6cjFRUkVHVWRhK1NCSkowVHZnMUN4ZjNYZ3Fx?=
 =?utf-8?B?dlBKUWQ5K2p1VXZiaXpOZ0dDSTNMbjlSVzZ1Vk90SEJHMmlBR1VzRzhLT2hx?=
 =?utf-8?B?M0JZNVhMcmxObTlDRUQ2ZlJ0Sk10ZFE5R3lSTElMd2xDb01BZDNMUHgxMFpC?=
 =?utf-8?B?SnpmYlRUdEtaa2FldEVsU2pTUUtoUUszaFU3K0JmV3FkUFFENkpNejFyUUdB?=
 =?utf-8?B?ZERVU1dNMGlSdnMzRFJCbHQycGQ1dmcvN0JUbUlBZDI0cFArV0trOVNVRlhz?=
 =?utf-8?B?NXJLR3RyVGYvdXpWU2N4VTM3UGxFdmdxMXNzbDJFanpGQU84TkVWY2NTZVNW?=
 =?utf-8?B?YWJnNnYxV0Z2eXlvUlE2Y3JXeVJ4Mlo2RmhrVW1yRGttdnRDdnlsTjJneGVj?=
 =?utf-8?B?cWc3UkhsL0J1TEJncElsTHIyMW51cjdwblcrK0FITDJJM25QQkhZc1V1QzFZ?=
 =?utf-8?B?UUVCWnJpYTF5UXQ3dG5rKzdRdU9wcXF1ZTJOa2NkSnFBdnI4dUM5L2I5OWNH?=
 =?utf-8?B?cUZMQmJVL2tWZXRlY3hiNVloZjlRNEhRZlRmWHV3OTk5SEFpcHl3TXZzYkkx?=
 =?utf-8?B?UmlrTmVvRUZiemN5MnRkMTBhVTJ1MmFYOHNEMzVwR2tFaXZXRjhVeW5JdHlh?=
 =?utf-8?B?M05OS1Jab1V0ZWdoTkd2RGFCZGxEMEVuaHBuR2xDb3NUcWd5RlVsM3F6K2lI?=
 =?utf-8?Q?cX1+u8HOWShYTfiQ5omGSvgMI0CuimS6o6tW5iX?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817a923c-c256-4b70-e391-08d976b6d2f7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:03:04.7051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: te28mB00VIqrrAJ6an4dus9A3WEb+jFcUWFMJBzfJXj71NA/avt6C464hAyN9s/CqBchsR/ionbAc9ysM4U/CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
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
