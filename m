Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482A5CE74E
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfJGPW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:22:56 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:51516 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727745AbfJGPW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:22:56 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CA0B0C020B;
        Mon,  7 Oct 2019 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570461775; bh=zJBaBqkAq1Pv2LsRNBMG+vGbLR7GF3SkroEzJ98OAAk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=KAeeKAyrQ/OavvYiDGzFtMD053upFig2wgkfysvWxjNaNMPzM8Icp/H4mERRBlO8r
         rE9a0ui5lUqgHkUJEU8MAttuojFxQyNyuL0hj5AxfzPbABrIRqCaVLUK21XKPE3eKJ
         DntCsewIgmAvtFePNZVZatINXsL9i/XBsXKnxdvLV5cPhDnfAkLCjupJYJlyZHJb4R
         Mgz80jYPS1DDBEDNyUh7+14TA3rcQRDUd5GVvWJ0JIE9tDaEfgwtwCGq/5xmPOSDJU
         rK/6GMR7PqDbpcoMiSJmeRKJBB2yUj0hh/ASOFj+BflKQFYCMhHuVM5S++UCswtzEH
         +pDafgVSg8zWQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id EB1B0A006F;
        Mon,  7 Oct 2019 15:22:53 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 7 Oct 2019 08:22:53 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 7 Oct 2019 08:22:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkL/4EytKAfmFNrJbXa/dmYM4kjfnKfTMcCeTFV+FCfnGpZjPTKxSPpQtWP3AFYvHceXOElLCqoPvu7BsmQKWJryC/JoFg2CdH0NlacCpBJ8i6FRaAKjR2hyix+4DcNYdi67DIoUoizHJsl8HvRj8m8qWq97m4n3zkQqA4tEVmisUmP1bd2ZnvGPy15JHUOncRyVn4eCfN5m2qzDxIIe8unMMQ/Qs9JK0bs24mxC6joHZmRNwdE1YIZkUmYArpjzjbuZ2BsfU+9OWEhEl+zV2DKbJ/KY5KTs/xcRLUZThKR4rv8JBAvKrGoCUsKBNXndvxN57oLMcOSWYYuMoOveLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfZskFUUBJ2mYJjg3KVbv5mMkBsE3CDTmVK5AHcvqx8=;
 b=hF53hieRmk0qIrLZVGf4CivELyjjSmL7kmFBSzUxhw4U405nX9jKMJ/0cWhg6drcvR5ngMCiHiQBIcXfdY1tQ8I+zWLTYSqMBtKZktTnE3b5soQOlCe95t4Jj8sVkXiKkvFIi3xrmrxAdktg+fitXl2XR/f1WLnWG7XUVhBKvNDj25vbFLwZqbgQreyN6HphWf2yR3wu7t8m3pnM0SPFQOIg8nmPl60tQEjDol/QVRE4c32Hy8dm6ZRx5N8s/LFHtGlUMHcxJ9cSlW5ON/HxwBvcXbo3rxPKroXiQSNOinSDgq3Vn6DDGudBuPPJ2ZMBPUZgzZcJeN7Ekm8arF766g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfZskFUUBJ2mYJjg3KVbv5mMkBsE3CDTmVK5AHcvqx8=;
 b=fBtF/NHGkuQmHc/dT/NoArlReAmEmtivro6WuqKV1mIuCsRwNlukRSIhhC1YXhSTlg0IZdmdnEBXmZm6H8l6PgkYv92yytMdiYr6nfniXNKxJHDyv6gPhs80Q+q03RihqY36dz43qvNf/L1mCw2xw9jICrBAmABeY5xz4r/U/2I=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3297.namprd12.prod.outlook.com (20.179.65.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Mon, 7 Oct 2019 15:22:50 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f431:f811:a1f9:b011]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f431:f811:a1f9:b011%3]) with mapi id 15.20.2327.025; Mon, 7 Oct 2019
 15:22:50 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: stmmac: Fix sparse warning
Thread-Topic: [PATCH net-next] net: stmmac: Fix sparse warning
Thread-Index: AQHVfRFyosdZXcdd1kO+/UasDUBusKdPOOkAgAASA6A=
Date:   Mon, 7 Oct 2019 15:22:50 +0000
Message-ID: <BN8PR12MB32660C9CE9B4F96517313E6BD39B0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <b59904022c2f96aca956aa693040faf0dddeb802.1570454078.git.Jose.Abreu@synopsys.com>
 <20191007.161426.108032588372697075.davem@davemloft.net>
