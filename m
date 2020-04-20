Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DB1B10F2
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgDTQEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:04:08 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:31360
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729267AbgDTQEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:04:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVDZDeUmSJ5poq0mihgEg+1gY5DhncTxb3B86946yRAN0/6N8Piy0DjU1lzrcWjk98enTo3Z+9WOpE3ugXH9pCJ5LfMUTT5/7m3Tit0bxB4YBPA7y/yd5RTOTpw8luTWn/BSDq+2ynfr7IaXeDBCkG7td1cUSlJBvRZ15kiPZcPKymr6jJ3bvU6kkpumshvhOrL/5ZrjlPoZk1QgN0wnHxxHatL7faHHIq0Z4TBXu2QvQpWtXKYQA5OZbnTaoWsUoGNT/H0vWyQSOEaOsg030GEWeY/uw1rIPHg08mTyHpFY5yYE/hAc8s1jmhRV0Eb81wodr9i250IGU36g6Oy3zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw7T7f7hrYyhFdaSjG4PdZOKuWDOeu/vP9hEhfuhEI0=;
 b=VMVyXqVkSGh+oLy0dIvq0QhmwpEiJYn6187Bkg312ucu4M1Rm9YaGULolLcwlyjv8uj5z+YsEwTixh9eXSWGc6fe5XT1gniK9/a+w9YXK408XHY268zZRsTispD0Jw+NdYOv/+aXGz3VoEvt50EBvN0z9JKJcslf38IvnEqXsfhxW92elgJz8FhQvvwIFt1qj2BpoYDQlrXAsBk1vMz0Fza0c4qxOFm5vVljDEN5/jRSjnSg2MjjM9t5yWTZ/qUPcPbb0B3TT5gwkK2FQBzwdmfzgh69WPkll1mcWi2H7f8uC5OgdqD6d9jc66gp0UkZuEnGDDUjKOa7SMLm7m8vjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw7T7f7hrYyhFdaSjG4PdZOKuWDOeu/vP9hEhfuhEI0=;
 b=BkC5wilFV6zmf2IVhLn/H+qKcbne8ZDJUQtz3GN3UzvKzyuqoTH8Og+o+eGAMgpf32+PwDHHnm/oVRdq+YEi7ptvsWAEpne0ps0kYVbqJBODOnQ5fraFcglB9qacBU6AzvNXaeqTZmEsVhe0EvBqVRpbiqYQZFAnHfAiun0oKFg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHSPR00MB249.namprd11.prod.outlook.com (2603:10b6:300:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 16:04:02 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:04:02 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/16] staging: wfx: drop unused enum wfx_state
