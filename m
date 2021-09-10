Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1F406F1F
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhIJQLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:11:19 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:51435
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229849AbhIJQJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:09:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUpkp0Z3hwcwnNdL1iLtx5uV/NfM6TqU8FsBNE95fuLNwxGxk1BRjOD4E9QsTRURXentFA8dFhVdtVCuymnDouHlWaB6gqlqccwSEesC3BKs9QtE1MglR7FTXBKzw3HIAHjzsdf024eNnd+n/+D5q2kQrMZ0Fq/nl64p3aqNvergCLjDy3Jrf76uBk/nxUM+qhmFpnskX6Be7nur2WF6hd/yBsdW3d8LMbL/Am6F5B6vIpQBk6Q66Ts3xZFTUbBS8WtMNJM/5eTnLdQInAomxTrlc2JPPJvYe0noxZkyyVR1dipzlA1er/8lW1S9kBUVWxp1E4scc6LZ77/2AmHHTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ji/Ro3T4EFvudESNOp7gumDhL+e49DGbfmq68yR81Dw=;
 b=a9C5AikmFidLtnQER7lw/0SOtUVmRpGxvb5uc0MtESoNCTUyc4jPllHB8QB8ZJo79XlmOXiCtCpHa9dFKv7APa6WHkcbmDKw0RBvFGUAgLugH+FRclt31wJq0WntYrHhOnqQGGvE7GGFaGmsUts3O+kqOJ1wYQZ6qMAZo1ZI4K3g/Z/1CbfTDvs2KqvpSvcjEcQyiCt4yb+VWq/graA/5MGN0XzIyfMv2RgFoa5Flqv6/NYrWOD0t9cS3+e9OlQgk7Qqod9DlhWY8ZLWvRzngvKONvRoaiFry6ejG8oPZtlVsmJf0ijisXb25/teOLoodXhmaTsZvKwIq+sXGfX1Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ji/Ro3T4EFvudESNOp7gumDhL+e49DGbfmq68yR81Dw=;
 b=c1ZhyuZdl/pXHM6kjYNIHcbbpo+LAMuv7VYvTzrSBCUOI+CFffhxcCsUgpgFbkOvKvf9cYrT1aaWKCA6Q5svGwOS64DhZZnbPm9VJnqQT/H1IruddF932j4UHGQTmAkuHvywZnDZgIp3aOSK/Qsi/du31RV1poa7On2rvewVU1A=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Fri, 10 Sep
 2021 16:06:20 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 25/31] staging: wfx: update files descriptions
