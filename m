Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E470294A13
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395210AbgJUJCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:02:37 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:44502 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394957AbgJUJCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603270956; x=1634806956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e6KcHS0iFP0DDoB6KQPfZv9xX/Wc9DqMVmlFjn1lpmY=;
  b=YEGZZ2KT3OqkA13AZRjbcLEAdsnm8RS7gd8+4LtUWumH+kWtV08VLXsj
   BRTqLQaaPZBRUStONso6kktuiZTwhX/IE+xgp6w+7n95PBmGJbPt0lKmW
   3qWY3hoxBpwLUQIfVzM/1hrnhdsFsoXztikENX7ty9x9V1bLHuSDJoE9a
   XOKNENnkw+MQUuRJOem4UghTSLq9lgNvu+IWw9nGCdUU1CznrRO5Oq/E3
   o1YgE/61WE/o8yf6i8cy8dkSFpsumv+IcTkbRTzsWKqT/+k8LMlwv1GBA
   EPlBoG1iBN+b4KKTCB3Km1+VWibXp299IbZc8nTckFJ7fJQXMmOQzMOOt
   Q==;
IronPort-SDR: ETwKtprysGhj4IrVNqh4KIwc4xr+Q9sNaFDSxY4WFa0Zrjhwe9Cdrii+0ZUmlRKtbCt7o84z+/
 mJmQZfEauoHHQ3v+gJWA4uYxxutMsiPIk8bBzatSO2wZ6IxzYvTzbWRtzomjbiPX2D6Cfvnu/z
 yQ3AAdrB8b//Zx4tLyqwvUc/bYKTazv5TQhrnGodFK8gQM26zXZZHvWvzS8Squh8pQcxwjGgrP
 a2zQv65V05d24J5pNgqy6FGamVMsdyg3+Le7r4Ft4M8Thf2Jqgyp9j3OH0ak+7eqrNIZo/+4Jt
 rws=
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="95414373"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Oct 2020 02:02:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 21 Oct 2020 02:02:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 21 Oct 2020 02:02:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/e2HCHYB586pfvzwyT7DdOitvstYEpvdAg6QnWptkRyrraSsn4TUuJTX3xsvl+Ot7/oPi6HZAIhwccPPMaBQqvv77Yambiea/lYTBzLaxO8vI9jqo1icw+3NpokD3QVSf7M8LJ8yNzUsksDPsL74+Bo6Mh5tz1KW0Y34zfV8wW4SvWEl14yixBl2SLSwGdYUYAQc5jD/WDYwSovMJRStXz6xMVbnt1Rpr/SoKx3WcN1O6opmTB3DSirBjESaYP3RA12QUHGU5VB7IEqCa7Ky3ITpoG2B1s/S72YfiMXxjZ7P1eiKcRXD3DWup8IDSSXhvHf4/SKGgoLQPYq0FuDmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6KcHS0iFP0DDoB6KQPfZv9xX/Wc9DqMVmlFjn1lpmY=;
 b=fGyfNH76MkJcdnbZR8BhcPvIygfw6fnXBvlfeBbB3cNPMPhp0+CPVZxghCfToMbKSlrLnnZaGT4kddXJ5Kxb1wkTKvgA9siIvHkxciw5xvcdDh09qyY4wrISKFpTOT98B2hR0ceM2GUOTeIt8n0DKl3+o6BPQiDFYJPdHr7rgnCyJfILM7U9WCk/Of10zmTtmrc/EuBF22VM4+Y+poSQZ9XqT/cY5Fn/tygfG+ZcSSAi2ZTGgiUyUixi4bRdS/gheREQKVy7RDWdzOBwsBXkKN4uI4s5rMcHaAoV/zNTS1DXHUe1yiIF1khnFG98S3Rpfdw1lAygVlZQts+hzZnVwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6KcHS0iFP0DDoB6KQPfZv9xX/Wc9DqMVmlFjn1lpmY=;
 b=QXP28F6bFrWIj2YxOG+sIAbCxJTL0iQweIQdPJG3Uz5D5YX7OSRgKskFMd1kI+hLkNBdEeqVR9vU01lZOXhrxS3XdOPoIxJ4gE0oUZTNeTCRum1J9+d75DXWhzUnXneiyl9fbvl3wTtnVrbBE5txSYqlfde2uVYFzuczOjZjNfE=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB4596.namprd11.prod.outlook.com (2603:10b6:5:2a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.27; Wed, 21 Oct 2020 09:02:34 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::f983:dc6d:ad81:9e18]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::f983:dc6d:ad81:9e18%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 09:02:33 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <w@1wt.eu>
