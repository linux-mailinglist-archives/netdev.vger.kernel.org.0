Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DDBFD40B
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKOFVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:21:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17116 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfKOFVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:21:01 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191115052059epoutp01f90b5c34f1947e0cbce6bb1df06684e2~XPnNT88T-0981509815epoutp01i
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 05:20:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191115052059epoutp01f90b5c34f1947e0cbce6bb1df06684e2~XPnNT88T-0981509815epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1573795259;
        bh=2s6MJG+dWgsvZtxFBg4TZIeCR2AfmMSoYt3HmY1lyMY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=cBDirSRUFaQxoD6WDd89bscs2LPuA6rDTPPs0WSZvRS+3YbTU6B20qktnbHLAxYAE
         VYOHdCC5MqZQQ4MEZcJQ9MLylezp7zxDieobjHKK3IY0AiTn6hRg4couSY5U7/GkTD
         C9dPaKheLiB2OfsEKfWGnpWM4GqjexctGHBfmjd8=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191115052059epcas5p15a17370751bca212bb6d227dcb4c17d4~XPnMndHW72461724617epcas5p1j;
        Fri, 15 Nov 2019 05:20:59 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5B.82.20245.AB53ECD5; Fri, 15 Nov 2019 14:20:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191115052058epcas5p42d949eaa247a8f55fd55da61db2b6676~XPnL15ohw1624916249epcas5p4V;
        Fri, 15 Nov 2019 05:20:58 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191115052057epsmtrp2ea1f391f18ee3ad1c456006271439ede~XPnLZg8i00484304843epsmtrp20;
        Fri, 15 Nov 2019 05:20:57 +0000 (GMT)
X-AuditID: b6c32a4b-fb9ff70000014f15-01-5dce35ba49e4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.98.25663.9B53ECD5; Fri, 15 Nov 2019 14:20:57 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.84.17]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191115052056epsmtip24d94ed8a7c35800f5fe695bf349b82ea~XPnJ3FkcQ2430624306epsmtip2E;
        Fri, 15 Nov 2019 05:20:56 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc:     <wg@grandegger.com>, <davem@davemloft.net>,
        <eugen.hristev@microchip.com>, <ludovic.desroches@microchip.com>,
        <pankaj.dubey@samsung.com>, <rcsekar@samsung.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <38ade7ff-0e0c-afe9-a927-17317f0f27b9@pengutronix.de>
