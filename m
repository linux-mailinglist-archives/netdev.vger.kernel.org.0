Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E082C5A06
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404287AbgKZRDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:03:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39815 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391628AbgKZRDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:03:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id s13so3065348wmh.4;
        Thu, 26 Nov 2020 09:03:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cgybd6xbGXLkt0sw6GYKKfpw15ST7qyxdFUHppXT/mE=;
        b=qmGJZE2AssYoYt6kY12tH0nu1IZKBoxiuUX5YvduknHZkei6WhYmjLRfah2mSx8LOI
         uIb1OHrCEiFP8j3AZfxw6BvjwwvtL8uIeDNL29xeBkBtD50psxPOSSaWUUJEBmYr1VNC
         BeqwLueWwHrEZQMy1aZpLBG3zkJlUzyTKEfNUt6480/a+7SXNtLvVslBqKQY9uZ3Ifgy
         7+XVIQGfWlUT7RAh7znSd9wd8S27CVXx9gfqzSKQC6MGpGSgQIHPE64ik0jyfaWxt1Ot
         0tVJV5T/QDXnpsYSh2dsp9cr21p87IQrBkYwlq5Xz5FiJtSH/Vu8PkLrore3qIXAL6Po
         xrqg==
X-Gm-Message-State: AOAM533L4yiJ+rnKK7//uAdRPTYmC+9twIHQG2/5cE3M309k61Q80ZwR
        19Wkcbk8QnulnzSt7O1SYZc=
X-Google-Smtp-Source: ABdhPJydsaRL6q7BidWBXwnOtWeYEizgqHM52UNuaQ347n6zbnTQh9mQZMMPUix323JU6c8R20wMyA==
X-Received: by 2002:a7b:c412:: with SMTP id k18mr4486905wmi.36.1606410215008;
        Thu, 26 Nov 2020 09:03:35 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id e27sm11480050wrc.9.2020.11.26.09.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 09:03:33 -0800 (PST)
Date:   Thu, 26 Nov 2020 18:03:30 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     bongsu.jeon2@gmail.com
Cc:     k.opasiak@samsung.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next 2/3] nfc: s3fwrn5: reduce the EN_WAIT_TIME
Message-ID: <20201126170330.GB4978@kozik-lap>
References: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
 <1606404819-30647-2-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606404819-30647-2-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 12:33:38AM +0900, bongsu.jeon2@gmail.com wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> The delay of 20ms is enough to enable and
> wake up the Samsung's nfc chip.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> index ae26594..9a64eea 100644
> --- a/drivers/nfc/s3fwrn5/i2c.c
> +++ b/drivers/nfc/s3fwrn5/i2c.c
> @@ -19,7 +19,7 @@
>  

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