CC:     <Nicolas.Ferre@microchip.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <daniel@0x0f.com>
Subject: Re: [PATCH net-next 3/3] macb: support the two tx descriptors on
 at91rm9200
Thread-Topic: [PATCH net-next 3/3] macb: support the two tx descriptors on
 at91rm9200
Thread-Index: AQHWokQv811GPe7V1UOUmioZApZWWg==
Date:   Wed, 21 Oct 2020 09:02:33 +0000
Message-ID: <061451b2-95b5-e37f-595f-1a93f8c3c2ab@microchip.com>
References: <20201011090944.10607-1-w@1wt.eu>
 <20201011090944.10607-4-w@1wt.eu>
 <29603cfa-db00-f088-3dbe-0781ee5a99ed@microchip.com>
 <20201014162732.GA12944@1wt.eu>
In-Reply-To: <20201014162732.GA12944@1wt.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: 1wt.eu; dkim=none (message not signed)
 header.d=none;1wt.eu; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [86.120.221.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43a7454c-dc20-4d62-119d-08d875a00c8f
x-ms-traffictypediagnostic: DM6PR11MB4596:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4596CB2001E9219DBDA8B6D9871C0@DM6PR11MB4596.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GPI9flo3a8zU4Rn2V3rqZE6ninrVjSERL2oGSA24NpV3IgmPa3S7TTJXEC08W4uxs5xqnjjHwHHFTxO+ks0DipekH4XZMdtcnqklSJ8hMdd3WqijCF3H3MQv1yduuUIoyeRHvChj7agb+OsNHQJTGH48CUSt+bNeV4HzvLSvJcZbAzyLP4SjUqAv5UMVEYU19Woy41kFMfW9w0YfOSB7NU4LH8npivMtThFSmtJi+o/0skULk4lVRIyXyAME+Doxf3VNnx4ZGVT1v6D1YEVGDKKpxW7GD2wAiYYrH0GRlDzBH2fuyiHiyGsp2Zdm3Q4UowgbCJePTvu5Q+JuORjUmwo/OZ7EXtM1Bb6BR3JMzQj5TlbZMNVQeHEpymGs49RF+yOic+s+KtemP9zNKfrl5ncTD1F8gP5va18Sa6paM0k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(39860400002)(376002)(91956017)(86362001)(31686004)(316002)(5660300002)(71200400001)(31696002)(2906002)(83380400001)(66446008)(6486002)(6506007)(186003)(66946007)(6916009)(53546011)(76116006)(66476007)(66556008)(64756008)(26005)(6512007)(4326008)(54906003)(8676002)(36756003)(8936002)(478600001)(2616005)(60764002)(781001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mOhktBP5Z+2ox+7JmzGmP6XktqAPCVY0iygZw8OiFvnXNE4+6kqpgNPDnAKtsP1bKZ9sOmPOleIAv2XTVjY0L45ojjyxrvkHwkfUiA5NsP5CvwErSPBPV0pi50FIoGkP1bkVOzN7s5bY+nf3FjlLh9ZFLMWyk/4k8CUzgg17YMs88wth5sjZVS7GnGfmxoukyu0Sb+Ny57ymLjJ2h1gEFqHHtNSW8DxKyW4OuzX5kedKPPRyPkpI3XXKWGdt3Xea+imlvNyrjfvsbrg50HVY3F0SvvB/qERzDac/hwUNh/0/fyJb2PSxeZRLkvDKx66LViaZAUKDwjDuRKk9sFluKV/CFrb3YWitcyZDt9S2SdCyZcg+u6sQC19OaLTjh113lN2AiE8AIK+X1Nrkz+tFadJkitgvY/r3JnHH4W4Z+whcE5y2/lBPX/gKJxS4GwqyFD7RSrUT7gtWZIaYsSJ9Pl4+sbghWPC7UWStFpp4ExRUFkpKm1TUkZWmWoKj4h92Ody7DpcrrrJIJtaMW3xPVLDkjAmsuEiCer21riCod3XMLa6VZH1aNrbE9RUEAYLoUGmCpZ6YxyD4gkGp4vGxCvhbONpOSFu7HiWb+wGYXArJ2NVJygxo+spLHHHt8Lu0VsAWXG1owRDpnauOeWfDWA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E499CAD7814794FB273F58D19C496DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a7454c-dc20-4d62-119d-08d875a00c8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 09:02:33.7337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G+sYdvgDApp+hCvNcj9mhPrVScHjbA6gu3YZunsQ+XlgyhNl7Jdm/HiVa3R7z9Za/yCxtApAqNKf+Zgh1WHYDkKBABbhL0rmwhgvfcdNMPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4596
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbHksDQoNCk9uIDE0LjEwLjIwMjAgMTk6MjcsIFdpbGx5IFRhcnJlYXUgd3JvdGU6DQo+
IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gSGkgQ2xhdWRpdSwNCj4g
DQo+IGZpcnN0LCB0aGFua3MgZm9yIHlvdXIgZmVlZGJhY2shDQo+IA0KPiBPbiBXZWQsIE9jdCAx
NCwgMjAyMCBhdCAwNDowODowMFBNICswMDAwLCBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29t
IHdyb3RlOg0KPj4+IEBAIC0zOTk0LDExICszOTk2LDEwIEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBh
dDkxZXRoZXJfc3RhcnRfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KPj4+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPj4+
ICB7DQo+Pj4gICAgICAgICBzdHJ1Y3QgbWFjYiAqbHAgPSBuZXRkZXZfcHJpdihkZXYpOw0KPj4+
ICsgICAgICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4+Pg0KPj4+IC0gICAgICAgaWYgKG1hY2Jf
cmVhZGwobHAsIFRTUikgJiBNQUNCX0JJVChSTTkyMDBfQk5RKSkgew0KPj4+IC0gICAgICAgICAg
ICAgICBpbnQgZGVzYyA9IDA7DQo+Pj4gLQ0KPj4+IC0gICAgICAgICAgICAgICBuZXRpZl9zdG9w
X3F1ZXVlKGRldik7DQo+Pj4gKyAgICAgICBpZiAobHAtPnJtOTIwMF90eF9sZW4gPCAyKSB7DQo+
Pj4gKyAgICAgICAgICAgICAgIGludCBkZXNjID0gbHAtPnJtOTIwMF90eF90YWlsOw0KPj4NCj4+
IEkgdGhpbmsgeW91IGFsc28gd2FudCB0byBwcm90ZWN0IHRoZXNlIHJlYWRzIHdpdGggc3Bpbl9s
b2NrKCkgdG8gYXZvaWQNCj4+IGNvbmN1cnJlbmN5IHdpdGggdGhlIGludGVycnVwdCBoYW5kbGVy
Lg0KPiANCj4gSSBkb24ndCB0aGluayBpdCdzIG5lZWRlZCBiZWNhdXNlIHRoZSBjb25kaXRpb24g
ZG9lc24ndCBjaGFuZ2UgYmVsb3cNCj4gdXMgYXMgdGhlIGludGVycnVwdCBoYW5kbGVyIG9ubHkg
ZGVjcmVtZW50cy4gSG93ZXZlciBJIGNvdWxkIHVzZSBhDQo+IFJFQURfT05DRSB0byBtYWtlIHRo
aW5ncyBjbGVhbmVyLiBBbmQgaW4gcHJhY3RpY2UgdGhpcyB0ZXN0IHdhcyBrZXB0DQo+IHRvIGtl
ZXAgc29tZSBzYW5pdHkgY2hlY2tzIGJ1dCBpdCBuZXZlciBmYWlscywgYXMgaWYgdGhlIHF1ZXVl
IGxlbmd0aA0KPiByZWFjaGVzIDIsIHRoZSBxdWV1ZSBpcyBzdG9wcGVkIChhbmQgSSBuZXZlciBn
b3QgdGhlIGRldmljZSBidXN5IG1lc3NhZ2UNCj4gZWl0aGVyIGJlZm9yZSBub3IgYWZ0ZXIgdGhl
IHBhdGNoKS4NCj4gDQo+Pj4gICAgICAgICAgICAgICAgIC8qIFN0b3JlIHBhY2tldCBpbmZvcm1h
dGlvbiAodG8gZnJlZSB3aGVuIFR4IGNvbXBsZXRlZCkgKi8NCj4+PiAgICAgICAgICAgICAgICAg
bHAtPnJtOTIwMF90eHFbZGVzY10uc2tiID0gc2tiOw0KPj4+IEBAIC00MDEyLDYgKzQwMTMsMTUg
QEAgc3RhdGljIG5ldGRldl90eF90IGF0OTFldGhlcl9zdGFydF94bWl0KHN0cnVjdCBza19idWZm
ICpza2IsDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIE5FVERFVl9UWF9PSzsN
Cj4+PiAgICAgICAgICAgICAgICAgfQ0KPj4+DQo+Pj4gKyAgICAgICAgICAgICAgIHNwaW5fbG9j
a19pcnFzYXZlKCZscC0+bG9jaywgZmxhZ3MpOw0KPj4+ICsNCj4+PiArICAgICAgICAgICAgICAg
bHAtPnJtOTIwMF90eF90YWlsID0gKGRlc2MgKyAxKSAmIDE7DQo+Pj4gKyAgICAgICAgICAgICAg
IGxwLT5ybTkyMDBfdHhfbGVuKys7DQo+Pj4gKyAgICAgICAgICAgICAgIGlmIChscC0+cm05MjAw
X3R4X2xlbiA+IDEpDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgbmV0aWZfc3RvcF9xdWV1
ZShkZXYpOw0KPiANCj4gVGhpcyBpcyB3aGVyZSB3ZSBndWFyYW50ZWUgdGhhdCB3ZSB3b24ndCBj
YWxsIHN0YXJ0X3htaXQoKSBhZ2FpbiB3aXRoDQo+IHJtOTIwMF90eF9sZW4gPj0gMi4NCg0KSSBz
ZWUgaXQhDQoNCj4gDQo+Pj4gQEAgLTQwODgsMjEgKzQxMDAsMzkgQEAgc3RhdGljIGlycXJldHVy
bl90IGF0OTFldGhlcl9pbnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KPj4+ICAgICAg
ICAgICAgICAgICBhdDkxZXRoZXJfcngoZGV2KTsNCj4+Pg0KPj4+ICAgICAgICAgLyogVHJhbnNt
aXQgY29tcGxldGUgKi8NCj4+PiAtICAgICAgIGlmIChpbnRzdGF0dXMgJiBNQUNCX0JJVChUQ09N
UCkpIHsNCj4+PiArICAgICAgIGlmIChpbnRzdGF0dXMgJiAoTUFDQl9CSVQoVENPTVApIHwgTUFD
Ql9CSVQoUk05MjAwX1RCUkUpKSkgew0KPj4+ICAgICAgICAgICAgICAgICAvKiBUaGUgVENPTSBi
aXQgaXMgc2V0IGV2ZW4gaWYgdGhlIHRyYW5zbWlzc2lvbiBmYWlsZWQgKi8NCj4+PiAgICAgICAg
ICAgICAgICAgaWYgKGludHN0YXR1cyAmIChNQUNCX0JJVChJU1JfVFVORCkgfCBNQUNCX0JJVChJ
U1JfUkxFKSkpDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgZGV2LT5zdGF0cy50eF9lcnJv
cnMrKzsNCj4+Pg0KPj4+IC0gICAgICAgICAgICAgICBkZXNjID0gMDsNCj4+PiAtICAgICAgICAg
ICAgICAgaWYgKGxwLT5ybTkyMDBfdHhxW2Rlc2NdLnNrYikgew0KPj4+ICsgICAgICAgICAgICAg
ICBzcGluX2xvY2soJmxwLT5sb2NrKTsNCj4+DQo+PiBBbHNvLCB0aGlzIGxvY2sgY291bGQgYmUg
bW92ZWQgYmVmb3JlIHdoaWxlLCBiZWxvdywgYXMgeW91IHdhbnQgdG8gcHJvdGVjdA0KPj4gdGhl
IHJtOTIwMF90eF9sZW4gYW5kIHJtOTIwMF90eF90YWlscyBtZW1iZXJzIG9mIGxwIGFzIEkgdW5k
ZXJzdGFuZC4NCj4gDQo+IFN1cmUsIGJ1dCBpdCBhY3R1YWxseSAqaXMqIGJlZm9yZSB0aGUgd2hp
bGUoKS4gSSdtIHNvcnJ5IGlmIHRoYXQgd2FzIG5vdA0KPiB2aXNpYmxlIGZyb20gdGhlIGNvbnRl
eHQgb2YgdGhlIGRpZmYuIFRoZSB3aGlsZSBpcyBqdXN0IGEgZmV3IGxpbnMgYmVsb3csDQo+IHRo
dXMgcm05MjAwX3R4X2xlbiBhbmQgcm05MjAwX3R4X3RhaWwgYXJlIHByb3Blcmx5IHByb3RlY3Rl
ZC4gRG8gbm90DQo+IGhlc2l0YXRlIHRvIHRlbGwgbWUgaWYgc29tZXRoaW5nIGlzIG5vdCBjbGVh
ciBvciBpZiBJJ20gd3JvbmchDQoNCldoYXQgSSB3YXMgdHJ5aW5nIHRvIHNheSBpcyB0aGF0IHNp
bmNlIGZvciB0aGlzIHZlcnNpb24gb2YgSVAgVFNSIGlzIG9ubHkNCnJlYWQgb25jZSwgaGVyZSwg
aW4gaW50ZXJydXB0IGNvbnRleHQgYW5kIHRoZSBpZGVhIG9mIHRoZSBsb2NrIGlzIHRvDQpwcm90
ZWN0IHRoZSBscC0+cm05MjAwX3R4X3RhaWwgYW5kIGxwLT5ybTkyMDBfdHhfbGVuLCB0aGUgc3Bp
bl9sb2NrKCkgY2FsbA0KY291bGQgYmUgbW92ZWQganVzdCBiZWZvcmUgd2hpbGU6DQoNCisgICAg
ICAgICAgICAgICBzcGluX2xvY2soJmxwLT5sb2NrKTsNCisNCisgICAgICAgICAgICAgICB0c3Ig
PSBtYWNiX3JlYWRsKGxwLCBUU1IpOw0KKw0KKyAgICAgICAgICAgICAgIC8qIHdlIGhhdmUgdGhy
ZWUgcG9zc2liaWxpdGllcyBoZXJlOg0KKyAgICAgICAgICAgICAgICAqICAgLSBhbGwgcGVuZGlu
ZyBwYWNrZXRzIHRyYW5zbWl0dGVkIChUR08sIGltcGxpZXMgQk5RKQ0KKyAgICAgICAgICAgICAg
ICAqICAgLSBvbmx5IGZpcnN0IHBhY2tldCB0cmFuc21pdHRlZCAoIVRHTyAmJiBCTlEpDQorICAg
ICAgICAgICAgICAgICogICAtIHR3byBmcmFtZXMgcGVuZGluZyAoIVRHTyAmJiAhQk5RKQ0KKyAg
ICAgICAgICAgICAgICAqIE5vdGUgdGhhdCBUR08gKCJ0cmFuc21pdCBnbyIpIGlzIGNhbGxlZCAi
SURMRSIgb24gUk05MjAwLg0KKyAgICAgICAgICAgICAgICAqLw0KKyAgICAgICAgICAgICAgIHFs
ZW4gPSAodHNyICYgTUFDQl9CSVQoVEdPKSkgPyAwIDoNCisgICAgICAgICAgICAgICAgICAgICAg
ICh0c3IgJiBNQUNCX0JJVChSTTkyMDBfQk5RKSkgPyAxIDogMjsNCisNCg0KaGVyZQ0KDQorICAg
ICAgICAgICAgICAgd2hpbGUgKGxwLT5ybTkyMDBfdHhfbGVuID4gcWxlbikgew0KDQpMZXQgbWUg
a25vdyBpZiBJJ20gbWlzc2luZyBzb21ldGhpbmcuDQoNClRoYW5rIHlvdSwNCkNsYXVkaXUNCg0K
PiANCj4gVGhhbmtzIQ0KPiBXaWxseQ0KPiA=
