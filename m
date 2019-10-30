Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35CDE962A
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 06:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfJ3Fzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 01:55:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19704 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfJ3Fzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 01:55:45 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20191030055542epoutp04e6a364701eedb19fe7bc58e8c8f7b0be~SVw8SWfkM2950429504epoutp041
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 05:55:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20191030055542epoutp04e6a364701eedb19fe7bc58e8c8f7b0be~SVw8SWfkM2950429504epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1572414942;
        bh=v9h7l+9XbROld5p1fEnR71nPrxXtqtEH/w4luax7RBY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=dnkHMiCiXmr6QoyNDEVX6RPjc3hhoLLNapYiV6B0tes6XvVN7gxmDYIqZb5YNLS1N
         AkDGG/ey3TOw5RqbO+CIKeRlZ+16FvGGDx8sb8sEsX2kguEcLa41drgPL/mmlxpNty
         8ShkEWR79IPOtuP0ALW1RuZ7wnB/+aL/JOz6/8ro=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191030055541epcas5p248f15823c998f81471f7a93d070e9888~SVw7nc8go1928219282epcas5p2g;
        Wed, 30 Oct 2019 05:55:41 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.7F.48302.DD529BD5; Wed, 30 Oct 2019 14:55:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20191030055540epcas5p10e67b586ff6203f7f291bf0cae729113~SVw6xtQto2223522235epcas5p1c;
        Wed, 30 Oct 2019 05:55:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191030055540epsmtrp16f2629896b10f187f42259b68e167fe0~SVw6wwr5K0745807458epsmtrp1k;
        Wed, 30 Oct 2019 05:55:40 +0000 (GMT)
X-AuditID: b6c32a4a-327ff7000001bcae-7e-5db925ddeb80
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.BE.24756.CD529BD5; Wed, 30 Oct 2019 14:55:40 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.84.17]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191030055538epsmtip18de7aefd13579f364ac8a8ec4cc9843c~SVw46mPSr1365013650epsmtip1Y;
        Wed, 30 Oct 2019 05:55:38 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <wg@grandegger.com>, <davem@davemloft.net>,
        <eugen.hristev@microchip.com>, <ludovic.desroches@microchip.com>,
        <pankaj.dubey@samsung.com>, <rcsekar@samsung.com>,
        <jhofstee@victronenergy.com>, <simon.horman@netronome.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <89d7b65f-e8cf-9241-5642-ab3446b464a5@pengutronix.de>
Subject: RE: [PATCH v2] can: m_can: add support for handling arbitration
 error
Date:   Wed, 30 Oct 2019 11:25:20 +0530
Message-ID: <00dd01d58ee6$a8ce43d0$fa6acb70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQI3yvUU2phHfNfUXWQjh97goU7vHgHmcqhyAiT9Gy2mjdss4A==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHeXfO2c5Wq9O28tFEamGi4mahdaKoqD4cwg9GRCGKjTyo6VR2
        yjQirURLa4Yl1TCZk4ZN09C55qVldpEw8k5GKl0UtIWV81ZLqO0s8tvvufzf//OHl8RkQ0QA
        mZpxitVlaNKVQgluexYaEjEa3JIQebdVQVf0FOB0x2IXTtd8cxC0ZaEcowdaK4T05IO3BN1g
        uonTL43raFPzrIg29NoJerhFTA83iOh7Yy3EXiljvf9OwPzof4+YkcV7iLlV8hFjSpciGb3V
        ghhXYxBT9vS7KJaMk+xKYtNTs1mdevdxScqwqR5l1QblNC3oUT6qhGIkJoGKgvZbH7BiJCFl
        VBuCsbsuIV/MIDC/NSG+mEcweMkl+icZ73H4Bo8RzOkf+SROBEVF1ZhnS0ip4ebFJdzDCkoF
        7usmgYcxyimA23MKD4upfdD7vd3bl1OxUGQ0eh1wKhieDi94WUrtAKfTgvG8Bl7dGcf5d8LB
        XOXE+Is2wM8JM8H3/WDqxXMR77sPymarCc9xQNWLoKanWsgLDsBv25hPLIcvXVZftACYKi30
        cRpUtZX+NSP/cg4U3pbz7T3QMVjhbWNUKDS0qnnbVXDNPS7gt6VwuVDGb2+G8olpxHMgjHxq
        8h3AgPNrJXEdbTQsC2ZYFsywLIzhv5kR4Rbkz2Zx2mSWi87amsGeUXEaLXc6I1l1IlPbiLyf
        LeygHZnfxHQiikTKldKOUHuCjNBkc7naTgQkplRI+17bEmTSJE3uWVaXmag7nc5ynWg9iSv9
        pGXEULyMStacYtNYNovV/ZsKSHFAProMfYlrHZ2H/OPUHSPnJzJ/zUS3PYlxb2va1Fy8KSRP
        ZT1HChS7uiu/dXPoyP606dUw8EnYfHRSW15QbHy4Jzww2hQvSbwQWXcFum7Mu0ZdtqvBtXk1
        i0H4zoESN25ZOrx9bbvJLg7Un5wzRFi3qqM/rzgmfxKV5MjZWZBd16/EuRTNljBMx2n+AIbc
        RvFoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWy7bCSnO4d1Z2xBnM2SFvMOd/CYnHgx3EW
        ixXv97FarPo+ldni8q45bBYv1l5ntVi/aAqLxbEFYhaLtn5ht5h1YQerxY2dnBY31rNbLL23
        k9WB12PLyptMHh8v3Wb0uPNjKaPH9O6HzB79fw08+rasYvT4vEnOY9LBD+wBHFFcNimpOZll
        qUX6dglcGW//sRYclq14uGIZWwPjNvEuRk4OCQETiSfn9zF2MXJxCAnsZpT4NGcaaxcjB1BC
        RmLx52qIGmGJlf+es0PUvGSUuD7vNRNIgk1AX2JK018WEFtEQE/i94RFTCBFzALfmSTmblnJ
        BtFxgVHi3qoPbCBVnAJOEhc+7AHrFhbwk9izcAMjiM0ioCpx8MZ3dhCbV8BS4vXrVcwQtqDE
        yZlPwDYwC2hLPL35FM5etvA1M8R5ChI/ny5jhYiLS7w8eoQd4iIniUlfFrNOYBSehWTULCSj
        ZiEZNQtJ+wJGllWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMERqqW5g/HykvhDjAIc
        jEo8vAc0d8QKsSaWFVfmHmKU4GBWEuG9eGZbrBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHep3nH
        IoUE0hNLUrNTUwtSi2CyTBycUg2M0642GwuFLDKykC7iFGwQ6MxIiHWQjRHacEZgWuUe9tRl
        9z+sMPryLuDB4pkyd3lfPNyyd8sqZfnXEayrNP8E2ny4vTd5msraJbe1jge5yP7Tkpmx7kZX
        avrEgtI1e434bB/OlWqqd336feYMRUtmszUyGks+B/m5S9yJ2quR2vbhUqLaNLZsJZbijERD
        Leai4kQA0nWDIswCAAA=