Subject: RE: [PATCH v3] can: m_can: add support for one shot mode
Date:   Fri, 15 Nov 2019 10:50:54 +0530
Message-ID: <05f701d59b74$7610ecf0$6232c6d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHwFvFf7BLTdmyWN921EOIqnqBEoQIzkbGZAZnmUhSnOE2GgA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsWy7bCmuu4u03OxBivv2ljMOd/CYnHgx3EW
        i1XfpzJbXN41h83ixdrrrBbrF01hsTi2QMxi0dYv7BazLuxgtbixnt1i6b2drA7cHltW3mTy
        +HjpNqPHnR9LGT36/xp49G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8apl1OZCv6qVJydtICx
        gfGGXBcjJ4eEgInEiuv/WLsYuTiEBHYzSqydNZUNwvnEKPF8w2l2COcbo8SSS9uZYVrOtj6H
        qtrLKHF0ynI2kISQwGtGidczgkBsNgF9iSlNf1lAbBEBPYnfExYxgTQwC6xlkuhf8oUVJMEp
        4CTx7PIisGZhAUeJl4tfAxVxcLAIqEq0PHAACfMKWEr8m/2VGcIWlDg58wnYTGYBbYllC19D
        HaQg8fPpMlaIXU4Sa/52s0LUiEu8PHoE7AMJgX52iVVbHrJCNLhInLi7mB3CFpZ4dXwLlC0l
        8fndXjYIO1ti4e5+FpB7JAQqJNpmCEOE7SUOXJkDFmYW0JRYv0sfYhWfRO/vJ0wQ1bwSHW1C
        ENVqElOfvmOEsGUk7jzaDDXcQ+LDthOsExgVZyF5bBaSx2YheWAWwrIFjCyrGCVTC4pz01OL
        TQuM81LL9YoTc4tL89L1kvNzNzGCE5aW9w7GTed8DjEKcDAq8fBK3DobK8SaWFZcmXuIUYKD
        WUmEd8rbM7FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeSexXo0REkhPLEnNTk0tSC2CyTJxcEo1
        MIa+ZXbkcr3wZNrt9Ivpbz+nLTtyZpniq4Af786Jpu35l3mISWFv6roM69f/Iv5rzaz9NevV
        xcBn+/XeR2aplzayF6wq07iZo7Ci/cEaU7+G86Y/eVmnJ06addtzn0x4U0iwreZOq99fPS51
        vunRTTzenMEXs3Tf0rh/MgffNjI8eizSBkxbhkosxRmJhlrMRcWJAMtaSu5UAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSvO5O03OxBgun6lnMOd/CYnHgx3EW
        i1XfpzJbXN41h83ixdrrrBbrF01hsTi2QMxi0dYv7BazLuxgtbixnt1i6b2drA7cHltW3mTy
        +HjpNqPHnR9LGT36/xp49G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aia2UFexQrpi7Wb2Cc
        LdXFyMkhIWAicbb1OVsXIxeHkMBuRolrc7+wdjFyACVkJBZ/roaoEZZY+e85O4gtJPCSUaJh
        sjKIzSagLzGl6S8LiC0ioCfxe8IiJhCbWWA7k8SOvWUQMy8wSnzsecoIkuAUcJJ4dnkRG4gt
        LOAo8XLxayaQXSwCqhItDxxAwrwClhL/Zn9lhrAFJU7OfMICMVNbovdhKyOMvWzha2aI2xQk
        fj5dxgpxg5PEmr/drBA14hIvjx5hn8AoPAvJqFlIRs1CMmoWkpYFjCyrGCVTC4pz03OLDQuM
        8lLL9YoTc4tL89L1kvNzNzGCY05LawfjiRPxhxgFOBiVeHglbp2NFWJNLCuuzD3EKMHBrCTC
        O+XtmVgh3pTEyqrUovz4otKc1OJDjNIcLErivPL5xyKFBNITS1KzU1MLUotgskwcnFINjEt0
        FjT++zd1a/bp0Ka7fPa6719Mtrtz5sbUVx+6ptwN1HkjIrXhTo/V/pDm+1VS57IOunSuFdhs
        wVDkcdL3e8/pDOO9nEzrJ+5QX+9z/sLlpVPny9+4Fh7Y3Po05hCTgFid47zJwauZPyjcctmQ
        p8NfdUb0dvqxM7Pe9hheCp217Kd/7dyFDFFKLMUZiYZazEXFiQATU5t2tQIAAA==
X-CMS-MailID: 20191115052058epcas5p42d949eaa247a8f55fd55da61db2b6676
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60
References: <CGME20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60@epcas5p2.samsung.com>
        <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com>
        <38ade7ff-0e0c-afe9-a927-17317f0f27b9@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Marc Kleine-Budde <mkl=40pengutronix.de>
