Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C43FACC1
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKMJUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:20:47 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:7890 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfKMJUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:20:46 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: zN2B8fVss1fdlXv+V6x7MBvCR9IK9t3+bPfLydHZULUMZeJVam9r71foXbel4hsy32IjjFFS56
 gpdPsfjobCsgTqTxehzslu6/nDYmSCgUKGGdmr+tjCvqVByVohNGq4ZrGHXblOSiuLCL1s7ccl
 72EogTzfY9PfY0MWFKN8+lycyNufe92LvV+McOlhIlFPCd60doJ7bbtPvtd9j7i1ttkD6scJq8
 uGvK7LQzeuHgMlPf7NkrBXaxyDfNFEZcsqmYvURLNhArJfSzAnNF1a2Bx3yugwWQdFnA9uZi83
 qB4=
X-IronPort-AV: E=Sophos;i="5.68,300,1569308400"; 
   d="scan'208";a="55263741"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2019 02:20:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 Nov 2019 02:20:22 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 13 Nov 2019 02:20:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAHevue/XQK7GuiFWHWdIm5V7k9MmVj8sWRE0p76JTWI87R/2LoG9jNKTs2Q457z1VyfJmwvRTcFG6fXGXNFYrgVitYODWsMNiZ0foWZ1QO0aTYk3hC6RjUmYplfy2VcuHZw7YlXfEDzWgrX6iVMbx2WKTzlniIxH7yUtpfyLk5KT+QdUDO9Ng++qVI8m+d64L4tuF876hbn6L/qGnjMTYIB7/oe+uvccRclP8xlsPKsVKpLQ71CP9w3k4d8Cby73QjIIHzaACzpBuibNJLIEi212NHE5ok1yCqD8jWkHPVUrDR7yyJubRdl1tBLAbKQbtxVzs6my0oNBcHvbVyRwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pf7aWO9OjXC2HUzLTp5ToC9JRA3+cd2bIWFJwJ3rib0=;
 b=ZKL4ZsStYXrAupM2TCEOZ4kXyQmEgFBi+7k0m8i4CkitEn2pQRVfQh3B+MNcn5008WekUklGtVEWL7rcNGxNHwX5o68PUsUXChfffjFpBMWHP/DHeN4kfcljc8e8V/ABinjskUNMoEa3EKP8CMjRjICUSWjXGKg2CUeTTtbKJWraV/E0/9Gmdjehcu2Cr7+GeV0w4JrkJdwZT0BGQczyc7cfND044pZoYcGIr1lygihRkLUE9AJaF+G90RaTTpPpgMjAYFONMszF3AW7BOnKSgr1+VAit4ghqTwLCA5ikw5aV9sFnjnj0DrxucI2eFQXtFeT00Pmd6/oCjxuvv2fLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pf7aWO9OjXC2HUzLTp5ToC9JRA3+cd2bIWFJwJ3rib0=;
 b=jhx2535Q4OV6s+jdmt0AOEMhHE+gr7y7aVznVnDwNKgfiOabmAeFapH2ZEEuh9YRajmzp1ZUyiQzfYe9zAkU1I/Hpc8u15mMxPEc7A7L5KKqx7eBZVwmiWvKkDDT21SXqnDa4IJUtHpOdJj01xmmk3P5pVNZBNe1Zbb+7KU/z3c=
Received: from SN6PR11MB2830.namprd11.prod.outlook.com (52.135.93.21) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.112.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Wed, 13 Nov 2019 09:20:21 +0000
Received: from SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::6460:e571:9440:bd83]) by SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::6460:e571:9440:bd83%6]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 09:20:21 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <antoine.tenart@bootlin.com>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <alexandre.belloni@bootlin.com>,
        <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <mparab@cadence.com>, <piotrs@cadence.com>, <dkangude@cadence.com>,
        <ewanm@cadence.com>, <arthurm@cadence.com>, <stevenh@cadence.com>
Subject: Re: [PATCH net-next v3 1/2] net: macb: move the Tx and Rx buffer
 initialization into a function
Thread-Topic: [PATCH net-next v3 1/2] net: macb: move the Tx and Rx buffer
 initialization into a function
Thread-Index: AQHVmgGChnSKn6wLCkyevG9G+lfDKKeI0xcA
Date:   Wed, 13 Nov 2019 09:20:21 +0000
Message-ID: <745a8f2c-3571-5bbc-f4d7-f9a7857ac513@microchip.com>
References: <20191113090006.58898-1-antoine.tenart@bootlin.com>
 <20191113090006.58898-2-antoine.tenart@bootlin.com>
In-Reply-To: <20191113090006.58898-2-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::17) To SN6PR11MB2830.namprd11.prod.outlook.com
 (2603:10b6:805:5b::21)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a01:cb1c:a97:7600:a0f2:f1f3:de5d:e88]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b57737b-2cf0-40f3-45f7-08d7681ab505
