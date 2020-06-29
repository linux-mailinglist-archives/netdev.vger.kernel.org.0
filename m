Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38D320DAF7
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388671AbgF2UCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:02:20 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16407 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388667AbgF2UCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593460933; x=1624996933;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=6Yk2j93aPXLkxHLvZSIdkPSi0wIJF5w+CZkl5etb3CY=;
  b=bYNJWfLNMWMbtr6uokjngxZA93jwFW+P1nOHaZw3RjlQEGOoKL3gdwOD
   cwOgOavXC/F1mPTu7va1tic9u+vbYPLZoTKmP75TZLMk7dJ/h68CfhlJM
   FvPp1O2TAF/bkQTvsp6BmNu70gMHGts4ruHqM+C4W7p7+SBd9GTRTL5Ej
   CmwOwYD9PiilouWi8fgUeO9Hc9qVoOueA6qRu+xBZ3vBwpVi/SHe0gmHW
   HMQ6uWNylJwDHkfCQjuCB8N/CC0H16Mtm6oiXN9o4U3n4PKgJuswiqZvx
   +y2OIsprycfaQS+WNICeHZItox1ioMCBKdt9uqDaXJNO0B/rN6s9AAXe7
   Q==;
IronPort-SDR: Jg3TUQ5mcfqAHHUStYH2KX4axa9JQUdd/LP/JJ/KVRjiD1yr2poMzuAUGYENL1TOXdQLGOWVfV
 LU3dMM7spfAVatYcuznt5oix6DpTAdrzLbfJILecTUTR7t4Y4BmK6p4GdCeD/PRAWYcHqPT8AN
 ZHlAj607wg+hcuYPhF92i5BcD3Ydm5KL6w0kW3H43dcyIDqo5bLmaKFR/u0H5RWOu3pGINIJ1R
 oYr3E4TGaqpwVmietZJVC5mJGECNnQysTSm+dWYfR/Uz+Cv+4gFmcFZXeR+3iD/jCT7CwTGnUA
 YHc=
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="85542667"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 13:02:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 13:02:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 29 Jun 2020 13:01:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaev62zVW4MGJFIA2WtuVQP5D7vwVlp4qij56DCUisg1u8QdjimT0sD7HMH+T9QNBCXOc42ThPFjok576U19kwTptECZRtyirV+CHcriKjrnud37bsLk/jNSF3S8EbFWNrLT76TPJsZtj0TcfBjZXmqHoguKqjfY2HzCNwbLgpPdIGWZEnUMZu4z39d224wcxBI9rcgBhrzo6GyhzzFl+HMmFiAkruCis7Yf0bR1SjT0MI1D1rSYl2aUFDqmz+/Lb4fBENXVm2xe7IL3tayiJTdFPCYiv47eWMXVRpdxBGEV04C5fPZmLqa6kEModsfhJNS9LuU6ZniN39vwgPdQEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Yk2j93aPXLkxHLvZSIdkPSi0wIJF5w+CZkl5etb3CY=;
 b=TQpsoPtiVxDFd0tpNvkegHAsMHw468+suYPKfRDHGh3hBZlxBE/znsRhXvShYipIgD1Kzmu5rdD2MDkkQ9UQNnAgbS/s2Qp9McQXrxVl62r02+TLZ085sairXpCgVGEVxSKxuAi/OyPBOTkR9pR1KTkpj/Mi14yaj0SCX/E/OM9WRfABQzMP9/H4WjqiL5YrK2BXUpNJvoVkbXo4mG4bH39QXkumJkTaoO5quYje76aUZNxdoi1fWoB/DuVw1+bK0y4Hn+1tEh364kABjiCliXDknf7LilWJ/GDnUt7FbknQY2caYHolfLdb1/Ap1S0rCzmanelTRHTDSpWFvxs49w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Yk2j93aPXLkxHLvZSIdkPSi0wIJF5w+CZkl5etb3CY=;
 b=Ew/x418Px91i+x2iyURhLzbPEAPmieTmhaLDowvubyy9rhk8coAJMziY7PotuPARSeEroNpe919N+pfvFcIkUgoJSafXNtBI0kiXr5l/VPRPbw4c4AkMxEHTF7FyhNl8pxkhTw7LEKVECb8w41ESr5uV0awxMRWuonJQgCFTIeg=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB2792.namprd11.prod.outlook.com (2603:10b6:a02:c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Mon, 29 Jun
 2020 20:02:00 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 20:02:00 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 6/8] smsc95xx: remove redundant function arguments
Thread-Topic: [PATCH net-next 6/8] smsc95xx: remove redundant function
 arguments
