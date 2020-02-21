Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943F0167CED
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgBUL4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:37 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726909AbgBUL4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTIx8Qr42DigOgQi1lwjJUTNXCdTNtP7/QD0LSqW/DlyFnv2rlI4h73b7TUMYFBXkMGKTPYctoV3hu3xrzmYddS1K5N6qzR6ytEbNVPtBVYILlaYSl2cfYYFHyRoeP8hrkgabne/FOckUN29HJN6RVMqdkF6Abmmt37/CwPNGgsW9kOXzoHu4ah8STLqpJUetY1aYJHGbcIDF51u0//KVXxAknKau/SKwbkG5zpLwoOq0mGQh4YTi5L0JuaBsXkr7XmUyiImZE0CcGmvXKRKWhe1BPt9FX/EUiy9OyEXWrdSiHeoJmuBi/vuSYGScaudKYT9XkwSgoRcem5LEGEaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGJhOZFp97GgwebMiHdV78wFkUFU3J7N5KhntqyeYnw=;
 b=AGUapOGgHcAroiQCWN2b1qUqdVcW8MG7Ejpd7LQMtQ8k8FBWXjXo7F8tbnzTlhXJ9vCqAtIQKTzCrkna+FfMF2JbH7QPfvB5D43uUdVS67pIsPPmncnBjB4bfqPRGdNAYdXOmwkQWNSG8Ok5FkPCZhzYHUEe6rmDGMLfrvcwWUPhxLZptCsL2T51iykRTbpe49STARBTAlKnNY/kDZWOV73nsPkv3XHqlAxu2s/IU0WzmTVqtKoXyXwiI42fW2iz5ad7Uxo5UexIeHgdLer1UEVRr/N35k1iry3bWd/GoaQQPqK1paN4ELs2hlOVmMmG7TanvyvMWyEskGyNtsOHTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGJhOZFp97GgwebMiHdV78wFkUFU3J7N5KhntqyeYnw=;
 b=H3q6x8XgZgnnrd8TjzCGzDqz7RMDP0cYQ5J41MNrjq+hCXUwQB8a98mZYewxNwRev7SHbCkTI+f/29Gqf2PEOoAXUq3e7DCyX3tzOfL3hSlfyZ1GkAvWGsfv/+Zw1uhSmy9idWfaoYrq/anHJRKsIA2QSGUx/HEjGpJ+BG/DPeU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:27 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:27 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/10] cfg80211: merge documentations of field "debugfsdir"
