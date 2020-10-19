Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BE8293087
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733116AbgJSVc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:32:59 -0400
Received: from mail-eopbgr670064.outbound.protection.outlook.com ([40.107.67.64]:39932
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733109AbgJSVc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:32:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aU21GJxfQaIjf8yOvQwXwVPzCJS3+cfTlOZR2zW0OKwphOh4FfiT0NediP4LCBt+AIZleM+ap6JNvxS39Kr4AnF4a3JK5KK6iM7/rR0Jx4tf3iAjrhdMLpATqnJP/3ULtfEe4leMDCe0xiGG2/JgjDpkBnsgMOdB7Z3GheK5iXfEnXByDa2y64A4ofCB2aeB538ADlIvAG1d1/twRym+PAThIwlbaylTXXLkjKnfJC3RM1LX8Cu53u3rAofnpM4qd6jrkA73hmKhA1CadMh52oMDm7mwveZkSsMKRDfPS5MkiHSgsa+TZdYjvMAlYFOphVAZPpc28vivi9cudFJjQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QbTH8Nva7zOfRD8ONuWVznqUl0b8MV/h06oX7DE39o=;
 b=aUnLXwMCRojxhPSlYYFWkBfqF2KUBxJtl2DenZq05KXFfPgah/yz3CHNzgo/qXD5UyyrOj3dY3lsPqdKYPeJxSkrO75WK2Q37Ra0nMN6ZN8Ljc83H7EBsGJ+vrFJO95f/zKgIxIeG9K1BK7Bj0TWruwL60GKlPm7Wi9j62L6zsc+AU1sxhvbk3oCBGrJRXfpwuInQr/KZQX7z7v2iHw6GsjmCz1iGmrpGUii6eVr2dYHEhJDOch4OesvCyl0FuZsae4ICkBYWESfUcfw4O9oDrel/GtQfWGmG5hm8p/nfTarfPEy0VQ3NushSik0e6ok86dRkUHLGvU5ECE2b0f6lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QbTH8Nva7zOfRD8ONuWVznqUl0b8MV/h06oX7DE39o=;
 b=EbH7hbvitnXT1ET39SdbHmYT6ErwFbAQRXLpM6Sd0a9AGPtYVj+P7X+Pp5UYxSdm4BttaMIa4G5SJDIENR5+lDCkl0rhM5ot3k/CrlrObqS5uPDCdTwr4bmdqhskeClo0dw+ZEVQyHJgrld9hOTHnog+kYs9/vO5AMvzEpfEOHI=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB2157.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Mon, 19 Oct
 2020 21:32:56 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 21:32:56 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Thread-Topic: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Thread-Index: AQHWpll91HNTpw9Y2UKmWJkWbB3A/amfa2WAgAAGtgA=
Date:   Mon, 19 Oct 2020 21:32:56 +0000
Message-ID: <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
References: <20201019204913.467287-1-robert.hancock@calian.com>
         <20201019210852.GW1551@shell.armlinux.org.uk>
In-Reply-To: <20201019210852.GW1551@shell.armlinux.org.uk>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-12.el8) 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6822c16-a6fb-464c-c0a0-08d874768b66
x-ms-traffictypediagnostic: YTXPR0101MB2157:
x-microsoft-antispam-prvs: <YTXPR0101MB2157D6AD580DCDD9537C0F17EC1E0@YTXPR0101MB2157.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +9nMg7niFgfEW4ghW4ra1Uyj/b+vEkjKNvap7zNxYmarfzTW+baQ371xEJq7bsfspXn9vByuam/CpDF/7D9lrxQxGhUnWOck70AmFbpQ1y+1KmYT8f2d/vKKY/h4RHytOagVeEFnaJEAPd7el6z0QIp/Jm16ctcQ5OcNZ1cS9Drte06eNkwUYrDk3SyFtR7AMU+H67nHAiw14z38UEOakl7xvSsV/O87Q25B/2S5yigyGiySWCHn/xIaM6MiyOQxkkr0XWiJ9Vz5vU8nV+m0cKjRnQJm55CP7aVO6GmhBLcm9S7q9wVaeTNFOg/8IR7wRqtvWvcKaBSTjKLUOHTZWa7BwMRdWZU9XnZOIpD4NQnXDwnFMfz+cY0sugXMzoQYBzG9TkRTIpBfxSM2wXUBZc/F7jjue907MOjgLIe57FmTpBe3r2R6V5OjmBewuz4tw+wqnscnyqbElyjV+Ax/fqBE7UUVTm414rNBaH+FZJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(136003)(396003)(366004)(186003)(8676002)(966005)(6506007)(36756003)(86362001)(66946007)(66556008)(66476007)(4326008)(316002)(76116006)(26005)(83380400001)(91956017)(45080400002)(66446008)(2906002)(5660300002)(478600001)(2616005)(64756008)(6916009)(54906003)(44832011)(4001150100001)(15974865002)(6512007)(6486002)(71200400001)(8936002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: r880nPqK707eyYeOBDX0kCXJt3TNydpv3QT5UKp1CXycAqVSnUfBs+DF0ddUGn+9sDFthoA2Yr7yXB8pWNHreKyWovaUmctsnXlXLDzzzlyKXN8ukSZdTONQM0qfG1fmcB+1lyJoutVFPPhM9K91Si8IwZYizr2malSHKkTb3ITZup+QNb1w0OfCUUsBfKrYMWAqFFI/r9F3ULf+KYn/T3E9b4A5gOuf9qoghVewOOwO/x7rN/aEUH4tV44g+HLtNfFLKlFytUh3N7wTpwcDCKlMGoPg/NxSvCa3/inkjBM2j73XqtO4/BhJzhFdzdKYWcVXsmy15SMqLKRfdP5paV6gIuKpTvZQ0aVyFl8WiI2fKlXv+Pj7dIsXzPQoP+zk7Nhqm4Ct+Y2q3UQ5s/OAKuh7XK9fFKyC/5YzElEn3smifDZudaijqPxin/BWppLtWSLtEA7nv/OLs816CGyBOpEKFzuJBbkUb08QpqIEVB3eVoPT+ntG8od4WgwEys7wVJ4TeLD+2PpP2Cjd9GS53cs/iyn58FrtHU95b+fkh7VVRdzmA1ezGfFlUZlDWlRHi0gAUol8Bi/YK/0CzQIDIMuRw13i7sgPKRRFanyL5UZIjlrmpnzLBgneP5XjAN1efw2KyDeu08Hm0XJo8nCM1A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C64D61D78A14BA439373CD1F17D6F87B@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c6822c16-a6fb-464c-c0a0-08d874768b66
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 21:32:56.5605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RzJ/boWRiKVQTqYa8d+Pr9JiY+vWbaAk5hOwqInBH2IWhIlx4aZbE2tu/mEZApKZbDSiu72QkmawGmXDhhad9QqiGSR9EQRssNR/KOk0A3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB2157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTE5IGF0IDIyOjA4ICswMTAwLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGlu
dXggYWRtaW4NCndyb3RlOg0KPiBPbiBNb24sIE9jdCAxOSwgMjAyMCBhdCAwMjo0OToxM1BNIC0w
NjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToNCj4gPiBUaGUgRmluaXNhciBGQ0xGODUyMFAyQlRM
IDEwMDBCYXNlVCBTRlAgbW9kdWxlIHVzZXMgYSBNYXJ2ZWwNCj4gPiA4MUUxMTExIFBIWQ0KPiAN
Cj4gWW91IG1lYW4gODhFMTExMSBoZXJlLg0KPiANCg0KV2hvb3BzLCB3aWxsIGZpeCBpbiBhbiB1
cGRhdGVkIHZlcnNpb24uDQoNCj4gPiB3aXRoIGEgbW9kaWZpZWQgUEhZIElELCBhbmQgYnkgZGVm
YXVsdCBkb2VzIG5vdCBoYXZlIDEwMDBCYXNlWA0KPiA+IGF1dG8tbmVnb3RpYXRpb24gZW5hYmxl
ZCwgd2hpY2ggaXMgbm90IGdlbmVyYWxseSBkZXNpcmFibGUgd2l0aA0KPiA+IExpbnV4DQo+ID4g
bmV0d29ya2luZyBkcml2ZXJzLiBBZGQgaGFuZGxpbmcgdG8gZW5hYmxlIDEwMDBCYXNlWCBhdXRv
LQ0KPiA+IG5lZ290aWF0aW9uLg0KPiA+IEFsc28sIGl0IHJlcXVpcmVzIHNvbWUgc3BlY2lhbCBo
YW5kbGluZyB0byBlbnN1cmUgdGhhdCAxMDAwQmFzZVQNCj4gPiBhdXRvLQ0KPiA+IG5lZ290aWF0
aW9uIGlzIGVuYWJsZWQgcHJvcGVybHkgd2hlbiBkZXNpcmVkLg0KPiA+IA0KPiA+IEJhc2VkIG9u
IGV4aXN0aW5nIGhhbmRsaW5nIGluIHRoZSBBTUQgeGdiZSBkcml2ZXIgYW5kIHRoZQ0KPiA+IGlu
Zm9ybWF0aW9uIGluDQo+ID4gdGhlIEZpbmlzYXIgRkFROg0KPiA+IGh0dHBzOi8vY2FuMDEuc2Fm
ZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnd3dy5maW5p
c2FyLmNvbSUyRnNpdGVzJTJGZGVmYXVsdCUyRmZpbGVzJTJGcmVzb3VyY2VzJTJGYW4tMjAzNl8x
MDAwYmFzZS10X3NmcF9mYXFyZXZlMS5wZGYmYW1wO2RhdGE9MDQlN0MwMSU3Q3JvYmVydC5oYW5j
b2NrJTQwY2FsaWFuLmNvbSU3QzZlZGE3ZDYzNmZiZjRhNzBmZjI0MDhkODc0NzMzMmEyJTdDMjNi
NTc4MDc1NjJmNDlhZDkyYzQzYmIwZjA3YTFmZGYlN0MwJTdDMCU3QzYzNzM4NzM4NTQwMzM4MjAx
OCU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJs
dU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT1jZkNo
QTRUQnczZjcwYWxyQU5YUFIwSEhnTmczVnMlMkZOZUVZaHpaYyUyQkY5QSUzRCZhbXA7cmVzZXJ2
ZWQ9MA0KPiANCj4gVGhlcmUncyBsb3RzIG9mIG1vZHVsZXMgdGhhdCBoYXZlIHRoZSA4OEUxMTEx
IFBIWSBvbiwgYW5kIHdlIHN3aXRjaA0KPiBpdCB0byBTR01JSSBtb2RlIGlmIGl0J3Mgbm90IGFs
cmVhZHkgaW4gU0dNSUkgbW9kZSBpZiB3ZSBoYXZlIGFjY2Vzcw0KPiB0byBpdC4gV2h5IGlzIHlv
dXIgc2V0dXAgZGlmZmVyZW50Pw0KDQpUaGlzIGlzIGluIG91ciBzZXR1cCB1c2luZyB0aGUgWGls
aW54IGF4aWVuZXQgZHJpdmVyLCB3aGljaCBpcyBzdHVjaw0Kd2l0aCB3aGF0ZXZlciBpbnRlcmZh
Y2UgbW9kZSB0aGUgRlBHQSBsb2dpYyBpcyBzZXQgdXAgZm9yIGF0IHN5bnRoZXNpcw0KdGltZS4g
SW4gb3VyIGNhc2Ugc2luY2Ugd2UgbmVlZCB0byBzdXBwb3J0IGZpYmVyIG1vZHVsZXMsIHRoYXQg
bWVhbnMgd2UNCmFyZSBzdHVjayB3aXRoIDEwMDBCYXNlWCBtb2RlIHdpdGggdGhlIGNvcHBlciBt
b2R1bGVzIGFzIHdlbGwuDQoNCk5vdGUgdGhhdCB0aGVyZSBpcyBzb21lIG1vcmUgd29yayB0aGF0
IG5lZWRzIHRvIGJlIGRvbmUgZm9yIHRoaXMgdG8NCndvcmsgY29tcGxldGVseSwgYXMgcGh5bGlu
ayBjdXJyZW50bHkgd2lsbCBvbmx5IGF0dGVtcHQgdG8gdXNlIFNHTUlJDQp3aXRoIGNvcHBlciBt
b2R1bGVzIGFuZCBmYWlscyBvdXQgaWYgdGhhdCdzIG5vdCBzdXBwb3J0ZWQuIEkgaGF2ZSBhDQps
b2NhbCBwYXRjaCB0aGF0IGp1c3QgZmFsbHMgYmFjayB0byB0cnlpbmcgMTAwMEJhc2VYIG1vZGUg
aWYgdGhlIGRyaXZlcg0KcmVwb3J0cyBTR01JSSBpc24ndCBzdXBwb3J0ZWQgYW5kIGl0IHNlZW1z
IGxpa2UgaXQgbWlnaHQgYmUgYSBjb3BwZXINCm1vZHVsZSwgYnV0IHRoYXQgaXMgYSBiaXQgb2Yg
YSBoYWNrIHRoYXQgbWF5IG5lZWQgdG8gYmUgaGFuZGxlZA0KZGlmZmVyZW50bHkuDQoNCi0tIA0K
Um9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQWR2YW5jZWQgVGVjaG5v
bG9naWVzIA0Kd3d3LmNhbGlhbi5jb20NCg==
