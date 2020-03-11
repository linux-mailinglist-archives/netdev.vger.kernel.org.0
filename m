Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343B818158D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 11:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCKKLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 06:11:21 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:6142
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgCKKLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 06:11:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViBBzCDFQjqkd/2HDGRc2VTafihQ8C5nA2rkWp50ED2R+7k9ONsNTTe544Vuh5HEJ2c72Ub6sp+0QwbXAn61a7vhSACk6yTvDe4wffAsvSfm3Zl3gr7g20rqsD/PUao7GKUfI0fhodcmfOJfrjbgZJO7aZ94hayIOjEeH1RUM3A2C/DH27UJtRVKA7Oozrpz6EgP+ZPf5iKzizLrPB6JCqOYzQDy7lPtuvHm1MnwDM11S6YLtfsODTpfHJG5ZRK8wbs8vsGV8tNAlv+xvSe2GgR8Lq4EV3leAZZgT9PRTBPwxtE9xnIrGIa6nYTXJvA/2DjCQZf/bzLdZoZLyD8rZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmMO2qypzngBkYrGh/zLrUfnSAuITQ1cXndvLY7JKQU=;
 b=QrySJpEvgaB+K4vljdN8PmhBLOyihkpiT0/3MTsmhGQ0MOlznOm2j/3Ozv3zUlcd8G2Mdcp8oPzt94D7lDqJQ9nH4g6GqO9/YLXMzjMWKQK2g2LugHL8AhMDy3uJXDRzfTSI+/ATJAp5FPLTZhQZF0KT66sNgkOJv015v2WEBO3XUY9yL4wL1HLWjiZx88vtXRzDpDv0FyEZz4ODpeve00rFO9XtrtJv9jrtrYYmdJH2ijDJgpmqAytyse8Vj4aVQT8iAgz37UcQwnPY33nCVKPXUnm38bcaoI1Ufob14LO/vw8rHX6LUQm5CLQI25vR7pf9IM5+AgW6G+3WLQbsvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmMO2qypzngBkYrGh/zLrUfnSAuITQ1cXndvLY7JKQU=;
 b=BxAtWaUrXI7Cc3Jhrl+BdRDRXj32gdUGfJXMX2fveAZY7xFewQb/NEtNCWedVnwpJeVOToZDTsh5KMkU+3RrsqjSt4QCFQGpJ45Q9OHtlm1y91dBqWvAzcRrIptsUTlX4lK9feuFLnmWezWqapKnZUzA2YkC4g1qkcOHRP1FQ8k=
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (52.133.57.143) by
 AM0PR05MB6322.eurprd05.prod.outlook.com (20.179.34.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 10:10:38 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::b16c:5fe0:ad0b:81af]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::b16c:5fe0:ad0b:81af%3]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 10:10:38 +0000
From:   Eli Cohen <eli@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [net 5/5] net/mlx5: Clear LAG notifier pointer after unregister
Thread-Topic: [net 5/5] net/mlx5: Clear LAG notifier pointer after unregister
Thread-Index: AQHV80RTfFk595Fhu0yXd0e2boIzuqhApc4AgAKMwzA=
Date:   Wed, 11 Mar 2020 10:10:38 +0000
Message-ID: <AM0PR05MB4786D1F16A12978B06DE7959C5FC0@AM0PR05MB4786.eurprd05.prod.outlook.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
 <20200305231739.227618-6-saeedm@mellanox.com>
 <AM0PR05MB48660149DA366D89137CADB4D1FE0@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB48660149DA366D89137CADB4D1FE0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eli@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8c1d9901-c617-4e17-7613-08d7c5a472d1
