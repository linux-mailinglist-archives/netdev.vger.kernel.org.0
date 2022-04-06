Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09E74F5DBA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiDFMEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiDFMD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:03:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB9350BB62;
        Wed,  6 Apr 2022 00:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CAC4B82140;
        Wed,  6 Apr 2022 07:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5872DC385A1;
        Wed,  6 Apr 2022 07:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649231459;
        bh=RVG9FfA/95qVG2QdZds4+9t4n1NB+/ldzTzaqZ3WVqM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fT5fIDoV/NWB6t4+2nKdZXyaMn2ZGq2ivHhTLkJVOVw72526DaEkdj+Q35ZNibbCR
         Ey5TVux2blnk/bcJ2JfA2/wEIkiry7XTwHhXJAbOgnS8FxoXVbCN45gRBZmJQNc0eC
         3w5bYhlnqGJ+NXNGG0f8aTIUxG2GtkETeXeayR9VkWPWmvBHNMsFwfgYY+Q3P4ichI
         j7/BQx/dqilFauh9+ZAhKE6dedG54iesW01UW7rCBPugDWZz4bASJblvln2vM7pX+5
         LeuzUnTF9ZLC9EJIz3w5efGgS76nRFHdSd8jqESShucOBseuFI0zzmZd+iO5ye+mxs
         Cft4AryW/gtMQ==
Received: by mail-wr1-f44.google.com with SMTP id w4so1847980wrg.12;
        Wed, 06 Apr 2022 00:50:59 -0700 (PDT)
X-Gm-Message-State: AOAM533rUF5Pg/5a/mRFvW+fcx+kIkF1yJW+Xrp5e54AoMptF/bfbF40
        ci5S8Bxf75aAGm9YIvrZMLgyLBLe2hCIdmNieGo=
X-Google-Smtp-Source: ABdhPJyiqjgdXKT+Gm3SGPYSCzPQJkLRQ8uaMQmjANYZyedWfv5cvhtw3ix0jOW8xkR6WQ9tZ0xvPwl85G+CJoj20I0=
X-Received: by 2002:a05:6000:178c:b0:204:648:b4c4 with SMTP id
 e12-20020a056000178c00b002040648b4c4mr5391670wrg.219.1649231457611; Wed, 06
 Apr 2022 00:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220406041627.643617-1-kuba@kernel.org>
In-Reply-To: <20220406041627.643617-1-kuba@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 6 Apr 2022 09:50:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a28s+NkN2XLghBgXA5i_g56z0yK0H3CVMZkLpamyZt2qw@mail.gmail.com>
Message-ID: <CAK8P3a28s+NkN2XLghBgXA5i_g56z0yK0H3CVMZkLpamyZt2qw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: atm: remove the ambassador driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, pabeni@redhat.com,
        Networking <netdev@vger.kernel.org>, myxie@debian.org,
        Jesper Juhl <jj@chaosbits.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 6:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> The driver for ATM Ambassador devices spews build warnings on
> microblaze. The virt_to_bus() calls discard the volatile keyword.
> The right thing to do would be to migrate this driver to a modern
> DMA API but it seems unlikely anyone is actually using it.
> There had been no fixes or functional changes here since
> the git era begun.
>
> In fact it sounds like the FW loading was broken from 2008
> 'til 2012 - see commit fcdc90b025e6 ("atm: forever loop loading
> ambassador firmware").
>
> Let's remove this driver, there isn't much changing in the APIs,
> if users come forward we can apologize and revert.
>
> Link: https://lore.kernel.org/all/20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: myxie@debian.org,gprocida@madge.com
> CC: Jesper Juhl <jj@chaosbits.net>
> CC: Dan Carpenter <dan.carpenter@oracle.com>
> CC: Chas Williams <3chas3@gmail.com> # ATM
> CC: linux-atm-general@lists.sourceforge.net
> CC: tsbogend@alpha.franken.de # MIPS
> CC: linux-mips@vger.kernel.org
> CC: p.zabel@pengutronix.de # dunno why, get_maintainer
> ---
>  arch/mips/configs/gpr_defconfig  |    1 -
>  arch/mips/configs/mtx1_defconfig |    1 -
>  drivers/atm/Kconfig              |   25 -
>  drivers/atm/Makefile             |    1 -
>  drivers/atm/ambassador.c         | 2400 ------------------------------
>  drivers/atm/ambassador.h         |  648 --------

Acked-by: Arnd Bergmann <arnd@arndb.de>
