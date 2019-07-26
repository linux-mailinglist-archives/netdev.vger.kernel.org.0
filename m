Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BFC764BA
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfGZLnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:43:55 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:57602
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbfGZLny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 07:43:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGMBqoBJC9WpBK+7RWndBibF6sK8yfCRWpnUxri7ggbmEGmk/Aqq30krCHv3MM15y1zoTZR7h83rkT2VIVX2F6yn2VXs1iluv2cQXbMtqRe70FGGcvAtNqe6dAg8urFLo+TNMX0XVizuI2wCLRNCxnauUYm/phyb5KxwaBvL0EP1WwArAtCGHLElf9fXF8hZBjLyej3SU5rR+et+iKLc0r9n3umYCZm07oGZXEqIrfRAKK4zgGnDgnlckG1kEj5b3rYpzBG1CpE85BILNxz3Brc8sglWU/+yPxa3waCoqaMRsM8xqLEMvXrfeMQpmsfoMYV7iKQl+4siAceYXcmIbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiXDLimfLvD21N9GkJBn0Xyz1FDMeni4l/2YAYB1rmM=;
 b=jSmJWL/ZFyJIrf1iYX4NWACmC7CVfwL+j4c58nalHg12d8EiquEnnyv8hycVrVRhKYNtLLqSh5eH1lLFjF26OinilrUDf1LgNi4SbmPDLGmOyw4ZdAZ5ouifqdIcvBI04HI3G0lxMMLw5luN3iYo2ZcO9D7cXPk6464SLWLzZNtZbCp5Q5z/PzfstIey39eI2a0Hdvg/06YRxg+4a+F3JwSsFYCossD3mnOgUz1BjdtNcjwd7shRUPcDUibfjTnvCIbqdjRo2CsT4OwVl+E1UpAK12Qeey+gwARAlREinzlvJHCrVfgfyWHWM/Cv/l/bYmUPg0nF+k3xnFvWlu1g2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiXDLimfLvD21N9GkJBn0Xyz1FDMeni4l/2YAYB1rmM=;
 b=jlJsCVRgulaMPj3ztFKj6SRx2ALJz4J3uiWVcJkiwRwqHqryS7DI0PwDcx3sk6tW+5W8zJ6h8XaE0i9RYS6NkP4+lW6+3m4LZLN3sxRE9qkYXDHep7lyJ0xhLKplrRN3xKmneLsO8CTJ4koonVgCkEUwoJhzvy16LT3WC7Pw5uw=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4815.eurprd05.prod.outlook.com (20.177.50.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Fri, 26 Jul 2019 11:43:49 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::a083:d09c:aeff:c7ed]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::a083:d09c:aeff:c7ed%5]) with mapi id 15.20.2094.013; Fri, 26 Jul 2019
 11:43:49 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/3] flow_offload: move tc indirect block to
 flow offload
Thread-Topic: [PATCH net-next v2 1/3] flow_offload: move tc indirect block to
 flow offload
Thread-Index: AQHVQ3n4OBm62/Fq/0mMjhuHnYCx4Kbcx9AA
Date:   Fri, 26 Jul 2019 11:43:49 +0000
Message-ID: <vbfk1c5nhql.fsf@mellanox.com>
References: <1564121869-3398-1-git-send-email-wenxu@ucloud.cn>
 <1564121869-3398-2-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1564121869-3398-2-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0130.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::22) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4cbcc4a-f244-4d3f-c545-08d711be8698
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4815;
x-ms-traffictypediagnostic: VI1PR05MB4815:
x-microsoft-antispam-prvs: <VI1PR05MB4815B9732A0A54E391B35C81ADC00@VI1PR05MB4815.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(6246003)(66476007)(4326008)(7736002)(6116002)(305945005)(25786009)(3846002)(5640700003)(8676002)(2906002)(229853002)(6486002)(11346002)(26005)(66446008)(66066001)(36756003)(76176011)(5660300002)(71190400001)(476003)(102836004)(53936002)(186003)(8936002)(478600001)(6916009)(52116002)(64756008)(2616005)(6506007)(66946007)(54906003)(71200400001)(316002)(1730700003)(81156014)(81166006)(386003)(256004)(2501003)(66556008)(486006)(14454004)(2351001)(99286004)(6436002)(68736007)(6512007)(86362001)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4815;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MV7R7BIMkpQN9wBEZt8iPGzr/VmEC/E1J9Tt/mEJV89v4xKUfemvmc9UzzfOPPms9WIbuztuPJ9Ou2bC8iNd5T5sd4l7a3Nw8WgKKUNhg3POaQrwp3/WeErsE1StTyoASLDxOr7nrymiDAwFB1jMRWu0mtle5Vepd5eUhnluOG0yBsn/Vs3XXGoL/FhFb+zlPdqhdocW8iuO/cqp57msvxo2j6Pmp6wsAVnnFklcrSRKHYhpxAqBO0Ag9ZE5ef8m+/Uq74klgt/IFFW+7JzmSNkdDU1qstJ+oBxgOe0yCXT+DLyvzci+kxVI46ZgGar3F1SEE6DCdjMo2YSWd6nFjEvPzy1SLZYPnw5f6xSwUJashMGqVUiJqPS8W6sIUJk8IqyuojeoNfczBm6DF/qPo8EfHG+VUG664bVojItVelY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4cbcc4a-f244-4d3f-c545-08d711be8698
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 11:43:49.7580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vladbu@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 26 Jul 2019 at 09:17, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> move tc indirect block to flow_offload and rename
> it to flow indirect block.The nf_tables can use the
> indr block architecture.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: make use of flow_block from Pablo
>     flow_indr_rhashtable_init advice by jakub.kicinski
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  10 +-
>  .../net/ethernet/netronome/nfp/flower/offload.c    |  10 +-
>  include/net/flow_offload.h                         |  41 ++++
>  include/net/pkt_cls.h                              |  35 ----
>  include/net/sch_generic.h                          |   3 -
>  net/core/flow_offload.c                            | 190 +++++++++++++++=
++
>  net/sched/cls_api.c                                | 231 ++-------------=
------
>  7 files changed, 261 insertions(+), 259 deletions(-)
>

[...]

> +
> +int flow_indr_rhashtable_init(void)
> +{
> +	static bool rhash_table_init;
> +	int err =3D 0;
> +
> +	if (rhash_table_init)
> +		return 0;
> +
> +	err =3D rhashtable_init(&indr_setup_block_ht,
> +			      &flow_indr_setup_block_ht_params);
> +	if (err)
> +		return err;
> +
> +	rhash_table_init =3D true;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(flow_indr_rhashtable_init);

Shouldn't this be dedicated *_initcall function? That would remove the
necessity for rhash_table_init flag.
