Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7DD1C54EB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgEEL7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 07:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728238AbgEEL7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 07:59:22 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C69C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 04:59:22 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id s9so1131330lfp.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 04:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uvyOYLDN9I6G44mzBr+eJp9UfWHxSSZYkeApkR1DRBs=;
        b=hHN3cpNowtbVxjqPXfJfjcZuJmb+J5Kee+wNPfV9hQkfN6yoyfeyUucbR++axL8aVO
         fpMlI4YRF0nBgFxj0vf15GhO5Tu6ZjZhlnzuV7hw2ZRQQlbMzyng/Z8bKQscC6Oaufq8
         l1GmOUQksiW11jYhrFJ4wBF5dsH0k9uAhQH7d8UQF4PlFwcA3sCFOfkX/xyTMNnoIWOF
         qytR5uXEloKnzfJ+g5FAPbCMc/nIfqmt+qIm3f1NMUgRG9dwDyRuYHU5O9nE8S85orQx
         hNBEhK7Z/1qq73yW5LxMcV/YZUA6QH8SQO/N9TvmN4GiDfJHntWV+shP19bozbSAO+Xp
         rBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uvyOYLDN9I6G44mzBr+eJp9UfWHxSSZYkeApkR1DRBs=;
        b=IGVdUHA78meOdin4kzX6WJw1sZ9VJJqmQPc6kmaeBgDT5GSzCr2ZEvVmY4sgbwH6r9
         XmRqwC7clZ4cRFt38Cj3q68WK2Tr4nGFP+MDp+cKzcFfy3+oshTgkYM5+nzSKk/TPEvq
         0mtP9V7KHFwObWVI/FNf+B4B5A0T9mXs/QQAj5qnAzKzU8BYtjd47hCUshI7KlmpeB6S
         usLuqw1TR3Z4dn/MUfz/Jv05BDS/5xKgaMJSKHk91RKJUft63I+XHoLIeKubrXc/8Bal
         4KNebIcQ0Zo4JG0O5Qgt6yGWCAmxWeva22lheaa0XsAeexkbUXugwxOa0a2wtUqkUsiK
         Sf8g==
X-Gm-Message-State: AGi0PuaFfmA0VYRbun4kTxAbm33koXMQsplmk0uSwOgKsDJryXDaK9Ez
        YxXVBllbW1NjApfgK4KPoW5o+LE1vUYuhx5R+HUwoQ==
X-Google-Smtp-Source: APiQypIOI/I3XWJ7qttW55NOmWj7VnuraK3AIGYXqHuHAPnirsq/4IwWVzOkmHsLKcQv2q+P2ChRK+/WFoZed5VuL3Y=
X-Received: by 2002:a05:6512:1109:: with SMTP id l9mr1543834lfg.12.1588679960671;
 Tue, 05 May 2020 04:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
 <20200501205011.14899-4-grygorii.strashko@ti.com> <CADYN=9L+RtruRYKah0Bomh7UaPGQ==N9trd0ZoVQ3GTc-VY8Dg@mail.gmail.com>
 <1bf51157-9fee-1948-f9ff-116799d12731@ti.com> <CADYN=9LfqLLmKNHPfXEiQbaX8ELF78BL-vWUcX-VP3aQ86csNg@mail.gmail.com>
In-Reply-To: <CADYN=9LfqLLmKNHPfXEiQbaX8ELF78BL-vWUcX-VP3aQ86csNg@mail.gmail.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 5 May 2020 13:59:09 +0200
Message-ID: <CADYN=9LDCE2sQca12D4ow3BkaxXi1_bnc4Apu7pP4vnA=5AOKA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/7] net: ethernet: ti: am65-cpsw-nuss: enable
 packet timestamping support
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Networking <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 at 13:16, Anders Roxell <anders.roxell@linaro.org> wrote:
>
> On Tue, 5 May 2020 at 13:05, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
> >
> > hi Anders,
>
> Hi Grygorii,

Hi again,

