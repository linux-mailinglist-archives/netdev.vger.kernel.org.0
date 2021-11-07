Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAC9447668
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbhKGWsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236667AbhKGWsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 17:48:37 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B35DC061570;
        Sun,  7 Nov 2021 14:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=M+g1TA0XL6sSz5D2gz4hPz0mw7n6pUz0QEyTQMdYjMc=; b=hSCndqGNvtsZEHw3Vioe+SpxPr
        0oKqbAqW/k9mvgnRx0Us5Jc6H5z0ACSSGj1sbAaxICG24buZfjc3zD2Q+FUQHM1sXSvoDkPwJNocp
        jNAGWmOzargYdaL46y4ZHG/mS2swvTZnavD10W8GzZvuGGl3lduZ47brPqupk+qQ7GTW6JN0+/+mu
        aFQFcCKm+vsjB8wV/RYxbvDhEkjY1qVMrI7HdgbdeQD4P1scGZ89wekzQ1ARs5GJTK9kQg4FZZJxV
        euWKkXN6apN1WZ7Vs97CxSHjzsA0tYlQY1xvTq3yhgUehsH8DhWIeuLmC03CbQWFko3hdI5l2FYxI
        HtEM/HEA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mjqvA-008etL-EH; Sun, 07 Nov 2021 22:45:52 +0000
Subject: Re: [RFC PATCH 3/6] leds: add function to configure offload leds
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-4-ansuelsmth@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <01b92118-8447-56d5-92a0-5fbf4a9aec85@infradead.org>
Date:   Sun, 7 Nov 2021 14:45:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211107175718.9151-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/21 9:57 AM, Ansuel Smith wrote:
> diff --git a/Documentation/leds/leds-class.rst b/Documentation/leds/leds-class.rst
> index ab50b58d6a21..af84cce09068 100644
> --- a/Documentation/leds/leds-class.rst
> +++ b/Documentation/leds/leds-class.rst
> @@ -191,6 +191,18 @@ If the second argument (enable) to the trigger_offload() method is false, any
>   active HW offloading must be deactivated. In this case errors are not permitted
>   in the trigger_offload() method.
>   
> +The offload trigger will use the function configure_offload() provided by the driver
> +that will configure the offloaded mode for the LED.
> +This function pass as the first argument (offload_flags) a u32 flag, it's in the LED

                  passes                                           flag. It's

> +driver interest how to elaborate this flags and to declare support for a particular

                                          flag
although that sentence is not very clear.

> +offload trigger.
> +The second argument (cmd) of the configure_offload() method can be used to do various
> +operation for the specific trigger. We currently support ENABLE, DISABLE and READ to

    operations

> +enable, disable and read the state of the offload trigger for the LED driver.
> +If the driver return -ENOTSUPP on configure_offload, the trigger activation will

                  returns

> +fail as the driver doesn't support that specific offload trigger or don't know

                                                                        doesn't know

> +how to handle the provided flags.


-- 
~Randy
