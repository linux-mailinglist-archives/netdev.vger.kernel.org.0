Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9568B1B1101
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgDTQEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:04:33 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:42592
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729774AbgDTQEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:04:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4M4eydqaMyCK/goeNXQ5c5Psu0+7f0hhaX8M4mvMTrsuQus7+oKDtX+m0zg1rpkpR/YMz+OciYLrEWJlMNTW1lFLmD3CTkethW/VrFD83AnAeEXuBnd9XiFZb+lciLbOW9jIZ+P6FgcBLBuq6PxBmW+7Hf24dOiGG1w43oM6lFgfplFS1+OAFwu/7Y3FvxekAIGys7XgS1f58Zh8Re1tYzFb1ZUS6qgOtFDuAZC8DQxdipBFA7Tyw9meqe59mj+nrZzHx3Eir2x76p+/XdV4LsQpz1JoTfPWtrmm5tPatVADNQ9SAIfHSBhVzosMXWAgOosIx5ygJVY3lxOj2oFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GYORL9S6ag8yEDGlBsbGblMNWbfeLXB8ypnNKgy/cc=;
 b=ZNjzvhti9Er1wPeWMaqEDWstKrDjZKPspQn+78Kmc1o3BgZIQYDqMmqNCuMoq/cVjZQFqT1VM5rrhB6P65coZPIt7NzuAnZjH8VKdjgXVXASB6Rmd6W8BvU3LI0Cq4LCw56i8ifgJj4pg8C68DiZpNJCbu9BKNDnOLELpYlwFOsUMtNpCkfpIs67xb85UnR+YsdAYign7APiyPseIf+qG4VX9wCnpzLmN1kEG+iS2g084ivdOqXvVXAyJe+8UocVxVebHD6miHGlmsb/5zHXvklLgqueM+DTNchwNP//HX3oYoPDnadUe0V1pqNJHyqIzvRLIC7XYf48/g0gCanGBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GYORL9S6ag8yEDGlBsbGblMNWbfeLXB8ypnNKgy/cc=;
 b=OAhQ0f3+a5fXftSKoNQ1fZHj/KNw6xXoaCL9Rj3vT8bw55EwVqyPTQF3jsm5NEcPFw6RmH8VRt33Ue9Mx6Y1zgY+NIgBUgr8km5NlGT9+Xmwa229GnwaEeRfbb/t+DGFYYZ3DcJCzRHQmI9BcuGuhLcc9kXQ/2Ut+gO1+KCfvLw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:04:04 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:04:04 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/16] staging: wfx: drop unused attribute 'join_complete_status'
