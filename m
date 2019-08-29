Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3CCA1456
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfH2JHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:07:03 -0400
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:62469
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfH2JHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 05:07:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dew+6A4APDBkG4ucNcZZUHeNHxLiTC5IM/SL5xITncf3bJ8hx179wRO+T86ztXa5KHlZpYLn2h55K0WSx9gsqgRCUj/NLgmtk+jG9YZBFnzd/7Oo42AbEKj8KVBF+XOcQvsZqmso+YqvBUGMJLMa945EGYWU4CG84V/x0mDceJdvpuyMvM1u7xVXWeBx05vYtKspxBVGLfW/kgpQVayDIpzU+MSG+y52ENMIjW6Yy3JeqLjFrry5MbApNYiXqT5pPy089JMGzbg8sVkTjgCBsvK9SlJDPraIyk6ADKAkBHTVAnhNxbutCIUV19QfPj+JC3vErLliJ4Ety6zK3FX0NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psiGmPJ1N4SsQsPDDpEV1+yFF1PCWFL0i7U7x9xEJog=;
 b=WIeP3+4inEPYzHoCs1Reqvuy7B21AM4qoVdI//wt2IYA+EZ0hJf02yZ6HCuVwx1zMwG4QZ712ng88HgvkGTXDWUA4Fns+Xb0NKopFz1P7nFu6Te3Mhtrc/KgAVoSc02NColBl7bU2/PhD5/+wx7FDsluyk3S46uj8kSQrzKtCxXx5xEf5Lrs3TWY660ysYOZzdldzjZimDbm5/pdGleD0pwudiqM41lcqTQCao2dhwavvdYIzjfCt6MaTDWFAga+1a71INjk0cf/WgzeAKvwLhWzugREKuoeRkb8CIFqOgmy4FEhEwWVeOeeVNmx6Yv0bTrytSbvvbtfcvKv++SBJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psiGmPJ1N4SsQsPDDpEV1+yFF1PCWFL0i7U7x9xEJog=;
 b=bKGlvK9gyvP5ylU8i0rZoIGY2eGnH8vHrukqZP2jgHU9+wf0AXIeWi2+rCGYt+RRNBCzpA2B/1v/41ZlCqYLx0Cb7jyLZ4IurgzkqPpK5VEVvYomZnQ2KW4bcuLkTejKc4xgWG9caW/Q801e5ghZFVQ2gfzHdKGJUvVAI6zuseQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6113.eurprd05.prod.outlook.com (20.178.117.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 09:06:59 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 09:06:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 1/5] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH v1 1/5] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXQwKr3hzuM9h9k6/weilGIZr2acRFDQAgADDoxA=
Date:   Thu, 29 Aug 2019 09:06:59 +0000
Message-ID: <AM0PR05MB486658228E2DE7FFE4327EB8D1A20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190827191654.41161-1-parav@mellanox.com>
        <20190827191654.41161-2-parav@mellanox.com> <20190828152544.16ba2617@x1.home>
In-Reply-To: <20190828152544.16ba2617@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e622d30-0c23-4094-764b-08d72c603fa9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6113;
x-ms-traffictypediagnostic: AM0PR05MB6113:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6113FD816D0FC03A2B7EFE8FD1A20@AM0PR05MB6113.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(199004)(189003)(13464003)(66556008)(64756008)(66446008)(26005)(55016002)(86362001)(486006)(66066001)(81166006)(71200400001)(186003)(8676002)(478600001)(81156014)(54906003)(53546011)(102836004)(229853002)(8936002)(66476007)(76116006)(3846002)(6116002)(14454004)(305945005)(7736002)(74316002)(9456002)(6916009)(25786009)(52536014)(4326008)(5660300002)(446003)(6246003)(11346002)(66946007)(76176011)(55236004)(9686003)(14444005)(2906002)(476003)(7696005)(256004)(53936002)(33656002)(6506007)(99286004)(316002)(71190400001)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6113;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sF51emU5ZhZM1Qdd3vgAdG3ukyY7AoHFpCcKzb7VV7c14kH/+zDp+UpOp78WfX+18Kll1But0LCz//ydaGqdcjr11InGr3O9m696OtXH2afD/06zx8Laj/1U2wVWzWI2jQuwPb7vDZKihNyp18C7uietTkUUqN6QaUznIavD2ZRErLfSeKaeqqX3oHD1lWCDolRLSRfTdc6vm7v1Rxtk9JqG33YHj4fyPmbvq1e+aINqNo+KZ0BBU2n7VbIhDt0K/VB0EgmK7qAJkLbOwbajt30GrqKyyyxUZqykbk/MWe8k267UpLn6pfd2hRgYiQNswgUWEX7UzS7xScdOe+bdP4gJvRJxjIbSI3uGh0nkxqOwl2pvZqZM7HFtAwVQzpoTKlqRYLCASizSW2SBEoAAV8/vSeNOHaKDYNFjwdkRY4w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e622d30-0c23-4094-764b-08d72c603fa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 09:06:59.1238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FpO0r0o6Cx4Mpd042I0E20cxRWGeOQgQGIy8luyw3MwSg/WiNMEm9tKkFAEoi9IohhgXIaRq7mpumIuVtZmlIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, August 29, 2019 2:56 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v1 1/5] mdev: Introduce sha1 based mdev alias
>=20

> > +	/* Allocate and init descriptor */
> > +	hash_desc =3D kvzalloc(sizeof(*hash_desc) +
> > +			     crypto_shash_descsize(alias_hash),
> > +			     GFP_KERNEL);
> > +	if (!hash_desc)
> > +		goto desc_err;
> > +
> > +	hash_desc->tfm =3D alias_hash;
> > +
> > +	digest_size =3D crypto_shash_digestsize(alias_hash);
> > +
> > +	digest =3D kzalloc(digest_size, GFP_KERNEL);
> > +	if (!digest) {
> > +		ret =3D -ENOMEM;
> > +		goto digest_err;
> > +	}
> > +	crypto_shash_init(hash_desc);
> > +	crypto_shash_update(hash_desc, uuid, UUID_STRING_LEN);
> > +	crypto_shash_final(hash_desc, digest);
>=20
> All of these can fail and many, if not most, of the callers appear that t=
hey might
> test the return value.  Thanks,
Right. Changing the signature and honoring return value in v2.

>=20
> Alex
