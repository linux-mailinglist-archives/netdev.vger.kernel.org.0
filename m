Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA31B9983
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 10:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD0IPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 04:15:11 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:60640
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726003AbgD0IPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 04:15:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/OHYr4Vggi0E6NlhXLdNl5S+la+MUwJelObP4S8WFBVtakmPJ0/OhXx4XG+sFGj5N8VZmqmy4OGKHs9cz44h0ZtcQfBXGVfsuALyBy3UzBZcLLWthZijxcI+kNnDFUbe81rbFCv5Zegv2RCPdCRB9drBaqAozUBe3VwcTuuORb5f1tGj4AZA+iiIuuf6LH4wZrLOXzOCTRar14TKxvWVwWfqxfaoh6xyV4TlBQTUCMunNxSftGrgyYMuUhl3ng1liENO8mGDtatBCAgmYjQ5YCt96hunEBslVA4jryN8rfddLSGLeOtW67GToJcXRh/Rpxt2Oh/ed/SV9JAcTocYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahpeHzMx8TOM8o+lJsD9EDBgpBwp9JHVo5fAGkCoJa8=;
 b=P8msHLzRccmLxGQNs99gDX1kfYQAqVh2Inv3ni8LSHFtAfBbfe9c7dVWHHTjgUWV/2Euz9sZVQQld2aPz0RMBxzwIm7dMvmLZ+/JtNZt03+kD2cKpjeSF87Q5TcMl7jMMuBfa2fZmdbP59bNYWp63qSWRLwmZn7ch5SFsYanDHdGSnSuI95ajTdumEFZiZEyeUvMAt2LW+7nqhlOMpKl42iohsZD6NTcQlrB/KlwiZB+RKgNAwFxXLP/EVhxKebtpvHJ7MViZNe41qkVH+f84UslqW/PWnRrokc/c9krgQa0kaRatBukDCJFcMJ5icH1uifxtUN8cLgqxUBy6WMIAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahpeHzMx8TOM8o+lJsD9EDBgpBwp9JHVo5fAGkCoJa8=;
 b=S5I+b4u6bzvfLFiZ8Xns9R/4FQvVSBUs6nVl+oAtKKaIEsMXa9UG/jlks0Xehco4edWrIeFlxRygsDadbhmm1jOX7yqlyGI7l0rYU+hs//7j0iIgmr/L7skh3O2BVU0X3ILj9eiQ/KDBUQPo0WwprxOM6Eogy50wJcjsOaMslm8=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB6841.eurprd04.prod.outlook.com (2603:10a6:10:116::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 08:15:07 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%10]) with mapi id 15.20.2937.020; Mon, 27 Apr
 2020 08:15:07 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Commit "MAINTAINERS: update dpaa2-eth maintainer list"
