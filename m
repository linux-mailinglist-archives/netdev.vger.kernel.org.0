Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101EE167CF6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBUL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:22 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbgBUL4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6zhAfjRcgoyU0a7WTOwiAWV1TrZ2wefSh3epRENwgWZncCnGX1IGTfWBSbFWkR1bREZ+MJCad2Yqo/3ghp0/3mZxNZVc5sKCJzch3Oa6Ky2VhIU6DSpGa1sqtudRGYuUgdTErQfMFlsCLa+7omq18mYPUIXUNJ7lOIJmVg2BWKzZUbMJg98KGDyt3HHsW+5flNShr/iRlALVK4IiHrnrW+RFPgJDH/hPczq9AMEI0V6lptrOCMgkmWM8LYaOrBSuHGBZe0MKySbYBbTysaqHfsuhI1P9T/sLdSKNxMIitiVZ3eliIaZiQWjr0G0VlskkRmXxYXL7BZDXSfrVa5Mnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkEuqmEOD2mfn3wsxeFhLzARBGh0vB/UsNg8bpkHB98=;
 b=WyTQV2ScmHd1LO++WzvorbJm9eZFUlWApGnzuZiO3u2cwDwtBzUbbL7zPre1/Z1u/rk603BACiZ0q6wVAPluiNJID5V6vOXFauhCG0fG/SJQUamSwdL563A1idiE8j736ydTgz5nEpEZcpVT5KGQnF7Yjx5xPIDIGO5rE0hjedtAfTFHSInJFj8M2BwoIoKeQrwI6NktfC6l0NXr1b0l55FQ9Yqlk6VEHIaTKCGQpRAei9lgRKuKFxZHUOM0YkpY7lIzrHXRfu6YwKYyjEcxRI+KctlLr1bxUPnWdG6TN0b5Zv8LZxiaYre2BM2ajYkC76CMvu0drHL8Hf8xK0Pu9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkEuqmEOD2mfn3wsxeFhLzARBGh0vB/UsNg8bpkHB98=;
 b=GHWSxeEXvGrUEK1wj/z2ijFdHc0Ubt/NQpSEUxjKNrUSPp7f+DJurFGOqyBtgMqQG6xFQPXTbnTrYWMOxnWJWJwwGbrqupd8GBUE4bhX3KS/z2hUkMqQbb6hAnfXr5J1FKRRdV7NKdHtun93vILTIdOCkHW4c5S4swAhP1g3kso=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:19 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:19 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/10] cfg80211: drop duplicated documentation of field "probe_resp_offload"
Date:   Fri, 21 Feb 2020 12:55:55 +0100
Message-Id: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:18 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb55464f-29f5-4e6f-25eb-08d7b6c51037
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4662A0386157A77BDBB75B4793120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(4744005)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8En8fPpYOhDQHsrV1u1LLza+ZODirMLiBE3apyJoDpu1MeXHyUrFRh9E3K2UrL/qzO3qBMBQKg+k5Nc9ApPNXIm4dp55Mqoh7m86yBYTts/srZ1ACJ0zwhL/bUzgLHYcUtLbddZ6a7IsiqlzP3JfedjPDgirCfg5nqn/AFvW7kyYOq7hGGmlStyrgdsGYVHZuvdav9OsbWWRcF4c+eUQRbgnYGDuDymo8FpxURfAvz0DUey9At4sGEyrsVrf4Mg6onvCp9ELKTS5WSJITNKDPMaQX+fsy+5+fyurfN9IoxkBgMuyBX9GDaeMZvFUp5oWaOtEv2/PcB9ER/I63s3j2ml/llmEdg8mRurmnvdAkIxxdqe1xkMA0XMqT5IwynZ9TMQAqsV/dZtKwSmg3UnQCx3RG+eo1MFyG/rAWwSuIrU3CUUkAooHxcuRFkHTm2Y
X-MS-Exchange-AntiSpam-MessageData: XHEC8duC27znU2w4kfuV6pPuqiPP5+GNfjOFQnnLlEMtRN2VHbMBEEZpH+/mXjZFCEaBwBaUKDVgC0UrWlzKVxNzPdyXV5yHObyvUP5V7WkfbYKua51ySle6a5n6JsDgxGpuCkS3TmyOqfSt/yx9OQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb55464f-29f5-4e6f-25eb-08d7b6c51037
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:19.6074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2a/8piaSmyAhB4xi7kXkTr63pDfVaRuvldU9IirBbnxYonmzAWIKEqBdE1wxB35LmWc+51FtrFyLwuV27m4PYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJwcm9iZV9yZXNwX29mZmxvYWQiIHdhcyBhbHJlYWR5IGRvY3VtZW50ZWQgYWJvdmUg
dGhlCmRlZmluaXRpb24gb2Ygc3RydWN0IHdpcGh5LiBCb3RoIGNvbW1lbnRzIHdlcmUgaWRlbnRp
Y2FsLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGluY2x1ZGUvbmV0L2NmZzgwMjExLmggfCA1IC0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jZmc4MDIx
MS5oIGIvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaAppbmRleCBmMjJiZDZjODM4YTMuLjAyZWZlYTUy
YTI3NiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaAorKysgYi9pbmNsdWRlL25l
dC9jZmc4MDIxMS5oCkBAIC00NjE2LDExICs0NjE2LDYgQEAgc3RydWN0IHdpcGh5IHsKIAl1MzIg
YXZhaWxhYmxlX2FudGVubmFzX3R4OwogCXUzMiBhdmFpbGFibGVfYW50ZW5uYXNfcng7CiAKLQkv
KgotCSAqIEJpdG1hcCBvZiBzdXBwb3J0ZWQgcHJvdG9jb2xzIGZvciBwcm9iZSByZXNwb25zZSBv
ZmZsb2FkaW5nCi0JICogc2VlICZlbnVtIG5sODAyMTFfcHJvYmVfcmVzcF9vZmZsb2FkX3N1cHBv
cnRfYXR0ci4gT25seSB2YWxpZAotCSAqIHdoZW4gdGhlIHdpcGh5IGZsYWcgQFdJUEhZX0ZMQUdf
QVBfUFJPQkVfUkVTUF9PRkZMT0FEIGlzIHNldC4KLQkgKi8KIAl1MzIgcHJvYmVfcmVzcF9vZmZs
b2FkOwogCiAJY29uc3QgdTggKmV4dGVuZGVkX2NhcGFiaWxpdGllcywgKmV4dGVuZGVkX2NhcGFi
aWxpdGllc19tYXNrOwotLSAKMi4yNS4wCgo=
