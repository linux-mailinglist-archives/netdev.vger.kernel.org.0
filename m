Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C073F0EA7
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 07:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbfKFGDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 01:03:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42692 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbfKFGD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 01:03:29 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20191106060326epoutp040e5930d6d3c8cf7f450ea33d161c2c60~UfYtGX2gg1132611326epoutp04b
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 06:03:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20191106060326epoutp040e5930d6d3c8cf7f450ea33d161c2c60~UfYtGX2gg1132611326epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1573020207;
        bh=Y0IhGjF1CLJv+DICYRimtbI6ElvDELr4R6qKhTfwWok=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ublOP49Xy/LYBmnYMbrk0sAxdTDo6Xvar+AyFiyrqg/yYjX4lVUUVArxx+hEZuzei
         QYgFX1PGQixyx1rByljTBGt+Kt/9RYXc3vzH6SMF6d7Q4eJKODcnJY/+IjWn7Xc7/6
         F0VmnmEGsd/lzl02QidmldWR7cMX0V+toFqi/+ws=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191106060325epcas5p1a0d7c3cd855093aa263766321910d70f~UfYsIXZoZ1750317503epcas5p1L;
        Wed,  6 Nov 2019 06:03:25 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.3E.48302.D2262CD5; Wed,  6 Nov 2019 15:03:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20191106060324epcas5p3d21a76cf2761b0180e98315c75284fe1~UfYrPW6TF0190401904epcas5p3A;
        Wed,  6 Nov 2019 06:03:24 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191106060324epsmtrp1f465960ce844321f3d25fd74577bcaf9~UfYrOhOct1765417654epsmtrp1G;
        Wed,  6 Nov 2019 06:03:24 +0000 (GMT)
X-AuditID: b6c32a4a-327ff7000001bcae-71-5dc2622d7939
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.9B.25663.C2262CD5; Wed,  6 Nov 2019 15:03:24 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.84.17]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191106060323epsmtip19c707ac4959bc96c17a4c4400de31d3a~UfYpfUDWj2995729957epsmtip1k;
        Wed,  6 Nov 2019 06:03:22 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>
Cc:     <davem@davemloft.net>, <eugen.hristev@microchip.com>,
        <ludovic.desroches@microchip.com>, <pankaj.dubey@samsung.com>,
        <rcsekar@samsung.com>, "'Sriram Dash'" <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: 
