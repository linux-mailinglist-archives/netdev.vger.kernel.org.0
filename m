Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C710722F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 13:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfKVMbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 07:31:35 -0500
Received: from mail-eopbgr130050.outbound.protection.outlook.com ([40.107.13.50]:51168
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726620AbfKVMbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 07:31:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqYlBasDKvmGFtL54YnaKRpPjOiKetvxoJoB5yVZiHp4ss7mS1gYGRgblfpenwZm2ufz9EruFo2F/oTDR5OyAc+CLIhC0TvCXs35Vt3ZYBNJ+RH7t0Tjh7H+IRjT7c2Sld3AhN33nal8MSo355MtWr35K1bPExj1nzSatT1Xl5L+xMOLaT8D874PEbhMoVzSTea4ZKU1S/WtUD/s1P38d+x6qHKWwJ2AjH8VNAVfqUIZTyRD5RXiP1t9h0JhemiDIblHhYjwfyFdk44G4WA5sTMT/yYkjhatQuAVa1b97KVIq7Bk+kwKPPyM7KqVeQKkrNEg0Nc9VruzDXuSjlXYBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcShyZa94OrpZ02irqe8DqfMECrkj2A8xdXJrOV66ho=;
 b=RuTHxVgqhFgVmpUBmKa4p4cFa1Z02FYGgPN9hNcDSGynESPi6ULOjj6nMHs/nXlcsrEPeytv3Ij/gAe4+W2fwVncM4BLH6xYxw262ftd+6mNuRo2eDE5gRjN6c1dYmFnI6CqmyeK5lb3Di1IJQcIGCsfz1ro0HShhcl4+wOXmAhB4hmO/5KOocZY2uAdh4Zahf7ZvNFoll2EVUc8Am5KoX+0U4+7XdURz+KOe1OYOLRW2fKEAuC4BZ0g0A/xXlkvZQMELFC0N9pxzZ0A5oDUTPOuwcM1qfhCD3xKCyDF2uqrXd+X1enH5Y/NSNLe+5xKry0F58o4ohBYzzUbN1kKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcShyZa94OrpZ02irqe8DqfMECrkj2A8xdXJrOV66ho=;
 b=WWVaVgL4kSKqTS6W6cy98J4XQJrSppNs2o9Yo7xLRXI22zygvMjAt/6l9vzFVLALzPavRr8QaIABk2hHA2Cn4jfRyNV2u8A6L4FahvBp0BzqkUtFdtWDl5Hn57DILjrJX8LFKGRwNigBcWfaQNldop5BeG2Gw0SRu4k8jAeW/5o=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB3230.eurprd04.prod.outlook.com (10.170.227.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 12:31:31 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb%6]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 12:31:31 +0000
From:   Alexandru Marginean <alexandru.marginean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: binding for scanning a MDIO bus
Thread-Topic: binding for scanning a MDIO bus
Thread-Index: AQHVoTDE9xOhoRGcSEOsjw1fon1gCw==
Date:   Fri, 22 Nov 2019 12:31:30 +0000
Message-ID: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexandru.marginean@nxp.com; 
x-originating-ip: [178.199.190.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2b47265b-0d4b-45be-49c8-08d76f47e754
x-ms-traffictypediagnostic: VI1PR04MB3230:
x-microsoft-antispam-prvs: <VI1PR04MB3230DF5D3FB28075C370634BF5490@VI1PR04MB3230.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(189003)(199004)(53754006)(6512007)(71200400001)(71190400001)(66446008)(6436002)(6486002)(7736002)(305945005)(478600001)(554214002)(99286004)(64756008)(66476007)(54906003)(110136005)(4326008)(91956017)(66946007)(14454004)(66556008)(76116006)(316002)(256004)(66066001)(5660300002)(2616005)(31686004)(3846002)(2906002)(6116002)(8936002)(81156014)(8676002)(31696002)(86362001)(81166006)(44832011)(6506007)(186003)(26005)(102836004)(25786009)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3230;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i2ioj5m9XM4IhV/J60jPO6RHwgEzDuHPPVNnfl4I1PZqCG/w/LcFNeq9h6vvq+96zYRkv9xHCYbJsJTozVNh0p4kIuEr8eU0dZNGK5y3o88X64AROorw/vbPcfKikrpariU/cGXN+wH2DBpoNVid4jOvG4StIBA1MVg2lO0GL3Zo4sSEhOeM1Nq/jN/xbP82ENxk5/hHRJaLeCaEnm5f4UpxIsaM2XD9+bioquN+oeiKkTsc8YbYQD2d2YPdRH3CsYcGMc2WmisWd53MZeJ5lcUu5ZABy/DXktaHBHqDap5FMOAEpNOLaaBi95eHqQ+dl0zI5EaU4KXhzrT0+KVefS/HJsWBDKrsWUH2/2kHO+kkr9C0ihkcHyEZ2N3ibatcflZz3xvh7mESZBTL5ZwgAiEpQMp0Ri5ezI8uPzw5sHBtMh1fcSHqYZvaUgqRV3lO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FC4171EB4039E4DB3995E2F00A210E4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b47265b-0d4b-45be-49c8-08d76f47e754
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 12:31:30.9806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XzJNt6oXgxXVlo3MA8MLe+/83ZS1avTXcqLJDC4iqDo/xCoz9pT+FO3TLaOcIChBhKEexxxOylCgnVQf+0Rc91d9SjnGdCzTqApoja8B/LQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3230
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgZXZlcnlvbmUsDQoNCkkgYW0gbG9va2luZyBmb3IgdGhlIHByb3BlciBiaW5kaW5nIHRvIHNj
YW4gZm9yIGEgUEhZIG9uIGFuIE1ESU8gYnVzIA0KdGhhdCdzIG5vdCBhIGNoaWxkIG9mIHRoZSBF
dGhlcm5ldCBkZXZpY2UgYnV0IG90aGVyd2lzZSBpcyBhc3NvY2lhdGVkIA0Kd2l0aCBpdC4gIFNj
YW5uaW5nIHRoaXMgYnVzIHNob3VsZCBndWFyYW50ZWUgZmluZGluZyB0aGUgY29ycmVjdCBQSFks
IGlmIA0Kb25lIGV4aXN0cy4gIEFzIGZhciBhcyBJIGNhbiB0ZWxsIGN1cnJlbnQgYmluZGluZ3Mg
ZG9uJ3QgYWxsb3cgc3VjaCANCmFzc29jaWF0aW9uLCBhbHRob3VnaCB0aGUgY29kZSBzZWVtcyB0
byBzdXBwb3J0IGl0Lg0KDQpUaGUgaGFyZHdhcmUgdGhhdCBJJ20gdXNpbmcgYW5kIGNvdWxkIHVz
ZSBzdWNoIGEgYmluZGluZyBpcyBhIE5YUCBRRFMgDQpib2FyZCB3aXRoIFBIWSBjYXJkcy4gIElu
IHBhcnRpY3VsYXIgdGhpcyBpcyBhIExTMTAyOEEsIGJ1dCB0aGUgcHJvYmxlbSANCmlzIGNvbW1v
biB0byB0aGUgTlhQIFFEUyBib2FyZHMuICBUaGVzZSBjYXJkcyB3aXJlIE1ESU8gdXAgdG8gdGhl
IENQVSANCnRocm91Z2ggYSBtdXguICBUaGUgbXV4IHByYWN0aWNhbGx5IHNlbGVjdHMgb25lIG9m
IHRoZSBzbG90cy9jYXJkcyBzbyANCnRoZSBNRElPIGJ1cyB0aGUgUEhZIGlzIG9uIGlzIHByaXZh
dGUgdG8gdGhlIHNsb3QvY2FyZC4NCkVhY2ggc2xvdCBpcyBhbHNvIGFzc29jaWF0ZWQgd2l0aCBh
biBFdGhlcm5ldCBpbnRlcmZhY2UsIHRoaXMgaXMgc3ViamVjdCANCnRvIHNlcmRlcyBjb25maWd1
cmF0aW9uIGFuZCBzcGVjaWZpY2FsbHkgZm9yIHRoYXQgSSdtIGxvb2tpbmcgdG8gYXBwbHkgYSAN
CkRUIG92ZXJsYXkuICBPdmVybGF5cyBhcmUgcmVhbGx5IGltcHJhY3RpY2FsIHdpdGggdGhlIFBI
WSBjYXJkcyB0aG91Z2gsIA0KdGhlcmUgYXJlIHNldmVyYWwgdHlwZXMgb2YgY2FyZHMsIG51bWJl
ciBvZiBzbG90cyBjYW4gZ28gdXAgdG8gOCBvciBzbyANCm9uIHNvbWUgdHlwZXMgb2YgUURTIGJv
YXJkcyBhbmQgbnVtYmVyIG9mIFBIWSBjYXJkIG92ZXJsYXlzIHRoYXQgc2hvdWxkIA0KYmUgZGVm
aW5lZCB3b3VsZCBibG93IHVwLiAgVGhlIG51bWJlciBvZiBvdmVybGF5cyB1c2VycyB3b3VsZCBu
ZWVkIHRvIA0KYXBwbHkgYXQgYm9vdCB3b3VsZCBhbHNvIGdvIHVwIHRvIG51bWJlciBvZiBzbG90
cyArIDEuDQoNClRoZSBmdW5jdGlvbiBvZl9tZGlvYnVzX3JlZ2lzdGVyIGRvZXMgc2NhbiBmb3Ig
UEhZcyBpZiAncmVnJyBpcyBtaXNzaW5nIA0KaW4gUEhZIG5vZGVzLCBpcyB0aGlzIGNvZGUgY29u
c2lkZXJlZCBvYnNvbGV0ZSwgaXMgaXQgT0sgdG8gdXNlIGl0IGlmIA0KbmVlZGVkIGJ1dCBvdGhl
cndpc2UgZGlzY291cmFnZWQ/ICBBbnkgdGhvdWdodHMgb24gaW5jbHVkaW5nIHN1cHBvcnQgZm9y
IA0Kc2Nhbm5pbmcgaW4gdGhlIGJpbmRpbmcgZG9jdW1lbnQsIGxpa2UgbWFraW5nICdyZWcnIHBy
b3BlcnR5IGluIHBoeSANCm5vZGVzIG9wdGlvbmFsPw0KDQpGb3Igd2hhdCBpcyB3b3J0aCBzY2Fu
bmluZyBpcyBhIGdvb2Qgc29sdXRpb24gaW4gc29tZSBjYXNlcywgYmV0dGVyIHRoYW4gDQpvdGhl
cnMgYW55d2F5LiAgSSdtIHN1cmUgaXQncyBub3QganVzdCBwZW9wbGUgYmVpbmcgdG9vIGxhenkg
dG8gc2V0IHVwIA0KJ3JlZycgdGhhdCB1c2UgdGhpcyBjb2RlLg0KDQpUaGFuayB5b3UhDQpBbGV4
