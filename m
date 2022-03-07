Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309F04CEFBD
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiCGCpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiCGCpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:45:06 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDABF5D5E5;
        Sun,  6 Mar 2022 18:44:03 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id i18so1366712vkr.13;
        Sun, 06 Mar 2022 18:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yd+nulc0Iga+22h749FCWw0jCYaxdTf5XtknT7WGKow=;
        b=ZAhx4gB0Xu3k3oeGTB5xfMFhqLLeTJxIJsnU+poY8ssPsEj7ziWmqkTxsJmVi3m2O6
         4RgvuU7D5OMHwA2kn4eEG2+vubbgzxS+lgzfydvDhyjft4mkZz4QsxdHg0XSGOqWUG3U
         DzuK78fCsU5BFfW/03psTMu7giU4uVMj2Qke+Gjh8uLnI46OAtZyjIxYsrnP4bFcBjeE
         sgFAl+MXrHWZrETzf2GF9431RcO0DarQQXdE71j95gud7Am3xVb31cEsjkeIx6j+XY/I
         IFEsmJnd6Cfi9d6cK1p1e3VDjs+IkiJnUm4KLB1Z8LIzIuEfWoDmidYEVYY5RMfT3YRo
         ge+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yd+nulc0Iga+22h749FCWw0jCYaxdTf5XtknT7WGKow=;
        b=eCLcR6TMgiPxrTyUKrusyaeflWbprMty4qUjn+fBTzfJYUT+awvagF/orp9hixhr8+
         8qVDwIxak7Q06wd+gZv2wkswX9b/+2qXwAljNmXXTFi15xODxF065MroZLEHWN+WiOYX
         JwPW46LWo0e54GvUurHRv6qawuhu6QVztmwjl0uy5WQrG2H3CW2zxA/H/T7gg0qkuOZv
         E6yKfrEV3JB2Y4w7Zd/+eBlFgLi9KKJEzVZ0mEA2KMOr7ZUIohfTNcXuLhMZf3XHWB4G
         6K7/cway4D0payD8tVDZmb3hNs9J9IAaETKAjQ3WYjm7feazgUF37BBhIuRbSb5qEa1n
         7yBg==
X-Gm-Message-State: AOAM533ihTAEI//01XCzzNrrb13AT+aJPrZbpw7NolS0pNjS3FQ6soJ2
        l1q8vXodb3TVoagHxlI4gY8hBTZV2YawA7EmbNk=
X-Google-Smtp-Source: ABdhPJz7UMNZf0KAFrMLRaa2vTBCL6ahz6QkuxtYnpb5woYu3BtOZb5z1EUe5b4P/gTNOh8K5HOiDNg2cmGjN/+49FE=
X-Received: by 2002:a1f:6101:0:b0:336:ea3c:48b0 with SMTP id
 v1-20020a1f6101000000b00336ea3c48b0mr3066349vkb.19.1646621043077; Sun, 06 Mar
 2022 18:44:03 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-4-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220223223326.28021-4-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 7 Mar 2022 05:44:12 +0300
Message-ID: <CAHNKnsStshsku4FyHaYGJm=HWXpJH1J6S5Zras4te0NgHr1oDw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 03/13] net: wwan: t7xx: Add core components
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
> Registers the t7xx device driver with the kernel. Setup all the core
> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> modem control operations, modem state machine, and build
> infrastructure.
>
> * PCIe layer code implements driver probe and removal.
> * MHCCIF provides interrupt channels to communicate events
>   such as handshake, PM and port enumeration.
> * Modem control implements the entry point for modem init,
>   reset and exit.
> * The modem status monitor is a state machine used by modem control
>   to complete initialization and stop. It is used also to propagate
>   exception events reported by other components.

[skipped]

> +static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
> +{
> +       struct device *dev = &t7xx_dev->pdev->dev;
> +       struct t7xx_modem *md;
> +
> +       md = devm_kzalloc(dev, sizeof(*md), GFP_KERNEL);
> +       if (!md)
> +               return NULL;
> +
> +       md->t7xx_dev = t7xx_dev;
> +       t7xx_dev->md = md;
> +       md->core_md.ready = false;
> +       spin_lock_init(&md->exp_lock);
> +       md->handshake_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
> +                                          0, "md_hk_wq");
> +       if (!md->handshake_wq)
> +               return NULL;
> +
> +       INIT_WORK(&md->handshake_work, t7xx_md_hk_wq);
> +       return md;
> +}
> +
> +int t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
> +{
> +       struct t7xx_modem *md = t7xx_dev->md;
> +
> +       md->md_init_finish = false;
> +       md->exp_id = 0;
> +       spin_lock_init(&md->exp_lock);

Looks like a duplicated initialization, the first time the lock was
initialized in the t7xx_md_alloc() above.

> +       t7xx_fsm_reset(md);
> +       t7xx_cldma_reset(md->md_ctrl[CLDMA_ID_MD]);
> +       md->md_init_finish = true;
> +       return 0;
> +}

[skipped]

> +void t7xx_pcie_set_mac_msix_cfg(struct t7xx_pci_dev *t7xx_dev, unsigned int irq_count)
> +{
> +       u32 val;
> +
> +       val = ffs(irq_count) * 2 - 1;

Move this initialization to the variable declaration.

> +       iowrite32(val, IREG_BASE(t7xx_dev) + T7XX_PCIE_CFG_MSIX);
> +}

--
Sergey