X-CMS-MailID: 20191030055540epcas5p10e67b586ff6203f7f291bf0cae729113
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78
References: <CGME20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78@epcas5p3.samsung.com>
        <1571660016-29726-1-git-send-email-pankj.sharma@samsung.com>
        <89d7b65f-e8cf-9241-5642-ab3446b464a5@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Marc Kleine-Budde <mkl=40pengutronix.de>
> Subject: Re: =5BPATCH v2=5D can: m_can: add support for handling arbitrat=
ion error
>=20
> On 10/21/19 2:13 PM, Pankaj Sharma wrote:
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
> >
> > changes in v2:
> > - common m_can_ prefix for is_protocol_err function
> > - handling stats even if the allocation of the skb fails
> > - resolving build errors on net-next branch
> >
> >  drivers/net/can/m_can/m_can.c =7C 37
> > +++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/drivers/net/can/m_can/m_can.c
> > b/drivers/net/can/m_can/m_can.c index 75e7490c4299..a736297a875f
> > 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > =40=40 -778,6 +778,38 =40=40 static inline bool is_lec_err(u32 psr)
> >  	return psr && (psr =21=3D LEC_UNUSED);
> >  =7D
> >
> > +static inline bool m_can_is_protocol_err(u32 irqstatus) =7B
> > +	return irqstatus & IR_ERR_LEC_31X;
> > +=7D
> > +
> > +static int m_can_handle_protocol_error(struct net_device *dev, u32
> > +irqstatus) =7B
> > +	struct net_device_stats *stats =3D &dev->stats;
> > +	struct m_can_classdev *cdev =3D netdev_priv(dev);
> > +	struct can_frame *cf;
> > +	struct sk_buff *skb;
> > +
> > +	/* propagate the error condition to the CAN stack */
> > +	skb =3D alloc_can_err_skb(dev, &cf);
> > +	if (unlikely(=21skb)) =7B
> > +		netdev_dbg(dev, =22allocation of skb failed=5Cn=22);
> > +		stats->tx_errors++;
> > +		return 0;
> > +	=7D
> > +	if (cdev->version >=3D 31 && (irqstatus & IR_PEA)) =7B
> > +		netdev_dbg(dev, =22Protocol error in Arbitration fail=5Cn=22);
> > +		stats->tx_errors++;
> > +		cdev->can.can_stats.arbitration_lost++;
>=20
> If the skb allocation fails, you miss the stats here.

Alright. We shall handle the stats even when skb fails.=20
Shall post in upcoming revision.

>=20
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
> > =40=40 -792,6 +824,11 =40=40 static int m_can_handle_bus_errors(struct
> net_device *dev, u32 irqstatus,
> >  	    is_lec_err(psr))
> >  		work_done +=3D m_can_handle_lec_err(dev, psr & LEC_UNUSED);
> >
> > +	/* handle protocol errors in arbitration phase */
> > +	if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
> > +	    m_can_is_protocol_err(irqstatus))
> > +		work_done +=3D m_can_handle_protocol_error(dev, irqstatus);
> > +
> >  	/* other unproccessed error interrupts */
> >  	m_can_handle_other_err(dev, irqstatus);
>=20
> Marc
>=20
> --
> Pengutronix e.K.                  =7C Marc Kleine-Budde           =7C
> Industrial Linux Solutions        =7C Phone: +49-231-2826-924     =7C
> Vertretung West/Dortmund          =7C Fax:   +49-5121-206917-5555 =7C
> Amtsgericht Hildesheim, HRA 2686  =7C
> https://protect2.fireeye.com/url?k=3Dcb5c4e6130fb99cd.cb5dc52e-
> 7d616d604aa6cbcf&u=3Dhttp://www.pengutronix.de   =7C


