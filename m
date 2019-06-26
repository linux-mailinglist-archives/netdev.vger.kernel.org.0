Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52245656E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFZJMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:12:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41018 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725379AbfFZJMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:12:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q99qth024365;
        Wed, 26 Jun 2019 02:12:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=DX0j4kivLkXx6uJoGZB3R3U9gOpPsnS6l+9pZvUo4Og=;
 b=UeofCBnTqVGYclhdImsT2t8fNZP2pwUImjmpIRw+hTRBHpx/QBeOCN2vzHwibDJJK4FH
 O0NNUvK3pKiE0UnV0bvyIXmcB1Xuv75gChkwON21+9yYwxV1vIL09b/9KlD/8fLEY8WM
 GCfr8g3+J9KM8e4k7m1RzT8GYdQ6pR944glx99ZPq/I+w/nIPRCNIN3qFtLilmZ+vFbu
 +EuJElqWqXbOJ+Eah2eB2vVaxtbJVP9PKmrObzSgmjx/P/8lgqU0I5p2ggpO4sPuyN9V
 BaHbEcJ0lQ1lmy+3T001CaLeD10Ysi+RB2DQGu+FPvKPAj5jmMMSXV13gCGtXdlrm7o7 Nw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tc5ht02cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 02:12:10 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 26 Jun
 2019 02:12:09 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.50) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 26 Jun 2019 02:12:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DX0j4kivLkXx6uJoGZB3R3U9gOpPsnS6l+9pZvUo4Og=;
 b=X5SRD0XoluX+zLEx6+m05bqyCwZx+HeCghio2TKz2F3YsTgFvxenPVffCJX6kGjGSWkcaOgG1EjHLEx+EpRpbchJxJRPGJ+FcpTEGfqVZP8PEeSJIHaomcbowTlDNtQDe8yGArYOwsEO4KONu6HCYyCL2FUo6urru6mbRS03ZrE=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2634.namprd18.prod.outlook.com (20.179.106.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 09:12:04 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 09:12:04 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 02/16] qlge: Remove page_chunk.last_flag
