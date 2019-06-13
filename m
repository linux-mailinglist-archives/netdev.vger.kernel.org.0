Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAB744621
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbfFMQt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:49:27 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:40929
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727640AbfFMEcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 00:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcN3wpiTM1XUDQBzX4uM9WlXb5YmwSiFbwDJZT7xAV4=;
 b=sUFjYEO4MnsxDNbbpNqREAiL7mJRTcX7/JzSgyhng2TABSkMif6HTlI55WoPvhNL7a+wEgrYLvS4qirdF4UIujRtHaospTGJGnbUhTkuZSg6kBHYbn/GbiLkghDIbbTy6TbPNyRyb+BFfHe4ZOKvosckYZJoiElB5WRfZCHNIsc=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2798.eurprd05.prod.outlook.com (10.172.11.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 04:32:26 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6%10]) with mapi id 15.20.1987.012; Thu, 13 Jun
 2019 04:32:26 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: RE: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
 encap mode
Thread-Topic: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
 encap mode
Thread-Index: AQHVIRk93NTLWDMZBEuCJA9HhOTRuqaY/2Nw
Date:   Thu, 13 Jun 2019 04:32:25 +0000
Message-ID: <VI1PR0501MB2271FF8A570DDBBD26CF7100D1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-2-leon@kernel.org>
In-Reply-To: <20190612122014.22359-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.182.253.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59462a5b-7184-41d3-6abd-08d6efb8231a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2798;
x-ms-traffictypediagnostic: VI1PR0501MB2798:
x-microsoft-antispam-prvs: <VI1PR0501MB27985B9E3CE2A34D8911FA35D1EF0@VI1PR0501MB2798.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(39860400002)(136003)(396003)(13464003)(189003)(199004)(6506007)(110136005)(478600001)(54906003)(486006)(99286004)(76176011)(7696005)(86362001)(476003)(6116002)(3846002)(71190400001)(71200400001)(53546011)(102836004)(446003)(11346002)(5660300002)(6636002)(14454004)(74316002)(2906002)(9686003)(66066001)(6436002)(305945005)(55016002)(316002)(52536014)(53936002)(6246003)(66946007)(73956011)(25786009)(66476007)(66556008)(66446008)(64756008)(26005)(256004)(4326008)(76116006)(68736007)(186003)(33656002)(229853002)(81156014)(107886003)(7736002)(8676002)(81166006)(14444005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2798;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r4VZqpJieqR5DOcJeLU3BJI2akbiIKOxVMZJbzuqkYU6rZeqJ7HswWbTyj0Bl8oOqwNUALZWOt2jsLpeny/iWO3K1SEsO9jF9Dye5O6ylYatd4WP4vybVJmEcU5KJFc1bwxhllUWsMs4Eup1DWrLX3DImzoqvCOrnyOtU2L1+RfSD/eQne6b19365roRDOXq0z5N0+97wwRznr8J1+mVCGltZLo+zVxS1mHaQ5/Rdekn4R0gBAIprYtDNIznLhgT2LK5pweFsmapEdFB18bfO6I1KX0lAnpWZu1cRpx8W5SDGYTlGuOcE+7QYMRWviVS3WLCNKyF24hsZaF8XCgttoSU/7M1JlVVgIerR1LwJrLVTnAEYphIXMYDDNZiNNtKLsoBHUNYkDV/zK58DNZDk9yiiUsqVeeeXLxbubhPfH8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59462a5b-7184-41d3-6abd-08d6efb8231a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 04:32:25.9777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2798
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, June 12, 2019 5:50 PM
> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> <markb@mellanox.com>; Parav Pandit <parav@mellanox.com>; Petr Vorel
> <pvorel@suse.cz>; Saeed Mahameed <saeedm@mellanox.com>; linux-
> netdev <netdev@vger.kernel.org>; Jiri Pirko <jiri@mellanox.com>
> Subject: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
> encap mode
>=20
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Devlink has UAPI declaration for encap mode, so there is no need to be
> loose on the data get/set by drivers.
>=20
> Update call sites to use enum devlink_eswitch_encap_mode instead of plain
> u8.
>=20
> Suggested-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 8 +++++---
>  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 6 ++++--
>  include/net/devlink.h                                     | 6 ++++--
>  net/core/devlink.c                                        | 6 ++++--
>  4 files changed, 17 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> index ed3fad689ec9..e264dfc64a6e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> @@ -175,7 +175,7 @@ struct mlx5_esw_offload {
>  	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
>  	u8 inline_mode;
>  	u64 num_flows;
> -	u8 encap;
> +	enum devlink_eswitch_encap_mode encap;
>  };
>=20
>  /* E-Switch MC FDB table hash node */
> @@ -356,9 +356,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct
> devlink *devlink, u8 mode,
>  					 struct netlink_ext_ack *extack);
>  int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8
> *mode);  int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, int
> nvfs, u8 *mode); -int mlx5_devlink_eswitch_encap_mode_set(struct devlink
> *devlink, u8 encap,
> +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> encap,
>  					struct netlink_ext_ack *extack);
> -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
> *encap);
> +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> *encap);
>  void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8
> rep_type);
>=20
>  int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw, diff --git
> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index e09ae27485ee..f1571163143d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -2137,7 +2137,8 @@ int mlx5_eswitch_inline_mode_get(struct
> mlx5_eswitch *esw, int nvfs, u8 *mode)
>  	return 0;
>  }
>=20
> -int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink, u8
> encap,
> +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> encap,
>  					struct netlink_ext_ack *extack)
>  {
>  	struct mlx5_core_dev *dev =3D devlink_priv(devlink); @@ -2186,7
> +2187,8 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink
> *devlink, u8 encap,
>  	return err;
>  }
>=20
> -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
> *encap)
> +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> *encap)
>  {
>  	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
>  	struct mlx5_eswitch *esw =3D dev->priv.eswitch; diff --git
> a/include/net/devlink.h b/include/net/devlink.h index
> 1c4adfb4195a..7a34fc586def 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -530,8 +530,10 @@ struct devlink_ops {
>  	int (*eswitch_inline_mode_get)(struct devlink *devlink, u8
> *p_inline_mode);
>  	int (*eswitch_inline_mode_set)(struct devlink *devlink, u8
> inline_mode,
>  				       struct netlink_ext_ack *extack);
> -	int (*eswitch_encap_mode_get)(struct devlink *devlink, u8
> *p_encap_mode);
> -	int (*eswitch_encap_mode_set)(struct devlink *devlink, u8
> encap_mode,
> +	int (*eswitch_encap_mode_get)(struct devlink *devlink,
> +				      enum devlink_eswitch_encap_mode
> *p_encap_mode);
> +	int (*eswitch_encap_mode_set)(struct devlink *devlink,
> +				      enum devlink_eswitch_encap_mode
> encap_mode,
>  				      struct netlink_ext_ack *extack);
>  	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
>  			struct netlink_ext_ack *extack);
> diff --git a/net/core/devlink.c b/net/core/devlink.c index
> d43bc52b8840..47ae69363b07 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -1552,7 +1552,8 @@ static int devlink_nl_eswitch_fill(struct sk_buff
> *msg, struct devlink *devlink,
>  				   u32 seq, int flags)
>  {
>  	const struct devlink_ops *ops =3D devlink->ops;
> -	u8 inline_mode, encap_mode;
> +	enum devlink_eswitch_encap_mode encap_mode;
> +	u8 inline_mode;
>  	void *hdr;
>  	int err =3D 0;
>  	u16 mode;
> @@ -1628,7 +1629,8 @@ static int devlink_nl_cmd_eswitch_set_doit(struct
> sk_buff *skb,  {
>  	struct devlink *devlink =3D info->user_ptr[0];
>  	const struct devlink_ops *ops =3D devlink->ops;
> -	u8 inline_mode, encap_mode;
> +	enum devlink_eswitch_encap_mode encap_mode;
> +	u8 inline_mode;
>  	int err =3D 0;
>  	u16 mode;
>=20
> --
> 2.20.1

Netdev follows reverse Christmas tree, but otherwise,
Reviewed-by: Parav Pandit <parav@mellanox.com>

