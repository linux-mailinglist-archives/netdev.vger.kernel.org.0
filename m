Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83B52B7FD7
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgKROwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:52:55 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5895 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKROwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:52:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb5353b0000>; Wed, 18 Nov 2020 06:52:43 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Nov
 2020 14:52:52 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Nov 2020 14:52:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdbCuEWo9ZJvPnc0c0A/quxAkTWqE+oQhdICylUYAh/bklcJOhJlC/G0vF9pNUGG0l9WMkKsW1pQozbIL05t/JPWa4fo6WVL79MkYISyrS3RwtB5my0qR6fnVQI6S+AeojW6bPfahNQEYmVTPP9rPaNYeN36sNNmz7lVwNthlPhHhR02U9jql/QiwA//aRVbBcBwFekjFoeCQxmKH1rOQ8IDcPhc3BghB+cVuI60meWY0AWUSeOtY/JUtCdnYigEjUQvrfQkbACn7sSPc/xzI3bcBLFTz3r/yzXYEejR84h5w8+3PvqZrR07ksdzYxvWFDx7Nq7L6P2D89XZ5dgEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMkeX0BjZsk3qdIa1dXD3fW7CiUgs32i9vaZTGHM8CI=;
 b=Yi+WN4Ynd+nQtzvWbCGUS62+JjtL2y4IwFrpZ83Mmxco2LPuhQVmCYfWPy9UVrsLzlIBGKPD6/nw9xO8rBFDf7XIh9VjaqC1/v/YTIKXwhD4ZXB/ezKQciR9TRWdNrjD2Kt3mo91wqEThjfolaAJKwi0L2C6J1haFWyF6WxyXjrvrPktrtI+B4OXCH9pX/pYiqHfGKGEmNIqGiYJ5RCKYsWJEhIPFAKGrIZIompslhq48ucIVoQqaCF89Z7OwWCpy9GYaHUPesSgFfdX4paHTB5EepzMpVzCQIAJRBfzXKt6tPE9b4CRtNQn2SogNRbpZuygQcTdmAijVeCR7CshOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by CH2PR12MB3655.namprd12.prod.outlook.com (2603:10b6:610:25::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 18 Nov
 2020 14:52:50 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::d24:4002:4e22:1788]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::d24:4002:4e22:1788%7]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 14:52:50 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        David Thompson <davthompson@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net-next v3] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v3] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHWvTd62uNALQJz0kW8MBAbCDLL1KnNNh8AgAC9QJA=
Date:   Wed, 18 Nov 2020 14:52:50 +0000
Message-ID: <CH2PR12MB3895318D3802419175BA42C3D7E10@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <1605654870-14859-1-git-send-email-davthompson@nvidia.com>
 <20201118030950.GB1804098@lunn.ch>
