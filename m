Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABFE310AE3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 13:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBEMHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 07:07:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2273 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhBEMF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:05:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601d345e0000>; Fri, 05 Feb 2021 04:04:46 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 12:04:46 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.53) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 5 Feb 2021 12:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMch16aRqcJ+WpxbThHfi2g+B8l5nv496GlSzMp77JFQpp6FnQJzKBOcIyxA2ktXzfKwQRkwLFGm9ZCPw/+aAcJ6dhqWcaZ0vTwGqG1PhmwdSA0cVYkU+1SNM/it+6gm1qahb1CLb0daK0yQTLCiABliHLFBhRVjKBwCVlgWMW8ie48VZulW9tivDSoSF9dZ9ebVjcFsfdR79r0z5E5Xy8jrtkphe9kCbl4yorBfnUm7V+mV+iiO/FK05PFJ/t15XqdIDRjeT2jB3NjMnkJBq9Fh7/BLHmrSeSZKZZBsmLEEByfpDJ0S5MSE5v/kIOuTaHbPTnkjFA4o3s+V1BGevA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fKqLWPNkEIJ8zIL45IrM+RE4JE8ZDqnYpYXZeGKMJo=;
 b=eSdPfCQvmax3cXBWvugrllhanU0r5RB/IzyzTw8BLupmKkQ2y8p9aahE6jrao5FmEipWl+yyTfEETsq6HCvnthHv7Dd17gWSAYSyfivwGclxmfvz7I+CiOSpPHlTK7gCmi5pZSEMVD0Gns4Wm4V8gqggNNRjzCt/3v+wEvlcSLvC407/WG0qSe9SOi8A/6LBwC/P9I3gWrQ+GaXhMbihS2KMWw3bl6hPLJjxragHur0QH3qw/O2CBQjDCvWXxGoc/3WfSwmIJtsIPzF9VlxRmkK9b7ald5b/Ax0XQ6HW1nWSIZl2qEk0TG4wi4O3MxzmmweG71VUipKO9ajoPqbzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3032.namprd12.prod.outlook.com (2603:10b6:a03:dd::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 12:04:44 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3805.033; Fri, 5 Feb 2021
 12:04:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/mlx5: docs: correct section reference in table of
 contents
Thread-Topic: [PATCH] net/mlx5: docs: correct section reference in table of
 contents
Thread-Index: AQHW+6UDTeAW+FAc70+05HVqdx779apJdrkQ
Date:   Fri, 5 Feb 2021 12:04:43 +0000
Message-ID: <BY5PR12MB432262D2F829A3D14D584AD1DCB29@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210205095506.29146-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20210205095506.29146-1-lukas.bulwahn@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed2c6ce8-93d4-4040-b19e-08d8c9ce39b0
x-ms-traffictypediagnostic: BYAPR12MB3032:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB303287FA0E147CCAC25A22F0DCB29@BYAPR12MB3032.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f7i3u3IiNfxtpok3azMHTezKJeevnGIGE9W+qV/PzpnUTx2oiPx9T/Xo+ibkOpG3MfaKb83GPM5C0X40/Mu9jaBbDlQjiXzCH8L2NkPz6Zi19OWpQf6ZUzZEFzfxNjcAU5+f93NpOaEvYYSet/SuIvsFKJAl3+A4ti1GlA/jHJhF5Z8aj6SjcFZy0Q+J7kj3XiC22DLyAdjVX5BevfrWF6yDwFasY3OQ4kJ/3dc5n7iBxFLUxgS5bB+1xn51t85GwIeeOFEaVGEEymd0cU0qxX3ftfEXM78LTzY5konajGHXhDuOK/12wQI/Qr6nuhmLzY1Us1C9WsrIdheRjvx3N699uyDMfv6VsS9jeW/nc+FewcgEIJK9vsgava37xt7kNLdlkHTFCXBiWM4z1c8bWWtQsw6Tr6fUjl563vDq0AbqQYb02Bk9foygCGe/T8sHTjevHBVGktGXyWuc6J+R+msMgmpVWRPfewbhVMqDNURJfQPuK4visALYJRgZn0WiXjRsvjBDtuUbDLhVIJFjuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(64756008)(66556008)(55016002)(186003)(66476007)(9686003)(8676002)(478600001)(4326008)(86362001)(66946007)(66446008)(52536014)(7696005)(2906002)(5660300002)(6506007)(33656002)(8936002)(316002)(83380400001)(110136005)(71200400001)(76116006)(26005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nAU/dHXHzBXMp+1MSDAHXKSR1pPQ73GLBy+D6e/RXesTYsMg1BtR7BEA7uyt?=
 =?us-ascii?Q?eURoM4DVscBTqlfBkKDse+lWL8fzKRsH6zfxFelG9jAjVSCt9h5EiYxr/BNQ?=
 =?us-ascii?Q?Lq0QAHW6GfyxLY531ZGbxI8b3Vk5wnJXCA7n/4R3oR3m7c+JCnvbGnQiNI/K?=
 =?us-ascii?Q?TFvVMhi+LjaTY8O70BoNbdN+mAa2RQvMeOFYrmfikrr5u6V6FD0e90NgdhoA?=
 =?us-ascii?Q?wTfderQPa6lEaKcR3fV9MP7KULlUXC1UdxBGVSd0xWuyi5CLOiDjtC7Q1OOJ?=
 =?us-ascii?Q?S6htGPrJb0TLwVCp5gO6kWgCNwc8Zyjm+hjZwuf4EOCYVLKEtHV7mZBHJePf?=
 =?us-ascii?Q?13TkvSobX7eAIZluxRpQXi/wF+QLajlN0zuQBsW+SkEuL96JbxUjee6+7J1Y?=
 =?us-ascii?Q?Kb67kz0ev+MNK0l3d90sCu7L9WlkB12FZrcnlU/K27CbIHC2IaUg4hGNBTD1?=
 =?us-ascii?Q?Vi/jF/NjI4MKndTQbaoFCemT0WuPia6D1x5zBBclagPRVTGJLD2zg5otNrCK?=
 =?us-ascii?Q?7Dsyh4w2HTsKvW5dBMUQcfpAlEssPueKpvYTftrV4NSC3n0VuYn0wkoFL3XD?=
 =?us-ascii?Q?py9q9C3/j+MVbUDRdEUVxhKq7VVy1nyu0Z4u0On1GysKw3kc883xXirIncqq?=
 =?us-ascii?Q?dkVuuQkh+xeAROignckmZla2TAj9QqSsKYL9R9DmmpS+SdCWWidPpE9RHkcU?=
 =?us-ascii?Q?RhX93mbLtDoC5gA56Qa01kuPgxIbTjuAkkUptTD+8aykKLQugO8/d6yIBuj0?=
 =?us-ascii?Q?SmipZV9OrZlrJjCQuRxzgBnni3AHAGiU+ZlUr5qtdjCcxnRvLwzs0Mhbg2fW?=
 =?us-ascii?Q?E8cPoHbK1YP9o+kWCD0NJ2RoQGkbu68cUaEwlxM1TIdeZsBDeUzGLSiJfHC0?=
 =?us-ascii?Q?SkotXDeVaWhEUgikX7Pd7KEo0MB66Gq3KK/erMRv5SBrcG9FPE9/niZrFJBE?=
 =?us-ascii?Q?YWy0BiNFg2MKCiDcfju3+BO8a0eySGnvMdMlD2UEb7f/EPHuIwGoOmKuKriG?=
 =?us-ascii?Q?DXtMyXW9xR+DZG9QDPMBqfyeZFbCOTQmkRchVue9zsL+MspojNiawDE4RJUB?=
 =?us-ascii?Q?dV2bmKS/vhivz9ec7urxdjTvv6vgbmLXtJHGQyIpJCFAr/wkYXBUDOxG4oro?=
 =?us-ascii?Q?xJqCg9dGghpRl0MmGejSHFFLwxkx53nFwcNJl9+UWz65hTTfyvYzXhJwrp0j?=
 =?us-ascii?Q?rXeDbg7FToqhvNo2HLEM+LVtdhOuD7kOJOizgN60L6vTN8hqmLT0xUvr2qtc?=
 =?us-ascii?Q?uT03AbXw+8mfJs1rvH7QLE1DFp/kZanKqvg8v8WEewjUQRVE0EXFrbmFfaEi?=
 =?us-ascii?Q?qoO7AZtwxIK68zcf3gy5Bcml?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2c6ce8-93d4-4040-b19e-08d8c9ce39b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 12:04:44.0037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WukvqJ1ZALvBXWT+w0hT9cZWNMYd2WVSF14c4MwDAB4s9aLvBdP24q7/mbMp2TLl4Rdc1vlh8BCPag29PbIohw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3032
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612526686; bh=1fKqLWPNkEIJ8zIL45IrM+RE4JE8ZDqnYpYXZeGKMJo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-header:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=E0Q7UH90YVKtwKsQQdvYUIijGV1EYuWiQ3SnQ4xrtrZ4Jm7qDVZE32KVyjbF5rUVk
         PJNT2ph5UGKpEwugATx9JIHya8otlJexfEKRUrli66Fe8I9gvOeULdWlLNkycss4q2
         iQYfSxzwJEEEcc3XHwzJLD3kU8ldPs5KJViC93KRJ6du0cnwDhdZj0PhoxPOsiV8VG
         9aZ8h25bUf5xJ2fVq13/Opt7GxDCaX4Jzf6qNiUy6uw/zIFWJ1EMEpnfavO/HxTAG/
         IrMXNOLTKgY96Tmdxs088c3RuWxyLRlSVUFXjUPLadk+bvmMljJ2lSm5MbdUtXY84C
         hCGoPPpqIXtlw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Sent: Friday, February 5, 2021 3:25 PM
>=20
> Commit 142d93d12dc1 ("net/mlx5: Add devlink subfunction port
> documentation") refers to a section 'mlx5 port function' in the table of
> contents, but includes a section 'mlx5 function attributes' instead.
>=20
> Hence, make htmldocs warns:
>=20
>   mlx5.rst:16: WARNING: Unknown target name: "mlx5 port function".
>=20
> Correct the section reference in table of contents to the actual name of
> section in the documentation.
>=20
> Also, tune another section underline while visiting this document.
>=20
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Saeed, please pick this patch for your -next tree on top of the commit ab=
ove.
>=20
>  .../networking/device_drivers/ethernet/mellanox/mlx5.rst      | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git
> a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
> b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
> index a1b32fcd0d76..1b7e32d8a61b 100644
> --- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
> +++
> b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
> @@ -13,12 +13,12 @@ Contents
>  - `Devlink info`_
>  - `Devlink parameters`_
>  - `mlx5 subfunction`_
> -- `mlx5 port function`_
> +- `mlx5 function attributes`_
>  - `Devlink health reporters`_
>  - `mlx5 tracepoints`_
>=20
>  Enabling the driver and kconfig options -
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>  | mlx5 core is modular and most of the major mlx5 core driver features c=
an
> be selected (compiled in/out)  | at build time via kernel Kconfig flags.
> --
> 2.17.1

Thanks.
Reviewed-by: Parav Pandit <parav@nvidia.com>
