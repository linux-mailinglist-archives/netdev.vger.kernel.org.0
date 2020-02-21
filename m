Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B321167CDB
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgBUL41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:27 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728169AbgBUL40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJRmu0D2GHFDy7DxV77Wt4tYKayZOez9yDASDiK6sIBYSHPrx1Fr/YaAOtUu4uzfw/2qgxVKFLdeCAJOzyO8QvW7zwWq0UdjpL4Jrkty314eDzGr/2jF3CjVtxez2zmJiaNmhFvse1muduE9hlPK/dmpmXcnMQWU29hYEBSYdZQ8Gw1UtOxUEm48TGhCcGXcxDhZjIfgBvJgIpF1SlvvJYSRNNVK2Cp7Id9bhOnOeLe9wk+gYlGxqhs14R6H4l1d301HEGoJjQvOD5S6pFCNlM1VyRWJ7/JDz8j4GZfLFA3bYe0IvDcEaa/No4Z/KF37WiRNg07BiZe90HSICEyIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgZEu6SOjrIS02joqzkzqXBwcQvShDkVhZXDHfGOk3k=;
 b=AkR2laGbVS+djmQMrh3UDB57TjS57X3e6fIIPAm33Mu1jIbnDA1dBsPhJVHt+5C2uzN/GAv70hm6qmpqmnl6LsU20gDuaV9vpqJk++eXJq5QiXqgs6YtTF7CurQxwPFgO3MPnsCy3iINdtzKzZF7CpufhGX7L5vXYjugGg7kU0kMsDIf3RnYOnKLxnKTip7PvDWcW1uU4UNhuVr+g6C8/q7/eqYddHb5N9Hb3JmRZBu232sdpf3HSwn5F0cI6uIqh3ImMiIthTJ1WN7qgAiV27tHt3SM265/XVM0EeNfFIm8OT1HSmj6woxwg8V1VMmAuVYlim5PHd2Xn3813ZGyHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgZEu6SOjrIS02joqzkzqXBwcQvShDkVhZXDHfGOk3k=;
 b=p7ni4fWq1owWWOaFq+d4ABSc/Yvlj7sV8byYbyPRfu72FOsiRC25l/4nLY5TNNbKNTxj09NnpVJA4etMAhb+V1PkvUIWPZ0Iv0XRHXv6eJPZFUd++TiXdJ1d88WWiiRtlpdCNmfl5Q2b1qfaibYSElH8dH7vgo4tyv05RsvMRzs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:23 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:23 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/10] cfg80211: drop duplicated documentation of field "_net"
Date:   Fri, 21 Feb 2020 12:55:58 +0100
Message-Id: <20200221115604.594035-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:22 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8db252d-5d14-4439-fcbb-08d7b6c51276
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB466266416B709BC9A9FB0C7493120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(66574012)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(4744005)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dIWuxKIWfs373TIwXktLiYJFyUiR9JtP1JwR4zntg2PC83fpcnD3NJIygO1uxsxOX/FWGbcQEgb+zYFFntgbdzo1D+sZQLxLSt8nWrQJyb2lFHgqCk7o87bNz2gwbqJke+9jgtw8eVg0oz2Einc4gZxXNyzumL3vROhfCsN4fND3d2ywRyAXxIqB084/k15XuFvUzAaXA17z6myURVGMgxm2337ANpDO17Menw/WAaddjXFDdbKLlMkVyAObPx/BsQoI81ePrptlU7KkyirY2P7DlqFSAw+YCs0oVO7sh5PdnrR2dP9Ntaj4EQFVLLqd0Mg0e2blbS4a5Ueg66Mrma201Qxlus6JuVD4swoboM2JvC8KPzhblHmF66n78zuVqEvgZnrqLMHPYMTba+xaiAC1UGK210WDY+YQhqLbNZvGs76etMJTD6zC1PBIxVO5
X-MS-Exchange-AntiSpam-MessageData: IQbNJ8Aj7/sJTZZcmVRBny6qv/0J2XwZweVg6fLXepVHyGeSbDB7lHotFlO/fHnJ4EBFn+hDdJYrJb+QEUcn8/T6tRZTeTDcQ4ko5+KdGQWuxqSF6h9N1zO4tlVeJUHFX6+Wun5oGCxqRqZxSHCbIg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8db252d-5d14-4439-fcbb-08d7b6c51276
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:23.3493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9jO7sX1yRyAphT5wrmK/dgvNz5PXXQ628/OW45t4qARC2WeXjip0aHqvlQWymwEoyh6X0mwWBvX8rZh7LQ2og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJfbmV0IiB3YXMgYWxyZWFkeSBkb2N1bWVudGVkIGFib3ZlIHRoZSBkZWZpbml0aW9u
IG9mIHN0cnVjdAp3aXBoeS4gQm90aCBjb21tZW50cyB3ZXJlIGlkZW50aWNhbC4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBpbmNsdWRlL25ldC9jZmc4MDIxMS5oIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2NmZzgwMjExLmggYi9pbmNsdWRlL25ldC9j
Zmc4MDIxMS5oCmluZGV4IGJmM2JiMTI2NWJjYy4uNTljODEwOGViNzU2IDEwMDY0NAotLS0gYS9p
bmNsdWRlL25ldC9jZmc4MDIxMS5oCisrKyBiL2luY2x1ZGUvbmV0L2NmZzgwMjExLmgKQEAgLTQ2
NDksNyArNDY0OSw2IEBAIHN0cnVjdCB3aXBoeSB7CiAKIAlzdHJ1Y3QgbGlzdF9oZWFkIHdkZXZf
bGlzdDsKIAotCS8qIHRoZSBuZXR3b3JrIG5hbWVzcGFjZSB0aGlzIHBoeSBsaXZlcyBpbiBjdXJy
ZW50bHkgKi8KIAlwb3NzaWJsZV9uZXRfdCBfbmV0OwogCiAjaWZkZWYgQ09ORklHX0NGRzgwMjEx
X1dFWFQKLS0gCjIuMjUuMAoK
