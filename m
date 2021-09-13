Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C664086C4
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbhIMIeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:34:24 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:62366
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238310AbhIMIdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2mSXw9xpBU28OQDFE8pkcV94lo4dS4+8osHdgYOCvBzqa5+U6XudqRMMNw3qLQd7r/c/is42xq8a1lKUVfrjOq/uD0Gqwbuz4YOH8m73CL2kFS3uUJsdBiKusAuj7xCnCrPYAwavOehWQUbfCgt/+BrQutSBZ8jQHDa4vCs6Rlw0+Eli36V+AMH8Mp8nDHS4MIC7FqnCNwi6NHy7yfj2DtTbPZbRZdLe6P5+N1VEGYv/b+FCr/m3byWztehzfr11waSKZSWJqFTF2NQLKTsE4NvLHV8tnUT9pr6fygHSHrgFNWJnFmyFXIa+4rp1kOxJkqtd47xxYIKFrAMO8jfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rtRjvSlyXDToLuWg9t+Q5N9m2nkpKJd5T4sJtezrxTw=;
 b=SSjw5S8hgJpjwa1u8PuvRmT7IvqDsY37CiQbHln3OIup98GCrq/yOi07Fh3wJVR4bSf8KPU45C40UIIQZxDmJbh7avOCurdWH9bdvNtUnQ6xUG/44wG9U2R9fwoGiGx5pV6rvrEKq857T/hbcMScxnnKiBzMMBK6bUF1YY3820ztACVNlU8/+gxAVfUNzPssMymteiro/wINR+uM+QNgDUhUYy/PoG5Fg1lgjVeRjizgExaXwL89IdBV3AUgbwTHvDbuxS4dNNkE356rTXJAiso1z2vJG2plVsVzcdXDpULjcl/8aLEfCW9PEikhQKl5LYIDBcbvme/mmF5VKYljew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtRjvSlyXDToLuWg9t+Q5N9m2nkpKJd5T4sJtezrxTw=;
 b=MCXdWtDEoMBjH6kPrSNrdiNNmnQ5x/LFg+uwArzN7YxbjfUh3Tp77jPuQRj1NqFhTNLHYx29uaZn6caGWyWKzX9cH7sZZQNN16GaOaf5hy/qv4JDztLtPew3CEhi1uwIwTSGqnnSpVWFDAd42z1tg7yaopB/QgMYckS0dpjbuiw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:31:59 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 23/33] staging: wfx: fix space after cast operator
