Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD77CE9A48
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 11:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfJ3Koe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 06:44:34 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43392 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfJ3Kod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 06:44:33 -0400
Received: by mail-lf1-f65.google.com with SMTP id j5so1153674lfh.10
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 03:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HLNFOw/E8sRyyfDeVaD6+99IdS/kmaGA7bFzdFcaD9s=;
        b=SYmYwz0mioBiMlfEX77UzKJbQ6sgR9ZU+drJo/4lm2TX+4zFldwcRs3Zt5tcLkkNEc
         V8pXMrG+2G+t8mQxcPG4p5hBT1Do35/lFGg8fye3mdR9zo1TtmINWRTueCK3klcTh9qG
         kWHx0YV5DTzMLbx5+piY8PoQiJRMgz5S1lempAtcMtu48ABulEOYWbI/MUxYAPT0Mee6
         hGt2A970WhXLMaWheiUD8fqDby6F6QSzpSGwiIR+t2DpMTfvL1cYWjCbOoyFY2zHLbEh
         9O3JWw3TZbfQtmESdvolk7gxuUmd5cbJbGTURNb+73oUd+TYV4PH6NKiYM/39OZ9HcN4
         eWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HLNFOw/E8sRyyfDeVaD6+99IdS/kmaGA7bFzdFcaD9s=;
        b=s5pPv0R7c2bopy2PoZK2ZrVpEm4ZAyRoIW25lNaiOgfB4Y2oAbCEEffjuvDnqUUkSE
         FkaxmPtouuQybMHo81S3FgEiZfMuby+oYZeMvc2+rheggp0lnpiXOnhJ/SexSiSx7QqA
         vswHXrv54UPw/1KXJqftT+fMtYjbvgUVEnHWmB8EwHy8o0Ahzl62sDfbVs2xw9HA1uMD
         HmiloYLZFnI7Qdnbb9TLnY5VSj27hh4fqQQ/Uc8+dP0HSMQLmE+mylsGWYYsDtNex7/k
         5vceQJ7JgCIrOf4Zoxas9xAeDYp6eAq4p1Vyfuuh9Z0paCSP8KAM/Ykus8PtGB6pCm88
         ZKJw==
X-Gm-Message-State: APjAAAWrbCLtUEP+yEqxQgfp4zJOuixKd4yCqAOPbHf7oVYdb9HolAnX
        d0x3OSKg90cFpSPXkiVubzoCOLUXgUaftxEoxIczpQ==
X-Google-Smtp-Source: APXvYqzZHsOOw41tv7DTeIFHAdCQE90j2etgAGTfRuDRHtV8tpEEoRF3mIAJvF76NQ+a2bdY+Jv2RC7Wdsh4Rd3m440=
X-Received: by 2002:a19:800a:: with SMTP id b10mr5848150lfd.15.1572432269483;
 Wed, 30 Oct 2019 03:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com> <1571895161-26487-2-git-send-email-sheetal.tigadoli@broadcom.com>
In-Reply-To: <1571895161-26487-2-git-send-email-sheetal.tigadoli@broadcom.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 30 Oct 2019 16:14:17 +0530
Message-ID: <CAFA6WYNSrda_DPQoBcg1s5F1JMeLyirxcKCMRCdF4ytDrmo+ew@mail.gmail.com>
Subject: Re: [Tee-dev] [PATCH V3 1/3] firmware: broadcom: add OP-TEE based
 BNXT f/w manager
To:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "tee-dev @ lists . linaro . org" <tee-dev@lists.linaro.org>,
        bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 at 11:09, Sheetal Tigadoli
