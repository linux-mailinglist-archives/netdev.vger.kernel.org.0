Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41EE10A9C0
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfK0FFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:05:42 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33632 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfK0FFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 00:05:42 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so1597954pjb.0
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 21:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xZ4O83bgDIw/8dIBhV4hXPyaX+XZAbVnynBzLd9+iLI=;
        b=JLaTbp8IWD3cAfVShRjwwPtl0yRZr6oE7Ksf4+lSwE3sJZ6lsicMVJulQ6G1kM9Dus
         OXHEYfdMsxCiR3NLCf+GjSURk4lk+VsPw08Zn8+s3EUJSvdinEWQWNBxF9btYJQPqnTC
         4zqtp3YYKPt274JrfE7hL+cLC8Ebd0hEeP7+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xZ4O83bgDIw/8dIBhV4hXPyaX+XZAbVnynBzLd9+iLI=;
        b=T/A5i6c3B/gVSbYHtwyidUe6XedfVDm6bHkqJtxOjm8g4L4edLSgKaKHrpQw3+vDjz
         VGcIHX7HoNZxMD0EzOam3MzM2wZ1NvGx7KKmJX4ZynLLmlti3lIPyILk7LpiPPrUST/W
         0Gfn3H3g3fezTpSQoXpXnIuQPVdFTC4gdYhBd4qy84YbImOqZhy83gGuK1yMfXp/bDfP
         J28aU9AIpYT6ey9u3bXjxo+7kVyTla3RVtmPuc3Zue0dvjTQcb5n5GBhu3Pp3HGwKsSE
         KeJuUvg6BfNZctF3yuOwgzk85vUM2lWAUZqPfLRmMXTNnhQ2ilPHT4auT2sLoDw+TNjh
         vkcQ==
X-Gm-Message-State: APjAAAWo9fSbLzJECmwOTFuPfr0jMhp03mHcMnffJskm+C9668YetePU
        Pt5HPjmgdoHx1rR1PWavRYt6Og==
X-Google-Smtp-Source: APXvYqzsYFZ3auba035H26fOpwRDetbWUh/33lew+U6cqe7LVIiXhT1QT5AwJLEUhwHRXSE9BpoINw==
X-Received: by 2002:a17:90a:d353:: with SMTP id i19mr3658245pjx.43.1574831141772;
        Tue, 26 Nov 2019 21:05:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f10sm14155169pfd.28.2019.11.26.21.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 21:05:40 -0800 (PST)
Date:   Tue, 26 Nov 2019 21:05:39 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     Larry.Finger@lwfinger.net, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org, Wright.Feng@cypress.com,
        arend.vanspriel@broadcom.com, davem@davemloft.net,
        emmanuel.grumbach@intel.com, franky.lin@broadcom.com,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        netdev@vger.kernel.org, p.figiel@camlintechnologies.com,
        pieter-paul.giesberts@broadcom.com, pkshih@realtek.com,
        rafal@milecki.pl, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, yhchuang@realtek.com,
        yuehaibing@huawei.com
Subject: Re: [Patch v2 1/4] b43legacy: Fix -Wcast-function-type
Message-ID: <201911262105.83DCA06@keescook>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
 <20191126175529.10909-1-tranmanphong@gmail.com>
 <20191126175529.10909-2-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126175529.10909-2-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 12:55:26AM +0700, Phong Tran wrote:
> correct usage prototype of callback in tasklet_init().
> Report by https://github.com/KSPP/linux/issues/20
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

Thanks for sending these!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/wireless/broadcom/b43legacy/main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
> index 4325e91736eb..8b6b657c4b85 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/main.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/main.c
> @@ -1275,8 +1275,9 @@ static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
>  }
>  
>  /* Interrupt handler bottom-half */
> -static void b43legacy_interrupt_tasklet(struct b43legacy_wldev *dev)
> +static void b43legacy_interrupt_tasklet(unsigned long data)
>  {
> +	struct b43legacy_wldev *dev = (struct b43legacy_wldev *)data;
>  	u32 reason;
>  	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
>  	u32 merged_dma_reason = 0;
> @@ -3741,7 +3742,7 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
>  	b43legacy_set_status(wldev, B43legacy_STAT_UNINIT);
>  	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
>  	tasklet_init(&wldev->isr_tasklet,
> -		     (void (*)(unsigned long))b43legacy_interrupt_tasklet,
> +		     b43legacy_interrupt_tasklet,
>  		     (unsigned long)wldev);
>  	if (modparam_pio)
>  		wldev->__using_pio = true;
> -- 
> 2.20.1
> 

-- 
Kees Cook
