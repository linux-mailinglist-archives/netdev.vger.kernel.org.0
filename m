Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F530565AD
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfFZJcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:32:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbfFZJcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:32:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q9TKmZ025181;
        Wed, 26 Jun 2019 02:31:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=pvAUt1Fwx06lL7dCjAWxj3uywK4kOSgBqmb70qDUqTg=;
 b=Spdd35tVLU2e+46wmhcCh9oApfDeevnMcqW7rTxqOvkYXG8TU87JYhC2QWgyd/yny5II
 e+XluaPfqi80FLkb0TbuYcFUXJQmFu1iaIp35K2qx4atlHsBo9ETk8qKlrqpxzHgi4Lu
 SbNh8YrOZMmpN8mdStDrn73UHaUX1POVQ5K8PzOHW9eBGeqN9cVir+7veF+NAbPVN8KV
 eNXYIBnQGiYIT1/husLubiov565Mz+aauQJNiwcKkXmPa9y6m7mO0P8feQCSQPmFuIfw
 4Ay9ylPz/jyr7aqFmcJ23WIT/vqSS35AAAUyHjNkassmEVyNGmBHvQNFy1r0uvWSU84v 4w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tc3s6rhs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 02:31:54 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 26 Jun
 2019 02:31:52 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 26 Jun 2019 02:31:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvAUt1Fwx06lL7dCjAWxj3uywK4kOSgBqmb70qDUqTg=;
 b=d2OmKiEQ1lIYLXpfr2WR5lshFEUB9R1yK7DtIRnolsXAY1cC6OcsR6gQRKCmNbgy/bQhc7tRMaLDQCtN8vTQDWJpdDniYOBawVGJ90dcFRF7iCr+kvZ5VOMR4LvHcH+9xmVNIqs7s0s6Wq2ltdQCCctZ+kzoea+BLNVaA8pytio=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB3083.namprd18.prod.outlook.com (20.179.48.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 09:31:50 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 09:31:50 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 04/16] qlge: Remove bq_desc.maplen
