Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE7A495DD3
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380020AbiAUKhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbiAUKhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:37:38 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E16FC061574;
        Fri, 21 Jan 2022 02:37:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c24so38933454edy.4;
        Fri, 21 Jan 2022 02:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wtu938bAAaQ3ZnDK8gjmaHpiCBPkE7NzcrpnXEzoRwI=;
        b=UdXBcRwHEEeo0wU3Qe7k3XoLo4cHDaMI8yY93id1Ju8jBQGqN4jFiJ4TH8DdTJdbV5
         FoKfVRNdwBbJ7KzrRcBvcc+eJrBjW1lQ65hYQBPLeWO5teDhzNfhCw6gRTNSfN6oH0+D
         X9UwUrQ+Yvft68uiwcjL+RoSaJcLVbYe3OVxLti9smoEh2nTqV+i83/+urqMqTYZTRMK
         RzIPHXuVFKQMYq5LN+2hOJX8poA14nqCFon4qY5a/ZH64GqKP17N9YZgljOW9ZMqAEA1
         VATpGRPUEwcZOxiGj47EJ83Ty+5zsP8yMBOJaaOdK3gbVIEXxwiqQiNbd/re43p0slnk
         TIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wtu938bAAaQ3ZnDK8gjmaHpiCBPkE7NzcrpnXEzoRwI=;
        b=2y8jKxYkknJph1py47Bj6X0dZBzHigFWc1XUEj2XStUSdwbGFtSz/aro/OFhq3BaSm
         yh5fCyr/xmmJD1uLwWZE0MUrlD9gCuRcF8tJrtJlyf0772lBYXgsZMT6VDiwYF6W8+Rz
         P01FKWCeCVfSHNoIVXCRRoKWoKMBi4X94Wei8CAnC3fFe28cbYUmi75JWS6YAM7Rwo4e
         0fI2eA2CkbNBmrfGIYwcxcl2bqOx0VplmRtu7jVyuMNLasrIP4GSVCgs+z2OJlT3FxMy
         m9qzTXMnfyoU28dKsuWAEr196x3w9R6sNQ+wagbVHMsTgngGfv/W2TyctxP1KjAMPosj
         hSmA==
X-Gm-Message-State: AOAM530SfUt3R+BvMOFZiMn6WSZdrsLVyl5Zsvenphhp4+vx1jzGp7qX
        F3rK3MlKfmBd4KMfmVUrr/9tZYM0FboEGMM2Z6A=
X-Google-Smtp-Source: ABdhPJy2dPZ5sFbj9ascaNf0QS1lzkHgAppi7foNYu8XKasCKwKVFgOk+oa3owvO5pgXGXQH3vlJKz4bML+iFmyePi4=
X-Received: by 2002:a05:6402:35d3:: with SMTP id z19mr3569830edc.29.1642761456398;
 Fri, 21 Jan 2022 02:37:36 -0800 (PST)
MIME-Version: 1.0
References: <20220121041428.6437-1-josright123@gmail.com> <20220121041428.6437-3-josright123@gmail.com>
In-Reply-To: <20220121041428.6437-3-josright123@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 21 Jan 2022 12:37:00 +0200
Message-ID: <CAHp75Vc9pJMNfW2roUbdrcxCSvyGboTsJC0oTDCcTAS5bmF08w@mail.gmail.com>
Subject: Re: [PATCH v12, 2/2] net: Add dm9051 driver
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 6:15 AM Joseph CHAMG <josright123@gmail.com> wrote:
>
> v1-v4
>
> Add davicom dm9051 spi ethernet driver. The driver work for the
> device platform with spi master
>
> Test ok with raspberry pi 2 and pi 4, the spi configure used in
> my raspberry pi 4 is spi0.1, spi speed 31200000, and INT by pin 26.
>
> v5
>
> Work to eliminate the wrappers to be clear for read, swapped to
> phylib for phy connection tasks.
>
> Tested with raspberry pi 4. Test for netwroking function, CAT5
> cable unplug/plug and also ethtool detect for link state, and
> all are ok.
>
> v6
>
> remove the redundant code that phylib has support,
> adjust to be the reasonable sequence,
> fine tune comments, add comments for pause function support
>
> Tested with raspberry pi 4. Test for netwroking function, CAT5
> cable unplug/plug and also ethtool detect for link state, and
> all are ok.
>
> v7
>
> read/write registers must return error code to the callet,
> add to enable pause processing
>
> v8
>
> not parmanently set MAC by .ndo_set_mac_address
>
> correct rx function such as clear ISR,
> inblk avoid stack buffer,
> simple skb buffer process and
> easy use netif_rx_ni.
>
> simplely queue init and wake the queues,
> limit the start_xmit function use netif_stop_queue.
>
> descript that schedule delay is essential
> for tx_work and rxctrl_work
>
> eliminate ____cacheline_aligned and
> add static int msg_enable.
>
> v9
>
> use phylib, no need 'select MII' in Kconfig,
> make it clear in dm9051_xfer when using spi_sync,
> improve the registers read/write so that error code
> return as far as possible up the call stack.
>
> v10
>
> use regmap APIs for SPI and MDIO,
> modify to correcting such as include header files
> and program check styles
>
> v11
>
> eliminate the redundant code for struct regmap_config data
> use regmap_read_poll_timeout
> use corresponding regmap APIs, i.e. MDIO, SPI
> all read/write registers by regmap
> all read/write registers with mutex lock by regmap
> problem: regmap MDIO and SPI has no .reg_update_bits, I write it
> in the driver
> problem: this chip can support bulk read/write to rx/tx data, but
> can not support bulk read/write to continue registers, so need
> read/write register one by one
>
> v12
>
> correctly use regmap bulk read/write/update_bits APIs
> use mdiobus to work to phylib and to this driver
> fine tune to arrange the source code to better usage

This is not tagged properly. Also, I specifically removed everything
else to point out, please, read finally the article [1] and write a
proper commit message. And move changelog under the cutter '--- '
line. Without doing these two things nobody can do anything with your
contribution.

[1]: https://cbea.ms/git-commit/


-- 
With Best Regards,
Andy Shevchenko
