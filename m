Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F169564BF77
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 23:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiLMWit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 17:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiLMWir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 17:38:47 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D1D220D5;
        Tue, 13 Dec 2022 14:38:44 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so5081168pjj.4;
        Tue, 13 Dec 2022 14:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BP1g1Iirzp/dUWf1Qe3G6Vg4zmWCmsMoMgBILYfECqE=;
        b=JLabunLMzosicidQXvV1G+Pyuf4pDYie+0w3zKQO6BmJZaPg+pKeyHQNP7N2MNyMVn
         4zzwLsWL+AQ5F2ay+2WhnansOA2J45PSy61MsAhXDkXWWduFkDpuqJzyl3w5vg9lXvEh
         v1V0xflPX3rFXwE5VLas4gailXyLtcGiFxef5lo8gMYOz6DKhhqIXpO16Wn0Rd9zmcUx
         2qc16xhthYo122qp04P1atlTQQhUGwImD2CCpnLLVjPTrCi/2518Rue4Rhfrcfxwwyx7
         lk4WVIBe3uKCHn/B9xdoCuD6X6MvUhsGcXoGKzcdCEBVlAM3lGr3i6tkMrBWBj9tuhpp
         SejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BP1g1Iirzp/dUWf1Qe3G6Vg4zmWCmsMoMgBILYfECqE=;
        b=HlSACqTqWI9iwynxe04LpSmqtbViBBw70L3w2kgl4M6xFSczRVUHAgLMcZUtJ21JeT
         sxmm3DvO4COBEzdoaW7VWp57ZS4OJzEkv0RyeoBo894OXolUXqrO08xdf7Ojn+6Dub/4
         HmAPsZRamzHwzIstLIo2w7Emzp/w5HRHDVEAM+3b5dJ5Klupxrxn5Qp70gvZVQAzZMp6
         Oxp+TDjcJowDGLkhok6ll1cOdLKo3GQJkUjDk1GTa5oJBd33Eg2deJ8y2fLohxTmiCSX
         QFCL54qWRPtXdsDugJv7bV5/w2F16mZOjnxd4AHsb37/yWZ1RLggAm0Hfe5/XebazXxE
         KQFw==
X-Gm-Message-State: ANoB5pktT16nl0aLqZVhb/Nu4rHAJmyrBm9mwAOZH9MmAr3v6T4unHpq
        zNh2NU1bfDA5PEe/vAvFUco3o+R3MDY=
X-Google-Smtp-Source: AA0mqf6FGon1t3trZEvFl8Hk/k8LaLMVwmtOScs6DNNDyTttIMFXySZr4589Kra0sZ1rN15GI0FiCw==
X-Received: by 2002:a05:6a20:4290:b0:ad:ccea:73b4 with SMTP id o16-20020a056a20429000b000adccea73b4mr7414299pzj.42.1670971124047;
        Tue, 13 Dec 2022 14:38:44 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id w20-20020a170902ca1400b0018930dbc560sm406613pld.96.2022.12.13.14.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 14:38:43 -0800 (PST)
Message-ID: <a32b21a9a624b39f150fbb66677aa7a5db527aa1.camel@gmail.com>
Subject: Re: [PATCH v2 net-next 1/3] net: dsa: mv88e6xxx: change default
 return of mv88e6xxx_port_bridge_flags
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 13 Dec 2022 14:38:41 -0800
In-Reply-To: <20221213174650.670767-2-netdev@kapio-technology.com>
References: <20221213174650.670767-1-netdev@kapio-technology.com>
         <20221213174650.670767-2-netdev@kapio-technology.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 18:46 +0100, Hans J. Schultz wrote:
> The default return value -EOPNOTSUPP of mv88e6xxx_port_bridge_flags()
> came from the return value of the DSA method port_egress_floods() in
> commit 4f85901f0063 ("net: dsa: mv88e6xxx: add support for bridge flags")=
,
> but the DSA API was changed in commit a8b659e7ff75 ("net: dsa: act as
> passthrough for bridge port flags"), resulting in the return value
> -EOPNOTSUPP not being valid anymore, and sections for new flags will not
> need to set the return value to zero on success, as with the new mab flag
> added in a following patch.
>=20
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index ba4fff8690aa..d5930b287db4 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -6546,7 +6546,7 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_s=
witch *ds, int port,
>  				       struct netlink_ext_ack *extack)
>  {
>  	struct mv88e6xxx_chip *chip =3D ds->priv;
> -	int err =3D -EOPNOTSUPP;
> +	int err =3D 0;
> =20
>  	mv88e6xxx_reg_lock(chip);
> =20

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