Thread-Topic: [PATCH net-next 04/16] qlge: Remove bq_desc.maplen
Thread-Index: AQHVJOFGnPsfPCgDs0Gg4GjwaD0Ts6atug4Q
Date:   Wed, 26 Jun 2019 09:31:50 +0000
Message-ID: <DM6PR18MB2697B10ACBBB21A7E433EAE8ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-4-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-4-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5487f3a9-4158-4714-8377-08d6fa191e23
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB3083;
x-ms-traffictypediagnostic: DM6PR18MB3083:
x-microsoft-antispam-prvs: <DM6PR18MB30836F08C27A94E0193CF4CDABE20@DM6PR18MB3083.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(366004)(376002)(346002)(199004)(189003)(13464003)(55016002)(25786009)(186003)(14444005)(256004)(53936002)(305945005)(68736007)(6436002)(7736002)(73956011)(76116006)(81156014)(5660300002)(8936002)(66946007)(81166006)(8676002)(66556008)(64756008)(66446008)(316002)(110136005)(66476007)(86362001)(52536014)(478600001)(66066001)(76176011)(71200400001)(99286004)(3846002)(6116002)(26005)(53546011)(229853002)(102836004)(6506007)(74316002)(9686003)(14454004)(6246003)(446003)(476003)(11346002)(2906002)(486006)(33656002)(7696005)(71190400001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB3083;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RIfpf4PLLtJdvhWvZGczrMeLAPLmSJJgI+1qdEDdzT5kPII2NGm1+V2QhVIJajXdqJs38UY1PFgo+wpxmc3Fe0dIgTSxUOwV5SUg4Aosxu/K5SUkMTs/GbG2nanz49uRHIVjwaDUf620E6suZC8sZTUsJq4QooVicf79k0lVqScHz5B4iwPcDhi4C8HmPAXXn6ETWt/oAHjoeFsSQLshXRky7DddbkCgkS6LdRFywsudoAnckPWSB6oj/c8bDWxEF6OvyxdkjKUdqyowySOMF7tAIX0g54sZ5PEP/Sk2dMRrd95PbhcVVwK20WmyV29YFAsOQlT/Fb+X7B19d4k1+gXZRikOzHUFcqTxHTnkbaoHD3DEHzgPpcuxlh6xB1wh91rokC8C4h68MhlyozkAzoIOGqsxM539kO9w4dl8978=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5487f3a9-4158-4714-8377-08d6fa191e23
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 09:31:50.4685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3083
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Benjamin Poirier <bpoirier@suse.com>
> Sent: Monday, June 17, 2019 1:19 PM
> To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> NIC-Dev@marvell.com>; netdev@vger.kernel.org
> Subject: [PATCH net-next 04/16] qlge: Remove bq_desc.maplen
>=20
> The size of the mapping is known statically in all cases, there's no need=
 to save
> it at runtime. Remove this member.
>=20
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> ---
>  drivers/net/ethernet/qlogic/qlge/qlge.h      |  1 -
>  drivers/net/ethernet/qlogic/qlge/qlge_main.c | 43 +++++++-------------
>  2 files changed, 15 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h
> b/drivers/net/ethernet/qlogic/qlge/qlge.h
> index ba61b4559dd6..f32da8c7679f 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge.h
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
> @@ -1373,7 +1373,6 @@ struct bq_desc {
>  	__le64 *addr;
>  	u32 index;
>  	DEFINE_DMA_UNMAP_ADDR(mapaddr);
> -	DEFINE_DMA_UNMAP_LEN(maplen);
>  };
>=20
>  #define QL_TXQ_IDX(qdev, skb) (smp_processor_id()%(qdev->tx_ring_count))
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> index 9df06ad3fb93..25dbaa9cc55d 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> @@ -1108,8 +1108,6 @@ static void ql_update_lbq(struct ql_adapter *qdev,
> struct rx_ring *rx_ring)
>  			map =3D lbq_desc->p.pg_chunk.map +
>  				lbq_desc->p.pg_chunk.offset;
>  			dma_unmap_addr_set(lbq_desc, mapaddr, map);
> -			dma_unmap_len_set(lbq_desc, maplen,
> -					  qdev->lbq_buf_size);
>  			*lbq_desc->addr =3D cpu_to_le64(map);
>=20
>  			pci_dma_sync_single_for_device(qdev->pdev, map,
> @@ -1177,8 +1175,6 @@ static void ql_update_sbq(struct ql_adapter *qdev,
> struct rx_ring *rx_ring)
>  					return;
>  				}
>  				dma_unmap_addr_set(sbq_desc, mapaddr,
> map);
> -				dma_unmap_len_set(sbq_desc, maplen,
> -						  rx_ring->sbq_buf_size);
>  				*sbq_desc->addr =3D cpu_to_le64(map);
>  			}
>=20
> @@ -1598,14 +1594,14 @@ static void ql_process_mac_rx_skb(struct
> ql_adapter *qdev,
>=20
>  	pci_dma_sync_single_for_cpu(qdev->pdev,
>  				    dma_unmap_addr(sbq_desc, mapaddr),
> -				    dma_unmap_len(sbq_desc, maplen),
> +				    rx_ring->sbq_buf_size,
>  				    PCI_DMA_FROMDEVICE);
>=20
>  	skb_put_data(new_skb, skb->data, length);
>=20
>  	pci_dma_sync_single_for_device(qdev->pdev,
>  				       dma_unmap_addr(sbq_desc, mapaddr),
> -				       dma_unmap_len(sbq_desc, maplen),
> +				       rx_ring->sbq_buf_size,
>  				       PCI_DMA_FROMDEVICE);
>  	skb =3D new_skb;
>=20
> @@ -1727,8 +1723,7 @@ static struct sk_buff *ql_build_rx_skb(struct
> ql_adapter *qdev,
>  		sbq_desc =3D ql_get_curr_sbuf(rx_ring);
>  		pci_unmap_single(qdev->pdev,
>  				dma_unmap_addr(sbq_desc, mapaddr),
> -				dma_unmap_len(sbq_desc, maplen),
> -				PCI_DMA_FROMDEVICE);
> +				rx_ring->sbq_buf_size,
> PCI_DMA_FROMDEVICE);
>  		skb =3D sbq_desc->p.skb;
>  		ql_realign_skb(skb, hdr_len);
>  		skb_put(skb, hdr_len);
> @@ -1758,19 +1753,15 @@ static struct sk_buff *ql_build_rx_skb(struct
> ql_adapter *qdev,
>  			 */
>  			sbq_desc =3D ql_get_curr_sbuf(rx_ring);
>  			pci_dma_sync_single_for_cpu(qdev->pdev,
> -						    dma_unmap_addr
> -						    (sbq_desc, mapaddr),
> -						    dma_unmap_len
> -						    (sbq_desc, maplen),
> +
> dma_unmap_addr(sbq_desc,
> +								   mapaddr),
> +						    rx_ring->sbq_buf_size,
>  						    PCI_DMA_FROMDEVICE);
>  			skb_put_data(skb, sbq_desc->p.skb->data, length);
>  			pci_dma_sync_single_for_device(qdev->pdev,
> -						       dma_unmap_addr
> -						       (sbq_desc,
> -							mapaddr),
> -						       dma_unmap_len
> -						       (sbq_desc,
> -							maplen),
> +
> dma_unmap_addr(sbq_desc,
> +								      mapaddr),
> +						       rx_ring->sbq_buf_size,
>  						       PCI_DMA_FROMDEVICE);
>  		} else {
>  			netif_printk(qdev, rx_status, KERN_DEBUG, qdev-
> >ndev, @@ -1781,10 +1772,8 @@ static struct sk_buff *ql_build_rx_skb(stru=
ct
> ql_adapter *qdev,
>  			ql_realign_skb(skb, length);
>  			skb_put(skb, length);
>  			pci_unmap_single(qdev->pdev,
> -					 dma_unmap_addr(sbq_desc,
> -							mapaddr),
> -					 dma_unmap_len(sbq_desc,
> -						       maplen),
> +					 dma_unmap_addr(sbq_desc,
> mapaddr),
> +					 rx_ring->sbq_buf_size,
>  					 PCI_DMA_FROMDEVICE);
>  			sbq_desc->p.skb =3D NULL;
>  		}
> @@ -1822,9 +1811,8 @@ static struct sk_buff *ql_build_rx_skb(struct
> ql_adapter *qdev,
>  				return NULL;
>  			}
>  			pci_unmap_page(qdev->pdev,
> -				       dma_unmap_addr(lbq_desc,
> -						      mapaddr),
> -				       dma_unmap_len(lbq_desc, maplen),
> +				       dma_unmap_addr(lbq_desc, mapaddr),
> +				       qdev->lbq_buf_size,
>  				       PCI_DMA_FROMDEVICE);
>  			skb_reserve(skb, NET_IP_ALIGN);
>  			netif_printk(qdev, rx_status, KERN_DEBUG, qdev-
> >ndev, @@ -1858,8 +1846,7 @@ static struct sk_buff *ql_build_rx_skb(struc=
t
> ql_adapter *qdev,
>  		sbq_desc =3D ql_get_curr_sbuf(rx_ring);
>  		pci_unmap_single(qdev->pdev,
>  				 dma_unmap_addr(sbq_desc, mapaddr),
> -				 dma_unmap_len(sbq_desc, maplen),
> -				 PCI_DMA_FROMDEVICE);
> +				 rx_ring->sbq_buf_size,
> PCI_DMA_FROMDEVICE);
>  		if (!(ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS)) {
>  			/*
>  			 * This is an non TCP/UDP IP frame, so @@ -2820,7
> +2807,7 @@ static void ql_free_sbq_buffers(struct ql_adapter *qdev, struc=
t
> rx_ring *rx_ring
>  		if (sbq_desc->p.skb) {
>  			pci_unmap_single(qdev->pdev,
>  					 dma_unmap_addr(sbq_desc,
> mapaddr),
> -					 dma_unmap_len(sbq_desc, maplen),
> +					 rx_ring->sbq_buf_size,
>  					 PCI_DMA_FROMDEVICE);
>  			dev_kfree_skb(sbq_desc->p.skb);
>  			sbq_desc->p.skb =3D NULL;
> --
> 2.21.0

Acked-by: Manish Chopra <manishc@marvell.com>

