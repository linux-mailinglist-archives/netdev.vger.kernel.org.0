Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D1424C1E6
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgHTPPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgHTPO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:14:56 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598ACC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 08:14:56 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a5so2387426wrm.6
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 08:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1JIx2ISbFr+im/JgAERrUViXQQVGSVzCpzNwvt0+XNE=;
        b=dDu8qc5XfXdfKM1LxePr/NKLom1qi8g19klgDh+jXyzTb3maA+ocOFdRXZ1sUbkOxt
         Unjn5eeXDTlmRp0dowIdPwuIqfjvud1hYuXLspC4/ntK6nnVecN3xDRJFmTrH2e/zUZR
         +Umd+slHkiC23WPaa6wR6l+fi3iYgscRZ9u3wHb25kv7cHIpo+kXs6m9eDp6aHwKMPwB
         SyUIyNGT7Fu8oHJIJFrOlR/w2keoqYsH4WGy1pS20+NQcwAiedciAmC1A7XbzW3BtHhM
         n141lHGlQVFg+9scIhfOAIoD/+06ngx8Im3fWZy7XnpEm3B7Oil+r+fvs9yY5SYDN7hn
         SkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1JIx2ISbFr+im/JgAERrUViXQQVGSVzCpzNwvt0+XNE=;
        b=FwnGQtIczsKTKjeRnVL36t4WqnX6a7mm/vuVZJvwBy2jFSL3HAJDU/15vO9wM77X6o
         NijHYch+EWyO5bQvXvYMptiOd6K0es5meGY5tKulUAuRKXuyLC3CirD7dgzTzMxHyX+M
         fPqjD7Xpfi8+fDWz1rv0o2se8izj4ckaUS3rkKCbJsQbbgoPYG+V78F7w3Gu/D+0A7FD
         fopYdfyTw//xNbddztC/e4LFgMZlKfROFgV1Ry97CYqOuJJap1F4b/G0tM2eJfklHIOn
         F198hl4iHgF2JbQxUWCJnnsi22VRL5qrYWMut2o25DN8QKNVHPlfZzUHUru3tmh7muJn
         7GiA==
X-Gm-Message-State: AOAM5305PRwSsLjGJsvqZt2xmkXPITwUT653KSVnQPUL3ywrwVQOvmHa
        5Ag64TX9wQHwdhjSDf8ASyHj+Ad+jefZLQ==
X-Google-Smtp-Source: ABdhPJz/JzWlSHxnKvkkvbTVdybR2TT4tlXyL6T43fyxPVfm2rAh0xRz1X2y0/GBr+KyqIt17t4SYg==
X-Received: by 2002:adf:df91:: with SMTP id z17mr4016175wrl.149.1597936494980;
        Thu, 20 Aug 2020 08:14:54 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:4c33:86ac:46d7:4d8e? ([2a01:e0a:410:bb00:4c33:86ac:46d7:4d8e])
        by smtp.gmail.com with ESMTPSA id j4sm4657814wmi.48.2020.08.20.08.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 08:14:53 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next v2] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
To:     antony.antony@secunet.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Antony Antony <antony@phenome.org>,
        Stephan Mueller <smueller@chronox.de>
References: <20200728154342.GA31835@moon.secunet.de>
 <20200820120453.GA18322@moon.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <60709458-cc80-9015-e507-137b80c78660@6wind.com>
Date:   Thu, 20 Aug 2020 17:14:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820120453.GA18322@moon.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 20/08/2020 à 14:04, Antony Antony a écrit :
[snip]
> @@ -38,6 +48,15 @@ static struct ctl_table xfrm_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec
>  	},
> +	{
> +		.procname	= "xfrm_redact_secret",
> +		.maxlen		= sizeof(u32),
> +		.mode		= 0644,
> +		/* only handle a transition from "0" to "1" */
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1         = SYSCTL_ONE,
> +		.extra2         = SYSCTL_ONE,
nit for the v3: the '=' of the last two lines is aligned with spaces while the
first lines use tabs.
