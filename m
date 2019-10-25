Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABFBE47A5
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438994AbfJYJoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:44:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59712 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438927AbfJYJoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:44:05 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20191025094401epoutp022ecf614a7253f585c128e178722afd5f~Q2p3rF_fi0765507655epoutp02v
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 09:44:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20191025094401epoutp022ecf614a7253f585c128e178722afd5f~Q2p3rF_fi0765507655epoutp02v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571996641;
        bh=SflvnjW4Hh4WJ/SqApbBnruL04/yjefm1zQBjhXAOmU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=vHNoBs89rTXi+zzPKzpRgP/0Ph5V6DQX5h8HzyMcbUMWxNwMGjHHwBMhLZmuAY9W/
         R7F0epGqX6WTUul/onFr1vhRMq2r3ZokeTFSQWkQwT1rWVyh9OJ7Y3QdvxSIGKsaK6
         sdIYv32MMZx6g0zQYg+Sdkzt7ybaXUjChDtI+pxo=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191025094400epcas5p12e59c789be2e198f5ffbf68d28757bfd~Q2p24QzKO1693016930epcas5p1s;
        Fri, 25 Oct 2019 09:44:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.21.20293.0E3C2BD5; Fri, 25 Oct 2019 18:44:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20191025094400epcas5p37941a903e7ecd986dd4ecd30e895e8ba~Q2p2WogFY3186531865epcas5p3W;
        Fri, 25 Oct 2019 09:44:00 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191025094400epsmtrp223059aaa6c14b3c551f0c751e08d14bf~Q2p2Rg74T0355203552epsmtrp2H;
        Fri, 25 Oct 2019 09:44:00 +0000 (GMT)
X-AuditID: b6c32a49-ffbff70000014f45-e0-5db2c3e0345e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.9A.25663.0E3C2BD5; Fri, 25 Oct 2019 18:44:00 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.84.17]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191025094358epsmtip174f6eb416823f88cae126a2189863d57~Q2p0tMbdX2875628756epsmtip1V;
        Fri, 25 Oct 2019 09:43:58 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wg@grandegger.com>,
        <mkl@pengutronix.de>
Cc:     <davem@davemloft.net>, <eugen.hristev@microchip.com>,
        <ludovic.desroches@microchip.com>, <pankaj.dubey@samsung.com>,
        <rcsekar@samsung.com>, "'Sriram Dash'" <sriram.dash@samsung.com>
In-Reply-To: <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com>
Subject: RE: [PATCH v3] can: m_can: add support for one shot mode
Date:   Fri, 25 Oct 2019 15:13:57 +0530
Message-ID: <000001d58b18$ba756770$2f603650$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHwFvFf7BLTdmyWN921EOIqnqBEoQIzkbGZpyRmlFA=
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHeXbv3a6zxW1bebQIGyRp+DJQuMnIAsEZfoj6Fkld9PqCbs5d
        ndqHkoiZii5MKaeFL6gkiLrmO+J8rzANS8xcTkRBE7TUdBJGbneS337nf/7n+Z8DD4lJRwg/
        MlWbxeq1TLpCKMY7hwMvBS8OW+LDHPXhdPXUE5y2OcdxunmvAqM/91YL6dWWWYJurSvH6bGa
        M3Rdx46INn/qJuivrSK6YaGHuOattr6ZE6h/Tc8jtd3ZgNSmgzB1qbUZqbct528K74hViWx6
        qoHVh169L04p6KzFdW2+ud0lpcJ8NCovQl4kUOGwOViFFSExKaX6EBQ6nEK+2EIwub8j4otd
        BI7ZacHRiGnA6Wn0I2gos3vm1xGsOYpxl0tIhUL54wPc1ZBTRgRzS4PuAnON/HZMYC6XFxUL
        PXsLIhfLqOuwVr/uzsCpizA/Y3a/JKGuQOWLUYznU/C+ctmtY9RlaKxdx/id/GF/pZFwsZyK
        hIMOB+I9PrA2OuLeFahiEfwtmPEcEQ2FRYUelsGPcauIZz/Y3ugX8pwGtX2mwzDykHPB+FLG
        y1Fg+1LtljEqEFp7Q/mok1DyZ1nAuyXw1Cjl3QFQsbKBeD4H9qW3nsfV8LPzHfEMXTAfO8x8
        7DDzsQPM/8NqEN6MfFkdp0lmuQidUsvmhHCMhsvWJockZGgsyP23gmK7kXkybghRJFKckKya
        2uOlBGPg8jRDCEhMIZf0BRxKkkQm7wGrz7inz05nuSF0lsQVPpIyYuaulEpmstg0ltWx+qOu
        gPTyy0e6qLicBKt8JyboBn17oHGqoctSKDNV1RgjA1LqJp5Xnl5VFUy0vZrZzdJtN5WNlhts
        eR8HjbeS+qcX7R9W25u+aRMN/gyoQqaSQjcfKjOTxaqtFsF3JsfW5SONUTyyBQSOme0q60JE
        5mxfmVKZHmxv3O0O8pa/HtyONo4tKXAuhVEGYXqO+QcGaD8/VwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCSnO6Dw5tiDZo38VjMOd/CYnHgx3EW
        i1XfpzJbXN41h83ixdrrrBbrF01hsTi2QMxi0dYv7BazLuxgtbixnt1i6b2drA7cHltW3mTy
        +HjpNqPHnR9LGT36/xp49G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aJb22MBbskKuadsGhg
        PC/cxcjJISFgItG//wd7FyMXh5DAbkaJh/+nMHYxcgAlZCQWf66GqBGWWPnvOVTNS0aJll/f
        2UASbAL6ElOa/rKA2CICPYwSj28GgRQxCxxmlFh04TMrRMcsRokFHcfAOjgFPCV2fr/HDmIL
        CzhKvFz8mgnEZhFQlbh9dRbYJF4BS4mZ048yQ9iCEidnPgGLMwtoSzy9+RTOXrbwNTPEeQoS
        P58uY4W4wkri79b7jBA14hIvjx5hn8AoPAvJqFlIRs1CMmoWkpYFjCyrGCVTC4pz03OLDQuM
        8lLL9YoTc4tL89L1kvNzNzGCY09LawfjiRPxhxgFOBiVeHhf9G+MFWJNLCuuzD3EKMHBrCTC
        u1sNKMSbklhZlVqUH19UmpNafIhRmoNFSZxXPv9YpJBAemJJanZqakFqEUyWiYNTqoExUn7z
        E5W1HybqV821jbZO29j1Q7+h7FiqauJVmw1xS5zZxf8aB9TJfNLIM+R6NpVR4dVzb/s3MsfW
        TfBr7F9fOG321OOv1qWFZDy+0NzbKWdzuDDyQ9eEb08fT/753PtQrbFxVeP1d+x5ir91KstW
        zXyjfcCwu/YBV41IINeBYMntmTX3Qw8qsRRnJBpqMRcVJwIA2JXoDrkCAAA=
