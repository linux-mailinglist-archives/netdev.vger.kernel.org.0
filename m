Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8B552EC14
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349236AbiETMbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 08:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241416AbiETMbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:31:17 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6146447568;
        Fri, 20 May 2022 05:31:13 -0700 (PDT)
Received: from mail-yb1-f172.google.com ([209.85.219.172]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N3KDM-1nidun1Y1a-010L21; Fri, 20 May 2022 14:31:11 +0200
Received: by mail-yb1-f172.google.com with SMTP id r1so13919589ybo.7;
        Fri, 20 May 2022 05:31:10 -0700 (PDT)
X-Gm-Message-State: AOAM533XICYSchr83/2dnnvlXYJ4p8DurUidGgS1IQc22J1Xjhw4Rq8S
        ggohQQS/MAC5kuY3vi/H1bpfmpgzzMs77SmJ3i4=
X-Google-Smtp-Source: ABdhPJzM0/g+q1PRwguziGorhB8SDUsN9iEFZbR/3vnqE9X6zeZuqHYx8uEJ7JXjS9vB4zG423aFir2s+dxjeU1ONqo=
X-Received: by 2002:a25:31c2:0:b0:641:660f:230f with SMTP id
 x185-20020a2531c2000000b00641660f230fmr9208955ybx.472.1653049869839; Fri, 20
 May 2022 05:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220519031345.2134401-1-kuba@kernel.org>
In-Reply-To: <20220519031345.2134401-1-kuba@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 20 May 2022 13:30:50 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3_4fNQV51V0-QUnuTr4dK0-S_ffeFzfA8vG1uGh8vyhg@mail.gmail.com>
Message-ID: <CAK8P3a3_4fNQV51V0-QUnuTr4dK0-S_ffeFzfA8vG1uGh8vyhg@mail.gmail.com>
Subject: Re: [PATCH net-next] eth: de4x5: remove support for Generic DECchip &
 DIGITAL EtherWORKS PCI/EISA
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, tsbogend@alpha.franken.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        sburla@marvell.com, vburru@marvell.com, aayarekar@marvell.com,
        arnd@arndb.de, zhangyue1@kylinos.cn, linux-doc@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-parisc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:RxidTNlQXTP5LyaUmtNAetv6uI1NVNaDYJwJVsMWQ7BOLaI5KHE
 BtANPl6/Mpb7IMmupUSDX+IsM35n8hWFOMNOYw+0YgSgKQA2FDDwU3YK4lDZQcZZlJmaAvo
 SZV9v5sCdIrOTEIPAKcGMViiGmdUCw1NuunYTM5JMQxgHn6zNKtV7QRkg8i+MLpW5EhFOmi
 b6RNeMTv+G71tkjVyMk8A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:e/tDl3btj98=:gvOYMsp+h25Jgb6dzhVdva
 0DyHnXDqjhtjeu4Pk1OZ7FZJJ0bWPdC7LgJPFm2pUoYTY1F0VUqKRRLkBeGRiXqHGPanmkBd+
 aBFbqZ1AH/5ZyPSmzjB4Hda9TFjuZ9/G4+47e4Ia4AYmjPQt1jzcvc4NmsqYvL6oCYvwdHnY6
 kDxgSXfGtcSRfBhgFpnzK59seeAPmZZ21ChXfu7UN5MxNYv1Oabmsaxc9HbvSARXxsZEGkET4
 JPlTMGSQfO8EQ7JwPs8E/EqpcxgY6LhsO5bQj7su6dveLB2o0P9NoEUxs+tSxloGZf0dBZm0V
 w6zMWKM2cbpW4nMJvsFnCyYOUzDIQCHcnjiqmffej7ibOqrcOmphjBGin276Nqs3gIvv+b48r
 5wQwolelaftPAGlEgFefW4ygh72SVpzU8pllcGBxxUqgtJ0Wl/0VdpAnIIaH+bWzbLF/K6VGA
 aO9SMtfT8BK4nploXjRUy2cAOYCVd/f8nfJRn2B3smFoS/5bxcR2dgS3nywOTAqVE8+FhoqvL
 doSY0NqYBY+V6MYhXUNYUHOOw2FW1SQnTwGBRh9NP6L3nvkrq5FIMm3ZHFYJ0pSM/AZRzeI58
 9XpJMw4OKijWCak2SAMy8yI5K1eHIx3dOkt9fLY8w1ClnwAOsXDpujOVyX+MHeN62xpsgX/s8
 WNtT3MNIhnjSQp1mwux3EHkbsArd/vYRfGujMyo48otmyeNLK7DdNRLAxWCwJ1U5ziJ+DQ1Tl
 aRQKRUuEWzdY+gEyN2VlWys8iHRjxTpid1Joig==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 4:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Looks like almost all changes to this driver had been tree-wide
> refactoring since git era begun. There is one commit from Al
> 15 years ago which could potentially be fixing a real bug.
>
> The driver is using virt_to_bus() and is a real magnet for pointless
> cleanups. It seems unlikely to have real users. Let's try to shed
> this maintenance burden.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: tsbogend@alpha.franken.de
> CC: mpe@ellerman.id.au
> CC: benh@kernel.crashing.org
> CC: paulus@samba.org
> CC: sburla@marvell.com
> CC: vburru@marvell.com
> CC: aayarekar@marvell.com
> CC: arnd@arndb.de

Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
>  .../device_drivers/ethernet/dec/de4x5.rst     |  189 -
>  .../device_drivers/ethernet/index.rst         |    1 -
>  arch/mips/configs/mtx1_defconfig              |    1 -
>  arch/powerpc/configs/chrp32_defconfig         |    1 -
>  arch/powerpc/configs/ppc6xx_defconfig         |    1 -
>  drivers/net/ethernet/dec/tulip/Kconfig        |   15 -
>  drivers/net/ethernet/dec/tulip/Makefile       |    1 -
>  drivers/net/ethernet/dec/tulip/de4x5.c        | 5591 -----------------
>  drivers/net/ethernet/dec/tulip/de4x5.h        | 1017 ---


I checked the defconfig files to make sure we are not removing the
last ethernet driver from
one of them. mtx1 has built-in networking and no PCI slot, so this is
definitely fine.
the ppc32 configs are for machines with PCI slots and also enable
multiple drivers but I saw
nothing specifically needing this card.

       Arnd
