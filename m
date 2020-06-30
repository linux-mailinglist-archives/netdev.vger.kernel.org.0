Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E536D20F1C0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 11:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgF3JhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 05:37:22 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:25989
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729193AbgF3JhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 05:37:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAsW7+AqHYzSPrBvuO3ftv1ogcY2o1YFrX2WN6PDInRDk4xXaLi+mnA46EAeC+NUPrk0GH0AncIumU3j8NLXXNehQTkR50xz1vP3nMViS+S85rWW31P1Gzc8xJ1LXeCV6f//p7Sm6HfwssPWN0vx9PX+POVpV+A3dhCgHFtbsKrY/JEOuf6uGp07Ux91rzAUIR1YWTtRj8A44Ufa0Pt6OS5YftHlyQbJUx/7F91YeHos+JhNYTRDzk2yYlKAquVhHqSwyK1k2kcRE0ys0EanVsLuLRTEfuqLBFSkjqCPyxivR7oZPe/u+iuTdoaaBQkeUG8f8oU0uXZPnacSVNCKsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTkwavi8yRrb7hclBCx1yYSkvokty0OhZYSQH/Uv7rY=;
 b=a0uJjLqBpMPFVkiSb+czCm8V4r4h9bTaZbLSIHsRDwoz91y2fHgVykgHkmcW6z/cnzrPquMiNsm2UmKzEVzPtUJYjqYnnEfMeTP3qonSqib9F5hlrYwsFkjEOMdsN19/WxGSs66JG769hbcHd6cNMCz2nalg6LNMUHTamN49ErcFV48I3d8x0GZ4+rOOOOx9VyUmt/S5C4P7yhQAstvKxgElUmubOO35I29VffYD4tfg4/r61r+onFqBpDXkkRmEFxMNp1Iwm5/Qzk5a+5i2M/v6gr/lPwKhE49jqesjjXFhdNNbrvULiyPl0p++nvtf5fXvAYWgLNmkwLoi/7chPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTkwavi8yRrb7hclBCx1yYSkvokty0OhZYSQH/Uv7rY=;
 b=Qy6g3fI24zGDiDVKyGQxRdu5RXHNoghH60E2a5fuejsAhGilIPFy9m2mXCZ1AOB0/YKw7q7wh2DBLvDuP78Vfptnr87XpxnaQRj88lu4wlA4CPdhnI+ynSs/sWhDZTBQ6i6Eztb/0TLXZezLjf6WWl21kpYs0KSJh83XIG/CwGY=
