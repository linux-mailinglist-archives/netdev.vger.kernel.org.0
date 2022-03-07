Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B24CEFE0
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbiCGDAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 22:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiCGDAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 22:00:09 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974EBF2;
        Sun,  6 Mar 2022 18:59:16 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id b37so5933881uad.12;
        Sun, 06 Mar 2022 18:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DwmKfJl7N0omnrAbWRQ3gyHUelu2NH+BW7m5QDrltUI=;
        b=YhnxKRW01KDrt3qFj5iB2tkinUGPI1g5+cWaTneIY/PjJHVUSpTGO7FQtlj/ZbAeo6
         6Bvwn0rjQ1scXnyzXgFHsRdFxhCSLjD9Mtgk6ZOVySUBhbYEo8ELTPXyFJvQaOL+LIpJ
         iHzVSsvI7ofo56MxBeCowh1DJscFoY0hScbrYcj2S1EndYKqMwxZ3H7FMqQ7y8Ywi1tf
         q64ipvJKHGcFgrOv8y5d3iE+Al1+U3fC37eLWB3/5bDNQuv1PeCPWupFKEBby5k/WRjH
         ii+DpvcErYoOdaFOawV/UB60LXKY0rI6+Ds9V9u0qrl3dMtzp91VnDp3iSTeZ/2GFMWb
         Gzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DwmKfJl7N0omnrAbWRQ3gyHUelu2NH+BW7m5QDrltUI=;
        b=HmM4qgWQaSX3P1oOvz+3GjLHjIOaYy67mvJPtY4dQl2fw5/OqlxEFXbr1nNAnaIpSi
         AyOTW20pEzdesuwDf95h1dg8MKrmq3XaqO7pbKDFmgK6PvhGIcTOpyOst0MOD7pncf8i
         hh6LlkJGwB/zsbQeHsGEJdxsu/8j/1KJLJKMHBPfRLSKrWYCRyyWSIi2L6tSuK1jLJNZ
         XF6d7/PjezEqpzVMfHGWlPAF/HY9fCagh9R0AqnGYmCmx8k/mZhsLrWUJVie+D7xlQv4
         A6yCT2LODb8I2NEgX64TUemFtI0QDn9QRQMfdRUNEkmjucnVKWzfCrbksE/acdrfMjqO
         Ehcw==
X-Gm-Message-State: AOAM533DGNCWrORUVMSt8Xo97krKQjO/SvjuuAiNnprlcD5zD4pTYIFs
        p1sCaPklQ5fDqwO46hypBUrxEhmhPLif7wL4Egg=
X-Google-Smtp-Source: ABdhPJxqoGClZAh5pDUP5Efxd5on71A5iriTObCcsQ2l4OwpojUBn1MmyzuvQ+MwUmYdaLTeItdmvPFrWOJrWKShR5E=
X-Received: by 2002:ab0:7545:0:b0:34a:52b:760b with SMTP id
 k5-20020ab07545000000b0034a052b760bmr2528774uaq.74.1646621955758; Sun, 06 Mar
 2022 18:59:15 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-10-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220223223326.28021-10-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 7 Mar 2022 05:59:24 +0300
Message-ID: <CAHNKnsQqC1B+5c0jDqD2WUR2HB_-WKV4nvsRoCK-1Sn95x6xDA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 09/13] net: wwan: t7xx: Add WWAN network interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> Creates the Cross Core Modem Network Interface (CCMNI) which implements
> the wwan_ops for registration with the WWAN framework, CCMNI also
> implements the net_device_ops functions used by the network device.
> Network device operations include open, close, start transmission, TX
> timeout, change MTU, and select queue.

[skipped]

> +static u16 t7xx_ccmni_select_queue(struct net_device *dev, struct sk_buff *skb,
> +                                  struct net_device *sb_dev)
> +{
> +       return DPMAIF_TX_DEFAULT_QUEUE;
> +}

[skipped]

> +static const struct net_device_ops ccmni_netdev_ops = {
> +       .ndo_open         = t7xx_ccmni_open,
> +       .ndo_stop         = t7xx_ccmni_close,
> +       .ndo_start_xmit   = t7xx_ccmni_start_xmit,
> +       .ndo_tx_timeout   = t7xx_ccmni_tx_timeout,
> +       .ndo_select_queue = t7xx_ccmni_select_queue,

Since the driver works in the single queue mode, this callback is unneeded.

> +};

--
Sergey