Thread-Topic: [PATCH net-next 02/16] qlge: Remove page_chunk.last_flag
Thread-Index: AQHVJOFETd6q1ujOhECG/ajaT47DXaattHuw
Date:   Wed, 26 Jun 2019 09:12:04 +0000
Message-ID: <DM6PR18MB2697AB743E5965B602229348ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-2-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-2-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3440f6b7-a8be-45d5-4a81-08d6fa165b35
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2634;
x-ms-traffictypediagnostic: DM6PR18MB2634:
x-microsoft-antispam-prvs: <DM6PR18MB26341F8FC0823A2089A88928ABE20@DM6PR18MB2634.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(366004)(39860400002)(376002)(189003)(199004)(13464003)(9686003)(81156014)(5660300002)(55016002)(66556008)(64756008)(66446008)(66066001)(52536014)(76176011)(8936002)(478600001)(25786009)(53936002)(7696005)(66476007)(186003)(6246003)(26005)(71190400001)(53546011)(81166006)(102836004)(86362001)(2906002)(6506007)(71200400001)(6116002)(8676002)(3846002)(256004)(14454004)(6436002)(99286004)(33656002)(110136005)(74316002)(446003)(316002)(76116006)(11346002)(229853002)(486006)(73956011)(2501003)(476003)(305945005)(66946007)(68736007)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2634;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j6wTBkM39xArejc8kEzNzi8/xRB2FW6yAhrZ4lfz0cMnpe4ljqqAHK5epVaicgkQDTcT8S6vSng2Qov/X8EGrmY8XVOjxCXsfri70iSwwacf9RMDS6aRK5PppLkoj35wNwk4RRzD8FLTz1ux4mxXeE88XjoVmTs3FEwfm0K4eT8SbFMMgS3Z4tRlMKVs0o+lwC5dvXpfbdnIJ3HzDcEhSCH/ENO4LODXVJfa48MNMDAhkSVZweNt9xx34HqyoHNuVOytq7ZHGgqUy37FcoTpTOvIM7lQBRCnjTsbn3fafTO/NLlyP/qNu4YZ/Twv5WTioa2D+Exj2pK9E9lmfAsos/JcYvg92i8hnFQx8PeRBALENenLSPydSIPZtyh3MHFRud4Bf1A2hW8tMgXwM+juBtO3/FHuBVqmijPW4TQCpuc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3440f6b7-a8be-45d5-4a81-08d6fa165b35
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 09:12:04.4688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2634
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
> Subject: [PATCH net-next 02/16] qlge: Remove page_chunk.last_flag
>=20
> As already done in ql_get_curr_lchunk(), this member can be replaced by a
> simple test.
>=20
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> ---
>  drivers/net/ethernet/qlogic/qlge/qlge.h      |  1 -
>  drivers/net/ethernet/qlogic/qlge/qlge_main.c | 13 +++++--------
>  2 files changed, 5 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h
> b/drivers/net/ethernet/qlogic/qlge/qlge.h
> index 5d9a36deda08..0a156a95e981 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge.h
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
> @@ -1363,7 +1363,6 @@ struct page_chunk {
>  	char *va;		/* virt addr for this chunk */
>  	u64 map;		/* mapping for master */
>  	unsigned int offset;	/* offset for this chunk */
> -	unsigned int last_flag; /* flag set for last chunk in page */
>  };
>=20
>  struct bq_desc {
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> index 0bfbe11db795..038a6bfc79c7 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> @@ -1077,11 +1077,9 @@ static int ql_get_next_chunk(struct ql_adapter
> *qdev, struct rx_ring *rx_ring,
>  	rx_ring->pg_chunk.offset +=3D rx_ring->lbq_buf_size;
>  	if (rx_ring->pg_chunk.offset =3D=3D ql_lbq_block_size(qdev)) {
>  		rx_ring->pg_chunk.page =3D NULL;
> -		lbq_desc->p.pg_chunk.last_flag =3D 1;
>  	} else {
>  		rx_ring->pg_chunk.va +=3D rx_ring->lbq_buf_size;
>  		get_page(rx_ring->pg_chunk.page);
> -		lbq_desc->p.pg_chunk.last_flag =3D 0;
>  	}
>  	return 0;
>  }
> @@ -2778,6 +2776,8 @@ static int ql_alloc_tx_resources(struct ql_adapter
> *qdev,
>=20
>  static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring
> *rx_ring)  {
> +	unsigned int last_offset =3D ql_lbq_block_size(qdev) -
> +		rx_ring->lbq_buf_size;
>  	struct bq_desc *lbq_desc;
>=20
>  	uint32_t  curr_idx, clean_idx;
> @@ -2787,13 +2787,10 @@ static void ql_free_lbq_buffers(struct ql_adapter
> *qdev, struct rx_ring *rx_ring
>  	while (curr_idx !=3D clean_idx) {
>  		lbq_desc =3D &rx_ring->lbq[curr_idx];
>=20
> -		if (lbq_desc->p.pg_chunk.last_flag) {
> -			pci_unmap_page(qdev->pdev,
> -				lbq_desc->p.pg_chunk.map,
> -				ql_lbq_block_size(qdev),
> +		if (lbq_desc->p.pg_chunk.offset =3D=3D last_offset)
> +			pci_unmap_page(qdev->pdev, lbq_desc-
> >p.pg_chunk.map,
> +				       ql_lbq_block_size(qdev),
>  				       PCI_DMA_FROMDEVICE);
> -			lbq_desc->p.pg_chunk.last_flag =3D 0;
> -		}
>=20
>  		put_page(lbq_desc->p.pg_chunk.page);
>  		lbq_desc->p.pg_chunk.page =3D NULL;
> --
> 2.21.0

Acked-by: Manish Chopra <manishc@marvell.com>