Subject: RE: [PATCH v3] can: m_can: add support for one shot mode
Date:   Wed, 6 Nov 2019 11:33:21 +0530
Message-ID: <01dc01d59467$e6886b20$b3994160$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHwFvFf7BLTdmyWN921EOIqnqBEoQIzkbGZpyRmlFCAEp3M8A==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7bCmhq5u0qFYg6YmM4s551tYLA78OM5i
        ser7VGaLy7vmsFm8WHud1WL9oiksFscWiFks2vqF3WLWhR2sFjfWs1ssvbeT1YHbY8vKm0we
        Hy/dZvS482Mpo0f/XwOPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyujrmsBYcFW6Yt6GNsYG
        xs+iXYycHBICJhL7n65l72Lk4hAS2M0o0fP1MCOE84lRYt3BZywQzjdGiQ/ff7LDtHQ2NUNV
        7WWU+L7wECuE85pRYsmGHkaQKjYBfYkpTX9ZQGwRAV2JH5vmgXUwC8xgklh7bAVTFyMHB6cA
        r8SEf9YgNcICjhIvF79mArFZBFQkll2cB2bzClhK/Fs0hwXCFpQ4OfMJmM0soC2xbOFrZoiL
        FCR+Pl3GCrHLSeJB0xRWiBpxiZdHj4A9JyHQzi7xat9UVogGF4kTX06xQNjCEq+Ob4F6TUri
        ZX8blJ0tsXB3PwvInRICFRJtM4QhwvYSB67MAQszC2hKrN+lD7GKT6L39xMmiGpeiY42IYhq
        NYmpT98xQtgyEncebWaDsD0kPmw7wTqBUXEWksdmIXlsFpIHZiEsW8DIsopRMrWgODc9tdi0
        wCgvtVyvODG3uDQvXS85P3cTIzhlaXntYFx2zucQowAHoxIPL0P5wVgh1sSy4srcQ4wSHMxK
        IrwxfUAh3pTEyqrUovz4otKc1OJDjNIcLErivJNYr8YICaQnlqRmp6YWpBbBZJk4OKUaGKX8
        b/x5cvGxlU6XguHpwB/zL6pN2Zl//0NRpcjX4hNfDwc3bX18a7q1ePi1+ocP7doLdP7eMJdn
        TojVPOXdfI/poUVY82yR+x94mu6JRMbn+k+YYDtN9He2cXvRNffUXwefXTwZP7nL/uLZ6vO+
        0vE51WHfU9RdHp2Jt028fSHRX18l9eSK40osxRmJhlrMRcWJAMYIjKdVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnK5O0qFYgzl3TS3mnG9hsTjw4ziL
        xarvU5ktLu+aw2bxYu11Vov1i6awWBxbIGaxaOsXdotZF3awWtxYz26x9N5OVgdujy0rbzJ5
        fLx0m9Hjzo+ljB79fw08+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PH9M2MBXelKq5suc7Y
        wPhdpIuRk0NCwESis6mZEcQWEtjNKLGgT6eLkQMoLiOx+HM1RImwxMp/z9m7GLmASl4ySsyY
        +48JJMEmoC8xpekvC4gtAmQvnNTIBFLELLCASaJ50mpWiI7ZjBLLf25mB5nKKcArMeGfNUiD
        sICjxMvFr8EGsQioSCy7OA/M5hWwlPi3aA4LhC0ocXLmEzCbWUBbovdhKyOMvWzha2aI6xQk
        fj5dxgpxhJPEg6YprBA14hIvjx5hn8AoPAvJqFlIRs1CMmoWkpYFjCyrGCVTC4pz03OLDQuM
        8lLL9YoTc4tL89L1kvNzNzGCI09LawfjiRPxhxgFOBiVeHgZyg/GCrEmlhVX5h5ilOBgVhLh
        jekDCvGmJFZWpRblxxeV5qQWH2KU5mBREueVzz8WKSSQnliSmp2aWpBaBJNl4uCUamCMn2X7
        KrWsSU3e3qZhUbV4vnXO094Ac6bFfkGLn7nHy78XbUy0+6Fc879ozf3gDYxWJULRXO5ZCoce
        X6gRn+z1/oSb560G7/Xb+ioml4Y16OsV61w993vfrmOvinWYOe9Z5+cGMX86YCqgFiqvuZC5
        pHNPT9FBz3Pve+RedVVkeoU4sfWZKrEUZyQaajEXFScCALTyrJm4AgAA
X-CMS-MailID: 20191106060324epcas5p3d21a76cf2761b0180e98315c75284fe1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60
References: <CGME20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60@epcas5p2.samsung.com>
        <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com> 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle Ping=21

> From: pankj.sharma <pankj.sharma=40samsung.com>
> Subject: RE: =5BPATCH v3=5D can: m_can: add support for one shot mode
>=20
> Gentle Ping=21
>=20
> > From: Pankaj Sharma <pankj.sharma=40samsung.com>
> > Subject: =5BPATCH v3=5D can: m_can: add support for one shot mode
> >
> > According to the CAN Specification (see ISO 11898-1:2015, 8.3.4
> > Recovery Management), the M_CAN provides means for automatic
> > retransmission of frames that have lost arbitration or that have been
> > disturbed by errors during transmission. By default automatic retransmi=
ssion is
> enabled.
> >
> > The Bosch MCAN controller has support for disabling automatic retransmi=
ssion.
> >
> > To support time-triggered communication as described in ISO
> > 11898-1:2015, chapter 9.2, the automatic retransmission may be disabled=
 via
> CCCR.DAR.
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
> > *dev)
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
> > *dev)
> >  	=7D else =7B
> >  	/* Version 3.1.x or 3.2.x */
> >  		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C CCCR_BRSE =7C CCCR_FDOE
> > =7C
> > -			  CCCR_NISO);
> > +			  CCCR_NISO =7C CCCR_DAR);
> >
> >  		/* Only 3.2.x has NISO Bit implemented */
> >  		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO) =40=40 -
> > 1165,6 +1166,10 =40=40 static void m_can_chip_config(struct net_device =
*dev)
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
> > int m_can_dev_setup(struct m_can_classdev
> > *m_can_dev)
> >  	m_can_dev->can.ctrlmode_supported =3D CAN_CTRLMODE_LOOPBACK =7C
> >  					CAN_CTRLMODE_LISTENONLY =7C
> >  					CAN_CTRLMODE_BERR_REPORTING =7C
> > -					CAN_CTRLMODE_FD;
> > +					CAN_CTRLMODE_FD =7C
> > +					CAN_CTRLMODE_ONE_SHOT;
> >
> >  	/* Set properties depending on M_CAN version */
> >  	switch (m_can_dev->version) =7B
> > --
> > 2.17.1


