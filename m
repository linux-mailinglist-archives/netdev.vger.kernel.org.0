Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52C38DD4F
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 23:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhEWVd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 17:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhEWVdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 17:33:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5230C061574;
        Sun, 23 May 2021 14:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=zwy49mBFt0f/ZPtPHzgSxw7NhGYpoFYgHQDG3NspMlg=; b=cmLB1nQUM7/1eU0JpuzQi9vXzM
        sel/Ty4HL8EDgqm99ja9/jmeSH/K7HsiP0y6DsNVYT++sVwZ74usky+8vumH7lUcZ+pgSw2VZDHeK
        D3qKj5kqM/dNqziVVGVA/VO8NeWroxRvRAlxr2stom2RglffOVz1ciC36MBjvli7d7PMLhULk2u3C
        b1rKbVmeDQ/R68m6eZdeUmOYuULEDaHpI7CCIjHBRGtAp8qPHrqZ4fh7ZRHYFkGlQa0QCWPOktI6X
        K5deAYA8WtTKFD3Hg8ilyGfAhnInh3x3lUx6zkajXl7t1lcaFOQVEtpTkhgXSGDIQW3Grqh9ESR3k
        b+Mr1aZg==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lkvhV-000Zzz-DI; Sun, 23 May 2021 21:31:57 +0000
Subject: Re: [PATCH] NFC: nfcmrvl: fix kernel-doc syntax in file headers
To:     Aditya Srivastava <yashsri421@gmail.com>,
        krzysztof.kozlowski@canonical.com
Cc:     lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210523210909.5359-1-yashsri421@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f194e3a9-c541-8ee9-3332-22f25d7a7bc5@infradead.org>
Date:   Sun, 23 May 2021 14:31:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210523210909.5359-1-yashsri421@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/21 2:09 PM, Aditya Srivastava wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> The header for drivers/nfc/nfcmrvl follows this syntax, but the content
> inside does not comply with kernel-doc.
> 
> This line was probably not meant for kernel-doc parsing, but is parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warnings from kernel-doc.
> For e.g., running scripts/kernel-doc -none on drivers/nfc/nfcmrvl/spi.c
> causes warning:
> warning: expecting prototype for Marvell NFC(). Prototype was for SPI_WAIT_HANDSHAKE() instead
> 
> Provide a simple fix by replacing such occurrences with general comment
> format, i.e. '/*', to prevent kernel-doc from parsing it.
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/nfc/nfcmrvl/fw_dnld.h | 2 +-
>  drivers/nfc/nfcmrvl/i2c.c     | 2 +-
>  drivers/nfc/nfcmrvl/nfcmrvl.h | 2 +-
>  drivers/nfc/nfcmrvl/spi.c     | 2 +-
>  drivers/nfc/nfcmrvl/uart.c    | 2 +-
>  drivers/nfc/nfcmrvl/usb.c     | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nfc/nfcmrvl/fw_dnld.h b/drivers/nfc/nfcmrvl/fw_dnld.h
> index ee4a339c05fd..058ce77b3cbc 100644
> --- a/drivers/nfc/nfcmrvl/fw_dnld.h
> +++ b/drivers/nfc/nfcmrvl/fw_dnld.h
> @@ -1,4 +1,4 @@
> -/**
> +/*
>   * Marvell NFC driver: Firmware downloader
>   *
>   * Copyright (C) 2015, Marvell International Ltd.
> diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
> index 18cd96284b77..c5420616b7bc 100644
> --- a/drivers/nfc/nfcmrvl/i2c.c
> +++ b/drivers/nfc/nfcmrvl/i2c.c
> @@ -1,4 +1,4 @@
> -/**
> +/*
>   * Marvell NFC-over-I2C driver: I2C interface related functions
>   *
>   * Copyright (C) 2015, Marvell International Ltd.
> diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
> index de68ff45e49a..e84ee18c73ae 100644
> --- a/drivers/nfc/nfcmrvl/nfcmrvl.h
> +++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
> @@ -1,4 +1,4 @@
> -/**
> +/*
>   * Marvell NFC driver
>   *
>   * Copyright (C) 2014-2015, Marvell International Ltd.
> diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
> index 8e0ddb434770..dec0d3eb3648 100644
> --- a/drivers/nfc/nfcmrvl/spi.c
> +++ b/drivers/nfc/nfcmrvl/spi.c
> @@ -1,4 +1,4 @@
> -/**
> +/*
>   * Marvell NFC-over-SPI driver: SPI interface related functions
>   *
>   * Copyright (C) 2015, Marvell International Ltd.
> diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
> index e5a622ce4b95..7194dd7ef0f1 100644
> --- a/drivers/nfc/nfcmrvl/uart.c
> +++ b/drivers/nfc/nfcmrvl/uart.c
> @@ -1,4 +1,4 @@
> -/**
> +/*
>   * Marvell NFC-over-UART driver
>   *
>   * Copyright (C) 2015, Marvell International Ltd.
> diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
> index 888e298f610b..bcd563cb556c 100644
> --- a/drivers/nfc/nfcmrvl/usb.c
> +++ b/drivers/nfc/nfcmrvl/usb.c
> @@ -1,4 +1,4 @@
> -/**
> +/*
>   * Marvell NFC-over-USB driver: USB interface related functions
>   *
>   * Copyright (C) 2014, Marvell International Ltd.
> 


-- 
~Randy

