Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FB7A4F68
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 08:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfIBG7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 02:59:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35930 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbfIBG7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 02:59:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id p13so13369235wmh.1;
        Sun, 01 Sep 2019 23:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5AF32yjhGbbOvKpLT0QnkitaASa0bJqQFXYiSlxM9BU=;
        b=gNXVl2UG6lgFfc0QyBzFSW2tSehhEaX+qyC/fIy+E/ot2IAkiLyixz0Y7Ch0LwZ9g3
         stsC0NgyHbUYDDSfmsydh4YPG7WXDUonWlYIWWwWA4aUEcBo/zdDmb1IoA/co11oTmfo
         o0zK1QJGLAo6yrZqaHEL/+KviP86DQZR6AZ9QPYngijtHdcJObxPEZIQkshC4GMN3hSM
         gGnKStQowGQY4QgMe/3iIdL8m4Qc0O9QXuX3/y449ADpum0WKfsbKAbUWKjRTHJy0M0j
         iJVAhv3+LOHjNB87eyntntCuudLBewzSEr2PhuswfyXVcfc3pLJvfiPFXYL1PmsVTI0Z
         YwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5AF32yjhGbbOvKpLT0QnkitaASa0bJqQFXYiSlxM9BU=;
        b=tiRWLaSqb0m4eKsoPN0owJ13/a7mG48EdhtLDB4MYp6FPvtWQ/0MZzEn7YkW6EO9gV
         TEj6jUJoD65Zw1E6LEdfXC3VPKCoqTLg8X81Pjn93P/FR/VZ6KjQM2yfG7MgNPankJM5
         OadLF9diPmN1ads4p1UzinYx9nCvtk+tg0rHxlPDRCfNVj/xdsny4cE9JbMhFvfbOFVj
         6fw4V2P0VYdLMYtUvJGFyTtz9Z/3gEcGyPQvbiCztVuYSFbLsxXTxSvcAm5RP3hYZmGE
         Z8xuUyPV9akPddAAd1YOxxFcBMquD1gPwmZJez1ZPFJNjXGh2fraNJNNWkAXXJmQkeqb
         UL0A==
X-Gm-Message-State: APjAAAV7X904qzTkhV/2sLGtVGC4E4D0jaVAOZk/GdzJpz+WGj3oB7qG
        tvPvrR/q4X1NjeVpqaQ9BnA=
X-Google-Smtp-Source: APXvYqweYciAqINF0LptZvUegqJRZK0cdpf1zntScf0vjs3F3MTX3o6XMZJ4CSQhXfaLyagt38aA9A==
X-Received: by 2002:a05:600c:2047:: with SMTP id p7mr7532151wmg.13.1567407538017;
        Sun, 01 Sep 2019 23:58:58 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id x5sm6155601wrg.69.2019.09.01.23.58.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 23:58:57 -0700 (PDT)
Date:   Mon, 2 Sep 2019 08:58:54 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Kalyani Akula <kalyani.akula@xilinx.com>
Cc:     herbert@gondor.apana.org.au, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>
Subject: Re: [PATCH V2 4/4] crypto: Add Xilinx AES driver
Message-ID: <20190902065854.GA28750@Red>
References: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
 <1567346098-27927-5-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567346098-27927-5-git-send-email-kalyani.akula@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 01, 2019 at 07:24:58PM +0530, Kalyani Akula wrote:
> This patch adds AES driver support for the Xilinx
> ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---

Hello

I have some comment below

