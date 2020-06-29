Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6A020DA46
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbgF2Tza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:55:30 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:39316 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388379AbgF2Tz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593460528; x=1624996528;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=OswM2BcmFT4BuEGV7YRpAVEHcfYykLmQXhPyMkEpFkk=;
  b=GndZEk3aEJywTbflelYfXQ3o+WxT3mdp5n1fFkxtZ7B/cKG1RoCBXYES
   J0R8sKVp9NYX6Kk/0tZTFtK6NlrEJIlJxKqZ1KiRO8i5PWocbS2OX+eFL
   eKFdLa6OAsloyJZbcYZcU8+7ttsb3AEtu4fxdVbcP/dXRi3v/VP7BpgD5
   S4l314JZ2KZ8Tq3RTMLmE1GIIxvmk5OMJ0h9gOv5r3XKqKevVHT4OoDX+
   WNsbCX/eW37Yg/zunOzLTM+4dXJnx0NdrMD8CDi8fU/wS6YJBDzBUTgug
   V9qDnqZINU+B0GCZfG6BG30piC40stkUIINdrQfrkc15XhEjOTUBWcwEf
   A==;
IronPort-SDR: smoMjTTiQMXMNTefUP3IOJTExNeB4CMMnHYqdDBJqBV/5U/A46gNlyBghE/WkGQP/OaK/FWrcH
 YctFwXqgGpx33J4qrA+Rn1juEJBSWTQFvI2314yFrNgN7xRv0zmfMDhkpSVOvtxuDaYUbxlM+B
 g5lbTtMA7fPqCCSe5l1pqEVFaHxfoaCX5YQfG8UE2aH3x5n5t5QxWWz9I2ZTrkJVfZuds9rrIc
 T1ZBzw+KEqSLB94FKxJCt2hbd6a25L0eUR/tkBIn6wUKcOfQV5IPdCbCLXLWJgMx9jhFTV6dRJ
 D9w=
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="80127819"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 12:55:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 12:55:09 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 29 Jun 2020 12:55:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHyA4kLPA8yYI1B3bXqYchILpxfu30lUsAGlVDocg1ABtAJQZFA1jnppcwqCEE3R5V3Lj118lrRkwVyUwEQ+S3RwxX7Snsy/qwlBBoY/36NZks8Hw2pmFWtHqRA2Y+i49QcAu9ShAfxfxKu+ej+ApXsGLw1AoT1G0E5a4RReldXrhYZBFkkjby9YFy0o4t0+xaNOdPRdYhCHnq0l9iYlWI24VAdfUuUQ/hSm3O174nbyq6z56WUnvQGjStVOiC5pf/LJhk2vXb4y055tNzDc0PbYc3tItNo2zBEEWihdgscj5MKCZBmaiy6pqDA1FjZa222wjUgvSC2qY58vgsHBCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OswM2BcmFT4BuEGV7YRpAVEHcfYykLmQXhPyMkEpFkk=;
 b=YkLtRTxOmVvuAzvmnF9XYvAIPHEcvdO6Cz4tgl9aTZ/0/q70u1qDsbVHPKodnwZEQqC9nF2U7/NGu+auRoNW7kRuqI7aSe6LavSi5V1jbiA7vwqGoBTa53wMAmH7Fu0j7Nw4NLplyY2mbD4MPvStv/SFULtHWrLvHYLgC4daoE0ukwHVd9NKS3Q86X8ANzcxtC11E4vGDjXxNJbtwLegSpedh+nqK4XZGYWznCx6AgUCvV7NDG6Zz8nGICpkSh/Paa0RYdKgqM/IECawzwrpHAPtVvT/PZHh272/rbU31wzei98odLQBYwsbM35VK9eHtaOlshodGtaWW7So89uhbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OswM2BcmFT4BuEGV7YRpAVEHcfYykLmQXhPyMkEpFkk=;
 b=bQcFfMMjdS+H2RcV0tKwjWAsu9LEPsVWtU/2acGx1DCK+TlTxZ8ZqKzKAPN1fO+gimwl42SFJ+wVIr2Hyjrv15D9/VfjSjmP6GQN5uft/BvB7kuwnNQEzQhOWQyU6Wmy7kCrdpdc6QpZDWkbtcV0Zr3fqqfKS00414SFI7tn3Xg=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB3496.namprd11.prod.outlook.com (2603:10b6:a03:8b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 19:55:25 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 19:55:25 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 0/8] Add PAL support to smsc95xx
