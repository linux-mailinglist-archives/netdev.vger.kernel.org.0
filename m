Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C96B65931D
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 00:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbiL2XTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 18:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiL2XSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 18:18:53 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A66C167DC;
        Thu, 29 Dec 2022 15:18:52 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id fc4so48017535ejc.12;
        Thu, 29 Dec 2022 15:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nKD4sJvY8u64R4lrHG7fSPlR5NgK9Ot3QdTgymkFPk4=;
        b=A1G/xzVKyRmQOfDsg8QC6+flkO9ORVgWYbr+iMzLp4FFAu25Sd940VxIx5IkDevPti
         ki1vPF9teW/7MhHSyZZaWUjbOPIQ57aAqcCNZ99mBiTmla8maFfzoO5cHuIxQgHXlB4a
         2ND9wNie4pYbBhYlAiDndGCLedFxWem++Mz06Qadn4kOmfg6ZRkhIk/8FvP17Ue6KDCb
         iDXA2uz4DlWxAu30tzjl/ONi3DzpoKgbIwijKIYAdlI/5wLNKmjtvtRwSORShHdkJPYa
         5J9S7wXYLVZvNXNttBp24FzzOiXjKzfcZvtlx/ShMUj2+vYLmlEO7fVWrS6C8dhjzRLP
         iH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nKD4sJvY8u64R4lrHG7fSPlR5NgK9Ot3QdTgymkFPk4=;
        b=QoeJvmvSZsD9fS+hDBz5GXG4cOM6VYmv9tkxOC8sbWRRWHquanqrsQD5SUBb3darIS
         0S6SyWKS4yJ+i0GFu0GR4giZtM3KYmmZD+mYIcqOYDKRnIURKEwZ+jfrsqMQk7xN2hgL
         8Rs9TjDVy4ZOCoNqlo7TWjTu7R56KR60LkTQmdb9dTPHA2dk5uts7hViv0ajZ9PvHCGa
         jFE/YN7BJoJDkdNRmgCoaaGTay9vhF2LkDMSGRk/VeptDt1D0pGi8Feg4WL+ktydaF+n
         XVbsBV2e8CvnRCQ/vEHYvt+ltV0sGA2LOaXh3+8PqrXeIwfD4FPsROa9ZQ+ZTYoPVDsG
         xZHQ==
X-Gm-Message-State: AFqh2krcLC282LWndnXZVIUDkVEVyrDpvsAtsLZPNft0PlQSjQEV3mUC
        cSnNWTblML/Ln3iyDpRAqDDXtkrXQxkoP0h8UMA=
X-Google-Smtp-Source: AMrXdXubUgI5QrUr9jQhMlRzP8ft2o7xEYt/jx8JmTEK8dKUAm4wI10/ibMcbPMziEtfHpDwzz4ralS47JWHJNcnCcc=
X-Received: by 2002:a17:906:26d2:b0:7c1:36:8ffe with SMTP id
 u18-20020a17090626d200b007c100368ffemr2089811ejc.725.1672355930684; Thu, 29
 Dec 2022 15:18:50 -0800 (PST)
MIME-Version: 1.0
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com> <8fe9b10318994be18934ec41e792af56@realtek.com>
In-Reply-To: <8fe9b10318994be18934ec41e792af56@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 30 Dec 2022 00:18:39 +0100
Message-ID: <CAFBinCBcurqiHJRSyaFpweYmrgaaUhpy632QQNWcrd3UHRtZbQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/19] rtw88: Add SDIO support
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

thanks again for all your input!

On Thu, Dec 29, 2022 at 5:19 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
[...]
> > - RX throughput on a 5GHz network is at 19 Mbit/s
>
> I have a suggestion about RX throughput, please check below registers with
> vendor driver:
>
> REG_RXDMA_AGG_PG_TH
> REG_TXDMA_PQ_MAP(0x10c) BIT_RXDMA_AGG_EN (bit2)
> REG_RXDMA_MODE(0290)  BIT_DMA_MODE (bit1)
Unfortunately I didn't manage to get the vendor driver to work with
mainline Linux.
The Android installation on my board (which is how it was shipped)
uses the vendor driver but unlike some Amlogic code the Realtek
(vendor) wireless driver does not allow reading arbitrary registers
through sysfs.
So I can't check the values that the vendor driver uses.

> Try to adjust AGG_PG_TH to see if it can help.
I tried a few values and I can say that it does change the RX
throughput, but the result is always lower than 19 Mbit/s, meaning
that it's worse than RX aggregation disabled (on my RTL8822CS).
Currently we're disabling RX aggregation in the driver. But Jernej
mentioned previously that for his RTL8822BS he found that RX
aggregation seems to improve performance.

Independent of this I did some investigation on my own and found that
when reducing the TX throughput the RX throughput increases.
For this I tried using ieee80211_{stop,wake}_queue() in the sdio.c HCI
sub-driver.
RX throughput is now at 23.5 Mbit/s (that +25% compared to before) on
my RTL8822CS (with RX aggregation still disabled, just like in the 19
Mbit/s test).
Unfortunately TX throughput is now way below 10 Mbit/s.

Additionally I think that the antenna of my board is worse than my
access point's antenna. So TX from rtw88 to my AP may be faster
(because the AP can "hear better") than RX (rtw88 "hearing is worse").

For today I'm tired and will stop here.


Best regards,
Martin


[0] https://github.com/xdarklight/linux/commit/3f2e6b9cd40dc785b5c72dbc9c8b471a2e205344
