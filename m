Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E8639006B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhEYL7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:59:14 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:31329
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232167AbhEYL7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 07:59:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWjirpTMmhBCaAeDIPcSbWtsgzuq071TECDs5m0ZpI8kix5AUQtRNRJyrjatMEdrNSxkylh4B8fyZW9iZeeTH7/80NxjqsKk2C162u2ugy8U488fdiKKqejREYms2PeGzm5QGUREKY6Tq5rIt9qtp01itq9E1J4aYszXuvVTrgEabv6sDP9LO2565fcBeSOx7IJeAizwHl7WCV142GD1bWwC13tcgV3IU5qgoSk5NS0X8ILnJ8k744aZ/m1e4a/DkPuWzEC1RCZjYUqlgPEuQtMzTtf07oAAHNHxpjyKCu/dSUQK3g8wiFQOnDCE7mWbmUjUbaKc5RSmM933mxZ4EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYPtiCxu4hx40AbEy6IRor+nsqTCHTn3Cpve5sqynCQ=;
 b=Jdh46vmh7l4h/Mg2rp8za7CyQ+k8qVqNJ4a0emXcuWq+1Xjf8zCzYKBSzVvuPx7L+4/Y/J4bNoqT8xn8o/hBQ6O4JgK4h41XvMTAFVIUd6yQ7aAwZ6C0/OOArpLpRencAPj7oQ3Gf8otq+NVoRJUURHMDxe4vb49hqQqfJqdeJ6Y6yyPieBAiCi9RM3SwR8wjWwYNelFL320zL9isJ9/VBl41IYAdYAvcivt96WorcbQxJ9UD0FvPA8nHAN8aW1RrIvXfd3R66+QHGvw10CWiqK6cvKxy0CLlrOBXk2SN3IFQwVOc29SSPmQvHG90NeSNhKBQ5FAg5Dl74Tl8yOzQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYPtiCxu4hx40AbEy6IRor+nsqTCHTn3Cpve5sqynCQ=;
 b=fDOpxlJwJw5On4ZLCk+KgEarUhaCkE2bJAJEajPPAUO1cAyUrG5giJ6e5uhKN3oSOc8ASRNr2uP85Xf5vPgmcA3zu8fhH0sEfEmSlr1pLhYM51+juoRyz0gLJgxQm/Cc+KyIcRzZtyV4j7g8rfqFwiAe5OTfDj0TwnKA/tVCg+U=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6125.eurprd04.prod.outlook.com (2603:10a6:803:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 11:57:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 11:57:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 09/13] dt-bindings: net: dsa: sja1105: add
 compatible strings for SJA1110
Thread-Topic: [PATCH net-next 09/13] dt-bindings: net: dsa: sja1105: add
 compatible strings for SJA1110
Thread-Index: AQHXUPOwf7v9NZZvvk6qbXsY9lUIJarzeE4AgACgGwA=
Date:   Tue, 25 May 2021 11:57:38 +0000
Message-ID: <20210525115738.facebwqt7y6k6klv@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-10-olteanv@gmail.com>
 <4e6cd92d-b2f3-9eb5-9a6f-e169dbd41537@gmail.com>