x-ms-traffictypediagnostic: SN6PR11MB3263:
x-microsoft-antispam-prvs: <SN6PR11MB32633117917AA87D41A182EFE0760@SN6PR11MB3263.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(396003)(39860400002)(136003)(376002)(199004)(189003)(25786009)(8676002)(5660300002)(71190400001)(71200400001)(52116002)(14444005)(256004)(81156014)(8936002)(81166006)(305945005)(64756008)(7736002)(76176011)(316002)(36756003)(102836004)(478600001)(186003)(2501003)(14454004)(110136005)(54906003)(31696002)(86362001)(6116002)(386003)(6506007)(66476007)(229853002)(2201001)(46003)(476003)(99286004)(53546011)(66556008)(66946007)(2906002)(66446008)(7416002)(446003)(6512007)(11346002)(4326008)(6246003)(486006)(2616005)(6436002)(31686004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3263;H:SN6PR11MB2830.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P8PnG1ygDTrynC3fF6xXyw1TTGbidX7HH3FRNb7Fs6gNF5GOnmiqWpbG5feNgzAdDcfKorS0iNQwDTFFwQ8R4wyD5IFZ4+ANWNMADKY80Q28zEOuG/UKkFPMsQLRNG9Qv/ADseCIQuqahMPWRU0EJCKFFXC7xpqj2BXQ7LC2zL7K4rnbBgwrrRUlBAG5+yACTDC4DmfiW4ae7N4Aqi70xzrnMEFL5LvrEm4aCCLjM6r4hyz5lc1+6Pe6Xzs8dJW0HPLuT/dGLn4wQuqhE1Q2kYq6fwC0ZSt4J5q+3uGS38rROBrkUA7nTrE/QrbUCTiPQrbMJHjbYJF6lFODFKvoUzOh9KetOH9YNsdVZb5AmdSOBbKAZ3/FkMP29o5iKg9IVV+KVnUjMy6NuhAOcDNkqiwQrlZLBKsFx7/GILJbu1JENSBZN6Bd9lDQdKbJ42IC
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <E0FD8E4902D3A145835072FBEB03771D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b57737b-2cf0-40f3-45f7-08d7681ab505
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 09:20:21.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuEyv8scD8fcaQqWXUTaO/H/HoJ6BY+2Hxl/ng1cLeQbbAY1hrVghtPFfWNicBxFOSYoZh8zW3EZC6DV/94pNYkduMYnu+EhNlfVpyF8Acw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/11/2019 at 10:00, Antoine Tenart wrote:
> External E-Mail
>=20
>=20
> This patch moves the Tx and Rx buffer initialization into its own
> function. This does not modify the behaviour of the driver and will be
> helpful to convert the driver to phylink.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 39 +++++++++++++++---------
>   1 file changed, 24 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c
> index b884cf7f339b..1b3c8d678116 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -388,6 +388,27 @@ static int macb_mdio_write(struct mii_bus *bus, int =
mii_id, int regnum,
>   	return status;
>   }
>  =20
> +static void macb_init_buffers(struct macb *bp)
> +{
> +	struct macb_queue *queue;
> +	unsigned int q;
> +
> +	for (q =3D 0, queue =3D bp->queues; q < bp->num_queues; ++q, ++queue) {
> +		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> +		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> +			queue_writel(queue, RBQPH,
> +				     upper_32_bits(queue->rx_ring_dma));
> +#endif
> +		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> +		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> +			queue_writel(queue, TBQPH,
> +				     upper_32_bits(queue->tx_ring_dma));
> +#endif
> +	}
> +}
> +
>   /**
>    * macb_set_tx_clk() - Set a clock to a new frequency
>    * @clk		Pointer to the clock to change
> @@ -1314,26 +1335,14 @@ static void macb_hresp_error_task(unsigned long d=
ata)
>   	bp->macbgem_ops.mog_init_rings(bp);
>  =20
>   	/* Initialize TX and RX buffers */
> -	for (q =3D 0, queue =3D bp->queues; q < bp->num_queues; ++q, ++queue) {
> -		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
> -#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> -		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> -			queue_writel(queue, RBQPH,
> -				     upper_32_bits(queue->rx_ring_dma));
> -#endif
> -		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
> -#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> -		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> -			queue_writel(queue, TBQPH,
> -				     upper_32_bits(queue->tx_ring_dma));
> -#endif
> +	macb_init_buffers(bp);
>  =20
> -		/* Enable interrupts */
> +	/* Enable interrupts */
> +	for (q =3D 0, queue =3D bp->queues; q < bp->num_queues; ++q, ++queue)
>   		queue_writel(queue, IER,
>   			     bp->rx_intr_mask |
>   			     MACB_TX_INT_FLAGS |
>   			     MACB_BIT(HRESP));
> -	}
>  =20
>   	ctrl |=3D MACB_BIT(RE) | MACB_BIT(TE);
>   	macb_writel(bp, NCR, ctrl);
>=20


--=20
Nicolas Ferre