x-ms-traffictypediagnostic: AM0PR05MB6322:|AM0PR05MB6322:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB632201B92464DD62F5AFB3A5C5FC0@AM0PR05MB6322.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(199004)(7696005)(6506007)(2906002)(53546011)(110136005)(55016002)(52536014)(8936002)(186003)(26005)(71200400001)(8676002)(107886003)(33656002)(316002)(81166006)(81156014)(54906003)(5660300002)(86362001)(66446008)(64756008)(66946007)(9686003)(478600001)(66476007)(66556008)(4326008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6322;H:AM0PR05MB4786.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dEB6cbm4NWgc07aCSI6LghlBrVlpfEsTsmmhCPxqNXwg5xciTLA2xN8j52I0UHM8m1Zqq2c+5tJGBaVhmbtwDsZyfqzWVQrBgawc+QSsqE1UNBOxvnAOn9mz2NxLAmYVK9RPnMfBfyzJPYK54UETQWfE0Y0dUsBUfzqjyLLBYntI7LXwEdC4fWxYfl935Rgx9fcoziKNW0jXEGoF/LLpRbxwlJfffoM+D9kvg7gEoO3XkSbP2DSSiHSAG5Qau07jtqolQRxKDnjXrg4MCCVB8gOgwqzCLLlna7hhHFvX/AC7d7V4+K3X/BPEEk1eYWJrFlrb/BKPTdlnYl4/V5Y+hMWyH3zPSw/baLiwQNMW1InEMAKAgFM3fLFewMuzZdwmb4NIB5AoFDGbCjMpBgCkvGSb79MJ6UIC+KXNHeaHJoBJDUWnx/8MWs53S++/T+H9
x-ms-exchange-antispam-messagedata: U3iSBBQlCrTT26ULnq/cpbUg7TS3UdxBGwah1dsJ6vSRRN7v5UvvA4wPRbTBpt8BbZ357+vN3h23aPcWGS/X7WiUfyrb3ZvGf1OW1qieOhow6kFgS2MLk/ss06J3sL3J+488fSPqCb3IMV8hku08fA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1d9901-c617-4e17-7613-08d7c5a472d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 10:10:38.6573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OGRTcZQBlXP1cEeGK8LBXmTGkF2zItKVKDW5PJ6sTer+dd6+FJNmynLSHrvbn06vK6kR5UGoXOFEeLK5yWChAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6322
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Parav,

My patch did not fix the issue you are quoting below with call trace. It  h=
as been fixed by this patch:
commit e387f7d5fccf95299135c88b799184c3bef6a705
Author: Jiri Pirko <jiri@mellanox.com>
Date:   Thu Feb 27 08:22:10 2020 +0100

    mlx5: register lag notifier for init network namespace only

My fix is straightforward. Look at the patch.


-----Original Message-----
From: Parav Pandit <parav@mellanox.com>=20
Sent: Monday, March 9, 2020 9:09 PM
To: Saeed Mahameed <saeedm@mellanox.com>; David S. Miller <davem@davemloft.=
net>
Cc: netdev@vger.kernel.org; Eli Cohen <eli@mellanox.com>; Vlad Buslov <vlad=
bu@mellanox.com>; Raed Salem <raeds@mellanox.com>; Saeed Mahameed <saeedm@m=
ellanox.com>
Subject: RE: [net 5/5] net/mlx5: Clear LAG notifier pointer after unregiste=
r

Hi Eli,

> Sent: Thursday, March 5, 2020 5:18 PM
> To: David S. Miller <davem@davemloft.net>
>=20
> From: Eli Cohen <eli@mellanox.com>
>=20
> After returning from unregister_netdevice_notifier_dev_net(), set the=20
> notifier_call field to NULL so successive call to mlx5_lag_add() will=20
> function as expected.
>=20
> Fixes: 7907f23adc18 ("net/mlx5: Implement RoCE LAG feature")
> Signed-off-by: Eli Cohen <eli@mellanox.com>
> Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Raed Salem <raeds@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lag.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> index 8e19f6ab8393..93052b07c76c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> @@ -615,8 +615,10 @@ void mlx5_lag_remove(struct mlx5_core_dev *dev)
>  			break;
>=20
>  	if (i =3D=3D MLX5_MAX_PORTS) {
> -		if (ldev->nb.notifier_call)
> +		if (ldev->nb.notifier_call) {
>  			unregister_netdevice_notifier_net(&init_net, &ldev-
> >nb);
> +			ldev->nb.notifier_call =3D NULL;
> +		}
>  		mlx5_lag_mp_cleanup(ldev);
>  		cancel_delayed_work_sync(&ldev->bond_work);
>  		mlx5_lag_dev_free(ldev);
> --
> 2.24.1

I have noticed this and applied this local change to avoid below call trace=
 and reported it to Leon few days back in different discussion.

But I fail to justify that this was/is the right fix. To me it seems to hid=
e another bug.
Can you please explain the flow why mlx5_lag_remove() will be called twice =
with i =3D 2 because of which null check is needed to avoid unregister_noti=
fier second time?

RIP: 0010:__list_del_entry_valid+0x7c/0xa0
unregister_netdevice_notifier_dev_net+0x1f/0x70
mlx5_lag_remove+0x61/0xf0 [mlx5_core]
mlx5e_detach_netdev+0x24/0x50 [mlx5_core]
mlx5e_detach+0x36/0x40 [mlx5_core]
mlx5e_remove+0x48/0x60 [mlx5_core]
mlx5_remove_device+0xb0/0xc0 [mlx5_core]
mlx5_unregister_interface+0x39/0x90 [mlx5_core]
cleanup+0x5/0xdd1 [mlx5_core]