X-CMS-MailID: 20191025094400epcas5p37941a903e7ecd986dd4ecd30e895e8ba
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

> From: Pankaj Sharma <pankj.sharma=40samsung.com>
> Subject: =5BPATCH v3=5D can: m_can: add support for one shot mode
>=20
> According to the CAN Specification (see ISO 11898-1:2015, 8.3.4 Recovery
> Management), the M_CAN provides means for automatic retransmission of
> frames that have lost arbitration or that have been disturbed by errors d=
uring
> transmission. By default automatic retransmission is enabled.
>=20
> The Bosch MCAN controller has support for disabling automatic retransmiss=
ion.
>=20
> To support time-triggered communication as described in ISO 11898-1:2015,
> chapter 9.2, the automatic retransmission may be disabled via CCCR.DAR.
>=20
> CAN_CTRLMODE_ONE_SHOT is used for disabling automatic retransmission.
>=20
> Signed-off-by: Pankaj Sharma <pankj.sharma=40samsung.com>
> Signed-off-by: Sriram Dash <sriram.dash=40samsung.com>
> ---
>=20
> changes in v3:
> - resolving build errors for net-next branch
>=20
> changes in v2:
> - rebase to net-next
>=20
>  drivers/net/can/m_can/m_can.c =7C 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.=
c
> index 562c8317e3aa..75e7490c4299 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> =40=40 -123,6 +123,7 =40=40 enum m_can_reg =7B
>  =23define CCCR_CME_CANFD_BRS	0x2
>  =23define CCCR_TXP		BIT(14)
>  =23define CCCR_TEST		BIT(7)
> +=23define CCCR_DAR		BIT(6)
>  =23define CCCR_MON		BIT(5)
>  =23define CCCR_CSR		BIT(4)
>  =23define CCCR_CSA		BIT(3)
> =40=40 -1135,7 +1136,7 =40=40 static void m_can_chip_config(struct net_de=
vice
> *dev)
>  	if (cdev->version =3D=3D 30) =7B
>  	/* Version 3.0.x */
>=20
> -		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C
> +		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C CCCR_DAR =7C
>  			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) =7C
>  			(CCCR_CME_MASK << CCCR_CME_SHIFT));
>=20
> =40=40 -1145,7 +1146,7 =40=40 static void m_can_chip_config(struct net_de=
vice
> *dev)
>  	=7D else =7B
>  	/* Version 3.1.x or 3.2.x */
>  		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C CCCR_BRSE =7C CCCR_FDOE
> =7C
> -			  CCCR_NISO);
> +			  CCCR_NISO =7C CCCR_DAR);
>=20
>  		/* Only 3.2.x has NISO Bit implemented */
>  		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO) =40=40 -
> 1165,6 +1166,10 =40=40 static void m_can_chip_config(struct net_device *d=
ev)
>  	if (cdev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
>  		cccr =7C=3D CCCR_MON;
>=20
> +	/* Disable Auto Retransmission (all versions) */
> +	if (cdev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
> +		cccr =7C=3D CCCR_DAR;
> +
>  	/* Write config */
>  	m_can_write(cdev, M_CAN_CCCR, cccr);
>  	m_can_write(cdev, M_CAN_TEST, test);
> =40=40 -1310,7 +1315,8 =40=40 static int m_can_dev_setup(struct m_can_cla=
ssdev
> *m_can_dev)
>  	m_can_dev->can.ctrlmode_supported =3D CAN_CTRLMODE_LOOPBACK =7C
>  					CAN_CTRLMODE_LISTENONLY =7C
>  					CAN_CTRLMODE_BERR_REPORTING =7C
> -					CAN_CTRLMODE_FD;
> +					CAN_CTRLMODE_FD =7C
> +					CAN_CTRLMODE_ONE_SHOT;
>=20
>  	/* Set properties depending on M_CAN version */
>  	switch (m_can_dev->version) =7B
> --
> 2.17.1


