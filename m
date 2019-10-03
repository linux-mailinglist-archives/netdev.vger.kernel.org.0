Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE6C9708
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 05:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfJCDrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 23:47:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52021 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbfJCDrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 23:47:40 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191003034737epoutp01848ea35e95629bfd29feecb2075aa9d0~KBmaZUlQ31559315593epoutp01Q
        for <netdev@vger.kernel.org>; Thu,  3 Oct 2019 03:47:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191003034737epoutp01848ea35e95629bfd29feecb2075aa9d0~KBmaZUlQ31559315593epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1570074457;
        bh=tTh2NtH07enJ+dDervgN540zaAt+pL+NURH7Sj9WmCU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=kJLy8X3J5uWkRgpaTn17TbQlUeddl9ym/f/tLa6A+iESYb+YRiKG+IS0954pNPkHt
         GU5TzKRB/C5nFxSkymHDBxCeEMPeuV+g5kLGUL2iHTHP3crluzMiUHl7YhAExMv1Km
         YLhQ7Cujee+blVtEdZwAqOtm4thjqskwa2ertVmM=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191003034736epcas5p228d6b0d2bcaa67e3b28ad5f31da49aac~KBmZJAK7C1708017080epcas5p2L;
        Thu,  3 Oct 2019 03:47:36 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        36.01.04647.85F659D5; Thu,  3 Oct 2019 12:47:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20191003034736epcas5p318b4c193365b47531868fc7808a92e5a~KBmYvnHxp2209022090epcas5p3L;
        Thu,  3 Oct 2019 03:47:36 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191003034736epsmtrp1fb0ac8c9cbff68c06efeeee35edd55a6~KBmYu2pEs1111611116epsmtrp1E;
        Thu,  3 Oct 2019 03:47:36 +0000 (GMT)
X-AuditID: b6c32a49-72bff70000001227-fc-5d956f580100
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.56.03889.75F659D5; Thu,  3 Oct 2019 12:47:35 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.85.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191003034734epsmtip198aa7d5ebc91b1db3ea302bba1d9652b~KBmXDqebo2519925199epsmtip1K;
        Thu,  3 Oct 2019 03:47:34 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <eugen.hristev@microchip.com>, <ludovic.desroches@microchip.com>,
        <pankaj.dubey@samsung.com>, <rcsekar@samsung.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>
In-Reply-To: <1569411904-6319-1-git-send-email-pankj.sharma@samsung.com>
Subject: RE: [PATCH] can: m_can: add support for one shot mode
Date:   Thu, 3 Oct 2019 09:17:32 +0530
Message-ID: <010501d5799d$4b372830$e1a57890$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK+j4JJ4HkhOxWJfJCfQUyc5gk6xQFleCA9pWrvZjA=
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsWy7bCmlm5E/tRYg+9NkhZzzrewWBz4cZzF
        YtX3qcwWl3fNYbN4sfY6q8X6RVNYLI4tELNYtPULu8WsCztYLW6sZ7dYem8nqwO3x5aVN5k8
        Pl66zehx58dSRo/+vwYefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlXH/znSWgpsSFT1vfrA0
        MLaLdDFyckgImEj8fXSPtYuRi0NIYDejxJLLPcwQzidGic4fsxlBqoQEvjFKTF6kA9Ox+PBm
        qI69jBKLb19hg3BeM0r0bfvKBlLFJqAvMaXpLwuILSIQLXFj9wWwscwCrxglfu87wQqS4BTw
        kPh99DQ7iC0sYCcx+cMEsDiLgIrEyy03wWxeAUuJ/mW7oWxBiZMzn4ANZRbQlli28DUzxEkK
        Ej+fLmOFWGYl0XL+ODtEjbjEy6NH2EEWSwh0s0tsOXiJFaLBRWLLvx9MELawxKvjW9ghbCmJ
        l/1tUHa2xMLd/UDLOIDsCom2GcIQYXuJA1fmgIWZBTQl1u/Sh1jFJ9H7+wkTRDWvREebEES1
        msTUp+8YIWwZiTuPNrNBlHhIHLpfOIFRcRaSv2Yh+WsWkvtnIexawMiyilEytaA4Nz212LTA
        MC+1XK84Mbe4NC9dLzk/dxMjOGFpee5gnHXO5xCjAAejEg/vjHtTYoVYE8uKK3MPMUpwMCuJ
        8F5aDxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOO4n1aoyQQHpiSWp2ampBahFMlomDU6qBUbF2
        3bl/50PSuI57P/+afPyofGy5jbjTkaXmTx5byy7rf5m5LdEvL+hD5rNNguqLvIpZZt5z3/rL
        aOXb+7Fv3CdkuXmUqFYfeLL61526e5/uOU65wmls8tMwOWnP5u1MmQ/e1zndqc6OEWJQsjzM
        Lvjhxkup9DU3mRK++XnfPspvL5azVyvzmhJLcUaioRZzUXEiAJkcHKdUAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCSnG54/tRYgz0fzC3mnG9hsTjw4ziL
        xarvU5ktLu+aw2bxYu11Vov1i6awWBxbIGaxaOsXdotZF3awWtxYz26x9N5OVgdujy0rbzJ5
        fLx0m9Hjzo+ljB79fw08+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK2NL+z/WghfiFf+XfWFr
        YJwi3MXIySEhYCKx+PBm1i5GLg4hgd2MEo37XzJ3MXIAJWQkFn+uhqgRllj57zk7RM1LRol1
        N5axgiTYBPQlpjT9ZQGxRQRiJToeN7CB2MwCnxglVs30hGiYySixe/1/ZpAEp4CHxO+jp9lB
        bGEBO4nJHyaADWIRUJF4ueUmmM0rYCnRv2w3lC0ocXLmExaIodoSvQ9bGWHsZQtfM0NcpyDx
        8ynEQSICVhIt54+zQ9SIS7w8eoR9AqPwLCSjZiEZNQvJqFlIWhYwsqxilEwtKM5Nzy02LDDK
        Sy3XK07MLS7NS9dLzs/dxAiOPS2tHYwnTsQfYhTgYFTi4Z1xb0qsEGtiWXFl7iFGCQ5mJRHe
        S+uBQrwpiZVVqUX58UWlOanFhxilOViUxHnl849FCgmkJ5akZqemFqQWwWSZODilGhitFu68
        vaBfyjLYyLi5prIg3zpORuTySht1Nr6nOrf2Wu+bcESx7WSL3cxn/gZCjZNXLN05P0t0U3ia
        Zk75kx2q02YvSXY49mJnzYOLP78zvpFPaHia7r6g9KiN89qW7W+tvG5OuLVF7ICKcZZTxzmx
        2E5DGyWZfdPs35bvdq7duHpLf3l0cqoSS3FGoqEWc1FxIgCBFn/ruQIAAA==