Thread-Index: AQHWTlAmSCPxEOFjiEqoQ4nggvYMnQ==
Date:   Mon, 29 Jun 2020 20:01:59 +0000
Message-ID: <43615c318e057a87ceab45e0807c3dd8e041eb49.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92a611fa-f7a6-4c30-1ec7-08d81c6748d1
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB27929F9964DB792126A8F751EC6E0@BYAPR11MB2792.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5UIL9QZhUrr863OVG/9cFN+EkpWm+546AjfLSxxwon3W1UEmNjRTa1DGdR92VV5/c8NsJRuLdxPbYL1Gii+UMxAtOnDFTxQ9kJ+dgg4ETOrqd4/1UR2CGXjzRlYI8alRcPvJpQ1Zl+OkKK8AJpFNKkiqhu/jDKNKDm7WqMaXmzojd11my0OStCy3iYMYNuecTlsu0PtSNQY2bEOrHAziORNHqBDVLJKgkDsDAux6wRMzbfIWD32VzhBwv/w7j4YRCPkoKFe/hXCklo9vhmy/0YOLNZrLO+QqDSLyTBL1s/updTnq4lXa3BBq4/zfVdk9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(6506007)(4326008)(110136005)(478600001)(2616005)(2906002)(8676002)(316002)(8936002)(36756003)(6512007)(186003)(86362001)(83380400001)(71200400001)(26005)(6486002)(76116006)(107886003)(91956017)(5660300002)(66446008)(64756008)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +Zo4QNN5u7NBnt454CgLzR9/kvov/KAzt5fuaAGe8vaqURbv3M32VESxUAevjpaD0oaZnmrJIBqxupoBPlX5H54FApNxnAMtjK926jep4PsUgh6VxoiC/lpv9MgZTnbuVYq5hT28s2EgPByKFWUFJrtPWbkMffJb4ILJrUYJVg/V7kR52sWfvfYSg95lHQT+0X77t8oye8cCqz4+bBtVVw5TJsB3OQcEauU0UL/XYpSRZM3yPQZ7nSvuP4tGBm0JfUqJ+Kh92yH9WH0K2tVx8baLcEgYJ+WgCtpSbxS8JZDQVHw+6+p0zIMzAwJi4uDQTiVrSrTQKl3366NjolCO635wH9vw7Bgm3X7Pih5iDf//I8y5Qnt0iVE9EcKTDLZ3NEh/uWLAavM1RdVbqjqeWzJDvURRPvsIBSoRlek2MQO/aRfUP6SjyRc+gDNT0hkZ9+J4LAJBWVoZpe0s8v4S1a1QaIilYwyRghIsrPWhKUyPvVA1kUH0KNz0THqtzK4m
Content-Type: text/plain; charset="utf-8"
Content-ID: <F80E8ECB0052A548876E481BF0E8CB7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a611fa-f7a6-4c30-1ec7-08d81c6748d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 20:01:59.9390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GB3k0dDaon/DR729XoEBpV5wIwEwqaGZKRaT7/SWarqIKpFevQgCHRvrxGmWldm4Nf79FoZP+tVCAK2sxftwTpRIQriYYBQbKu5jmVhg4/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCByZW1vdmVzIGFyZ3VtZW50cyBuZXRkZXYgYW5kIHBoeV9pZCBmcm9tIHRoZSBm
dW5jdGlvbnMNCnNtc2M5NXh4X21kaW9fcmVhZF9ub3BtIGFuZCBzbXNjOTV4eF9tZGlvX3dyaXRl
X25vcG0uICBCb3RoIHJlbW92ZWQNCmFyZ3VtZW50cyBhcmUgcmVjb3ZlcmVkIGZyb20gYSBuZXcg
YXJndW1lbnQgYHN0cnVjdCB1c2JuZXQgKmRldmAuDQoNClNpZ25lZC1vZmYtYnk6IEFuZHJlIEVk
aWNoIDxhbmRyZS5lZGljaEBtaWNyb2NoaXAuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvdXNiL3Nt
c2M5NXh4LmMgfCAzNSArKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmls
ZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jIGIvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4
LmMNCmluZGV4IDExYWY1ZDVlY2U2MC4uYmNkZDdlNzI2ZjViIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvdXNiL3Ntc2M5NXh4LmMNCisrKyBiL2RyaXZlcnMvbmV0L3VzYi9zbXNjOTV4eC5jDQpA
QCAtMjYxLDE2ICsyNjEsMTggQEAgc3RhdGljIHZvaWQgX19zbXNjOTV4eF9tZGlvX3dyaXRlKHN0
cnVjdA0KbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQgcGh5X2lkLA0KIAltdXRleF91bmxvY2soJmRl
di0+cGh5X211dGV4KTsNCiB9DQogDQotc3RhdGljIGludCBzbXNjOTV4eF9tZGlvX3JlYWRfbm9w
bShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQNCnBoeV9pZCwNCi0JCQkJICAgaW50IGlk
eCkNCitzdGF0aWMgaW50IHNtc2M5NXh4X21kaW9fcmVhZF9ub3BtKHN0cnVjdCB1c2JuZXQgKmRl
diwgaW50IGlkeCkNCiB7DQotCXJldHVybiBfX3Ntc2M5NXh4X21kaW9fcmVhZChuZXRkZXYsIHBo
eV9pZCwgaWR4LCAxKTsNCisJc3RydWN0IG1paV9pZl9pbmZvICptaWkgPSAmZGV2LT5taWk7DQor
DQorCXJldHVybiBfX3Ntc2M5NXh4X21kaW9fcmVhZChkZXYtPm5ldCwgbWlpLT5waHlfaWQsIGlk
eCwgMSk7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShzdHJ1
Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQNCnBoeV9pZCwNCi0JCQkJICAgICBpbnQgaWR4LCBp
bnQgcmVndmFsKQ0KK3N0YXRpYyB2b2lkIHNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShzdHJ1Y3Qg
dXNibmV0ICpkZXYsIGludCBpZHgsIGludA0KcmVndmFsKQ0KIHsNCi0JX19zbXNjOTV4eF9tZGlv
X3dyaXRlKG5ldGRldiwgcGh5X2lkLCBpZHgsIHJlZ3ZhbCwgMSk7DQorCXN0cnVjdCBtaWlfaWZf
aW5mbyAqbWlpID0gJmRldi0+bWlpOw0KKw0KKwlfX3Ntc2M5NXh4X21kaW9fd3JpdGUoZGV2LT5u
ZXQsIG1paS0+cGh5X2lkLCBpZHgsIHJlZ3ZhbCwgMSk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgc21z
Yzk1eHhfbWRpb19yZWFkKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIGludCBwaHlfaWQsDQpp
bnQgaWR4KQ0KQEAgLTEzNDksMzkgKzEzNTEsMzcgQEAgc3RhdGljIHUzMiBzbXNjX2NyYyhjb25z
dCB1OCAqYnVmZmVyLCBzaXplX3QNCmxlbiwgaW50IGZpbHRlcikNCiANCiBzdGF0aWMgaW50IHNt
c2M5NXh4X2VuYWJsZV9waHlfd2FrZXVwX2ludGVycnVwdHMoc3RydWN0IHVzYm5ldCAqZGV2LA0K
dTE2IG1hc2spDQogew0KLQlzdHJ1Y3QgbWlpX2lmX2luZm8gKm1paSA9ICZkZXYtPm1paTsNCiAJ
aW50IHJldDsNCiANCiAJbmV0ZGV2X2RiZyhkZXYtPm5ldCwgImVuYWJsaW5nIFBIWSB3YWtldXAg
aW50ZXJydXB0c1xuIik7DQogDQogCS8qIHJlYWQgdG8gY2xlYXIgKi8NCi0JcmV0ID0gc21zYzk1
eHhfbWRpb19yZWFkX25vcG0oZGV2LT5uZXQsIG1paS0+cGh5X2lkLA0KUEhZX0lOVF9TUkMpOw0K
KwlyZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYsIFBIWV9JTlRfU1JDKTsNCiAJaWYg
KHJldCA8IDApDQogCQlyZXR1cm4gcmV0Ow0KIA0KIAkvKiBlbmFibGUgaW50ZXJydXB0IHNvdXJj
ZSAqLw0KLQlyZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYtPm5ldCwgbWlpLT5waHlf
aWQsDQpQSFlfSU5UX01BU0spOw0KKwlyZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYs
IFBIWV9JTlRfTUFTSyk7DQogCWlmIChyZXQgPCAwKQ0KIAkJcmV0dXJuIHJldDsNCiANCiAJcmV0
IHw9IG1hc2s7DQogDQotCXNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShkZXYtPm5ldCwgbWlpLT5w
aHlfaWQsIFBIWV9JTlRfTUFTSywNCnJldCk7DQorCXNtc2M5NXh4X21kaW9fd3JpdGVfbm9wbShk
ZXYsIFBIWV9JTlRfTUFTSywgcmV0KTsNCiANCiAJcmV0dXJuIDA7DQogfQ0KIA0KIHN0YXRpYyBp
bnQgc21zYzk1eHhfbGlua19va19ub3BtKHN0cnVjdCB1c2JuZXQgKmRldikNCiB7DQotCXN0cnVj
dCBtaWlfaWZfaW5mbyAqbWlpID0gJmRldi0+bWlpOw0KIAlpbnQgcmV0Ow0KIA0KIAkvKiBmaXJz
dCwgYSBkdW1teSByZWFkLCBuZWVkZWQgdG8gbGF0Y2ggc29tZSBNSUkgcGh5cyAqLw0KLQlyZXQg
PSBzbXNjOTV4eF9tZGlvX3JlYWRfbm9wbShkZXYtPm5ldCwgbWlpLT5waHlfaWQsIE1JSV9CTVNS
KTsNCisJcmV0ID0gc21zYzk1eHhfbWRpb19yZWFkX25vcG0oZGV2LCBNSUlfQk1TUik7DQogCWlm
IChyZXQgPCAwKQ0KIAkJcmV0dXJuIHJldDsNCiANCi0JcmV0ID0gc21zYzk1eHhfbWRpb19yZWFk
X25vcG0oZGV2LT5uZXQsIG1paS0+cGh5X2lkLCBNSUlfQk1TUik7DQorCXJldCA9IHNtc2M5NXh4
X21kaW9fcmVhZF9ub3BtKGRldiwgTUlJX0JNU1IpOw0KIAlpZiAocmV0IDwgMCkNCiAJCXJldHVy
biByZXQ7DQogDQpAQCAtMTQzMCw3ICsxNDMwLDYgQEAgc3RhdGljIGludCBzbXNjOTV4eF9lbnRl
cl9zdXNwZW5kMChzdHJ1Y3QgdXNibmV0DQoqZGV2KQ0KIHN0YXRpYyBpbnQgc21zYzk1eHhfZW50
ZXJfc3VzcGVuZDEoc3RydWN0IHVzYm5ldCAqZGV2KQ0KIHsNCiAJc3RydWN0IHNtc2M5NXh4X3By
aXYgKnBkYXRhID0gKHN0cnVjdCBzbXNjOTV4eF9wcml2ICopKGRldi0NCj4gZGF0YVswXSk7DQot
CXN0cnVjdCBtaWlfaWZfaW5mbyAqbWlpID0gJmRldi0+bWlpOw0KIAl1MzIgdmFsOw0KIAlpbnQg
cmV0Ow0KIA0KQEAgLTE0MzgsMTcgKzE0MzcsMTcgQEAgc3RhdGljIGludCBzbXNjOTV4eF9lbnRl
cl9zdXNwZW5kMShzdHJ1Y3QNCnVzYm5ldCAqZGV2KQ0KIAkgKiBjb21wYXRpYmlsaXR5IHdpdGgg
bm9uLXN0YW5kYXJkIGxpbmsgcGFydG5lcnMNCiAJICovDQogCWlmIChwZGF0YS0+ZmVhdHVyZXMg
JiBGRUFUVVJFX1BIWV9OTFBfQ1JPU1NPVkVSKQ0KLQkJc21zYzk1eHhfbWRpb193cml0ZV9ub3Bt
KGRldi0+bmV0LCBtaWktPnBoeV9pZCwJUEhZX0VEUA0KRF9DT05GSUcsDQotCQkJUEhZX0VEUERf
Q09ORklHX0RFRkFVTFQpOw0KKwkJc21zYzk1eHhfbWRpb193cml0ZV9ub3BtKGRldiwgUEhZX0VE
UERfQ09ORklHLA0KKwkJCQkJIFBIWV9FRFBEX0NPTkZJR19ERUZBVUxUKTsNCiANCiAJLyogZW5h
YmxlIGVuZXJneSBkZXRlY3QgcG93ZXItZG93biBtb2RlICovDQotCXJldCA9IHNtc2M5NXh4X21k
aW9fcmVhZF9ub3BtKGRldi0+bmV0LCBtaWktPnBoeV9pZCwNClBIWV9NT0RFX0NUUkxfU1RTKTsN
CisJcmV0ID0gc21zYzk1eHhfbWRpb19yZWFkX25vcG0oZGV2LCBQSFlfTU9ERV9DVFJMX1NUUyk7
DQogCWlmIChyZXQgPCAwKQ0KIAkJcmV0dXJuIHJldDsNCiANCiAJcmV0IHw9IE1PREVfQ1RSTF9T
VFNfRURQV1JET1dOXzsNCiANCi0Jc21zYzk1eHhfbWRpb193cml0ZV9ub3BtKGRldi0+bmV0LCBt
aWktPnBoeV9pZCwNClBIWV9NT0RFX0NUUkxfU1RTLCByZXQpOw0KKwlzbXNjOTV4eF9tZGlvX3dy
aXRlX25vcG0oZGV2LCBQSFlfTU9ERV9DVFJMX1NUUywgcmV0KTsNCiANCiAJLyogZW50ZXIgU1VT
UEVORDEgbW9kZSAqLw0KIAlyZXQgPSBzbXNjOTV4eF9yZWFkX3JlZ19ub3BtKGRldiwgUE1fQ1RS
TCwgJnZhbCk7DQo=
