Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B91CFB9E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfJHNwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 09:52:34 -0400
Received: from mail-eopbgr720045.outbound.protection.outlook.com ([40.107.72.45]:53375
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbfJHNwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 09:52:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQlmkNOBnf5BTFHExFBK4w16NepcNDugbmOloQP3ic4RFORPg5cNw0VT4PYb2WAFBh2uRABeR09BkZVnSTbWvdLpdlXXp5/5QOcAckE0ldQ9LoFFoHxPKCmcdUpTnVT4pwa/kpM7mKgpUfhdkrM60vm3OKSBuxB2WtIK8gzOED1hxioWi3norfPq/WANpXYVA3xqE0w4T8AKDb08HbrQCaZSGb21loHN7WHdvlSdpk9rfqW0bFdf3YDW1NJxExubwDUs9GFtKD+ahO1hiIOIJ9ko56lUKBfH4rjDb32Ej7bQ08OamnMynqFXRTBmlDjCwlyGdOdqo2wJBgIT4I/g/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SH0gcqehYjLSPgPfoSaWTT2WzUVMNcnyDDYbxmOprY=;
 b=Wq1bo9rTfjhzON+Lkmf7HtD/hk5cR69Puvmhhd+QjZ1r14ZKmYoJMLMrNlxSqcQJTGLutwKcDjWuUXk5MGK2HU2Ej0izSzwEENicWBRU2YVby0zGqh3+FBNTZbErpzulSnZJQW2QtwWt7PlJnWTFimX8tQR8ZB2YZu+jYRWMKfNvTr+3hWNwxfeVZW/dIgNWC+qaTr6d1HgPsbbfv0Jo6JGR2pflxHscNB3A9WvTfAWUZp507bMjBoz+kBBAQ/TGlgnmBEVKzY/fMNIl1E1bL1VqxxJhvk9rcIMuI+JhXo2mC/uDveo1/5m80kPFSK85Lv8Iqwv7XF/IKKNWQaN1hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SH0gcqehYjLSPgPfoSaWTT2WzUVMNcnyDDYbxmOprY=;
 b=IKdPbKWtFTOdBqHkn5YFcOF4DQU0wQXYovPhbNXrxJq6Ie6zSOOC/Br/YGR2jriydraaaPIpmAIzRhbuADJWiRvbp4hBhWAr0Z6ElvLIup6L76JZtATQQ582d5XQ2ccFfJ2kq3cOnpY30F2ru7aa+aIDamU6ULcbI+3ssZ5JdFg=
Received: from MN2PR15MB3581.namprd15.prod.outlook.com (52.132.172.94) by
 MN2PR15MB2976.namprd15.prod.outlook.com (20.178.253.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 13:52:29 +0000
Received: from MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::2939:6f37:2a1b:cc6d]) by MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::2939:6f37:2a1b:cc6d%6]) with mapi id 15.20.2327.026; Tue, 8 Oct 2019
 13:52:29 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "mlxsw@mellanox.com" <mlxsw@mellanox.com>
Subject: RE: [patch net-next] net: tipc: prepare attrs in
 __tipc_nl_compat_dumpit()
Thread-Topic: [patch net-next] net: tipc: prepare attrs in
 __tipc_nl_compat_dumpit()