Date:   Mon, 20 Apr 2020 18:03:11 +0200
Message-Id: <20200420160311.57323-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:04:02 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd0b966c-a30c-40fc-d7ef-08d7e544728f
X-MS-TrafficTypeDiagnostic: MWHPR11MB1792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1792D1B76CC36428C522855493D40@MWHPR11MB1792.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(346002)(376002)(366004)(396003)(136003)(66476007)(66556008)(186003)(66946007)(4326008)(86362001)(16526019)(107886003)(6666004)(81156014)(7696005)(478600001)(52116002)(8676002)(66574012)(54906003)(316002)(6486002)(1076003)(2616005)(36756003)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xqp/e7gvyTxWJPzZfltW3oBlzyzGmXe7iCnXCQKeA42uBHd3lU4gnl50yyu79TEKL4jgnWsGaZcTsWGv2Vhm9ODd0ZNbb2TbZQ4Jp5XWBgonoRFS7MpfAGZmns1nNfVqhG9EZ9aLHDpN1nhakRuQAmZ3xALj6L1BC4952+DX4Vm97TavCNzhRDeVaZGMoRkJVD6dIswDdCTHkrVGhviWjngwqtfzJMxaTBtM1+j7LhkCpqMGdnOyjcg9izZpmNdm4zV/O2O1O+qYzY5o0Dted+A6/eEEFlM5iy/iHrC1DDIVN7T3o03BuzjzKZm6CRx1/NyateyDRaO/knerBmyJvCFByn5MpwbLIVdmbr7yuQuf0ULQvzJjb1bH2IkmjaJafEbKByrYd1PNZ8sM9K9NlEXPxxW0jaFxZLPIRoMG99WcrTuU58QiHVOw2Ogd4P6K
X-MS-Exchange-AntiSpam-MessageData: EfOukIfnxptBy3qLWXBoYi+GH+uNviOmdgJJ9qE6NM9+R+4RTiyNPsMrp/P5dGd79NM1Fvvdt4dhvLOImPVtQDA50o9bFfPwyDxI+9ZASOCOWgfCHgYWDIbL+l0SIcthFAzTjUB9tnLWfZvMHAdX96reJoRpqPibwbB5GA0XqkjPAMhQtsD9qq0/fVDe4tonT+CYl2gP9ripZ6+wmmcClDLfygzK926nA0tYkk3yJYWZv2kU/fc++sMrTqz/j4aQ3971haqoIWv3hh21Rsqaf4BQljQm+x4ZEacKFZuOY3a2HfyZsdDdBXhQaRcDeivHaqkjWaQAkppaaj/JNiejv81RgOEC7eaqJ5+VjNYmINeQr4sWwbLICltb8dpVsVrlNReu2cZHaTqC93tFss+6OZ2SWNnldlUlflaYZja+UdLaKe+6Zb5se938+fWeFhz2To29k25+AJyhiZrs5KrZjoKy6le43Ty5MdLuePPgGgT98TR3Uy89tohmuslLxpzkMZhDVl8nkSwcOZCvI6+pa++WYLdj48iMRQVqkKqUueamJps3W07Y0pktspwY4x8VuEKuiRBTpE+3+GBdSWC+1im9qtUb69TPy/2cTEzvwr2RK5y8EiKUXhLz16ifOLrhgtb4+xfjHGQ0d3ygzlz8Wp1d971IS92/WDttjw8f2KUmSfVHHcG5h8W72KD/ZDbcTeqjK4QLkwZJtzF+Xgxwqs9LoLkLTPu6eheGNyWKBUIYRb3TkY3+Vy6iijZEQZIlrwwQVHgoSYfL+I7P6ybSVqT1sG7IUwTDJDjDDGDPcJUW+FFc6koeJHf9JXaFO1f2ClpL0UiwOMNPNOAQrDyxmqv7guZYNUkhODAQuXyc1C4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0b966c-a30c-40fc-d7ef-08d7e544728f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:04:04.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wOmbIbVLCI4U+GdrrwYGebjUMCCViDwiCtSo/vkj+x9KSYSvHFL5hNSOxfYS+lYtoA3xdjgcfJMLUCizRNynYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIGpvaW5fY29tcGxldGVfc3RhdHVzIGlzIG5ldmVyIHJlYWQuIERyb3AgaXQuCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDIgLS0KIGRyaXZlcnMvc3RhZ2luZy93
Zngvd2Z4LmggfCAyIC0tCiAyIGZpbGVzIGNoYW5nZWQsIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKaW5kZXggMWU0M2UzYjY1OTUzLi41ZDVjODk1MWY1MGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMzYx
LDEwICszNjEsOCBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZikKIAlyZXQgPSBoaWZfam9pbih3dmlmLCBjb25mLCB3dmlmLT5jaGFubmVsLCBzc2lkLCBzc2lk
bGVuKTsKIAlpZiAocmV0KSB7CiAJCWllZWU4MDIxMV9jb25uZWN0aW9uX2xvc3Mod3ZpZi0+dmlm
KTsKLQkJd3ZpZi0+am9pbl9jb21wbGV0ZV9zdGF0dXMgPSAtMTsKIAkJd2Z4X2RvX3Vuam9pbih3
dmlmKTsKIAl9IGVsc2UgewotCQl3dmlmLT5qb2luX2NvbXBsZXRlX3N0YXR1cyA9IDA7CiAJCS8q
IER1ZSB0byBiZWFjb24gZmlsdGVyaW5nIGl0IGlzIHBvc3NpYmxlIHRoYXQgdGhlCiAJCSAqIEFQ
J3MgYmVhY29uIGlzIG5vdCBrbm93biBmb3IgdGhlIG1hYzgwMjExIHN0YWNrLgogCQkgKiBEaXNh
YmxlIGZpbHRlcmluZyB0ZW1wb3JhcnkgdG8gbWFrZSBzdXJlIHRoZSBzdGFjawpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgK
aW5kZXggOGQyOWJmNzdjZmVkLi43MDZlOTVjZDEwOTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtODIsOCAr
ODIsNiBAQCBzdHJ1Y3Qgd2Z4X3ZpZiB7CiAKIAl1bnNpZ25lZCBsb25nCQl1YXBzZF9tYXNrOwog
Ci0JaW50CQkJam9pbl9jb21wbGV0ZV9zdGF0dXM7Ci0KIAkvKiBhdm9pZCBzb21lIG9wZXJhdGlv
bnMgaW4gcGFyYWxsZWwgd2l0aCBzY2FuICovCiAJc3RydWN0IG11dGV4CQlzY2FuX2xvY2s7CiAJ
c3RydWN0IHdvcmtfc3RydWN0CXNjYW5fd29yazsKLS0gCjIuMjYuMQoK
