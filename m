Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386503213B6
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhBVKE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:04:57 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14950 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhBVKCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 05:02:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603381180000>; Mon, 22 Feb 2021 02:02:00 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 10:01:59 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 10:01:57 +0000
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 22 Feb 2021 10:01:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2RG+KmSAlCWmhD69zSFF7A3nmAkGmWYcATv1S7J5EmEySEUbDOJDRMlAyly+8RO/OdkP3OzcfCx8JE+wJ+YHy67IHyadRslD4ATwSTB4s9guwVjp+ldhDww6NDjrFYTovrRMgla6mJ02PX4ZBMFfCS5a7vB5Nr++gqgdvrSFLTROVg7gxsnFfx8TDYPu2aDpGXw1VOV7RCdoudFgO76qYX7hHgQVg2EKT0QFozbYPc9O6B+YKlmvaSvIW7AriZr1Yw7JJOybLfv8nehqwXfl/tBqlwpZby9JRAnEuPx61/m/fe2q6jdDSVIL2CUwiBowPAeCiEHokBdinj0/DvBsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Pg4MXnHs9TsVSF6a/KVT/i741Q2xSyvjx00nG2UlA0=;
 b=XJ3RRGYXYdCbvX+xqeSzAR9liHm+cLxxP9DO/moDFuyXRlUcYi+sViDArZ/4vX/JiEn9zeaC15ktYSYwZASUx511jy4ffD1R8H97QeCj5ug3gEGhSDXBWTvPLTwPduV0sYb+hAFxqWx5BJjvb2aVaPjq6j1XkUvLnfjnbUpQrBSFz4Nl5Nv9EHygq0ImZEog9GlwtA9VjaQsMt8A59oRCgMOd10w/p/lFke/3AcwJZSo35HFvFjdSvEKgOGQu+tt75HIq0AmlxKew+kkR0Sjx0mhQ8MsL+tdayqevnl0X0w0OOiIR3VbkvFLmkuaA2VKzCPMHn0DTEi7yS0tuBgQLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3906.namprd12.prod.outlook.com (2603:10b6:a03:1a9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Mon, 22 Feb
 2021 10:01:55 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3868.033; Mon, 22 Feb 2021
 10:01:55 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/mlx5: remove unneeded semicolon
Thread-Topic: [PATCH] net/mlx5: remove unneeded semicolon
Thread-Index: AQHXCQFdZeK6pe8bzk+WL+Rwiz5bb6pj8VNA
Date:   Mon, 22 Feb 2021 10:01:54 +0000
Message-ID: <BY5PR12MB4322C25D61EC6E4549370917DC819@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <1613987819-43161-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1613987819-43161-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [122.166.131.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02458182-f8b3-405a-dd4d-08d8d718e266
x-ms-traffictypediagnostic: BY5PR12MB3906:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB390660785DE53AA28CC50760DC819@BY5PR12MB3906.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:473;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 05WpNDa4BkYozgGF+yU3Sbc2fcnR7weEYcG4H6D8jt4Iem3cns24lvxJXWg5mxwYU10kjWSrkEivS46wSEbfyRlYgz31vpVY7eM3T4KlBaaJafo2OlahMuSHPW0lIBRl/MzOEeX2JeNN6/2DbaNESrXFQfY0E+PefhBJFuxHzDNrngxd0yVTNCxEj2GolBZx2QZwHiqfZg6ddzCiya5QlgjSqI8m/DJVqPmn++Wrf3DIT4gukukYqa9mCUwM3eoqTGPvBtNe4wUIHvQ23NO565UTTAXZh6lKjfnBjzd7b/Zrp8ec68vGQ10AOZykHBeLNmvp6HGismnq6+vLZnKX0wsqxHa2B61QZop5bsGHx+0zAni934HheELjOf2GfwI6HeCiS2F+0May+5HPWZ7HIc2Sc4Xx+hrWHBv+Gb0Zyd0DduWxZNplLc3gGygNbSYiPzbTa+vaynCEriQp30/PD7s/JoM51HDVfs518QpZD9R32PUYdVFoGhJs2EdE2446S2JFZ1NZuTTicJSe8LeUvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(478600001)(2906002)(83380400001)(54906003)(7696005)(52536014)(76116006)(6506007)(6636002)(26005)(66946007)(66476007)(64756008)(66556008)(66446008)(186003)(71200400001)(8676002)(9686003)(4744005)(33656002)(4326008)(110136005)(316002)(5660300002)(55016002)(8936002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?y7H78NyihpehakaX9Moz4jI6b+O45QcVSxGonxQk+c7TjfjIB3sAhJd+LlWp?=
 =?us-ascii?Q?ZD+A8/T7OxVatr7blW6w3U54Nunl7BWmj/lQA8czuT90Ietx5+bVPH2k2eIC?=
 =?us-ascii?Q?9Gwap+7hq031pm4SzbfIXJ7EXChGf3q5/HB1Gu82SYgK+sgChTf8FVOc1Bpl?=
 =?us-ascii?Q?DC5ars5tBXlaML/CouHWadC6y4X4gNkt7DwvOqS+LabYMCcue2W9rKVi6qnn?=
 =?us-ascii?Q?JJUYyTeIvq7gieBV0NNa9r0poz9iBLG/ZGNTIlHyKnjScyHLKFUJGpP3Biwj?=
 =?us-ascii?Q?shQyV1Q5jJyTo3KtgGKdrDdgxpabmaeb0WZCmNk5uKazWPI+JNquwABxCE3X?=
 =?us-ascii?Q?YgOluQF8VQPgx/6iLvvypv78EnV/J97ijoDeFEOKxbhXbwgTt6ajsxhDkNoG?=
 =?us-ascii?Q?O8sQC5ZJCugaW7Lt1/6ilv3GRPHuagKwtvV0OeVIB+k+CBROy4YOrneErPQs?=
 =?us-ascii?Q?9/ozqSbge+uAPxnmpXH4Vcjchbc6YWjJpTJ6RPSnOdwem1MrqmQ4+ihICdxE?=
 =?us-ascii?Q?gFfvSFaDewBKToH/KN/taz9T9keo0mCBVNMkp8vO4wqxPNBtxxrNoqbjkklu?=
 =?us-ascii?Q?UntLvtyrRMFjInQ7F4/d1SU//zVym0U8p4yU2EB5aRPd+vhpJ0DYzIwX1lxr?=
 =?us-ascii?Q?n7zuVOKw4mow5ZXnvTurFJXw/FpseDqvFVf+/gDTGOLRt9Ux/dUDdGsHh6Go?=
 =?us-ascii?Q?b60PLd0KtJULFUVmChoTeRjPaGBKn2HAmFuAAdXIygxqsuMLOfglgveY/K8d?=
 =?us-ascii?Q?w1n3ZKVnfwzk2qrmxZECwRSZYfbd0b7DHbq2CXAjXDvE3RVNWPPETxEkI5yb?=
 =?us-ascii?Q?ZUGNRrfJbwJUCyfK7hVUdfzogWJKPUlxISM0tcWxxzRYt9BEu8dO80BgRcM+?=
 =?us-ascii?Q?pxqpdc81Aj1XP5vxLF9Mn9+dyPUAm+sZ8tL8vKxWG/ZVjEaqENkrTsrSjgs0?=
 =?us-ascii?Q?9tCv39HcNRX0qiKoJyAT3DMqBN1ECm3O5ZTy3H6r04muOidZi2PQDd43CoL6?=
 =?us-ascii?Q?pAv7DbnwGwK+KqMl5KMdti5uLms2vHiyT6hsCqBV3BfsvEHKzKMsE5CJXl6X?=
 =?us-ascii?Q?iXnukCw3DO109Z/8iq0hZYEQphRgx5hzS3iiCJdYe8oajpfHdaAzZY48LrDw?=
 =?us-ascii?Q?bsczB4fTro1aQy2jmAc2L63XiioAkn4vEs5EMkFyyNnTa4UBgqqHRT4iPUHE?=
 =?us-ascii?Q?aXEhetzY/pGqIWbhLp04BZcJcF611K59p5mtvT53Q2cczCtwVzq74gzKjTPM?=
 =?us-ascii?Q?w26dbWmKfjbo1FMiTrOKqJtmfDU9jpHobdMP4+vPfb5oj1wDSc2OEBEw7J5e?=
 =?us-ascii?Q?drr65jcjjGieCMa4tMzEBZ/J?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02458182-f8b3-405a-dd4d-08d8d718e266
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2021 10:01:54.9707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+qcryiGj1fDiNI9SuzJ3TLpY3LIMWzUF+qwHX2Z8yP/wepASwh7dbXlalAreW0ih01Wwsynf+oeYQvxfx/qJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3906
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613988120; bh=3Pg4MXnHs9TsVSF6a/KVT/i741Q2xSyvjx00nG2UlA0=;
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
        b=nJMmb5tcrmwxmSMZ/J877ZiFeofH0kP/mc4+GeQCwcUdYjwNB1KQtmDs7+kwUjmDO
         T9m0hzj8l1lZE0DDX4R5bLhREQOv2Ai1QM39TXldpgG04fF5DbiYEiuT97WQ+lmCvO
         sF3uyHB3Gpeh/SHMYpN8WfOX6b6WISOd02v13AAuSdUDksd0aT4igJiXupRWGVbIKI
         VZk/U2diYATi8+uqQKdYylKlVpzTzbPlQNO0uuNAWn4Sd7LejwPyIbUp/3aKktu2Q5
         iGfPJ0APIUol/D/UWNfSXW/TlLrjP65z90K40OzWMZt0XCpLayHlOtmBvk9jIJfJxF
         2e2v1gs55YkTw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Sent: Monday, February 22, 2021 3:27 PM
>=20
> Fix the following coccicheck warnings:
>=20
> ./drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c:495:2-3: Unneeded
> semicolon.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> index c2ba41b..60a6328 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> @@ -492,7 +492,7 @@ static int mlx5_sf_esw_event(struct notifier_block
> *nb, unsigned long event, voi
>  		break;
>  	default:
>  		break;
> -	};
> +	}
>=20
>  	return 0;
>  }
> --
> 1.8.3.1

Reviewed-by: Parav Pandit <parav@nvidia.com>

