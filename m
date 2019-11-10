Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5ABCF69E7
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 16:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKJPsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 10:48:23 -0500
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:8323
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726800AbfKJPsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 10:48:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deG/CKsiF2+qbCIsTgivLeLIKHCfvmIh4aUmVrwnqQUkoAPtUpeD4vn7EUnYG2DvlvfGqRiRlwFD+Bf1NH4PiDrTCvNsm2kUUtXfGJwD5zlI+gNZCpWrEzMY5wJmjZuqq6yeEsXTwp/5g0o1c2e0gfiEnl4plSAn+PRQxasCD8wgTkkEb9+el3THIR0VMN7cqfNXgqf+Dc0EfWiOSVb1OYZh17RXYsCJSK2X0hbONrk+j6unlSfn52UTGO1re0UNPa+uDrf4bf3udBcvitRacpLtwoudnPsCX0crJxFqZEpPOy0xv9H3VzOxUPKhbvf+AcWLUYclYCcRViwbdbOfBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iikGl7GnndINLAF8o65m304E5k1/ryNVsP+bRBZy+Fs=;
 b=J0oyctJs/O1XsE4ej8/JvZDAMjixyK/DEJNA76+gKktSxB6u0GCYSPh2l/5PyTpwMvgOXTL7X0XVu68zJul54qPIJEknir7WRVCmLhXdWMxYelkfEm/urcL29HSN5rSeH58qkBExo34iwySJfA1RNCWp6vuzXXUF3yVUOc13scannvF1htp/ZqcHecLLiKVU69V008s8UpCmGUbebIqQhPItAuLT7neEgRWzXreErCSAjJAhp+3X2Wt1Rl20VDPok6vzh/GdXLDtlf8zK5kDcvEQoSNpiF6XoiD8+9XFne9BBdIWDQbKbzd7TfpQS8gJbP70QLhEfn67FmZdf0yR3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iikGl7GnndINLAF8o65m304E5k1/ryNVsP+bRBZy+Fs=;
 b=Lteff9pY0aGt51KszMNraOTEDk4P6+91Y5JuXQ2IXykEIGDm6bHhhheRCPwNRbp7Qy+q+FAetnfgCJQMGyYg7VWWhvKxJte9Lze3iaB4uUpJc3pVLBhjB5pVCdOEIGsF1Ac6TkpGPld/HTHePKB5acqHuZXNfNoyr3LPMQzMvd8=
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com (52.133.17.145) by
 AM6PR0502MB3672.eurprd05.prod.outlook.com (52.133.20.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Sun, 10 Nov 2019 15:48:19 +0000
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::7478:e4bb:fa38:3687]) by AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::7478:e4bb:fa38:3687%6]) with mapi id 15.20.2430.023; Sun, 10 Nov 2019
 15:48:18 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Ido Schimmel <idosch@mellanox.com>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next] mlxsw: core: Enable devlink reload only on probe
Thread-Topic: [patch net-next] mlxsw: core: Enable devlink reload only on
 probe
Thread-Index: AQHVl9v2Q8NcuSHj4E+XCxFYoer4s6eEjNAA
Date:   Sun, 10 Nov 2019 15:48:18 +0000
Message-ID: <bf10e51a-0533-1fb7-8181-9e190590ae53@mellanox.com>
References: <20191110153144.15941-1-jiri@resnulli.us>
In-Reply-To: <20191110153144.15941-1-jiri@resnulli.us>
Accept-Language: en-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
x-clientproxiedby: AM4PR08CA0047.eurprd08.prod.outlook.com
 (2603:10a6:205:2::18) To AM6PR0502MB3783.eurprd05.prod.outlook.com
 (2603:10a6:209:3::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b0c47e4-91c1-47ce-5498-08d765f5683e
x-ms-traffictypediagnostic: AM6PR0502MB3672:|AM6PR0502MB3672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0502MB3672A5FAF5AAF9921FA314B9C5750@AM6PR0502MB3672.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02176E2458
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(199004)(189003)(52116002)(2501003)(76176011)(386003)(6506007)(7736002)(66476007)(66446008)(64756008)(66556008)(66946007)(53546011)(102836004)(31696002)(305945005)(86362001)(186003)(26005)(6246003)(107886003)(478600001)(4326008)(8936002)(6436002)(229853002)(6512007)(31686004)(256004)(6486002)(65956001)(8676002)(446003)(25786009)(66066001)(65806001)(81166006)(81156014)(4744005)(5660300002)(99286004)(14454004)(486006)(476003)(2616005)(3846002)(6116002)(2906002)(316002)(58126008)(54906003)(11346002)(71200400001)(71190400001)(36756003)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0502MB3672;H:AM6PR0502MB3783.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HwMgm+hZCXBpfJoT+HtwDAMZEeQC/yEaZArpoBiqG/eotLJuhZTVv5X+8ZdyhJg0x6J6q7NPXgCMnqp0nywo+aaEpBXRoEHK4mF61OysQVEomAbOO4f+k0+bc8Lvg2N7DokwuHnRyN9NKzDrWN89my1TNBHjFz4Ri0bU/3DufJCPhwhTvrb9/3G1OhxCzwOoLLeAAWdp0li/4OHpL7D+ApMta8Gtze65tgUfGqH0U52nLY0VUaB1LRwAszyYoySXN4ZCpgvt87Pw7N5Dp58jXdB1O+39A5gVsyVXJD0s7qcBSSSGd9ZlLhwzVsUJVP/9tABMELuTLR6gmsscsvjLBg17W/QGz2yl0AqmXvGoU2q8ZPpPhVPn0QydFlvrJ+ireQPTPOUk9mpUNQLa5zqPgoOEcVV6cGwJIuit1QcfU4JByfKmFicsE+5kIuRdfk65
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B82EF5D3184754EA36FEB2D7A7D2939@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0c47e4-91c1-47ce-5498-08d765f5683e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2019 15:48:18.8201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 25tWJzk6XDeGMGZjXolb+vk98W8G016Sn3xMiKRplU1QD+88hyWM+c6iT3woS+fJ09FkQj0qcOgg6gTEuLM+6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTEvMjAxOSAxNzozMSwgSmlyaSBQaXJrbyB3cm90ZToNCj4gRnJvbTogSmlyaSBQaXJr
byA8amlyaUBtZWxsYW5veC5jb20+DQo+IA0KPiBDYWxsIGRldmxpbmsgZW5hYmxlIG9ubHkgZHVy
aW5nIHByb2JlIHRpbWUgYW5kIGF2b2lkIGRlYWRsb2NrDQo+IGR1cmluZyByZWxvYWQuDQo+IA0K
PiBSZXBvcnRlZC1ieTogU2hhbG9tIFRvbGVkbyA8c2hhbG9tdEBtZWxsYW5veC5jb20+DQo+IEZp
eGVzOiBhMGM3NjM0NWUzZDMgKCJkZXZsaW5rOiBkaXNhbGxvdyByZWxvYWQgb3BlcmF0aW9uIGR1
cmluZyBkZXZpY2UgY2xlYW51cCIpDQo+IFNpZ25lZC1vZmYtYnk6IEppcmkgUGlya28gPGppcmlA
bWVsbGFub3guY29tPg0KDQpUZXN0ZWQtYnk6IFNoYWxvbSBUb2xlZG8gPHNoYWxvbXRAbWVsbGFu
b3guY29tPg0K
