Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B3120D66A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbgF2TTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:19:50 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35790 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731840AbgF2TTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593458381; x=1624994381;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=8ZS7IBi2vdydHtJiW0ph5emQev3EMVbkK/L/ZkjxV7U=;
  b=F1We15sgia/dbOvA1gKzf4VKKHJte5RX32Qg3ae0m0TKNL9zy3rFfRPX
   4NILYvEo6Pca/rVitSD0kZCAfbJGXtwo1kIbjsAcqVz/MGHCg3vy7szbh
   8yzU2zQ6Es+OlLAkPzd6IdBsxnVyP0TicOaYVGOfjjqchJMlDTwPAnJm4
   RwSJ1XK2wps7Cldtyzj0j2yKCC0L39tQfU4wpQ0mGXbYpp6K453hrhuDA
   ww6TR+qbRXumfaSlhmv/nZZ45Q8Y68vvQiTsk7xQl0AtmNVMpFkkAlafs
   d+YoXJwUDKzuOu3N58wMFmfmEcb13xgMmPWb5/CMpJ5uo9ly+S50sqIic
   A==;
IronPort-SDR: 6S/kpeNBbLwmoiWjtLMH0TjIndQKrkhFTBSN+vNpNsrzx0ksGTvEMBkWxWQLU7+VNmB09c8sTC
 CCJMw0HyUf7PqEC6dzr7qSAKCWfoPiJxUGQTOP2VMcxkJqESopy5dA4HBkuQhFUOIIK3t8QNaO
 omlDtTCNLo1tYL8x6Q1Ilc/0AW8bQp3/gBpX9vJBbCcQ0t0VabtS/Gs6Z52A2ikToapEniWj3m
 GTy1EsRQIBopGY31Yn8uF2HYsOPRWOfGWzzFZuYjzqwvNlEPWg1BQOocT0a6318rRpj3W5656F
 CHQ=
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="80077313"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 06:11:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 06:10:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 29 Jun 2020 06:10:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFnyy2DzuvU1NKeNH2MjKEGw2epB5js7oAvz2z1nS7zHOYx7qsMWUlY9Afj5iP7tQ9vR/bdTGR+AHP3XljVZuxOVZg/cJqSfX3jZTG1xD3rIXJLcf+Xp0mDl6YagGEDYNG/CsRxsMGOPzKDUJnULOatVkw35819fdsiFR8FA9lJOTkbdl3Ew6aKSGYBF03AOxJ9MdGICN4oL9auGb17hVq+LZ9STVOy1iuSAdgCerwsY1uGTpBBgkDRJwgP0fTOxDJ6DVlh0575v0+xTWmSU4V5StC8Wm/CSgB0TGwo+0Uo97jiAamz7Yk1q1b6x+F2bOPtMoJAS1ABwUPW+i5ckjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZS7IBi2vdydHtJiW0ph5emQev3EMVbkK/L/ZkjxV7U=;
 b=UygeSJ6O3X3fGp+Tbwlwusoj+iS+G6QujS2ya75HrruakazG5h184sJ5xFTFerqN96+aXymr5TAxoDzf0QEvyOjW6q0ErcfKFJoHihb5koqxmXuDruiXezKSY2LZWfg/zH17ZILdF6qwwJzeub/ZmPkOrswKXgy2OdpmBEnQoKMrkZRMg096XemoKrhfrqOpLpFUlf5TI3tffujt2bIlxOCOG2gK7skAc7Lr9xBMFEqOXn1bwCqKa6XcKKAIBMM6YckdMu7Qh/lnwV2bcwB5k8TfQrcwmd+vPu3rTt7B/lqlldNhJSFq/QJex2rBzEl5jn8OCjugilD2qKV4A6xYaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZS7IBi2vdydHtJiW0ph5emQev3EMVbkK/L/ZkjxV7U=;
 b=HrW75i7CCWBS6ZEzX3eCE4DWSB1kbmYqO8HgVdwHgweDMJWT7/Ix+xd9sMPxgdeVxjciaDGLG2vuPKkBbEJtg+KUkQwLFL570YOQB5h5hSJHPpB4bpWcMdaEAVJrhwtqJJu3MJbCyR7sucJd7jxE1y1JtxOCSlRcHdnnpju3wdw=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB3237.namprd11.prod.outlook.com (2603:10b6:a03:1e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 13:10:59 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 13:10:59 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 2/8] smsc95xx: avoid memory leak in smsc95xx_bind
Thread-Topic: [PATCH net-next 2/8] smsc95xx: avoid memory leak in
 smsc95xx_bind
