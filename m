Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0F54E3B43
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiCVIzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiCVIzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:55:04 -0400
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0D4C05;
        Tue, 22 Mar 2022 01:53:36 -0700 (PDT)
Received: by mail-qk1-f181.google.com with SMTP id v15so13477332qkg.8;
        Tue, 22 Mar 2022 01:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pvFHOlMwsCxQs4l0jrognWndE4En3aC3fmFiIzLXcP4=;
        b=CYAHlaygS7mSyuK1eB5QkLCYm+MrcDgK+bffEENT/f3AprmUx+lgXA6wWlVJInAAIQ
         w0QuBN4KCtojTB2Y+sCogtMN2y+Pns4Wrv45xc1FDA1UbPjiwC6lkMAW5eEfDOshLroH
         /pPOiq+qINbvZR+mhqIVSJYJG8KqSkxRaWm2o2E7FDYKGsUfDtYN8MG8j0fjS/+juX1d
         MPZVVkw0T/YN95gok/ND2Ci8KBdQQKbIf60C5BaexHsdOX6KS2aQMeb2V2a6fxAbXYA0
         v5/hwoKzJrnRXL6tFKhBOo1j/1nWSBwfVV6e/BavMCHGTR6HnDgIRxaDXt8qtYZtSfoi
         UPwQ==
X-Gm-Message-State: AOAM532mOao6AjR80LgLFLRVbLr1UwEItWTVAZiF6pDjdE0o78Dv9XrQ
        f0SGWfNm+FDeYP9EtVuchMIrQutw2LIwyw==
X-Google-Smtp-Source: ABdhPJw7IZzzLwcA7reDL30FyPATf6A/xatgn15pDwlngqf+RZ2SkZF4lZzhqLkYX4tiPbYPCi2Fmw==
X-Received: by 2002:ae9:c115:0:b0:67e:4c57:eaff with SMTP id z21-20020ae9c115000000b0067e4c57eaffmr12772395qki.18.1647939215184;
        Tue, 22 Mar 2022 01:53:35 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id d13-20020a05622a15cd00b002e1df990d01sm13712290qty.71.2022.03.22.01.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 01:53:34 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id g138so11999462ybf.5;
        Tue, 22 Mar 2022 01:53:34 -0700 (PDT)
X-Received: by 2002:a05:6902:101:b0:633:ccde:cfca with SMTP id
 o1-20020a056902010100b00633ccdecfcamr14913592ybh.207.1647939214166; Tue, 22
 Mar 2022 01:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220315164531.6c1b626b@canb.auug.org.au>
In-Reply-To: <20220315164531.6c1b626b@canb.auug.org.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 22 Mar 2022 09:53:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVJjhd77PtV6SA0iFXznkH0X82iJTg5akaud7ZkMvRvkA@mail.gmail.com>
Message-ID: <CAMuHMdVJjhd77PtV6SA0iFXznkH0X82iJTg5akaud7ZkMvRvkA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the char-misc tree with the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Tue, Mar 15, 2022 at 6:45 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the char-misc tree got a conflict in:
>
>   drivers/phy/freescale/Kconfig
>
> between commit:
>
>   8f73b37cf3fb ("phy: add support for the Layerscape SerDes 28G")
>
> from the net-next tree and commit:
>
>   3d565bd6fbbb ("phy: freescale: i.MX8 PHYs should depend on ARCH_MXC && ARM64")
>
> from the char-misc tree.
>
> I fixed it up (I think, see below) and can carry the fix as necessary.
> This is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

> --- a/drivers/phy/freescale/Kconfig
> +++ b/drivers/phy/freescale/Kconfig
> @@@ -23,12 -26,4 +26,14 @@@ config PHY_FSL_IMX8M_PCI
>           Enable this to add support for the PCIE PHY as found on
>           i.MX8M family of SOCs.
>
>  +config PHY_FSL_LYNX_28G
>  +      tristate "Freescale Layerscape Lynx 28G SerDes PHY support"
>  +      depends on OF
>  +      select GENERIC_PHY
>  +      help
>  +        Enable this to add support for the Lynx SerDes 28G PHY as
>  +        found on NXP's Layerscape platforms such as LX2160A.
>  +        Used to change the protocol running on SerDes lanes at runtime.
>  +        Only useful for a restricted set of Ethernet protocols.
> ++
> + endif

The above resolution is not correct: Layerscape is a different SoC
family than i.MX8, using ARCH_LAYERSCAPE instead of ARCH_MXC.

Hence PHY_FSL_LYNX_28G should be moved outside the if/endif block
(and gain a dependency on ARCH_LAYERSCAPE || COMPILE_TEST; I will
 send a patch).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
