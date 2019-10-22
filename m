Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DC4DFA13
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfJVBVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:21:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34710 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 21:21:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id k20so8907637pgi.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 18:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vvcQr5h1U3NASoYXSRC3luhXZiqOg4DPFee5U8H8DO8=;
        b=j4jZG9VDxVogBVaQ5qtMUstGofZfdVNlVxXNWNwt8ycwkHY925aAn/brJgEYvaA5mt
         kbiBgvZ3ODaYZbGly1HtCjhdwTVJ2nDGrkgN+Pbfj9G+3m7EfioheWCVje7JGMn5GSnX
         uUh11sfoKQh2sS0BAqC96d/y5uR1eY8uKhb7hTXc+MVLuwh8i3bZwFdvZWvVAXNIhEC6
         aqv/9kBj8/2DMkKIiqUD/7dyhCYvykSoBjnBC3HJrsvtmPixJ39fXOc7m3VVJZcOxLni
         scT89CvuAapVfgVsgyYopt358qxXc3QmicO3uOLns6qhGhuktK54noO2FlRxnulSI29y
         bEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vvcQr5h1U3NASoYXSRC3luhXZiqOg4DPFee5U8H8DO8=;
        b=mNBM53pxTXS6pFOI7fwLQpXwN65iMmXoxxfWdbU6fmuAq3R3RS7JXBDiPeDtOM2xZQ
         22AEaCHRrdBtFfyksFlPoXVRo0aL/oVX1JJTnPNx2AXmc3RTMs4YVP0va6y50wSn8sTd
         /ZWt6gZaGXq0wRicTHNepq3QkIEcmmyC6lQDG2Gdb7zhqwkLMgkaiFAyGmIsJ7R2smRZ
         NZBwYqqX0s5OatWspSJtly3BFX+Z5oeaaddj8E1Cytitg3WcXBGW6fvsa97Eg4OazGGz
         j3sP0AbOKrkk/4qX2jgc/1S4xlYBjdLHZDqjvOZbm1WMQnzaruVxuaGSJzQx9suTGJWR
         sgdg==
X-Gm-Message-State: APjAAAXsCVA/QfcC6ZeJr8I2ysKZ6MlXlsL0Xd81uvLe8uUFM+SFUghy
        x/JoPHHmYEWHkMMGNB3Rq6AIzTTG4FM=
X-Google-Smtp-Source: APXvYqzmlzK+X4+RhbVanSbArpETdZqFOjVk0sNdfYbhrYe6aRe/QZDNe4KldZfaSGmaqVjiHE7S4g==
X-Received: by 2002:aa7:92c9:: with SMTP id k9mr1121537pfa.215.1571707265731;
        Mon, 21 Oct 2019 18:21:05 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id w2sm8294943pgm.18.2019.10.21.18.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 18:21:05 -0700 (PDT)
Date:   Mon, 21 Oct 2019 18:21:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 07/10] net: ehernet: ixp4xx: Use devm_alloc_etherdev()
Message-ID: <20191021182103.48962e29@cakuba.netronome.com>
In-Reply-To: <20191021000824.531-8-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
        <20191021000824.531-8-linus.walleij@linaro.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 02:08:21 +0200, Linus Walleij wrote:
> Using the devm_alloc_etherdev() function simplifies the error
> path. I also patch the message to use dev_info().
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/net/ethernet/xscale/ixp4xx_eth.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> index fbe328693de5..df18d8ebb170 100644
> --- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
> +++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> @@ -1378,7 +1378,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  
>  	plat = dev_get_platdata(dev);
>  
> -	if (!(ndev = alloc_etherdev(sizeof(struct port))))
> +	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
>  		return -ENOMEM;
>  
>  	SET_NETDEV_DEV(ndev, dev);

Okay, I see you do devm_ here.. please reorder the patches, then.
