Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA14C429BC9
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 05:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhJLDNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 23:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbhJLDNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 23:13:36 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC0EC06174E
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 20:11:34 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x27so81407289lfa.9
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 20:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w2FJM5xq0hHLOwYkxQq9HjtkvFRksFK+c9CUBnhMlUA=;
        b=ECxgpBAgFN57M9Muv6HgPW+2gsbKzFTgbdkbk/wcoXHhkLozGpRLLlOMDYegVvygHN
         2py0lXASeUR5ykVbr81UL/hPafzHt+NJHhyIvmIYcmytMQ6GdAJ8dUABYBTqcJvXUoDk
         df377gxkJR4hl2XnoHq6H5fg1PhPosrjlO+vw06vz95++L7FV4HiYbwq2J1WFfNnN/jf
         Mx2ogkRKfRgA5smJ82Ca1+NvpsHAbDGCT+LpTXs64ymH6okmPAuVxvDsTmmJO9KVLgUG
         pZxdks765lI2PhK8KGoyJxBi3yRR/GHoeDDoq3qeWcq50tyooD3LpiVGlx8t8P9OlzUu
         Hbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w2FJM5xq0hHLOwYkxQq9HjtkvFRksFK+c9CUBnhMlUA=;
        b=p1ybbyLWWST8RGjJ+s+w3aXfgTirrFsNF4VX2mnbrgK4Nv3vBILXrlzMhwZDkN/lOa
         jf8Hh7iEeW54arpaw2R5Sf3eC0lOe44V/NAYOElTY4Yrk1H/pgRgFEhKVH9lMQ5/doKP
         TBzZ7Y73mWoj0FJNKcI5KFC0uv6HeVrrD4+bQ34pFl0dWT4BCHeYkDG1mrn9Mdu/u1aS
         FDWSttz9sBFvIl2UJAF0EGrDnE2GOmQl2e8LB4kSedRae1UF/ODDwt4HlvXb2YtW9J6n
         l6tnlYvO6LgjWH5mtqZ9ca4e4DCdvAe0kMFexQZR2E4+wzrRZnG3rI03LzhU7wCsCpXr
         Hu0g==
X-Gm-Message-State: AOAM531/OvA8xzogspPYDuWKOQS5onDjHAqrw4BVbvrXyPBrnc7uOJs2
        wPVXDfzd2ziYqyhxyezmNb0CQsyaLDNONzs9WR69kw==
X-Google-Smtp-Source: ABdhPJyrNsMKS3+CiKmx5Tie0/Y10h5OgwLQcjWxqMC9cxgYiRdOXIj2B1esdvuIxFjjlUZ3q1gGQg9rDQ/7FbCROq4=
X-Received: by 2002:a05:651c:b21:: with SMTP id b33mr25766490ljr.515.1634008293091;
 Mon, 11 Oct 2021 20:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211007151010.333516-1-arnd@kernel.org> <20211007151010.333516-2-arnd@kernel.org>
In-Reply-To: <20211007151010.333516-2-arnd@kernel.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Mon, 11 Oct 2021 20:11:20 -0700
Message-ID: <CALAqxLVVEi67HQbjCSvfDPmfjeeZ4ROvqa8yfYMnRmeyi34Ddw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] qcom_scm: hide Kconfig symbol
To:     Arnd Bergmann <arnd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DRM DRIVER FOR MSM ADRENO GPU" 
        <freedreno@lists.freedesktop.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alex Elder <elder@linaro.org>,
        Amit Pundir <amit.pundir@linaro.org>,
        Caleb Connolly <caleb.connolly@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 8:10 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> Now that SCM can be a loadable module, we have to add another
> dependency to avoid link failures when ipa or adreno-gpu are
> built-in:
>
> aarch64-linux-ld: drivers/net/ipa/ipa_main.o: in function `ipa_probe':
> ipa_main.c:(.text+0xfc4): undefined reference to `qcom_scm_is_available'
>
> ld.lld: error: undefined symbol: qcom_scm_is_available
> >>> referenced by adreno_gpu.c
> >>>               gpu/drm/msm/adreno/adreno_gpu.o:(adreno_zap_shader_load) in archive drivers/built-in.a
>
> This can happen when CONFIG_ARCH_QCOM is disabled and we don't select
> QCOM_MDT_LOADER, but some other module selects QCOM_SCM. Ideally we'd
> use a similar dependency here to what we have for QCOM_RPROC_COMMON,
> but that causes dependency loops from other things selecting QCOM_SCM.
>
> This appears to be an endless problem, so try something different this
> time:
>
>  - CONFIG_QCOM_SCM becomes a hidden symbol that nothing 'depends on'
>    but that is simply selected by all of its users
>
>  - All the stubs in include/linux/qcom_scm.h can go away
>
>  - arm-smccc.h needs to provide a stub for __arm_smccc_smc() to
>    allow compile-testing QCOM_SCM on all architectures.
>
>  - To avoid a circular dependency chain involving RESET_CONTROLLER
>    and PINCTRL_SUNXI, drop the 'select RESET_CONTROLLER' statement.
>    According to my testing this still builds fine, and the QCOM
>    platform selects this symbol already.
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Acked-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v2:
> - fix the iommu dependencies

Hey Arnd,
   Thanks again so much for working out these details. Also my
apologies, as Bjorn asked for me to test this patch, but I wasn't able
to get to it before it landed.  Unfortunately I've hit an issue that
is keeping the db845c from booting with this.

> diff --git a/drivers/iommu/arm/arm-smmu/Makefile b/drivers/iommu/arm/arm-smmu/Makefile
> index e240a7bcf310..b0cc01aa20c9 100644
> --- a/drivers/iommu/arm/arm-smmu/Makefile
> +++ b/drivers/iommu/arm/arm-smmu/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_QCOM_IOMMU) += qcom_iommu.o
>  obj-$(CONFIG_ARM_SMMU) += arm_smmu.o
> -arm_smmu-objs += arm-smmu.o arm-smmu-impl.o arm-smmu-nvidia.o arm-smmu-qcom.o
> +arm_smmu-objs += arm-smmu.o arm-smmu-impl.o arm-smmu-nvidia.o
> +arm_smmu-$(CONFIG_ARM_SMMU_QCOM) += arm-smmu-qcom.o
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c b/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
> index 9f465e146799..2c25cce38060 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
> @@ -215,7 +215,8 @@ struct arm_smmu_device *arm_smmu_impl_init(struct arm_smmu_device *smmu)
>             of_device_is_compatible(np, "nvidia,tegra186-smmu"))
>                 return nvidia_smmu_impl_init(smmu);
>
> -       smmu = qcom_smmu_impl_init(smmu);
> +       if (IS_ENABLED(CONFIG_ARM_SMMU_QCOM))
> +               smmu = qcom_smmu_impl_init(smmu);
>
>         if (of_device_is_compatible(np, "marvell,ap806-smmu-500"))
>                 smmu->impl = &mrvl_mmu500_impl;


The problem with these two chunks is that there is currently no
CONFIG_ARM_SMMU_QCOM option. :)

Was that something you intended to add in the patch?

I'm working up a Kconfig patch to do so, so I'll send that out in a
second here, but let me know if you already have that somewhere (I
suspect you implemented it and just forgot to add the change to the
commit), as I'm sure your Kconfig help text will be better than mine.
:)

Again, I'm so sorry I didn't get over to testing your patch before
seeing this here!

thanks
-john
