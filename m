Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B092C8076
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 10:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgK3JAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 04:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbgK3JAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 04:00:13 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DD1C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 00:59:30 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id k10so11052771wmi.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 00:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3hM+phFbSccuPNXURtLkQPcsGT4rPyJ0on20dI+C1Qw=;
        b=rJvWgeMPDJjEKJNRCC8yQz0N0Ut2wK5L+xQwBVUvMytQP/WgEdBTMzV4rvh9KIaYjP
         E2NAJTqgwzKngo5FnKjNOv2x+y1F4WtHr0xEotVzgN2DGYPvprnM0xbdpJQ5PvzbY6R8
         ejRORUmiHFPPrUWZgGXjPpwaS4rICehg3rp+YmaTEB7s4pchLKW91b3TgQK6CRHakjQb
         XT+qkq4ijcGBvUbnNbgOcEHGvybYPYr0wmR1GdFoRWOmqKSTP3yxqRJ+cQ6wB5+PwDy9
         CpfGwHnt8SQYDTyxk74Xsu6o4gjZcZFhUYSdBE1ZwkHZAl9PxnOG3edaGJct/cHpNXUT
         BilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3hM+phFbSccuPNXURtLkQPcsGT4rPyJ0on20dI+C1Qw=;
        b=B4+RZVH2xk3PrywONBIeWjTn/hQ8vSuHK53r+td9zxakI5ZZh83+/Yuv2x5sf0fa/y
         +WCYpNUKrxItlzEcx0IVfgcXBbtWt9065STMDQnbPktDrrAr/X91eedtp7+uCq2YP3Ow
         ga7ctd6nq3tKmnkIjConJHBP7Nm6QWzxC/PDe8e0dQl0V4hvYw9JQyD27wkw1L3uIdVZ
         nLiJtVDC9BcbKtkPfa8uGPyl84j7U9jKYHAPq1cbndA7Cy/jwrE+//MaHbPZcgdkQ8Sf
         kIZvc8KH/pP7hGEgKOXaMolU/cT4CugU20yWHaABczmlyqagNCkSm4oDQb+Suqljb1qH
         8V5Q==
X-Gm-Message-State: AOAM530Go9R0jzVyph0MgVVhf0/c+0snHOTT7UjFV4oKtxqPmexU1vkG
        t9sNBHanyR2lsYiSpKa8bKZuzw==
X-Google-Smtp-Source: ABdhPJw+Kc4lxyw2Sqwg6q/29/xhcLtgRtfpGiTtJszcuqv4nSBWi2fAXTXpo7wCEQsrS26cNR02Xw==
X-Received: by 2002:a1c:f617:: with SMTP id w23mr22239554wmc.52.1606726769505;
        Mon, 30 Nov 2020 00:59:29 -0800 (PST)
Received: from dell ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id f18sm26960482wru.42.2020.11.30.00.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 00:59:28 -0800 (PST)
Date:   Mon, 30 Nov 2020 08:59:27 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Erik Stahlman <erik@vt.edu>,
        Peter Cammaert <pc@denkart.be>,
        Daris A Nevil <dnevil@snmc.com>,
        Russell King <rmk@arm.linux.org.uk>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/8] net: ethernet: smsc: smc91x: Demote non-conformant
 kernel function header
Message-ID: <20201130085927.GB4801@dell>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
 <20201126133853.3213268-2-lee.jones@linaro.org>
 <20201129183309.GH2234159@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201129183309.GH2234159@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Nov 2020, Andrew Lunn wrote:

> On Thu, Nov 26, 2020 at 01:38:46PM +0000, Lee Jones wrote:
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'dev' not described in 'try_toggle_control_gpio'
> >  drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'desc' not described in 'try_toggle_control_gpio'
> >  drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'name' not described in 'try_toggle_control_gpio'
> >  drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'index' not described in 'try_toggle_control_gpio'
> >  drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'value' not described in 'try_toggle_control_gpio'
> >  drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'nsdelay' not described in 'try_toggle_control_gpio'
> > 
> > Cc: Nicolas Pitre <nico@fluxnic.net>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Erik Stahlman <erik@vt.edu>
> > Cc: Peter Cammaert <pc@denkart.be>
> > Cc: Daris A Nevil <dnevil@snmc.com>
> > Cc: Russell King <rmk@arm.linux.org.uk>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/net/ethernet/smsc/smc91x.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
> > index 56c36798cb111..3b90dc065ff2d 100644
> > --- a/drivers/net/ethernet/smsc/smc91x.c
> > +++ b/drivers/net/ethernet/smsc/smc91x.c
> > @@ -2191,7 +2191,7 @@ static const struct of_device_id smc91x_match[] = {
> >  MODULE_DEVICE_TABLE(of, smc91x_match);
> >  
> >  #if defined(CONFIG_GPIOLIB)
> > -/**
> > +/*
> >   * of_try_set_control_gpio - configure a gpio if it exists
> >   * @dev: net device
> >   * @desc: where to store the GPIO descriptor, if it exists
> 
> Hi Lee
> 
> This is the wrong fix. The name of the function in the documentation
> should be corrected. The rest looks correct.

Yes, you're right.  Will fix.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
