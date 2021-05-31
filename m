Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D30A39593D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhEaKxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:53:20 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:50580
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231208AbhEaKxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 06:53:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJD3qmUhYFeA8gxG7Wyy/3TQMy86sM2RSV7DApbnCFw0Gn7coY6XcBPf4OenpKhXznhTbcFSL3XrIUZ8lFupZObdcLyV3c0VVhSIAFBpuHMbx6C/NLXAc9ZwILtPNJkkpP6omTUchL9jOBLnkFhynFIYTDOSHUgKCCvVOtjZnyDjfzbHxw51hHhYmONRNJIAa6gqYZGt2h+ODdnoiKJyMyshS/y/WnSbPtsIObgLo5UMrB+FsV+FtLrSfoarsG5FzXRxdq+ygreCAgwLVO6eaU9xGcfQcKPqQhm6wgucVgONBgwZhE3HbzXEzkQvP/Ym2jA4mQHnRVaM+G8qebN1eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/dwQjvs4+Un/Fzr0O+hdD+JJbWyANNYIQGTbnx9QIY=;
 b=Gx/h+2LATFejKqFoZQOUu6cEKmH5IK5dag/Gzi9F+/nlgc1cijz3eE0g/M3o+/CYqO8dOPAZ0G4n/EAt/5cdy1eqGZnLA46qz0r392aM0Tf7Q9f7fH3y0pcujUSEhyZRZuxuJKKBfjaNqb2eaIVpyiILlNfLwyhjecalS31YbuqXstmG6q8V368CWFdmTL7nt7OZdWGbbzVat2Eo5gOy2n43gGPExnRoGUnEHk8LidViOFClLF/hmZC5w5hoKUgo+rx2/FdLYVCbLxoMIE3Dv2+YzoXmwbMFReu3SCQzWkig+EIDEerKfqrrh6+pI8ntONY8R/ULhKrIWcF9IiCxFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/dwQjvs4+Un/Fzr0O+hdD+JJbWyANNYIQGTbnx9QIY=;
 b=Xk2z1HwKq2zp1GhgpCR6bDPv9nVksnQ7FzFYVxaLAlWrG0P5eM4Im8DuE4TQdfvODZZ37PXUSrPUVQOWyLaQSQmgHeOdveSD8S1cPfQv14Yag/P4EWvPFTj5tmA6z1+yyLW0ZNOQNVe6vLEjHnsazIjO5YYs6AogZ0cAlhJBZJE=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DBBPR04MB7642.eurprd04.prod.outlook.com (2603:10a6:10:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Mon, 31 May
 2021 10:51:36 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 10:51:36 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Topic: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Index: AQHXTfl8MjjmUYWreESzJP4N6mmsJar0KWqAgAlOe5A=
Date:   Mon, 31 May 2021 10:51:36 +0000
Message-ID: <DB7PR04MB5017604C9B3AE7C499B413D3F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
 <20210525123711.GB27498@hoboy.vegasvil.org>
In-Reply-To: <20210525123711.GB27498@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df73aaed-aee0-4f4a-f1c2-08d92422100a
x-ms-traffictypediagnostic: DBBPR04MB7642:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB76420A39701BDF12102461D8F83F9@DBBPR04MB7642.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nsPHzrWCYjsan1H3guxA4WCgE+mCg9jlCWp4S5FzuPAtrt8C/k+G6bMX8H66lVybfknAkEQUEOkD1nlsXbV1tqvwudP/++JkL56J8+ZVPML0k2En8X3/lLEByCzES91t8+Rt6l13BGwrWHbfkAjkjYiyEiCv/3SI6359GVQHgTmpYZBjfsTeP87rCz1UqddvujN5uujP3aI4GjYR3z78SGdZbYwknY6HKwG177YbNGrGx60Iy0ZPANgn3Nzlu/rsKIyY8kncIzItBDyTTWbA/QMaPpm/T2O2Z3FGV2Z4ar+IoKPrmwOqta3Gj6UY3vjV+OTVCYLKp/+q00fjv7xQBMREEgVS9k9CeDb6W0zBvYqIsvqVvmx/dzGbyOzUsgpkB6/0XwLYJ8hqo5NwcYk9oNK5SNhlxHEKmhMkPRfFgW1kL1Am1SXzBKt1mMtvpDS+SXKTyzSYjFy29nojgfAujRuGFp5F/WjVukdqHZCOcoFOHtgik3Gy417UmmViaDa9AUvZaWHHNyZQ4fr5LinBQBfTNqNU8ec4TwEcrEZ09s87wpijJuaiWa4vMUHkfE24dG5K3XFUh1FE4WXaX4mL7NrJ1aW8EVgh4qOU4ky+cWY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39850400004)(396003)(53546011)(54906003)(478600001)(8936002)(76116006)(64756008)(66476007)(66446008)(66556008)(2906002)(6506007)(71200400001)(110136005)(122000001)(316002)(38100700002)(66946007)(86362001)(5660300002)(8676002)(4326008)(55016002)(26005)(9686003)(6636002)(83380400001)(186003)(33656002)(7696005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?YVdKaDlLZVRGUENyQWF5SVVpQXlJZHpveHdWQ0U5ZERzaHBQYlY3aGMwdjA5?=
 =?gb2312?B?eDkvK0haZ0g2V252SU1XZDU5Znp1T2VvQ2Y1Z3crUFc2SWNXUEEvQXRXdXRK?=
 =?gb2312?B?dFk3OHZncTJ0dXBTNEVmYWJkeks1c0xMajVoa21NaGUyUHdDaGRuUWUrWGRs?=
 =?gb2312?B?SE5yUFFOeHVmS2cxbTRDcFVBcXpLU05aZkdyQXNkclZBTXZyVkJvdjhrbmpr?=
 =?gb2312?B?ZW5SRElWTGhhRWdnTk0wZTUrc0g2OFRmdmI3YnBrV296NTdtTDZJWnoxSmlY?=
 =?gb2312?B?T09mYW9wWlRiblp4MHJRTWVVUHZVRnZzVzRLamdkamZqKzVWVjd3eEZMWGdF?=
 =?gb2312?B?RVZyU0M5WnljNUpSc0NQS3RnNFdNcTdPbjlUVmNYY2J5OFVTeHFQYm5DYTVN?=
 =?gb2312?B?Q3RoZWpmSGVVRkxxV2QrWCtodWJsS05YWGRXZWhjdXVWTHZvVkEvaHpCK2xq?=
 =?gb2312?B?Q2FGSWl1OGlpaldWTjFDZUpQS3pUUjMzMGtuN2NXbEg1Nyt4RFZ2dFkvZHFo?=
 =?gb2312?B?amh5QW5uUi9RU1VzZVFydTkvTXdBZHhMMjkxeGJJNkhpQ05kbkRWZEdoUElZ?=
 =?gb2312?B?cVBJRk1LY0ZHVzNaNGtwSnVIRk9XeXNXY1RaSXdqV250czdNekd6U1JWWVlp?=
 =?gb2312?B?RWVJODhaN1ZqUkxaMGphKzBCWUM4cW4wSXhxbmJNNnBQS0ZqVHlzWWFrYXQ0?=
 =?gb2312?B?aHlrbUorSU9BM0g5N01hWWlXa3QrSG5EMUxSb0paODZ0S3EvZkduaXVhcERE?=
 =?gb2312?B?TzNOOGFsNGlwdUE5MHFIaDJwakxYWFNlYmIzQkMxNTMvYVFxWlVBekhUeUNY?=
 =?gb2312?B?UnVYZE1QQ0tBblJZa0ZBaVpXZzBJQy9jTUgydlhlcHVwelY2OEpoZTlGV0FT?=
 =?gb2312?B?c0FabnZlcTh5SGViRjlSQTF3dHpzUVBWcHptRnUzbmp3a2hwZXgyNVJSR1lO?=
 =?gb2312?B?NUFwd2NDdzNkdGl4dlErZ281NTIvWjlwMFFDbFQ1c05rc2RoZ0t3amdLTVpR?=
 =?gb2312?B?NHVQendscmpFWitvdDZPMjVyelJPelNuUVdJdUxmcHRPUjQ4SWdBNlZwU0xz?=
 =?gb2312?B?eXBOVTZxVnBSWmppYXR2U2FxOUxGckpnL2FWSmtzM3g5ejBoQjhNOGNFTVNJ?=
 =?gb2312?B?V1IrKy9rTW5wSjU3M0QyZlprTThzNEIrcnNNNjFZdTIycG9aaUxwM2FtQkxh?=
 =?gb2312?B?Zmo1d1JsMmU1dDFkTEtFTTlENEtMSVpoK3ltVitkcDI3YndtTWxjVkcwT0h4?=
 =?gb2312?B?a25FdDlkdFhlaitzbDVLaVlTdDdqSnhKZlFGYWhMdnpFREtsOWE5Mlp2WGhO?=
 =?gb2312?B?NlhFa29lVmpXcytrSGROREdSamhPQ0RDbU4razFjQVZ3WS9Ba21LanJPSXEw?=
 =?gb2312?B?aDhZNlU3QlUyK2xIV1c5Z2c3bHlQa1MyVndsMlhleVBBNHVVMWorY0NzU0t0?=
 =?gb2312?B?Z0dUT1R6dW1rRHBRQ3dhMEMrTlFaQTArcHRRZ1o4bHhJRVF2em91eUpJWVMr?=
 =?gb2312?B?ZWJjK0YxYmFzd3FheXZ1WXVUME1rZGpsdy9LSXdVSjB2UjhDUTRka1psUHJh?=
 =?gb2312?B?blorMExnOUxGR05mUDMrUWs0TkNUZktIZHl1Y0tacEh3KzRaR1NRakt2MkYz?=
 =?gb2312?B?K3ZSMEFIM2gwUGIwSkJOeHNkcnBTK3VBMlNqYWJtYjkybzBnTWtOWFBMZDJN?=
 =?gb2312?B?ZW9OMUxQMW1rWTdvcHZaY3BFNERyQ09mN1VVUFRIWklpYzc5NnNRQ1VFTFNK?=
 =?gb2312?Q?RzvpuUpOSEPGqiD+HJ4evKuDzq4mdenviApC2R9?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df73aaed-aee0-4f4a-f1c2-08d92422100a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 10:51:36.5127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ybJWGcpfBjg5wLZ2m131x4kyosWws8Ic8ZA6+u0wTHpRrakHf7ykoKydpqjDr+AhtZrvTnP3EqYSrnNngDJwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7642
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2xhdWRpdSBhbmQgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2Vu
dDogMjAyMcTqNdTCMjXI1SAyMDozNw0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+
DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBk
YXZlbWxvZnQubmV0PjsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+
OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW25ldC1u
ZXh0LCB2MiwgNy83XSBlbmV0Yzogc3VwcG9ydCBQVFAgZG9tYWluIHRpbWVzdGFtcA0KPiBjb252
ZXJzaW9uDQo+IA0KPiBPbiBGcmksIE1heSAyMSwgMjAyMSBhdCAxMjozNjoxOVBNICswODAwLCBZ
YW5nYm8gTHUgd3JvdGU6DQo+IA0KPiA+IEBAIC00NzIsMTMgKzQ3MywzNiBAQCBzdGF0aWMgdm9p
ZCBlbmV0Y19nZXRfdHhfdHN0YW1wKHN0cnVjdCBlbmV0Y19odw0KPiAqaHcsIHVuaW9uIGVuZXRj
X3R4X2JkICp0eGJkLA0KPiA+ICAJKnRzdGFtcCA9ICh1NjQpaGkgPDwgMzIgfCB0c3RhbXBfbG87
ICB9DQo+ID4NCj4gPiAtc3RhdGljIHZvaWQgZW5ldGNfdHN0YW1wX3R4KHN0cnVjdCBza19idWZm
ICpza2IsIHU2NCB0c3RhbXApDQo+ID4gK3N0YXRpYyBpbnQgZW5ldGNfcHRwX3BhcnNlX2RvbWFp
bihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1OCAqZG9tYWluKSB7DQo+ID4gKwl1bnNpZ25lZCBpbnQg
cHRwX2NsYXNzOw0KPiA+ICsJc3RydWN0IHB0cF9oZWFkZXIgKmhkcjsNCj4gPiArDQo+ID4gKwlw
dHBfY2xhc3MgPSBwdHBfY2xhc3NpZnlfcmF3KHNrYik7DQo+ID4gKwlpZiAocHRwX2NsYXNzID09
IFBUUF9DTEFTU19OT05FKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArCWhk
ciA9IHB0cF9wYXJzZV9oZWFkZXIoc2tiLCBwdHBfY2xhc3MpOw0KPiA+ICsJaWYgKCFoZHIpDQo+
ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiA+ICsJKmRvbWFpbiA9IGhkci0+ZG9tYWlu
X251bWJlcjsNCj4gDQo+IFRoaXMgaXMgcmVhbGx5IGNsdW5reS4gIFdlIGRvIE5PVCB3YW50IHRv
IGhhdmUgZHJpdmVycyBzdGFydGluZyB0byBoYW5kbGUgdGhlDQo+IFBUUC4gIFRoYXQgaXMgdGhl
IGpvYiBvZiB0aGUgdXNlciBzcGFjZSBzdGFjay4NCj4gDQo+IEluc3RlYWQsIHRoZSBjb252ZXJz
aW9uIGZyb20gcmF3IHRpbWUgc3RhbXAgdG8gdmNsb2NrIHRpbWUgc3RhbXAgc2hvdWxkDQo+IGhh
cHBlbiBpbiB0aGUgY29yZSBpbmZyYXN0cnVjdHVyZS4gIFRoYXQgd2F5LCBubyBkcml2ZXIgaGFj
a3Mgd2lsbCBiZSBuZWVkZWQsDQo+IGFuZCBpdCB3aWxsICJqdXN0IHdvcmsiIGV2ZXJ5d2hlcmUu
DQoNClRoYXQncyBwZXJmZWN0IHdheS4NCg0KPiANCj4gV2UgbmVlZCBhIHdheSB0byBhc3NvY2lh
dGUgYSBnaXZlbiBzb2NrZXQgd2l0aCBhIHBhcnRpY3VsYXIgdmNsb2NrLg0KPiBQZXJoYXBzIHdl
IGNhbiBleHRlbmQgdGhlIFNPX1RJTUVTVEFNUElORyBBUEkgdG8gYWxsb3cgdGhhdC4NCg0KSG93
IGFib3V0IGFkZGluZyBhIGZsYWcgU09GX1RJTUVTVEFNUElOR19CSU5EX1BIQywgYW5kIHJlZGVm
aW5pbmcgdGhlIGRhdGEgcGFzc2luZyBieSBzZXRzb2Nrb3B0IGxpa2UsDQoNCnN0cnVjdCB0aW1l
c3RhbXBpbmcgew0KICAgICAgIGludCBmbGFnczsNCiAgICAgICB1OCBod3RzdGFtcF9waGM7IC8q
cGhjIGluZGV4ICovDQp9Ow0KDQpUaGUgc29jayBjb3VsZCBoYXZlIGEgbmV3IG1lbWJlciBza19o
d3RzdGFtcF9waGMgdG8gcmVjb3JkIGl0Lg0KDQo+IA0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30N
Cj4gDQo+IFRoYW5rcywNCj4gUmljaGFyZA0K
