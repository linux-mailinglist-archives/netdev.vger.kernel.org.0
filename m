Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F26D13C8F9
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAOQQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:16:20 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:45988 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbgAOQQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:16:20 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 14D76C0646;
        Wed, 15 Jan 2020 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579104979; bh=Pm+KzXesAkYAGe4VNi485/QuOtVc2zfN8tF3kYYW09U=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=fu01RFtIon+g/XHAM3eiRXBmWTF93F2qh1C9Ha/fOB8PH7Ztb4LUEjmZT/cck1oXe
         cHQuBpYUR2DPhJWtiq9hDyOxJzt1aSqtZmkVAZ+bkYRM3RTb81DLBZuAoYDST12b9l
         lAGs+osT8B7Gbp2/f2W6yCvwCkkWSuIQEwPr1wa5WY+vJzYgRRmNEUlza/wus0Z+Ks
         UBwYygKc14T1cnmw4GHGUDCe4DOqY/5uOpNGi3ldgLuTN6iPz1qgWfKsD/DqjyN2Du
         MrJEOkcDvxZd0tNsf1iLQ8wiCaE2KE0LklzB8sGfAd0MlsKgr0c68edvqh6fAQWutO
         loouKHj1xP+og==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7EFD8A007F;
        Wed, 15 Jan 2020 16:16:05 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 15 Jan 2020 08:15:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 15 Jan 2020 08:15:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvXNKNqz4HSyhGh2YA1gmjdtO9mW8HAoXRk+dPYfew9Z5/kQuILvfilnC+u1/gLhhIWWOOYSO+vjdaI+wbkfMe3/MOZCHlDNTxFRcOa/yXBgu2qrO0jU5lOg/wQU4PRSt4t90ZEUeXq/Ibd0PnS+dYw4cFy0cxGyleG0LBkRXUDZ8qMEY0HFkigzjYTeI9ouc+AeH8r72D5uOX2NTCygBO0haP3SMaQfJbbTI7uYgPtMkKlQCBkcn6JSLBnwDlaZqPMIKFRFRAioO1WfzXfexlsFhwl0sNzBW6/XVr1jWpaSCwRw9A1iuPLymePzTzRlkCHPhNlXojdOdu9oWEk/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w34eBEERU37rQYTi8ro7STXXUOAIvWiiXBlp26m7YZ0=;
 b=C3NZog2UKARhhbeUoN1CsY1OGFnOD7+IzAQ3Kswn5sFIBzx7+Ov42axsbMtQG6EeaIKP7spAu8UMm9efroByXefw+TJJP2aK8g0DUmGu5RFhDdWFV9Ul0qp5z+0cmph24RvoqY90a4rvRDfYXs6TYRg7Xg/YFabkaoVOJnIaC3py8vaUSyd/KseB4d5uejR9uDIk6ig1SEBxkhODEfw9IwE4ZYGDNDF0Ntl8lTlW2VeXj8a5Sq7wRPJlrioUe/Ipy2r4d+2VmCL25fx9+e3ht76EamU0oTKKk5r4+4HIphFvGReb8J9Q4Gm2jOspGq6brIwTCIUp4pFnb0uU9Ibtrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w34eBEERU37rQYTi8ro7STXXUOAIvWiiXBlp26m7YZ0=;
 b=FsSgminDsBrIvgc4sqIU4YUE0UVdgZUMGMOspTgfR4aCJfRwfSE5SUHlZcx8KVsm1f3IwGa0rxg+qd6W+lZQsnqHS7HAWB0tM/Z2VjnsBaBRyQLoJpv8XrAIjtCmtkxKf0BLkxI47cA4a8W9pHb9t4m6sAEhIMnP/uqt0Mmt9ho=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2851.namprd12.prod.outlook.com (20.179.65.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 16:15:48 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Wed, 15 Jan 2020
 16:15:48 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kubakici@wp.pl>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Voon Weifeng" <weifeng.voon@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2 1/4] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Topic: [PATCH net v2 1/4] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Index: AQHVy3L8yN7x0daunUum4okkbbxKDafr5uCg
Date:   Wed, 15 Jan 2020 16:15:48 +0000
Message-ID: <BN8PR12MB3266F3619CDF78C14179E025D3370@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200115071003.42820-1-boon.leong.ong@intel.com>
 <20200115071003.42820-2-boon.leong.ong@intel.com>
In-Reply-To: <20200115071003.42820-2-boon.leong.ong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 230d6895-e2b4-4285-b6e3-08d799d62f19
x-ms-traffictypediagnostic: BN8PR12MB2851:
x-microsoft-antispam-prvs: <BN8PR12MB2851866EDB989038CF82798BD3370@BN8PR12MB2851.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(110136005)(54906003)(8676002)(4326008)(66946007)(7416002)(81166006)(71200400001)(7696005)(66476007)(52536014)(8936002)(186003)(33656002)(86362001)(9686003)(498600001)(2906002)(26005)(66446008)(66556008)(76116006)(81156014)(64756008)(6506007)(55016002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2851;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5OFhQlQJBfH74J4XKFp7CAso182YOEgBQVqc+/kt/rN+JlkwPjae7m0yxN0LPn/T1nMfSTTVkX13ofT19IIktcG3kiY9UFm+Xddn1nfqbxK9LRSi4p9oMmsJEZp5qEsxkhbrIsnP9aRhv83qu+H4nJgI2H9kMWU204mM/aQm8LaumpVMlC1NHKGTQ3wsUCgsdkVNvigs8D3KvUHAWOlfHOa/DnM9DOapRAI4ItFBfg7aYIqZ0jhqXDLI+9kzccPKYPAI3m7Jx5t9ebr/9c1pCwjN5HSITBifS4aNeyKaCMNFM8i0t9wurESpZzIqjpA2miIQhBY+xAZ/BTaip5eCbkXAsxzyqEpUouwWhE3iuPjITKxZcyIbGOcZm4DqmqlI3uFmntpZpR+Uyv1Jg2KepSyOvN+vNN6jJ2p/QlVNBnh3jFXlTJfmISsXhLQwHIuQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 230d6895-e2b4-4285-b6e3-08d799d62f19
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 16:15:48.7680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e2q0WQVWVP2LFoaXMqOkGWP3MgWkRthpPFkuD4wdMZUqYIH7Tkppf6E9Z6mkFimx6nRGFiS/QHYC58wek14aBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2851
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>
Date: Jan/15/2020, 07:10:00 (UTC+00:00)

> From: Aashish Verma <aashishx.verma@intel.com>
>=20
> netif_set_real_num_tx_queues() & netif_set_real_num_rx_queues() should be
> used to inform network stack about the real Tx & Rx queue (active) number
> in both stmmac_open() and stmmac_resume(), therefore, we move the code
> from stmmac_dvr_probe() to stmmac_hw_setup().
>=20
> Fixes: c02b7a914551 ("net: stmmac: use netif_set_real_num_{rx,tx}_queues"=
)
> Signed-off-by: Aashish Verma <aashishx.verma@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index 80d59b775907..0780e00580a2 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2624,6 +2624,10 @@ static int stmmac_hw_setup(struct net_device *dev,=
 bool init_ptp)
>  	if (priv->dma_cap.vlins)
>  		stmmac_enable_vlan(priv, priv->hw, STMMAC_VLAN_INSERT);
> =20
> +	/* Configure real RX and TX queues */
> +	netif_set_real_num_rx_queues(dev, priv->plat->rx_queues_to_use);
> +	netif_set_real_num_tx_queues(dev, priv->plat->tx_queues_to_use);
> +

Nack. You need to hold rtnl lock when calling this and at suspend / resume=
=20
you don't.

---
Thanks,
Jose Miguel Abreu
