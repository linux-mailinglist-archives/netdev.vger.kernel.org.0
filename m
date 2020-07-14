Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B7921E75B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 07:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgGNFLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 01:11:36 -0400
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:45988
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbgGNFLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 01:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+E1nEHQoIGHoZElShzjPIg10DCEQn+1zvpz6z/FSLEhGuEn3OnK3CTURMdl+FNuAx4ReoLQ/qYAii/qo1FUnH+h4TIN+haSeOBLzRbiwkgVijxCkiBUacdWKdmaXnu7PhuS3Z5U+y1uU62BWIseGNHk/Cqr32r7HoHPsSAhLs2NpUx0S9Oe0hIZ807yNeLk0OMNrpOKajpUMZr+W3wrJVL2K+WDfn9yb7eHkZp21/Pm6pI9YTqPq+Qmkks7HSa1uuD1VQYjdNchoIeATS1E6fkAbGfT1jdicNFQU66KHGAWXoOXv22N11cFy9O0nK/V0228OO3Qxnib+kP/aHz1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uoL47CLPB+0TWAukfhQWiJaNMTO1rBln/5Qy9enc+U=;
 b=DLIXvmoqmr6DGrpc7s8Coi12NKGCUYyoVW57Fh0gQBzg9iKMX2GT6n+39O4CR5Gz89mxp7VjUGti7NYL31Ce+wAUu39QPaAzackGsxY4cF68U2oT0RDk2K/dSEIXo/o6HG8UstnOESKKc3FYCRy6U1dpXOG86ci/eUcGowpcTbiqEbs25cjSq1GhHwwSA6aWVaE1Ga80z4S5zK4UJpneTdorNPxW2/JVbtNGJkkC1DfLUDjabkbZ4Jc1gd7gKIHKykyTaqbzmAyTwZDddKpmerUBo/nMqkcDXbSknNirvMXrPeKtn429tCH3QzrBwA6ch8qrZCtU24XztkwuUfcsUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uoL47CLPB+0TWAukfhQWiJaNMTO1rBln/5Qy9enc+U=;
 b=KXXr5MlRAC++wjtAWU5wreD77UBeFFFB2jrIxflDm2c9uP36eAZ/XYU2ontbYHcSUjXzKCBNbYBFto33Kst00uAPiYJYREDsRh3O/Q28ngx9n6DwmP8ESVSutuMxRnxUKyPZLTB9pRJgdRCAZJg83I7xCTzYqRYPEKMCMluNvds=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3710.eurprd05.prod.outlook.com (2603:10a6:803:8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 05:11:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 05:11:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next 00/13] Mellanox, mlx5 CT updates
 2020-07-09
Thread-Topic: [pull request][net-next 00/13] Mellanox, mlx5 CT updates
 2020-07-09
Thread-Index: AQHWVmza2mFJQtZsm0yB2Uoj5f0/fqkBUKsAgAU88AA=
Date:   Tue, 14 Jul 2020 05:11:31 +0000
Message-ID: <31e978781676414b91c44fc02b9f200bae9bc863.camel@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
         <20200710.141204.1000719994162068882.davem@davemloft.net>
