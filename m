Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55502FC5C1
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbhATA1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 19:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730895AbhATA0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 19:26:49 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD34C061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 16:26:09 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n25so14070756pgb.0
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 16:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z9mD76EmB7EJfuD1K2yKQ8IH77bGMGo7WI4f7IS4cuk=;
        b=HsJb9Ooacj77a2bK1tF4aTDWN4V08o3/lXTyzI7SSf7gs7tsVpezcwkvj4CKGZkqeW
         DGRwsVowbONAQQ8a925y18A1O1qpoHiB6lTD5k9y4//ZUaomWmQTaUHeZLm+M1tFeGMK
         JZjsOln8Z2vn16mUSTjEa1C6CYsw+jd5aS/RQnrOcFtyuf4PdDijgBQuZnY4Gzx4YpYj
         xDALaCiUWQ5DbEZzLcgrc0POOCkMN5iRL3F6g61qPxB08CpFriiGQUhDrJhw3b+1Dgh5
         +QjOUeYfVfIij+ynU5izEGtygaSFd/lRBJSPCXglQ/Dij+gJ6g6YaefC2gYLCgTKTJ0C
         eGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z9mD76EmB7EJfuD1K2yKQ8IH77bGMGo7WI4f7IS4cuk=;
        b=UuKBrKLrLyTd3iR3nVBfhbAaP0HtBKjyj3JkPN2Cnq7UW5WQ4m15dW0lCW95ay1qLp
         Kdm4ST/DLiYpM02O71AhkldWPNi2xibYqmvrT1v+I31NynHxbD6+j3PVlXb+fXCs6JwS
         P0HK8VnCrSwK9Puxon7ha7TYkS0kWosU2xVuK07LdQtpg8F6N2Z1tgFrjzDtSgkIEFDM
         0H7R6OwbQmhrGiUp+Csgr2oXbDTQsIP5ImjqAZOLVUQ3IfrzqE9TWZkBY2+13AYKXukP
         CdjiEF5rNe0+kvQ9dG+huNf0B1kTeQqQ6yNGOEM3JEaX56WrGXZ/oehZggZ2K9BBpRwM
         qt8w==
X-Gm-Message-State: AOAM532KWw2JeFmiRrmKmyPIUEk/id5Jv0p9aq8To5eN5iVWX0Fg+IVY
        +lY/cJKrAo7MwjNxOR6gwG8=
X-Google-Smtp-Source: ABdhPJxmgLmI7WndjE/PlUn+cRnC510cfnCVWgnIXumMn32cfujn0kVJ7l53Epzep2wOoYxBmuQ0Hw==
X-Received: by 2002:a63:44d:: with SMTP id 74mr6755478pge.170.1611102368576;
        Tue, 19 Jan 2021 16:26:08 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ne6sm117455pjb.44.2021.01.19.16.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 16:26:07 -0800 (PST)
Subject: Re: [PATCH net-next V2] net: dsa: microchip: ksz8795: Fix KSZ8794
 port map again
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210120001045.488506-1-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7fac4fb7-9a58-f73a-b872-720193eb1ddb@gmail.com>
Date:   Tue, 19 Jan 2021 16:26:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210120001045.488506-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 4:10 PM, Marek Vasut wrote:
> The KSZ8795 switch has 4 external ports {0,1,2,3} and 1 CPU port {4}, so
> does the KSZ8765. The KSZ8794 seems to be repackaged KSZ8795 with different
> ID and port 3 not routed out, however the port 3 registers are present in
> the silicon, so the KSZ8794 switch has 3 external ports {0,1,2} and 1 CPU
> port {4}. Currently the driver always uses the last port as CPU port, on
> KSZ8795/KSZ8765 that is port 4 and that is OK, but on KSZ8794 that is port
> 3 and that is not OK, as it must also be port 4.
> 
> This patch adjusts the driver such that it always registers a switch with
> 5 ports total (4 external ports, 1 CPU port), always sets the CPU port to
> switch port 4, and then configures the external port mask according to
> the switch model -- 3 ports for KSZ8794 and 4 for KSZ8795/KSZ8765.
> 
> Fixes: 68a1b676db52 ("net: dsa: microchip: ksz8795: remove superfluous port_cnt assignment")
> Fixes: 4ce2a984abd8 ("net: dsa: microchip: ksz8795: use phy_port_cnt where possible")
> Fixes: 241ed719bc98 ("net: dsa: microchip: ksz8795: use port_cnt instead of TOTOAL_PORT_NUM")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Cc: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
