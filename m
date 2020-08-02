Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9562D235A58
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHBURA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgHBURA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:17:00 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36060C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:17:00 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id q17so19688634pls.9
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ARXy7mwsfF33W4mRC3mJZSZ5rj1eOMP3Ix5VMGL+ps4=;
        b=HmVXMbTocWvqfV7Yi0fmUQJq7kSonRWTGCIEirAxRDqNLH9PU7Wzr8Zig7QzGh8Qta
         22shRhe5XF43NXu3kEwujxd6h5Eq7pccEALz8OA791JRV7W8PDYc3zMv63hUlG5ozEF+
         Ob4A2DOJ1ncZpgoQVDb+P4qRd5JN08JLeRaaONRr7GFhfa7xoKk5nhaK4pZ13A+udsDV
         hOk+AoX4RKuj07SW13mdrxv4OGDOEbXjZrSyOqx7F7uZ14RqGlrnYe6BEvY9niIFzEnc
         ULvYHWN9qem1o9YiWjWgoY9kP1YbiHMuwfZl0AK8kLKqCKHwjJIxt4QPZEpASt+2jV3z
         OmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARXy7mwsfF33W4mRC3mJZSZ5rj1eOMP3Ix5VMGL+ps4=;
        b=OibS1DdI/cs9CNDx4lxIHTO3qvxXWjc6Eozl8Y5Fp7iGVxldnPBV9gkKrEuYouF19w
         cH6LWmH7yiH6ALtV+4XdRbE4MS0+uq03mm01ulBIOuN+Fd3ysYyRQBrLYpgMoOgSnp3h
         MpcBuX2idWlHzN8Lh0Xmlwd1UhuSt7fyNNL/YHTGkJ3x9tuYSFtgzc+GQi82vQX3ZnJZ
         MVnm9DgF3MPgYwB1Mb8VBmjBOP6oLePDIhpvyq8En2dpUBIveQaMgcR5Z000gxl6BtV5
         8y//6+1qF7FkZScUtU3bj78bKTE8ZWAbYGadr1EfarVHPm+f9RdrFTHrECGYlqgkOVhN
         PQoQ==
X-Gm-Message-State: AOAM533oFh3MKdD+U/vJruaeum7qhg/vwqSAh0a3cZ7lOrKF/w5U4dzM
        4NJf4qh6S3uJyo8KminDBdhqKdpf
X-Google-Smtp-Source: ABdhPJze2t+iko5h5hyD9uTUgUjXBw8nzDZZ4f5kUhAZeueukPhnicxIsFsu5n32w06ZUnwEG0jmmQ==
X-Received: by 2002:a17:90a:d482:: with SMTP id s2mr13951563pju.140.1596399419728;
        Sun, 02 Aug 2020 13:16:59 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a7sm10303141pfa.19.2020.08.02.13.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:16:58 -0700 (PDT)
Subject: Re: [PATCH v2 1/4 net-next] dt-bindings: net: mdio: add
 reset-post-delay-us property
To:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fabio Estevam <festevam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
 <20200730195749.4922-2-bruno.thomsen@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c69ba3d1-099b-7582-baeb-2b6a7e67e404@gmail.com>
Date:   Sun, 2 Aug 2020 13:16:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730195749.4922-2-bruno.thomsen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 12:57 PM, Bruno Thomsen wrote:
> Add "reset-post-delay-us" parameter to MDIO bus properties,
> so it's possible to add a delay after reset deassert.
> This is optional in case external hardware slows down
> release of the reset signal.
> 
> Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  Documentation/devicetree/bindings/net/mdio.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
> index d6a3bf8550eb..26afb556dfae 100644
> --- a/Documentation/devicetree/bindings/net/mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/mdio.yaml
> @@ -39,6 +39,13 @@ properties:
>        and must therefore be appropriately determined based on all devices
>        requirements (maximum value of all per-device RESET pulse widths).
>  
> +  reset-post-delay-us:
> +    description:
> +      Delay after reset deassert in microseconds. It applies to all MDIO
> +      devices and it's determined by how fast all devices are ready for

Uber nit: it is should be spelled out, but that does not warrant a resend.
-- 
Florian