Date:   Fri, 21 Feb 2020 12:56:01 +0100
Message-Id: <20200221115604.594035-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:26 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e3fcda7-9592-40d9-9577-08d7b6c514c9
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB466204B7B8C4ABE4085F38A293120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(66574012)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfkQyYDntRAJSrg6qMnMCljSbcEcCqDRrDLM/IOhA0tvcPgawJCZ/aL7KiYx/mrEbC6AkW3uMOtBrxiywcE2yzsyrdEzTFQiOGg2uMJAqO5p06+g3zgkNANCApJvSzbeWOH6NjkuzylafeCa+//5RihMtl7GQ0bHVfQTQQQnNLZLpwN/GKmAeLtC46mHMyLWqNVRByoGkjSPZAO5hoF7hCXvwcQHlBfpwsxcUMFveF2OdL2W4aRklFitRPlL96TGxqR3mXRk+0AYUrj5KyhL3aqCkB4JEj+yI4OiFmDCZJj0b+CUn0rNXEwC+YflOKwrQoMo7YucaKLG+xRBg8ZN7T9d3Y/7LwSrMCpAF9YY0Q79yaq4F+Nq/YL4q1DR3OdMF4VGT+iUKY4TxHkrtz/lEs9u+uwmnA+yfEnPAs/eUtq7UjdVL3tZDP00DySIhnOb
X-MS-Exchange-AntiSpam-MessageData: +2yEek0K8GJ0y7CD1aGi16b6N/y/5X5gMzuFNzobNmjwY0SL/165a3EwUdjySCNu+VZydj6RoSt8hBLJqFKKmR6s3zVGavz55eIip+bzONxEvnxvV1q5m5H1jHSfIfy/l2pqs5OZ35y+lzQj3obNKQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3fcda7-9592-40d9-9577-08d7b6c514c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:27.1341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/GCA8ZGyXUoE4E+qrI5vEVvSJkBzXH9koCyQsvzrM7ILChwCW5XDjRe7sBqFu8ZM5iJRS0Ab8HmFwkYeX5TxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJwcml2aWQiIGlzIGRvY3VtZW50ZWQgdHdpY2UuIENvbW1lbnRzIHdlcmUgbW9yZSBv
ciBsZXNzIHRoZQpzYW1lLiBUaGUgcGF0Y2ggbWVyZ2UgdGhlbS4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBpbmNsdWRl
L25ldC9jZmc4MDIxMS5oIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jZmc4MDIxMS5oIGIv
aW5jbHVkZS9uZXQvY2ZnODAyMTEuaAppbmRleCA0YjA4NzFlY2E5ZWYuLjJiYjk2M2U5NmMzMiAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaAorKysgYi9pbmNsdWRlL25ldC9jZmc4
MDIxMS5oCkBAIC00NDA5LDggKzQ0MDksOCBAQCBzdHJ1Y3QgY2ZnODAyMTFfcG1zcl9jYXBhYmls
aXRpZXMgewogICoJdGhlIHNhbWUgbnVtYmVyIG9mIGFyYml0cmFyeSBNQUMgYWRkcmVzc2VzLgog
ICogQHJlZ2lzdGVyZWQ6IHByb3RlY3RzIC0+cmVzdW1lIGFuZCAtPnN1c3BlbmQgc3lzZnMgY2Fs
bGJhY2tzIGFnYWluc3QKICAqCXVucmVnaXN0ZXIgaGFyZHdhcmUKLSAqIEBkZWJ1Z2ZzZGlyOiBk
ZWJ1Z2ZzIGRpcmVjdG9yeSB1c2VkIGZvciB0aGlzIHdpcGh5LCB3aWxsIGJlIHJlbmFtZWQKLSAq
CWF1dG9tYXRpY2FsbHkgb24gd2lwaHkgcmVuYW1lcworICogQGRlYnVnZnNkaXI6IGRlYnVnZnMg
ZGlyZWN0b3J5IHVzZWQgZm9yIHRoaXMgd2lwaHkgKGllZWU4MDIxMS88d2lwaHluYW1lPikuCisg
KglJdCB3aWxsIGJlIHJlbmFtZWQgYXV0b21hdGljYWxseSBvbiB3aXBoeSByZW5hbWVzCiAgKiBA
ZGV2OiAodmlydHVhbCkgc3RydWN0IGRldmljZSBmb3IgdGhpcyB3aXBoeQogICogQHdleHQ6IHdp
cmVsZXNzIGV4dGVuc2lvbiBoYW5kbGVycwogICogQHByaXY6IGRyaXZlciBwcml2YXRlIGRhdGEg
KHNpemVkIGFjY29yZGluZyB0byB3aXBoeV9uZXcoKSBwYXJhbWV0ZXIpCkBAIC00NjM5LDcgKzQ2
MzksNiBAQCBzdHJ1Y3Qgd2lwaHkgewogCiAJYm9vbCByZWdpc3RlcmVkOwogCi0JLyogZGlyIGlu
IGRlYnVnZnM6IGllZWU4MDIxMS88d2lwaHluYW1lPiAqLwogCXN0cnVjdCBkZW50cnkgKmRlYnVn
ZnNkaXI7CiAKIAljb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2h0X2NhcCAqaHRfY2FwYV9tb2RfbWFz
azsKLS0gCjIuMjUuMAoK
