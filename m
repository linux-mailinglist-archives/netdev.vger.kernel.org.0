Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9641CC5B2
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgEJAKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726356AbgEJAKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:10:06 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A84C061A0C;
        Sat,  9 May 2020 17:10:05 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f15so2319658plr.3;
        Sat, 09 May 2020 17:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IWHKhYQFFhVmAZdVEU3sdVLO9m2nC9E3mlrDhLHlqis=;
        b=D5CBUnEh+bRiWY/vqnwtVKpq9Urnov0iFESmWTqaczl16jrXAXQw7kmPYh2pWJhhZ3
         6HkYqtUDcdGc3mlvYEfgKfX64/PglVxJVdKSHzYRqNjvp+M7SGb0wveaoIlFB4ScHeJn
         t3C2MpDL9lYPYcqJdfK+jqAGULdkZkEZjhNaM/XoB3pHZKb6TH/EFXjlfcxuwGiFG7jy
         0b3IS1M4s7vUZpxMthG7NxWBPJVI0r9pCslec6WLa68boAw8fJYTpsRSY7fBFzJduae+
         t4xFd8WC6h386KnkO9tDYb29KDPuQ7tbW87Xjm6EwJ4nkdcqFNWPOeG0BFMRy22ulYmh
         QUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IWHKhYQFFhVmAZdVEU3sdVLO9m2nC9E3mlrDhLHlqis=;
        b=CFFf4ERFPOeFdpTre7c9HGmqXogFj1qFNAgb1scmDIeYmKm/oQW1gMyU3hPdldAPL4
         K6EDuf6xf/X1YlyQp37AgfOBFKSeIK5eIceM3KGzMj2tdKPF0wFS7ztrfhj1NlvRSa5i
         bdEWvKtDktj74BC/DVBSv+KA63T9YkqqDpLSmkQZlSt4h4TAiKg98j32jMMvIz2GwO+e
         P+zudb8/qURrN1j+AgF8GSH41TSqvjcyZRWdV/nm8cvuQwgsb0YEFImc0eC8sUVCkz9P
         /4jofyfpahAQ5LnOh+8Vh9/I53Grg9QY0IsR+nCe1dRZ2dtCXml3wS7Ida/S+4j6oc0I
         ngdw==
X-Gm-Message-State: AGi0Pua4NLJIxerS4p3HMk2X9eAbIl3aP7QQv1mDBXbskIVQrqyJxbg3
        pfEUOCr0DysYsSAIjEsZGnJPBQJp
X-Google-Smtp-Source: APiQypJBUsj6tQWvSALt3UCSpQdMpN3teunVgIuZvwgUCzR+bJ4G0HP861FM2ilWCahiq4aTImnSnA==
X-Received: by 2002:a17:90a:648d:: with SMTP id h13mr13656731pjj.12.1589069405125;
        Sat, 09 May 2020 17:10:05 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q62sm5926926pjh.57.2020.05.09.17.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 17:10:04 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: phy: broadcom: add cable test support
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-4-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5e8c2d6e-44be-3500-4d46-e94cdfcd98b5@gmail.com>
Date:   Sat, 9 May 2020 17:09:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509223714.30855-4-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2020 3:37 PM, Michael Walle wrote:
> Most modern broadcom PHYs support ECD (enhanced cable diagnostics). Add
> support for it in the bcm-phy-lib so they can easily be used in the PHY
> driver.
> 
> There are two access methods for ECD: legacy by expansion registers and
> via the new RDB registers which are exclusive. Provide functions in two
> variants where the PHY driver can from. To keep things simple for now,
> we just switch the register access to expansion registers in the RDB
> variant for now. On the flipside, we have to keep a bus lock to prevent
> any other non-legacy access on the PHY.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for dealing with the legacy expansion vs. RDB access method, this
looks really nice, now I just need to test it on a variety of devices :)
-- 
Florian
