Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB11B5313
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgDWDSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWDSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:18:24 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BCFC03C1AA;
        Wed, 22 Apr 2020 20:18:24 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rh22so3546031ejb.12;
        Wed, 22 Apr 2020 20:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+nfWOsr4ZJZbsxymJ7sh9iZtJO+QSdkzISxoJh2nb68=;
        b=Yj6mdVnqk687alMjhDS41cf0cYXFirXwxORN+RMDmLJwBImKmTnKq7izunZv1KDe5B
         E+aLJbl4wdRMGFatEbT9+YdKPKLU8afS/5sZuv4z80UBKHR1+0vy90tGrD7l9eAqlMCN
         875mPCyRVS0FCyLI2LFZ175KdRzoHi6uxGmd+CflgQCfM/+26ntOwnJ2cD/C1Ej8IPGR
         Qn43DNlujhe4H4GH6vCTJykhSSaCA13NFlCmAwJhGj1oD+hfTVtGejD5GtsQ1ZxVIomG
         tx+scdT5QMDhPXJV3pYs04ISZOfZcn5YcM8swksHufkkxRO9fp5USy3Z9QbXAwuXAxvl
         rgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+nfWOsr4ZJZbsxymJ7sh9iZtJO+QSdkzISxoJh2nb68=;
        b=Ghq44imRelRfRBARA+ecmSO5uBKhfj6holvIsvokb+7cU6czWyMCVbu8BiBRkGuTCj
         F656vE0X8zpbc4DE63OBMHzJAiHNUGI/XfdeADGBjqNJPWk0n1SWzFm6glan7Yq/m2wC
         /JSRv0Dt/be6sqpFEcLne4/KqBdppVcPyG/gSDFoN6lvpwt2+0AF8cWhc1I60RRu7mWe
         0HJ0WK8iqNsPTAY8WtWH9NT5E0RefKF2hgKyVT+C8VQt/WOOB+AWT0p1A2Xn0Xygdmbi
         2iYt/P1Sv9+m0lkEWzJKuNhri+zXWdDUxWehp0AxfB9tT9pKi/agM1g4IR6+wRP1HMc/
         8Ydg==
X-Gm-Message-State: AGi0PuZuepOzNR0rbzK8XxYjaYHyxbDdsQdG61zZ2ebUOQDHHLqySmkK
        U0vDZlBcW1ROFooUCS2eqm3gO4rH
X-Google-Smtp-Source: APiQypKU22t3H6MCfHELuAUbMdkbiS91S2MgbM29QSBaTvdlltjhRWyuamGmDfn+zjFlcVlXf3p1gg==
X-Received: by 2002:a17:906:1c8a:: with SMTP id g10mr1106058ejh.342.1587611903070;
        Wed, 22 Apr 2020 20:18:23 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f23sm257108ejl.23.2020.04.22.20.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:18:22 -0700 (PDT)
Subject: Re: [PATCH net-next v5 3/4] net: mdio: of: export part of
 of_mdiobus_register_phy()
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
 <20200422092456.24281-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c592958c-e169-42fa-edce-463423136d2c@gmail.com>
Date:   Wed, 22 Apr 2020 20:18:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422092456.24281-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2020 2:24 AM, Oleksij Rempel wrote:
> This function will be needed in tja11xx driver for secondary PHY
> support.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
