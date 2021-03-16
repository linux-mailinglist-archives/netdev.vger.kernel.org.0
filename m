Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57B433D1BB
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhCPKXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbhCPKW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 06:22:57 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590F6C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:22:57 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id n24so4441983qkh.9
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GkJ3jxo7/KFXYSq89FTOt38RWpqi4R06hnBue+up1Z8=;
        b=EGqMvFY/a92lx5nERjVQBG6Y6N1bCtrM6KgBiMQ8xArUUv5enBIuVua9ClyZ7mBT3t
         t/ZULe5K3aVSindR8ZWCW/YHDggL5Ijtpag8MnqF8Bgo45O+ltJOTDb/iVcO1nlDKAVC
         jM0mVAIFvZQC+OntPvdOC9IP7B/EVVpeGnB78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GkJ3jxo7/KFXYSq89FTOt38RWpqi4R06hnBue+up1Z8=;
        b=lGhPkCSe+AbAhRCOTCopN9WrNJbrJgRorePEkapnut0HLMBs5kDQgtbEEpQpEUsstP
         Z4ejHsY13nbRIMm6SLts7XJWxzq37tXpHDILKS7AiKcI7m7L541U3vk8chlzSqudywU5
         ftBPxcIJBOxk2NjyPzBIRbtXYLduglSk5r94uK2oL9HcW8ZNsxANBksobAFkSroJ7DEB
         WLscJRGT48WJTvIeWnEJ7W6SwwSEQvG+DsMGvCuvH4lVcyzoeRiyqaIUVtdjWJ2H8Kgu
         PHY6UBv+zMPln2aYga16drwo2y+BqZqAgW6sH84XEGQ+XMSmzMjCoVb+1K/WlKiKVz83
         a29w==
X-Gm-Message-State: AOAM5328KXckOWOqQA9NgwCz5gvznUFyr+3h/w1kPi1QSwXBUXwku7TZ
        LsYovYWJZRvzOHYmCCmCVVpmCyEZFDfFhw==
X-Google-Smtp-Source: ABdhPJwpELWEOuZYuk4dmeaBcC6Nu19UDTBJsQLTzuIOJ9OK9uwLu3WIwWxRCcW3kTeHYPYwHLtvpw==
X-Received: by 2002:a05:620a:2a02:: with SMTP id o2mr29289933qkp.492.1615890176328;
        Tue, 16 Mar 2021 03:22:56 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id j30sm13041440qtv.90.2021.03.16.03.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 03:22:55 -0700 (PDT)
Subject: Re: [PATCH] net: ipa: Remove useless error message
To:     Jay Fang <f.fangjian@huawei.com>, elder@kernel.org
Cc:     netdev@vger.kernel.org
References: <1615887666-15064-1-git-send-email-f.fangjian@huawei.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <d83c4f03-245f-8230-3f67-c1cb96c8bcd2@ieee.org>
Date:   Tue, 16 Mar 2021 05:22:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1615887666-15064-1-git-send-email-f.fangjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/21 4:41 AM, Jay Fang wrote:
> From: Zihao Tang <tangzihao1@hisilicon.com>
> 
> Fix the following coccicheck report:
> 
> drivers/net/ipa/gsi.c:1341:2-9:
> line 1341 is redundant because platform_get_irq() already prints an error
> 
> Remove dev_err() messages after platform_get_irq_byname() failures.
> 
> Signed-off-by: Zihao Tang <tangzihao1@hisilicon.com>
> Signed-off-by: Jay Fang <f.fangjian@huawei.com>

The error message printed by platform_get_irq_byname()
does not indicate what the error (errno) is.  But in
practice we essentially won't get these errors, and
if we do the message from platform_get_irq() is
enough to know there's a problem of some kind.

Thanks for the patch.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
>   drivers/net/ipa/gsi.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 390d340..2119367 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1337,10 +1337,9 @@ static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
>   	int ret;
>   
>   	ret = platform_get_irq_byname(pdev, "gsi");
> -	if (ret <= 0) {
> -		dev_err(dev, "DT error %d getting \"gsi\" IRQ property\n", ret);
> +	if (ret <= 0)
>   		return ret ? : -EINVAL;
> -	}
> +
>   	irq = ret;
>   
>   	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);
> 

