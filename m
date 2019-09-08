Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918FEACC15
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 12:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfIHKjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 06:39:36 -0400
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:45393
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728516AbfIHKjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 06:39:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDro5R5C6KHxHAAgq5rVoYwD9MJbO8rLkifMURWKP1n3N6iOFWc+x5AxGPE30qGd2o/mZ+866M9yWQsNf3RI0PwQHZxheIgeCNJxM8MxWfT5hJYOx0v4tiMYly1GC8vrPy3XLdfJKlJ6LkqXP44XnajU7QJp2EcB0+nALm17C6HAmn/wnFycvcPPkI1ir8VxOz9yHHxN2nXis0PZthwXN54AXiBoLaw26IzmhyGXW3qwHw6zKYJi5H4HpT8H4BbEOozn7SInJCRK+3+YTbR5oBSy5hhEQo6cGLP8eZ1WoyuvmMlcZStodHTMMQ556hLUSHFal0B7lUsuyWlDT0yLqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E70+8yEJQGZFJVGBfmSbUV5gMKRjI57a7sTixzjGAsk=;
 b=JBh8yUctxTvICOkIp7Z/ql8VXMc4xZrh2+6djvVNimTOM/jf5b9kMlmKDGwunjh6uL7PlWTS/p2ujsAQZtomLvK77QRULoNDEy5xVGoAQ7LJOOeWUnZ6uwtxVTwvlfJ5v0cdVmlVcz2kiXVXCMp0kqURd9T37tZSr9G2HFG4+SrvdD9LJ3JFEy3CeBJz8TZfLq5IXnxRqWqQFwD1OY3NFWz+KhELuLQpPQuenGfcHj1FI3MNxbSe5vOzE+xQShBmY/8neF2N9kDLRQC6vJuUXFitJX9/N56/z6Exy1GYDkg3fylqA9Hn4bUmT8ux/1whDZvcOf2FN8LYR8A9cErsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E70+8yEJQGZFJVGBfmSbUV5gMKRjI57a7sTixzjGAsk=;
 b=SmTigz4lAbwBqG6ksz6TwAZWA/v0rl7qkaT9fTzcdBbccIKQsJZGNTVWiuLNQD/P5QE2MxmegeQ6gbSdnTqI5KylP10i0I3jNIkBPp7uz8a2iQTpy3iUg0pdi+hBRwk387HPmp0jBisBsjbJiOrboLBMBjxqzOqcZIcgQgvjszc=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB6186.eurprd05.prod.outlook.com (20.178.106.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Sun, 8 Sep 2019 10:39:32 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b%5]) with mapi id 15.20.2241.018; Sun, 8 Sep 2019
 10:39:32 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next v2 3/3] net: devlink: move reload fail indication
 to devlink core and expose to user
Thread-Topic: [patch net-next v2 3/3] net: devlink: move reload fail
 indication to devlink core and expose to user
Thread-Index: AQHVZb5ksm4y7oN0gkKk3XG8zXgJRKchl+QA
Date:   Sun, 8 Sep 2019 10:39:32 +0000
Message-ID: <20190908103928.GA21777@splinter>
References: <20190907205400.14589-1-jiri@resnulli.us>
 <20190907205400.14589-4-jiri@resnulli.us>
In-Reply-To: <20190907205400.14589-4-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0168.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::36) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f791e1ae-4c44-42bd-1a7e-08d73448d5a2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB6186;
x-ms-traffictypediagnostic: DB7PR05MB6186:|DB7PR05MB6186:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB6186866CD4ED0D2D9701643CBFB40@DB7PR05MB6186.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0154C61618
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(199004)(189003)(4326008)(5660300002)(66556008)(64756008)(66446008)(66946007)(14454004)(2906002)(6116002)(305945005)(478600001)(3846002)(8936002)(8676002)(81156014)(81166006)(33656002)(99286004)(7736002)(6916009)(86362001)(54906003)(1076003)(52116002)(66066001)(25786009)(229853002)(6486002)(316002)(53936002)(26005)(66476007)(102836004)(186003)(386003)(6506007)(33716001)(6436002)(446003)(76176011)(14444005)(256004)(11346002)(71200400001)(71190400001)(6246003)(6512007)(9686003)(486006)(476003)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB6186;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X2e4e1nKWvreYloGIJ1qt94kLtNijcoDrOwqFMYe5dFdGVhxOdYXlv4/N2+fbJdJnE+M9RkxFCtR0sJx2iDQDrLR9T7U6kG8Y5gziiMdEPSxcjBgufDp6Kx6qn0/CPe32bfxunGQcGcVtlGWwuW2hktSvfwGlTr2G02G6BQA5BNRLL0bVYIRbRu/4ofhG2fgyUEPnB9BnISAMks5oh3o1bYnvlJRNGbiHD6Vj6KcDB5A0ABoUHeuoNpHC6Di4r7rjFAN29sdljdJ6JlqJvEVBjBXm7sBx+AioCQGdYmEl9VN9/zGd+TZo0JMuWb69M1xvXTWRr/n0Iso8xM7zyowdUoTw+2qyCxZjN8KwiRSDBA+/FdHtDz1qdK3TFCy/evf3IYzJRPNbK9Lwey4j1+RHBehz2sJk8bnkcO6in5DbDI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FCB18031124564EADAB5750FB7D7BCF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f791e1ae-4c44-42bd-1a7e-08d73448d5a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2019 10:39:32.6022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z2g5DNPZVcXjP/CzDBLeINSoOkXh3opakGJ+f89/idKEfp5Y02QJ91fmWa0siI28bUysFwC07+8xZnzFV0vKwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB6186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 07, 2019 at 10:54:00PM +0200, Jiri Pirko wrote:
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 546e75dd74ac..7cb5e8c5ae0d 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -410,6 +410,8 @@ enum devlink_attr {
>  	DEVLINK_ATTR_TRAP_METADATA,			/* nested */
>  	DEVLINK_ATTR_TRAP_GROUP_NAME,			/* string */
> =20
> +	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
> +
>  	/* add new attributes above here, update the policy in devlink.c */
> =20
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 1e3a2288b0b2..e00a4a643d17 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -471,6 +471,8 @@ static int devlink_nl_fill(struct sk_buff *msg, struc=
t devlink *devlink,
> =20
>  	if (devlink_nl_put_handle(msg, devlink))
>  		goto nla_put_failure;
> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed)=
)

Why not use NLA_FLAG for this?

> +		goto nla_put_failure;
> =20
>  	genlmsg_end(msg, hdr);
>  	return 0;
> @@ -2677,6 +2679,21 @@ static bool devlink_reload_supported(struct devlin=
k *devlink)
>  	return devlink->ops->reload_down && devlink->ops->reload_up;
>  }
