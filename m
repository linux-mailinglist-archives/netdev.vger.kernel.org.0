Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8254374DA
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfFFNIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:08:51 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:12769
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfFFNIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTQVEt0WHXoGeecAGMjcC0kuSkgeQI6+OyW5zjOo3uc=;
 b=l9PljOftT4KAJ1GCR4qOWoW7IU1KRKOKLS9USIgx71lFDKoq9XIaMIZ7Cl+qHubqKbqe50VLZLlSPwV6Q1bQp+c504YfLK9D1PVNSgTc9byL1+aID/O4dYWXB/6cxsvhTEgnpwsJRcigW7t0bGZv3RDCvz/JrBLMk+fSTwyLI90=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2608.eurprd05.prod.outlook.com (10.168.134.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 13:08:46 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6%10]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 13:08:46 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Thread-Topic: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Thread-Index: AQHVHFfk48XsBdlVgE2l6nOFj6QIH6aOl6Tw
Date:   Thu, 6 Jun 2019 13:08:46 +0000
Message-ID: <VI1PR0501MB227150ADAFACF4A5DEC26693D1170@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-2-leon@kernel.org>
In-Reply-To: <20190606110609.11588-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.21.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2709cc14-d769-4fc8-51de-08d6ea801bbb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2608;
x-ms-traffictypediagnostic: VI1PR0501MB2608:
x-microsoft-antispam-prvs: <VI1PR0501MB26082B10698AEE59CC161BE7D1170@VI1PR0501MB2608.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(136003)(376002)(396003)(13464003)(199004)(189003)(53546011)(186003)(66066001)(7736002)(76176011)(76116006)(26005)(256004)(4326008)(8676002)(64756008)(6506007)(73956011)(66446008)(55236004)(6116002)(71190400001)(14454004)(33656002)(8936002)(102836004)(74316002)(66556008)(25786009)(78486014)(478600001)(71200400001)(6636002)(52536014)(86362001)(5660300002)(305945005)(110136005)(68736007)(99286004)(55016002)(229853002)(2906002)(3846002)(66946007)(446003)(11346002)(486006)(66476007)(476003)(81166006)(54906003)(81156014)(9456002)(6436002)(316002)(7696005)(9686003)(6246003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2608;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nxrF9RalcPkahMv9KhZxnAOjrLqoMrQwnDHZrftskqzJL/2AaRc0+WUM+PlOzeVuBHQVn5m4WxPiWmxHKMcD1AkRL6SLPBY7UBVUAygxWbb6EWLcopt46JCaxY0Z769GDxk1N9sU5puB6Hf6WTzmbzFxgNKdOVGSI2HswZFS4u6GUKesGQ+McB4o3SP7UpxQWsuCU5vAYhjUI1g/6b+f9sO61NmyMavr8Ngj88ado4FMv1VGiFQHqGq7Isbdop7tGKGAM5xKlsGgAsnkTSEAf/1/zyjYQLnJRiVqqrRUC2dUwAoRkQERkHID3SSDSNok7TFZ+gH22WSLjRDx2LAQZvme96ijoG3xqrOpd3//5ZnY1mX0CkRy3MSQH5+bIxplKM9CG1dOa2U03tCDXsGHgo2pX6+uw0fVmgImmqp+49g=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2709cc14-d769-4fc8-51de-08d6ea801bbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 13:08:46.0887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> Sent: Thursday, June 6, 2019 4:36 PM
> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> <markb@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> linux-netdev <netdev@vger.kernel.org>
> Subject: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
>=20
> From: Maor Gottlieb <maorg@mellanox.com>
>=20
> Add API to get the current Eswitch encap mode.
> It will be used in downstream patches to check if flow table can be creat=
ed
> with encap support or not.
>=20
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 10 ++++++++++
>  include/linux/mlx5/eswitch.h                      | 10 ++++++++++
>  2 files changed, 20 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index 9ea0ccfe5ef5..1da7f9569ee8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -2452,6 +2452,16 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch
> *esw)  }  EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
>=20
> +u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev) {

Encap mode as well defined devlink definition.
So instead of u16, it should return enum devlink_eswitch_encap_mode.

Since this is only reading the mode, it is better to define struct mlx5_cor=
e_dev* as const struct mlx5_core_dev *.

> +	struct mlx5_eswitch *esw;
> +
> +	esw =3D dev->priv.eswitch;
> +	return ESW_ALLOWED(esw) ? esw->offloads.encap :
> +		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
> +}
> +EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
> +
>  bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct
> mlx5_core_dev *dev1)  {
>  	if ((dev0->priv.eswitch->mode =3D=3D SRIOV_NONE && diff --git
> a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h index
> 0ca77dd1429c..7be43c0fcdc5 100644
> --- a/include/linux/mlx5/eswitch.h
> +++ b/include/linux/mlx5/eswitch.h
> @@ -7,6 +7,7 @@
>  #define _MLX5_ESWITCH_
>=20
>  #include <linux/mlx5/driver.h>
> +#include <net/devlink.h>
>=20
>  #define MLX5_ESWITCH_MANAGER(mdev) MLX5_CAP_GEN(mdev,
> eswitch_manager)
>=20
> @@ -60,4 +61,13 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
> struct mlx5_flow_handle *  mlx5_eswitch_add_send_to_vport_rule(struct
> mlx5_eswitch *esw,
>  				    int vport, u32 sqn);
> +
> +#ifdef CONFIG_MLX5_ESWITCH
> +u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev); #else  /*
> +CONFIG_MLX5_ESWITCH */ static inline u16
> +mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev) {
> +	return DEVLINK_ESWITCH_ENCAP_MODE_NONE; } #endif /*
> +CONFIG_MLX5_ESWITCH */
>  #endif
> --
> 2.20.1

