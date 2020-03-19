Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4424018B86B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgCSN5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:57:18 -0400
Received: from mail-eopbgr60069.outbound.protection.outlook.com ([40.107.6.69]:56338
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727180AbgCSN5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 09:57:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoUJFMp8iR3hSngbrGuaNZpj9rOUHo+Bb/MMySBZjY8GOUPi6a+u0wEP1tc9ngjbF4V18R5bqclMj1J3qqIbCVoEeVyiZDuqE27W3c2KP8+DXfdM9dSnJfBaQlX/ypX5nxRHddlfuFpkzTvOFz3g6D9jHHxodOjtJjbIlCFpCueQAa32MgD84LerMi7wg0r0+EMni4vkeWFA6yx2VcIvTlSe0wgdgA7U39lsPvuBE4xeVXh5EIo2PX5QeyVFgILQ5p01d7qoPdCSJoxOl+29Ayg26JK4aw5R2CbpEnKlCegD4R07NcGJAEvrFtC4D6lY0kdapU+81qyUxg/VoNsiCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcwHihxbo/EQ/T/8nPaDSgdkf6pYRjCT6SdkaSK7/3A=;
 b=bKyiJdWUFAZIDdwHS5nCojf9Klz9eNTlUq8N55ywSl3DdtkyvR35vhRb+dTRdFJcdQUGCevQWVaq2yyBTQgsAbOI29awlXnpeZDE0l+vR65+dXlbB7JlSix90A98wegK0dhn+m78pfl6i9VGkv1tfCoaZ6z1XgEi2bJmnjCmXxpxj4lN5/xHWHlHVpuJiFeeQdEJ+FZ+gMPDcc+yHaEgnzhgcMldmFcAdw2rLp+zvmaRa7L5l1e3o3fH3qASv6UYTivk9/wZPJhfkqSOxZLDzTERYk6gWpT7DJyHLZdZ1VepPgo8o6RtnPo3vu8FMTKzYWDbf+VSVgC8j9LQaFK6FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcwHihxbo/EQ/T/8nPaDSgdkf6pYRjCT6SdkaSK7/3A=;
 b=L/rf0dj2B9uv20nkm4k5MPDq/2XPTRWqW8g64rLUg/VE5zVtaurGgisYgOTimTCaF7adLcrdnJedIpXShr3e1ckUzgRVSGH2mghTMlAN8K+0XdTXkmfOyBuKmvwGp2Jyj+K8ZvnAkwlhmzUpXQXiIypLK2LOrDanZdS5m1OgXbw=
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6150.eurprd05.prod.outlook.com (20.178.93.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Thu, 19 Mar 2020 13:57:15 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.025; Thu, 19 Mar 2020
 13:57:14 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH net-next v2 0/2] net/mlx5e: add indr block support in the
 FT mode
Thread-Topic: [PATCH net-next v2 0/2] net/mlx5e: add indr block support in the
 FT mode
Thread-Index: AQHV/QhAygadKPDapEmQSWIHvYFGZahP8nYl
Date:   Thu, 19 Mar 2020 13:57:14 +0000
Message-ID: <AM6PR05MB5096147A19D4215F0653BF32CFF40@AM6PR05MB5096.eurprd05.prod.outlook.com>
References: <1584523959-6587-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1584523959-6587-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-originating-ip: [5.29.240.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cf46820a-3057-4d5e-d722-08d7cc0d6dd4
x-ms-traffictypediagnostic: AM6PR05MB6150:|AM6PR05MB6150:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB615042A69790C711436C8929CFF40@AM6PR05MB6150.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 0347410860
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(199004)(8676002)(9686003)(186003)(26005)(478600001)(55016002)(66476007)(71200400001)(76116006)(66446008)(316002)(86362001)(6636002)(52536014)(81156014)(66556008)(66946007)(64756008)(7696005)(2906002)(81166006)(5660300002)(54906003)(110136005)(8936002)(53546011)(6506007)(107886003)(4326008)(33656002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6150;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rqzilfscHVZQ2NZ+VSEy5WC5vOfc9XfWEXP78FFwZ83rjlPPxVBFdvnq0toMJL/3dDWaDNJOyAiIQpwfoQKsiPrWrN0hnvA9EEt2gHhViFrkhXw8S6vFMXvn/zU5qFurTakB/smuf0TfCM5GKv6ZwVlPY2P358KA8b4Ubw7YnVH+oVZHKywcR6z7wsH0hmJUiMhnBjOGO8h04HbO+Z2gM/vXE6DJufr2oi+aKAhYUHiLouDMcJ9qIFOmQ231VUv2MyVHqnSRMGSrqpuaEEQP61vIKjhcDiYbJhePGfE0P6/+1sMBM5QyEah/6qWpH4iYPdnn5wVw2vh2FeqZJcugOUyujDkCtrdfBDG3Og/XBt8c4zVSX5lNTPo1tn0AtN7GGelf8TZseaOuJ8UKsMwtJuVzZ9kObQX9Gq9WEM6AxHfjQ079gHj9NuK2+Cr78KIh
x-ms-exchange-antispam-messagedata: LuRPvYswgwBn9qGlmYHxRFt1gOcvtuGTp3eYYncrUNSCqAbiCGJrn7TUP2DanUPuH7YdLzMXTSfT/Fqn8pNgu9SsgX76PrzI4+opLC8A3JKblF7Vtsp3OR/SLY3t+9Jo0HzPjjk+YVDBuvK5XWLxrQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf46820a-3057-4d5e-d722-08d7cc0d6dd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2020 13:57:14.4467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XjbLxblRZUcYgTYOE92WdSLNBAOOHEipysdDy690qYLeRV68gTgm/+HTr34ACkGss9xJYOlyX3ykde3Rl7xPcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+cc vlad

________________________________________
From: wenxu@ucloud.cn <wenxu@ucloud.cn>
Sent: Wednesday, March 18, 2020 11:32 AM
To: Saeed Mahameed; Paul Blakey
Cc: netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/2] net/mlx5e: add indr block support in the F=
T mode

From: wenxu <wenxu@ucloud.cn>


wenxu (2):
  net/mlx5e: refactor indr setup block
  net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 92 ++++++++++++++++++--=
----
 1 file changed, 71 insertions(+), 21 deletions(-)

--
1.8.3.1

