Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D32E8464
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfJ2J0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:26:07 -0400
Received: from mail-eopbgr30077.outbound.protection.outlook.com ([40.107.3.77]:54903
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730793AbfJ2J0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 05:26:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTF1t0uOU9ndTVPGBdjHGyBFJSX+1izQT2Yz+JoPENtZ4+DA1Td0uA6xZ9hFq+y6Wujcbdg5kRo973ReXwD3rnUixM99Yr4HuTDC0lKvhsgSu2jP+3lGFdFdJCcXsnoCjPIxrbuLb8DlAlm0Bs2mUUo/mQ6aZZJl2OPgYJ2Vhkf2EGe5lQZv7vx2Ic2TZY4M52UAAWEJzAeJWXu22e102eIxthQ9TLA618QvHJ1NcDsk9cJEZ6Xz0oquCCjeEaWISeAnC0/NxvT0eTbJqoQmlnqZZ3fBdLhAvXqpchd3xLxnd+86/GXFHsIRQ8+kpLZl4PnrIKu+3RTCYk5VvNOGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdP0fdHQR4VN+9eiuvP8Y4SYnBRTFVsW6pjAdIwg5p0=;
 b=Xe1wuhuO9FIjsf7tkipFtmW9mcjikGSLn6oQqzF6kz88xDDkN8eR5R32RA/anAO9WfwTIEOdnsM0np8+rG+yL6QI5cPht/w260/RyRSerMWs89pSQvpnvnvsAwx4M15FS7wB34ornP1/k0iq4k2/roPc3tQTpcAiRSpT2g+WqTlOpuFswNzgqgTFopOIkpF67i3v/jN2SnsKvEP1vvMARHxfXFBOtoV1w9hI7EPBlXjSKOia+aATC1LNAdLZKdzWJQlRORXwy4+3saRwIMyVUAPhn71gsMXQckqKqoZ3NLt1xoJrEsVdW0U9ep85hzDdw53c6whGEYuZf3cYrqvK7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdP0fdHQR4VN+9eiuvP8Y4SYnBRTFVsW6pjAdIwg5p0=;
 b=hzmaHniA8ReK69lbq0Hplmg0L3nEgXhofEAfGUk+Jd6+tjWKN9yl8iBRuJZbk62X6k/8TKdXBBhVc0jLXstjL8Q3bUffGSMFhNs30r0ryogm0mUNFI4xsKPx2a8fhm7sHeKzVipHxovQ2JFxGlcoeYlSv9uWZnFiptj4QuU2gv4=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3741.eurprd04.prod.outlook.com (52.134.12.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 09:26:02 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2387.027; Tue, 29 Oct
 2019 09:26:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v3 2/5] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Thread-Topic: [PATCH net-next v3 2/5] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Thread-Index: AQHVix1sOC+L+Xa0dkS4RnM3YQGOjadw3tOAgACALwA=
Date:   Tue, 29 Oct 2019 09:26:02 +0000
Message-ID: <VI1PR0402MB2800DA31D3CBF552B4B77FB9E0610@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
 <1571998630-17108-3-git-send-email-ioana.ciornei@nxp.com>
 <20191029014523.GH15259@lunn.ch>
In-Reply-To: <20191029014523.GH15259@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f7164900-70ea-4125-0be7-08d75c52045c
x-ms-traffictypediagnostic: VI1PR0402MB3741:|VI1PR0402MB3741:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB374168D4CE775D5350E8B96EE0610@VI1PR0402MB3741.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(199004)(189003)(66476007)(52536014)(76116006)(14454004)(6246003)(5660300002)(186003)(99286004)(86362001)(446003)(26005)(102836004)(71200400001)(66066001)(6506007)(256004)(6436002)(74316002)(6116002)(3846002)(7736002)(66946007)(7696005)(55016002)(66556008)(44832011)(64756008)(66446008)(11346002)(476003)(71190400001)(316002)(2906002)(76176011)(478600001)(305945005)(54906003)(8676002)(81156014)(4326008)(6916009)(8936002)(9686003)(33656002)(229853002)(25786009)(486006)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3741;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vh+6ngx04JupnUX7Y7eSbOHHjnVgJHzNQ9t3SvZ9aY+odT22zcAa6gedqYKgHvr/Lkig73FxbrntmjIWAEdgZ/dZdtFjqxcpqYMgVfHLUu7OzQf73VOdYyMZGAQ8drhyZ6++HnAb+DpYS+9FwX3bdY44OHHV716Ktdw0NDLz3oz9KbCrvWd8yZUugciQNkSqifs9efz07W8zZNPCSmt+m9U4d+V1C66CTMM8c6wISFSGNDNagbnfznGKG9f7xLryhKjs4s+Ei76TrgGrk9xhYCDIE4H0vdLh3qWt57etuAc4yPbxLD1jGt8fX8kKJfm/2sayqepaBCJ0wLBM8k9/HhR+dxvhULK1u11oSieiJ6g8lqfCizI43BT0OGOwuN28nWCiJSI8juUER8HualFIsNpmVuJTqKWML7IdJwH7o+P1qnbHVYAluPr47IYp7ikT
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7164900-70ea-4125-0be7-08d75c52045c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 09:26:02.4530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kfu2cKoCrv3Zp/+toxkgfP8r5cZAi0d3a/1KH6acm4LLrhkjDH+JE+PAxNhsYcJFDz/a+Ddg/7ne5tQiKGRIiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next v3 2/5] bus: fsl-mc: add the fsl_mc_get_endp=
oint
> function
>=20
> > +struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device
> > +*mc_dev) {
> > +	struct fsl_mc_device *mc_bus_dev, *endpoint;
> > +	struct fsl_mc_obj_desc endpoint_desc =3D { 0 };
> > +	struct dprc_endpoint endpoint1 =3D { 0 };
> > +	struct dprc_endpoint endpoint2 =3D { 0 };
> > +	int state, err;
> > +
> > +	mc_bus_dev =3D to_fsl_mc_device(mc_dev->dev.parent);
> > +	strcpy(endpoint1.type, mc_dev->obj_desc.type);
> > +	endpoint1.id =3D mc_dev->obj_desc.id;
> > +
> > +	err =3D dprc_get_connection(mc_bus_dev->mc_io, 0,
> > +				  mc_bus_dev->mc_handle,
> > +				  &endpoint1, &endpoint2,
> > +				  &state);
> > +
> > +	if (err =3D=3D -ENOTCONN || state =3D=3D -1)
> > +		return NULL;
> > +
> > +	if (err < 0) {
> > +		dev_err(&mc_bus_dev->dev, "dprc_get_connection() =3D %d\n",
> err);
> > +		return NULL;
> > +	}
>=20
> You could return these errors with ERR_PRT(err)
>=20
>     Andrew

I could but the caller would still take the same action disregarding the ac=
tual error code.
I don't find it really useful to return ERR_PTR().

Ioana
