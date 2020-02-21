Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BEF167CEE
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgBUL4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:35 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728169AbgBUL4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3gOF1AIO8RWLuqKntkIijA15gaTdjTelTixBs7e0Io4ehjrotvzC2WJ84btfN+/ZFJanZZfhzzdBgqP0tP5QLRmsiGiolK8ItFbwMb9lrruE3t/yChGzbde4LhHErXH3WVx6g8z3CUYGfjX7t0nDI//5D5Fppv51Zx9HTab3QetqL0M8dhBYplBxc5CZs92NkhRcGrCTqaCYeyHt5uUakam/LB9owX1sm2jxHwOg3H6H4cUgH8g2OyAupjEr1Dz2soQXHCoEc61gcRftrsQLIqH735gn6WbxwvOcaO0g5v6KFztS5+cScoT8EfFOT6TyLj2n+rrBxDy1MJjWfYJWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oEHy5RzBsie/+BANuShHM88zZuWY9srO1+uwogdjTA=;
 b=S8E2pKSnlbVH0lQz64Ms/jPQj/UOZv0fxUtCXY7VzuIogOwrzZvCI4LXmZQreBUiRO1W3TrDPxcC3ustvTMJGLoLF6qpg4V6Kvrhv9pZBrq7dA5BbXlY1QAEA2+gTb6jQ3ZZ5/0+cRLxxFDQef0WJFiyvkFEkR90uHHOrl2GkTZC3AcQANk4ii7b4zCk1PoETpF+K0Qjsa+ittbBUeEw6l/zRvybZczBmk+tyywYUSJNUg1xb4Y9MQft5MW9G+jJ8ADlPVJ/jEn0UTLr3NYKpjrFqrKebL/AGxJjVGGcLOisA212/nkxCSQ6VBlx5tMaaY3r83rtyYCx8nPLpiozAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oEHy5RzBsie/+BANuShHM88zZuWY9srO1+uwogdjTA=;
 b=YxWbUEM6dT7F2nFpzuaMfelPmhb6tyVwabXB3ttlWO+iJOutx+TbaZ582Ju5qIx9IVhJK2x3G930Bfekz1u6dBDQoB6/GF989E2vD5hEqTSKO2ezlPSkKraOegbz9Sgi+ARjrSuARnM4jOfRLx+xwGizxvpiSrOPGJoM8ipghek=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:26 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/10] cfg80211: drop duplicated documentation of field "reg_notifier"
Date:   Fri, 21 Feb 2020 12:56:00 +0100
Message-Id: <20200221115604.594035-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:24 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c77adc62-e0da-4e2a-66d3-08d7b6c51404
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4662298B4281492DFED54C5993120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(66574012)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(4744005)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D22Sv5bEA4A8TS7T+tg7SNrDb2sHV5+tyOnCjLKUdm3ppGfzeYsaq70oL74M1j3DuBHCxsuwFEqNrhOPL11OzzBqPf4SJTn+DX7lR8U11hCfifUeZnSS5GteKvjSCUH9Cj9aeLRAibG5GJ089wYnqdKxng8IMQmnJPn1pkhVDLyv2SVISC4jHVgMD7TgKDwZky+Ak7WZxb6D/5NE+RZi971AHQwLUDkJr5Qo9wRfmmiq+MPDXDniom713iXEbzRpkfubRV+CDuN1+oDOVjnzP8JOxuqBLAep2Bpb/RGsLVqIINfUXYzDQ+WADIv4H1m43Q9WLMJr04O6fB3bfregdlWgEMVNwY6bA3x2jtZk2szLC29IjIaSjVy1eBxzwsxZ3phi7Ph9OYAWJ6HXdwNmMTrFbwR0Yztx6NADnHyfyOfYhviykMyvAqd8n1RVqacp
X-MS-Exchange-AntiSpam-MessageData: eJLJKqqvBblMelDLnV6K90UI3p+7dypK+Yy6j2wIA4voYR9rbHJcDWqurCXN7UkGpgNlcCmaRPFWMooBJq4b4D6fufWah+Jv2R3nQetEpv9HMiaC1Tv/TwhTenio9rVPNyLTeZegsiGenuRT8scGdg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77adc62-e0da-4e2a-66d3-08d7b6c51404
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:25.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZUKDpaYWEpnNLTfa3NEJD8TYL0h4RSl6ykvsvjMZqCSRWrMFEWWEag7wXPdsynXcA8HM5vXVcZHL1iYU3GVcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJyZWdfbm90aWZpZXIiIHdhcyBhbHJlYWR5IGRvY3VtZW50ZWQgYWJvdmUgdGhlIGRl
ZmluaXRpb24gb2YKc3RydWN0IHdpcGh5LiBUaGUgY29tbWVudCBpbnNpZGUgdGhlIGRlZmluaXRp
b24gb2YgdGhlIHN0cnVjdCBkaWQgbm90CmJyaW5nIG1vcmUgaW5mb3JtYXRpb24uCgpTaWduZWQt
b2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0t
LQogaW5jbHVkZS9uZXQvY2ZnODAyMTEuaCB8IDEgLQogMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jZmc4MDIxMS5oIGIvaW5jbHVkZS9uZXQv
Y2ZnODAyMTEuaAppbmRleCBiNWY2ZmU1Njk3NGUuLjRiMDg3MWVjYTllZiAxMDA2NDQKLS0tIGEv
aW5jbHVkZS9uZXQvY2ZnODAyMTEuaAorKysgYi9pbmNsdWRlL25ldC9jZmc4MDIxMS5oCkBAIC00
NjI2LDcgKzQ2MjYsNiBAQCBzdHJ1Y3Qgd2lwaHkgewogCiAJc3RydWN0IGllZWU4MDIxMV9zdXBw
b3J0ZWRfYmFuZCAqYmFuZHNbTlVNX05MODAyMTFfQkFORFNdOwogCi0JLyogTGV0cyB1cyBnZXQg
YmFjayB0aGUgd2lwaHkgb24gdGhlIGNhbGxiYWNrICovCiAJdm9pZCAoKnJlZ19ub3RpZmllciko
c3RydWN0IHdpcGh5ICp3aXBoeSwKIAkJCSAgICAgc3RydWN0IHJlZ3VsYXRvcnlfcmVxdWVzdCAq
cmVxdWVzdCk7CiAKLS0gCjIuMjUuMAoK
