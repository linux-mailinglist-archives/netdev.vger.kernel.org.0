Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44845278CC5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgIYPdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbgIYPdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:33:06 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F950C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:33:06 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a12so2872644eds.13
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pR7yuQAlmENp4pL1cTC2XGTJ+IwhSzJ1lcWJc18JAoE=;
        b=WH+x0DDoocDTfFMx9PfQ3Az163GFMIRLjEm8R01m4TYAJVGRbUkK9SrnttGNIkzt7w
         u5rfe2sG+y66fpmlVNx2hwNsDkTTvcmBM/lNCDElFPVKrwOpoVGrcZXI1bEJE2672ZSa
         fx12wFfyhklkHIkahSEwQfAQcI9r2jjoIE3juICj8oZcot+TD28F3VZInUUsP6x2ioGI
         aOYtE9K372w1na9nIkx/3f1zf9wf7wCQkakmHjByvZ9txvvVuk7TI3sgYlhRHFRpsErZ
         12veDNtFbwdzWN+csgji68Ezlql5Bz+TaXkNFp0I2RQf8QTPbTHNsM39+AOCLULeUUrw
         qTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pR7yuQAlmENp4pL1cTC2XGTJ+IwhSzJ1lcWJc18JAoE=;
        b=oCrcS7sF6tdvm/YEMWiM67zYkAV2QXr329Kr+ir/XwCuqHPVUjF4gRivADQmyCG4gJ
         wPk/cAqjox49XXVP4obGFEcoedzaKxQIMV957rl7KReLobQxbod+3Hii1RfyYSg3hwJT
         angi1p9KY+Yaft4Kwqh2WRQzw6+jcvQMG3Y/JddRYx9vLe4qe8SWUfDPycfctstvtMh3
         hBe6Il5SOt2h/81PMMsbqwqFY4RUfZQX+xaMjy/qUQKf7Tm5GJGRUru5XuqCB6fo0X63
         Ec1xCpN8C64S71eNRXTqjM4RmQDmKhO/KBlTpBoPAh0+3GjJIuteBnZMS12X8wEOc7oW
         h5Zw==
X-Gm-Message-State: AOAM533mEUlUlseXm+NuGDZvT/19vBwL0dQPg50kzeZcE1GbZHX71IlY
        HioiQY0K3HH1WrABjRjXCQ4=
X-Google-Smtp-Source: ABdhPJxSYdNAMBl9cBjQHQUlvjqZqnTeDD3fa1SvLmLE3zKLAkLMXkGDrvFHFX5yJwFtALEY4HHYTg==
X-Received: by 2002:a05:6402:6c1:: with SMTP id n1mr1934329edy.215.1601047984783;
        Fri, 25 Sep 2020 08:33:04 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id d24sm2095574edp.17.2020.09.25.08.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 08:33:04 -0700 (PDT)
Date:   Fri, 25 Sep 2020 18:33:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net] MAINTAINERS: Add Vladimir as a maintainer for DSA
Message-ID: <20200925153302.gyjkbvtvkybvb5sf@skbuf>
References: <20200925152616.20963-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925152616.20963-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 08:26:16AM -0700, Florian Fainelli wrote:
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Thank you Florian, it is a pleasure for me to help out DSA to evolve and
gain traction, as well as to work with you guys.

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9350506a1127..6dc9ebf5bf76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12077,6 +12077,7 @@ NETWORKING [DSA]
>  M:	Andrew Lunn <andrew@lunn.ch>
>  M:	Vivien Didelot <vivien.didelot@gmail.com>
>  M:	Florian Fainelli <f.fainelli@gmail.com>
> +M:	Vladimir Oltean <olteanv@gmail.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/
>  F:	drivers/net/dsa/
> --
> 2.25.1
>

Thanks,
-Vladimir