In-Reply-To: <20200710.141204.1000719994162068882.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c743772-0fcf-4bd1-fdcd-08d827b45f28
x-ms-traffictypediagnostic: VI1PR0502MB3710:
x-microsoft-antispam-prvs: <VI1PR0502MB3710EC876424BA43815D74CEBE610@VI1PR0502MB3710.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fAaepTiOahUshAB0ADG/WBi1nmTi/LzW8wljEuDPVF875u53tGy8+QtTf/wrRzDg3PgZGTC694J76rTEiOQ0DLrvequ70ueDaeik4R8bwny99pzaG85j/yb/nWXsQvI7Uz1Eu3ftGTZMee5Mvz4L8BojrD/3tGDmQBMhCGQ698Pws9NQ5Z0ycYrd+OnPOqPw79UhGqm4QaFX4bkLMSh+9U70736CB2vA2gqi4YMgnkF9cdd7YVkyHiJEz5vJA3ENJ28esaghlwpYT7htYT/FWXi88jjpIdFRldkYJmSTjH5UfnEusLsW8Y81lXUlfMFI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(36756003)(86362001)(8676002)(76116006)(15650500001)(316002)(66946007)(91956017)(186003)(5660300002)(66556008)(64756008)(71200400001)(26005)(4326008)(2616005)(66476007)(66446008)(478600001)(2906002)(6512007)(54906003)(83380400001)(8936002)(6506007)(6916009)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BDfumI+Vcwt47SelRRWrBsVDuyQKCSUzfpH9EpLrvmoO1LZg2pN93DPLgK2xIstX6KPSlEKoKzWdl/zwhK59cPJSJQShGlDjD3/Pw+1x+3uTtcSBlj1SfkM0/gbok/s0m+y2HUE1OkrbOTS+cbwahn2qtv0sujQ+VRaqUXuiAW9yiCVfR2Mmtb2bn+qDVsMvghv+8dgVwaShmqHfJCKVDozL8Vho4nluNs7HGr/n/8CMhIXtLUzSiVRdgmn0oRKnwfCc+NuKF5PeZ0u+o9PF7NcghGzNTzYIDjvy0B1SWRtat/yWt17kexmCkvn5LecBLORG8jWQcMvKPokDCnHStTGFC2hTqCwwlrBIEGVeBNX1erO9qQ6+SdTwBrcLQmt8IAk+S75LUOWjArQ+kQE635RNce7sMn+Cc7vjBHUQ8whhJxqpgqzc5W4i2jn1IUzYnvJXM8kw3491fe8PiUY0BSkk6R/XJs4IR6cEKglNNH4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F84D906E3C9FE540A0104A033179DCF2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c743772-0fcf-4bd1-fdcd-08d827b45f28
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 05:11:31.6104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yFjThWMLuExtQzWgY6w2X360RO2AJ3/WAfafXOf8EQGo7OxY0AgtsB67QtUIwVrgQx9cmAC36B1TN+iQv4Khrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDE0OjEyIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUaHUs
ICA5IEp1bCAyMDIwIDIwOjQ0OjE5IC0wNzAwDQo+IA0KPiA+IFRoaXMgc2VyaWVzIHByb3ZpZGVz
IHVwZGF0ZXMgdG8gbWx4NSBDVCAoY29ubmVjdGlvbiB0cmFja2luZykNCj4gb2ZmbG9hZHMNCj4g
PiBGb3IgbW9yZSBpbmZvcm1hdGlvbiBwbGVhc2Ugc2VlIHRhZyBsb2cgYmVsb3cuDQo+ID4gDQo+
ID4gUGxlYXNlIHB1bGwgYW5kIGxldCBtZSBrbm93IGlmIHRoZXJlIGlzIGFueSBwcm9ibGVtLg0K
PiANCj4gUHVsbGVkLg0KPiANCj4gPiBUaGUgZm9sbG93aW5nIGNvbmZsaWN0IGlzIGV4cGVjdGVk
IHdoZW4gbmV0IGlzIG1lcmdlZCBpbnRvIG5ldC0NCj4gbmV4dDoNCj4gPiB0byByZXNvbHZlIGp1
c3QgdXNlIHRoZSBodW5rcyBmcm9tIG5ldC1uZXh0Lg0KPiA+IA0KPiA+IDw8PDw8PDwgSEVBRCAo
bmV0LW5leHQpDQo+ID4gICAgICAgbWx4NV90Y19jdF9kZWxfZnRfZW50cnkoY3RfcHJpdiwgZW50
cnkpOw0KPiA+ICAgICAgIGtmcmVlKGVudHJ5KTsNCj4gPiA9PT09PT09IChuZXQpDQo+ID4gICAg
ICAgbWx4NV90Y19jdF9lbnRyeV9kZWxfcnVsZXMoY3RfcHJpdiwgZW50cnkpOw0KPiA+ICAgICAg
IGtmcmVlKGVudHJ5KTsNCj4gPj4+Pj4+Pj4gYjFhN2Q1YmRmZTU0Yzk4ZWNhNDZlMmM5OTdkNGUz
YjE0ODRhNDlhZg0KPiANCj4gVGhhbmtzIGZvciB0aGlzLg0KPiANCj4gSWYgeW91IGNvdWxkIHB1
dCB0aGlzIGluZm8gaW50byB0aGUgbWVyZ2UgY29tbWl0IG1lc3NhZ2UgSSdkDQo+IGFwcHJlY2lh
dGUgaXQuDQo+IA0KDQpTdXJlIGkgY2FuIGRvIHRoaXMuDQoNCkJ1dCBhdCB0aGUgdGltZSBvZiB0
aGlzIHN1Ym1pc3Npb24gdGhlcmUgd2Fzbid0IGFueSBjb25mbGljdCwgYW5kIEkNCmNvdWxkbid0
IGRldGVybWluZSBhaGVhZCBvZiB0aW1lIGlmIHlvdSBhcmUgZ29pbmcgdG8gbWVyZ2UgbmV0IG9y
IHRoaXMNCnB1bGwgcmVxdWVzdCBmaXJzdC4NCg0KDQo+IEkgYWRkZWQgaXQgaW4gYnkgaGFuZCB0
aGlzIHRpbWUuDQo+IA0KPiBUaGFua3MgYWdhaW4uDQo=