>  drivers/crypto/Kconfig          |  11 ++
>  drivers/crypto/Makefile         |   1 +
>  drivers/crypto/zynqmp-aes-gcm.c | 297 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 309 insertions(+)
>  create mode 100644 drivers/crypto/zynqmp-aes-gcm.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 603413f..a0d058a 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -677,6 +677,17 @@ config CRYPTO_DEV_ROCKCHIP
>  	  This driver interfaces with the hardware crypto accelerator.
>  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
>  
> +config CRYPTO_DEV_ZYNQMP_AES
> +	tristate "Support for Xilinx ZynqMP AES hw accelerator"
> +	depends on ARCH_ZYNQMP || COMPILE_TEST
> +	select CRYPTO_AES
> +	select CRYPTO_SKCIPHER
> +	help
> +	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
> +	  encryption and decryption. This driver interfaces with AES hw
> +	  accelerator. Select this if you want to use the ZynqMP module
> +	  for AES algorithms.
> +
>  config CRYPTO_DEV_MEDIATEK
>  	tristate "MediaTek's EIP97 Cryptographic Engine driver"
>  	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index afc4753..c99663a 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -48,3 +48,4 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
>  obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
>  obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
>  obj-y += hisilicon/
> +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
> diff --git a/drivers/crypto/zynqmp-aes-gcm.c b/drivers/crypto/zynqmp-aes-gcm.c
> new file mode 100644
> index 0000000..d65f038
> --- /dev/null
> +++ b/drivers/crypto/zynqmp-aes-gcm.c
> @@ -0,0 +1,297 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Xilinx ZynqMP AES Driver.
> + * Copyright (c) 2019 Xilinx Inc.
> + */
> +
> +#include <crypto/aes.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/scatterlist.h>
> +#include <linux/firmware/xlnx-zynqmp.h>
> +
> +#define ZYNQMP_AES_IV_SIZE			12
> +#define ZYNQMP_AES_GCM_SIZE			16
> +#define ZYNQMP_AES_KEY_SIZE			32
> +
> +#define ZYNQMP_AES_DECRYPT			0
> +#define ZYNQMP_AES_ENCRYPT			1
> +
> +#define ZYNQMP_AES_KUP_KEY			0
> +#define ZYNQMP_AES_DEVICE_KEY			1
> +#define ZYNQMP_AES_PUF_KEY			2
> +
> +#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
> +#define ZYNQMP_AES_SIZE_ERR			0x06
> +#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
> +#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
> +
> +#define ZYNQMP_AES_BLOCKSIZE			0x04
> +
> +static const struct zynqmp_eemi_ops *eemi_ops;
> +struct zynqmp_aes_dev *aes_dd;

I still think that using a global variable for storing device driver data is bad.

> +
> +struct zynqmp_aes_dev {
> +	struct device *dev;
> +};
> +
> +struct zynqmp_aes_op {
> +	struct zynqmp_aes_dev *dd;
> +	void *src;
> +	void *dst;
> +	int len;
> +	u8 key[ZYNQMP_AES_KEY_SIZE];
> +	u8 *iv;
> +	u32 keylen;
> +	u32 keytype;
> +};
> +
> +struct zynqmp_aes_data {
> +	u64 src;
> +	u64 iv;
> +	u64 key;
> +	u64 dst;
> +	u64 size;
> +	u64 optype;
> +	u64 keysrc;
> +};
> +
> +static int zynqmp_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
> +			     unsigned int len)
> +{
> +	struct zynqmp_aes_op *op = crypto_tfm_ctx(tfm);
> +
> +	if (((len != 1) && (len !=  ZYNQMP_AES_KEY_SIZE)) || (!key))

typo, two space

> +		return -EINVAL;
> +
> +	if (len == 1) {
> +		op->keytype = *key;
> +
> +		if ((op->keytype < ZYNQMP_AES_KUP_KEY) ||
> +			(op->keytype > ZYNQMP_AES_PUF_KEY))
> +			return -EINVAL;
> +
> +	} else if (len == ZYNQMP_AES_KEY_SIZE) {
> +		op->keytype = ZYNQMP_AES_KUP_KEY;
> +		op->keylen = len;
> +		memcpy(op->key, key, len);
> +	}
> +
> +	return 0;
> +}

It seems your driver does not support AES keysize of 128/196, you need to fallback in that case.
You need to comment the keylen=1 usecase and use a define for this value.