Thread-Topic: [PATCH net-next 0/8] Add PAL support to smsc95xx
Thread-Index: AQHWTk86EWJZAUL8ykWTeHSdNCeJ6g==
Date:   Mon, 29 Jun 2020 19:55:24 +0000
Message-ID: <c8fafa3198fcb0ba74d2190728075f108cfc5aa1.camel@microchip.com>
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
x-ms-office365-filtering-correlation-id: 91c3b23e-11d8-4bbb-da42-08d81c665d5b
x-ms-traffictypediagnostic: BYAPR11MB3496:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3496A423139836042CA457ABEC6E0@BYAPR11MB3496.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /cgcLdKuE3438ndCCho/FqMEor2LQmEzKiBznI7VJXovp4UtzJdqR+WM+3MUOCIE0WBfQgeZtouNjix0bTFmXqCc8izoXXYGUH7EEq35Rlr1/ui3exyc/UHPCK4DQcl+Nm05jhzM7E/ouuaWFnVymTOj51obUjtrD+oS4fZj55sZaHhxvwNWh7Dz1BPvNR0rc9ObU5DS9MfPVlUtBYiS9yIDromSSHtCZnSSghJ/VLVhQfczNCwhDkKc/1xZsevKx+KuNSixz5OREF1Q+7y5VfxfKdOQGrR4pe08oa3l/pPcqSF2O8no6ViXx4RWKnM5gNc40L8oSHDiGa/F+KzN7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(396003)(39860400002)(376002)(346002)(91956017)(66946007)(76116006)(66446008)(64756008)(66476007)(66556008)(4326008)(6486002)(2616005)(6506007)(110136005)(4744005)(2906002)(5660300002)(186003)(8936002)(8676002)(71200400001)(107886003)(36756003)(83380400001)(478600001)(26005)(86362001)(316002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /TAdRe8o5rX63ShOq7e1GvSzhTGQub3Ky+W3uxubxXmOf5XoUmYfO/E9/mbvMGDR+ZCaslNQBrBeSgT3Yz5Bh8xB9zGHZT1juYiG3TrWM0+KOCQcb28dAOpDl4W/K2/s0mN4mkfwN37/10zxP44pxgac6O9mlmga4g4s5giKmjQ5UWFANXCUGKvffyBc5dS7raqmjPXC3YOzq8OsuYogrh/EEa1AQeDCNpHYNmNWz495aAGp2i0KWTWgrmMOIBrDfGByjZBarW/imnHdPZroZ3W/d6YZcBKOnlKu3yhwxtqHYCb4KkJdyBPj1KImw6j9qA09eFZO3WHX/btXKuYSueYnbrdwKTIv8kN/CAqE7EqsZ7zNoZBTjPi0ITXMurmo6tumwnfWGlzy6IQP8tdBHv3l73gHtWKk//SLlxjSzWNfPFRqvpJnzy4YoBR8KSoQ8g6IjszGG6ie8CEQzS9l+SwsyWAb3igweivD+XFk5U6oKr0aUHYI2Jj8ymOoQ+tQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <59EAC00B532BD34BB838FF17D0D8A15A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c3b23e-11d8-4bbb-da42-08d81c665d5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 19:55:24.9009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ozNvppQDHzCAuUe90x+1A8ZHtlJbZ1XsTCF6VcvFWRY0zDV2J9DokU0E05278ivTQ/K4KgdfLmUbMxEMo4kjegFb3+TKM+sgzXSMoJbXM/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3496
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VG8gYWxsb3cgdG8gcHJvYmUgZXh0ZXJuYWwgcGh5IGRyaXZlcnMsIHRoaXMgcGF0Y2hzZXQgYWRk
cyB1c2Ugb2YNClBoeSBBYnN0cmFjdGlvbiBMYXllciB0byBzbXNjOTV4eCBkcml2ZXIuDQoNCkFu
ZHJlIEVkaWNoICg4KToNCiAgc21zYzk1eHg6IGNoZWNrIHJldHVybiB2YWx1ZSBvZiBzbXNjOTV4
eF9yZXNldA0KICBzbXNjOTV4eDogYXZvaWQgbWVtb3J5IGxlYWsgaW4gc21zYzk1eHhfYmluZA0K
ICBzbXNjOTV4eDogYWRkIFBBTCBzdXBwb3J0IHRvIHVzZSBleHRlcm5hbCBQSFkgZHJpdmVycw0K
ICBzbXNjOTV4eDogcmVtb3ZlIHJlZHVuZGFudCBsaW5rIHN0YXR1cyBjaGVja2luZw0KICBzbXNj
OTV4eDogdXNlIFBBTCBmcmFtZXdvcmsgcmVhZC93cml0ZSBmdW5jdGlvbnMNCiAgc21zYzk1eHg6
IHJlbW92ZSByZWR1bmRhbnQgZnVuY3Rpb24gYXJndW1lbnRzDQogIHNtc2M5NXh4OiB1c2UgUEhZ
IGZyYW1ld29yayBpbnN0ZWFkIG9mIE1JSSBsaWJyYXJ5DQogIHNtc2M5NXh4OiB1c2UgdXNibmV0
LT5kcml2ZXJfcHJpdg0KDQogZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgfCAzOTQgKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxODYgaW5z
ZXJ0aW9ucygrKSwgMjA4IGRlbGV0aW9ucygtKQ0KDQo=