Date:   Fri, 10 Sep 2021 18:04:58 +0200
Message-Id: <20210910160504.1794332-26-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d28e7f2d-f519-45c3-c91d-08d97474ed8b
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB50022D429E16B860E2BDBA2493D69@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xyV4CcTd4nzXgX4Cy/791jXW/2CZ93J0UDNbYCZ9Dw5dh2g8oFIbCnFQ5QPvB9D19bYjuXF+KlpBpIGA4lWJ/4x93VKoPGa2IfS2lLkS6h+5jpPiZsCYqXyNDaCrV/MkjcNaGGK/uD3yG1ILLzDUkQKO7eHPaGrZTHzFpwtRdcX+FVlntNJuxzBwY5rH8iTTqV+HMZFN8J08TR8nA9VuSOLtYJUfd64ocbRhjsFGYNvOps8IchA+s5RKMeWB6pG7L5mVcNkYjMxKWrwXcigNL1+5wIdZcuLp7jRRqZSgiYxPOTIqWHG0xZoqrrZaMS0M/ToRGC5lmSW+nwVFiGfBMtz0mEgGWpYO73vTOK9L0gJlMXNC/bE+o2d7ER+Qq0SEDqsVZWKdmJfQhUvw40yWmLnm4UIcq4tTZuoPvAafB2YL9ULdZZUTgn5vpjPh0o2/qw46UZFtM1EWHMk6Oa5ZCOB4vuMtpoC7dOPtAqlojuUpFhZezxkZeGwbacJP5nOxJB4spwDC41ATdNL2HC6ko7dFTTFr/A8ROdV21psG8KNZ1HdxvlsjoIMq/YTchlhY7wW7pNcJ+hkPDXMa1KSYQoxM9mVASE4z4cCNxeXtqsH3vLOnwA25t1ecG82b/MzsBx3Lbt9tuDpQTEXJpzTLOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(52116002)(86362001)(38100700002)(8936002)(186003)(7696005)(4326008)(508600001)(8676002)(36756003)(2616005)(6666004)(66556008)(316002)(66476007)(83380400001)(54906003)(66946007)(2906002)(1076003)(107886003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3JYU1J2QW5kVjNqNzhKM0NoTjZ6MXZoZk9wQzNjVTNMUU5NRndMVXpVc25V?=
 =?utf-8?B?UFVLWlZlWHhUQlFzOGc3QWVIVk0vSE5LK1UvSFBkd3phcElDclJ6RFJreVpP?=
 =?utf-8?B?SmJHYVhXSlYzMmg1NnpKVzBMbFJyTyttcUxHNW91Q1NDRzlFcmhOTWRxNmdl?=
 =?utf-8?B?SklSTXo2NXo1OXVLa0dJZ3JQd0gyMGFjN2JvV3NyMzhPNVNTRUM3dHgxOGp5?=
 =?utf-8?B?Mjk1cnlrWkVvdWozLzYxMWt2UzFsVEFSWW5wK1VWc094YmJDbGY4UUNCaHdt?=
 =?utf-8?B?MlZRUW9vd1U1Uzgra1lBYnU2eDdIWmpFdHlYbys5aFBaZTg0Y0Znek50R1Z1?=
 =?utf-8?B?cFQwZDBYTVgweTJXdUtXSnlPUlpoaGpDZlBxeGc5MTZNQ0EwQ3JKRXB5L09H?=
 =?utf-8?B?ZzAwUW9RQ292VkwzUm0vdXdEZTIzYlJUdmhDcnpvMkxqM3FkVitBTG9reUkv?=
 =?utf-8?B?Zi9oNCtkL2k1bEdUcVRJVDkwcjY4YUhvc2Q0RkNDTnhydE4wU3JYamR5dnVV?=
 =?utf-8?B?WHpzN2h0cng1Qy9GQ2NuS1dhZEVENmdYd1RlVXFmUXlsWG9Db2kxdlNKQUh1?=
 =?utf-8?B?Y1lxcGJpdThGY2gzT1F4b1RWcHlOdDlXMnBDRkxlL0tXSVE5M3NRZ21qa25V?=
 =?utf-8?B?OEJRRHZkciszbC9UQzN6Q25SUVhNVHV1dGtxTDYwVjVGWWFGZzk4dTFFQ1l1?=
 =?utf-8?B?VTdzNThYeUVqTFY5akxJTXp6aVY2ODdMODQ2YnJGVjB5Q0pnMkxDakc2MXFT?=
 =?utf-8?B?T2l2dURkYi9OU3dSMnJUaWNaOWpoM2l5eUVTUHkvK0UwWUkxZFpNQ0V1SEU4?=
 =?utf-8?B?cTkrVjhkem16VDM3T2ZsOXVxemNZZ25MU3VvN2ZyRUNtUUFjMTc5bTc5bWxP?=
 =?utf-8?B?bkQrd0lTWnh6aHlwNHU2RDhWOG1VU3dlNTY5UjVJY2lOa0FOdlVrT2g3TFo2?=
 =?utf-8?B?RFNmbit3YnB2VG5MaU5na2xVNjc0L05PTXpWMFNpRHdzVUhySktXMWFDRjlu?=
 =?utf-8?B?ZDBtVi8xeUNpYks0VUVCUmFETVNESmM2alRtMFdaS2JuRlFUYVlqUzhub3hL?=
 =?utf-8?B?ZlhOdWdKR3JlL2JPUkFkTnRlR3ZWbFV4MW9VMUZZa2pIUEZhV0RIOWJCdmg2?=
 =?utf-8?B?Z1FGb0FaN0VwMUY5c1pneUFrVThURGNYTHY3STBzQjM3WjdyejNEN2tZaHQ0?=
 =?utf-8?B?Tnp6dGRNSndjQ0RZcDkyTDZkbmdYckNSci9DdTdvNmFMYitTYzFiR2RMekdu?=
 =?utf-8?B?ait2cy9COGhyZ0hGcFZTdko2MkkxTUwxK3oyVlJzQ2UvMHVIVmFhWnhWSWlR?=
 =?utf-8?B?VDVzRnZLQk5jTGJxVSt1azhpRTFOOUVSZkJzdW5sbEZuL24rS0tjM29Oa2k5?=
 =?utf-8?B?NVRwczhNSjBVM0wySjRRRFpSV0NEaDhkZTk4YnJ0RUFBbkpicGMxbHUvQ0dh?=
 =?utf-8?B?RStUVVRTSE9mOVg0NzRDWENsOTNHdVd2dEJhNHlrRWFWQ2t1aGQyMUQ5VEgv?=
 =?utf-8?B?cXpOL3dvaEpaOXIzaDJFN1FBYmkwQml2eXFXMEZXamtiNmludWtYMzhQdTZ3?=
 =?utf-8?B?ckhHbGwvWnRNTHFFYWZrK3ZhdHZYSnUvdXh0ckRldEh2RUNSWW5uU1U3eURy?=
 =?utf-8?B?LzJEQTVYejBpQzQ3SlE3aVdjWndrMnVYR2RCWUR5ZktVaElKdi9Qck5LNzdJ?=
 =?utf-8?B?aFNxcTlsN1BEamdLSXZPNkZnQXg3Rm9FN3FHVHkyUDVPc21TNHU2R0l5RUFV?=
 =?utf-8?B?OTBnNFc5WUhCYVdRc1hIUDEzZXhNV1V0ZnYvUGFDWmN0d2pCZnBMU3lFOEl5?=
 =?utf-8?B?TllXaUcvaThnMGllTzlzZjJTK0h3RUJLUXR1UkFNVFJtQ3NiQnptcSt5OTVZ?=
 =?utf-8?Q?at07UcQ9HYmW/?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d28e7f2d-f519-45c3-c91d-08d97474ed8b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:20.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TsVc875sq4mAIlQ9O9znv6bESKCMRYtMnEXqf0pMl7E+1YM2xgn++jn16GrUmtE5hivelTJRnO63SF3KNK9Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
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