>
> >
> > On 05/05/2020 13:17, Anders Roxell wrote:
> > > On Fri, 1 May 2020 at 22:50, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
> > >>
> > >> The MCU CPSW Common Platform Time Sync (CPTS) provides possibility to
> > >> timestamp TX PTP packets and all RX packets.
> > >>
> > >> This enables corresponding support in TI AM65x/J721E MCU CPSW driver.
> > >>
> > >> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > >> ---
> > >>   drivers/net/ethernet/ti/Kconfig             |   1 +
> > >>   drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  24 ++-
> > >>   drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 172 ++++++++++++++++++++
> > >>   drivers/net/ethernet/ti/am65-cpsw-nuss.h    |   6 +-
> > >>   4 files changed, 201 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> > >> index 1f4e5b6dc686..2c7bd1ccaaec 100644
> > >> --- a/drivers/net/ethernet/ti/Kconfig
> > >> +++ b/drivers/net/ethernet/ti/Kconfig
> > >> @@ -100,6 +100,7 @@ config TI_K3_AM65_CPSW_NUSS
> > >>          depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
> > >>          select TI_DAVINCI_MDIO
> > >>          imply PHY_TI_GMII_SEL
> > >> +       imply TI_AM65_CPTS
> > >
> > > Should this be TI_K3_AM65_CPTS ?

instead of 'imply TI_K3_AM65_CPTS' don't you want to do this:
'depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS'


Cheers,
Anders

> > >
> > > I did an arm64 allmodconfig build on todays next tag: next-20200505
> > > and got this undefined symbol:
> > >
> > > aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> > > function `am65_cpsw_init_cpts':
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:
> > > undefined reference to `am65_cpts_create'
> > > aarch64-linux-gnu-ld:
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1685:(.text+0x2e20):
> > > relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> > > `am65_cpts_create'
> > > aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> > > function `am65_cpsw_nuss_tx_compl_packets':
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:923:
> > > undefined reference to `am65_cpts_tx_timestamp'
> > > aarch64-linux-gnu-ld:
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:923:(.text+0x4cf0):
> > > relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> > > `am65_cpts_tx_timestamp'
> > > aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> > > function `am65_cpsw_nuss_ndo_slave_xmit':
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1018:
> > > undefined reference to `am65_cpts_prep_tx_timestamp'
> > > aarch64-linux-gnu-ld:
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1018:(.text+0x58fc):
> > > relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> > > `am65_cpts_prep_tx_timestamp'
> > > aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-nuss.o: in
> > > function `am65_cpsw_nuss_hwtstamp_set':
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1265:
> > > undefined reference to `am65_cpts_rx_enable'
> > > aarch64-linux-gnu-ld:
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-nuss.c:1265:(.text+0x7564):
> > > relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> > > `am65_cpts_rx_enable'
> > > aarch64-linux-gnu-ld: drivers/net/ethernet/ti/am65-cpsw-ethtool.o: in
> > > function `am65_cpsw_get_ethtool_ts_info':
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-ethtool.c:713:
> > > undefined reference to `am65_cpts_phc_index'
> > > aarch64-linux-gnu-ld:
> > > /srv/src/kernel/next/obj-arm64-next-20200505/../drivers/net/ethernet/ti/am65-cpsw-ethtool.c:713:(.text+0xbe8):
> > > relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol
> > > `am65_cpts_phc_index'
> > > make[1]: *** [/srv/src/kernel/next/Makefile:1114: vmlinux] Error 1
> > > make[1]: Target 'Image' not remade because of errors.
> > > make: *** [Makefile:180: sub-make] Error 2
> > > make: Target 'Image' not remade because of errors.
> >
> > Sry, I can't reproduce it net-next.
>
> Oh I forgot to try net-next, sorry.
>
> > trying next...
>
> Thank you.
>
> > What's your config?
>
> This is the config [1] I used.
>
> Cheers,
> Anders
> [1] https://people.linaro.org/~anders.roxell/kernel-next-20200505.config
>
> >
> > --
> > Best regards,
> > grygorii
