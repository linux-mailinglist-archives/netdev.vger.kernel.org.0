Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941502AD704
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbgKJNBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJNBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 08:01:03 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BECFC0613CF;
        Tue, 10 Nov 2020 05:01:03 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id za3so17434081ejb.5;
        Tue, 10 Nov 2020 05:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ajXHEgvKvDLhZr+b4VkRkVOqNVKibmZLuO4V85gORMw=;
        b=kXA6kehqPww0MB2lYZtcpgiIwP3b0g4jikNRniY0P0rw2ecDAED88fnQXgZ8GfHzbU
         lUc89Kly7QcdAG+K6G1CI/nH19H01T2JIvFpZSjp6jKok+EWdAGWvRrDoBSZJI5Cja9e
         b2CYFxs1HdNUjkATKsv4l7t3CYEA6wYTncXMZTDm5HcoMo4hRTlolWgU5AXl6WkvqiKT
         62WNQJ4gMjecIOZIbkj6I3w+7IlXhaakCnohXn3/yFScgaoqmnWi3IOMxXH71hUOEQMd
         mKMGR91GfCimXXqe94IozBq5eA6B6m/ddHbvq1oyo6GcGbzfshQUXdFe+Vo0SjsOUvJq
         f3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ajXHEgvKvDLhZr+b4VkRkVOqNVKibmZLuO4V85gORMw=;
        b=cRN1w2lugcB/xmRuC4bZXy2TsP1sybMSBNa9tJ4niGYreEkjZ3aoIOILQW4n6UqRx4
         9gjgsTkJ1OXPffMkjJ6LIorJXik4qr/rlMF+/Tc9xiTSvkYKMmmi2cKX9rwfQawSkP+S
         hV2/spKcwYyxZtHbBTKPGBwwD8cqrCQJKxDKMazXMev9flrvYlzAv+J8yCUr8XbJT730
         WFXV5eI3Vr1NOLWGGG6LMex6O/D95rreIKgtOhgo58lhn4ZtbGG18HkkqUFWEPvahhGL
         urFXtR0u3rh7wy5jeWI+nB4rc29xi2FnBPAWA7h2bB+HpC21zVgyFjjzl4fwNi9kqJBl
         7EZw==
X-Gm-Message-State: AOAM533c1DT3c21Zg6UdXCdqpHX9zJSfU1ivg+YZCcQRzJ8Rgexc59B7
        MMV/fjQBbID0YP724AtPdno=
X-Google-Smtp-Source: ABdhPJxQQn2PrOvIuPkm7EHEokhMCQ3D7ALZ36Db7q8dfPwEoE2BUcI2ifm7I0RUlxJF15wx406tPQ==
X-Received: by 2002:a17:907:9e3:: with SMTP id ce3mr20231763ejc.4.1605013262202;
        Tue, 10 Nov 2020 05:01:02 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id lz27sm10782312ejb.39.2020.11.10.05.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 05:01:00 -0800 (PST)
Date:   Tue, 10 Nov 2020 15:00:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] MAINTAINERS: Add entry for Hirschmann Hellcreek
 Switch Driver
Message-ID: <20201110130059.emgojxcyu5j3lc73@skbuf>
References: <20201110071829.7467-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110071829.7467-1-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 08:18:29AM +0100, Kurt Kanzenbach wrote:
> Add myself to cover the Hirschmann Hellcreek TSN Ethernet Switch Driver.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2a0fde12b650..7fe936fc7e76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7897,6 +7897,15 @@ F:	include/linux/hippidevice.h
>  F:	include/uapi/linux/if_hippi.h
>  F:	net/802/hippi.c
>  
> +HIRSCHMANN HELLCREEK ETHERNET SWITCH DRIVER
> +M:	Kurt Kanzenbach <kurt@linutronix.de>
> +L:	netdev@vger.kernel.org
> +S:	Maintained

Just want to make sure you're aware of the difference:

	   Supported:	Someone is actually paid to look after this.
	   Maintained:	Someone actually looks after it.

> +F:	Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> +F:	drivers/net/dsa/hirschmann/*
> +F:	include/linux/platform_data/hirschmann-hellcreek.h
> +F:	net/dsa/tag_hellcreek.c
> +
>  HISILICON DMA DRIVER
>  M:	Zhou Wang <wangzhou1@hisilicon.com>
>  L:	dmaengine@vger.kernel.org
> -- 
> 2.20.1
> 