Received: from AM6PR05MB5064.eurprd05.prod.outlook.com (2603:10a6:20b:11::18)
 by AM6PR0502MB3990.eurprd05.prod.outlook.com (2603:10a6:209:1c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 09:37:16 +0000
Received: from AM6PR05MB5064.eurprd05.prod.outlook.com
 ([fe80::d40d:fb57:aec3:8567]) by AM6PR05MB5064.eurprd05.prod.outlook.com
 ([fe80::d40d:fb57:aec3:8567%4]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 09:37:16 +0000
From:   Vadim Pasternak <vadimp@mellanox.com>
To:     Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Adrian Pop <popadrian1996@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: RE: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for QSFP-DD
 transceivers
Thread-Topic: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Thread-Index: AQHWS8jXfrv+aW8Mkk6CeR3MAkwTJ6jrAskAgAAlk4CAABoVAIAANBcAgAFg6ACAABfaAIAA/06AgAJixoCAAF5fgIAAK2lg
Date:   Tue, 30 Jun 2020 09:37:16 +0000
Message-ID: <AM6PR05MB50641C1DB044B3825764F163A26F0@AM6PR05MB5064.eurprd05.prod.outlook.com>
References: <20200626144724.224372-1-idosch@idosch.org>
 <20200626144724.224372-2-idosch@idosch.org> <20200626151926.GE535869@lunn.ch>
 <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch>
 <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
 <20200627191648.GA245256@shredder>
 <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
 <20200628115557.GA273881@shredder> <20200630002159.GA597495@lunn.ch>
 <20200630055945.GA378738@shredder>
In-Reply-To: <20200630055945.GA378738@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b07f109e-078a-4345-1516-08d81cd92d6e
x-ms-traffictypediagnostic: AM6PR0502MB3990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0502MB3990E0CA4B3F1A026B7BB5B2A26F0@AM6PR0502MB3990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jzk87vTvY6t2S+MjfbuXAkJXBxI+QVIVBNjvpC4Gu4/xiTDobgESz+3ICy+nYWLRMbkcbTDwDpGXYbQzUOqa8iUfBH6d2nCltJEyV5FSJzUC5B5ENDDPggPI0lfVlDUuIiPpd4e+0CEMig2TpdPOzCmanUiOjvHMRDq0kCjJwlmrufzvWJDXgFiu2XaOK5GkaMMO4DPq/QYKXwgbulX9C1586uZj5o+2VnNeYxEs6dyLAT5nKTYsooDMfc4i2H+LvVnb8n8iyi147PX5VadT1osqndSMRN5qBfHT5PycDADUmecoMTL36e0W9cthVBUoXOVarZzZXUYp5TyZwFxYCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5064.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(7696005)(66946007)(76116006)(66476007)(66556008)(66446008)(64756008)(4326008)(53546011)(110136005)(6506007)(2906002)(5660300002)(186003)(8936002)(8676002)(52536014)(33656002)(71200400001)(107886003)(83380400001)(54906003)(26005)(478600001)(316002)(55016002)(9686003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JHBrW6/aOdXbVPFTPci97aRXBPn62gMTIEPPb0anvhiR/W2laL/ypuM2RTychuQIqyMz6tebDtB6BBWVxIClAQLA/4olLBgxeldOcZ1+J9eYmy/GVNrDp60cFMIkbTJbFyzahe433IyueuYUCfd8Th2u2G8/ZkYdaPMiTOwfxv8BGTAKlFtovTrLsDRi1sOg1xPRAZ2UPO1sMSVeIz1P2ZehOYxNqrC1TuIfRZBTlAn090JWl0iOQIZbaJ65GKXlFeIB9d49W+aw4oxEhlV7iwRenQtPTWjbkXlIOSNR800kkCxzTaKxKsk08HiCucw3MZ2/xGKEH2QsEdd32iag0o94VkPeCXcVOjxJ21zcBuReCIQ7F8DiCMN+jolWiZzRakrSdXaKfXDQWMdCwPYrFlRgYGnl/QUSyO8VE1NszTI1irEIlaCnL4NednEk16diVF0cI7YNk2vf4l99FMmC/L9VwXzeo6OS4HZDwDjhDT9DHTMxrXYDO+FLYSlsZQHA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5064.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b07f109e-078a-4345-1516-08d81cd92d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 09:37:16.7525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iBClEV740hfmL73GTv7/HKfef5BOEb1DZdsu2XmNM1SLvm0uWlUm17QUnh0QBBkhZ+JEpO6g+i2UWHHgJQ8YSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Tuesday, June 30, 2020 9:00 AM
> To: Andrew Lunn <andrew@lunn.ch>; Vadim Pasternak
> <vadimp@mellanox.com>
> Cc: Adrian Pop <popadrian1996@gmail.com>; netdev@vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org; Jiri Pirko <jiri@mellanox.com>;
> mlxsw <mlxsw@mellanox.com>; Ido Schimmel <idosch@mellanox.com>
> Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for QS=
FP-
> DD transceivers
>=20
> On Tue, Jun 30, 2020 at 02:21:59AM +0200, Andrew Lunn wrote:
> > I've no practice experience with modules other than plain old SFPs,
> > 1G. And those have all sorts of errors, even basic things like the CRC
> > are systematically incorrect because they are not recalculated after
> > adding the serial number. We have had people trying to submit patches
> > to ethtool to make it ignore bits so that it dumps more information,
> > because the manufacturer failed to set the correct bits, etc.
> >
> > Ido, Adrian, what is your experience with these QSFP-DD devices. Are
> > they generally of better quality, the EEPROM can be trusted? Is there
> > any form of compliance test.
>=20
> Vadim, I know you tested with at least two different QSFP-DD modules, can
> you please share your experience?
>=20

I tested two types of QSFP-DD, cooper and optical from few vendors:
Innolight, SP (Source Photonics) and Mellanox customized transceivers.
We don't have enough statistics. I guess in all our systems in LAB we
validated about 150 - 200 cables. No one of them had wrong EEPROM.

But in all Mellanox systems QSFP reading works through the firmware
and firmware performs QSFP validation for stamping (some cable type
are considered as untrusted and firmware put them to the black list),
page checksum, power consuming criteria.


> >
> > If we go down the path of using the discovery information, it means we
> > have no way for user space to try to correct for when the information
> > is incorrect. It cannot request specific pages. So maybe we should
> > consider an alternative?
> >
> > The netlink ethtool gives us more flexibility. How about we make a new
> > API where user space can request any pages it want, and specify the
> > size of the page. ethtool can start out by reading page 0. That should
> > allow it to identify the basic class of device. It can then request
> > additional pages as needed.
>=20
> Just to make sure I understand, this also means adding a new API towards
> drivers, right? So that they only read from HW the requested info.
>=20
> > The nice thing about that is we don't need two parsers of the
> > discovery information, one in user and second in kernel space. We
> > don't need to guarantee these two parsers agree with each other, in
> > order to correctly decode what the kernel sent to user space. And user
> > space has the flexibility to work around known issues when
> > manufactures get their EEPROM wrong.
>=20
> Sounds sane to me... I know that in the past Vadim had to deal with vario=
us
> faulty modules. Vadim, is this something we can support? What happens if
> user space requests a page that does not exist? For example, in the case =
of
> QSFP-DD, lets say we do not provide page 03h but user space still wants i=
t
> because it believes manufacturer did not set correct bits.

Regarding faulty modules, as I wrote - validation is performed by firmware
and our software trust firmware.

Currently user space just asks for the buffer length.
I suppose in case we'll have additional API:
ethtool -m <if> <page> <offset> <size>
it would be possible to provide buffer only for the defined page and upto
valid size.

Pay attention that CMIS specification covers also others transceivers types
and some of them we are going to support through ethtool, like:
19h (OSFP 8x Pluggable Transceiver)
1Ah (SFP-DD Double Density 2x Pluggable Transceiver)
1Eh (QSFP with QSFP-DD memory map)

If I am not wrong 19h and 1Eh should have same layout as QSFP-DD and
SFP-DD is supposed to be similar, but shorter (page 02h is reserved, page
01h contains info, which for QSFP-DD sits at page 02h).

