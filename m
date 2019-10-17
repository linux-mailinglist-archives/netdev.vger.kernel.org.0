Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F56DAB82
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 13:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502171AbfJQLvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 07:51:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19249 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbfJQLvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 07:51:44 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20191017115140epoutp0478822a08cc660cac8ee1b92299c0ba30~ObPCqsZys1130211302epoutp04w
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:51:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20191017115140epoutp0478822a08cc660cac8ee1b92299c0ba30~ObPCqsZys1130211302epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571313100;
        bh=z5RX4YzD39txlPDlH5ZuDcN6Ob50hPcAjN3oTs4zhOA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=EA3nrnTxepQAtA3fQcPxWTrymIgsTglvYt9xPujgpwRT4L8CsEVsESAYWzbvoAZ3e
         DWDFR1Cjn3iHwGdByhyI9hy3oWg9bxEkXj8Y46WS5AP8Ag14NqI9egIqs8/QMPWcSN
         oRc3nfNbspo42LSsSu5d+jjPTbV+U9str7Yd2tXA=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20191017115140epcas5p3dc0d25f56a592bbb1307472c1407e750~ObPCQaRDH2375523755epcas5p3H;
        Thu, 17 Oct 2019 11:51:40 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0F.24.04480.CC558AD5; Thu, 17 Oct 2019 20:51:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191017115140epcas5p4c467d9815c3456e1960afef2177b5fa0~ObPB3eT_60995809958epcas5p4b;
        Thu, 17 Oct 2019 11:51:40 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191017115140epsmtrp1f1b7c0625c35a27e8b9e82a3bd884356~ObPB2vSyA2468024680epsmtrp1Z;
        Thu, 17 Oct 2019 11:51:40 +0000 (GMT)
X-AuditID: b6c32a4b-cbbff70000001180-31-5da855cc3314
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.E0.03889.BC558AD5; Thu, 17 Oct 2019 20:51:39 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.85.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191017115138epsmtip1d4d7be4869bbae7cc0124ab22c8a501a~ObPAQkCf52661626616epsmtip1j;
        Thu, 17 Oct 2019 11:51:38 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <wg@grandegger.com>, <davem@davemloft.net>,
        <eugen.hristev@microchip.com>, <ludovic.desroches@microchip.com>,
        <pankaj.dubey@samsung.com>, <rcsekar@samsung.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <00c5c5b7-cc90-ff6c-0c49-77fe0481dac1@pengutronix.de>