In-Reply-To: <4e6cd92d-b2f3-9eb5-9a6f-e169dbd41537@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cc0b484-d31b-4500-1625-08d91f744b07
x-ms-traffictypediagnostic: VI1PR04MB6125:
x-microsoft-antispam-prvs: <VI1PR04MB612540A64888B236526F40B8E0259@VI1PR04MB6125.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3KDERM7zLOJmzpykzZW8zc2Ex/qAS8akrixzU4dKZr/TU4Lgxwifj61A6x6Dul6J3mZFjwJmQuaq+P8rqll3xIg1VOoOK0Nl3Q48xsaYweJwCy1vhSSTTLle7tVSNEnMrTqdHRqu77INaqM8/EV9KjbWCKFpKWoQYj0CTkxc74diCMr4acJjTsmdg+UCe31y0VWDb44Q+cXFE2mH3klE9xlXbSplGUhe0RHG/J2TSuLRqnDqGghQU2A6vGP93AGMpuDpFZ+d0Ro/T/R0dG9YIl4ynlBpjZ9MYTZkFLaZfKLpCkQeNzUtEK7BXXbk8iRVkdLsQJaM7TaPSvEPfQzPRuvwN5X7f0QHnWYGz0DrJIGRPOrzJEHuv3y6cftojqlxeABTQjr/PQir3rpmCi5QDH0dFAfuzg95rQers8esOOxO+dG87r2kZ2srMhvj7FYbzt04eNElr7kEIcjL4YezMSr6qrbHo+klKtyRkI6l7gTDP0i82wGquE1pi6+dF1Ujs8Mqh7PJ1o8FWQ+JNxAt4pCm4qCfsScVZQk0Iby1Guaypncn5yyI/ju1+RC0WLkEnRtviDqRt7JUNhoV4Ec9Uqo2AuKT9d2mIIxwvGScAXE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(498600001)(66476007)(9686003)(66556008)(66446008)(2906002)(33716001)(66946007)(64756008)(8676002)(6916009)(6486002)(76116006)(6512007)(5660300002)(53546011)(1076003)(71200400001)(38100700002)(44832011)(4326008)(54906003)(8936002)(122000001)(4744005)(26005)(6506007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5C1XvBI/0cVG6mly/Q8hGo75xHPay7Cwiom6W8dyV9d+pVqbJcGd0AW+rW+3?=
 =?us-ascii?Q?LwQ4kZo9+qPMIPmkwUT3Wt3f1gkJk9MN2TZGMS5IkNNHeLFrazfpWa2BKZ2F?=
 =?us-ascii?Q?iq5tizb+8fCfipEgNfuJodJ2GHdIQUmVI9amJUUb3cTKh9GK2Mnr7hpaaYYB?=
 =?us-ascii?Q?Uc+R1cb+JN4IiQMMAykxYFUnq3rQdxViEfZob+yyHUavnDd5jMwgVeUKXB6V?=
 =?us-ascii?Q?KWB94yhB2iAMM1QI4/n/CMzAghqGe3wR6nqchGOQbJEfw0lHlHNBCtsbjLrN?=
 =?us-ascii?Q?9Q62WzXlnOxEILe9/FPNNzzA6XxUJNTXyytq5cy+s5vCcg8WnMYvFkaoxR7X?=
 =?us-ascii?Q?TMYWPK5vQA8LAXcpLp+GjtX8zSMBrCloTV1TyDVEARdiz7XM2JEye56D4IGt?=
 =?us-ascii?Q?M5yUmmRMQWtntzGZJnysSzDEJnP8SkM8IAFMZfSrXR+oB1PdmMsgPd8dycyb?=
 =?us-ascii?Q?Suk2pXyuRfGlL2QqiziXaLPeVOEUf2q3APzqZGvR19s63Fjn+6v8Qm9HSiOn?=
 =?us-ascii?Q?V1jxEeTeHPCY2UxYqolIqY8AT9UhCktXhfQiXmXKd9EVmaWoNAi8P8vuDF0Z?=
 =?us-ascii?Q?9j4HR2bI8/zU7FC+00AX8Mf6d9z1MNb9ujgAnfll6ouzsWW9C+uP+29JsGHn?=
 =?us-ascii?Q?SM4b+2tL1WSSqC8IbdtKSB8FsXi/RPqJvX51KWlAp5Ko9UrJPngR1wmjyCd9?=
 =?us-ascii?Q?8Jnu1ALGkHsqOKjrrxj19l6bhHXUFpf24ZScXF8XcCNcgpnK7N6A5hFiTHOF?=
 =?us-ascii?Q?nVS+AAMjThR4pCbbusWJ//NLFIhpsYgX1WQilukydu2hXSX+ZLxl8mPlfHFU?=
 =?us-ascii?Q?uDa3UQ3k6/Azip7tyuBhTwYpKWlOtBRTdEqPjnPKrI/VZ58wIAPPGqb1RHNf?=
 =?us-ascii?Q?hxRRJ8b9SDgm1BM0WgDY7gTT4jjkF4uxrPCpPqAaiLfB8tLJzOd2BVO3B5Xt?=
 =?us-ascii?Q?Fy48jcrg4FglKuqvzN/ywFHMO7nAXllnzvlvULodKKqQMUDz7SOon+GKgAOf?=
 =?us-ascii?Q?oskK+8MaySljjn+b1armn3DtbHG7WvDcJNSy2dPK6a2GBryZnk5wCd4Hiqrj?=
 =?us-ascii?Q?3ZZoLUJR4Xy8IKdOhGnvMqse3HjduJ+yDCzB3sIHs2OX9fc73TLGcMgU4yGY?=
 =?us-ascii?Q?tfPDU/U+SHN3XSyOu02xlNib1iYKeWtLbs+J0kbHjMsnW6r28ppJkPt89p7K?=
 =?us-ascii?Q?FhXloUGeHfm5Yxp/oEcTHijYwtS97bN3O35RdiB5d0paZwISdYXi2WWsYoAO?=
 =?us-ascii?Q?A3KJmcbADSmioBoDZ/d23JGeZWWlx4nc+/SxOEejowel7racS4VE1rR/9v5T?=
 =?us-ascii?Q?CsJNHZQ73Wq1DdkySP3KaILP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B5E13A1C62922E4AA65A689D7F287552@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc0b484-d31b-4500-1625-08d91f744b07
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 11:57:38.4429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXXJii+xOB/AMZQc7UmaTmNIJXnuR0nyqjsapvpk1gnMX0msiJBLsUpogE6Yo7g9FgZ53oG9D4ynx+0/HL5Nhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 07:24:36PM -0700, Florian Fainelli wrote:
> On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > There are 4 variations of the SJA1110 switch which have a different set
> > of MII protocols supported per port. Document the compatible strings.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>
> Time to YAMLify that binding?

I'm afraid that will sidetrack in another discussion about
sja1105,role-mac and sja1105,role-phy which I'm not prepared to have
right now. Those boolean properties are to my knowledge unused, so I
could remove them, but the phy-mode =3D "mii" + sja1105,role-phy would
have to be replaced with phy-mode =3D "revmii" and similarly, a new
phy-mode would have to be introduced for phy-mode =3D "revrmii" or
something.=
