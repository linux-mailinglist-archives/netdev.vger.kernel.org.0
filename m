Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCC0425212
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241078AbhJGLe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241069AbhJGLew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 07:34:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B6DC061764
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 04:32:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g10so21460506edj.1
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 04:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyoTVfW0q/Sz3MjyHTCgqtubb6sYVUua8s/Tg/xpMNA=;
        b=rS7GjWh14BJN1s07cRh9Ip2/XMDUYffaHojGBth76ffHw6Tue2LTzLy2Ec/DiL9yZ4
         Wix9Prhd3bhQoOxA8upfQxS4A/0FqsbCThw2TL9WjSLhhmy3jWsWzBzAYf/67Z9e8Bzr
         6KWUNh/Bt9UfxZHZqa6yfxMauOYn/rJj7St0bL9FvkO+1EfYD/wLb9kRMIeg1v1mIg5Y
         QBrFfoAsI6RCfd6+XfCRAvNm9X70XlQeVvLCPNA0zOkZ6URn6Dq2naqolQ0xIW0IU+iP
         MSbbRLjMaIxdpmGAf0U5fwHxTwtlkEmcXMNgXikc9NI4E0hLksVdQ0WnH395G2dkUPsD
         gnhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyoTVfW0q/Sz3MjyHTCgqtubb6sYVUua8s/Tg/xpMNA=;
        b=P7NPhlyEr1PVyQtFnaeiiCqQr0KN/xCbX1Wl4wi6vMJ1QjbFfapbj03mAqpJEoV9NO
         b21GeRUE7yYmI/bWweumwE1Ri9FJd8AjZZA8SBh6yD5ocr2nlTdWJGsI2TRII3QlGWE6
         TdCk6pyGvEaUl44xI+/NzgWhvjCowYlamxSQWDNF13a8ZNepTLPWCHLjlNPMJBgsJk0/
         3ccSjBq3o8vckDXLwok2FMe5rBrkMouO0fYZb0H56s4Tw5G5QVey6REpq3FMjMCKgjGc
         BUIbSiPQVUDTwvE6ouUCKwj67wzL2/qwzGyncdfDv42/BLsQU7cKGxTbnHmo3Oa59fcO
         alGA==
X-Gm-Message-State: AOAM533KBNHyE9Itp+3IiZqEyN2/abqpXk7s2KHg7U/yxQKZNd41QNIU
        I5V/sG1+V9aDUFPEauuo6cLuWLi9sfavlC0qJsphIEB1D95Eww==
X-Google-Smtp-Source: ABdhPJx1LxdbI+6Eo1iN/qluMq/FkpUgQwUazu70RZATfKUUIW2IRfqilrQHPRzlPMpYRYiaPBQfkLpphSrTn5AbKKg=
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr5170753ejy.493.1633606376037;
 Thu, 07 Oct 2021 04:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211004065851.1903-1-pkushwaha@marvell.com> <20211004065851.1903-7-pkushwaha@marvell.com>
In-Reply-To: <20211004065851.1903-7-pkushwaha@marvell.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 Oct 2021 17:02:44 +0530
Message-ID: <CA+G9fYspE5kQd=hjpLf1nv_kKBQhaHi8jd2qhdH5JfUTzfmjog@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] qed: Update qed_hsi.h for fw 8.59.1.0
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        aelior@marvell.com, smalin@marvell.com, jhasan@marvell.com,
        mrangankar@marvell.com, prabhakar.pkin@gmail.com,
        malin1024@gmail.com, Omkar Kulkarni <okulkarni@marvell.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regression found on arm gcc-11 build.
Following build warnings / errors reported on Linux next 20211007.

On Mon, 4 Oct 2021 at 12:29, Prabhakar Kushwaha <pkushwaha@marvell.com> wrote:
>
> The qed_hsi.h has been updated to support new FW version 8.59.1.0 with
> changes.
>  - Updates FW HSI (Hardware Software interface) structures.
>  - Addition/update in function declaration and defines as per HSI.
>  - Add generic infrastructure for FW error reporting as part of
>    common event queue handling.
>  - Move malicious VF error reporting to FW error reporting
>    infrastructure.
>  - Move consolidation queue initialization from FW context to ramrod
>    message.
>
> qed_hsi.h header file changes lead to change in many files to ensure
> compilation.
>
> This patch also fixes the existing checkpatch warnings and few important
> checks.

<trim>

> +static int qed_fw_err_handler(struct qed_hwfn *p_hwfn,
> +                             u8 opcode,
> +                             u16 echo,
> +                             union event_ring_data *data, u8 fw_return_code)
> +{
> +       if (fw_return_code != COMMON_ERR_CODE_ERROR)
> +               goto eqe_unexpected;
> +
> +       if (data->err_data.recovery_scope == ERR_SCOPE_FUNC &&
> +           le16_to_cpu(data->err_data.entity_id) >= MAX_NUM_PFS) {
> +               qed_sriov_vfpf_malicious(p_hwfn, &data->err_data);
> +               return 0;
> +       }


metadata:
    git_describe: next-20211007
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
    git_short_log: f8dc23b3dc0c (\Add linux-next specific files for 20211007\)
    target_arch: arm
    toolchain: gcc-11

build error :
--------------
drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_fw_err_handler':
drivers/net/ethernet/qlogic/qed/qed_dev.c:2390:17: error: implicit
declaration of function 'qed_sriov_vfpf_malicious'
[-Werror=implicit-function-declaration]
 2390 |                 qed_sriov_vfpf_malicious(p_hwfn, &data->err_data);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_common_eqe_event':
drivers/net/ethernet/qlogic/qed/qed_dev.c:2410:24: error: implicit
declaration of function 'qed_sriov_eqe_event'; did you mean
'qed_common_eqe_event'? [-Werror=implicit-function-declaration]
 2410 |                 return qed_sriov_eqe_event(p_hwfn, opcode, echo, data,
      |                        ^~~~~~~~~~~~~~~~~~~
      |                        qed_common_eqe_event
cc1: some warnings being treated as errors
make[6]: *** [scripts/Makefile.build:288:
drivers/net/ethernet/qlogic/qed/qed_dev.o] Error 1
make[6]: Target '__build' not remade because of errors.
make[5]: *** [scripts/Makefile.build:571:
drivers/net/ethernet/qlogic/qed] Error 2


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build link:
-----------
https://builds.tuxbuild.com/1zAeXBdIL6bf5zawzmHpVFEQ3wV/build.log

build config:
-------------
https://builds.tuxbuild.com/1zAeXBdIL6bf5zawzmHpVFEQ3wV/config

# To install tuxmake on your system globally
# sudo pip3 install -U tuxmake
tuxmake --runtime podman --target-arch arm --toolchain gcc-11
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1zAeXBdIL6bf5zawzmHpVFEQ3wV/config


-- 
Linaro LKFT
https://lkft.linaro.org
