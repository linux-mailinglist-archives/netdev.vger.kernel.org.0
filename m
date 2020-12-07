Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE802D18E9
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgLGTB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgLGTBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:01:25 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD2EC061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 11:00:45 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id b8so13180100ila.13
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 11:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cr00/iGSYlkD4Pyi5lzd0kE84mDyXOXTl5aNYanmYgs=;
        b=A7/V5B0kmxa84eivb+NwTtiAgFcOP20lcsH03pvuLhI1xEDAXo71QMqZTSJk8aqKWI
         MKrP0f7j29TC6NCjd6pR/PZov1rq9yzTahMU+moNcOHMkLuqgjVqNfaBAE3zkwjkVJ99
         IrcXEVJK5yMCTTRCYuJuxvXaOVCbkSEESkup1SOw2/4hOP7jYglPdYsfE9eBOaM+t0FF
         QyEj22VA/GIOrNVTmU3tXy0nkpA0H801aPTOgvu8Fbk21qXP17UuVX4SmlsgLkQXC6a9
         Bvw3oD02XM2nZS2VJqL2uK9hfxo2LNfaV3AhQUE+l3ELzH+sL/gQtri43CVsR5vz1Zhr
         /6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cr00/iGSYlkD4Pyi5lzd0kE84mDyXOXTl5aNYanmYgs=;
        b=YDOohEha218s73UWOafhLDCcFn+/g/Wt5nFFuN+JwtKrvyUNYc2iVU6mj7HvU5b4vh
         DCMTAe4Kf7iWILQVZAVNf3q4GlzbKdjWgM/NyMNacEoXAhJYEnvU/6Q98DbjEle2F7V6
         AV77cilZqXkeGvRGGT4VJ7B3g5fMRRiDNiiDfc6TxzJQtcsitdxYBWo9kFc5b8j/gR4c
         sD0a2CIeLGYfquDEAv3BRirs5x82rChwddrsBNEo3ZSFJS3AzDvxtoNIhyBkSkFbPMjn
         tWJOCXJeLVlSaSd14iDNxm/pJcdX0qwXRuvMKRtbv+eGLTG+rixqTBLTXu886WO8Dzgz
         eWZw==
X-Gm-Message-State: AOAM531J4BbyarEEUgybpSVETQ1Hxea0Q25LvaDWNLzr7ouDx54PUAq1
        kC5jzvENFjPGHklkppEHhmZoPsOXu2uppRK8dwU=
X-Google-Smtp-Source: ABdhPJzJc1yJ3VTLiopPSIhNFZdy34Dadz5bWSTARCLKjTpBumACxR03YKSk1OnOp52lnNqJHNoW80uaDutcxuGl0Ng=
X-Received: by 2002:a92:d44f:: with SMTP id r15mr23704658ilm.237.1607367644941;
 Mon, 07 Dec 2020 11:00:44 -0800 (PST)
MIME-Version: 1.0
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com> <1607083875-32134-4-git-send-email-akiyano@amazon.com>
In-Reply-To: <1607083875-32134-4-git-send-email-akiyano@amazon.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 7 Dec 2020 11:00:34 -0800
Message-ID: <CAKgT0Ueaa-63KGuvhDMT+emk4UoXPUW4SFB8GbxhNj4N5SDwYg@mail.gmail.com>
Subject: Re: [PATCH V4 net-next 3/9] net: ena: add explicit casting to variables
To:     akiyano@amazon.com
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, ndagan@amazon.com, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>, Ido Segev <idose@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 4:15 AM <akiyano@amazon.com> wrote:
>
> From: Arthur Kiyanovski <akiyano@amazon.com>
>
> This patch adds explicit casting to some implicit conversions in the ena
> driver. The implicit conversions fail some of our static checkers that
> search for accidental conversions in our driver.
> Adding this cast won't affect the end results, and would sooth the
> checkers.
>
> Signed-off-by: Ido Segev <idose@amazon.com>
> Signed-off-by: Igor Chauskin <igorch@amazon.com>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_com.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
> index e168edf3c930..7910d8e68a99 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_com.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
> @@ -1369,7 +1369,7 @@ int ena_com_execute_admin_command(struct ena_com_admin_queue *admin_queue,
>                                    "Failed to submit command [%ld]\n",
>                                    PTR_ERR(comp_ctx));
>
> -               return PTR_ERR(comp_ctx);
> +               return (int)PTR_ERR(comp_ctx);
>         }
>
>         ret = ena_com_wait_and_process_admin_cq(comp_ctx, admin_queue);

I'm not a big fan of resolving it this way as we are going to end up
with the pattern throughout the kernel if this is really needed. It
might make more sense to either come up with a new define that returns
int instead of long, or to tweak the existing PTR_ERR define so that
it returns an int instead of a long.

An alternative here would be to just pass PTR_ERR into ret and then
process it that way within this if block. As it stands the comparison
to ERR_PTR(-ENODEV) doesn't read very well anyway.

> @@ -1595,7 +1595,7 @@ int ena_com_set_aenq_config(struct ena_com_dev *ena_dev, u32 groups_flag)
>  int ena_com_get_dma_width(struct ena_com_dev *ena_dev)
>  {
>         u32 caps = ena_com_reg_bar_read32(ena_dev, ENA_REGS_CAPS_OFF);
> -       int width;
> +       u32 width;
>
>         if (unlikely(caps == ENA_MMIO_READ_TIMEOUT)) {
>                 netdev_err(ena_dev->net_device, "Reg read timeout occurred\n");
> @@ -2266,7 +2266,7 @@ int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, int mtu)
>         cmd.aq_common_descriptor.opcode = ENA_ADMIN_SET_FEATURE;
>         cmd.aq_common_descriptor.flags = 0;
>         cmd.feat_common.feature_id = ENA_ADMIN_MTU;
> -       cmd.u.mtu.mtu = mtu;
> +       cmd.u.mtu.mtu = (u32)mtu;
>
>         ret = ena_com_execute_admin_command(admin_queue,
>                                             (struct ena_admin_aq_entry *)&cmd,

Wouldn't it make more sense to define mtu as a u32 in the first place
and address this in the function that calls this rather than doing the
cast at the last minute?

> @@ -2689,7 +2689,7 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
>                 return ret;
>         }
>
> -       cmd.control_buffer.length = (1ULL << rss->tbl_log_size) *
> +       cmd.control_buffer.length = (u32)(1ULL << rss->tbl_log_size) *
>                 sizeof(struct ena_admin_rss_ind_table_entry);
>
>         ret = ena_com_execute_admin_command(admin_queue,
> @@ -2712,7 +2712,7 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
>         u32 tbl_size;
>         int i, rc;
>
> -       tbl_size = (1ULL << rss->tbl_log_size) *
> +       tbl_size = (u32)(1ULL << rss->tbl_log_size) *
>                 sizeof(struct ena_admin_rss_ind_table_entry);
>
>         rc = ena_com_get_feature_ex(ena_dev, &get_resp,

For these last two why not make it 1u instead of 1ull for the bit
being shifted? At least that way you are not implying possible
truncation in the conversion.
