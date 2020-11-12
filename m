Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E1E2B027E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgKLKHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgKLKHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:07:02 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21201C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:07:02 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 10so4734270wml.2
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=k9u191cQeVv+ft9APDoYYYhAD7rGueoJWNM2HK61hgw=;
        b=gnrp3LxY8VpTkONnz6433SUvkSpmNdVVSo6E7PG3TVuJzuLhR73fQ/fMMeFfWFLnwv
         CqUp1CfV4pmV5fTmxV3FSd2hzArjGVss8sOlWsKmeXgzO+typqxEZWPOy1Knn9NeAfKN
         gWstCElHGNFcRqWxKQZKDbDUz5xTFQoCjvcoI2MYa7jAc0HasXaVToCyoAra8xkATkHx
         Tq8hcod/Hs3tl5bWne2AMw+L/B5f7JbEtiM9DAjz0CsevEiBlfwakrzVjccD3dvyjaQZ
         3KHQhIaffpV9/Ms4ND958L8skETTNXlo7VFeACzu5O08d+vgr89oMqqx2tkY1W1LSP2B
         Fkzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=k9u191cQeVv+ft9APDoYYYhAD7rGueoJWNM2HK61hgw=;
        b=TR2ojQFwbmGuGsajp7VoKbMtePRCyfmgo35iaMM0MD5uhOnsGDGorMzfeI71pdg3Wl
         n1FlQdgivkVC+ilJ7vbhUj0SeMYWfdEYbc6HMDZunw/iTcJeFIWigr+GqFIuQ3fvBghh
         c++UWICqXT+2iozDNeFGBmqNECv9XKZZSwnJETGZaUeLykP6QYzHSPHKCQA5q7nEWnIh
         cqNKDt16sDHOtQyujiDn5B83RM/MhCTNUR5b6N2J2/qvf+Y2aQEoP+JCyN2AN/dkwlF8
         YwQIqDJu3WJGXi6Zv+jlxpCdVn//3JRk4BNL1DM1IpqRNHpzgSDF+vUD9hvN/hHfEC8s
         m/RA==
X-Gm-Message-State: AOAM533PvvGSAQAfzR/IWlZCko1Rs/9QHo/Ot2sx5HLA6I78PaIv6ZSN
        M2Jl9vZMTpgzA9v2NRdszfgsmg==
X-Google-Smtp-Source: ABdhPJym4+8DnC71C5VrC58stI63Ta6LjGq2V60olaEtxEIxwfyS19OvrRJOvyXQ3ERGwaT6tvrnrg==
X-Received: by 2002:a7b:c925:: with SMTP id h5mr8726001wml.5.1605175620878;
        Thu, 12 Nov 2020 02:07:00 -0800 (PST)
Received: from dell ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id b63sm6381293wme.9.2020.11.12.02.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:07:00 -0800 (PST)
Date:   Thu, 12 Nov 2020 10:06:58 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Nicolas Pitre <nico@fluxnic.net>, Jakub Kicinski <kuba@kernel.org>,
        Erik Stahlman <erik@vt.edu>, Peter Cammaert <pc@denkart.be>,
        Daris A Nevil <dnevil@snmc.com>,
        Russell King <rmk@arm.linux.org.uk>, netdev@vger.kernel.org
Subject: Re: [PATCH 30/30] net: ethernet: smsc: smc91x: Mark 'pkt_len' as
 __maybe_unused
Message-ID: <20201112100658.GB1997862@dell>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
 <20201102114512.1062724-31-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102114512.1062724-31-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020, Lee Jones wrote:

> 'pkt_len' is used to interact with a hardware register.  It might not
> be safe to remove it entirely.  Mark it as __maybe_unused instead.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/smsc/smc91x.c: In function ‘smc_tx’:
>  drivers/net/ethernet/smsc/smc91x.c:706:51: warning: variable ‘pkt_len’ set but not used [-Wunused-but-set-variable]
> 
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Erik Stahlman <erik@vt.edu>
> Cc: Peter Cammaert <pc@denkart.be>
> Cc: Daris A Nevil <dnevil@snmc.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/net/ethernet/smsc/smc91x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
> index b5d053292e717..a3f37b1f86491 100644
> --- a/drivers/net/ethernet/smsc/smc91x.c
> +++ b/drivers/net/ethernet/smsc/smc91x.c
> @@ -703,7 +703,7 @@ static void smc_tx(struct net_device *dev)
>  {
>  	struct smc_local *lp = netdev_priv(dev);
>  	void __iomem *ioaddr = lp->base;
> -	unsigned int saved_packet, packet_no, tx_status, pkt_len;
> +	unsigned int saved_packet, packet_no, tx_status, __maybe_unused pkt_len;
>  
>  	DBG(3, dev, "%s\n", __func__);

This one is still lingering.  Looks like it's still relevant.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
