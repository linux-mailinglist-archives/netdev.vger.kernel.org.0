Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B901231BE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfLQQQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:03 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:33729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729077AbfLQQP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTM4K8HZ6hgnWs/7jq1XoRwvXbluyPF7HOl+GcF6nbyuGpCNomcfJy1kv6sN2y0ZwIr09zCIVTIznwGyxkZwrIxi8E3ldB3yUqvHQXghIO74Jd1sDnVVnLZ32lG42+b3EKhFX+VhX2xg0S72p64dPzhaVdBWpkucKkMDo8aRmhMH0gTcIQMghiqSyQNSbZh1FQZd3EAYhBOXUSM9f0N3/rCdbv+MNq9/c8qyJI+IhxcfQ8f0dTt3AtpqfHycdD+sJwJeEgKEV3YLvOXeRaztd3l9IoZ3dMO97gAQXVwNraGVq/MRMSCjq5nsTGBT/dI6rUxkp6207rzb/kZwTcr3GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQUOd2k3H7PvGQvT3Gmu7+8VFJLJ0zbzv6DQPSsWlUM=;
 b=Wl80ivMEjfb7wOuamZso0vf0l18DgHLqBwdlUdu+nEi0VO8o5duntlw1kxcKADDx59q5TwTxYNXhKyo7k5Gu4FsoL5jIxbvLubmrgyRYEucD5BxPCMVc/xf+ie/Sr5mmotlNO9SktYvZebDS2upaQedni/+1/1+HM/hF+seomX8D4DwkUDoBo7dCriqvExVj3GoeRIBzlxaBk0wZHjUudBmQjzotwhLShQ723mQ6wxsOGhLNiABNI5SlZcBERMfsObd5rlCQsD1sNs6KDiOvZs0zwUsNfOWKBG8fMCs6SS20VTsntf6HiiDg5+0AeIBiN7ku0e3P+JaYcYuLI5AAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQUOd2k3H7PvGQvT3Gmu7+8VFJLJ0zbzv6DQPSsWlUM=;
 b=iBldJD8OQ9uBIPwCxAqfnRI4W26LYEKIBqbwv032iDOtx7CcQlJhipZ7klFdFV/wo+HTUnsP9VNsxs/7Q1sRy9I0RtyT/SknO2Y2DDAw4WiZXdTn4KGlxEh42WfmOY+qhQ6oQcxtIvgs2MeaPrDR39dlEPbhJ9bgyKeFaZ+X/W8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:15:51 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:51 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 45/55] staging: wfx: device already handle sleep mode
 during scan
Thread-Topic: [PATCH v2 45/55] staging: wfx: device already handle sleep mode
 during scan
