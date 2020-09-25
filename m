Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79FE278341
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgIYIv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:51:57 -0400
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:38112
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYIv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 04:51:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glU6d/1pgeXp3HT9t0N7y4ZyZr4OC+xtnXSladKc24KhC3ve6/0FYJAjjhpyjWOq+qjvXS4Qvo7ZGzBhngTpAZJO4MurRjgo5ZsZbJWOsyvb5d6KYSY+gS/GXyoFGdVNQrXJYGyyO4bCc3CDza+ZzO8cZI+a58qPKJ1cYTULAv9msb68iMFPZKm0nRqq3PY4FH1LWPxq66H0ovPuQ9BPRH4El2WvNnIK6iS89H+/xROo0dbO7ugH+lWYDBgHnuvL3nuI+MTWGix7+ezEq/eiBW8ULmq6H7LnH+Dtwge3uYi3JLSNagMDY61Qi/EhgrGHXQ+iP32fxCFbAsIQp1B8+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aqRPzMYyh9QYsxr6ZvdePOzGSvIijHXLmkDVOt1i0U=;
 b=ng1c6NssVwzXH25Yk+87QK3NgZkRSOdjjGUgH3KAynjJMzz8BMY5TZVdatk5WVjj0evSSGJop7Cyo5hVnna4zmJoZCeLOu5AsaPT6uojtcnQKZFkXGc9oT15a7fVh0Sde1Hrsgzc6tDDeNXT9IgmXGEsCVb7vcFVsZbDPdCnecpQoNA8LZVB+QVgvuS9SFJrbfbVxF5V2MBHECqXH86NiZaZ58LYD6TOqkZzi2/h1iWkZI3+OS4PX2HPNOyfL6sQOGfieKTGpWiCbyzFxoIdVm0bF+QK08l4i75QsuACRb3EdDIxgJadIQOqSbOxOBIFmLZ8JKyffrcazican8KVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aqRPzMYyh9QYsxr6ZvdePOzGSvIijHXLmkDVOt1i0U=;
 b=IVPIZLc+BXSuCgq/dSWToJK+KiEUdQGvOw7bXLlUxZqFTy0eoQ8503jhbqIRGmjH0MGHVg3Hd/Qlgszn/0K18tuBUF+qwpF26MoUAMQpjXvbS6+FxQu0QjLoBkSNYmj6/rrDs7Y9DMIbVylZvguues/0FxUFDI7uxUcsRu2/by8=