Subject: RE: [PATCH] can: m_can: add support for handling arbitration error
Date:   Thu, 17 Oct 2019 17:21:36 +0530
Message-ID: <000e01d584e1$3cb91c10$b62b5430$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQHTm5UrDi6Y56TssjuVaZ0vw+2T4wFBl3stAb/DtPKnSn8dcA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTYRzl2+69u65Wtyn5y7JsPZhWc9GDG4WJRM4MUkiC8NHSi5pO567P
        KBAbEqZOfFBNw2lqJi5zavigkJWaFDp85Qv/MI1UslJJTYTc7iT/O9855zvnO/CRfLEZdyGj
        4xIZTZwyVkIIsTfv3T1OfA6qDpFnfHWmS3q1GN2+0oXRNctFfLq/tYSgvxu/4HRdeSFGdxp2
        0+VNSwJab2nG6eE6AV050YJ7b1M0vhzhKX73jSHF+EolUujW5YrcxhqkWDTtDyBuCi9EMLHR
        yYzG0+uWMMrY+xRTT7qm9sy14OnI4JyFHEigTsPy62U8CwlJMdWGIP/xMI87LCAYG9bZlT8I
        DF1GweaVjmwLwQlvERSYyuyuOQQv5k2E1UVQnlCYsY5ZsRMlg7W8clsunzLyQFexhFsFB8oH
        LOO1tlhHyh/6hwZsGKOOwDtLA8+KRdQ5yNeOEhzeBd1Pp2yhfOoYVJXN8bknucHqdBXO8c4w
        0/FhI4fcKPaBgr4D1l6gHgmgdCkP4/yX4OP0J8RhR5jtarRPc4EZXaYdx0BZmw6z5gCVCplP
        HDn6IrQPlNhoPuUOda2eXOsOyFmb4nFuETzMFHPuo1A0PW8v2gfjkw0EhxWQl60j8tBB/ZZd
        +i279Fu26P+XGRBWg/YwalYVybBn1KfimBQZq1SxSXGRsvB4lQnZfpaHfzMy9Vw1I4pEku2i
        5oDqEDGuTGbTVGYEJF/iJCrVVoSIRRHKtLuMJj5MkxTLsGa0l8QkzqJ8fDBYTEUqE5kYhlEz
        mk2VRzq4pCO/8vs7KwZvEHV93usJirNXhkaL3TSzbKPEK1z9t7v4V1aotKj/uFS4+iNDEMgc
        aqKmY3IXyQdlob6L8p9hLVGmywutfq64X/1zr8DamZygw9eDXknV61V3cFlwh6UQOy+dUd2e
        SpiovzYCblOhK+G+bbnyeymdz3hG0TftcokEY6OUJz34Glb5D1klI1pVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnO7p0BWxBs922ljMOd/CYnHgx3EW
        i1XfpzJbXN41h83ixdrrrBbrF01hsTi2QMxi0dYv7BazLuxgtbixnt1i6b2drA7cHltW3mTy
        +HjpNqPHnR9LGT36/xp49G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bpNZ9ZCz7IVJxYsY2t
        gXGdWBcjJ4eEgInE0Z4LbF2MXBxCArsZJZ7928PYxcgBlJCRWPy5GqJGWGLlv+fsEDUvGSXa
        9/WxgyTYBPQlpjT9ZQGxRQT0JH5PWMQEYjMLbGeS2LG3DKLhAqPE6gl9rCAJTgEniQt31oA1
        Cwt4S1y+dgXMZhFQldh3YTNYM6+ApcSklltsELagxMmZT1gghmpLPL35FM5etvA1M8R1ChI/
        ny5jhYiLS7w8eoQd5AERoF2TL8lPYBSehWTSLCSTZiGZNAtJ9wJGllWMkqkFxbnpucWGBUZ5
        qeV6xYm5xaV56XrJ+bmbGMGRp6W1g/HEifhDjAIcjEo8vDsCVsQKsSaWFVfmHmKU4GBWEuGd
        37IkVog3JbGyKrUoP76oNCe1+BCjNAeLkjivfP6xSCGB9MSS1OzU1ILUIpgsEwenVANjwZnw
        O/f4V3XV3Ty4/MlRtvnt37n91yWu2vW80cNe/LC4t4G33GtLQ6aNT14fvxLGtjV35ZKgAwEM
        ZbvUFjQrTbVPd2g5uuXEAZuIlX8bvlhFPytVkz+lHt79Qyr64U6Np0Y+jMuXzHLU0v8bwhPE
        u7iv//9kYbVHarwzTY7V2tmeSH4rqr9GiaU4I9FQi7moOBEAWnD7D7gCAAA=
X-CMS-MailID: 20191017115140epcas5p4c467d9815c3456e1960afef2177b5fa0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191014113437epcas5p2143d7e85d5a50dad79a4a60a9d666fe4
References: <CGME20191014113437epcas5p2143d7e85d5a50dad79a4a60a9d666fe4@epcas5p2.samsung.com>
        <1571052844-22633-1-git-send-email-pankj.sharma@samsung.com>
        <00c5c5b7-cc90-ff6c-0c49-77fe0481dac1@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Marc Kleine-Budde <mkl=40pengutronix.de>
> Subject: Re: =5BPATCH=5D can: m_can: add support for handling arbitration=
 error