Thread-Topic: Commit "MAINTAINERS: update dpaa2-eth maintainer list"
Thread-Index: AQHWG/HhEP5BTEAKSEaIobRV1LLJ36iMnPMQ
Date:   Mon, 27 Apr 2020 08:15:07 +0000
Message-ID: <DB8PR04MB6828010EDE71CAA128623CB2E0AF0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200426174058.GB25745@shell.armlinux.org.uk>
In-Reply-To: <20200426174058.GB25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9396a053-4902-4ba7-c031-08d7ea8318f9
x-ms-traffictypediagnostic: DB8PR04MB6841:
x-microsoft-antispam-prvs: <DB8PR04MB6841EEA803956E7DE33D5C51E0AF0@DB8PR04MB6841.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(86362001)(66556008)(4326008)(64756008)(498600001)(33656002)(9686003)(76116006)(66946007)(66446008)(66476007)(7696005)(2906002)(81156014)(52536014)(55016002)(54906003)(5660300002)(71200400001)(6916009)(15650500001)(8676002)(26005)(8936002)(44832011)(186003)(6506007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HJuPfAj+rUZuGaCjTvELepruRH4+xW8+2W2XYyZmKRgh6xKN1WskkxYxBwx+UEK6sjpEjbmjxXv9K/WqFqBz/l2zliJfbjvqfAWKh0I6EL5FNGnVGVkqKuZv2ALid4boyI1YqWAnXCDLkiuWE13gOGxWcp6tX9DGgjl/qPcDW3elECGVWskYLSWbLsiMY08ToI0HYMHSDFvoOiGBimOds6+te9lBgTYmsoGHbrSTguHnKb/Pnw8jgd1M8ZORczA5fRhq/liysJAKrdpkSABkasGSq7L2OPs1tO8Il+uQYKFBElsVlRJnvoxO3Pmevlb8aXA93AQdRPMYymISb6foYbKM36oiFoppsErK70hOquHEYiDH4oiRK3h+AgvBCsrFEU/c1D52ogmPStn8NSkRztjtyDXdfs5EVTFS6nQcCU1ZcpCAikEBM1wlHZVExIpY
x-ms-exchange-antispam-messagedata: r2kdgIlVs/nqyClYotACEJOHq4u6hrFsrj/ZdtaNL8ZLHg0pz9UIzddWCB67wq4sph8PfHlLHDUsDK7Pce3h6k59MrEwJ9+1+vQqzCz+meAZntQ0AanvFCxYxr9n0i0wIA8LmbLAd1UgEBmD/9+fRqj7r1Wj4M7KjeWofqcdixmn78diFCh8pczgxgxm0iE0gYXqed0cyI/5KLacmjfZs12oyIdudtw0UKy3tsqQIj2W+WGXBNsmA34ZrM+uRNvJ90RLOmruE1FNMhsSSCUmLk74K4q8+FZouFvHtDIRD47KzrRznHC6EHa0Gw5EOYC4tpZK0208g305RHaOBXRSVklZZxjSmCLXkNNmZGDaqjQSRRUIeAfGdpXTygA5T/+4D3cyoPY6+Odx0fHvoG+o/mqRfql6+lW/LSpDfiObx+Ddbne71PQ8pzn4p/2YZyYGQZ6qbbxbrtc6JVt483EpKG5GK2pXylhASfqnaVW9mmQO3XbX3eEwMB0Ur5FU6C8Yutv5egBvYwYPr+QwdPRnDqcJ46yI4hRIeaduHhTFoGnxCU3+6SHfo8H7cJRODQJCVcSkgbvQB8CQntWOCoYdqbkPVACJ4Pc4Uv1aPPsPIWkQgDZrwpS1HJSv+FNmFOpdDjOnVpdlur1w7mM40lhW+3kEJhJBGBiNFJLY1H5RbgZx8GweGkZSC5c/MQkEWcbylKWmapjjzLP9W+9Po0gpwjb/IwT4APz8AGI6Xu8mGOw2qz3TVjghvjqgSZVmt49BoedYIvL/HUxK5HyN+XzW6ZI3mdS2ooMQfKrSTLKm5Uo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9396a053-4902-4ba7-c031-08d7ea8318f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 08:15:07.5745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCY3ENr1ZIUPsSQooM+X++uWj8vHpw6USaARf3Vp2+pcLY16gA8tiFx1iXhRdMMeEfowoxpcWTJuU5gECKcEEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6841
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Commit "MAINTAINERS: update dpaa2-eth maintainer list"
>=20
> Hi,
>=20
> I see there is the commit below in net-next, but it seems to only partial=
ly address
> my comments to you about the maintainership of this driver.
>=20
> Is Ioana Radulescu's email address now active again?  If it is not, then =
my
> original report and issue with the maintainership of DPAA2 still stands, =
and it
> interferes with my ability to send patches.
> It means I have to keep adding a commit on top of net-next to fix MAINTAI=
NERS
> every time I want to send patches that touch DPAA2.
>=20
> Please check what the current situation is, and remove Ioana Radulescu's =
email
> address if it is indeed dead, or let me know if it is not.  Either way, I=
 would like to
> get rid of one way or another the additional commit I'm having to carry t=
o fix
> this apparently broken MAINTAINERS entry.

Hi Russell,

Ioana Radulescu's email is active. The problem that you encountered previou=
sly
was generated by a lack of storage of the account, which has been fixed now=
.

As additional context for this, Ioana Radulescu is in a LOA and I added mys=
elf to
the maintainer list so that I am copied to patches on dpaa2-eth during this=
 time.

Regards,
Ioana C


>=20
> Thanks.
>=20
> commit 31fa51ad7c5664d0e6530e3d537e2eb025aa1925
> Author: Ioana Ciornei <ioana.ciornei@nxp.com>
> Date:   Wed Apr 22 20:52:54 2020 +0300
>=20
>     MAINTAINERS: update dpaa2-eth maintainer list
>=20
>     Add myself as another maintainer of dpaa2-eth.
>=20
>     Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6851ef7cf1bd..d5e4d13880b2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5173,6 +5173,7 @@ S:        Maintained
>  F:     drivers/soc/fsl/dpio
>=20
>  DPAA2 ETHERNET DRIVER
> +M:     Ioana Ciornei <ioana.ciornei@nxp.com>
>  M:     Ioana Radulescu <ruxandra.radulescu@nxp.com>
>  L:     netdev@vger.kernel.org
>  S:     Maintained
>=20
> --