> +
> +static int zynqmp_aes_xcrypt(struct blkcipher_desc *desc,
> +			     struct scatterlist *dst,
> +			     struct scatterlist *src,
> +			     unsigned int nbytes,
> +			     unsigned int flags)
> +{
> +	struct zynqmp_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> +	struct zynqmp_aes_dev *dd = aes_dd;
> +	int err, ret, copy_bytes, src_data = 0, dst_data = 0;
> +	dma_addr_t dma_addr, dma_addr_buf;
> +	struct zynqmp_aes_data *abuf;
> +	struct blkcipher_walk walk;
> +	unsigned int data_size;
> +	size_t dma_size;
> +	char *kbuf;
> +
> +	if (!eemi_ops->aes)
> +		return -ENOTSUPP;
> +
> +	if (op->keytype == ZYNQMP_AES_KUP_KEY)
> +		dma_size = nbytes + ZYNQMP_AES_KEY_SIZE
> +			+ ZYNQMP_AES_IV_SIZE;
> +	else
> +		dma_size = nbytes + ZYNQMP_AES_IV_SIZE;
> +
> +	kbuf = dma_alloc_coherent(dd->dev, dma_size, &dma_addr, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	abuf = dma_alloc_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
> +				  &dma_addr_buf, GFP_KERNEL);
> +	if (!abuf) {
> +		dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
> +		return -ENOMEM;
> +	}
> +
> +	data_size = nbytes;
> +	blkcipher_walk_init(&walk, dst, src, data_size);
> +	err = blkcipher_walk_virt(desc, &walk);
> +	op->iv = walk.iv;
> +
> +	while ((nbytes = walk.nbytes)) {
> +		op->src = walk.src.virt.addr;
> +		memcpy(kbuf + src_data, op->src, nbytes);
> +		src_data = src_data + nbytes;
> +		nbytes &= (ZYNQMP_AES_BLOCKSIZE - 1);
> +		err = blkcipher_walk_done(desc, &walk, nbytes);
> +	}
> +	memcpy(kbuf + data_size, op->iv, ZYNQMP_AES_IV_SIZE);
> +	abuf->src = dma_addr;
> +	abuf->dst = dma_addr;
> +	abuf->iv = abuf->src + data_size;
> +	abuf->size = data_size - ZYNQMP_AES_GCM_SIZE;
> +	abuf->optype = flags;
> +	abuf->keysrc = op->keytype;
> +
> +	if (op->keytype == ZYNQMP_AES_KUP_KEY) {
> +		memcpy(kbuf + data_size + ZYNQMP_AES_IV_SIZE,
> +		       op->key, ZYNQMP_AES_KEY_SIZE);
> +
> +		abuf->key = abuf->src + data_size + ZYNQMP_AES_IV_SIZE;
> +	} else {
> +		abuf->key = 0;
> +	}
> +	eemi_ops->aes(dma_addr_buf, &ret);
> +
> +	if (ret != 0) {
> +		switch (ret) {
> +		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
> +			dev_err(dd->dev, "ERROR: Gcm Tag mismatch\n\r");
> +			break;
> +		case ZYNQMP_AES_SIZE_ERR:
> +			dev_err(dd->dev, "ERROR : Non word aligned data\n\r");
> +			break;
> +		case ZYNQMP_AES_WRONG_KEY_SRC_ERR:
> +			dev_err(dd->dev, "ERROR: Wrong KeySrc, enable secure mode\n\r");
> +			break;
> +		case ZYNQMP_AES_PUF_NOT_PROGRAMMED:
> +			dev_err(dd->dev, "ERROR: PUF is not registered\r\n");
> +			break;
> +		default:
> +			dev_err(dd->dev, "ERROR: Invalid");
> +			break;
> +		}
> +		goto END;
> +	}
> +	if (flags)
> +		copy_bytes = data_size;
> +	else
> +		copy_bytes = data_size - ZYNQMP_AES_GCM_SIZE;
> +
> +	blkcipher_walk_init(&walk, dst, src, copy_bytes);
> +	err = blkcipher_walk_virt(desc, &walk);
> +
> +	while ((nbytes = walk.nbytes)) {
> +		memcpy(walk.dst.virt.addr, kbuf + dst_data, nbytes);
> +		dst_data = dst_data + nbytes;
> +		nbytes &= (ZYNQMP_AES_BLOCKSIZE - 1);
> +		err = blkcipher_walk_done(desc, &walk, nbytes);
> +	}
> +END:
> +	memset(kbuf, 0, dma_size);
> +	memset(abuf, 0, sizeof(struct zynqmp_aes_data));
> +	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
> +	dma_free_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
> +			  abuf, dma_addr_buf);
> +	return err;
> +}
> +
> +static int zynqmp_aes_decrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst,
> +			      struct scatterlist *src,
> +			      unsigned int nbytes)
> +{
> +	return zynqmp_aes_xcrypt(desc, dst, src, nbytes, ZYNQMP_AES_DECRYPT);
> +}
> +
> +static int zynqmp_aes_encrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst,
> +			      struct scatterlist *src,
> +			      unsigned int nbytes)
> +{
> +	return zynqmp_aes_xcrypt(desc, dst, src, nbytes, ZYNQMP_AES_ENCRYPT);
> +}
> +
> +static struct crypto_alg zynqmp_alg = {
> +	.cra_name		=	"xilinx-zynqmp-aes",
> +	.cra_driver_name	=	"zynqmp-aes-gcm",
> +	.cra_priority		=	400,
> +	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
> +	.cra_blocksize		=	ZYNQMP_AES_BLOCKSIZE,
> +	.cra_ctxsize		=	sizeof(struct zynqmp_aes_op),
> +	.cra_alignmask		=	15,
> +	.cra_type		=	&crypto_blkcipher_type,
> +	.cra_module		=	THIS_MODULE,
> +	.cra_u			=	{
> +	.blkcipher	=	{
> +			.min_keysize	=	0,

Are you sure to accept this a keysize of 0 ?

Regards
