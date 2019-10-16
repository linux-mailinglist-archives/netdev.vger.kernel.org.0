Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A7DD8BE5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbfJPI4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:56:07 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:37780 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbfJPI4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 04:56:06 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 15BD2C0CE5;
        Wed, 16 Oct 2019 08:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1571216166; bh=AxemtfnAXdxcUVj4UVCsEPmZxZV14bfT4ObxXkxsSbc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=flI6+faVZ+6RRIUxEle/45fex+HM8UkCQ9idV9TdeZXHB/YiZrkKhRSQ03kei1jRq
         emK/hJanaLxT7xr4KMSQ6xvmXv6qOneNE8EE4NcFppZbzjTWdblQjiUE6NQIiYuQ0x
         s6Ulz3RIMW+5cnvk94UGyAGoVpYzywQluWOdGcLYVMJCZV9V/BT28ys+3oj36JD2/C
         RO0A2L4Zo9L4xFptWJXlmImh4GHoNcr/pftDx5EFAiuJGWCryUnTlhMfZRUjoO66U7
         X46Rtn9Go2MogpHSFruIhHrQfBUxUHUukqlIYik7Uj1u+/PTkYFEMpe3KzUAaRXFtl
         WCex5K9Lcwl9w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7FB5CA008A;
        Wed, 16 Oct 2019 08:55:59 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 16 Oct 2019 01:55:44 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 16 Oct 2019 01:55:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VN51FJTki7SctCdKI3sziNm4KRTPgrD8Oiw/UvJk9L36PGIufa6rixLfyOzWbTVxJDMrzIpX3RNq1Td5hcvjHjcm7wFK75BgM9GvCMXPQThdefI3lFm2dWEIFTUkYfhmiY/ZQKbBuk3M7GA12pCXvjQ1iEi1ctGh0pEvPB+I3U2djbTe6edo9Cs35iYi2ugeKGv9W0p2jAvz+H5xA5sESlw49yyzP/R4YzTYDDiNFwlGwnJoPGt1qRzsoCs2D+wMkCoor85p+raH4+o2nGmcJForwZb1/9lb4Xy+4S/iFLg4CuSQ9pFpb7yeCHSXR9dkp/irsgWJT7roFg+gVmOkLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pr9OI/yD3zUAvAzzF2vpqfh3aISLaJn/zaVKBFYkzIA=;
 b=mB35u1xhxc4yVsFFUCVifjsod9U+nJtsK7fws8NzKODDp2ljIivxJzcLBU87h57NLTJ+oUvtBIPpkkdkSGsq335O9lhXcCHbqk/OnHUzD60zEPblN/GhZOGgo6hXdF90fchqA3ApIRLwNJWuGuiMX3B6oUOSsbOkVtk+b1vrqvoCTd/WezUXi5d4L+h8/v7ZEdE/nNvlIEKEZ4xqB1VTbuUXbVIXHD9WvE8EPTid6gyl+PXt3EdqGnmLQCR/oJWZJvC6zohEhPrwEOPXDQKR8tUgSWZcNIEVhcGY9j6P497pOnisCXuSaLmDis5mSO8LxbcWMheQJuePF7bCr80caA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pr9OI/yD3zUAvAzzF2vpqfh3aISLaJn/zaVKBFYkzIA=;
 b=hU3+ollkxLmRo2SPFQxpbuqDMiAFD4P+YhkXHDpkFpuC5MaLwkl0Dv6z4IGV7esuXvw2ADDd1SJKy8bquagUTfOP8buBF7dN1aduTnjt5Or9zuwB6A9TA/zTJkRwpLIL46qdJwhZcCC7Y+LsIVny0j2nCLevWb/PMDDKs2zf0xQ=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2851.namprd12.prod.outlook.com (20.179.65.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Wed, 16 Oct 2019 08:55:43 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f431:f811:a1f9:b011]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f431:f811:a1f9:b011%3]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 08:55:43 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "cphealy@gmail.com" <cphealy@gmail.com>
Subject: RE: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
Thread-Topic: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
Thread-Index: AQHVg6sD/Z3YV8nANkekqPlmkekI5adc9FFA
Date:   Wed, 16 Oct 2019 08:55:43 +0000
Message-ID: <BN8PR12MB3266989D42B1C5B09E7053A3D3920@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
 <20191015224953.24199-3-f.fainelli@gmail.com>
