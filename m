Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F297E167CE2
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgBUL4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:42 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728402AbgBUL4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjD/byT3ORUUVWOVZd0qupXFGD8HX6rr8Nm2m7RawUX7VVIdf4mb5VapXcRTCmQugv75wzD9ufSYzStpRENMQLKJAu45WFhGcoTuiKH6ocIliYXipUsWnHynDL0hKBGRSXpFQrgW2gg0+Y0Cu2w/3Ww5A+/kNYTlpHw2Db4S9KjCRoGZcyc9OYaVJaAz2UVgqTe9pviVWoa9skxeMWbqwqVoDAGtZ4UarhQmqNgVNLZRPHLstKHoHBMg7avlX4+zEy455Z9AjAOkfE60l7uoZUW8f3D0YcTkvZPvrmDsAAQCAk71DytGvwYIVMril9PbA15bT5lvvP1VEqLVjxRecw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4EKUJPX9obZgtKM8OhTxSqHaziNmxhAn5WQQikAAco=;
 b=ZN5010TRrV05aguROJsoo5iLqh12NdvF4eRywIdLFHCfiVuc0zu3tF3jxRnp5duFkYeCuxqBtS7tq5rlKXqAzIZWU3+uvz4mwdcSKD6u8NrmBl1qkojj+dMw2e1j7j/2Yjfq6vijh4HlwiExha+IwYcCpsGzusAhCiKJoBjTOdokmlf6kiFojVqWH94DD9oaTB5Fet5HNeMEqsTtzR+KaEBpT2thEvHhuG3O+Ni/riOMvzsZywukLiKhyCNZw0LOfDdNjQ4du/Ef6ZXlqt89wUfjn4T0mpDq14iJSSXvA0rY90UH1ZWepSNhGj5t2BePdWEdPvKtrZXvGTkD+US6YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4EKUJPX9obZgtKM8OhTxSqHaziNmxhAn5WQQikAAco=;
 b=WjdLhWJASzot0Ziz+snQmDu0mPLue3Kjoc8CrHJ4hQNac0j3XfuRiPyQXWqBLfpHFa9yWadjmYWtg2LQ4f8I+goIa/3Wd8GnW3L0shI601BXoCFcS7q9X2Yl6IRi778SWM7m7pI7tyhRNlZboJlDCCLa38JYZGANCQT9+7qByKI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:28 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 08/10] cfg80211: merge documentations of field "dev"
