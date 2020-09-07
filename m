Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC3A25F7CB
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgIGKUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:20:16 -0400
Received: from mail-eopbgr770070.outbound.protection.outlook.com ([40.107.77.70]:3728
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728802AbgIGKRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:17:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALa3jpFKGE7ar+ZeG23GnOwOUdP98WlKdJgUtbSfhjyC86uoFqwnfvagvWCpS6OTt3MpO3R2cCjGnXHhaCsnmsWztl0YEfhQogtrgqS0AWBusVtRw+fFT7+ZhOob/KxssWorQuEuRi15AoDHZvOxzpEapaVQHhr4O/+yvl28wuMUPGaJO91zkgJiSVcSCBmqxc+sIgKyqQII7j/vSt7nF7w8UivabbRwHwPHWqoyYJvlzyrKyVUhIIKAZMGE0MfJYbUJhyRgZw7dA7uAUIuGGFZ4c+coGKQ8m1d8xPjD2DGhnxDQQw3CE07c86FaqFm1XLgDK+VqcRme8zZmgEYFng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ha9bLL1iB7oklPDnmBPi0BNz4qopztsf+sfspwWNco=;
 b=MU5E29bo5NMvsWw/if2A4SaH6sU8sZkJ3ULo8rxCVH98gYFIt67WK+UuW0c6wDThToejJldhqu1hoYEKChXSattEtFC3P9TfG69Jx2frJ6yHhpB6APaAXT1MRt63hfQAOMuGi+VwiWVLcLvKIkXcKiE1qtDeAbajg8Vew/mE9AXMqQR8PH05ydqHmnVxBk8iSEGq4vXYITvzPbjau/wAK5raZP7by+bR7IbLn/LthXY6Titgctf4318B7EPaqtEC3m+0he1jfZoNwA1s9hBhbZZ3YohtlkuYVvjcaozlV24sjyatInC4q0aTbDxbYym16iV/rqnFXDQ3bTx1YJi1rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ha9bLL1iB7oklPDnmBPi0BNz4qopztsf+sfspwWNco=;
 b=HKSHRzAPB98poBk1bYWTzh1Ung+suamJR8v77Uc/a1jBo+FBf87qtp9fBDRRVLWBE22jqllYallPmI8CyZ0893QbfFlwZ+u+wEFmilzw3VGFsLjN0hprcKthVVxZdAMg5vjIIJX1Kv+Lb5Gxf/oJS6zkmOU6gam/C81XAp35JJs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:17:04 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:17:04 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 31/31] staging: wfx: update TODO list
