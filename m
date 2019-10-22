Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27048E0103
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbfJVJrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:47:11 -0400
Received: from mail-eopbgr150043.outbound.protection.outlook.com ([40.107.15.43]:47071
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730312AbfJVJrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guWFb9VDDwi1Dy/vnZ363fu4RdVOU+96B3vwp4jCaJzWjqwIfRwC7MZgPc1/UVa32m5w9lHmsIhx2VcDg2wXFCh6UcdCLUO+oeD+wZ4MUhjW33TF/wesrVXChFxj/tjacM4UXEGpy4rSwqBsW+3+GuucbzoV/Nr5SdmMBnUXsILT1Rv4TkkJ3o/z82M/X7mpTsphPAMd24cfZr0CVnSvwIg4W5fIaOB1kjrA/BFwnksj4tiTbpc7vbsvkXhhgrlyWGPv4DvG5eMXmcv3Dnq9ugArvvsca9bHJDdi7WUhmVZ+8d19qPsvdlsElqhjA7L5TX6eyHoIpRcAtgv3+BBEgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfXxo4+MVPLPPMFrqqDq9qIeD9hWj25sTmXzf7vgtVo=;
 b=lToGFwQqZXqRhunbg5QQXQhOVHr1x3zdZ78gnOt+dlNExRxr84XfdURCb/tQCSPcvTMTUlNHvw8YrPE5NYju0JJUnK3/i6jm6cp+5nvC3O05j+j8vjI8JcieQtK8S9UIBX9ghhHFfUidT0mnA5/sgWBvYKY/bwKE2+Q3yg/f9TyIy3y+uEc5M9KWn3zqf4Q94yEmXck+3gODiSSR6Q6jqEgMf2ZAJj4nISmSx37hJAcfMYUEVfUJsZaZuHkDLiQyALlVy64B0KwRJYRECipkH3gIaERGfmafnuaTK3iRmgbwZHleIeXvOPonodnZSSC0WMH17GB4FGxvQP2AaAhdIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfXxo4+MVPLPPMFrqqDq9qIeD9hWj25sTmXzf7vgtVo=;
 b=BYVb6M+CwQRyvo/O7Nc3OrVHjsgL7JGbLlnBEY9NDKb3wuhY6MWfJgtRR4js+G2dCXc0igaUq0SnO0cjcdSaNKPnYECy8NkZpCYuk30SjITbPvXbVHCMVXN23gC9FpBYTS+hPxrJR3/4LCQDh2UGR5K5Tv7bQF4vrbOuwGRzIOI=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3565.eurprd04.prod.outlook.com (52.134.9.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Tue, 22 Oct 2019 09:47:07 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2367.022; Tue, 22 Oct
 2019 09:47:07 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rmk@armlinux.org.uk" <rmk@armlinux.org.uk>
Subject: RE: [PATCH net-next 2/4] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Thread-Topic: [PATCH net-next 2/4] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Thread-Index: AQHViGH40719o3a9PUiEMMfGYOQweadluXqAgACw0aA=
Date:   Tue, 22 Oct 2019 09:47:07 +0000
Message-ID: <VI1PR0402MB280005DA3369B45E551246B0E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-3-git-send-email-ioana.ciornei@nxp.com>
 <20191021231317.GA27462@lunn.ch>
In-Reply-To: <20191021231317.GA27462@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24e83a05-1fec-4169-e42f-08d756d4cd5e
x-ms-traffictypediagnostic: VI1PR0402MB3565:|VI1PR0402MB3565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB35659A1EDA21355E2A30B2E5E0680@VI1PR0402MB3565.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(366004)(396003)(199004)(189003)(6246003)(476003)(66446008)(66556008)(76116006)(6116002)(55016002)(64756008)(66476007)(81166006)(102836004)(81156014)(6436002)(2906002)(3846002)(86362001)(66946007)(11346002)(26005)(8936002)(229853002)(5660300002)(486006)(44832011)(4326008)(9686003)(8676002)(4744005)(6506007)(446003)(76176011)(478600001)(7696005)(54906003)(316002)(99286004)(25786009)(52536014)(74316002)(256004)(6916009)(186003)(66066001)(71200400001)(33656002)(7736002)(71190400001)(305945005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3565;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kXqN2J7vSV0lH/gE2erek1B6xMX9QKyfIlTe1Q4VnNxqw9G0V2dSDB5QXxwRbxIj8j7nUTZmTwjRMpEYIqRgp4ZtfkMNH2m+h+GkafxGFpIE+kLDmP9z31ZKWSc1k1FN2yeOcUD/2xBv/7d6Sv1JGnviP4yT8AGs59q2DbpKtMkLReN/m2yaIfDebAZuv1yJulRagHOyOiCmFwbgVXZdZDJUv3O8wMnB77oPMMcwzM0AMm9hTmOesP2FFOAf5EeXjLrBbIYq7s8OR6e99WbKZGS7BsXmQyuFQYktP/ko43eHy8oLYnw5/TXkhfojDi0waXXRcletUKiAeLQzupQRcpIdPCPi6Lb1gSG0ynxsHY04IVqJ2uiyzwWYbMgDRlWJ7JnrfmpiMtp66uj0yvJI2Uz8nRZyhCIWYfpsPRQm2vw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e83a05-1fec-4169-e42f-08d756d4cd5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:47:07.3098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8Y0yKrWUGyP8snm9ZPxGQ489riHtp3ilCVudFUcGCiJ+/pE0/Vv2ongtx1UpL26LfHyjDqoX3DeQKdi2sPh3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3565
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Ioana

Hi Andrew,=20

>=20
> > +/**
> > + * dprc_get_connection() - Get connected endpoint and link status if
> connection
> > + *			exists.
> > + * @mc_io:	Pointer to MC portal's I/O object
> > + * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
> > + * @token:	Token of DPRC object
> > + * @endpoint1:	Endpoint 1 configuration parameters
> > + * @endpoint2:	Returned endpoint 2 configuration parameters
> > + * @state:	Returned link state:
> > + *		1 - link is up;
> > + *		0 - link is down;
> > + *		-1 - no connection (endpoint2 information is irrelevant)
> > + *
> > + * Return:     '0' on Success; -ENAVAIL if connection does not exist.
>=20
> #define	ENAVAIL		119	/* No XENIX semaphores
> available */
>=20
> This is not a semaphore.
>=20
> How about
>=20
> #define	ENOTCONN	107	/* Transport endpoint is not
> connected */
>=20
> 	Andrew

ENOTCONN is a better fit here. Will change.=20

Thanks,
Ioana
