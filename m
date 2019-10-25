Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64854E47A8
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438579AbfJYJoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:44:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59967 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392769AbfJYJoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:44:44 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20191025094442epoutp0244a0ee115beaa300487504f86bc33c62~Q2qd3NBY60896108961epoutp02F
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 09:44:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20191025094442epoutp0244a0ee115beaa300487504f86bc33c62~Q2qd3NBY60896108961epoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1571996682;
        bh=qpeQGHpxGTrmxefBXovAYXXe5I6YU+tTKK2JRPeQ7Ho=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=IC9iJxwhrT/9TAFYrxP7yrAhHKYTmT97JO3LjRwwHMhY0NPM20joDdOP3BUngUlxn
         Saa8NFM4KcXiC3ion3h3ulE50zexfT8+6ajlHiRhgjVWfpLdzYRRzML5Bh4YlPkhLI
         c9z6hqDejSZls7+qL2JUjC7ye1QeeQ/ML5uc/6Os=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191025094442epcas5p2b383af783c4ba04b78dac81bedbacc25~Q2qdPUgiY1583915839epcas5p2C;
        Fri, 25 Oct 2019 09:44:42 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.51.20293.904C2BD5; Fri, 25 Oct 2019 18:44:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20191025094441epcas5p2bb257b84247491740cb08c788848327e~Q2qc_Rog_1583815838epcas5p2B;
        Fri, 25 Oct 2019 09:44:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191025094441epsmtrp1a501d839d33d9aeb9c000b7b9d03aecb~Q2qc3u4jh1550015500epsmtrp1y;
        Fri, 25 Oct 2019 09:44:41 +0000 (GMT)
X-AuditID: b6c32a49-ffbff70000014f45-62-5db2c4098fba
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.F9.24756.904C2BD5; Fri, 25 Oct 2019 18:44:41 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.84.17]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191025094439epsmtip2f78fc60f334b42c73cd3ce41043930ae~Q2qa6z1ty1329513295epsmtip2s;
        Fri, 25 Oct 2019 09:44:39 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wg@grandegger.com>,
        <mkl@pengutronix.de>
Cc:     <davem@davemloft.net>, <eugen.hristev@microchip.com>,
        <ludovic.desroches@microchip.com>, <pankaj.dubey@samsung.com>,
        <rcsekar@samsung.com>, <jhofstee@victronenergy.com>,
        <simon.horman@netronome.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>
In-Reply-To: <1571660016-29726-1-git-send-email-pankj.sharma@samsung.com>
Subject: RE: [PATCH v2] can: m_can: add support for handling arbitration
 error
Date:   Fri, 25 Oct 2019 15:14:38 +0530
Message-ID: <000101d58b18$d3178e70$7946ab50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI3yvUU2phHfNfUXWQjh97goU7vHgHmcqhyppdn9mA=
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7bCmhi7XkU2xBof3M1rMOd/CYnHgx3EW
        ixXv97FarPo+ldni8q45bBYv1l5ntVi/aAqLxbEFYhaLtn5ht5h1YQerxY2dnBY31rNbLL23
        k9WB12PLyptMHh8v3Wb0uPNjKaPH9O6HzB79fw08+rasYvT4vEnOY9LBD+wBHFFcNimpOZll
        qUX6dglcGX+3f2MseCJRMfnoc/YGxpUiXYycHBICJhJXOj+wdTFycQgJ7GaUOH10HjuE84lR
        YsbztcwgVUIC3xgl3mzWgunYfWofVNFeRonpyyexQjivGSXatr9iA6liE9CXmNL0lwUkISLQ
        xihx89FBMIdZ4DfQqMvbWUCqOAU8JRZffM4KYgsLBEi0L1jADmKzCKhKnJ+2BmwSr4ClROPZ
        d6wQtqDEyZlPwHqZBbQlli18zQxxk4LEz6fLwGpEBKwkTr27yghRIy7x8ugRsFslBNaxS3Rs
        ecQE0eAice0OTLOwxKvjW9ghbCmJl/1tUHa2xMLd/UDLOIDsCom2GcIQYXuJA1fmgIWZBTQl
        1u/Sh1jFJ9H7+wkTRDWvREebEES1msTUp+8YIWwZiTuPNrNB2B4Sr9/MY53AqDgLyWOzkDw2
        C8kDsxCWLWBkWcUomVpQnJueWmxaYJiXWq5XnJhbXJqXrpecn7uJEZzatDx3MM4653OIUYCD
        UYmH90X/xlgh1sSy4srcQ4wSHMxKIry71YBCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeSexXo0R
        EkhPLEnNTk0tSC2CyTJxcEo1MB5e+KXoq+OPos5q9gcuHB/vJi29I39MfaK5v//PK996fisv
        t/A0/92v8WFBiFL+5INqurOnbhR7Nldh5c81jsu2lfSHr23PCj8VKzd1GcMpu1srmk1sHKbG
        hars6evUcP9UFtixS8t+Zk1Pn5qR1cKIpg/r+XpmeHXHrmZkTHh34lSsDSuLoxJLcUaioRZz
        UXEiAD7xcgVpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWy7bCSvC7nkU2xBqfvKljMOd/CYnHgx3EW
        ixXv97FarPo+ldni8q45bBYv1l5ntVi/aAqLxbEFYhaLtn5ht5h1YQerxY2dnBY31rNbLL23
        k9WB12PLyptMHh8v3Wb0uPNjKaPH9O6HzB79fw08+rasYvT4vEnOY9LBD+wBHFFcNimpOZll
        qUX6dglcGftW3Gcv6JWo+HZ8BksD4wXhLkZODgkBE4ndp/axdzFycQgJ7GaU6Gq8wtTFyAGU
        kJFY/LkaokZYYuW/51A1LxklFp6cwAaSYBPQl5jS9JcFxBYR6GGUeHwzCKSIWaCZSeL26yOs
        IAkhgVmMEkc6HUFsTgFPicUXn4PFhQX8JPYs3MAIYrMIqEqcn7YGbCivgKVE49l3rBC2oMTJ
        mU/AFjALaEs8vfkUzl628DUzxHUKEj+fLmOFOMJK4tS7q4wQNeISL48eYZ/AKDwLyahZSEbN
        QjJqFpKWBYwsqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgiNUS3MH4+Ul8YcYBTgY
        lXh4X/RvjBViTSwrrsw9xCjBwawkwrtbDSjEm5JYWZValB9fVJqTWnyIUZqDRUmc92nesUgh
        gfTEktTs1NSC1CKYLBMHp1QDY/3zJ59l926q3nn8/HcdUW7hZU/0o94W23UcMDARPF/JUrOn
        Kkhng4XI3Btx/EKvJmbP41p/U/NFUJlCuon3nKuV6wQVFpin/z72N47F+av6mYeHnOb2XHh/
        T3zF7Htvfx5OdTNZ/flJ2/pKJ8E6jsMT7v18t2HJg6OM9jvlZi+M/lI+a/Lv26FKLMUZiYZa
        zEXFiQC1ZnzvzAIAAA==