In-Reply-To: <20191007.161426.108032588372697075.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 420e59dd-5743-4d44-4e95-08d74b3a376f
x-ms-traffictypediagnostic: BN8PR12MB3297:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB32976CADC7792D711D1531E7D39B0@BN8PR12MB3297.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(39860400002)(366004)(346002)(199004)(189003)(6506007)(256004)(86362001)(14444005)(5660300002)(7696005)(71200400001)(66476007)(52536014)(66556008)(66446008)(66946007)(71190400001)(64756008)(229853002)(8676002)(76116006)(6436002)(6246003)(99286004)(55016002)(9686003)(76176011)(478600001)(14454004)(74316002)(476003)(26005)(66066001)(6636002)(316002)(110136005)(486006)(4326008)(81156014)(7736002)(8936002)(102836004)(11346002)(446003)(305945005)(186003)(54906003)(2906002)(81166006)(25786009)(6116002)(3846002)(33656002)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3297;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /uMP3CNUEbRcxbi316KXzfaSGdQ6qkv0e5oFx6JAhhHqv24TQLV583NZhKbKKKdZbKLzSm57H6GhU/m/mIDev/Z05cE1TmL7zHn/4EKo3+uYdh/URT4DqJEsyHl4XxcJK8hnBX+XuNiJT1SRidf/JSQymO0q3Xuew3KnOHpNX9+1YRcgQIGuQS3exL3jXzpPf+/PrIxZ2JcNtGqW1PsjvJAWW0Bq1gHJDXP4UOW2H/NwI1ECoQAnLoIDXhd6QHnN4mCJBYV2yqsDaxE6EllgQmeRAvnzgE9zxCdfklzr4DAZwFtlu8NCfmz+5SOdx3JGlvMw48z+bvyEkCsgtXTsxhHMchvxfxxwe+e17j4SwAoD5BYjyxcBEhzbVdHSR3qcFXPVMEcn/UEcIHnfZHLLSODP/UiRG/Mp44k8aswndbA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 420e59dd-5743-4d44-4e95-08d74b3a376f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2019 15:22:50.5492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ct0h8My16hHxZwzxhz8dL+3Nly8L+00Ll814WGBtAwWzC/IxXRTY8X+7lidj0elTCqN0LdZK9mgJXlGTTvc5aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3297
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Oct/07/2019, 15:14:26 (UTC+00:00)

> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Date: Mon,  7 Oct 2019 15:16:08 +0200
>=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/driver=
s/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 8b76745a7ec4..40b0756f3a14 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -4207,6 +4207,7 @@ static u32 stmmac_vid_crc32_le(__le16 vid_le)
> >  static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double=
)
> >  {
> >  	u32 crc, hash =3D 0;
> > +	__le16 pmatch =3D 0;
> >  	int count =3D 0;
> >  	u16 vid =3D 0;
> > =20
> > @@ -4221,11 +4222,11 @@ static int stmmac_vlan_update(struct stmmac_pri=
v *priv, bool is_double)
> >  		if (count > 2) /* VID =3D 0 always passes filter */
> >  			return -EOPNOTSUPP;
> > =20
> > -		vid =3D cpu_to_le16(vid);
> > +		pmatch =3D cpu_to_le16(vid);
> >  		hash =3D 0;
> >  	}
> > =20
> > -	return stmmac_update_vlan_hash(priv, priv->hw, hash, vid, is_double);
> > +	return stmmac_update_vlan_hash(priv, priv->hw, hash, pmatch, is_doubl=
e);
> >  }
>=20
> I dunno about this.
>=20
> The original code would use the last "vid" iterated over in the
> for_each_set_bit() loop if the priv->dma_cap.vlhash test does not
> pass.
>=20
> Now, it will use zero in that case.
>=20
> This does not look like an equivalent transformation.

It is intended behavior. HW specific callbacks:=20
dwmac4_update_vlan_hash() / dwxgmac2_update_vlan_hash(), will either use=20
Hash method or Perfect method so if priv->dma_cap.vlhash is not=20
available then pmatch will be last vid. Otherwise, it will be zero and=20
hash will be populated.

---
Thanks,
Jose Miguel Abreu
