Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B891CF872
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgELPFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:05:17 -0400
Received: from mail-eopbgr770070.outbound.protection.outlook.com ([40.107.77.70]:42722
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730823AbgELPFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:05:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsxvJOcYA2Gsg2ge+rqKmIGfRYl2DqguNh+QVPg0tjyadq/5c/+JJoEtyqHQEdJgu6mQQTBAJPEPEtMKO29b7VT8ajQ41NDBlJNCgN9gL0CLcqhfuLvhahnDiYG/VMd1X23nOspHxi/rysIYE3mM3gfabpiyDQ/5siKjtH9Oy1hTNJ7q9vQmMSKKP/UT+EwQUWHWLVmuLduLb6C1MWP/FVK/UCiPXPBxMoGG5WbF6XnMcrzVMsePzmA2Inpc/2EOo2NM0xQzQuvonK7mtKtRAjGN7EGlDfikghX/AAPa094PA/i0SwmZNSev6MduA/lAXqILDSxffE7bMGZd9xWXTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iT/OMJBcfsRkPe6vAx1P07qFqYJx6s8Pt4Ip2IXw6Ic=;
 b=SpMM8alvGmeAUxFHJvumn0bgCmx2i/b0YpDFKiFqHIYy9+Gvj/QhajQBxC8yHBjH94DrqRYtqOJhrPO/bWhUU2WlsS6N7H+B7JdXzahSl3kLN1cgZkitCzpRm85RGeF5R5m7vkTAXpBIB+HNQcMnsz72CjhrVcUsYtWy/dB+eGZw9iv7zBsnNY/A6aO9TVkPW2S1Hz0sYhl39+DSoD7ebfed+ELDE7zZ7wg3DZM/4wwoHG+7HzkK7pWHHeYhCUB0Xy82knycAOfmqRv/2F45kONdpVlow6ypmQwEXQWiX+cf38oNOQp0WDJavCmV4LLxYnGcv9SddoLifkUALOLt2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iT/OMJBcfsRkPe6vAx1P07qFqYJx6s8Pt4Ip2IXw6Ic=;
 b=XaU2FYpwLu4RS/DNvqNf6ktv9KfmAUH/DjTC/SuvsYt27d9yexEzUmBC0Fys6ow35GdUTOx3Y/9JOIychrAFjq5vp714T51ADj4+9CXrJseG5nwjXt0AK/4UZCHkSa7OgsQHAkdAT54BaemMaxDFLp/2p07VNEAviwcVEWsG760=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:05:04 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:05:04 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 17/17] staging: wfx: update TODO
Date:   Tue, 12 May 2020 17:04:14 +0200
Message-Id: <20200512150414.267198-18-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:05:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee5b2f05-2bb8-455d-f11f-08d7f685d990
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17418DC5DB012A496A85CDDD93BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LI0s+fQVIve+mQxUdw4WVpbowfP157vTPR1MWKIC29vAAgsAqc5ecLnvzLT/02T43MUWtvCCXLZiYniPZDLSVjF0qhNnvWsv8JEMyqlm8mnygnvYoCQSI2sMFPLs85GlYVxtsR3O3Smd3MmhnVI/+mmTTaW/fzcnV850xr0c7efJIBm8fzTo7CCE+UoxlF57QNHBCKdhetTnqI5B52DUEaILsnJ3hfV60Oai58Mwjwqcwevi+QV585J99+Tr/fJxVXydXqZBrRD+yY9Z4JxLiKMUcq+f8YSVFFgXJ0rC56RlOhqhurBiGnFDiASQ71zO+YpaLm2FyMaX6vFKqfIXOQz47+rixSlahUo3wGvxPQ7Av2hE8x9zQQgJzDm/STe+EPhofFixskT3+xLS+WVM+tJCC02uhy0GIMQKlU3iLg9wJA2ovCjAxscB7tFzEjm3sf39QsWL6craMHirIH8Z4LqKm4jp+VSYKriB4fp7j6zzs+SRxGNKjCsceaa0Mx5cMbrZtozEqLEqGy6dYlCHNnfoEBEBHYDN/uTOGPOcEf+BVkd0LH1Om4N9RxCKmPS+z51do72N04fhXPmt09erTSHB8qzfPXzpY8cJPLw36qU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(966005)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(15650500001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: R7A3UtH8QDH47mIQWxQrqTHNXrp6S8UTmh7rIwtKbkoNMGSV+yE4gnQ9+cOOPXkg1C/cEOiIQcqgzvSBH20E2eC5v39JnsEFUxfASJG1+OY9HJNKN49HmcYy1qWRsVVip38qfOQ1nOOxx3LnpYAwlkeWwpRSmjpYOj6hpgQwuyPFOPX4viiXc5n37GvNApD6qoTu4IhKWOxyJG87utmZyLwYkWvXBOnXUKIvSYyCqXgNBq3xtKo+eHisLacHgeMDYGLTX2bl+hNTO3YoB5KD6CpcWVerT2CEnez080MMujAmOuTYRL06OuaCJ+r8sZCzgrDoAFE7iKZAktuDOfL0G7TTg3bMb8qk2WWhwsNaO31ucUTj9Pi5Vsf8bS36fACpDMoSiC0a+k5IRWkhCmyn87wdwcyhelTIFz9NXS13HWbWyx5R+PIgsZDbbJnHNfXKTavv/gApSBtsElSSIOv1oncAlmvdLuyafaendVgajc8=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5b2f05-2bb8-455d-f11f-08d7f685d990
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:05:03.9621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6BDFjX5ZkBTsSLyEtviN5ZaqDJvC//nZJKDWaSE4aECQbvJTjlR/+1/S5txgHNtRjEojg4AQu8aqarU/6l2CoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
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