Date:   Fri, 21 Feb 2020 12:56:02 +0100
Message-Id: <20200221115604.594035-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:27 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72ae8e18-5a4a-416a-3613-08d7b6c5157f
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4662A993E602E40D5D6D0F1793120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+/tRUmgG2RM2VuXwx1hoHGvERJoO4x+ZUWStEaQJZJYDTrh7+Wl72VlcQibl+b5ADdPP/aCwrQBmAZEuxrqj++LvOP8gUJbRDR5wsSk7rU4Mng0TUCGWs5RPTXhtEZJ6ImP2xNrop72PAosg+nPds9umKbtmmwgCw4/NIhC+0FXQk0toa4FRPDlI/LDdNJKIc0CRCsw5bg95rM9CmxHYudpOBTL8yNIXYoCrVbrX2/+WT68qS3CcifROUAmbc/k0bsgU6Mdm0/LJvzw7VUgZwlF0GZffIKyN6ab8Y18U13yninJ2Z5baWBQGYTQTZE8PLOPWeR7OS1KA9LUAfH2TOItdDedwV2qGXp3zEvbes2x0+ONC2aa4y5rEn4baFzHn5i1w01htk5arrv5DUM8LJzjOA9e8RgHBs+r3B7Tt+FR+aN0VnhwMpd1w6HcR4Tk
X-MS-Exchange-AntiSpam-MessageData: UJt/p91umNGnkCdqob6u/0L3YkpGF+pBcrVpNPCL/HVlFlKFyBKuwTABCUnc4NqEDGgDwY5acrEP4dOuwrj66EPzxvo1Hbdap4Bn53zX00JbGKXtd+QPB7tSBfujqCxGSNAxP4pyXDvkrFqt912C5g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ae8e18-5a4a-416a-3613-08d7b6c5157f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:28.3284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEZAaxsQ95rndnN48HXiQDWbiHo3Byhu+wwioyQ7GNc4tBq5nTjzSRKbhs6NnoZ49D7MxYS3JEvZBtCnVZGhpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJkZXYiIHdhcyBkb2N1bWVudGVkIG9uIHR3byBwbGFjZXMuIFRoaXMgcGF0Y2ggbWVy
Z2VzIHRoZQpjb21tZW50cy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBpbmNsdWRlL25ldC9jZmc4MDIxMS5oIHwgNiAr
KystLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaCBiL2luY2x1ZGUvbmV0L2NmZzgwMjEx
LmgKaW5kZXggMmJiOTYzZTk2YzMyLi4xY2MzNDQyYjU0MGYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bmV0L2NmZzgwMjExLmgKKysrIGIvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaApAQCAtNDQxMSw3ICs0
NDExLDkgQEAgc3RydWN0IGNmZzgwMjExX3Btc3JfY2FwYWJpbGl0aWVzIHsKICAqCXVucmVnaXN0
ZXIgaGFyZHdhcmUKICAqIEBkZWJ1Z2ZzZGlyOiBkZWJ1Z2ZzIGRpcmVjdG9yeSB1c2VkIGZvciB0
aGlzIHdpcGh5IChpZWVlODAyMTEvPHdpcGh5bmFtZT4pLgogICoJSXQgd2lsbCBiZSByZW5hbWVk
IGF1dG9tYXRpY2FsbHkgb24gd2lwaHkgcmVuYW1lcwotICogQGRldjogKHZpcnR1YWwpIHN0cnVj
dCBkZXZpY2UgZm9yIHRoaXMgd2lwaHkKKyAqIEBkZXY6ICh2aXJ0dWFsKSBzdHJ1Y3QgZGV2aWNl
IGZvciB0aGlzIHdpcGh5LiBUaGUgaXRlbSBpbgorICoJL3N5cy9jbGFzcy9pZWVlODAyMTEvIHBv
aW50cyB0byB0aGlzLiBZb3UgbmVlZCB1c2Ugc2V0X3dpcGh5X2RldigpCisgKgkoc2VlIGJlbG93
KS4KICAqIEB3ZXh0OiB3aXJlbGVzcyBleHRlbnNpb24gaGFuZGxlcnMKICAqIEBwcml2OiBkcml2
ZXIgcHJpdmF0ZSBkYXRhIChzaXplZCBhY2NvcmRpbmcgdG8gd2lwaHlfbmV3KCkgcGFyYW1ldGVy
KQogICogQGludGVyZmFjZV9tb2RlczogYml0bWFzayBvZiBpbnRlcmZhY2VzIHR5cGVzIHZhbGlk
IGZvciB0aGlzIHdpcGh5LApAQCAtNDYzMyw4ICs0NjM1LDYgQEAgc3RydWN0IHdpcGh5IHsKIAog
CWNvbnN0IHN0cnVjdCBpZWVlODAyMTFfcmVnZG9tYWluIF9fcmN1ICpyZWdkOwogCi0JLyogdGhl
IGl0ZW0gaW4gL3N5cy9jbGFzcy9pZWVlODAyMTEvIHBvaW50cyB0byB0aGlzLAotCSAqIHlvdSBu
ZWVkIHVzZSBzZXRfd2lwaHlfZGV2KCkgKHNlZSBiZWxvdykgKi8KIAlzdHJ1Y3QgZGV2aWNlIGRl
djsKIAogCWJvb2wgcmVnaXN0ZXJlZDsKLS0gCjIuMjUuMAoK
