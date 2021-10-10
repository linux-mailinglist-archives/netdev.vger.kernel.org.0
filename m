Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83665428118
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhJJMJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhJJMJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:09:29 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4D2C061570;
        Sun, 10 Oct 2021 05:07:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id p13so56334401edw.0;
        Sun, 10 Oct 2021 05:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VhfnjgnKEFzD7T76QULgdNjNfhYZkfopvKDKy+hHIj8=;
        b=PwDV2RVeeJsVMPKLkgnYHA/QDWvOgpSGIhgu3LBxEzP8UwyUWsFPmPU0OINuH3hiz5
         My60GFseFp2ev/WMAmnrphJEWcfpDOcoVIDiyuTNRbULmTyisqkU1XAAzGwxmt9DZxSB
         cpX+FB0BI4zvH3exkZ8U2cBzV1dVy6376GYQrCiKV17EtFH9S98Qmitivq4nkGKcHBGi
         8FIQtAFZHMnkn/WcpcG+smTcVQ2C7UprKb7pI/NkfG4kJNl4PaAQ5HP7Kwt2rGtUFYiW
         ASZab023RSdlW87FlRuCV6w8ebXLq0RmZm7mn8th+VulbQbe1Pmhj9H3Gm4lMNJclVUp
         8Okw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VhfnjgnKEFzD7T76QULgdNjNfhYZkfopvKDKy+hHIj8=;
        b=0SfARDpksEXeVuNylVi0jGZVOsvjFkfR6Oq7d0L7FQDizOZqgLq8rGgzj/luO4V4Sa
         LKurQLrg5zD31nClqCgzUO7YGDlfnYIByN+jLusnSlgdYQnXojLjQLoqmEB/ziFPmtqZ
         HR11tpsoANKrwnEAWzOQZAMcAlQAYWqSG5sDE0FR5OUS8mjt7z084hqVQIkldaIeeNuN
         3FdPRdL1b0Sz69i1T00mPFJgDi6gaM4wLiqnqlZ/5FPWXtPz9SzzFYDS8vFxm3vhGVOc
         dFVqM3OsAbh5lQ6RZiwRJFiRbwCo+hd+qSRvfCGkIq3tjfY64jn+Ms8bNM3uXEofNM9k
         tjmA==
X-Gm-Message-State: AOAM531eoP1HEHWnWUvIFJuYMuMtb2svWlxNsWKo+rNX28/0oz6xsnOE
        sV3f1nOBZVvNBYtDWlKZDJ8=
X-Google-Smtp-Source: ABdhPJyMFlWrYzoVR2jkGjidMBFU9kEAv7jXfCRxYoudUqyXQwS4TRmbaTHFG96HtnLrOyn2SJ2sOg==
X-Received: by 2002:a05:6402:5215:: with SMTP id s21mr27056481edd.113.1633867650059;
        Sun, 10 Oct 2021 05:07:30 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id q9sm2015467ejf.70.2021.10.10.05.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:07:29 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:07:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v4 03/13] dt-bindings: net: dsa: qca8k: Add MAC
 swap and clock phase properties
Message-ID: <20211010120728.da56if3z7rtzb6hu@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010111556.30447-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 01:15:46PM +0200, Ansuel Smith wrote:
> Add names and descriptions of additional PORT0_PAD_CTRL properties.
> qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
> phase to failling edge.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 8c73f67c43ca..cc214e655442 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -37,6 +37,10 @@ A CPU port node has the following optional node:
>                            managed entity. See
>                            Documentation/devicetree/bindings/net/fixed-link.txt
>                            for details.
> +- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
> +                                Mostly used in qca8327 with CPU port 0 set to
> +                                sgmii.
> +- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
>  
>  For QCA8K the 'fixed-link' sub-node supports only the following properties:
>  
> -- 
> 2.32.0
> 

Must first document, then use.
Also, would you care converting qca8k.txt to qca8k.yaml?
