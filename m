Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284241CDFA0
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgEKPuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:46 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:17760
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730648AbgEKPui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bs/aVAgZv9VqwODNdXkkcW924ZsbFuOkboNRkkN8WMGZk1lM/Is1aEG+p2C/5OhJYYwnk83sNmRRjovxeT9uRNQJOripFff17t3B0Y7epTIPV6zJWVn+uiZlAwnAnHxzmyJvaAFtx3Pd2g4VzwRMn99qsb7bPkqAD/yHTuAwhYhzT4gaxzj5yOJVztzrQA9hrexPRiw2EqLnM5W2WMwabI8ACEyVWlghiX+rija8zX2iSmIjiJ/TO5PPxgVvaMkYjm2KTx7Dz1TiRdhWUTuEnfVh0mrwbdGsrv+qVUEfHJSHKe7CyAsTVb42rprr3SUPnQiQeMIGvlqTW5XU3/gUOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iT/OMJBcfsRkPe6vAx1P07qFqYJx6s8Pt4Ip2IXw6Ic=;
 b=g+gvNdrbD/OipuIxaXAd7HPzcHRo5jXZNbwFXYundMP40TfQbsOYUGi86LnfXJh7+LMoEbFkIo+EAzaNcIg90TcDc8BalHZiv4PFhggC082Yx3AcGt3NkKayr9Kj5RiZ37cJJUtGOtvED6+T+uuz3DyTVE/CtquAuwZyoxTBEdfX8HzJMgOy28OiZkOj4RnIxcGcVwuQvzrFQ0MDcksPxKY8d0ysblxV9nxF73ey+SLYMS3q3TuwGCxfNy1b7DdJa2E1U7/IEkd2VW+EMe5MiKHM/LYPD/1GRXTXn8lhs50Nr9jStJn6gmeCRS2oNhJVBgvmGL05n1wParlueNmYCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iT/OMJBcfsRkPe6vAx1P07qFqYJx6s8Pt4Ip2IXw6Ic=;
 b=oDE+VGiHC0w1Uj+B9WVLDSvcbRXgO6fhFn/gBCAPApJHnOh554VjW2GcZZgtifBrWwF0bCTGfLW98E/htVGhxldsrLwSXJqH1sEm6YnbfrnlL6igrRXL+lhXsy7Px3gNHuo9NEA2dJzCDdahAd5AF4FLsrD4N0sSeumF3x3CxzI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:21 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:21 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 17/17] staging: wfx: update TODO
