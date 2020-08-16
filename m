Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEE624598C
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 22:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgHPU6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 16:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgHPU6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 16:58:44 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42163C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:58:44 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 189so6470553pgg.13
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gHG25huDYf1EGk4edQYA4uns9+ZJ3YJL45iXTcDkVEI=;
        b=gcAyeE1lLg9kRXo7zrOUf6A9MVg54xbD3zKxcntuOWZBWs12sQln4Ot9iegug+nv3j
         WgsnplnlRAwSjmApbQ9MiXmhDongeQ72beNy0RPFHM0h/uVGfP0MXq/lcJnLISi+BY9D
         b2MliPsdftNS6msabKkRp301j2YBOAmiEdfTjk7EszCDtdZQ4ABmPylwq6Yl0crF1XDA
         Jdbsfg56W3GWOLiJwoJ+Pm7OHYxgXQkW/LmIE5D58nJ2cRn90JjZ1V0gUEm2uPdeWdnH
         0X5IRah4TvqU40hCemb/1NU0UIKVIWe91wRtEuZXKB94vnP5oEJ3yhkbu59aUZNqZbBd
         QwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gHG25huDYf1EGk4edQYA4uns9+ZJ3YJL45iXTcDkVEI=;
        b=Ufi+vE0r0G//J1Kn0nXGryRlSam3Mls8tXkBAtBBF/9nut2yp4aS/YXqpXa8gsA+Wp
         bCgq85B91KO/9OA2v/sBpf5iIMn0LBoayvz0W8GWvkbbKneC/WXuyLw60Ss2TlsSHcg4
         tHNMeL9U0B2k5lci+4COaY7mnhsauwz7Xlisxau1mDJONoPRzl9SQtnWczglJVPWhA2l
         LN5urfSnPzKv9hLFVvIuW0MKCMHbDeQkPs3p/O/IL5zt53li+3lUJ5z5TfZKVNUHgxSA
         stmJ3Q3LaxJn9mPcjPKV+KTbfWyzgS6kvFK57NQIeus85ymb8UdmcxGHH9yemI0pVlWD
         Huaw==
X-Gm-Message-State: AOAM533+ZrFNCZw3WWSDZ6IESYpAFXt0G5jDJIuv1yGlrAq0/DKLatMZ
        Mpm5+R02C7CyV48TkgvNj6E=
X-Google-Smtp-Source: ABdhPJxgFZ9iO4tNirftyRM+cs2TEEruXhivqfFmcVwk27irCgfWOlLqdso1t8hxZq+iwziruzJShQ==
X-Received: by 2002:a63:5213:: with SMTP id g19mr7680379pgb.44.1597611522363;
        Sun, 16 Aug 2020 13:58:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z26sm15090396pgc.44.2020.08.16.13.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 13:58:41 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/5] net: pcs: Move XPCS into new PCS
 subdirectory
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <20200816185611.2290056-1-andrew@lunn.ch>
 <20200816185611.2290056-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6607927b-c6c2-5904-b6d9-cf6322880f2b@gmail.com>
Date:   Sun, 16 Aug 2020 13:58:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200816185611.2290056-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2020 11:56 AM, Andrew Lunn wrote:
> Create drivers/net/pcs and move the Synopsys DesignWare XPCS into the
> new directory.
> 
> Start a naming convention of all PCS files use the prefix pcs-, and
> rename the XPCS files to fit.
> 
> Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   MAINTAINERS                                   |  5 +++--
>   drivers/net/Kconfig                           |  2 ++
>   drivers/net/Makefile                          |  1 +
>   drivers/net/ethernet/stmicro/stmmac/Kconfig   |  2 +-
>   drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +-
>   drivers/net/pcs/Kconfig                       | 20 +++++++++++++++++++
>   drivers/net/pcs/Makefile                      |  4 ++++
>   .../net/{phy/mdio-xpcs.c => pcs/pcs-xpcs.c}   |  2 +-
>   drivers/net/phy/Kconfig                       |  6 ------
>   drivers/net/phy/Makefile                      |  1 -
>   include/linux/{mdio-xpcs.h => pcs-xpcs.h}     |  8 ++++----

Why not reflect that directory into the include folder as well and 
create include/linux/pcs/pcs-xpcs.h?
-- 
Florian
