Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F084E8333
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiCZSWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiCZSWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:22:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BED32058;
        Sat, 26 Mar 2022 11:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98AEF60AB1;
        Sat, 26 Mar 2022 18:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F7CC340ED;
        Sat, 26 Mar 2022 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648318835;
        bh=a9PM8ugoPHcLZbjkxJVPg7uQdblZc8OHq1uRNBRh9Yo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s7P5sH3ynxDq9DOZZbVd1rpChas+Vz68Xeb96Ar1owhXSRM34zCpvoKdOzTUzoebR
         BR360GyHKwlEGTC5p52ZTxUc0HpVmY6DeayFlcrfta83zmO0Js3lqZL49AuLjXdOKm
         6XIj1+zSSRhGdfyyo7NkaAMxFBpUbU6STck0ztGAHeBC+wgBV/SWf8JFGo4VffABB7
         0a3+EHc7ze3dtRBlbeDGvb9G5alVaEIB6iP+lEi6u2oTYJtnewnepqbNDs0hX56ZwQ
         fiOegfAmH6kZWXcesJSvQZ0GIf7zJlIGhnxRaHWz1CoWd9psPYt6KvQv/1XFM/8Ea9
         JoiZWG0bHc/KQ==
Date:   Sat, 26 Mar 2022 19:20:20 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Benjamin =?UTF-8?B?U3TDvHJ6?= <benni@stuerz.xyz>
Cc:     andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux@armlinux.org.uk,
        linux@simtec.co.uk, krzk@kernel.org, alim.akhtar@samsung.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, robert.moore@intel.com,
        rafael.j.wysocki@intel.com, lenb@kernel.org, 3chas3@gmail.com,
        laforge@gnumonks.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/22] orion5x: Replace comments with C99 initializers
Message-ID: <20220326192020.670e0b2f@coco.lan>
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, 26 Mar 2022 17:58:48 +0100
Benjamin St=C3=BCrz <benni@stuerz.xyz> escreveu:

> This replaces comments with C99's designated
> initializers because the kernel supports them now.

Please:

1. Split this series per sub-system. It makes no sense to mailbomb all
   subsystems for things that won't belong there;

2. Add a patch 00 to the series, in order to make easier to do reviews
   like this that are meant to the series as a hole.

Regards,
Mauro
>=20
> Signed-off-by: Benjamin St=C3=BCrz <benni@stuerz.xyz>
> ---
>  arch/arm/mach-orion5x/dns323-setup.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x=
/dns323-setup.c
> index 87cb47220e82..d762248c6512 100644
> --- a/arch/arm/mach-orion5x/dns323-setup.c
> +++ b/arch/arm/mach-orion5x/dns323-setup.c
> @@ -61,9 +61,9 @@
> =20
>  /* Exposed to userspace, do not change */
>  enum {
> -	DNS323_REV_A1,	/* 0 */
> -	DNS323_REV_B1,	/* 1 */
> -	DNS323_REV_C1,	/* 2 */
> +	DNS323_REV_A1 =3D 0,
> +	DNS323_REV_B1 =3D 1,
> +	DNS323_REV_C1 =3D 2,
>  };
> =20
> =20



Thanks,
Mauro
