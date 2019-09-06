Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE981AB301
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404518AbfIFHEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:04:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44675 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbfIFHEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:04:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id 30so5314581wrk.11;
        Fri, 06 Sep 2019 00:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5pzmBZer/+TBMOVeXwQ9BsAmm7zzKnUjSwWoimEiUsE=;
        b=utGMqSVus0m5uL9skhioJy/Wyar18PoXazYEoP81I4FMpvOuwKHoxczuwey+4Untcm
         Z1TTGv1dcVI08WsY2mm2RsQH6i/AoScqiNiyUzRGYmoeDLwVFkQz1DN/COo7hOkSQXXL
         2AqeSp2/KBwA7U8CLgaVkxDbyTgN4zJZXJ+fzMGm4xadjGjM5jmxNM4wCNsXTiBMeoBJ
         mAq1KhYE1PEOxF4nUiptnN7XEH6+cEJ7dboGl0UKmzTVmVhMw6R52/Gm9qtmVsHyRQox
         T0MqfD4o4ksanBDwB/zObxS8vXOs0yqSp4Tm/CjEBmQ8YET0DEu+gfnFJBJn/a09SMW0
         ZDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5pzmBZer/+TBMOVeXwQ9BsAmm7zzKnUjSwWoimEiUsE=;
        b=RJ0LE/GszGNyLoym3Y+TBZImo/9XtH3lR89KsqelH4kbFeSvjV6q0aFz70pPBIsZpf
         +2YQtoiGB1fv7tO6Ho1M4smmgFVZk4vIo5FsYJ2VAKE4qvkrfUJpWYUYnpqeI/6wF9nl
         b4X49A7tLfjf/N4MnV6Haswsak6Z5zEiF3V6JtibGdj/Z6GqIy+TfRD1YJSxWw5ThI4T
         Tpw9CeMtu82NBdJI7RZVg+L1jO3mRRduGOyCau5wJwwWEFB4eSnnkxR/sH8UxBnfV67T
         YBVmH4z66BzO97xWpMvdxd3vIF8aRU9cOk6z3TAT6Z19yrEdXl7GaBw+ur0vi8cvmUFi
         SidQ==
X-Gm-Message-State: APjAAAXK2r2QDN5nPlGXRtODzynAlaRk6iZ7Y7OPTS2oCNCP+iKedp9j
        uLNEX0WME9TqWaZ9AXSLoEc=
X-Google-Smtp-Source: APXvYqwD4aSpDy4eqO3m8n2Pm0zL/CB18gcJ4R9r7lJ449f/V5S/d+OCOxs0pPjNi6W1W2to5Yqkng==
X-Received: by 2002:a5d:568c:: with SMTP id f12mr5867093wrv.248.1567753478970;
        Fri, 06 Sep 2019 00:04:38 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id x6sm7908454wmf.38.2019.09.06.00.04.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 00:04:38 -0700 (PDT)
Date:   Fri, 6 Sep 2019 09:04:35 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Kalyani Akula <kalyania@xilinx.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: Re: [PATCH V2 4/4] crypto: Add Xilinx AES driver
Message-ID: <20190906070435.GA22006@Red>
References: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
 <1567346098-27927-5-git-send-email-kalyani.akula@xilinx.com>
 <20190902065854.GA28750@Red>
 <BN7PR02MB512445C31936CED70F02D15AAFB80@BN7PR02MB5124.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN7PR02MB512445C31936CED70F02D15AAFB80@BN7PR02MB5124.namprd02.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 04, 2019 at 05:40:22PM +0000, Kalyani Akula wrote:
> Hi Corentin,
> 
> Thanks for the review comments.
> Please find my response/queries inline.
> 
> > -----Original Message-----
> > From: Corentin Labbe <clabbe.montjoie@gmail.com>
> > Sent: Monday, September 2, 2019 12:29 PM
> > To: Kalyani Akula <kalyania@xilinx.com>
> > Cc: herbert@gondor.apana.org.au; kstewart@linuxfoundation.org;
> > gregkh@linuxfoundation.org; tglx@linutronix.de; pombredanne@nexb.com;
> > linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; Kalyani Akula <kalyania@xilinx.com>
> > Subject: Re: [PATCH V2 4/4] crypto: Add Xilinx AES driver
> > 
> > On Sun, Sep 01, 2019 at 07:24:58PM +0530, Kalyani Akula wrote:
> > > This patch adds AES driver support for the Xilinx ZynqMP SoC.
> > >
> > > Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> > > ---
> > 
> > Hello
> > 
> > I have some comment below
> > 
> > >  drivers/crypto/Kconfig          |  11 ++
> > >  drivers/crypto/Makefile         |   1 +
> > >  drivers/crypto/zynqmp-aes-gcm.c | 297
> > > ++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 309 insertions(+)
> > >  create mode 100644 drivers/crypto/zynqmp-aes-gcm.c
> > >
> > > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig index
> > > 603413f..a0d058a 100644
> > > --- a/drivers/crypto/Kconfig
> > > +++ b/drivers/crypto/Kconfig
> > > @@ -677,6 +677,17 @@ config CRYPTO_DEV_ROCKCHIP
> > >  	  This driver interfaces with the hardware crypto accelerator.
> > >  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
> > >
> > > +config CRYPTO_DEV_ZYNQMP_AES
> > > +	tristate "Support for Xilinx ZynqMP AES hw accelerator"
> > > +	depends on ARCH_ZYNQMP || COMPILE_TEST
> > > +	select CRYPTO_AES
> > > +	select CRYPTO_SKCIPHER
> > > +	help
> > > +	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
> > > +	  encryption and decryption. This driver interfaces with AES hw
> > > +	  accelerator. Select this if you want to use the ZynqMP module
> > > +	  for AES algorithms.
> > > +
> > >  config CRYPTO_DEV_MEDIATEK
> > >  	tristate "MediaTek's EIP97 Cryptographic Engine driver"
> > >  	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST diff --git
> > > a/drivers/crypto/Makefile b/drivers/crypto/Makefile index
> > > afc4753..c99663a 100644
> > > --- a/drivers/crypto/Makefile
> > > +++ b/drivers/crypto/Makefile
> > > @@ -48,3 +48,4 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
> > >  obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
> > >  obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/  obj-y += hisilicon/
> > > +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
> > > diff --git a/drivers/crypto/zynqmp-aes-gcm.c
> > > b/drivers/crypto/zynqmp-aes-gcm.c new file mode 100644 index
> > > 0000000..d65f038
> > > --- /dev/null
> > > +++ b/drivers/crypto/zynqmp-aes-gcm.c
> > > @@ -0,0 +1,297 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Xilinx ZynqMP AES Driver.
> > > + * Copyright (c) 2019 Xilinx Inc.
> > > + */
> > > +
> > > +#include <crypto/aes.h>
> > > +#include <crypto/scatterwalk.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of_device.h>
> > > +#include <linux/scatterlist.h>
> > > +#include <linux/firmware/xlnx-zynqmp.h>
> > > +
> > > +#define ZYNQMP_AES_IV_SIZE			12
> > > +#define ZYNQMP_AES_GCM_SIZE			16
> > > +#define ZYNQMP_AES_KEY_SIZE			32
> > > +
> > > +#define ZYNQMP_AES_DECRYPT			0
> > > +#define ZYNQMP_AES_ENCRYPT			1
> > > +
> > > +#define ZYNQMP_AES_KUP_KEY			0
> > > +#define ZYNQMP_AES_DEVICE_KEY			1
> > > +#define ZYNQMP_AES_PUF_KEY			2
> > > +
> > > +#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
> > > +#define ZYNQMP_AES_SIZE_ERR			0x06
> > > +#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
> > > +#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
> > > +
> > > +#define ZYNQMP_AES_BLOCKSIZE			0x04
> > > +
> > > +static const struct zynqmp_eemi_ops *eemi_ops; struct zynqmp_aes_dev
> > > +*aes_dd;
> > 
> > I still think that using a global variable for storing device driver data is bad.
> 
> I think storing the list of dd's would solve up the issue with global variable, but there is only one AES instance here.
> Please suggest
> 

Look what I do for amlogic driver https://patchwork.kernel.org/patch/11059633/.
I store the device driver in the instatiation of a crypto template.

[...]
> > > +static int zynqmp_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
> > > +			     unsigned int len)
> > > +{
> > > +	struct zynqmp_aes_op *op = crypto_tfm_ctx(tfm);
> > > +
> > > +	if (((len != 1) && (len !=  ZYNQMP_AES_KEY_SIZE)) || (!key))
> > 
> > typo, two space
> 
> Will fix in the next version
> 
> > 
> > > +		return -EINVAL;
> > > +
> > > +	if (len == 1) {
> > > +		op->keytype = *key;
> > > +
> > > +		if ((op->keytype < ZYNQMP_AES_KUP_KEY) ||
> > > +			(op->keytype > ZYNQMP_AES_PUF_KEY))
> > > +			return -EINVAL;
> > > +
> > > +	} else if (len == ZYNQMP_AES_KEY_SIZE) {
> > > +		op->keytype = ZYNQMP_AES_KUP_KEY;
> > > +		op->keylen = len;
> > > +		memcpy(op->key, key, len);
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > It seems your driver does not support AES keysize of 128/196, you need to
> > fallback in that case.
> 
> [Kalyani] In case of 128/196 keysize, returning the error would suffice ?
> Or still algorithm need to work ?
> If error is enough, it is taken care by this condition 
> if (((len != 1) && (len !=  ZYNQMP_AES_KEY_SIZE)) || (!key))

I think this problem just simply show us that your driver is not tested against crypto selftest.
I have tried to refuse 128/196 in my driver and I get:
alg: skcipher: cbc-aes-sun8i-ce setkey failed on test vector 0; expected_error=0, actual_error=-22, flags=0x1

So if your hardware lack 128/196 keys support, you must fallback to a software version.

Anyway please test your driver with crypto selftest enabled (and also CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)

Regards
