Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9013F79031
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfG2QBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:01:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38618 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbfG2QBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:01:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id f5so19661207pgu.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JPoICl2jmuwVCY4uE1r7Ty38gJq27Q0+J8wDhNw3+vw=;
        b=Dlcnt0qRspsCcVl9UmmGRHgYr4RP8gb3EhYNOi1mJxtY109oeRGiilGa9UL5FRjgOz
         WFYzuai0O8YKnkAfbRVRfTHipf3wlWfcS9NCKuIWzlAPzcw1xZitXrI6lCN95dcYG26+
         rkB2QlbdrSi087t+L8BKx6BbLlqQaiD6DQOGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JPoICl2jmuwVCY4uE1r7Ty38gJq27Q0+J8wDhNw3+vw=;
        b=Ic1YYHCet7HivVEMWj8Wt6IMY5WS/RHYw9aw0JIu/DUiE7JoPtoolUt/pboSvNg4JE
         cI8BfVw1zjj8OAyIefTXN64d/O3QNf+K9DK0QFRmu6wmMRSEnZdq1t/fqHo1hmur2ifO
         CICwDZG7KIiXHjPj2oybv8/YMeHTg88iMXvzYD51DoSqGuxLlhnWd1+TXvDuBeDdp8MM
         ZaFh4ZcZ6Y36+1LqAgyvqmlA/Gb9s/BS8UBx+D20qOPTcQPC8bRCr4K/VLup5OziZykd
         sc8wQ5844ZSKKp1uJEegWWsRpq0g9S3rAj92azl0v2O8T6r2Xf4a1zNoPq0LcupLOBdU
         ai1A==
X-Gm-Message-State: APjAAAVnxZgPFvpuNZ/bl4iaqXsZt8wNmjnXwUqk3/cXwqFzRY7u3u57
        DychV/3BvyiqkK1rfOUC6GekFg==
X-Google-Smtp-Source: APXvYqwnqrWKYQH3ulODk63tjoKMNyGn8GM05K6af1sRp16nZ53h16A7hdXrbMvs3F9Gxsd6NiwMTQ==
X-Received: by 2002:a17:90a:35e6:: with SMTP id r93mr113341053pjb.20.1564416076331;
        Mon, 29 Jul 2019 09:01:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y12sm71478789pfn.187.2019.07.29.09.01.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jul 2019 09:01:15 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:01:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] arcnet: com20020-isa: Mark expected switch fall-throughs
Message-ID: <201907290901.E15B283F7F@keescook>
References: <20190729142503.GA7917@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729142503.GA7917@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 09:25:03AM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings:
> 
> drivers/net/arcnet/com20020-isa.c: warning: this statement may fall
> through [-Wimplicit-fallthrough=]:  => 205:13, 203:10, 209:7, 201:11,
> 207:8
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/arcnet/com20020-isa.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com20020-isa.c
> index 28510e33924f..cd27fdc1059b 100644
> --- a/drivers/net/arcnet/com20020-isa.c
> +++ b/drivers/net/arcnet/com20020-isa.c
> @@ -197,16 +197,22 @@ static int __init com20020isa_setup(char *s)
>  	switch (ints[0]) {
>  	default:		/* ERROR */
>  		pr_info("Too many arguments\n");
> +		/* Fall through */
>  	case 6:		/* Timeout */
>  		timeout = ints[6];
> +		/* Fall through */
>  	case 5:		/* CKP value */
>  		clockp = ints[5];
> +		/* Fall through */
>  	case 4:		/* Backplane flag */
>  		backplane = ints[4];
> +		/* Fall through */
>  	case 3:		/* Node ID */
>  		node = ints[3];
> +		/* Fall through */
>  	case 2:		/* IRQ */
>  		irq = ints[2];
> +		/* Fall through */
>  	case 1:		/* IO address */
>  		io = ints[1];
>  	}
> -- 
> 2.22.0
> 

-- 
Kees Cook
