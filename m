Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C224E8664
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 09:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbiC0HGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 03:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiC0HGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 03:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393411A4;
        Sun, 27 Mar 2022 00:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB29D60EC8;
        Sun, 27 Mar 2022 07:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF89C340EC;
        Sun, 27 Mar 2022 07:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648364698;
        bh=X/Z0U6GxGaaswFQP/q5cQDmThmBP/93x/RCyJbllhv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KLWyEO1UbxHyNVoDNL/roXtV3ntCYrCI14DuGtZmrvURMsaENvGmBhcc+g2Hq6z55
         pCz8tq91GZiUNxXtD3fqEWnRtwUk/l96208zjRGXFs2EG/+G48bk8zULB4LK0EyBCO
         aWWHH+YRsiC/wOgoJRq0aI40DzEEiCr4RsfopyrJI/n/eGgI9D0pQwRi80UxYM9ku7
         2WUBYW+VmxW0Jz1OfjOmv/4vfbdr93ZD/O/T0SKZemSzO6Zo0ZX5znzXDznONvXBDL
         GLr1ezU2BVJR+IpBfBz929i/iI/6pQ6EsbwWjly85gGpXcS3yeJScuLR+bTihqYbI7
         YtoQThz4uEpzA==
Date:   Sun, 27 Mar 2022 10:04:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Benjamin =?iso-8859-1?Q?St=FCrz?= <benni@stuerz.xyz>
Cc:     andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux@armlinux.org.uk,
        linux@simtec.co.uk, krzk@kernel.org, alim.akhtar@samsung.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, robert.moore@intel.com,
        rafael.j.wysocki@intel.com, lenb@kernel.org, 3chas3@gmail.com,
        laforge@gnumonks.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        mchehab@kernel.org, tony.luck@intel.com, james.morse@arm.com,
        rric@kernel.org, linus.walleij@linaro.org, brgl@bgdev.pl,
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
Subject: Re: [PATCH 11/22] rdmavt: Replace comments with C99 initializers
Message-ID: <YkAMlurdV15gNROq@unreal>
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-11-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220326165909.506926-11-benni@stuerz.xyz>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 05:58:58PM +0100, Benjamin Stürz wrote:
> This replaces comments with C99's designated
> initializers because the kernel supports them now.
> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> ---
>  drivers/infiniband/sw/rdmavt/rc.c | 62 +++++++++++++++----------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rdmavt/rc.c b/drivers/infiniband/sw/rdmavt/rc.c
> index 4e5d4a27633c..121b8a23ac07 100644
> --- a/drivers/infiniband/sw/rdmavt/rc.c
> +++ b/drivers/infiniband/sw/rdmavt/rc.c
> @@ -10,37 +10,37 @@
>   * Convert the AETH credit code into the number of credits.
>   */
>  static const u16 credit_table[31] = {
> -	0,                      /* 0 */
> -	1,                      /* 1 */
> -	2,                      /* 2 */
> -	3,                      /* 3 */
> -	4,                      /* 4 */
> -	6,                      /* 5 */
> -	8,                      /* 6 */
> -	12,                     /* 7 */
> -	16,                     /* 8 */
> -	24,                     /* 9 */
> -	32,                     /* A */
> -	48,                     /* B */
> -	64,                     /* C */
> -	96,                     /* D */
> -	128,                    /* E */
> -	192,                    /* F */
> -	256,                    /* 10 */
> -	384,                    /* 11 */
> -	512,                    /* 12 */
> -	768,                    /* 13 */
> -	1024,                   /* 14 */
> -	1536,                   /* 15 */
> -	2048,                   /* 16 */
> -	3072,                   /* 17 */
> -	4096,                   /* 18 */
> -	6144,                   /* 19 */
> -	8192,                   /* 1A */
> -	12288,                  /* 1B */
> -	16384,                  /* 1C */
> -	24576,                  /* 1D */
> -	32768                   /* 1E */
> +	[0x00] = 0,
> +	[0x01] = 1,
> +	[0x02] = 2,
> +	[0x03] = 3,
> +	[0x04] = 4,
> +	[0x05] = 6,
> +	[0x06] = 8,
> +	[0x07] = 12,
> +	[0x08] = 16,
> +	[0x09] = 24,
> +	[0x0A] = 32,
> +	[0x0B] = 48,
> +	[0x0C] = 64,
> +	[0x0D] = 96,
> +	[0x0E] = 128,
> +	[0x0F] = 192,
> +	[0x10] = 256,
> +	[0x11] = 384,
> +	[0x12] = 512,
> +	[0x13] = 768,
> +	[0x14] = 1024,
> +	[0x15] = 1536,
> +	[0x16] = 2048,
> +	[0x17] = 3072,
> +	[0x18] = 4096,
> +	[0x19] = 6144,
> +	[0x1A] = 8192,
> +	[0x1B] = 12288,
> +	[0x1C] = 16384,
> +	[0x1D] = 24576,
> +	[0x1E] = 32768
>  };

I have hard time to see any value in this commit, why is this change needed?

Thanks

>  
>  /**
> -- 
> 2.35.1
> 
> 
