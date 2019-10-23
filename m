Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AB7E120D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbfJWGYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:24:13 -0400
Received: from mail-eopbgr30062.outbound.protection.outlook.com ([40.107.3.62]:30438
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732574AbfJWGYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 02:24:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwgXKLyReHaLW1PTnx/sZvTH8SwET4wGhm94kHxjHYozGf3fI3+punQ3KqWsY6dK6Tdj8MYnxw/W6DqlTfHiywusKeuaf35IGQhqSpeP/FsYjhqafhlk0+HJ6q2wHDYrti5+T/R8LmW4WhRft+SUMXiOe7kuKot4SmSI/oNpxfl1jBZJ8aLbZfNtWU/gJw2q3wJ5CGJVloYEQSz9GFwtxncavbQT9Yr+VmbLQbNAoOnwON9PXDY91AgcW8dCFHik9QGNy8adh5Qs/F3l51FJEp6JhO2w0PLA5pjsf6rGcqEmBswyZeXcJw6hqPtcIcZ/OSugDQyZhOCGvdJaSqqCTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5bADGJcQF1KHNO/95eo+3nRlXgL4FeljZ0SSkTqhX8=;
 b=bReeTBSH32Ql6SeKZHyd2TM9Qi8Ei/VOciadd9a+gxGN+IQHJbJrR0W/xY1uPUlPWsHNqEhVC34er4czJMt12t3yHE/QVp39jZRm8fKFkIUSjgLhtUUzJCHqloFpLURTlu+JUh+cvTMrysg5wcrcyAbet7Aszw29ziAx6ExLayV3HWnxQ/fIIgo4HUYnBiaP9zgKVd+7kP51YGVmkPQog0lHzbXZoDLK8LoF6jjafbU+KAxVmJHvz4pgARjaVi5XlXDTzG647UEq1KjDkfLeDesKWbgI4U2sKijg+4x2yGro+WaBHtCaOHWKLjJTZ9U0sp/md3d7oZQfSbyNBCWhDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5bADGJcQF1KHNO/95eo+3nRlXgL4FeljZ0SSkTqhX8=;
 b=aA/XkfpN+k2fgnjnRhl7x0LNZZqpWmRSNYsa/fDix4A8Knm/KeREPXiYOSKGOdj7H9Kr2TpTuOMj7aOK17BLIIhQbBINTvAE1tS24X5A4Si7XW5SySZsHxLwahFZQbRRIFoPSn/F6Zgn+pZl2RsG3mDzeL7zLQevKERqlf1AV/I=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB4621.eurprd04.prod.outlook.com (20.177.55.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 06:24:09 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 06:24:09 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: RE: [PATCH net-next v2 5/6] dpaa_eth: change DMA device
Thread-Topic: [PATCH net-next v2 5/6] dpaa_eth: change DMA device
Thread-Index: AQHViMn3r398P4gZBkKNRRamt6o89adnKdUAgACZfhA=
Date:   Wed, 23 Oct 2019 06:24:09 +0000
Message-ID: <VI1PR04MB55676A488FD01BC586104C63EC6B0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1571742901-22923-1-git-send-email-madalin.bucur@nxp.com>
        <1571742901-22923-6-git-send-email-madalin.bucur@nxp.com>
 <20191022141436.4f727890@cakuba.netronome.com>
In-Reply-To: <20191022141436.4f727890@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c7f76562-bf29-4ef0-4369-08d757819d47
x-ms-traffictypediagnostic: VI1PR04MB4621:|VI1PR04MB4621:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4621BC5106AEF84668C04F0AEC6B0@VI1PR04MB4621.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(13464003)(189003)(199004)(25786009)(316002)(9686003)(55016002)(256004)(6116002)(229853002)(3846002)(52536014)(54906003)(6436002)(6246003)(4326008)(6506007)(76176011)(7696005)(5660300002)(478600001)(71200400001)(6916009)(71190400001)(53546011)(33656002)(102836004)(2906002)(99286004)(26005)(14454004)(74316002)(7736002)(86362001)(76116006)(446003)(486006)(66066001)(66946007)(8676002)(64756008)(66556008)(66476007)(66446008)(8936002)(476003)(305945005)(81156014)(81166006)(186003)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4621;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gITkjOJpK1clJlmxwSFE4GFie8I9L4oNrmjpxmpdUBCjTT8dfOAORgVKJ1NmWi/zs92Tk2ByOozihKbG8jzI+mh9oi3kE7Yqdm7zEpotZMGOIkKFlzh/zwitn2+tNQk8Q6w1dcpoDpDX4dCOCb6SnycDpV/2HrqdIqZBRuDMR1B7+Z0XLQpnH+w6xmK9Aht3VhPt48ujOfHGrWKQ0qRpQxfbbbev0wZ55EUVqJc3yyxeV+lKucGATpmQclKOYws3AkaNx41PgQWzbX7LP2CbUrPRhRhhJgxz7GPCl8hdms/L9z2LyT/skWOixKREFf4sGbVy6TdhJ6EWI5aXtqKhkjXKPs59fp2yRzORqsgGxVKVyYdIlQ+1Yu9rqhz2Skq9dj3XN5G9HycT/Cmezw+ypwjRtkjRdGnIQmV9apfI6/2tw2AVlmcV7cd53NVFjJSb
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f76562-bf29-4ef0-4369-08d757819d47
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 06:24:09.6226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFfTp4fSDyatYiAf2V50gRufL5opeZ9GrHchBfbNIFFfEi9usKto1EGrIRAB1BHUfl0A3I4WJS0k00UARvFxOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4621
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, October 23, 2019 12:15 AM
> To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Roy Pledge
> <roy.pledge@nxp.com>; Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Subject: Re: [PATCH net-next v2 5/6] dpaa_eth: change DMA device
>=20
> On Tue, 22 Oct 2019 14:15:00 +0300, Madalin Bucur wrote:
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 8d5686d88d30..639cafaa59b8 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -1335,15 +1335,15 @@ static void dpaa_fd_release(const struct
> net_device *net_dev,
> >  		vaddr =3D phys_to_virt(qm_fd_addr(fd));
> >  		sgt =3D vaddr + qm_fd_get_offset(fd);
> >
> > -		dma_unmap_single(dpaa_bp->dev, qm_fd_addr(fd), dpaa_bp->size,
> > -				 DMA_FROM_DEVICE);
> > +		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, qm_fd_addr(fd),
> > +				 dpaa_bp->size, DMA_FROM_DEVICE);
> >
> >  		dpaa_release_sgt_members(sgt);
> >
> > -		addr =3D dma_map_single(dpaa_bp->dev, vaddr, dpaa_bp->size,
> > -				      DMA_FROM_DEVICE);
> > -		if (dma_mapping_error(dpaa_bp->dev, addr)) {
> > -			dev_err(dpaa_bp->dev, "DMA mapping failed");
> > +		addr =3D dma_map_single(dpaa_bp->priv->rx_dma_dev, vaddr,
> > +				      dpaa_bp->size, DMA_FROM_DEVICE);
> > +		if (dma_mapping_error(dpaa_bp->priv->rx_dma_dev, addr)) {
> > +			netdev_err(net_dev, "DMA mapping failed");
>=20
> You seem to be missing new line chars at the end of the "DMA mapping
> failed" messages :( Could you please fix all of them and repost?
>=20
> >  			return;
> >  		}
> >  		bm_buffer_set64(&bmb, addr);

Sure
