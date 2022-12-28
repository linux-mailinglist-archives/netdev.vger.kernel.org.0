Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E90F65763A
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 13:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiL1MAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 07:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiL1L74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 06:59:56 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0441057E;
        Wed, 28 Dec 2022 03:59:55 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c34so15967790edf.0;
        Wed, 28 Dec 2022 03:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y3dCBduSZep7OtTaS9LhWzGoxt4oPR9hKAZLosj+w9Y=;
        b=O1B4AaBRlbaNtr6ENlhGMOwiBXypMphOmNmFl+u1EV1ALRUIuRz89SY14mNhOiryww
         NLJaCfn9E+XWOFUfDXpftsyH4Ot4I6tq1NCQVCng1NN8NFCEFRES4HMc5w0zeWtZAIiD
         /Ydzi/ZIcCC/0gkLvGOdcKMcCWB8vVRgfGEY3u6hG8R/954epU8p/egwIePu3/p4eDoa
         vPw/jYJdO/cPXcYkHm1HemTRLyhJwoKiPW2XVk3b0jeq3OQV+/BAHbqeyoAcE2HIFdna
         33/7ghCqjhGxY26lNdwFSviFqxDTPyE7y3fS4WEjv/uL/8pKgF2Ofnn9VE9du3fTZHvq
         43cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y3dCBduSZep7OtTaS9LhWzGoxt4oPR9hKAZLosj+w9Y=;
        b=wiwMVLTxXIhRTNnn9S3Bic/aDYntOEyhRYdc9NSSoLQnOd4fbfDnMedZrxIHMwlnTP
         rE3ba5bmdVkNATiGoDTObgAqSueYK0eUCboVsdcFuj0GeduTu7LUTjGllCHYHaJHTax4
         Ofw7mdhuni6+16Fkg+ZC6rfXZMMHIWXt+KMpYGHBpFRz+zbWtLChH0Y4v5kI4uKPWRHT
         v5OsdPcr1lbJNEHOI1E74JSxfPrYhjsGWYGtMqtN9u71WT+GmSaPYGm+oSP/dTZhXuXe
         EnDTna8O82PuYPpdcDNNVQkbLb0B/VIDYJMcEZ9R+e33B1MU1a4J+FzZwZpZUyYxUkCd
         Hpbg==
X-Gm-Message-State: AFqh2krAo38OKHD50yevr8QXKQhTSd9V/QshfWpbkqYIvZSa0jsaSTLY
        90qaZlsEdIAgieRiDrsOzRFMpjEIQ+yPxR/13Zg=
X-Google-Smtp-Source: AMrXdXunyLRnGi+5FJ5SwEShJ34TGNrDu6XFzxjG/T4X0i6iCX9AeAnSDYpw2vSBQ9EGT/1RBYyphnyr2L7UB5ORgQ0=
X-Received: by 2002:aa7:c0cd:0:b0:461:b033:90ac with SMTP id
 j13-20020aa7c0cd000000b00461b03390acmr2868918edp.257.1672228793315; Wed, 28
 Dec 2022 03:59:53 -0800 (PST)
MIME-Version: 1.0
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-13-martin.blumenstingl@googlemail.com> <2a9e671ef17444238fee3e7e6f14484b@realtek.com>
In-Reply-To: <2a9e671ef17444238fee3e7e6f14484b@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 28 Dec 2022 12:59:42 +0100
Message-ID: <CAFBinCDVq6o0c6OLSD0PhQKFPrXohjhdJeXk=5wuDEWMKwufrA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 12/19] rtw88: sdio: Add HCI implementation for SDIO
 based chipsets
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

as always: thank you so much for taking time to go through this!

On Wed, Dec 28, 2022 at 10:39 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
[...]
>
> > +
> > +static void rtw_sdio_writel(struct rtw_sdio *rtwsdio, u32 val,
> > +                         u32 addr, int *ret)
> > +{
> > +     u8 buf[4];
> > +     int i;
> > +
> > +     if (!(addr & 3) && rtwsdio->is_powered_on) {
> > +             sdio_writel(rtwsdio->sdio_func, val, addr, ret);
> > +             return;
> > +     }
> > +
> > +     *(__le32 *)buf = cpu_to_le32(val);
> > +
> > +     for (i = 0; i < 4; i++) {
> > +             sdio_writeb(rtwsdio->sdio_func, buf[i], addr + i, ret);
> > +             if (*ret)
>
> Do you need some messages to know something wrong?
It's not obvious but we're already logging that something went wrong.
The messages are logged in rtw_sdio_{read,write}{8,16,32}.
We do this because there's multiple ways to access data (direct,
indirect, ...) and some of them require multiple register operations.
So we print one message in the end.

[...]
> > +static u8 rtw_sdio_read_indirect8(struct rtw_dev *rtwdev, u32 addr, int *ret)
> > +{
> > +     struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> > +     u32 reg_cfg, reg_data;
> > +     int retry;
> > +     u8 tmp;
> > +
> > +     reg_cfg = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_CFG);
> > +     reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
> > +
> > +     rtw_sdio_writel(rtwsdio, BIT(19) | addr, reg_cfg, ret);
> > +     if (*ret)
> > +             return 0;
> > +
> > +     for (retry = 0; retry < RTW_SDIO_INDIRECT_RW_RETRIES; retry++) {
> > +             tmp = sdio_readb(rtwsdio->sdio_func, reg_cfg + 2, ret);
> > +             if (!ret && tmp & BIT(4))
>
> 'ret' is pointer, do you need '*' ?
Well spotted - thank you!

[...]
> As I look into sdio_readb(), it use 'int *err_ret' as arugment.
> Would you like to change ' int *ret' to 'int *err_ret'?
> It could help to misunderstand.
Sure, I'll do that

[...]
> > +             rtw_write16(rtwdev, REG_RXDMA_AGG_PG_TH, size |
> > +                         (timeout << BIT_SHIFT_DMA_AGG_TO_V1));
>
> BIT_RXDMA_AGG_PG_TH GENMASK(7, 0)       // for size
> BIT_DMA_AGG_TO_V1 GENMASK(15, 8)        // for timeout
Thanks, I'll use these

[...]
> > +static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
> > +{
> > +     u32 rx_len;
> > +
> > +     while (true) {
>
> add a limit to prevent infinite loop.
Do you have any recommendations on how many packets to pull in one go?
My thinking is: pulling to little data at once can hurt performance

[...]
>
> > +
> > +static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
> > +                                   enum rtw_tx_queue_type queue)
> > +{
> > +     struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
> > +     struct sk_buff *skb;
> > +     int ret;
> > +
> > +     while (true) {
>
> Can we have a limit?
Similar to the question above: do you have any recommendations on how
many packets (per queue) to send in one go?


Best regards,
Martin