Received: from BYAPR11MB2600.namprd11.prod.outlook.com (2603:10b6:a02:c8::15)
 by BYAPR11MB2903.namprd11.prod.outlook.com (2603:10b6:a03:89::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 08:51:51 +0000
Received: from BYAPR11MB2600.namprd11.prod.outlook.com
 ([fe80::103:e863:8475:4349]) by BYAPR11MB2600.namprd11.prod.outlook.com
 ([fe80::103:e863:8475:4349%5]) with mapi id 15.20.3391.026; Fri, 25 Sep 2020
 08:51:51 +0000
From:   "Liu, Yongxin" <Yongxin.Liu@windriver.com>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Revert "net: ethernet: ixgbe: check the return value of
 ixgbe_mii_bus_init()"
Thread-Topic: [PATCH] Revert "net: ethernet: ixgbe: check the return value of
 ixgbe_mii_bus_init()"
Thread-Index: AQHWkugQQBwN14Xhs0uzcqOVgStpZql5AhuAgAAH39A=
Date:   Fri, 25 Sep 2020 08:51:51 +0000
Message-ID: <BYAPR11MB2600094C066D51C15B81EA70E5360@BYAPR11MB2600.namprd11.prod.outlook.com>
References: <20200925024247.993-1-yongxin.liu@windriver.com>
 <CAMpxmJWjczUhKH2K25E4Ezs9DEFQMxHMhD8qzhurSeEyE=wmXg@mail.gmail.com>
In-Reply-To: <CAMpxmJWjczUhKH2K25E4Ezs9DEFQMxHMhD8qzhurSeEyE=wmXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: baylibre.com; dkim=none (message not signed)
 header.d=none;baylibre.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67267378-b471-4c09-8125-08d861303f00
x-ms-traffictypediagnostic: BYAPR11MB2903:
x-microsoft-antispam-prvs: <BYAPR11MB290325BB1B885E847C68120FE5360@BYAPR11MB2903.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:546;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oU6CoxwSElRjRfJE54QuqI2/wCOqNBu1g4ldagwVGPiR7f+ZCN/MHjCi5f06FRLp+/dMalT5CFuX3h7OSV93AcRg8C7s2aNQ02BVUSAjSxgF4Zo4EtwjTUKJOUAHkmj3PhHpuqeAqGL+/LTBNqjemMtEYZjmyPPrNGPcq+NXTT5yK3e61I6nrOr9CJozSy3OH+4EO/4y6xdv8BcCifQnri0JcEXSOsfvtiXoWX6sFzuV7zcv3ECH9Kg5AhhRZtR1jEp3/jbKmUzOtMRpUNCh2WG8Dem4qH41Agb4skF9dQKYm+lxZBY6j++0BURbK/W19Qe5fCrwehkgIFPFLia4fSvn1M7aFExKtsQnSElPuwuDMliltAvZXYa9kXNYymhA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2600.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39850400004)(366004)(33656002)(478600001)(76116006)(55016002)(86362001)(7696005)(54906003)(66946007)(9686003)(4326008)(5660300002)(52536014)(83380400001)(316002)(6916009)(71200400001)(8936002)(66446008)(66476007)(53546011)(26005)(6506007)(186003)(66556008)(64756008)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: LKUcg3BJ5/CbKlJeAjV7sr5KbDajAET/0rHhVd5RImvP/leiPYSIm/OhFuj1G36hfyShDFQanIQdVnofj2F/3NrSuaOJigHSQZxwzUZlWLLG1EuuSlvi5xeArqVotLuiH+XzkiEmVJRJFl+M2XEc8Mc/ajPMturSXwWokcXXWV8o4uao7k35Eks/VA6FR5jU/NAYBlTUZQmo04wRRh+7wroV+X/wIXBgFudf/hWtDb2ZWOLy7ln4IGe3az5jw0nCGovGgKbBv8+dx5KKynwPCtnY6izew0woHz5AJk5tVUvw0PP+nbVLsdrWxVu2i6lkEM3hLlXmh1xuCdrdfrvxo8JTGqvU9dkOo2O3f0ldXoyyKCi4CMZttO5JN4++O0EeXa/N+WyScUQdvrlA1WuPKK09HR7mIdQbfsJQ3O05RVhSrbmWtKopgq9cpHMTGkqS01bRWlKk2oqriyBBFh5WE/gN8LxQkIgPwS6IltZXETHfU2iqhp40ZkY76yKWLywju1IMBMairEXry4spYwRKt7h7ba04aduBFAG3qWtYs/ADLLNzfwndalE7eKHNarRGvYlKqnOHuXBMdGCqZLrgu/y4wB3iAcpNimHYvicEqNAs6JcczGDNCYGqzVK0EmrAZleeD85QsRPO7B+dKPJJEA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2600.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67267378-b471-4c09-8125-08d861303f00
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 08:51:51.4148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9kckVnsUT8aiEK+U5WGzWq9nLaZd/EK0KtHnuwqReaw9P3UiTII41Hrj6D2Ywfn5MyHJh7Z03srZGzxDhwAVdsX0jkplr/U43JAfU8/14I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0b3N6IEdvbGFzemV3c2tp
IDxiZ29sYXN6ZXdza2lAYmF5bGlicmUuY29tPg0KPiBTZW50OiBGcmlkYXksIFNlcHRlbWJlciAy
NSwgMjAyMCAxNjoxNQ0KPiBUbzogTGl1LCBZb25neGluIDxZb25neGluLkxpdUB3aW5kcml2ZXIu
Y29tPg0KPiBDYzogRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IG5ldGRl
dg0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIFJldmVydCAibmV0OiBldGhlcm5ldDog
aXhnYmU6IGNoZWNrIHRoZSByZXR1cm4gdmFsdWUNCj4gb2YgaXhnYmVfbWlpX2J1c19pbml0KCki
DQo+IA0KPiBPbiBGcmksIFNlcCAyNSwgMjAyMCBhdCA0OjQ1IEFNIFlvbmd4aW4gTGl1IDx5b25n
eGluLmxpdUB3aW5kcml2ZXIuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IFRoaXMgcmV2ZXJ0cyBj
b21taXQgMDllZjE5M2ZlZjdlZmIwMTc1YTA0NjM0ODUzODYyZDcxN2FkYmI5NS4NCj4gPg0KPiA+
IEZvciBDMzAwMCBmYW1pbHkgb2YgU29DcywgdGhleSBoYXZlIGZvdXIgaXhnYmUgZGV2aWNlcyBz
aGFyaW5nIGEgc2luZ2xlDQo+IE1ESU8gYnVzLg0KPiA+IGl4Z2JlX21paV9idXNfaW5pdCgpIHJl
dHVybnMgLUVOT0RFViBmb3Igb3RoZXIgdGhyZWUgZGV2aWNlcy4gVGhlDQo+ID4gcHJvcGFnYXRp
b24gb2YgdGhlIGVycm9yIGNvZGUgbWFrZXMgb3RoZXIgdGhyZWUgaXhnYmUgZGV2aWNlcw0KPiB1
bnJlZ2lzdGVyZWQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZb25neGluIExpdSA8eW9uZ3hp
bi5saXVAd2luZHJpdmVyLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jIHwgNiArLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCA1IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21haW4uYw0KPiA+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gaW5kZXggMmY4YTRj
ZmM1ZmExLi41ZTUyMjNiZWNmODYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gQEAgLTExMDMxLDE0ICsxMTAzMSwxMCBA
QCBzdGF0aWMgaW50IGl4Z2JlX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KPiBjb25zdCBz
dHJ1Y3QgcGNpX2RldmljZV9pZCAqZW50KQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIElY
R0JFX0xJTktfU1BFRURfMTBHQl9GVUxMIHwNCj4gSVhHQkVfTElOS19TUEVFRF8xR0JfRlVMTCwN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICB0cnVlKTsNCj4gPg0KPiA+IC0gICAgICAgZXJy
ID0gaXhnYmVfbWlpX2J1c19pbml0KGh3KTsNCj4gPiAtICAgICAgIGlmIChlcnIpDQo+ID4gLSAg
ICAgICAgICAgICAgIGdvdG8gZXJyX25ldGRldjsNCj4gPiArICAgICAgIGl4Z2JlX21paV9idXNf
aW5pdChodyk7DQo+ID4NCj4gPiAgICAgICAgIHJldHVybiAwOw0KPiA+DQo+ID4gLWVycl9uZXRk
ZXY6DQo+ID4gLSAgICAgICB1bnJlZ2lzdGVyX25ldGRldihuZXRkZXYpOw0KPiA+ICBlcnJfcmVn
aXN0ZXI6DQo+ID4gICAgICAgICBpeGdiZV9yZWxlYXNlX2h3X2NvbnRyb2woYWRhcHRlcik7DQo+
ID4gICAgICAgICBpeGdiZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKGFkYXB0ZXIpOw0KPiA+IC0t
DQo+ID4gMi4xNC40DQo+ID4NCj4gDQo+IFRoZW4gd2Ugc2hvdWxkIGNoZWNrIGlmIGVyciA9PSAt
RU5PREVWLCBub3Qgb3V0cmlnaHQgaWdub3JlIGFsbCBwb3RlbnRpYWwNCj4gZXJyb3JzLCByaWdo
dD8NCj4gDQoNCkhtLCBpdCBpcyB3ZWlyZCB0byB0YWtlIC1FTk9ERVYgYXMgYSBubyBlcnJvci4N
CkhvdyBhYm91dCBqdXN0IHJldHVybiAwIGluc3RlYWQgb2YgLUVOT0RFViBpbiB0aGUgZm9sbG93
aW5nIGZ1bmN0aW9uPw0KDQo8ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVf
cGh5LmM+DQogOTAyIHMzMiBpeGdiZV9taWlfYnVzX2luaXQoc3RydWN0IGl4Z2JlX2h3ICpodykN
CiA5MDMgew0KIC4NCiAuDQogLg0KIDkxMyAgIHN3aXRjaCAoaHctPmRldmljZV9pZCkgew0KIDkx
NCAgIC8qIEMzMDAwIFNvQ3MgKi8NCiA5MTUgICBjYXNlIElYR0JFX0RFVl9JRF9YNTUwRU1fQV9L
UjoNCiA5MTYgICBjYXNlIElYR0JFX0RFVl9JRF9YNTUwRU1fQV9LUl9MOg0KIDkxNyAgIGNhc2Ug
SVhHQkVfREVWX0lEX1g1NTBFTV9BX1NGUF9OOg0KIDkxOCAgIGNhc2UgSVhHQkVfREVWX0lEX1g1
NTBFTV9BX1NHTUlJOg0KIDkxOSAgIGNhc2UgSVhHQkVfREVWX0lEX1g1NTBFTV9BX1NHTUlJX0w6
DQogOTIwICAgY2FzZSBJWEdCRV9ERVZfSURfWDU1MEVNX0FfMTBHX1Q6DQogOTIxICAgY2FzZSBJ
WEdCRV9ERVZfSURfWDU1MEVNX0FfU0ZQOg0KIDkyMiAgIGNhc2UgSVhHQkVfREVWX0lEX1g1NTBF
TV9BXzFHX1Q6DQogOTIzICAgY2FzZSBJWEdCRV9ERVZfSURfWDU1MEVNX0FfMUdfVF9MOg0KIDky
NCAgICAgaWYgKCFpeGdiZV94NTUwZW1fYV9oYXNfbWlpKGh3KSkNCiA5MjUgICAgICAgcmV0dXJu
IC1FTk9ERVY7DQoNCg0KVGhhbmtzLA0KWW9uZ3hpbg0KDQoNCj4gQmFydG9zeg0K
