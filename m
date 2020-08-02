Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916F8235A5D
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgHBUSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgHBUSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:18:38 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D10C06174A;
        Sun,  2 Aug 2020 13:18:38 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh1so6606684plb.12;
        Sun, 02 Aug 2020 13:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+VaeBdZD6BxbTiHiKYuiWDRV4AX+dW31+H1ogDniWgI=;
        b=Ceeiw+MzYueUeDVdP0aj66GMYW33iLI4ekMXmYv+FHgInpLns+zq/m0PcRS50vHk26
         ZJqElfQ7gpsFDwrRVA4jieBcPiI00xOX18tcSlqxEIbXQVrfeuzRI8FFVFHmBW98+B3D
         lYC1KlNpbcjkLY1PcE6+1kJBXj7tY5LYchpqV++tDjNNLtYfRI0OhtvGiLCRHQ2TBlOP
         C59RqhToVq4pGGZJu7lfAqrgr+Oe/7R2cPqOGb3Px4v2wITByfZODtDhadw8ysqvlNvP
         O/Gtzqm2KKetS3DO60oHouD8tEgsCBYdLxioy5YIgOEFEtUGvWUCXje85REt7+m2oOq8
         eHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+VaeBdZD6BxbTiHiKYuiWDRV4AX+dW31+H1ogDniWgI=;
        b=A7OGw3S7ePhuc68sd7lKhUG3nTeEK0Pr7yY+yI3zMWnaDTjdRi2JNWGeX6QCk1g5c5
         yoxnq6UChdRa6mpBAR8yeojIlPbusMlN/lWgF3COPilMbubcdhSdnAIGHTkbyRdujRoX
         bg3Xp+7IriXeNRgG8+c3WQ3OsG3KFYgIS6o2SmEgvYdRHbWgyXULLr0+K50/FoMEVw4M
         WgRK5FwDAcbHmgIO22S+5M7GMZgumMXs9DsVnrBVpcHp839+fgZ7hEuyYU0w1V/2CjyW
         qFZ/0n5HlaZ80sIZPBE1t+k+6Xap+UFrRfupv+pO8/UjPhDv2OchQaIk4pfWdJsvmXmh
         7Ujw==
X-Gm-Message-State: AOAM53189TVsPkDNqciDVJP/4uY5nWLfrOJ43D5gRkivE5qIQSCfjTMu
        Tb10SHugP5uqXxY7ZKBztOM=
X-Google-Smtp-Source: ABdhPJw/S1fMbFH207iXXnX3cp/cOSEnD+zqvERr2xiGFnu2wILqXwDyaISUCxeO8XSRK/QMUs0pmA==
X-Received: by 2002:a17:902:7c03:: with SMTP id x3mr11920417pll.178.1596399517819;
        Sun, 02 Aug 2020 13:18:37 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s185sm13712146pgc.18.2020.08.02.13.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:18:36 -0700 (PDT)
Subject: Re: [net-next PATCH] net: phy: mdio-mvusb: select MDIO_DEVRES in
 Kconfig
To:     Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        kernel test robot <lkp@intel.com>
References: <20200802074953.1529-1-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a0143110-537d-7344-5b81-8ce656c5e9b7@gmail.com>
Date:   Sun, 2 Aug 2020 13:18:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200802074953.1529-1-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 12:49 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> PHYLIB is not selected by the mvusb driver but it uses mdio devres
> helpers. Explicitly select MDIO_DEVRES in this driver's Kconfig entry.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1814cff26739 ("net: phy: add a Kconfig option for mdio_devres")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