<sheetal.tigadoli@broadcom.com> wrote:
>
> From: Vikas Gupta <vikas.gupta@broadcom.com>
>
> This driver registers on TEE bus to interact with OP-TEE based
> BNXT firmware management modules
>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
> ---
>  drivers/firmware/broadcom/Kconfig             |   8 +
>  drivers/firmware/broadcom/Makefile            |   1 +
>  drivers/firmware/broadcom/tee_bnxt_fw.c       | 277 ++++++++++++++++++++++++++
>  include/linux/firmware/broadcom/tee_bnxt_fw.h |  14 ++
>  4 files changed, 300 insertions(+)
>  create mode 100644 drivers/firmware/broadcom/tee_bnxt_fw.c
>  create mode 100644 include/linux/firmware/broadcom/tee_bnxt_fw.h
>
> diff --git a/drivers/firmware/broadcom/Kconfig b/drivers/firmware/broadcom/Kconfig
> index d03ed8e..79505ad 100644
> --- a/drivers/firmware/broadcom/Kconfig
> +++ b/drivers/firmware/broadcom/Kconfig
> @@ -22,3 +22,11 @@ config BCM47XX_SPROM
>           In case of SoC devices SPROM content is stored on a flash used by
>           bootloader firmware CFE. This driver provides method to ssb and bcma
>           drivers to read SPROM on SoC.
> +
> +config TEE_BNXT_FW
> +       bool "Broadcom BNXT firmware manager"
> +       depends on (ARCH_BCM_IPROC && OPTEE) || COMPILE_TEST
> +       default ARCH_BCM_IPROC
> +       help
> +         This module help to manage firmware on Broadcom BNXT device. The module
> +         registers on tee bus and invoke calls to manage firmware on BNXT device.
> diff --git a/drivers/firmware/broadcom/Makefile b/drivers/firmware/broadcom/Makefile
> index 72c7fdc..17c5061 100644
> --- a/drivers/firmware/broadcom/Makefile
> +++ b/drivers/firmware/broadcom/Makefile
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_BCM47XX_NVRAM)            += bcm47xx_nvram.o
>  obj-$(CONFIG_BCM47XX_SPROM)            += bcm47xx_sprom.o
> +obj-$(CONFIG_TEE_BNXT_FW)              += tee_bnxt_fw.o
> diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
> new file mode 100644
> index 0000000..72dcbfa
> --- /dev/null
> +++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
> @@ -0,0 +1,277 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2019 Broadcom.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/tee_drv.h>
> +#include <linux/uuid.h>
> +
> +#include <linux/firmware/broadcom/tee_bnxt_fw.h>
> +
> +#define MAX_SHM_MEM_SZ SZ_4M
> +
> +#define MAX_TEE_PARAM_ARRY_MEMB                4
> +
> +enum ta_cmd {
> +       /*
> +        * TA_CMD_BNXT_FASTBOOT - boot bnxt device by copying f/w into sram
> +        *
> +        *      param[0] unused
> +        *      param[1] unused
> +        *      param[2] unused
> +        *      param[3] unused
> +        *
> +        * Result:
> +        *      TEE_SUCCESS - Invoke command success
> +        *      TEE_ERROR_ITEM_NOT_FOUND - Corrupt f/w image found on memory
> +        */
> +       TA_CMD_BNXT_FASTBOOT = 0,
> +
> +       /*
> +        * TA_CMD_BNXT_COPY_COREDUMP - copy the core dump into shm
> +        *
> +        *      param[0] (inout memref) - Coredump buffer memory reference
> +        *      param[1] (in value) - value.a: offset, data to be copied from
> +        *                            value.b: size of data to be copied
> +        *      param[2] unused
> +        *      param[3] unused
> +        *
> +        * Result:
> +        *      TEE_SUCCESS - Invoke command success
> +        *      TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> +        *      TEE_ERROR_ITEM_NOT_FOUND - Corrupt core dump
> +        */
> +       TA_CMD_BNXT_COPY_COREDUMP = 3,
> +};
> +
> +/**
> + * struct tee_bnxt_fw_private - OP-TEE bnxt private data
> + * @dev:               OP-TEE based bnxt device.
> + * @ctx:               OP-TEE context handler.
> + * @session_id:                TA session identifier.
> + */
> +struct tee_bnxt_fw_private {
> +       struct device *dev;
> +       struct tee_context *ctx;
> +       u32 session_id;
> +       struct tee_shm *fw_shm_pool;
> +};
> +
> +static struct tee_bnxt_fw_private pvt_data;
> +
> +static void prepare_args(int cmd,
> +                        struct tee_ioctl_invoke_arg *arg,
> +                        struct tee_param *param)
> +{
> +       memset(arg, 0, sizeof(*arg));
> +       memset(param, 0, MAX_TEE_PARAM_ARRY_MEMB * sizeof(*param));
> +
> +       arg->func = cmd;
> +       arg->session = pvt_data.session_id;
> +       arg->num_params = MAX_TEE_PARAM_ARRY_MEMB;
> +
> +       /* Fill invoke cmd params */
> +       switch (cmd) {
> +       case TA_CMD_BNXT_COPY_COREDUMP:
> +               param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
> +               param[0].u.memref.shm = pvt_data.fw_shm_pool;
> +               param[0].u.memref.size = MAX_SHM_MEM_SZ;
> +               param[0].u.memref.shm_offs = 0;
> +               param[1].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT;
> +               break;
> +       case TA_CMD_BNXT_FASTBOOT:
> +       default:
> +               /* Nothing to do */
> +               break;
> +       }
> +}
> +
> +/**
> + * tee_bnxt_fw_load() - Load the bnxt firmware
> + *                 Uses an OP-TEE call to start a secure
> + *                 boot process.
> + * Returns 0 on success, negative errno otherwise.
> + */
> +int tee_bnxt_fw_load(void)
> +{
> +       int ret = 0;
> +       struct tee_ioctl_invoke_arg arg;
> +       struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
> +
> +       if (!pvt_data.ctx)
> +               return -ENODEV;
> +
> +       prepare_args(TA_CMD_BNXT_FASTBOOT, &arg, param);
> +
> +       ret = tee_client_invoke_func(pvt_data.ctx, &arg, param);
> +       if (ret < 0 || arg.ret != 0) {
> +               dev_err(pvt_data.dev,
> +                       "TA_CMD_BNXT_FASTBOOT invoke failed TEE err: %x, ret:%x\n",
> +                       arg.ret, ret);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(tee_bnxt_fw_load);
> +
> +/**
> + * tee_bnxt_copy_coredump() - Copy coredump from the allocated memory
> + *                         Uses an OP-TEE call to copy coredump
> + * @buf:       desintation buffer where core dump is copied into

s/desintation/destination/

> + * @offset:    offset from the base address of core dump area
> + * @size:      size of the dump
> + *
> + * Returns 0 on success, negative errno otherwise.
> + */
> +int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size)
> +{
> +       struct tee_ioctl_invoke_arg arg;
> +       struct tee_param param[MAX_TEE_PARAM_ARRY_MEMB];
> +       void *core_data;
> +       u32 rbytes = size;
> +       u32 nbytes = 0;
> +       int ret = 0;
> +
> +       if (!pvt_data.ctx)
> +               return -ENODEV;
> +
> +       prepare_args(TA_CMD_BNXT_COPY_COREDUMP, &arg, param);
> +
> +       while (rbytes)  {
> +               nbytes = rbytes;
> +
> +               nbytes = min_t(u32, rbytes, param[0].u.memref.size);
> +
> +               /* Fill additional invoke cmd params */
> +               param[1].u.value.a = offset;
> +               param[1].u.value.b = nbytes;
> +
> +               ret = tee_client_invoke_func(pvt_data.ctx, &arg, param);
> +               if (ret < 0 || arg.ret != 0) {
> +                       dev_err(pvt_data.dev,
> +                               "TA_CMD_BNXT_COPY_COREDUMP invoke failed TEE err: %x, ret:%x\n",
> +                               arg.ret, ret);
> +                       return -EINVAL;
> +               }
> +
> +               core_data = tee_shm_get_va(pvt_data.fw_shm_pool, 0);
> +               if (IS_ERR(core_data)) {
> +                       dev_err(pvt_data.dev, "tee_shm_get_va failed\n");
> +                       return PTR_ERR(core_data);
> +               }
> +
> +               memcpy(buf, core_data, nbytes);
> +
> +               rbytes -= nbytes;
> +               buf += nbytes;
> +               offset += nbytes;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(tee_bnxt_copy_coredump);
> +
> +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> +{
> +       return (ver->impl_id == TEE_IMPL_ID_OPTEE);
> +}
> +
> +static int tee_bnxt_fw_probe(struct device *dev)
> +{
> +       struct tee_client_device *bnxt_device = to_tee_client_device(dev);
> +       int ret, err = -ENODEV;
> +       struct tee_ioctl_open_session_arg sess_arg;
> +       struct tee_shm *fw_shm_pool;
> +
> +       memset(&sess_arg, 0, sizeof(sess_arg));
> +
> +       /* Open context with TEE driver */
> +       pvt_data.ctx = tee_client_open_context(NULL, optee_ctx_match, NULL,
> +                                              NULL);
> +       if (IS_ERR(pvt_data.ctx))
> +               return -ENODEV;
> +
> +       /* Open session with Bnxt load Trusted App */
> +       memcpy(sess_arg.uuid, bnxt_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
> +       sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> +       sess_arg.num_params = 0;
> +
> +       ret = tee_client_open_session(pvt_data.ctx, &sess_arg, NULL);
> +       if (ret < 0 || sess_arg.ret != 0) {
> +               dev_err(dev, "tee_client_open_session failed, err: %x\n",
> +                       sess_arg.ret);
> +               err = -EINVAL;
> +               goto out_ctx;
> +       }
> +       pvt_data.session_id = sess_arg.session;
> +
> +       pvt_data.dev = dev;
> +
> +       fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
> +                                   TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> +       if (IS_ERR(fw_shm_pool)) {
> +               tee_client_close_context(pvt_data.ctx);
> +               dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
> +               err = PTR_ERR(fw_shm_pool);
> +               goto out_sess;
> +       }
> +
> +       pvt_data.fw_shm_pool = fw_shm_pool;
> +
> +       return 0;
> +
> +out_sess:
> +       tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
> +out_ctx:
> +       tee_client_close_context(pvt_data.ctx);
> +
> +       return err;
> +}
> +
> +static int tee_bnxt_fw_remove(struct device *dev)
> +{
> +       tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
> +       tee_client_close_context(pvt_data.ctx);
> +       pvt_data.ctx = NULL;
> +

Possible shm leak? "tee_shm_free(pvt_data.fw_shm_pool);" missing here.

> +       return 0;
> +}
> +
> +static const struct tee_client_device_id tee_bnxt_fw_id_table[] = {
> +       {UUID_INIT(0x6272636D, 0x2019, 0x0716,
> +                   0x42, 0x43, 0x4D, 0x5F, 0x53, 0x43, 0x48, 0x49)},
> +       {}
> +};
> +
> +MODULE_DEVICE_TABLE(tee, tee_bnxt_fw_id_table);
> +
> +static struct tee_client_driver tee_bnxt_fw_driver = {
> +       .id_table       = tee_bnxt_fw_id_table,
> +       .driver         = {
> +               .name           = KBUILD_MODNAME,
> +               .bus            = &tee_bus_type,
> +               .probe          = tee_bnxt_fw_probe,
> +               .remove         = tee_bnxt_fw_remove,
> +       },
> +};
> +
> +static int __init tee_bnxt_fw_mod_init(void)
> +{
> +       return driver_register(&tee_bnxt_fw_driver.driver);
> +}
> +
> +static void __exit tee_bnxt_fw_mod_exit(void)
> +{
> +       driver_unregister(&tee_bnxt_fw_driver.driver);
> +}
> +
> +module_init(tee_bnxt_fw_mod_init);
> +module_exit(tee_bnxt_fw_mod_exit);
> +

Apart from minor comments above, this TEE bus driver looks good, so:

Acked-by: Sumit Garg <sumit.garg@linaro.org>

-Sumit

> +MODULE_AUTHOR("Vikas Gupta <vikas.gupta@broadcom.com>");
> +MODULE_DESCRIPTION("Broadcom bnxt firmware manager");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/firmware/broadcom/tee_bnxt_fw.h b/include/linux/firmware/broadcom/tee_bnxt_fw.h
> new file mode 100644
> index 0000000..f24c82d
> --- /dev/null
> +++ b/include/linux/firmware/broadcom/tee_bnxt_fw.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: BSD-2-Clause */
> +/*
> + * Copyright 2019 Broadcom.
> + */
> +
> +#ifndef _BROADCOM_TEE_BNXT_FW_H
> +#define _BROADCOM_TEE_BNXT_FW_H
> +
> +#include <linux/types.h>
> +
> +int tee_bnxt_fw_load(void);
> +int tee_bnxt_copy_coredump(void *buf, u32 offset, u32 size);
> +
> +#endif /* _BROADCOM_TEE_BNXT_FW_H */
> --
> 1.9.1
>
> _______________________________________________
> Tee-dev mailing list
> Tee-dev@lists.linaro.org
> https://lists.linaro.org/mailman/listinfo/tee-dev
