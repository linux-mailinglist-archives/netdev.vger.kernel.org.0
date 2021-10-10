Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BFF42816A
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhJJM5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhJJM5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:57:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6F8C061570;
        Sun, 10 Oct 2021 05:55:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id a25so40171064edx.8;
        Sun, 10 Oct 2021 05:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uxf6d2g9ffV+zwe6N7TVe+9fOiv/YRNPfGxPEDH5JAw=;
        b=CmRFSQ3ceribCREYPrJtIO/38NeV5PbWTtvEeAb6oUAX6KFxJQ8gZibTkMfHkXUauA
         8ZCW10ti7de2lcgk6CQj46GtITS6we+wT7Kxk7gbNxGoonhIVAxGZdja0kJj7863E72A
         DIaZf9W86tUDAL2clsXo7eJND+ZBQ2ZklV8YRPPN2WACO8dOtY17P5AxZlbNHp5x5lNH
         AYBzXX/Nh6ftUBRKhtjhPhOrdk16lmU4BHQLEE0OP1nr7k9zFvYlFhwh08e+qf9AVDpo
         DxdKducZ5FanwvmTVYIVA1RsT5HgweF1PY5Grsv4Na2gjVQ9Zcn+twcQ088KZvsSCHdT
         9+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uxf6d2g9ffV+zwe6N7TVe+9fOiv/YRNPfGxPEDH5JAw=;
        b=ohMNjPEWJXtvaeYbBKRNVqDrIcsWG8Hgwq2SMytDP+0yLOlg0PMZ6AR3VoQK6A5hYb
         xTwcIPHUkuE3gZj+Ldo9B6tYILXABPMeAtbvybZnp/R0NEo3xkCwCbNIKMQodXLYqpHI
         RSP0IHYQtRivlJbastGbYbBNGecZiMv6arUVtdVWwqN/vftMqzO9jngDOZKiZYWQvrj9
         GuJAt1uMVZcwGucczqfMW76cuELjVrQq7JfqIdzWzNsWL4DIOJ7gLXOKrYZTbO8Xjpbz
         1kyLH0ndg64S5iyywe6KuyUnDe5J7CeUjtVYoGF1mdtEeGlzm/8MoflhBv6w6LoO0juf
         56Aw==
X-Gm-Message-State: AOAM532X/UrGTVwY23nK8BNyA6N+NFVDPhWUAHrnIa2coriHApJEBuP4
        G5E9hWkRbRGDEuUl6cwpygQ=
X-Google-Smtp-Source: ABdhPJyT8k9tf4EVic9k6/FRm8QazOpZmsxcJQ/6LKzJ1mtKmUFh+JZ/goAkhgVU/R3qUBLq4tRxRQ==
X-Received: by 2002:a50:cd02:: with SMTP id z2mr32351652edi.241.1633870501195;
        Sun, 10 Oct 2021 05:55:01 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id z19sm589819ejw.44.2021.10.10.05.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:55:00 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:54:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v4 10/13] dt-bindings: net: dsa: qca8k: document
 open drain binding
Message-ID: <20211010125459.evdv4khxcxk5ewiz@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010111556.30447-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 01:15:53PM +0200, Ansuel Smith wrote:
> Document new binding qca,power_on_sel used to enable Power-on-strapping
> select reg and qca,led_open_drain to set led to open drain mode.

Please spend 5 minutes to proof-read your emails before sending. You
will find tons of spelling mistakes and inconsistencies.

The commit message refers to qca,led_open_drain and qca,power_on_sel
which are not the names added to the documentation.

> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 05a8ddfb5483..71cd45818430 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -13,6 +13,17 @@ Required properties:
>  Optional properties:
>  
>  - reset-gpios: GPIO to be used to reset the whole device
> +- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
> +                           drain or eeprom presence. This is needed for broken
> +                           device that have wrong configuration or when the oem

_devices_ that _have_

> +                           decided to not use pin strapping and fallback to sw
> +                           regs.
> +- qca,led-open-drain: Set leds to open-drain mode. This require the

This _requires_

> +                      qca,ignore-power-on-sel to be set or the driver will fail
> +                      to probe. This is needed if the oem doesn't use pin

oem _prefers_

> +                      strapping to set this mode and prefer to set it using sw
> +                      regs. The pin strapping related to led open drain mode is
> +                      the pin B68 for QCA832x and B49 for QCA833x
>  
>  Subnodes:
>  
> -- 
> 2.32.0
> 