X-CMS-MailID: 20191025094441epcas5p2bb257b84247491740cb08c788848327e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78
References: <CGME20191021121350epcas5p3313e54a3bc5c8600c52a6db299893f78@epcas5p3.samsung.com>
        <1571660016-29726-1-git-send-email-pankj.sharma@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle Ping=21

> From: Pankaj Sharma <pankj.sharma=40samsung.com>
> Subject: =5BPATCH v2=5D can: m_can: add support for handling arbitration =
error
>=20
> The Bosch MCAN hardware (3.1.0 and above) supports interrupt flag to dete=
ct
> Protocol error in arbitration phase.
>=20
> Transmit error statistics is currently not updated from the MCAN driver.
> Protocol error in arbitration phase is a TX error and the network statist=
ics should
> be updated accordingly.
>=20
> The member =22tx_error=22 of =22struct net_device_stats=22 should be incr=
emented as
> arbitration is a transmit protocol error. Also =22arbitration_lost=22 of =
=22struct
> can_device_stats=22 should be incremented to report arbitration lost.
>=20
> Signed-off-by: Pankaj Sharma <pankj.sharma=40samsung.com>
> Signed-off-by: Sriram Dash <sriram.dash=40samsung.com>
> ---
>=20
> changes in v2:
> - common m_can_ prefix for is_protocol_err function
> - handling stats even if the allocation of the skb fails
> - resolving build errors on net-next branch
>=20
>  drivers/net/can/m_can/m_can.c =7C 37
> +++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.=
c
> index 75e7490c4299..a736297a875f 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> =40=40 -778,6 +778,38 =40=40 static inline bool is_lec_err(u32 psr)
>  	return psr && (psr =21=3D LEC_UNUSED);
>  =7D
>=20
> +static inline bool m_can_is_protocol_err(u32 irqstatus) =7B
> +	return irqstatus & IR_ERR_LEC_31X;
> +=7D
> +
> +static int m_can_handle_protocol_error(struct net_device *dev, u32
> +irqstatus) =7B
> +	struct net_device_stats *stats =3D &dev->stats;
> +	struct m_can_classdev *cdev =3D netdev_priv(dev);
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +
> +	/* propagate the error condition to the CAN stack */
> +	skb =3D alloc_can_err_skb(dev, &cf);
> +	if (unlikely(=21skb)) =7B
> +		netdev_dbg(dev, =22allocation of skb failed=5Cn=22);
> +		stats->tx_errors++;
> +		return 0;
> +	=7D
> +	if (cdev->version >=3D 31 && (irqstatus & IR_PEA)) =7B
> +		netdev_dbg(dev, =22Protocol error in Arbitration fail=5Cn=22);
> +		stats->tx_errors++;
> +		cdev->can.can_stats.arbitration_lost++;
> +		cf->can_id =7C=3D CAN_ERR_LOSTARB;
> +		cf->data=5B0=5D =7C=3D CAN_ERR_LOSTARB_UNSPEC;
> +	=7D
> +
> +	netif_receive_skb(skb);
> +
> +	return 1;
> +=7D
> +
>  static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus=
,
>  				   u32 psr)
>  =7B
> =40=40 -792,6 +824,11 =40=40 static int m_can_handle_bus_errors(struct ne=
t_device
> *dev, u32 irqstatus,
>  	    is_lec_err(psr))
>  		work_done +=3D m_can_handle_lec_err(dev, psr & LEC_UNUSED);
>=20
> +	/* handle protocol errors in arbitration phase */
> +	if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
> +	    m_can_is_protocol_err(irqstatus))
> +		work_done +=3D m_can_handle_protocol_error(dev, irqstatus);
> +
>  	/* other unproccessed error interrupts */
>  	m_can_handle_other_err(dev, irqstatus);
>=20
> --
> 2.17.1


