Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D191660E2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgBTPY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:24:58 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34675 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgBTPY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:24:56 -0500
Received: by mail-pj1-f65.google.com with SMTP id f2so1275700pjq.1
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 07:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x64IzpxQxgoD+epizuWhLq6VmBY0vv/CGFxkWQZpQEs=;
        b=xzHA3evsbmbuNoQNBVN3xL96+3fHb4eHM6XCsq5SNnWSm9ZFv1oj4hjvgBmjYl0uFd
         iWpzSc7739TGJepNYRkCO5DW+ju1PFJL9Qie7xNeQRJXRrVYoeqIYwqxecKVURKary9/
         yRV1pZy3aN1EquYn1i/gNQmFvt2aT7WUNRS+pWc0g9qD2YZDkxZHROaP1ETKQ85hPnmv
         5YjghAqzQSazmdx1ERFslgn1aMEvyiSz6JU1/4YJSSw715sVBw7/3ZlB1fjXcQa2mcw9
         2+ILztPxlfdEJlYoybnkg+5p5mo45wYt7/DMjmDlVPSiVUJzhZBnqf7hpEpkFFQzv5Dh
         vVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x64IzpxQxgoD+epizuWhLq6VmBY0vv/CGFxkWQZpQEs=;
        b=ZXkdzh04WRGO8GY3WsmPso/vq3Z0G75bmbBq7qx6Sdz7PwD2gt7mlu1iU6DUom6A6r
         HNytEbGXjS+Wu5I/uE+H5zw/hMs8HPY0sFFxO5uee9awGylTKa3ZBr3o4mK3tkwaOebM
         9qrfyxSqupb9q3m/p6kGdJJOqLbcKBni2FPShX2IEEc6ZXSibQlPy2tvldjbZYkAf5fk
         Arf2IrQU5t1FNVsA2FDJ9C/SeGwhFYXVurYWO/Gou9IFXTnkBmrRKEPPJhXV7rlRDek+
         5gTvQuAunIFv3cw6vU3FSAa0WTBdyDz9+G5lGzR4HquToMC4J/ZtsUUJxZz1uEulZLjW
         k5Qg==
X-Gm-Message-State: APjAAAXf/iSu4dEUltjTqnZjqroXO261jcEhLkkQFCozH9gPjzVvvDwh
        rQXF/MhzMkmROeF5nqs9rIfYQw==
X-Google-Smtp-Source: APXvYqx7FoRaaZ+BLfysstttTcWpdHJjdDonV5aa3Tld/CpF08uYFDpMPfbSWWYTQyUy9AHDsKP9lQ==
X-Received: by 2002:a17:90a:c388:: with SMTP id h8mr4088982pjt.83.1582212293781;
        Thu, 20 Feb 2020 07:24:53 -0800 (PST)
Received: from ripper (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id b3sm3820107pjo.30.2020.02.20.07.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 07:24:53 -0800 (PST)
Date:   Thu, 20 Feb 2020 07:23:56 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, arnd@arndb.de, smohanad@codeaurora.org,
        jhugo@codeaurora.org, kvalo@codeaurora.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 15/16] net: qrtr: Do not depend on ARCH_QCOM
Message-ID: <20200220152356.GA955802@ripper>
References: <20200220095854.4804-1-manivannan.sadhasivam@linaro.org>
 <20200220095854.4804-16-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220095854.4804-16-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 20 Feb 01:58 PST 2020, Manivannan Sadhasivam wrote:

> IPC Router protocol is also used by external modems for exchanging the QMI
> messages. Hence, it doesn't always depend on Qualcomm platforms. As a side
> effect of removing the ARCH_QCOM dependency, it is going to miss the
> COMPILE_TEST build coverage.

The COMPILE_TEST was there so that the code could be compile tested on
other platforms, but without the ARCH_QCOM dependency this will always
be the case. So I would suggest that you drop the last sentence. (Or
write "With this we no longer need to depend on COMPILE_TEST, so remove
that too.")

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  net/qrtr/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
> index 8eb876471564..f362ca316015 100644
> --- a/net/qrtr/Kconfig
> +++ b/net/qrtr/Kconfig
> @@ -4,7 +4,6 @@
>  
>  config QRTR
>  	tristate "Qualcomm IPC Router support"
> -	depends on ARCH_QCOM || COMPILE_TEST
>  	---help---
>  	  Say Y if you intend to use Qualcomm IPC router protocol.  The
>  	  protocol is used to communicate with services provided by other
> -- 
> 2.17.1
> 