Date:   Mon,  7 Sep 2020 12:15:21 +0200
Message-Id: <20200907101521.66082-32-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:34 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17e23a10-6b45-43c7-d8d9-08d8531719f6
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB26068B6ECDC4BD3F463E84F393280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eAs9Gxr7wGd0LdrHLLLHYyTli4wsgofOgiehKtvgMU0JqP+UJVRc28aVMZ3SJ9oKABrVEw6+NO9RFpLSqmt3k5GHLJkHoQp2i44LYzVriibvkC00Tntp8kxt+eFKSNYHado+cVcelFYpj5kqruz61DAb7hFr3Sjpfcsi7IrKN6Oh8xVS1l1WKwdsBqU4WiH5R2Pzifq46P+aRXJj1JSwD+Dgtb/VUi0u4ENEV7iwdX+3D4MqtSv4UMubPjbU8oL6SxuM7QolCKFFEBv8h8jsT9fRqU7eTBKWYpIcSjXSIzTiq51NXAKuSF58/KJtEX5QGb1cNV9Lh/cgf662A610NSfIWEead0vgORcV2ZR9/jNaCi1f4tzwwcmCx5Mm5gfNRlsSSkWwanjPymKVBTr7Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(15650500001)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(966005)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZRMZhQ3V0bYDfxXeC3D9Q5CKg16iZ9cevRT62KAXwoW0FbS3BJiXQPyhenSuf1p7JsxcOxAB3vB01mE+0u3p4dQHXpaNQp7C6z3UMcNDny+Zf6lsfDSBOewGVAlY5jWnprumGtFVKR0ewL9GmzAQ5pWpWetapq//K+dCBSLePMZ+aaxkcL/bliLgthbu2ambdOz7P7diMIsRIqlcS1DcOKdmO8s7t4ckGKUTyeHaep+bKmT+wuwRF879O5ZDJ5bdIZbkJoNxNzWeUlHGcL5dEmL9Q5+op1Me6flOS6IP4rdVklMyE9ntq7XqwQ3igsQZGjxmUce/lBS9ojmie1Ql9F8IrEFs3SS/QyI1VwMzHLEGGAf+8kB4io2pnuuebRrPN89g7dezChp32FbIa41XqqWtG+1ZRIbpFn4MmrFhLa4z4/M+TbclUAdG7bqtpkpA2A964oDCPCuU/2LDc8UQbjBlsj2p71p2GryciC/MgY3NH4NckWqcLm99oQ5Zj3Q9v8xWEptVRKfAoEzfcBIAjTi78IXBvhEGhxQfDghaz9iBHnStsQf4rKCoa8d49y2JCkF5tCKK8Jr3s3WyKb0eFuG8iV5hS6a31ltYyGY3NceOLLKk67Kij+NYKv3gAdHgKK/fjSw/elTlEYVL5VE+bA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e23a10-6b45-43c7-d8d9-08d8531719f6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:35.9575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3XchI7lObSHP1rqzBRUwM0Kcltk1PPJePwjDRRKZgzZDDMRsGnIkW2l6GkacNF0n+1XuDXG8nzgP3lhrW9mSkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRyaXZlciBpcyBub3cgY2xvc2UgdG8gbGVhdmUgdGhlIHN0YWdpbmcgZGlyZWN0b3J5LiBVcGRh
dGUgdGhlIFRPRE8KbGlzdCB0byByZWZsZWN0IHRoZSB3b3JrIGRvbmUuCgpTaWduZWQtb2ZmLWJ5
OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9UT0RPIHwgMTkgLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNo
YW5nZWQsIDE5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
VE9ETyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETwppbmRleCA0MmJmMzZkNDM5NzAuLjFiNGJj
MmFmOTRiNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvVE9ETwpAQCAtMSwyNSArMSw2IEBACiBUaGlzIGlzIGEgbGlzdCBvZiB0
aGluZ3MgdGhhdCBuZWVkIHRvIGJlIGRvbmUgdG8gZ2V0IHRoaXMgZHJpdmVyIG91dCBvZiB0aGUK
IHN0YWdpbmcgZGlyZWN0b3J5LgogCi0gIC0gVGhlIEhJRiBBUEkgaXMgbm90IHlldCBjbGVhbiBl
bm91Z2guCi0KLSAgLSBUaGUgY29kZSB0aGF0IGNoZWNrIHRoZSBjb3JlY3RuZXNzIG9mIHJlY2Vp
dmVkIG1lc3NhZ2UgKGluIHJ4X2hlbHBlcigpKSBjYW4KLSAgICBiZSBpbXByb3ZlZC4gU2VlOgot
ICAgICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RyaXZlcmRldi1kZXZlbC8yMzAyNzg1LjZD
N09EQzJMWW1AcGMtNDIvCi0KICAgLSBBcyBzdWdnZXN0ZWQgYnkgRmVsaXgsIHJhdGUgY29udHJv
bCBjb3VsZCBiZSBpbXByb3ZlZCBmb2xsb3dpbmcgdGhpcyBpZGVhOgogICAgICAgICBodHRwczov
L2xvcmUua2VybmVsLm9yZy9sa21sLzMwOTk1NTkuZ3YzUTc1S25OMUBwYy00Mi8KIAotICAtIEZl
YXR1cmUgY2FsbGVkICJzZWN1cmUgbGluayIgc2hvdWxkIGJlIGVpdGhlciBkZXZlbG9wZWQgKHVz
aW5nIGtlcm5lbAotICAgIGNyeXB0byBBUEkpIG9yIGRyb3BwZWQuCi0KLSAgLSBUaGUgZGV2aWNl
IGFsbG93cyB0byBmaWx0ZXIgbXVsdGljYXN0IHRyYWZmaWMuIFRoZSBjb2RlIHRvIHN1cHBvcnQg
dGhlc2UKLSAgICBmaWx0ZXJzIGV4aXN0cyBpbiB0aGUgZHJpdmVyIGJ1dCBpdCBpcyBkaXNhYmxl
ZCBiZWNhdXNlIGl0IGhhcyBuZXZlciBiZWVuCi0gICAgdGVzdGVkLgotCi0gIC0gSW4gd2Z4X2Nt
ZF9zZW5kKCksICJhc3luYyIgYWxsb3cgdG8gc2VuZCBjb21tYW5kIHdpdGhvdXQgd2FpdGluZyB0
aGUgcmVwbHkuCi0gICAgSXQgbWF5IGhlbHAgaW4gc29tZSBzaXR1YXRpb24sIGJ1dCBpdCBpcyBu
b3QgeWV0IHVzZWQuIEluIGFkZCwgaXQgbWF5IGNhdXNlCi0gICAgc29tZSB0cm91YmxlOgotICAg
ICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvZHJpdmVyZGV2LWRldmVsL2FscGluZS5ERUIuMi4y
MS4xOTEwMDQxMzE3MzgxLjI5OTJAaGFkcmllbi8KLSAgICBTbywgZml4IGl0IChieSByZXBsYWNp
bmcgdGhlIG11dGV4IHdpdGggYSBzZW1hcGhvcmUpIG9yIGRyb3AgaXQuCi0KLS0gCjIuMjguMAoK
