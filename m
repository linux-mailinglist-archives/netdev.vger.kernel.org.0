Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF0B1DDC5F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgEVBB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:01:57 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:39502
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbgEVBB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 21:01:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqHAezBLauQ4tTVgnErZk79fdYia2pAOXYNc7+2ROP6E0SihlF9OqSS0Nw6ymijCfuCzQNAIvHHlXc8Wft7lhZSlddj8HU5o/0o1Nb0KnOBZiYRn62Nbnn9rzoyIakC9V4OToAoaSf+3Yhui/G+oStTHfV5YxuntvXigRBpD/bi3hYwtQdiO9oc6PVm7NWJlxfBVgoq3acM7/ctISMHqhermn60VEfv+qOTCItzCYCqf0nKZkYqbVB3TyqA30anuDq/rghmPaJ7/ZI0/ASNDoVmqg57XtBcs/qkWwEahypMqTJtIYVQWb2alyTRoTt4DHFwBvRkMjo+RXvYd5riGQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keWdxfH4NgNJxnCA2AsbVr6tvjSe2LfefyZs1SvB7Hc=;
 b=SYvE6Y/QU/vF6UlGhRNmXR93tMIlBnUS/jF/AUC7fDWVYG0cB8209aVFtqeEBYHjTFfu3BlGUhrcoRXoF6XaDyLucO9bE1fHEPhWq6VzrhRMTAbGa6xA0C4aGGd1XvRHRzthJXN90XwFvtvCAg4vwnRgzQW2q0GYY5tDlR6kLFEcmfIMLc8WX6Gt6G1PHwd+lxSaP7G+o4nQhCbw26zbrUQZmXjBNuM9Kx4hbXArHPM8TEb05+cW1s8G42NMIx3DbVPHwUEp7DmDhC4vihS8BSHyLEhaCRGXldYufSqbU3ftpVCqAE7H85QYy+pawdmD5IbjJmEtj8xoo/YPGUT9mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keWdxfH4NgNJxnCA2AsbVr6tvjSe2LfefyZs1SvB7Hc=;
 b=IAtZ7gbDQhGzNP0qub2U4kh2RiQBaknW8MmFkz78reJoEoivb8IVOQXjk1YxitRQbWSfAKwMKZC1heoWjiIc4x3MTVJgXbpACJ/K3S6/Kui99S3KVnvHgA+6R3mdZpXA7tSWMz3i05UwmEiXF0Y0FerW9/j0caz2DLxlJw0zFdg=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3591.eurprd04.prod.outlook.com
 (2603:10a6:209:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Fri, 22 May
 2020 01:01:53 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Fri, 22 May 2020
 01:01:53 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr property
 to match new format
Thread-Topic: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr
 property to match new format
Thread-Index: AQHWLoHSZsTKfn2KY0W5vmilgDZ/AqixNB4AgACoEqCAAKg5AIAAxaRg
Date:   Fri, 22 May 2020 01:01:53 +0000
Message-ID: <AM6PR0402MB360728F404F966B9EF404697FFB40@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-4-git-send-email-fugang.duan@nxp.com>
 <20200520170322.GJ652285@lunn.ch>
 <AM6PR0402MB3607541D33B1C61476022D0AFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <20200521130700.GC657910@lunn.ch>
In-Reply-To: <20200521130700.GC657910@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1f629a4-d044-4e4c-993e-08d7fdebb774
x-ms-traffictypediagnostic: AM6PR0402MB3591:
x-microsoft-antispam-prvs: <AM6PR0402MB3591379FFBA1DA1A55D7EF06FFB40@AM6PR0402MB3591.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 04111BAC64
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r0zef+O1s8L2lgpoABcFhVrJNNOLkT+7mpTA7bgHzQjWLPEt/xjc6u5qzgVyXo7lA0jvmg9lk8HMacaQXePfER5Si59FZOocAYFzyDm3fqEjZ5U9EeVVwuN5t4UhLVbZ8NIU4mY1LxxfFHHRBiG6xo76AIp2dESgp4cXWVbPSrxwrw1h4gXQLBN0j+wHMQtRs3ptF7SCM9HXTEpR339e0NCIa6TKz/zS+SwsGPMYbdzIeFXahQLCKtNm0RtHvZRWweAc6cgyBQ8dHfSy8QWK/mcngFgYa7oGj5/VILu3Lxdv2Mt5+q6DGTlOiLCzVMKehOxGgOLZLIJSy3V0TPySwUR00GjlEz8KJ+ZZaS1G46qY++hi2ouLPR0gSYw2HnjRVdzd8oSUjLiGclezZKcpKmgKy5SO3/mpv00jmPpM055+RO1JruaV6bRYXT1Niqdx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(54906003)(5660300002)(8676002)(86362001)(66946007)(71200400001)(55016002)(7696005)(2906002)(316002)(76116006)(4326008)(186003)(6506007)(9686003)(478600001)(64756008)(52536014)(66446008)(26005)(6916009)(33656002)(8936002)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0PxHIw6swkvXPbPnxAFxnp9uPcv8csp8QJbNTLJWI0tH/v6oUHqphlTl5VYrHfGEiVfiOcPoJzVSHgPmi/IgTYnAksFvnfYSm1BjJx/ccJnpYIpviMCio1Q3p8+Xyayi+9Cqik9UGCaMHAtCQZ3vJN5e3hXN/gUvett/qo7y9NQABf2SpQniViZ3KGttVHaW6OdgxOxRIHHj8uSkyJ9tG2dmLvmuBCvFTmieUmOYhftL0xcRmV8/GPSHSDZxrQ33rMiifBMFrzjSpEogcA3eHhe+nvz3dpmXn8tGfBVSWLR9kzkG9RLMcnNaC9pzYT7jegXxMcdkdTCEwoFBfhgweqviKlTx/tl1IKkWfX4bOiEbn5BCYKSKmu1z7SmtkmYkyIQymO7aMlAFfh7KkwSx4QtvViGy0dDYev9Esretb/vuw7IdRA9fwKK1vpiS1at2oorAeAnlYixOfL1RwaKoJepOP/5+PJMg+Pey6vUSExs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f629a4-d044-4e4c-993e-08d7fdebb774
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2020 01:01:53.1999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJ9Od9gPeU/ElImGlE2REp8g8+RF8mWE5oa/gSdyI+qhfvCPvy5BsRVjhKQxu5TcBaQIScVNYVZuVdo3wBVf6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3591
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Thursday, May 21, 2020 9:07 PM
> > Andrew, patch#1 in the series will parse the property to get register o=
ffset
> and bit.
> > Patch#2 describes the property format as below:
> >        <&gpr req_gpr req_bit>.
> >         gpr is the phandle to general purpose register node.
> >         req_gpr is the gpr register offset for ENET stop request.
> >         req_bit is the gpr bit offset for ENET stop request.
> >
> > All i.MX support wake-on-lan, imx6q/dl/qp is the first platforms in ups=
tream
> to support it.
> > As you know, most of i.MX chips has two ethernet instances, they have
> different gpr bit.
> >
> > gpr is used to enter/exit stop mode for soc. So it can be defined in dt=
si file.
> > "fsl,magic-packet;" property is define the board wakeup capability.
> >
> > I am not sure whether above information is clear for you why to add the
> patch set.
>=20
> I understand the patch. What is missing is an actual user, where you have=
 two
> interfaces, doing WOL, with different values for gpr. We don't add new ke=
rnel
> APIs without a user.
>=20
>     Andrew

Andrew, many customers require the wol feature, NXP NPI release always supp=
ort
the wol feature to match customers requirement.

And some customers' board only design one ethernet instance based on imx6sx=
/imx7d/
Imx8 serial, but which instance we never know, maybe enet1, maybe enet2. So=
 we should
supply different values for gpr.

So, it is very necessary to support wol feature for multiple instances.

Andy