X-CMS-MailID: 20191003034736epcas5p318b4c193365b47531868fc7808a92e5a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758
References: <CGME20190925114609epcas5p305e259619c7fe8cdc75d9fd27f34e758@epcas5p3.samsung.com>
        <1569411904-6319-1-git-send-email-pankj.sharma@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle Ping

> -----Original Message-----
> From: Pankaj Sharma <pankj.sharma=40samsung.com>
> Subject: =5BPATCH=5D can: m_can: add support for one shot mode
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
>  drivers/net/can/m_can/m_can.c =7C 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.=
c
> index deb274a19ba0..e7165404ba8a 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> =40=40 -150,6 +150,7 =40=40 enum m_can_mram_cfg =7B
>  =23define CCCR_CME_CANFD_BRS	0x2
>  =23define CCCR_TXP		BIT(14)
>  =23define CCCR_TEST		BIT(7)
> +=23define CCCR_DAR		BIT(6)
>  =23define CCCR_MON		BIT(5)
>  =23define CCCR_CSR		BIT(4)
>  =23define CCCR_CSA		BIT(3)
> =40=40 -1123,7 +1124,7 =40=40 static void m_can_chip_config(struct net_de=
vice
> *dev)
>  	if (priv->version =3D=3D 30) =7B
>  	/* Version 3.0.x */
>=20
> -		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C
> +		cccr &=3D =7E(CCCR_TEST =7C CCCR_MON =7C CCCR_DAR =7C
>  			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) =7C
>  			(CCCR_CME_MASK << CCCR_CME_SHIFT));
>=20
> =40=40 -1133,7 +1134,7 =40=40 static void m_can_chip_config(struct net_de=
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
>  		if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO) =40=40 -
> 1153,6 +1154,10 =40=40 static void m_can_chip_config(struct net_device *d=
ev)
>  	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
>  		cccr =7C=3D CCCR_MON;
>=20
> +	/* Disable Auto Retransmission (all versions) */
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
> +		cccr =7C=3D CCCR_DAR;
> +
>  	/* Write config */
>  	m_can_write(priv, M_CAN_CCCR, cccr);
>  	m_can_write(priv, M_CAN_TEST, test);
> =40=40 -1291,7 +1296,8 =40=40 static int m_can_dev_setup(struct platform_=
device
> *pdev, struct net_device *dev,
>  	priv->can.ctrlmode_supported =3D CAN_CTRLMODE_LOOPBACK =7C
>  					CAN_CTRLMODE_LISTENONLY =7C
>  					CAN_CTRLMODE_BERR_REPORTING =7C
> -					CAN_CTRLMODE_FD;
> +					CAN_CTRLMODE_FD =7C
> +					CAN_CTRLMODE_ONE_SHOT;
>=20
>  	/* Set properties depending on M_CAN version */
>  	switch (priv->version) =7B
> --
> 2.17.1