Date:   Mon, 13 Sep 2021 10:30:35 +0200
Message-Id: <20210913083045.1881321-24-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5bdc03f-f45e-48cd-7fdb-08d97690ebe4
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27172B933C04AE94F583365B93D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYOy+WpD8q2RW9rG/AhTJqqmMTDrsK1rB94M0IvZz9gMQ5bRZDbJPSAAvE75RILcIJQRVDAWdtOyURiVEhSj1XxmwBBMaYqNEvGmFVHiteg+RjA8Lt/jwlkJ1EU+PWYg1f11gOf0xraourkpokYXS0yPYKPDmSywzUZBeTdF2r6gDpEz1W16+PYUtTAO1b7p3x/af6B517l56CM8PprWu4Rl8KSECfIXClTXTBHdM95/6WydFoOqs47fzoNzokay9SE53z+yvflx5bAlZOse2CUh7z2QCU/o6l0kNDluicFs3M1DvOkOKhWo0N/WMNDh8aWXNMw/B6GrVNl8icZvoVINW9JF9J5Bb+U9xShaidTABWg8qhMnTN3wTb57qtIxK0H5tg6kOLdyPgGVc9IA0wBhlPbzGhOIeKXhAeKmCL4zzaIFsbOuX6mZODCuup6bCx917UzbSuW/D/BQgnN2JI+Mls8gqljlXxWwOC2KeG6nNA64mKmKJ++wwRGvgWbX/o9MX+h46QjSYemHkpqFINSeZETVWtyJhq4Ttqb/sW3OTG57Pm9w3gKfTBSfUiHBqn8oB/UoDxLgbhWw/ms28+z8A3aqhIeg85B6qnOaLFn/sIMlU1BBX5r/+XA/8CPNuXu0EQxM54ILFOXXJxekLElxRd/sTPT6+HYiDrWkG2TjrhEQ0CNPtZ7DFjuKEWioGD+PbiCHodI34Er1+C/lmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005)(4744005)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THppMjNiU0NwOGJuVHFSTjEzT3dzT01jLzNNQzhZdFJsalhXbzQ2eUVrZEdE?=
 =?utf-8?B?YVhieG1Xc1cvOTRvRVhBSWZwR1pDdk4yQmJDSWdkQ2daa2RXTGdxSU03Mmht?=
 =?utf-8?B?dTloaEp2L296aVlHQ2xsN1dUb2hQMHk5WXNKeHZGd0xEdXN0SXY4eGF4Q3B6?=
 =?utf-8?B?ZkkwSnN0WXdHN05OK0NFT1RoYlMwZWF6QWVOZmlFM2VpV3BFZlVSdDZ5RnRJ?=
 =?utf-8?B?Y0d1TWp2Q2VXNkRQenZPSkVKY3F1MnR5cFhNR1djVkNXNm9KU3ZpQ2NOYktC?=
 =?utf-8?B?ZlpPQUNRaVdDZk01UzJjTHRCZ1g5bHBNdWZ5RDEvQXBQYmVJbEoyY2xQTUda?=
 =?utf-8?B?czk2cnVDdmFaZUtXems4SCsyVHZ0MDIxWG91YlduN3lIakRuOXppUVgyMHFF?=
 =?utf-8?B?dFM0UUNscEpMcERDN2l2d2tNTG5UeTdtTmx2ck1JV0pKdThYSlB5bWt5Qmpm?=
 =?utf-8?B?K2xqKzk4OUwwNW1WTkYzMU1kT0NLTFM4a0dBMTdJOHEvMkFrNTJaQndqWXh3?=
 =?utf-8?B?aUNYN2F4Y0k3WVpYUlAwOUtMZll0MEZ0WXMxUnk4YW9GRUtXZmhEZ1doU2hX?=
 =?utf-8?B?b0Q5ZTNhelcyVG9aT3RwU1NuZFowNlYvRkREVGJDSjQwZlhoeFdQSjBLNWF2?=
 =?utf-8?B?Zlhpa2VHNVV2dHdnblZ1Wkg1bFlIVEN6dU5wRFo0OXNzejJEeVRBSnhXOWxw?=
 =?utf-8?B?TFl6TVdOcCtBci85ZlMveDZaSkNnV3BkdWk0aXFOY2cvdlFCSUlZL3FRRm1y?=
 =?utf-8?B?RDVTelhkTGxRNnFRMjdUUWs2RWpZRjhlNFovUWlrZFZIc3BUaDR0UzBFMVha?=
 =?utf-8?B?Sm5lREE0anJOZG1acUJFWllHUEp3cHd1Wm9KTFN4dDluWkV1eGdsU1psQ1M4?=
 =?utf-8?B?WnVUd0d2ZFNzOXovc1dESmlWSStRRW9OZWZQUnNUSDE3R0dnbDhYQkJ4Rmxw?=
 =?utf-8?B?c091ZUJGMlpxTVN6RG1abmtDMzhDbS83V1dWd2tNRGhPWWRjbmowMzdtKzdJ?=
 =?utf-8?B?eCtObFNBTTFpSzJ2NUJKN012MHQ5WWdnV1RmWXNFRGpYOUVuOHAzN1ArUWFE?=
 =?utf-8?B?SVl1Mkk0S1JMeTUrTjV3TDdTTVZiK0l0Um9jZ3pvRmdWYlhDNlZGeW5hWHhX?=
 =?utf-8?B?ZTNCTEE3UTVubVFwWE9HRFV1VHNZRjM3YXlTaEo2UUZzRzg2RmdsZUJySGVh?=
 =?utf-8?B?ZVM1My8wbG96ZHloelVQMmlVbWNQa2xOb3JvQzkyeDByeWFVT0pnclE3aFEr?=
 =?utf-8?B?dTQvd1NGcTA5MDlCRGhQS2ZZTkxzNlZGN2x4TWpjV285Uk50UnJMWmpocExC?=
 =?utf-8?B?M3RsNmYyZitwMXhFV1YxbmJWMjlsa1JIbFFISmxPREhMenJHZDNRVEF3OG9z?=
 =?utf-8?B?TjRGY3ZQMUg4WTlxeU1wcGtVcU1ZOVVrZGpmQm9OK3hLZWNlaXBsbTVhMmF2?=
 =?utf-8?B?b0dPQlROb0M3R1dxVDNZdVVRWEI1NnJwOTR2NjJEL3R6NlhhYlhBYVZhaDQw?=
 =?utf-8?B?cW9kemlXT3V5MlNKVWdtYjF5Um9wTElYcnJURVhsb1RxRlVYRmVrdWtETlNB?=
 =?utf-8?B?V29nOGYxdkp3Rk9qS1FoUElRMG13M2wrZUFsV3NPNFZ1ZCt6aHJUbitZQklm?=
 =?utf-8?B?MFNYMXNhNEZzenlNTXMrSGxyS1o1VEhESG1Nd0Z0QlFNa1JJSHM5SDY1cEtG?=
 =?utf-8?B?TS85RjBKUUZwRFc4Z2RXa0NsS3BkZWNjcWJMZk1kcDZvU2dsOVN5NlJzRVV0?=
 =?utf-8?Q?riGFZ/Mc3g1qr7YjgWKAvhwueLjtQCXCpFuh4rh?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5bdc03f-f45e-48cd-7fdb-08d97690ebe4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:45.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t002txGUfPNJ52Xj2tw+yn5XduXULD0cIp1dhALH72ai8BkdJu65qYC/FYLMDLpYXQjr8mVEeEEvIRMfU+noZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
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
