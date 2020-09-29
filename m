Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A11F27D15E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgI2Ois (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgI2Ois (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:38:48 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0CFC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 07:38:47 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g96so4618877otb.12
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 07:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CeAhjsVpPlkutIILOxVTEMI1x28fxs4ubetSNjGcP7o=;
        b=BHvgNDYIjjwF0sJw5DecMcDIn+fYZwnJHHA3IvTEbmCNZohrflaMw1Q4uwEpcaoOXC
         K/fiUmSRNF0kr4L62o4kgJVirxMhMfHED6+UbhQ+AbjQv1tk2Tz1kaItDtfNsVOvjCKN
         mEkvLykFEBhRL/cOpPgQpZRtZ0o/2nJuaRQAhPLpTs3SYVFSdP1pII3j9BDqk//OSmIA
         9QsBmU87sB4w4TURv1M91sU7A7iMURdMzeB5E+1GkJ3aVBlnm/wKAcS4P5grH3H8mMLN
         hkIXgP4vk4d+XjPOxaA/3CkIyzPAnTS5/VZAkcjz+3JSKU+x7yICZk6Fx3n4GkP/LT+v
         urmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CeAhjsVpPlkutIILOxVTEMI1x28fxs4ubetSNjGcP7o=;
        b=oE7iDkSgNl5UMhbkt0fiE8RhJo8AayqV5ETj4+L7UMeh3xH/4nR8tkAbC2gap/EjVP
         KjKTQv11oB2QycI07klLEH4S8JiqNpdQrjhcHVaW9YAdeCBXfrB7H0C4GjRwVB3LdU2Y
         KhZH75AU4qGEnxXrUn04pVsS0h5qCw1PnYYfkGMVm+sVl9IXGwhEmvK+n/m4cAoKRXuN
         bDRJ/WUzaipyTxXU0FdtjXYPZZzfQuUAo6gFflRctfyeiMTOxDS0ez7pKgwqO1dTf12z
         hwHhScXzvho8bGsfNcBuf6BTyhVlhJRcdWaH936fvskEsv7Yl3MdSJZJWTnMX31pJRKZ
         tb6g==
X-Gm-Message-State: AOAM5329OfK0AlujRm/KJbwChiMmR5n3tR7Bg0NJo1JGD+brJTWP9zRM
        uHpbbzih29VzWRVO2SvvEnQATA==
X-Google-Smtp-Source: ABdhPJz5IGtSxQ2A/ESt0jo5nLd8DAstxSqDnfZeznEkkCbWpjmzgcCx1Rj1rHFneBLKGZ3yf0l3LA==
X-Received: by 2002:a9d:65c8:: with SMTP id z8mr2919074oth.5.1601390327249;
        Tue, 29 Sep 2020 07:38:47 -0700 (PDT)
Received: from builder.lan (99-135-181-32.lightspeed.austtx.sbcglobal.net. [99.135.181.32])
        by smtp.gmail.com with ESMTPSA id w12sm2924405oow.22.2020.09.29.07.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 07:38:46 -0700 (PDT)
Date:   Tue, 29 Sep 2020 09:34:19 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, clew@codeaurora.org,
        manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH 1/2] net: qrtr: Allow forwarded services
Message-ID: <20200929143419.GD71055@builder.lan>
References: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 29 Sep 08:33 CDT 2020, Loic Poulain wrote:

> A remote endpoint (immediate neighbor node) can forward services
> from other non-immediate nodes, in that case ctrl packet node ID
> (offering distant service) can differ from the qrtr source node
> (forwarding the packet).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  net/qrtr/ns.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index d8252fd..d542d8f 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -469,10 +469,6 @@ static int ctrl_cmd_new_server(struct sockaddr_qrtr *from,
>  		port = from->sq_port;
>  	}
>  
> -	/* Don't accept spoofed messages */
> -	if (from->sq_node != node_id)
> -		return -EINVAL;
> -
>  	srv = server_add(service, instance, node_id, port);
>  	if (!srv)
>  		return -EINVAL;
> @@ -511,10 +507,6 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
>  		port = from->sq_port;
>  	}
>  
> -	/* Don't accept spoofed messages */
> -	if (from->sq_node != node_id)
> -		return -EINVAL;
> -
>  	/* Local servers may only unregister themselves */
>  	if (from->sq_node == qrtr_ns.local_node && from->sq_port != port)
>  		return -EINVAL;
> -- 
> 2.7.4
> 
