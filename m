Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3062A279CBB
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 00:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgIZWAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 18:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIZWAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 18:00:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17610C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 15:00:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i26so3263828ejb.12
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 15:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DAKbY89WBRHdbI/muXDTPMFepO+aT+ytuxJZkONLLrY=;
        b=s+68XHotqOTONd4yAyq7VwsQZiv4t9NRS1dcWvRCxH8z8CvkpH/dha6N1NEMES7Oqs
         wX6SiyT/l9EgeegCxTjyDkZJ7jFun3SyWwdJl0fhLDQDZuV6P6CuMeaq8HDFwrjsWhJy
         TXTZxK81pdtmgUNh85WSt3974OjnHNtqd4Rrs4VrqglWTg6bqg6NwEftAfP03A5OR5DV
         dXsSs521pWsAmxqBP997WCj3K2EYLMcGHElE5sbtDI45OgB3gfov1haomT3klboYw3+o
         pWzbiES9pA3hy77O/Sg6XncJqepLl10vjZBnliBMvhdoELCJXwY8Hf7+5K10D35tFRC+
         im2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DAKbY89WBRHdbI/muXDTPMFepO+aT+ytuxJZkONLLrY=;
        b=enzznmXDAM22vr2FhCwDqgYamrjf5H87PUQsx1luYEXGgUgDZ9iLc2yl4yORVFS4A/
         JGj1vVTg092FjFYdJ3qcnOW0Hk/HaElXO8UylJlP2wvyA5xigT8GR7QqNIHbCiyOS3kx
         zNV5NgJqGb/xb5YSUPrDHo+xW3+4fnDnKIyn6xlyP5zmsCVfj1vxV63C4uRlm+gNSrjL
         5A4j227r50udwGRMH1+45xCgdCzffrCV9tpFCRYLJqtgoa62TWaRJWFvzukJBtaph4wm
         1+70KLkjDuVRayhC8jPK+MIDp3YWwgBv8v9H3MvdNcx1N1nD5xgYs3wjMu2guEYJye+5
         rtWg==
X-Gm-Message-State: AOAM530EcnBFpI9MgYmZiwFxjOcSRbN98JepKfHClQqdMz49E+dfw7Z3
        6qy5C/ezFtDFp60LYlDzSts=
X-Google-Smtp-Source: ABdhPJyWv/OuxhsbXMHoccZgqueTliCTIX2G8EU4BdkXLaxmvXKLYio8Y6A01+wfcSC1kDd76R+qKQ==
X-Received: by 2002:a17:906:4754:: with SMTP id j20mr9131302ejs.293.1601157636610;
        Sat, 26 Sep 2020 15:00:36 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id v2sm4770844ejh.57.2020.09.26.15.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 15:00:36 -0700 (PDT)
Date:   Sun, 27 Sep 2020 01:00:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200926220034.ols6bayu73ae7in6@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926210632.3888886-2-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 11:06:26PM +0200, Andrew Lunn wrote:
> Not all ports of a switch need to be used, particularly in embedded
> systems. Add a port flavour for ports which physically exist in the
> switch, but are not connected to the front panel etc, and so are
> unused.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

You also have an iproute2 patch prepared, right?

$ devlink port
spi/spi0.1/0: type notset flavour <unknown flavour>  <- this should read "unused"
spi/spi0.1/1: type eth netdev swp2 flavour physical port 1
spi/spi0.1/2: type eth netdev swp3 flavour physical port 2
spi/spi0.1/3: type eth netdev swp4 flavour physical port 3
spi/spi0.1/4: type notset flavour cpu port 4
