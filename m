Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F018A1C4B71
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 03:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgEEBSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 21:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726449AbgEEBSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 21:18:44 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84403C061A0F;
        Mon,  4 May 2020 18:18:44 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t12so492396edw.3;
        Mon, 04 May 2020 18:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ESLjKLI3zYKevyA1VvOR4LQx91uhZUxxvAK2raOSXD0=;
        b=icIu7NgqMHtcY7DCmx9AgDtkHSZkehYOeZWh0ch8MNJ2Hiv5PpHPvE0aRkvRH4G3AQ
         AYzSMGB0Ui+v75cb2Kw4847rJLA0WaBjqSNmo14ZINnIkgPBte6Rhc7Y0gAg0ornrIWP
         R+iXo7REy8hnwxJpTm1apYtnE/wUg4UHmYqVNM/Ct0dYlCqNH6bSOOxFSgQq/Fteo4XN
         2PIPZg9c9Ivhq/Iliv43xFnuRGMMxM+fzJ1WY6XALk7H3NlcPwQRR2ZxmBRCtVRmkepP
         2UJAzTupK2XI/56tuA1hMjMq04kcGHb+JpeoPyu9kQxUeP1Q9zMl4dYpiXaBBF54gU+X
         FS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ESLjKLI3zYKevyA1VvOR4LQx91uhZUxxvAK2raOSXD0=;
        b=MXre/x0MMn3hmnueTAP2nExl8tQjtZMzO5i5LdPT68M3mtwg33WMM8sUbNWkD66v38
         W8rhpZmgea+kDHCIWuX99V5Qp6YuT/Ev8JhjsG1V/hJdN9CUcCUGGo/iHSWsSwgtJ+TX
         5J/2mWK+wRNnertlyI+cNrtD3hszlx4JCubm6ANza/xZvuPsSO/uaJjdskW8p9c3eGGY
         toBSZJGhzFmyTyZdQofeo42zXj6EHga5uqEu/w5OSRoQTkKdI36eZ/2GZ1WROQF+QbRu
         HnPCGqhmNnD3EB9N2pSMMSMs1ITY8qtKj0TuR3cwE0f6P4J2QN5NorgvwHNiJckdYBnm
         6vTw==
X-Gm-Message-State: AGi0PuYtoz/knHzhpV4kTw++NJaRHLoaNiVVNnVR96gZUU/1zcLc2+KP
        Pa0eDaZlLI5ZFBXPsqGllfk=
X-Google-Smtp-Source: APiQypJfYvNzTBzbY10pp3ua4pMFxVPTarhOZ/sh9pBKuZpg9Vw4f5p9IViNoAB/yFezfoYLHnmNjA==
X-Received: by 2002:a50:99c4:: with SMTP id n4mr648565edb.187.1588641523237;
        Mon, 04 May 2020 18:18:43 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ch17sm87693edb.42.2020.05.04.18.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 18:18:42 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] net: phy: bcm54140: use
 phy_package_shared
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
References: <20200504213136.26458-1-michael@walle.cc>
 <20200504213136.26458-3-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <99574d6f-8a64-c04a-f244-525e48d008ea@gmail.com>
Date:   Mon, 4 May 2020 18:18:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504213136.26458-3-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 2:31 PM, Michael Walle wrote:
> Use the new phy_package_shared common storage to ease the package
> initialization and to access the global registers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
