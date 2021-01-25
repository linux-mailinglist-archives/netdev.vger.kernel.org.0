Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF7E304A16
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbhAZFQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730003AbhAYPfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:35:40 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F84C061223
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:23:05 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id 36so13069798otp.2
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 07:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lo7lv5OxxAFtMueqAJVGhFDn/LukUddIU2Fiy+gEQuI=;
        b=poLLy+034v97d/qsqdvFRNp6ftVN3OOuUAYS0xkwOOf+DYk39RRi0TCQ3ygJsx4su4
         PjriCB2cfkatWbJMaNnz3vjVMx5hQ8e3DDBt+dQK6twLbvls5Br2ykNw1iF07JAPcK3q
         YD8C8PXHlvlT0QhZDJRMmCuWxwSZdwzwTE4Fn5HjByn9BUvz+wD9ywluI//upUkioE6F
         +Cnhjv0d57cVMGDX1qnVhPSljeiOh9fcw8NMcGIZSfbZSFNnqA/mKmXUj2iUwBuNH8Uf
         uEPhgDVvWzBt9cA+rCH475atw2tQWmD06uv2eXSVlJbc/LpYYszre6RITiU1qx/BOmcK
         onuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lo7lv5OxxAFtMueqAJVGhFDn/LukUddIU2Fiy+gEQuI=;
        b=jSsySAK3BTmyuEguIRIEf8eUJcEsx40xdpTdGh8evJbCsmocJ7POPxruuB5C6x0p2H
         t0+791Go41hZQDcul6US8dgvAlhLWUJT/0VlDBi5MgTANgaEpaSRX8hARqr2WYsRGbYQ
         HdeDK3jbYWhsptPT2O3XjlsnEVI7u/IgnUWCpXmp7bUhEFEkCgVslFBeFhEBU0lNTB4G
         kUkm900TcP4QEjhzK2lZg5OXK9Ztjpp9mg31lnGJXDcXBQcJHlxtbo9bp3SR27Mq95BW
         yhMlK0DGUJ8pP9DDQ4j4PPjA7dg/bGkNgh2pw1KP7UbGMG2kiK1p9hgE2sP3Z8krVakS
         UVgw==
X-Gm-Message-State: AOAM532Idd1Cc8doycFE+5r2Ccvx9MQO7sg73G6zDy3Kd7q8UzUqnawW
        BZo+gLZMQ7n0xXbi2NMrKCy9FA==
X-Google-Smtp-Source: ABdhPJwsaz6kYv5Vz5E7CK/Izn6RArB6cWNzJaxLMm0/XF/bSXo+TCcgoT1Rjv4Yk8hqCXnA9fuzyA==
X-Received: by 2002:a9d:3786:: with SMTP id x6mr818146otb.176.1611588184943;
        Mon, 25 Jan 2021 07:23:04 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id c26sm2560370otu.48.2021.01.25.07.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 07:23:04 -0800 (PST)
Date:   Mon, 25 Jan 2021 09:23:01 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] ipa: add remoteproc dependency
Message-ID: <YA7iVQtm8P2F1VAN@builder.lan>
References: <20210125113557.2388311-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125113557.2388311-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 25 Jan 05:35 CST 2021, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Compile-testing without CONFIG_REMOTEPROC results in a build failure:
> 
> >>> referenced by ipa_main.c
> >>>               net/ipa/ipa_main.o:(ipa_probe) in archive drivers/built-in.a
> ld.lld: error: undefined symbol: rproc_put
> >>> referenced by ipa_main.c
> >>>               net/ipa/ipa_main.o:(ipa_probe) in archive drivers/built-in.a
> >>> referenced by ipa_main.c
> >>>               net/ipa/ipa_main.o:(ipa_remove) in archive drivers/built-in.a
> 
> Add a new dependency to avoid this.
> 

Afaict this should be addressed by:

86fdf1fc60e9 ("net: ipa: remove a remoteproc dependency")

which is present in linux-next.

Regards,
Bjorn

> Fixes: 38a4066f593c ("net: ipa: support COMPILE_TEST")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ipa/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
> index b68f1289b89e..aa1c0ae3cf01 100644
> --- a/drivers/net/ipa/Kconfig
> +++ b/drivers/net/ipa/Kconfig
> @@ -3,6 +3,7 @@ config QCOM_IPA
>  	depends on 64BIT && NET && QCOM_SMEM
>  	depends on ARCH_QCOM || COMPILE_TEST
>  	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
> +	depends on REMOTEPROC
>  	select QCOM_MDT_LOADER if ARCH_QCOM
>  	select QCOM_QMI_HELPERS
>  	help
> -- 
> 2.29.2
> 