>=20
> On 10/14/19 1:34 PM, Pankaj Sharma wrote:
> > The Bosch MCAN hardware (3.1.0 and above) supports interrupt flag to
> > detect Protocol error in arbitration phase.
> >
> > Transmit error statistics is currently not updated from the MCAN driver=
.
> > Protocol error in arbitration phase is a TX error and the network
> > statistics should be updated accordingly.
> >
> > The member =22tx_error=22 of =22struct net_device_stats=22 should be
> > incremented as arbitration is a transmit protocol error. Also
> > =22arbitration_lost=22 of =22struct can_device_stats=22 should be incre=
mented
> > to report arbitration lost.
> >
> > Signed-off-by: Pankaj Sharma <pankj.sharma=40samsung.com>
> > Signed-off-by: Sriram Dash <sriram.dash=40samsung.com>
> > ---
> >  drivers/net/can/m_can/m_can.c =7C 38
> > +++++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> >
> > diff --git a/drivers/net/can/m_can/m_can.c
> > b/drivers/net/can/m_can/m_can.c index b95b382eb308..7efafee0eec8
> > 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > =40=40 -778,6 +778,39 =40=40 static inline bool is_lec_err(u32 psr)
> >  	return psr && (psr =21=3D LEC_UNUSED);
> >  =7D
> >
> > +static inline bool is_protocol_err(u32 irqstatus)
>=20
> please add the comon m_can_ prefix

Alright. Will change the name =22is_protocol_err=22 to =22m_can_ is_protoco=
l_err=22

>=20
> > +=7B
> > +	if (irqstatus & IR_ERR_LEC_31X)
> > +		return 1;
> > +	else
> > +		return 0;
> > +=7D
> > +
> > +static int m_can_handle_protocol_error(struct net_device *dev, u32
> > +irqstatus) =7B
> > +	struct net_device_stats *stats =3D &dev->stats;
> > +	struct m_can_priv *priv =3D netdev_priv(dev);
> > +	struct can_frame *cf;
> > +	struct sk_buff *skb;
> > +
> > +	/* propagate the error condition to the CAN stack */
> > +	skb =3D alloc_can_err_skb(dev, &cf);
> > +	if (unlikely(=21skb))
> > +		return 0;
>=20
> please handle the stats, even if the allocation of the skb fails.

Alright. Will do as follows
+       if (unlikely(=21skb)) =7B
+               netdev_dbg(dev, =22allocation of skb failed=5Cn=22);
+               stats->tx_errors++;
+               return 0;
+       =7D

>=20
> > +
> > +	if (priv->version >=3D 31 && (irqstatus & IR_PEA)) =7B
> > +		netdev_dbg(dev, =22Protocol error in Arbitration fail=5Cn=22);
> > +		stats->tx_errors++;
> > +		priv->can.can_stats.arbitration_lost++;
> > +		cf->can_id =7C=3D CAN_ERR_LOSTARB;
> > +		cf->data=5B0=5D =7C=3D CAN_ERR_LOSTARB_UNSPEC;
> > +	=7D
> > +
> > +	netif_receive_skb(skb);
> > +
> > +	return 1;
> > +=7D
> > +
> >  static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstat=
us,
> >  				   u32 psr)
> >  =7B
> > =40=40 -792,6 +825,11 =40=40 static int m_can_handle_bus_errors(struct
> net_device *dev, u32 irqstatus,
> >  	    is_lec_err(psr))
> >  		work_done +=3D m_can_handle_lec_err(dev, psr & LEC_UNUSED);
> >
> > +	/* handle protocol errors in arbitration phase */
> > +	if ((priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
> > +	    is_protocol_err(irqstatus))
> > +		work_done +=3D m_can_handle_protocol_error(dev, irqstatus);
> > +
> >  	/* other unproccessed error interrupts */
> >  	m_can_handle_other_err(dev, irqstatus);
> >
> >
>=20
> Marc
>=20
> --
> Pengutronix e.K.                  =7C Marc Kleine-Budde           =7C
> Industrial Linux Solutions        =7C Phone: +49-231-2826-924     =7C
> Vertretung West/Dortmund          =7C Fax:   +49-5121-206917-5555 =7C
> Amtsgericht Hildesheim, HRA 2686  =7C http://www.pengutronix.de   =7C