Thread-Index: AQHWTha7FNW/IuZeE0aDhRcmCp3Kbg==
Date:   Mon, 29 Jun 2020 13:10:59 +0000
Message-ID: <7157e8cdfaf076bc19c8a418729d681dee57a981.camel@microchip.com>
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
x-ms-office365-filtering-correlation-id: 9f948a22-1216-43e8-20cd-08d81c2dddb7
x-ms-traffictypediagnostic: BYAPR11MB3237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB323726CEE198BBCFF17EFC1AEC6E0@BYAPR11MB3237.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tXEDQE12VsVaZVVrvOfbOfqpjcmS2fdpTvaD25q46iuYybBQHfc24kaebPjwkz74H4cUyuz71Q4O/SjoEAOla94EXMfheMGuTZuIuLnxE+TIwlMNUo0uaIYL1OJPZRPDM/xxfCGCUp6DrHDvUYouIDSrWjZpKuK0OSk/PfmHwk5Ikv7oj04Yxk15Jgq2/ddsgZZd9tPhNWwgQP1MTohXZlVOBjoa6pZRbeXmqa0uV8g60CIL9oiVjqd4ivBfDB5jtNCtQw5nfaAouucz9b7FM0QUIOtEUurlyPCZhPXjmWsxt98Vo7gLCDcxWZ2W1kkZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(39860400002)(366004)(396003)(346002)(186003)(76116006)(4326008)(6512007)(8936002)(110136005)(36756003)(71200400001)(66446008)(66946007)(91956017)(66476007)(6486002)(2906002)(86362001)(66556008)(5660300002)(107886003)(64756008)(8676002)(316002)(83380400001)(2616005)(26005)(4744005)(478600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vDeXehcZUTi5DD0G/Cjxu4UWhAFgdw4Qb9v3fL6/ZOq+QmARClMEFjEqkWsa7QTtAyPLayDral2yqpapvFGulkCfSpda/0U3g/ntaPuf0IizSiZZG40KaEUUYEW4C4J+vyW6oCgt1srQnGNdECfIcqPT+roofYJE5HxrMnHqvPHfMUngcqNaHECUSQmlTb/ZI7cam6gjamIC5POfvaTfQe4oZbH750xAvjHpG+I3IKfeNs5/3xGiEyDSQZ6aJxMtXUvFw18urgZaZLzbm/DPcyCs5UUrmm7+D09cL3H4V3W+HB9MSNiXYumDwQFPxx5iKzrK6S+IA90aw6jVQBoEwMbAZ5c+JodXNyMdMTJ9SxkzoafHGD8W0i4EF959Fe3WZgdrTlBxvfUijfLZSffijPe6y+iaw/TNWEtd2HF+6o2Gj9UzdvR47WrI/hIaddBDy5xrQZOlpy/tSIWx7nbtx2hwc2W7EmAx6ZXUhQSSMjk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9398F9D6E2252D4282E2330392F40D39@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f948a22-1216-43e8-20cd-08d81c2dddb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:10:59.0168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bZ2knIdf1VBzhgOEW7FtEliZNepyJiEiqZm3b5JLexXSxcHyhn9kTWviQM6ZP1P2ezDzuoW3lwkElsYQFBrb521CeaG0y5x76e0AvXdVcpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gYSBjYXNlIHdoZXJlIHRoZSBJRF9SRVYgcmVnaXN0ZXIgcmVhZCBpcyBmYWlsZWQsIHRoZSBt
ZW1vcnkgZm9yIGENCnByaXZhdGUgZGF0YSBzdHJ1Y3R1cmUgaGFzIHRvIGJlIGZyZWVkIGJlZm9y
ZSByZXR1cm5pbmcgZXJyb3IgZnJvbSB0aGUNCmZ1bmN0aW9uIHNtc2M5NXh4X3VuYmluZC4NCg0K
U2lnbmVkLW9mZi1ieTogQW5kcmUgRWRpY2ggPGFuZHJlLmVkaWNoQG1pY3JvY2hpcC5jb20+DQpT
aWduZWQtb2ZmLWJ5OiBQYXJ0aGliYW4gVmVlcmFzb29yYW4gPA0KUGFydGhpYmFuLlZlZXJhc29v
cmFuQG1pY3JvY2hpcC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYyB8IDMg
KystDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgYi9kcml2ZXJzL25ldC91c2Iv
c21zYzk1eHguYw0KaW5kZXggZWI0MDRiYjc0ZTE4Li5iYjRjY2JkYTAzMWEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYw0KKysrIGIvZHJpdmVycy9uZXQvdXNiL3Ntc2M5
NXh4LmMNCkBAIC0xMjkzLDcgKzEyOTMsOCBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X2JpbmQoc3Ry
dWN0IHVzYm5ldCAqZGV2LA0Kc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpDQogCS8qIGRldGVj
dCBkZXZpY2UgcmV2aXNpb24gYXMgZGlmZmVyZW50IGZlYXR1cmVzIG1heSBiZQ0KYXZhaWxhYmxl
ICovDQogCXJldCA9IHNtc2M5NXh4X3JlYWRfcmVnKGRldiwgSURfUkVWLCAmdmFsKTsNCiAJaWYg
KHJldCA8IDApDQotCQlyZXR1cm4gcmV0Ow0KKwkJZ290byBmcmVlX3BkYXRhOw0KKw0KIAl2YWwg
Pj49IDE2Ow0KIAlwZGF0YS0+Y2hpcF9pZCA9IHZhbDsNCiAJcGRhdGEtPm1kaXhfY3RybCA9IGdl
dF9tZGl4X3N0YXR1cyhkZXYtPm5ldCk7DQo=
