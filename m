Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E56160A2D
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 06:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgBQF5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 00:57:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52796 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgBQF5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 00:57:41 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so15840462wmc.2
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 21:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZXuMKcZyj/idpOZmGXYQMfUcYkxlliPEMPEeNplqlRo=;
        b=jgvk7ken0jTTqqtTNtyefWsUXW4+4AkbkUxler3NbAYhbYQEw06uZfZ+o0P/Qx74NW
         eWx0lLZOQrFNzNlaVcxoVzNIjFdBWKL3h/bq8/DeM9OmdSrRfFIA/oj/DnSSxWio70Xs
         UUd74XVKYM463TiTXCtv2Y9LCPcLVgoQSgIX4fl+5dXzIWDV8AEFN3MTqzBwvG+83X4I
         bg23iGsdVN32JhgL1jXnAQnMdaRpy/nqE+If/bXn2zyyZ5VqQeizgiJnQLr/M4Bij6bq
         IsNhPgOvH2Moend9O5ivriLrjm6DsxtLkNSHsvAcfSrrtQjx653WJENd4yyKiOBdqx8j
         AMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZXuMKcZyj/idpOZmGXYQMfUcYkxlliPEMPEeNplqlRo=;
        b=R4IKeL6A1rJo77JacC4OnwpXJHEf3Cm9+91tpS4MLrCbdzjIi4oeTcX+zANmmXud0k
         tl7RmOXWEw7CgWxYM6rpOV5os6oQe/+aoR9uuYbgzQ3nlXEyOPKI4KBO1yUqfPKXaccf
         YQJIgnZHsZjZp+AdeNSqOG094BsF9z3GRD12Ft8kcUqQWpR3XDGHnoYzcr0Ssv8NiTO2
         l9O8Nl1tCFVY/X7mPPtIxtqCEVawK/VG8gsMU2xyETkxgs9RefHRyljU3TAcPfz74DR8
         Do1BzkaqcHh6HBa/ElTD2dKbdNj5ya/Uv+UhP3sKGIktNjdBF4Uaa3Ku+DBeqB75xR/u
         CCIw==
X-Gm-Message-State: APjAAAUF7Uo+QzPVUPPbUSB1dStfvik+1iCgiF66WfO3Ytaow/9hfrJn
        LTUpg78Ti7cLRgoYGC83JuUN0w==
X-Google-Smtp-Source: APXvYqy4DcCMx4ZQzKPPXY+K/mHB0y/EkYkOwcFNUZ1+4YuKE84Oq5iaB6C9hx1gKGozChYFngBdJw==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr20128249wmc.65.1581919059979;
        Sun, 16 Feb 2020 21:57:39 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id v22sm18366526wml.11.2020.02.16.21.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 21:57:39 -0800 (PST)
Date:   Mon, 17 Feb 2020 07:57:36 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        lorenzo@kernel.org, thomas.petazzoni@bootlin.com,
        jaswinder.singh@linaro.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, hawk@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: page_pool: API cleanup and comments
Message-ID: <20200217055736.GA15371@apalos.home>
References: <20200216094056.8078-1-ilias.apalodimas@linaro.org>
 <20200216.195300.260413184133485319.davem@davemloft.net>
 <20200216.195957.2300038427552527679.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200216.195957.2300038427552527679.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 07:59:57PM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 16 Feb 2020 19:53:00 -0800 (PST)
> 
> > From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Date: Sun, 16 Feb 2020 11:40:55 +0200
> > 
> >> Functions starting with __ usually indicate those which are exported,
> >> but should not be called directly. Update some of those declared in the
> >> API and make it more readable.
> >> 
> >> page_pool_unmap_page() and page_pool_release_page() were doing
> >> exactly the same thing. Keep the page_pool_release_page() variant
> >> and export it in order to show up on perf logs.
> >> Finally rename __page_pool_put_page() to page_pool_put_page() since we
> >> can now directly call it from drivers and rename the existing
> >> page_pool_put_page() to page_pool_put_full_page() since they do the same
> >> thing but the latter is trying to sync the full DMA area.
> >> 
> >> Also update netsec, mvneta and stmmac drivers which use those functions.
> >> 
> >> Suggested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > 
> > Applied to net-next, thanks.
> 
> Actually this doesn't compile, please respin:

Ooops :(
I was compiling for armv7, stmmac and mvneta are included but netsec isn't. 
Sorry for the noise, i'll send a v2

> 
> drivers/net/ethernet/socionext/netsec.c: In function ‘netsec_uninit_pkt_dring’:
> drivers/net/ethernet/socionext/netsec.c:1201:4: error: too few arguments to function ‘page_pool_put_page’
>     page_pool_put_page(dring->page_pool, page, false);
>     ^~~~~~~~~~~~~~~~~~
> In file included from drivers/net/ethernet/socionext/netsec.c:17:
> ./include/net/page_pool.h:172:6: note: declared here
>  void page_pool_put_page(struct page_pool *pool, struct page *page,
>       ^~~~~~~~~~~~~~~~~~

Thanks
/Ilias
