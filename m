Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC5427A930
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgI1H6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:58:46 -0400
Received: from mail-vi1eur05on2051.outbound.protection.outlook.com ([40.107.21.51]:36704
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726440AbgI1H6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 03:58:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwl4lwpURpHia2AGKklRPiqAw+5vh8EjWT/4h3Zg5QD7gF36z0kxNBwYBxjLxfOyKdSAgzgQzEUfn/kHFTz7AY8FraNJwnEGWTA7FoylAO9CaNrmVKq1o05V0QeZHm/6l5s7HD0qN9StDybUZwSCu98+LJV6N9nfYbM/iXGKv8xw7yVG3B5sdFr+8b2kwTK0nt7W6ghLR4lRl3ZwrWmdIU6mfNZx+gmlkRerte8PPC/gro9HeAMx5UARMuYUP4cy1flLAvJYzj3S1jmuuFmt4JVLwYgPTHf6dK7PcPDs17/PY5WKaXonVGbFjKAGSbfYeM9PVY8Rhgwk4wvFe5+xhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrDuSkkkXMxiwuYp0Q1Tqqd/VO5O2L5aN3QD5KFeIIs=;
 b=PeaLgcgVMD3vZL3IMjuMaI3n7p2I5c+wYLUUB+0usPe2BOi9YsDIh5qm1AKPVk5qcoGP8zyD9JNGz5WFaISptd0JRnYym88eb1TqGDYCEJZoStXapNOGXQ7xtjQpOJ1Aov2GV6kuyWJ0s2H1VPco1hIF8IFB2G/vd6XKkHysMGcLJDrlYMxMy72YVTZsldaUnA/SCKA940tWwP9cSnnFnxIPbFxVbOHxxHpfPD+XHAuTq7vX8grvVez0gFlWzyKBUMWbPm00SJyJff49C6vgm0KzZ8JDHOZ4lw5spmv5uWHZhg9Marjw1DyTmLsMslQLeRdK3xkwJ1sliqFvgc75Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrDuSkkkXMxiwuYp0Q1Tqqd/VO5O2L5aN3QD5KFeIIs=;
 b=H+oFLaSqXwknxiTjWAy6rL183lCScVBCw5KrtDYvA76mppHlv8Gaxa8N4JqyH9vQ8kwM1hbTEWloPO7pSm9tDAlfvKsKryPHuCf7IYZ7qOuV4O5WdCraUjSqCCv2LMPWJtOO26cDKtcFZirele058rAmiZ6TiD5SF7bOGN94tOQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6137.eurprd04.prod.outlook.com (2603:10a6:10:c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Mon, 28 Sep
 2020 07:58:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 07:58:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Topic: [PATCH linux-can-next/flexcan 1/4] can: flexcan: initialize all
 flexcan memory for ECC function
Thread-Index: AQHWkwrxc33Q4pOyMEiSJX13xMzIVal49QgAgAMfcACAANYAAIAAZbnggABUGYCAAA5kEA==
Date:   Mon, 28 Sep 2020 07:58:41 +0000
Message-ID: <DB8PR04MB679575A5E8EE9C7534A446BAE6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-2-qiangqing.zhang@nxp.com>
 <f98dcb18-19f9-9721-a191-481983158daa@pengutronix.de>
 <DB8PR04MB6795C88B839FE5083283E157E6340@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <4490a094-0b7d-4361-2c0a-906b2cff6020@pengutronix.de>
 <DB8PR04MB679574C44EC1B2D401C9B5D1E6350@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <3910f513-1a47-5128-1a78-f412a0904911@pengutronix.de>
In-Reply-To: <3910f513-1a47-5128-1a78-f412a0904911@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7e9c9156-1162-4533-0069-08d8638450a8
x-ms-traffictypediagnostic: DBBPR04MB6137:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB61379A52222E3C87B8EDA716E6350@DBBPR04MB6137.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LTcYpcupH1tGTv8u585W6cf6NXWvSHqirvllx6KPieD7B1seJyqsBLwqwZbj8zWIcdDiQJm3/PM7DECyp2UZmlJsXdiJ3xb8dhkU77t4+4Chl9SeZtOaYrWJ6u4hczN+RVLSAoIAZo8ci7pY5GDkwbziJlOOW50zxCiSelRq4GMH3OdklaVMmxrj9W7RDW8Im4q9IMYks8A+2gvZlU469rsQAfE+vsORONyBa05ld3RTo45p6y538cFiCfNOZ6ttr8JDjbQ/q0ArwR1eN76E1sKKUEtUor2diSRZGDX+H3HW8Krah5SOZwzxmMqpuSnonLUopqb/xvHBJEBuvu6gEp6IIouhHMiK4O9EfkcWzfukvDeSvoy1eKXp53T44uSOwi9sCFqStpBqMEkJLXWAqiuakm9erhDdCwbsc2ZAyXcFf+veCnFo1CDCHHzzvavnYy8HdsDJvQggATRRW6S+vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(66556008)(2906002)(966005)(71200400001)(8936002)(8676002)(52536014)(86362001)(478600001)(26005)(66476007)(83080400001)(64756008)(66446008)(33656002)(186003)(4326008)(110136005)(66946007)(76116006)(5660300002)(6636002)(9686003)(7696005)(83380400001)(316002)(54906003)(6506007)(55016002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 4nPzk8/bSM04aZvigzkxKMwmZW7dnJ+uFnoxHLjFIM0q/j8Xnn/ZAA4Omn/KNM7CT/5etbih1wgwA+HSwycFdnj8hJGubWgfuqX7qx52YIsfB6Z5IZ5DDk7vw41G+Ognw7L9EUlo3znq6oLlr/IUBvPlISwXlmXT8FB0oYlIvKT6Navu9E8bfg8p4i7SaNpKbpzW8dZFiz+yB7uNxmCrmr9VoY9Mc9wDgPVTsIbOPCRAW6DYKwqtTCIQz2LQy0BxenILY/Alql6YIJHyGprnRiBxfAWLvuI+9hTVFs6EoVj2OnHZrpjq+S/zBYin8lNd7tQpBrJ3qRkOohgXd4WOvi2D9edun8SndCkoJJcehwFWh1Gk4lk1zC81WH2kHHV8yqjetKTh1vSLNOEhKrQ2tSj2FI0IrqZj+EhhHrcGZySCUPYzG30R9WghK+z+5yzrTIGuaSF2uBGD0JHAslRFBrmzv8+dbWjHiybSdupFidswY/MbD1LGAaUEAckq+r+2eKBGZM+uBUb0bLzLYKSkKIQfMK3e4NQYkGNjWjnnnZeuAT7yvtXcpeWFxVLb75NfbhO0ovu7ky/K5rcHtUl5I1uwqgGgQoAGPzARO5oOy7j05C4PJ01Z8ArxffNfRGFy9b+A85PtpDrlDlMAxM14LQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9c9156-1162-4533-0069-08d8638450a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 07:58:41.1969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: odAAKi2mMCGYIgQw+ujs08AXNNb+96H6nNu2S39xC4T3BmIOA3zCP6UglNkB9nb/hi3YEvjFlp1+L4rgh4Vd7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjjml6UgMTU6MDENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnOw0KPiBQYW5rYWogQmFuc2FsIDxwYW5rYWouYmFuc2FsQG54cC5jb20+DQo+
IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0L2ZsZXhjYW4gMS80XSBj
YW46IGZsZXhjYW46IGluaXRpYWxpemUgYWxsIGZsZXhjYW4NCj4gbWVtb3J5IGZvciBFQ0MgZnVu
Y3Rpb24NCj4gDQo+IE9uIDkvMjgvMjAgNDoyNyBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+
PiBJZiBpdCdzIE9LIG9uIGFsbCBTb0NzIHRvIGluaXRpYWxpemUgdGhlIGNvbXBsZXRlIFJBTSBh
cmVhLCBqdXN0IGRvDQo+ID4+IGl0LiBUaGVuIHdlIGNhbiBnZXQgcmlkIG9mIHRoZSBwcm9wb3Nl
ZCBzdHJ1Y3QgYXQgYWxsLg0KPiA+DQo+ID4gU2hvdWxkIGJlIE9LIGFjY29yZGluZyB0byBJUCBn
dXlzIGZlZWRiYWNrcy4NCj4gDQo+IEdvb2QhDQo+IA0KPiA+IHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
ZmxleGNhbl9kZXZ0eXBlX2RhdGEgZnNsX3ZmNjEwX2RldnR5cGVfZGF0YSA9IHsNCj4gPiAJLnF1
aXJrcyA9IEZMRVhDQU5fUVVJUktfRElTQUJMRV9SWEZHIHwNCj4gRkxFWENBTl9RVUlSS19FTkFC
TEVfRUFDRU5fUlJTIHwNCj4gPiAJCUZMRVhDQU5fUVVJUktfRElTQUJMRV9NRUNSIHwNCj4gRkxF
WENBTl9RVUlSS19VU0VfT0ZGX1RJTUVTVEFNUCB8DQo+ID4gCQlGTEVYQ0FOX1FVSVJLX0JST0tF
Tl9QRVJSX1NUQVRFLA0KPiA+IH07DQo+ID4NCj4gPiBzdGF0aWMgY29uc3Qgc3RydWN0IGZsZXhj
YW5fZGV2dHlwZV9kYXRhIGZzbF9sczEwMjFhX3IyX2RldnR5cGVfZGF0YSA9IHsNCj4gPiAJLnF1
aXJrcyA9IEZMRVhDQU5fUVVJUktfRElTQUJMRV9SWEZHIHwNCj4gRkxFWENBTl9RVUlSS19FTkFC
TEVfRUFDRU5fUlJTIHwNCj4gPiAJCUZMRVhDQU5fUVVJUktfRElTQUJMRV9NRUNSIHwNCj4gRkxF
WENBTl9RVUlSS19CUk9LRU5fUEVSUl9TVEFURSB8DQo+ID4gCQlGTEVYQ0FOX1FVSVJLX1VTRV9P
RkZfVElNRVNUQU1QLA0KPiA+IH07DQo+ID4NCj4gPiBzdGF0aWMgY29uc3Qgc3RydWN0IGZsZXhj
YW5fZGV2dHlwZV9kYXRhIGZzbF9seDIxNjBhX3IxX2RldnR5cGVfZGF0YSA9IHsNCj4gPiAJLnF1
aXJrcyA9IEZMRVhDQU5fUVVJUktfRElTQUJMRV9SWEZHIHwNCj4gRkxFWENBTl9RVUlSS19FTkFC
TEVfRUFDRU5fUlJTIHwNCj4gPiAJCUZMRVhDQU5fUVVJUktfRElTQUJMRV9NRUNSIHwNCj4gRkxF
WENBTl9RVUlSS19CUk9LRU5fUEVSUl9TVEFURSB8DQo+ID4gCQlGTEVYQ0FOX1FVSVJLX1VTRV9P
RkZfVElNRVNUQU1QIHwNCj4gRkxFWENBTl9RVUlSS19TVVBQT1JUX0ZELCB9Ow0KPiANCj4gPiBJ
IGFtIGNoZWNraW5nIGxheWVyc2NhcGUncyBDQU4gc2VjdGlvbjoNCj4gPg0KPiA+IFRoZXJlIGlz
IG5vIEVDQyBzZWN0aW9uIGluIExTMTAyMUENCj4gPiBodHRwczovL3d3dy5ueHAuY29tL3Byb2R1
Y3RzL3Byb2Nlc3NvcnMtYW5kLW1pY3JvY29udHJvbGxlcnMvYXJtLXByb2NlDQo+ID4gc3NvcnMv
bGF5ZXJzY2FwZS1tdWx0aWNvcmUtcHJvY2Vzc29ycy9sYXllcnNjYXBlLTEwMjFhLWR1YWwtY29y
ZS1jb21tdQ0KPiA+IG5pY2F0aW9ucy1wcm9jZXNzb3Itd2l0aC1sY2QtY29udHJvbGxlcjpMUzEw
MjFBP3RhYj1Eb2N1bWVudGF0aW9uX1RhYg0KPiANCj4gSG1tbSwgd2h5IGRvZXMgdGhlIExTMTAy
MUEgaGF2ZSAiRkxFWENBTl9RVUlSS19ESVNBQkxFX01FQ1IiPyBUaGUNCj4gYml0cyBpbiB0aGUN
Cj4gY3RybDIgYW5kIHRoZSBtZWNyIHJlZ2lzdGVyIGl0c2VsZiB1c2VkIGluIHRoZSBxdWlyayBh
cmUgbWFya2VkIGFzIHJlc2VydmVkIGluDQo+IHRoaXMgZGF0YXNoZWV0Li4uLg0KPiANCj4gQ2Fu
IEBQYW5rYWogQmFuc2FsIGNsYXJpZnkgdGhpcz8NCj4gDQo+ID4gRUNDIHNlY3Rpb24gaW4gTFgy
MTYwQSwgYWxzbyBjb250YWlucyB0aGUgc2FtZSBOT1RFIGFzIGkuTVg4TVAuDQo+ID4gaHR0cHM6
Ly93d3cubnhwLmNvbS9wcm9kdWN0cy9wcm9jZXNzb3JzLWFuZC1taWNyb2NvbnRyb2xsZXJzL2Fy
bS1wcm9jZQ0KPiA+IHNzb3JzL2xheWVyc2NhcGUtbXVsdGljb3JlLXByb2Nlc3NvcnMvbGF5ZXJz
Y2FwZS1seDIxNjBhLW11bHRpY29yZS1jb20NCj4gPiBtdW5pY2F0aW9ucy1wcm9jZXNzb3I6TFgy
MTYwQT90YWI9RG9jdW1lbnRhdGlvbl9UYWINCj4gDQo+ID4gSGkgQFBhbmthaiBCYW5zYWwsIGNv
dWxkIHlvdSBwbGVhc2UgYWxzbyBoYXZlIGEgY2hlY2s/DQo+IENhbiBzb21lb25lIGNoZWNrIHRo
ZSB2ZjYxMCwgdG9vPw0KDQpJIGNoZWNrIHRoZSBWRjYxMCBSTSBqdXN0IG5vdywgaW5kZWVkIGl0
IGhhcyBFQ0MgZmVhdHVyZSwgdGhlcmUgaXMgYWxzbyBhIE5PVEUgaW4gIjEyLjEuNC4xMyBEZXRl
Y3Rpb24gYW5kIENvcnJlY3Rpb24gb2YgTWVtb3J5IEVycm9ycyIgc2VjdGlvbjoNCg0KQWxsIEZs
ZXhDQU4gbWVtb3J5IG11c3QgYmUgaW5pdGlhbGl6ZWQgYmVmb3JlIHN0YXJ0aW5nIGl0cw0Kb3Bl
cmF0aW9uIGluIG9yZGVyIHRvIGhhdmUgdGhlIHBhcml0eSBiaXRzIGluIG1lbW9yeSBwcm9wZXJs
eQ0KdXBkYXRlZC4gVGhlIFdSTUZSWiBiaXQgaW4gQ29udHJvbCAyIFJlZ2lzdGVyIChDVFJMMikN
CmdyYW50cyB3cml0ZSBhY2Nlc3MgdG8gYWxsIG1lbW9yeSBwb3NpdGlvbnMgZnJvbSAweDA4MCB0
bw0KMHhBREYuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiByZWdhcmRzLA0KPiBN
YXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICB8IE1hcmMg
S2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAg
ICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0Rv
cnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2Vy
aWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8
DQoNCg==