Date:   Mon, 11 May 2020 17:49:30 +0200
Message-Id: <20200511154930.190212-18-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:50:19 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7692626-b90f-4fed-8a01-08d7f5c30283
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB19686A3DF12B2CF5743E966893A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2VCt/2IJYavhsazcLKJF0P+cFbP0Ek6kfmq6/r8Da/qhtsE7lxX/KppV/k2w/atz36CFh9yCRZv4EEpmWuZqyvrOPRflpeTqdSlNLvMBY5PY5dOadFL+iMJld7afi4XJXOEIRjiykxVeMWp19n+p0vufC3NhgnHoLIpO8KaijiDpc5EsfQqGOCwtzQfQjJSZ6jshx7xBb5euDfaI6WlK7G+Pzc7iTugUsdHhXLrJjxvZsGfLEXNsFl83lMZJ7NO81fok5RbaC7btOBRFDfJUxiQxvODA1KFbMfiE6R978TAgPuyte8h8qcjDO7ZFrSJ7z9PouRgaQc5nppzYYxjderTBRx0K6GPJRYIyOSz69WyoqvMwroOnfuQYQvNd+so4iAEETD+td36batsJgwXIuFi02va7F1DtIZq6KQ98hb31vfhQ82f1iWimsDmJ6bQtcgLgLttC48LPiFd8j4bEf+DYvrEQDFPzLmQBshi7okhvVcjxoHpAwmzeG/DDhV5E5A2vZeER7MdTWdHLuJg343ubIk29ZbYVoL5+S8Sl2OX2gH0Kk7v/SOEPxzdpFm1Qysjns9oc/jtICWGG4DboV7beiiovOJdV+RehasEdyI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(66574014)(36756003)(16526019)(26005)(15650500001)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(966005)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wXcEZIaYbKYHeapouqHpJDPlxtG63wGOGsCqA4IgVLSm9bzBwi8mBXiRQfzh3lOrrV4xsCJOWpnZyI4er/mZ09XAi95fcKpRVmw6ZyqB9dcI73yluuGNdqnDJkFSJaeM3FPmOBCoLWKn0xxAcvhnaKWmnnx94Xnpgkt46LLL/+AozfLC0Br7wHPjjouBQyYIqYHc9rJtLxvrdG6f8HCTA77TLCCDrSXqMfMTtZkHnaeHOohDu4HH2ihgESy4leOavI9H+xpSDUdhBUqgj+lpGPISB19oo+03d8PCC/+i/qwCpBPMF8wosLhEZ5wl2bgSt7wLWVCe6HgiJP3xLLBD14R7W32k/gG7zxU46lmn2jT2MPTLXKWCl+rJW7T491WdqgvwGUYbn6HTDvWa1m4bmWMDn8RQAx+Y/ujXBz8hK5awAKzjzQ9zJocKsq5wJh43mH6J4aMmFeSKjtqs9JG/4jqokWKawcEXIqfbnij/N2c=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7692626-b90f-4fed-8a01-08d7f5c30283
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:20.8796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vq26kolM0H+KiHNKi5hDNJJSRLBS0u7xZhOyLT9DrMqktMicV/i2BYmdWeNQvwV7/dnjx+NfWK8Yinr3030MNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVXBk
YXRlIHRoZSBUT0RPIGxpc3QgYXNzb2NpYXRlZCB0byB0aGUgd2Z4IGRyaXZlciB3aXRoIHRoZSBs
YXN0CnByb2dyZXNzZXMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPIHwgMTkg
LS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE5IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
VE9ETwppbmRleCBmY2EzMzMyZTQyY2UuLjQyYmYzNmQ0Mzk3MCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9UT0RPCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETwpAQCAtMywz
MiArMywxMyBAQCBzdGFnaW5nIGRpcmVjdG9yeS4KIAogICAtIFRoZSBISUYgQVBJIGlzIG5vdCB5
ZXQgY2xlYW4gZW5vdWdoLgogCi0gIC0gRml4IHN1cHBvcnQgZm9yIGJpZyBlbmRpYW4gYXJjaGl0
ZWN0dXJlcy4gU2VlOgotICAgICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAxOTEx
MTEyMDI4NTIuR1gyNjUzMEBaZW5JVi5saW51eC5vcmcudWsKLQotICAtIFRoZSBwb2ludGVycyBy
ZXR1cm5lZCBieSBhbGxvY2F0aW9uIGZ1bmN0aW9ucyBhcmUgYWx3YXlzIGNoZWNrZWQuCi0KICAg
LSBUaGUgY29kZSB0aGF0IGNoZWNrIHRoZSBjb3JlY3RuZXNzIG9mIHJlY2VpdmVkIG1lc3NhZ2Ug
KGluIHJ4X2hlbHBlcigpKSBjYW4KICAgICBiZSBpbXByb3ZlZC4gU2VlOgogICAgICAgIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2RyaXZlcmRldi1kZXZlbC8yMzAyNzg1LjZDN09EQzJMWW1AcGMt
NDIvCiAKLSAgLSBTdXBwb3J0IGZvciBTRElPIHdpdGggZXh0ZXJuYWwgSVJRIGlzIGJyb2tlbi4K
LQogICAtIEFzIHN1Z2dlc3RlZCBieSBGZWxpeCwgcmF0ZSBjb250cm9sIGNvdWxkIGJlIGltcHJv
dmVkIGZvbGxvd2luZyB0aGlzIGlkZWE6CiAgICAgICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xrbWwvMzA5OTU1OS5ndjNRNzVLbk4xQHBjLTQyLwogCi0gIC0gV2hlbiBkcml2ZXIgaXMgYWJv
dXQgdG8gbG9vc2UgQlNTLCBpdCBmb3JnZSBpdHMgb3duIE51bGwgRnVuYyByZXF1ZXN0IChzZWUK
LSAgICB3ZnhfY3FtX2Jzc2xvc3Nfc20oKSkuIEl0IHNob3VsZCB1c2UgbWVjaGFuaXNtIHByb3Zp
ZGVkIGJ5IG1hYzgwMjExLgotCi0gIC0gTW9uaXRvcmluZyBtb2RlIGlzIG5vdCBpbXBsZW1lbnRl
ZCBkZXNwaXRlIGJlaW5nIG1hbmRhdG9yeSBieSBtYWM4MDIxMS4KLQotICAtIFRoZSAic3RhdGUi
IGZpZWxkIGZyb20gd2Z4X3ZpZiBzaG91bGQgYmUgcmVwbGFjZWQgYnkgInZpZi0+dHlwZSIuCi0K
LSAgLSBJdCBzZWVtcyB0aGF0IHdmeF91cGxvYWRfa2V5cygpIGlzIHVzZWxlc3MuCi0KLSAgLSAi
ZXZlbnRfcXVldWUiIGZyb20gd2Z4X3ZpZiBzZWVtcyBvdmVya2lsbC4gVGhlc2UgZXZlbnQgYXJl
IHJhcmUgYW5kIHRoZXkKLSAgICAgcHJvYmFibHkgY291bGQgYmUgaGFuZGxlZCBpbiBhIHNpbXBs
ZXIgZmFzaGlvbi4KLQogICAtIEZlYXR1cmUgY2FsbGVkICJzZWN1cmUgbGluayIgc2hvdWxkIGJl
IGVpdGhlciBkZXZlbG9wZWQgKHVzaW5nIGtlcm5lbAogICAgIGNyeXB0byBBUEkpIG9yIGRyb3Bw
ZWQuCiAKLS0gCjIuMjYuMgoK