In-Reply-To: <20201118030950.GB1804098@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.112.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8b5bbe8-b9c1-4d49-74f1-08d88bd19f0c
x-ms-traffictypediagnostic: CH2PR12MB3655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB3655D8205EDFDF59015C9879D7E10@CH2PR12MB3655.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wPJCFfE6/ZPcqESFXgkKBNP8j6E0DtfRiONhe2H61ykkr13+BA/EuFF/GHjJBB6RwtKBmwrZp0WCI1w0y0P0mN31drYFi154e36vHQv8MD73l7qYW4UxUMcupUo0eppN+gwQAcDWHOEOtNXdxuXtT/BE9iDCBccclebGAC1uAdb2l3zdYzP0IvbYRRy6TbduQYmrE2H5V6T3cU6qEgpcr2PAHzm97wplQB8V2mCbCkxw+ULqb4CwIpCCEwIIYGX73umwrsC9m7LQCYV8XmbmYzlUJB8jWz4WEc61cW99k2hzXsFAXqVeg4zSdM5soRjobA3K2+hyLVl8uMNPme0gWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(7696005)(2906002)(64756008)(478600001)(33656002)(5660300002)(6506007)(52536014)(8676002)(86362001)(186003)(26005)(4326008)(316002)(6636002)(83380400001)(66446008)(54906003)(110136005)(8936002)(9686003)(66556008)(66946007)(76116006)(55016002)(66476007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Rys7SFBBpSeF0XPxx/lfclwHE7OylnRUQjoZhrykmQEqvag9lFoOS1dN0R9+v0kFNOb07Z/epy9sxNcnxKkWVGdNJ9Uyo4v0OERQn6d/KZJO2PHgw84rWo0jYtXLOzCPtxJCCc9y40GrCEKy5uABOPl8SkanprPJW1mfkRe/9mCAnWpNJUBt2bVfcVc0FK3hqwR8MFeQdyvIqqODCVNOWwPMOo3w8XDxaSmJ/E5d3diJHHyRtQNGK0ckTBHI6+6vGL6XPFzSvsQ1b6/jY3YnIaOIN8UTU6S2cGGWuirNYmBi5KKHIc94haHLuk1pGaRqKEC3YLpv+ZIK2iXnFZDN+OBi0UqdrR6rgRSUBgDS1NHk0NBnvp91WMry0uK/usR1Q57R2JQhZy6Uvh9nHQnFwNaWmZ/9ZzGLc9KBwjr42exrA6kYqeL5B0cFvfvMy4d+DXmA+DuGylm5vDOcW+H947PHmLiVs1Fi4Kj7KQ+innXagw2Lyd9kRtOawlZPAzbhjWf40oA0f85Yf7Xk8XjS5RjKPi+9mpgcA+4gyR8ENnE98JdTarbIUgi4rtbt12WDLEgnkS5H4sOig2N7Qxb5vYJ0hOuq4FZuE5sbt/RDlfpMirY7vEVNX4FDV3bxxlrTxs00jRsq4jDtQ1GQ/WPgQ6AeN08MLAnXK/wmC+BFz8y8WnxB0GymPPfgF16/zGFow5mIs+avclLHyldGXTQfRNrF2lp6clb/IIYVToPjhF91xUwYLJsk7IuGNIt3DUnJjzkv8YKu3XMFBBjs8SZ+UI82dw+tvnVJ9zYr7iziQgeR9Q4hXMnUtQTl0nGMW9xmT48zibu5CF3oF37RiscpR/ifwgwN4mTS3ROtu5Whct8S5FUAY9QOrBm2F3TdoykD+LCDt3aLC8lrSZfs9Oi7LQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b5bbe8-b9c1-4d49-74f1-08d88bd19f0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 14:52:50.4715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EhlVDmgfQLRBzg+GnYpELJSbp3eD6oe8yISa2gRwnvtcJpw1tiCzoDQ8f0xp8V49gCFYQGz4Qa/lST86HB+Luw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3655
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605711163; bh=oMkeX0BjZsk3qdIa1dXD3fW7CiUgs32i9vaZTGHM8CI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=IWkuFEbGaZQNOpt0Q/bJvHnA1YvTp7HjRX9dhq3bA/mEsRFSOIeXYPxH5jBvAYG64
         jQ6G3E+xzS0Cs12cshNJmiLFHP3fmb7uB1fFMal9O49tfuXmdtOjE76F+2bNSNbBTy
         M28LLhYlngaXYmY9tSXwCQForMSqneY7CuSLEOyWomDoSpMfDAu5kvA0E5ALwB/7C1
         acnrO5ULk2R6hNaL0fClUzo3dMWbCaFkmfIluTAuJbaHoGzgMxB7z4pQiwI7iUcijb
         r+BBMOHk4hWXTMRvtL0xlHyIfNqf4x+2D8vMlSqpRvmbKFffizmZJWR2+rGLL4tG7s
         Xfsh4eEi7KKjA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> > +static int mlxbf_gige_phy_enable_interrupt(struct phy_device *phydev)
> > +{
> > +	int err =3D 0;
> > +
> > +	if (phydev->drv->ack_interrupt)
> > +		err =3D phydev->drv->ack_interrupt(phydev);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	phydev->interrupts =3D PHY_INTERRUPT_ENABLED;
> > +	if (phydev->drv->config_intr)
> > +		err =3D phydev->drv->config_intr(phydev);
> > +
> > +	return err;
> > +}

We actually just need to make sure here, the PHY INT register is still conf=
igured properly. mlxbf_gige_phy_enable_interrupt is called right after phy_=
start because the PHY INT controller/status register gets cleared out after=
 phy_start due to the call to __phy_resume. Because it gets cleared, the PH=
Y no longer reports any interrupts.

> > +
> > +static int mlxbf_gige_phy_disable_interrupt(struct phy_device
> > +*phydev) {
> > +	int err =3D 0;
> > +
> > +	if (phydev->drv->ack_interrupt)
> > +		err =3D phydev->drv->ack_interrupt(phydev);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	phydev->interrupts =3D PHY_INTERRUPT_DISABLED;
> > +	if (phydev->drv->config_intr)
> > +		err =3D phydev->drv->config_intr(phydev);
> > +
> > +	return err;
> > +}
>=20
We need to call mlxbf_gige_phy_disable_interrupt from the stop routine beca=
use if we leave it enabled, and decide to call the ndo_open routine after, =
the interrupt coming from the PHY will be discarded until the PHY state mac=
hine is setup properly (via phy_start).

> This is, erm, interesting.
>=20
> > +irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(int irq, void
> > +*dev_id) {
> > +	struct phy_device *phydev;
> > +	struct mlxbf_gige *priv;
> > +	u32 val;
> > +
> > +	priv =3D dev_id;
> > +	phydev =3D priv->netdev->phydev;
> > +
> > +	/* Check if this interrupt is from PHY device.
> > +	 * Return if it is not.
> > +	 */
> > +	val =3D readl(priv->gpio_io +
> > +			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> > +	if (!(val & MLXBF_GIGE_CAUSE_OR_CAUSE_EVTEN0_MASK))
> > +		return IRQ_NONE;
> > +
> > +	phy_mac_interrupt(phydev);
> > +
> > +	/* Clear interrupt when done, otherwise, no further interrupt
> > +	 * will be triggered.
> > +	 */
> > +	val =3D readl(priv->gpio_io +
> > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> > +	val |=3D MLXBF_GIGE_CAUSE_OR_CLRCAUSE_MASK;
> > +	writel(val, priv->gpio_io +
> > +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> > +
> > +	/* Make sure to clear the PHY device interrupt */
> > +	if (phydev->drv->ack_interrupt)
> > +		phydev->drv->ack_interrupt(phydev);
> > +
> > +	phydev->interrupts =3D PHY_INTERRUPT_ENABLED;
> > +	if (phydev->drv->config_intr)
> > +		phydev->drv->config_intr(phydev);
>=20

Yes mlxbf_gige_mdio_handle_phy_interrupt is used to check whether the inter=
rupt is coming from GPIO12 (which is set in HW as the PHY INT_N pin). There=
 is one HW interrupt line (here defined as MLXBF_GIGE_PHY_INT_N) shared amo=
ng all the GPIOs and other components (like I2C). =20
Now you mentioned that we should not be copying core PHY code. Ack_interrup=
t needs to be called here to make sure we clear the interrupt after clearin=
g the Mellanox HW interrupt MLXBF_GIGE_PHY_INT_N. and config_intr needs to =
be called because phy_mac_interrupt causes the PHY device to clear the PHY =
INT enable bits.=20

> And more interesting code.
>=20
> We have to find a better way to do this, you should not by copying core P=
HY
> code into a MAC driver.
>=20
> So it seems to me, the PHY interrupt you request is not actually a PHY
> interrupt. It looks more like an interrupt controller. The EVTEN0 suggest=
s that
> there could be multiple interrupts here, of which one if the PHY? This is=
 more
> a generic GPIO block which can do interrupts when the pins are configured=
 as
> inputs? Or is it an interrupt controller with multiple interrupts?
>=20
> Once you model this correctly in Linux, you can probably remove all the
> interesting code.
>=20
>     Andrew