> Subject: Re: =5BPATCH v3=5D can: m_can: add support for one shot mode
>=20
> On 10/21/19 2:04 PM, Pankaj Sharma wrote:
> > According to the CAN Specification (see ISO 11898-1:2015, 8.3.4
> > Recovery Management), the M_CAN provides means for automatic
> > retransmission of frames that have lost arbitration or that have been
> > disturbed by errors during transmission. By default automatic
> > retransmission is enabled.
> >
> > The Bosch MCAN controller has support for disabling automatic
> > retransmission.
> >
> > To support time-triggered communication as described in ISO
> > 11898-1:2015, chapter 9.2, the automatic retransmission may be
> > disabled via CCCR.DAR.
> >
> > CAN_CTRLMODE_ONE_SHOT is used for disabling automatic retransmission.
> >
> > Signed-off-by: Pankaj Sharma <pankj.sharma=40samsung.com>
> > Signed-off-by: Sriram Dash <sriram.dash=40samsung.com>
> > ---
> >
> > changes in v3:
> > - resolving build errors for net-next branch
> >
> > changes in v2:
> > - rebase to net-next
> >
> >  drivers/net/can/m_can/m_can.c =7C 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/can/m_can/m_can.c
> > b/drivers/net/can/m_can/m_can.c index 562c8317e3aa..75e7490c4299
> > 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > =40=40 -123,6 +123,7 =40=40 enum m_can_reg =7B
> >  =23define CCCR_CME_CANFD_BRS	0x2
> >  =23define CCCR_TXP		BIT(14)
> >  =23define CCCR_TEST		BIT(7)
> > +=23define CCCR_DAR		BIT(6)
> >  =23define CCCR_MON		BIT(5)
> >  =23define CCCR_CSR		BIT(4)
> >  =23define CCCR_CSA		BIT(3)
> > =40=40 -1135,7 +1136,7 =40=40 static void m_can_chip_config(struct net_=
device
> *dev)
> >  	if (cdev->version =3D=3D 30) =7B
> >  	/* Version 3.0.x */
> >
> > -		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C
> > +		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C CCCR_DAR =7C
> >  			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) =7C
> >  			(CCCR_CME_MASK << CCCR_CME_SHIFT));
> >
> > =40=40 -1145,7 +1146,7 =40=40 static void m_can_chip_config(struct net_=
device
> *dev)
> >  	=7D else =7B
> >  	/* Version 3.1.x or 3.2.x */
> >  		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C CCCR_BRSE =7C CCCR_FDOE
> =7C
> > -			  CCCR_NISO);
> > +			  CCCR_NISO =7C CCCR_DAR);
> >
> >  		/* Only 3.2.x has NISO Bit implemented */
> >  		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO) =40=40 -
> 1165,6
> > +1166,10 =40=40 static void m_can_chip_config(struct net_device *dev)
> >  	if (cdev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> >  		cccr =7C=3D CCCR_MON;
> >
> > +	/* Disable Auto Retransmission (all versions) */
> > +	if (cdev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
> > +		cccr =7C=3D CCCR_DAR;
> > +
> >  	/* Write config */
> >  	m_can_write(cdev, M_CAN_CCCR, cccr);
> >  	m_can_write(cdev, M_CAN_TEST, test); =40=40 -1310,7 +1315,8 =40=40
> static
> > int m_can_dev_setup(struct m_can_classdev *m_can_dev)
> >  	m_can_dev->can.ctrlmode_supported =3D CAN_CTRLMODE_LOOPBACK =7C
> >  					CAN_CTRLMODE_LISTENONLY =7C
> >  					CAN_CTRLMODE_BERR_REPORTING =7C
> > -					CAN_CTRLMODE_FD;
> > +					CAN_CTRLMODE_FD =7C
> > +					CAN_CTRLMODE_ONE_SHOT;
> >
> >  	/* Set properties depending on M_CAN version */
> >  	switch (m_can_dev->version) =7B
>=20
> What happens if you have called netif_stop_queue() and the controller was=
 not
> able to send a single frame?
>=20
> What happens to the echo_skb, if the controller was not able to send a fr=
ame?

We are aware of this issue. For this the tx frame errors are to be first ha=
ndled and=20
the error stats should be updated.
Currently in MCAN code Tx errors aren=E2=80=99t=20being=20handled.=20=0D=0A=
We=20are=20working=20on=20this=20issue=20to=20handle=20these=20errors.=20Ar=
bitration=20error=20being=20the=20first=20=0D=0Apatch=20which=20is=20alread=
y=20posted.=20Very=20soon=20will=20be=20posting=20the=20patches=20for=20tx=
=20error=20handling.=20=0D=0A=0D=0A>=20=0D=0A>=20Marc=0D=0A>=20=0D=0A>=20--=
=0D=0A>=20Pengutronix=20e.K.=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=7C=20Marc=20Kleine-Budde=20=20=20=20=20=20=20=20=20=20=20=7C=0D=
=0A>=20Industrial=20Linux=20Solutions=20=20=20=20=20=20=20=20=7C=20Phone:=
=20+49-231-2826-924=20=20=20=20=20=7C=0D=0A>=20Vertretung=20West/Dortmund=
=20=20=20=20=20=20=20=20=20=20=7C=20Fax:=20=20=20+49-5121-206917-5555=20=7C=
=0D=0A>=20Amtsgericht=20Hildesheim,=20HRA=202686=20=20=7C=0D=0A>=20https://=
protect2.fireeye.com/url?k=3De09921cf-bd02ddac-e098aa80-=0D=0A>=200cc47a31c=
dbc-65578a3e12ca03be&u=3Dhttp://www.pengutronix.de/=20=20=20=7C=0D=0A=0D=0A=
=0D=0A
