Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E412EC370
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbhAFSrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbhAFSrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 13:47:51 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3673C061358
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 10:47:11 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id d20so3945482otl.3
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 10:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oBky9IsZzaVOpffccVN0ENWdeYQgjOceqsMbGawzZ3k=;
        b=G0YA9vg7I9aWvmOkJ1MUAA6N+we8K4mhL4ricDcu3b25XJCXBzrDYaxWOwEVjpg/CL
         Wu+DoV/BAo2hoMhQeybjL7GtF8VWUGf4890T7PR/is5GuOjO0jA5MH3fz2TEIvpzBSxp
         8/++ojVI0J4y0PdoyJyS/zjQ8YwdrfclHb8EN8zNbcUBkq7jNg/hiDmRgY0+qveDupqT
         KJkeFy1SrLGrBhNC6MKoEeflcxW75TEnHXi6mvhxS7MVVsvqs8jzXn7xoHL4bDMBwZ6Z
         nvwjNUpfgvw6i/OyERwG4KpMoFfexZQLTqwjOVzE5a3D+Y1BVAmGZbfy59TeE749JAL0
         FsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oBky9IsZzaVOpffccVN0ENWdeYQgjOceqsMbGawzZ3k=;
        b=LFFGloZU+v3V/MrH9K2iMJJelX+jyhhWCPTaAYEiPSre5M4hVXiIV1jo0Jw6jMliLx
         hu4LE39GmBkWqljp/YjsQwijTTQowSZKFJu8vHW0t6eyLNnF7hZ3rzjesA0KDaJ6+U1t
         kG3D+73y31GRi6vx+qsa6Zw8QaRmcIc3VGdgwFba3KiWSawQeWNSRd1+blvWr6gpTz8Q
         BJQ0F9zRz0uDyr8pyWxLtkbTpZcj8H4p3+SWyknpg9GgY51LY6CVqnXa0ce5imLDEG9t
         NxR1XvtQFAIdjOTI4S1VTQMSf3VsJEacyGmVVDAj1Dg8rsaRy08n4ISLtY9LcUVbtBX7
         Ryxg==
X-Gm-Message-State: AOAM531OVtAYQEphnHZPhirR5ws20nyYqvEiI3L1q/wly92sOxDGqlBi
        FPp/LdwxrzJ1p6s05cDuhfx3Cw==
X-Google-Smtp-Source: ABdhPJyDI9EArrMGcPEc2MlupYnX0BvdPeUP7bJcecw/uHZy4GKudhmiA//coVeHe38uqHFmfgMYMQ==
X-Received: by 2002:a9d:1725:: with SMTP id i37mr4121914ota.258.1609958831082;
        Wed, 06 Jan 2021 10:47:11 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id k3sm667025oor.19.2021.01.06.10.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 10:47:10 -0800 (PST)
Date:   Wed, 6 Jan 2021 12:47:08 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     agross@kernel.org, ohad@wizery.com, davem@davemloft.net,
        kuba@kernel.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] remoteproc: qcom: expose types for
 COMPILE_TEST
Message-ID: <X/YFrHDYAgyi619f@builder.lan>
References: <20210106023812.2542-1-elder@linaro.org>
 <20210106023812.2542-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106023812.2542-2-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 05 Jan 20:38 CST 2021, Alex Elder wrote:

> Stub functions are defined for SSR notifier registration in case
> QCOM_RPROC_COMMON is not configured.  As a result, code that uses
> these functions can link successfully even if the common remoteproc
> code is not built.
> 
> Code that registers an SSR notifier function likely needs the
> types defined in "qcom_rproc.h", but those are only exposed if
> QCOM_RPROC_COMMON is enabled.
> 
> Rearrange the conditional definition so the qcom_ssr_notify_data
> structure and qcom_ssr_notify_type enumerated type are defined
> whether or not QCOM_RPROC_COMMON is enabled.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

@Jakub, @Dave, as this is a prerequisite for allowing IPA to be compile
tested feel free to merge it together with patch 3.

Regards,
Bjorn

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  include/linux/remoteproc/qcom_rproc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/remoteproc/qcom_rproc.h b/include/linux/remoteproc/qcom_rproc.h
> index 6470516621749..82b211518136e 100644
> --- a/include/linux/remoteproc/qcom_rproc.h
> +++ b/include/linux/remoteproc/qcom_rproc.h
> @@ -3,8 +3,6 @@
>  
>  struct notifier_block;
>  
> -#if IS_ENABLED(CONFIG_QCOM_RPROC_COMMON)
> -
>  /**
>   * enum qcom_ssr_notify_type - Startup/Shutdown events related to a remoteproc
>   * processor.
> @@ -26,6 +24,8 @@ struct qcom_ssr_notify_data {
>  	bool crashed;
>  };
>  
> +#if IS_ENABLED(CONFIG_QCOM_RPROC_COMMON)
> +
>  void *qcom_register_ssr_notifier(const char *name, struct notifier_block *nb);
>  int qcom_unregister_ssr_notifier(void *notify, struct notifier_block *nb);
>  
> -- 
> 2.20.1
> 
