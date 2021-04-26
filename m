Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5396536B8ED
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhDZSal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbhDZSak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 14:30:40 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE59C061574;
        Mon, 26 Apr 2021 11:29:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c3so20783564pfo.3;
        Mon, 26 Apr 2021 11:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eD0PFZldN2fk6Q8XGEWi1L4KU1I/CUCgFu5Mux/m9AY=;
        b=VWfwSpPI0Eg3yBf8nMrXOpIgEveyi3+bdG1XSSWQoc1clt0TzePLazZUmTzjB1Fx9v
         uJwt8PIvAT77FGn8oASdUQXNcr2uX7SS1lUeit9usmZXAkj4aWNMjzDnfziNQrTgpAu0
         YPbug12YsrR5rXXlIOILl7tPuF4FgJCsR9RDeOB8hbVv7ztZXQhgToAOYy+N1xK3xIqv
         SjHTQjkgvqzYI91t3qxmhgf8b6emdxI5tV/jasBPiO+mZHAch64rBnZF3qA+HZJQ5Udl
         2YGlPccWLn/ZKTDrnYmErOnrduM3w+Tq3QPyCbwsgfoYyRKnGF/iCC+iYoxV7248nxC+
         clTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eD0PFZldN2fk6Q8XGEWi1L4KU1I/CUCgFu5Mux/m9AY=;
        b=r77NtQaeT5txbi7jjDGUbnF4AOWsjenEfj2PAoR31ON2x4IEAc99rBhBCDdFWfscCL
         C7etrxFgEvNweqv6YEvawP1OPVshecvjeFs7z9nwdvbKoi3SuHL11LqNASFjzLPEMYDY
         yIFDPx96ZUJnJxuMd0fUNrQ56hBbalpHRTOnNhX3MZTkpCnLk9t0tN+u8IrJywcY4l/O
         SP6lN1buMbmqRs5uX2OzDsB70hBMcAsOly118sF0Gn632Iaqu9XwfnwU9wKEWQJBHwmi
         LtWoLOxXG4aAOhS95MKZo615iHbqRKYGLV4Rt8lVTP8Hl0X9SYpRt/KgFdUUSLHoJMcy
         GlXQ==
X-Gm-Message-State: AOAM531Ze6y0OcuTuOcNFGpuiuXRaAfh3n2vm9lSFMtdS50YA3qTv+5o
        fXyr/0ql6+54GRCSDgkUf6EK82b1nUw=
X-Google-Smtp-Source: ABdhPJymy1MJSwKN3kn4xglt4jWRCrGTZ8d4yEyXZJy2NgNYe5m5osPGcMIMUn5Ix3G9vOgNYtVBQQ==
X-Received: by 2002:a05:6a00:134e:b029:277:1974:3c98 with SMTP id k14-20020a056a00134eb029027719743c98mr5754187pfu.62.1619461797706;
        Mon, 26 Apr 2021 11:29:57 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f18sm358070pfe.49.2021.04.26.11.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 11:29:57 -0700 (PDT)
Subject: Re: [PATCH net-next v7 1/9] net: dsa: microchip: ksz8795: change
 drivers prefix to be generic
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20210426131911.25976-1-o.rempel@pengutronix.de>
 <20210426131911.25976-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a1e3e091-ea64-ee2b-3eee-229ce16fe70e@gmail.com>
Date:   Mon, 26 Apr 2021 11:29:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426131911.25976-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/21 6:19 AM, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> The driver can be used on other chips of this type. To reflect
> this we rename the drivers prefix from ksz8795 to ksz8.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
