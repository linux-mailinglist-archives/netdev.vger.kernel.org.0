Return-Path: <netdev+bounces-10688-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D57B372FC73
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 135C51C20C1F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC26E79D5;
	Wed, 14 Jun 2023 11:30:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1FB6AA3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:30:12 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8A9199B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686742210; x=1718278210;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=iekMNmVk2zF+d+7HGggopWYAOuzQY2WawO/n8J2vNwM=;
  b=wr4fBQ9p+R+O853nYhpYJsYsrFZsOYlLfpbmC7PS0oSCCq4otru634/0
   WQbPS7+fi+c0vZBAOGNLXDkcquNAYsLJC0Bm/wBXulm4lRbeTT1b5BSVO
   rSeukLEnpjSMz+2XUsG9a8CnpyCUu3YS08Bag1QWbyhij9fHMb7Kw+bnN
   /ZV9t8UL8id7hjzfwhM6s2ZReCsrQ8VltiyR/TSgOoWxZ9bhsjA7BTPtK
   BPNI323d2cVK8dpgU1L/rwyx2txa693JZPl5YyOHWQycSuY+IXaqA2mub
   rEWQnEsXH6WMySjLDCxxOtTe8nbWflrZVMJpOjm8fzmU6IqY/fUBlrcZA
   w==;
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="220241287"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2023 04:30:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 14 Jun 2023 04:29:55 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 14 Jun 2023 04:29:53 -0700
Message-ID: <700342a6747c9fdf5a80ec37070576ba9da1d9eb.camel@microchip.com>
Subject: Re: Fwd: [PATCH] net: microchip: sparx5: Remove unneeded variable
From: Steen Hegelund <steen.hegelund@microchip.com>
To: <baomingtong001@208suo.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
	<daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
	<horatiu.vultur@microchip.com>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Wed, 14 Jun 2023 13:29:52 +0200
In-Reply-To: <d70ab6d10972330290c4c810d61df193@208suo.com>
References: <20230613094921.19836-1-luojianhong@cdjrlc.com>
	 <d70ab6d10972330290c4c810d61df193@208suo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Bao,

I could not apply your patch as there seems to be no message id in the mail
headers.  I also could not find it on patchwork, so it seems like it has be=
en
ignored there.

Could you please resend this with the proper details - otherwise the change
looks good to me.

BR
Steen

On Tue, 2023-06-13 at 17:53 +0800, baomingtong001@208suo.com wrote:
>=20
> =C2=A0You don't often get email from baomingtong001@208suo.com. Learn why=
 this is
> important
>=20
>=20
>=20
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
>=20
> Fix the following coccicheck warning:
>=20
> drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c:1435:5-8: Unneed=
ed
> variable: "err".
>=20
> Signed-off-by: Mingtong Bao <baomingtong001@208suo.com>
> ---
> =C2=A0drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c | 3 +--
> =C2=A01 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> index 3f87a5285a6d..03a9b226c9c5 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> @@ -1432,7 +1432,6 @@ static int sparx5_tc_flower_template_destroy(struct
> net_device *ndev,
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sparx5_port *port =3D netdev_priv(nd=
ev);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sparx5_tc_flower_template *ftp, *tmp=
;
> - =C2=A0=C2=A0=C2=A0int err =3D -ENOENT;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Rules using the template are removed by =
the tc framework */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_for_each_entry_safe(ftp, tmp, &port->t=
c_templates, list) {
> @@ -1447,7 +1446,7 @@ static int sparx5_tc_flower_template_destroy(struct
> net_device *ndev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(ftp);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0break;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> - =C2=A0=C2=A0=C2=A0return err;
> + =C2=A0=C2=A0=C2=A0return -ENOENT;
> =C2=A0}
> =C2=A0
> =C2=A0int sparx5_tc_flower(struct net_device *ndev, struct flow_cls_offlo=
ad *fco,


