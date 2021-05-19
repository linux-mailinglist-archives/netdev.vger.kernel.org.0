Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2401B389281
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354732AbhESPZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 11:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346350AbhESPZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 11:25:12 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2709AC06175F;
        Wed, 19 May 2021 08:23:52 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id b12so8881307ljp.1;
        Wed, 19 May 2021 08:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vZqm6PyudcGSEfI1UhpCQCBW48YlXZO5HgZI4Wx4nO8=;
        b=Bsctn8IQ8TOypJMZcrD/cP56fNtLPDpC28hi+wdXT9RBsG8uT+pybRIExKqiv2U1h2
         1CeaRLl/wW7jCOX8ZsWirRAoh7p42CGKhcdKM2prNT9yFdkZ6QpbCUnsvkK4ybNvCKDX
         RcxIz5E1rqHDlkFnSHiZBkPUELDwaqZ1SbpQ/8IaGJe/v56qWqHHnNxHY2YtXT9C9t7c
         DKa17i2LeupTM24mzs0xOUc07K6cwDvlt72gvhHlhWU3iU0s//4eyzpE9ZteA+5YIRfB
         WBwn9ikxKsRuCiDgoqw0Px2szd5FnnijEAq9vY5uK1gFrDbcq5o0M6UCSiH0jLsG4ZbC
         4Lcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vZqm6PyudcGSEfI1UhpCQCBW48YlXZO5HgZI4Wx4nO8=;
        b=tCsn+K10uEdWyegAzv1JVOi19cnsxzCTj/ZosDcvwn/yMZg9rFQcMnJTJUwDnyGZa7
         SZO1KwN8/yuKewKh7Z5pNnJfqiWa8pIsRl4KBXKOSWusYT/unN5r24TbvhbX+n7u1uLz
         P6Gdm2yiB04QZfJo8SC9Ogn0C/P4Tx6I4VuEy1t7Hs5FWK1v9dARva2jwndM5yr5hZ41
         sMmg4ta+6Q+rewYD9HH6F/EbSlPdHLIxnV9hjn7UoAIGiCG14vY2CLpfAXEi98g2g4J7
         cBOZYvs8QRBqn3WZiF4zTiV2KDaGnnDT1HhUDt+Q5NotJOZG1h03pS6L/RxRhh8QdyAY
         lFeQ==
X-Gm-Message-State: AOAM532cNSvWQBQUJwi2WYYqQnwJGEdeBbCr2elZFEeYxjN18BET30Nm
        byw/DbdqIGVYWvfH8OV3uTZ/qOQjFMo=
X-Google-Smtp-Source: ABdhPJwSEN1RWsujXeRoEt2h6tX8IMiUPrIOJqBqMey8M27eLZbjedEBzGK7nMIxWzRtlTKukSMyCA==
X-Received: by 2002:a2e:a7cb:: with SMTP id x11mr9284749ljp.143.1621437830321;
        Wed, 19 May 2021 08:23:50 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.83.229])
        by smtp.gmail.com with ESMTPSA id y3sm1982lfl.34.2021.05.19.08.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 08:23:50 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: net: renesas,ether: Update Sergei's email
 address
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <15fb12769fcfeac8c761bf860ad94b9b223d3f9c.1621429311.git.geert+renesas@glider.be>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <ac381693-628c-e298-ca82-a6c6d70690e5@gmail.com>
Date:   Wed, 19 May 2021 18:23:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <15fb12769fcfeac8c761bf860ad94b9b223d3f9c.1621429311.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 5/19/21 4:02 PM, Geert Uytterhoeven wrote:

> Update Sergei's email address, as per commit 534a8bf0ccdd7b3f
> ("MAINTAINERS: switch to my private email for Renesas Ethernet
> drivers").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/renesas,ether.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
> index 8ce5ed8a58dd76e6..c101a1ec846ea8e9 100644
> --- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
> @@ -10,7 +10,7 @@ allOf:
>    - $ref: ethernet-controller.yaml#
>  
>  maintainers:
> -  - Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> +  - Sergei Shtylyov <sergei.shtylyov@gmail.com>

Acked-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