In-Reply-To: <20191015224953.24199-3-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68241eb2-c15e-4785-be81-08d75216a075
x-ms-traffictypediagnostic: BN8PR12MB2851:
x-microsoft-antispam-prvs: <BN8PR12MB2851A47DC6F03E93CA9038DDD3920@BN8PR12MB2851.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39850400004)(396003)(376002)(366004)(346002)(189003)(199004)(2906002)(99286004)(54906003)(5024004)(2501003)(74316002)(4326008)(6246003)(256004)(486006)(76176011)(33656002)(26005)(476003)(110136005)(446003)(11346002)(7696005)(305945005)(7736002)(6116002)(6506007)(102836004)(3846002)(86362001)(478600001)(25786009)(7416002)(186003)(316002)(5660300002)(81166006)(81156014)(55016002)(66476007)(14454004)(64756008)(66556008)(66066001)(9686003)(52536014)(8676002)(229853002)(8936002)(76116006)(71200400001)(6436002)(71190400001)(66946007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2851;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eyueseTcTiIPQNEOIvnPRnWDq3B8D0c5bBluvDf9/UlilkwlgvObTJw6xIowV4wvWeMjBQIvWOA+/701zU7E+WkGuIpgYDt5BzDD5tiWv2NVpOBwCleTEhuTt1sf+2K+FhygLSMrFkij7pt4TQOX6D3rI4Bje4IXEikmGL4KB9f6bH+RvIDByBSNPCJNsrhbpwaNDWekCSRutQ1pMKN7CviAXyvahkfD8LPEpN2rW8Z1cW1B5O2XnSz5f7OqYT+ViEgfqAu0RfE6lHfipjWAzu1BHLv2MT7zbQMGYccgr4JEvWbBcE3RgmWqU9iRiOLv3AH6gu9MlRMszXCLZ1abbrae1w80FfhOGXhp/wdYUVjGdCLHmQc29TcMd97Y/lsG0DVCY3lGLkC8ppkxHrnbPfuQ8qdbSQd8acztbzzcza8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68241eb2-c15e-4785-be81-08d75216a075
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 08:55:43.0344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uzhKSUmNMw68DyXE6w1SMolTkY4TMgaZpTcPAOmDw86pXbRgbYG8POHyKPLZafrSwerLmN6uTPrU18gc/TtzKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2851
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Oct/15/2019, 23:49:53 (UTC+00:00)

> The function phy_rgmii_debug_probe() could also be used by an Ethernet
> controller during its selftests routines instead of open-coding that
> part.

I can add it to stmmac selftests then :)

> +int phy_rgmii_debug_probe(struct phy_device *phydev)
> +{
> +	struct net_device *ndev =3D phydev->attached_dev;
> +	unsigned char operstate =3D ndev->operstate;
> +	phy_interface_t rgmii_modes[4] =3D {

This can be static.

> +		PHY_INTERFACE_MODE_RGMII,
> +		PHY_INTERFACE_MODE_RGMII_ID,
> +		PHY_INTERFACE_MODE_RGMII_RXID,
> +		PHY_INTERFACE_MODE_RGMII_TXID
> +	};
> +	struct phy_rgmii_debug_priv *priv;
> +	unsigned int i, count;
> +	int ret;
> +
> +	ret =3D phy_rgmii_can_debug(phydev);
> +	if (ret <=3D 0)
> +		return ret;
> +
> +	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (phy_rgmii_probes_type.af_packet_priv)
> +		return -EBUSY;

You are leaking "priv" here.

> +
> +	phy_rgmii_probes_type.af_packet_priv =3D priv;
> +	priv->phydev =3D phydev;
> +	INIT_WORK(&priv->work, phy_rgmii_probe_xmit_work);
> +	init_completion(&priv->compl);
> +
> +	/* We are now testing this network device */
> +	ndev->operstate =3D IF_OPER_TESTING;
> +
> +	dev_add_pack(&phy_rgmii_probes_type);
> +
> +	/* Determine where to start */
> +	for (i =3D 0; i < ARRAY_SIZE(rgmii_modes); i++) {
> +		if (phydev->interface =3D=3D rgmii_modes[i])
> +			break;
> +	}
> +
> +	/* Now probe all modes */
> +	for (count =3D 0; count < ARRAY_SIZE(rgmii_modes); count++) {
> +		ret =3D phy_rgmii_probe_interface(priv, rgmii_modes[i]);
> +		if (ret =3D=3D 0) {
> +			netdev_info(ndev, "Determined \"%s\" to be correct\n",
> +				    phy_modes(rgmii_modes[i]));
> +			break;
> +		}
> +		i =3D (i + 1) % ARRAY_SIZE(rgmii_modes);
> +	}
> +
> +	dev_remove_pack(&phy_rgmii_probes_type);
> +	kfree(priv);
> +	phy_rgmii_probes_type.af_packet_priv =3D NULL;

I think you should set af_packet_priv to NULL before freeing "priv"=20
because of the "if ([...].af_packet_priv)" test, otherwise you can get=20
use-after-free.

---
Thanks,
Jose Miguel Abreu