Thread-Index: AQHVfcfOvpukfCjEdEyEaGPw+dhZNadQw42w
Date:   Tue, 8 Oct 2019 13:52:29 +0000
Message-ID: <MN2PR15MB35819EB2C946639FE0C3C6579A9A0@MN2PR15MB3581.namprd15.prod.outlook.com>
References: <20191008110151.6999-1-jiri@resnulli.us>
In-Reply-To: <20191008110151.6999-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [192.75.88.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf7d5087-0c6a-4df0-1750-08d74bf6c2a0
x-ms-traffictypediagnostic: MN2PR15MB2976:
x-microsoft-antispam-prvs: <MN2PR15MB2976EC95C1BD9FBC48BAF1069A9A0@MN2PR15MB2976.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(199004)(189003)(13464003)(66556008)(64756008)(76176011)(7696005)(76116006)(14454004)(476003)(99286004)(446003)(478600001)(33656002)(52536014)(11346002)(486006)(6506007)(2501003)(305945005)(7736002)(66446008)(44832011)(66946007)(74316002)(86362001)(53546011)(5660300002)(66066001)(26005)(66476007)(102836004)(81156014)(6116002)(54906003)(8676002)(229853002)(4326008)(9686003)(256004)(8936002)(81166006)(71200400001)(6246003)(110136005)(55016002)(2906002)(3846002)(186003)(316002)(6436002)(71190400001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR15MB2976;H:MN2PR15MB3581.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ncyU3amPhWkZ6uNPVGLdApEh7cmvRnaqrIhr7AXYVJA6EYO36ZMznlRfjT38GUcqTzV2G90I0Pr5Rf8qxQtl33loxJsBEc1cUYfx81DjSpuk9naYzfPDpSJ024WXBXaOp6C/fGHCD9QoaMppbVCD0WcHTdyVmp2ekiCZvwQ0LyLaP8KizfYTgJaVqkxgCCDwpoTdLK0GDchfBKDL8MCoBAJwdK7BHTbvSocZgrlmOhuo5+3OxBZKp37eiay0mtOcEa8MCLb0DmfXjQoIj2txY+xoznYDC/xmzJxo7lXM1UYeM+35tOHgOfv4hWBdj+pTnVp6FiyoTlQehdZ9GAb2YPzXpMHIqhkBNmmuyHfd9pPzO7nUOMDsVuDosKSoC4/kna/csJWW57YmRLX8XlCnOh/xHh7h7L60hZ1GkK1duX4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7d5087-0c6a-4df0-1750-08d74bf6c2a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 13:52:29.4045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GWtIBh99JQsqxXiPOIVhNcJDJobCK0UewrZpNeZhr+TE4YT7o1Zvgs00NMwgn3zQ2UPhT1cyEHRymUkU0vhgIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2976
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked. Thanks Jiri.

///jon


> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: 8-Oct-19 07:02
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; Jon Maloy <jon.maloy@ericsson.com>;
> ying.xue@windriver.com; johannes.berg@intel.com; mkubecek@suse.cz;
> mlxsw@mellanox.com
> Subject: [patch net-next] net: tipc: prepare attrs in
> __tipc_nl_compat_dumpit()
>=20
> From: Jiri Pirko <jiri@mellanox.com>
>=20
> __tipc_nl_compat_dumpit() calls tipc_nl_publ_dump() which expects the
> attrs to be available by genl_dumpit_info(cb)->attrs. Add info struct and=
 attr
> parsing in compat dumpit function.
>=20
> Reported-by: syzbot+8d37c50ffb0f52941a5e@syzkaller.appspotmail.com
> Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs d=
uring
> dumpit")
>=20
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/tipc/netlink_compat.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c index
> 4950b754dacd..17a529739f8d 100644
> --- a/net/tipc/netlink_compat.c
> +++ b/net/tipc/netlink_compat.c
> @@ -181,6 +181,7 @@ static int __tipc_nl_compat_dumpit(struct
> tipc_nl_compat_cmd_dump *cmd,
>  				   struct tipc_nl_compat_msg *msg,
>  				   struct sk_buff *arg)
>  {
> +	struct genl_dumpit_info info;
>  	int len =3D 0;
>  	int err;
>  	struct sk_buff *buf;
> @@ -191,6 +192,7 @@ static int __tipc_nl_compat_dumpit(struct
> tipc_nl_compat_cmd_dump *cmd,
>  	memset(&cb, 0, sizeof(cb));
>  	cb.nlh =3D (struct nlmsghdr *)arg->data;
>  	cb.skb =3D arg;
> +	cb.data =3D &info;
>=20
>  	buf =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
>  	if (!buf)
> @@ -209,6 +211,13 @@ static int __tipc_nl_compat_dumpit(struct
> tipc_nl_compat_cmd_dump *cmd,
>  		goto err_out;
>  	}
>=20
> +	info.attrs =3D attrbuf;
> +	err =3D nlmsg_parse_deprecated(cb.nlh, GENL_HDRLEN, attrbuf,
> +				     tipc_genl_family.maxattr,
> +				     tipc_genl_family.policy, NULL);
> +	if (err)
> +		goto err_out;
> +
>  	do {
>  		int rem;
>=20
> --
> 2.21.0