Thread-Index: AQHVtPUzjPg8Lu2rPUKHwVRjyrYluw==
Date:   Tue, 17 Dec 2019 16:15:29 +0000
Message-ID: <20191217161318.31402-46-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f3b38bb-a3ab-4dc3-bc35-08d7830c5584
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4477D41EAC3109BD0ECE4D8493500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(66574012)(186003)(107886003)(8676002)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NWgU3uSr9ceh/qkFugBPi4sFgIJEnvCL1um9tvP3m6Oh4umno/BRCBJirvJpR29s7HwKsleBuEdovTEx/fqreeo7oY1OWR10cDHd0MvZI9SlvQNVnlMoen8ZW4qfhtzQdM1Y/Wy1z5m2xqNTuP0iKSrCqj1fs5lZqufpzx4omGGj/XsMMBxZuH83xLQLmIwg6MAV4dqC4rPw0W7awgdgnmc1mqUESJWQVc0JQEh0l6oWgwicdizZgnx2Qrv4mX90S//P8DCuHzU5cuWwYo0nW3Csg9owLrLidpKYphw8ikqtA1/LVl1xpECgwjKmqeF/Em1rakoQGxiqS1spVHRv3FUWx3D95EmGI2JtHwaCxf7yMXfKZ0DpCLkP/hOqo2b8JoSqwrSeyClqz3rZh0BEhFercyF6rFmf/5Jh3t0T70T29vsQ8I+4jeApwZR3wt9V
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FB045CF19D8A94E81EF85590E0334A4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3b38bb-a3ab-4dc3-bc35-08d7830c5584
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:29.5322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: omkMHNWcaGNGjTRKZRkZVJN9q/Ct+bS7CNpGrg66H96smhXMVocRw0VRHNR6G7+/JuNJp/8e5ty2ibbrdCRLEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBpcyBub3QgYWxsb3dlZCB0byBlbnRlciBpbiBzbGVlcCBtb2RlIGR1cmluZyBzY2Fu
LiBIb3dldmVyLAp0aGlzIGlzIGFscmVhZHkgaGFuZGxlZCBieSB0aGUgZGV2aWNlLiBTbyBkcml2
ZXIgZG9lcyBub3QgaGF2ZSB0byBjYXJlCmFib3V0IGl0LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvYmguYyAgIHwgMyArLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgMyAt
LS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggIHwgMSAtCiAzIGZpbGVzIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvYmguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwppbmRleCAyNDMyYmE5NWMyZjUu
Ljk4M2M0MWQxZmU3YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvYmguYwpAQCAtMjcxLDggKzI3MSw3IEBAIHN0YXRpYyB2b2lk
IGJoX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCiAJaWYgKGxhc3Rfb3BfaXNfcngp
CiAJCWFja19zZGlvX2RhdGEod2Rldik7Ci0JaWYgKCF3ZGV2LT5oaWYudHhfYnVmZmVyc191c2Vk
ICYmICF3b3JrX3BlbmRpbmcod29yaykgJiYKLQkgICAgIWF0b21pY19yZWFkKCZ3ZGV2LT5zY2Fu
X2luX3Byb2dyZXNzKSkgeworCWlmICghd2Rldi0+aGlmLnR4X2J1ZmZlcnNfdXNlZCAmJiAhd29y
a19wZW5kaW5nKHdvcmspKSB7CiAJCWRldmljZV9yZWxlYXNlKHdkZXYpOwogCQlyZWxlYXNlX2No
aXAgPSB0cnVlOwogCX0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKaW5kZXggY2RjY2I2N2NiMzBlLi4zOTdmZTUxMWQz
NGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc2Nhbi5jCkBAIC00NCw3ICs0NCw2IEBAIHN0YXRpYyBpbnQgd2Z4X3NjYW5f
c3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCB3Znhfc2Nhbl9wYXJhbXMgKnNjYW4p
CiAJdG1vICs9IHNjYW4tPnNjYW5fcmVxLm51bV9vZl9jaGFubmVscyAqCiAJICAgICAgICgoMjAg
KiAoc2Nhbi0+c2Nhbl9yZXEubWF4X2NoYW5uZWxfdGltZSkpICsgMTApOwogCWF0b21pY19zZXQo
Jnd2aWYtPnNjYW4uaW5fcHJvZ3Jlc3MsIDEpOwotCWF0b21pY19zZXQoJnd2aWYtPndkZXYtPnNj
YW5faW5fcHJvZ3Jlc3MsIDEpOwogCiAJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZ3dmlmLT5zY2Fu
LnRpbWVvdXQsIG1zZWNzX3RvX2ppZmZpZXModG1vKSk7CiAJaGlmX3NjYW4od3ZpZiwgc2Nhbik7
CkBAIC0yMzIsOCArMjMxLDYgQEAgdm9pZCB3Znhfc2Nhbl93b3JrKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykKIHN0YXRpYyB2b2lkIHdmeF9zY2FuX2NvbXBsZXRlKHN0cnVjdCB3ZnhfdmlmICp3
dmlmKQogewogCXVwKCZ3dmlmLT5zY2FuLmxvY2spOwotCWF0b21pY19zZXQoJnd2aWYtPndkZXYt
PnNjYW5faW5fcHJvZ3Jlc3MsIDApOwotCiAJd2Z4X3NjYW5fd29yaygmd3ZpZi0+c2Nhbi53b3Jr
KTsKIH0KIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvd2Z4LmgKaW5kZXggZjM5NmE1MDIyODNlLi45NzM3M2QwNDdmNTggMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC93ZnguaApAQCAtNjAsNyArNjAsNiBAQCBzdHJ1Y3Qgd2Z4X2RldiB7CiAJc3RydWN0IG11dGV4
CQlyeF9zdGF0c19sb2NrOwogCiAJaW50CQkJb3V0cHV0X3Bvd2VyOwotCWF0b21pY190CQlzY2Fu
X2luX3Byb2dyZXNzOwogfTsKIAogc3RydWN0IHdmeF92aWYgewotLSAKMi4yNC4wCgo=
