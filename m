Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C7C222EB7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGPXJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgGPXJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:19 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F85C08C5DD;
        Thu, 16 Jul 2020 15:19:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so8778351wrl.8;
        Thu, 16 Jul 2020 15:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H5QoX0EnQtJ7nKvUo3g53hwz6ZnHeI+UuONUkGNSIOg=;
        b=pzWBph9RVupA8tGWneYRS9IeaLJh04bMZnsi+xitFm22eyJx78DiPYE4JnWKVmlfln
         SHSHJy0RkoRquZDZuHr/e/PEgFL/3EoQwdSv+cgF7cuo2YcpBVRS68EiR/QazpvR5QnX
         rA878Lo8v4MuZEupYGkzYTDpGjLOGwugksfpbRcZ4Kb5cRNNUlj7YTilUIU4OlTeiyHf
         OSG4RpYBYXs9yqCXaRidWdkU4sG7ZOqUtD35k+mUO4NAOgTZSeXLUJD+E6ONWYBaVuyU
         NOp1TMvf/tiNS85lz3cEmeT1W0vO6+UnAh+B1KZ7qO046bV62mB0t+QdBbuI+shekPr9
         RqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H5QoX0EnQtJ7nKvUo3g53hwz6ZnHeI+UuONUkGNSIOg=;
        b=BbplC3geyzTgNms0Z/TvuBebbtbTtrV7vVUMk7CAv3yyLj0kYJZim2b/s4ZogBX1ox
         mukXyySLWE5PgAxhKG6dtrMTusNuDK57GgqLnupkWbBXbPpzAC+tyIC6N9mzor7UVThq
         5IB1h3GkUI0Ncv2sqQiWIqVHQNpEYo91Q8jG2ZlY0n8qX0msrmlOuzIdBYPNawucoxme
         7Av1porplSKHWL0iGHJJvVnhbRUJGpp7aweMkTo9QNsb0BlaJGM+MeAXz6a4qj4DjX+m
         dG2QGJbBpkeqOo6ebIQ7rJRphWmf53oBbyj9iWdzlGmNy6gnZmXWsE12NxiQz0L68hV0
         zArw==
X-Gm-Message-State: AOAM532cG7YzzBK/0Rjf+lZtzLIsZBMYQFxNdff2b1qs/J8lmi11FdMA
        oPTSS2qWxBxXexgCh4LJUlGR/n4G
X-Google-Smtp-Source: ABdhPJzk6a7MmutVrxKKsxmTRCi8FyROM04Oh+yTPj75zNfkwUQOxrwiMg5l5Wv3amORXEUjGV1Lfw==
X-Received: by 2002:a5d:54c9:: with SMTP id x9mr7437293wrv.247.1594937979124;
        Thu, 16 Jul 2020 15:19:39 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d10sm10822130wrx.66.2020.07.16.15.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 15:19:38 -0700 (PDT)
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <21d25c2f-8a8b-81db-b665-916676a0df65@gmail.com>
Date:   Thu, 16 Jul 2020 15:19:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2020 1:50 PM, Matthew Hagan wrote:
> Add names and decriptions of additional PORT0_PAD_CTRL properties.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index ccbc6d89325d..3d34c4f2e891 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -13,6 +13,14 @@ Optional properties:
>  
>  - reset-gpios: GPIO to be used to reset the whole device
>  
> +Optional MAC configuration properties:
> +
> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
> +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
> +				falling edge.
> +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
> +				falling edge.

Are not these two mutually exclusive, that is the presence of one
implies the absence of the other?
-- 
Florian