Date:   Mon, 20 Apr 2020 18:03:10 +0200
Message-Id: <20200420160311.57323-16-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:04:00 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8a2d833-8262-4d8d-9778-08d7e5447142
X-MS-TrafficTypeDiagnostic: MWHSPR00MB249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHSPR00MB249BFADB70A16565D2C357F93D40@MWHSPR00MB249.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(376002)(396003)(39850400004)(346002)(8676002)(7696005)(52116002)(6666004)(4326008)(8936002)(81156014)(66556008)(66476007)(66946007)(36756003)(186003)(54906003)(16526019)(107886003)(478600001)(2906002)(316002)(66574012)(1076003)(86362001)(6486002)(2616005)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h8IZj19/0+6c/gFh+Rx2c0TtaKOTPzb53MmWme1XqqKnkRLO6TfQ1zQdkbw/CIgOe35BdG8X1rjAZ9wiMl7ruvL3J0mCPVt9KA3mcLEo1Fky9AjjcmUwZe2Y9VRghySXlxDae4ChozEik+PZ905jaU/T/0T+HVtmmBCrVbNl0by7k6waanmpPJXusmO6Y9WPCUsOaFAxvoBWt2W5ju6XK5c9N9rzEQrrmPYG6456uLUEBu7b9irD93lWFVDQGb/5ehoaxjaIAKxu6XPIaHF1q+HJ+r7v5vFMG76cMF/pYUKDBq6AeiMv1cHv2rILROrbGtMEUrlvFrqW6sT7sneOHwckGRY39Exaeb1Z9Ds4y0XpebkUPU3FYCqbqSoNCxBSPXtvvTo3oIDaMAm6avE0ENWTRuce1bNTWqdVqPhov/skBtVjhocl24cBdD6eI7vi
X-MS-Exchange-AntiSpam-MessageData: kQaYB5HBm2d9CZrVnEOv0vtIgA8eqytEaJD7pbRSdA9y8PWfQhfLsAeYUHB3J8dldSiGX/PE0xjt5XrLG6gH9faYguliARnl3mLDvj3t67UJivkF1D36Ha0IPJztI9eCd8v7GSj67zqm9i04GF/jBLn3WSDgPZltxGhLtEF382K02FKld8sj93hC4P+7ZnLdhu4TeFqet7Rrqaht6PcTptXN3xIupLOyuhnuQJCea+NxRUb7cy/RbSb7Ns3xyhIID7GEJzD01U13OMjDmKkjOyGsst5ow0X9FdyTjZwpWq1Xb1ROdrE9mG9VzBBl85vUOMvl89hcjIaVzIT8w8B/k5tUC6yvC+TdQkzNWhnFUQYy1bkPGzArFXyEg6PYGEDJ1AWmG6Y1wwnYxw9iu9pZ/Ct44AfMofBKuXRI8ymKg7rnUSjRSBIu0aKqMIq8UxVACrbc81+LbsdPMjMEZK4nIJScW7Gmx60EGkUt160sV2NLVv6zM6xeIm/vPf3hjWhfLj1lNHawqc/P1aKBllK5hlFWzsbClcg4Hs0QTwpvhNDsdsMvRSxAVhuy45A7vN5tL9Go5gE38wkwpBPcmObi2Cbuszv+vpW9TgNgR+SGdngTzNMC0qr7ohGhPiGjp+HRHwBmQEMfGvb6miyPsywVsYfRsvxAFnvFcUDNAV5xxrg4NNDyef7PFqsUgg45HSKdCRQnSl6EcZhHSMv37l74bgcLObYA2RoyWATXrRD9clq022yQs+JHxEsqVjq5k0zN9eAPENrXXN2G8di62jZHJRCcEFRjTMg6/7TZX+3HipgqJWF1glwDwnTTMVBPUl66kVKKC6Bxvumm+cSIVwHCkAvp33JrOfiaOSl3wVPGwNU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a2d833-8262-4d8d-9778-08d7e5447142
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:04:02.0099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5UrRqeZaJZ+hhUDmnKY/5V7FF9AiYVCV8Cc/G9xI3FpXydHy3dQ3H/W+qPT4ih/eShrpr8nA3AXdd39YEw45Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
Zm9ybWVyIGNvZGUsIHRoZSBmaWVsZCB3dmlmLT5zdGF0ZSB3YXMgbW9yZSBvciBsZXNzIHJlZHVu
ZGFudCB3aXRoCnZpZi0+dHlwZS4gV2l0aCB0aGUgbGFzdHMgY2hhbmdlIGl0IGhhcyBiZWNvbWUg
dW51c2VkLiBJdCBpcyBub3cgdGltZSB0bwpkcm9wIGl0LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgfCAxMyAtLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5oIHwgIDggLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCAgMSAtCiAzIGZp
bGVzIGNoYW5nZWQsIDIyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDE3MzJmM2QwYTFl
NS4uMWU0M2UzYjY1OTUzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTI4Niw4ICsyODYsNiBAQCB2b2lkIHdm
eF9zZXRfZGVmYXVsdF91bmljYXN0X2tleShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIC8vIENh
bGwgaXQgd2l0aCB3ZGV2LT5jb25mX211dGV4IGxvY2tlZAogc3RhdGljIHZvaWQgd2Z4X2RvX3Vu
am9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHsKLQl3dmlmLT5zdGF0ZSA9IFdGWF9TVEFURV9Q
QVNTSVZFOwotCiAJLyogVW5qb2luIGlzIGEgcmVzZXQuICovCiAJd2Z4X3R4X2xvY2tfZmx1c2go
d3ZpZi0+d2Rldik7CiAJaGlmX3Jlc2V0KHd2aWYsIGZhbHNlKTsKQEAgLTM2NywxMSArMzY1LDYg
QEAgc3RhdGljIHZvaWQgd2Z4X2RvX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJCXdmeF9k
b191bmpvaW4od3ZpZik7CiAJfSBlbHNlIHsKIAkJd3ZpZi0+am9pbl9jb21wbGV0ZV9zdGF0dXMg
PSAwOwotCQlpZiAod3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX0FESE9DKQotCQkJ
d3ZpZi0+c3RhdGUgPSBXRlhfU1RBVEVfSUJTUzsKLQkJZWxzZQotCQkJd3ZpZi0+c3RhdGUgPSBX
RlhfU1RBVEVfUFJFX1NUQTsKLQogCQkvKiBEdWUgdG8gYmVhY29uIGZpbHRlcmluZyBpdCBpcyBw
b3NzaWJsZSB0aGF0IHRoZQogCQkgKiBBUCdzIGJlYWNvbiBpcyBub3Qga25vd24gZm9yIHRoZSBt
YWM4MDIxMSBzdGFjay4KIAkJICogRGlzYWJsZSBmaWx0ZXJpbmcgdGVtcG9yYXJ5IHRvIG1ha2Ug
c3VyZSB0aGUgc3RhY2sKQEAgLTQ0OCw3ICs0NDEsNiBAQCBpbnQgd2Z4X3N0YXJ0X2FwKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogewogCXN0cnVj
dCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopdmlmLT5kcnZfcHJpdjsKIAotCXd2
aWYtPnN0YXRlID0gV0ZYX1NUQVRFX0FQOwogCXdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKHd2aWYp
OwogCWhpZl9zdGFydCh3dmlmLCAmdmlmLT5ic3NfY29uZiwgd3ZpZi0+Y2hhbm5lbCk7CiAJcmV0
dXJuIDA7CkBAIC00NjIsNyArNDU0LDYgQEAgdm9pZCB3Znhfc3RvcF9hcChzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAl3ZnhfdHhfcG9saWN5X2lu
aXQod3ZpZik7CiAJaWYgKHd2aWZfY291bnQod3ZpZi0+d2RldikgPD0gMSkKIAkJaGlmX3NldF9i
bG9ja19hY2tfcG9saWN5KHd2aWYsIDB4RkYsIDB4RkYpOwotCXd2aWYtPnN0YXRlID0gV0ZYX1NU
QVRFX1BBU1NJVkU7CiB9CiAKIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXplKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLApAQCAtNDc1LDkgKzQ2Niw2IEBAIHN0YXRpYyB2b2lkIHdmeF9qb2luX2Zp
bmFsaXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWhpZl9zZXRfYnNzX3BhcmFtcyh3dmlmLCBp
bmZvLT5haWQsIDcpOwogCWhpZl9zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Qod3ZpZiwgMSwgMSk7
CiAJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsKLQotCWlmICghaW5mby0+aWJzc19qb2luZWQpCi0JCXd2
aWYtPnN0YXRlID0gV0ZYX1NUQVRFX1NUQTsKIH0KIAogaW50IHdmeF9qb2luX2lic3Moc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCkBAIC03ODcsNyAr
Nzc1LDYgQEAgdm9pZCB3ZnhfcmVtb3ZlX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywKIAlXQVJOKHd2aWYtPmxpbmtfaWRfbWFwICE9IDEsICJjb3JydXB0ZWQgc3RhdGUiKTsKIAog
CWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7Ci0Jd3ZpZi0+c3RhdGUgPSBXRlhfU1RBVEVfUEFTU0lW
RTsKIAloaWZfc2V0X21hY2FkZHIod3ZpZiwgTlVMTCk7CiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2
aWYpOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuaAppbmRleCBmZTcyOGU2NDJjZmMuLmU4MTRmZTc0M2I3ZCAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5oCkBAIC0xNSwxNCArMTUsNiBAQAogc3RydWN0IHdmeF9kZXY7CiBzdHJ1Y3Qgd2Z4X3Zp
ZjsKIAotZW51bSB3Znhfc3RhdGUgewotCVdGWF9TVEFURV9QQVNTSVZFID0gMCwKLQlXRlhfU1RB
VEVfUFJFX1NUQSwKLQlXRlhfU1RBVEVfU1RBLAotCVdGWF9TVEFURV9JQlNTLAotCVdGWF9TVEFU
RV9BUCwKLX07Ci0KIHN0cnVjdCB3Znhfc3RhX3ByaXYgewogCWludCBsaW5rX2lkOwogCWludCB2
aWZfaWQ7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC93ZnguaAppbmRleCAzNTRhNjIzOTRkYjAuLjhkMjliZjc3Y2ZlZCAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oCkBAIC02Niw3ICs2Niw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlzdHJ1Y3QgaWVlZTgw
MjExX3ZpZgkqdmlmOwogCXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbDsKIAlpbnQJ
CQlpZDsKLQllbnVtIHdmeF9zdGF0ZQkJc3RhdGU7CiAKIAl1MzIJCQlsaW5rX2lkX21hcDsKIAot
LSAKMi4yNi4xCgo=
