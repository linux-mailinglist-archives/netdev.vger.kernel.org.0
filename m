Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F87020D123
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgF2Siu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgF2SiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:38:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE29C031416;
        Mon, 29 Jun 2020 10:20:31 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k1so7359789pls.2;
        Mon, 29 Jun 2020 10:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EBxO7W3vjKfKExb7YIhRFg//dsteKdeNGdPmppkjMb8=;
        b=ewKodK9aN0OWBZQbu44iYiVfZECWxTo16lvDvRM89Z4teK9Y+NqZrKgHYKIHfQNOTY
         vWSJsKDUNNqYREungOJwclpKtKpmRkrGL+hMdIqE94CYuq5fgEYhUIMzysHUIT76AEss
         9/Hf9IgN/E1R5MQ6oWDqXpxAzTI8bKdOJqf3X5whfi8CQo95Fb5coiHOOJu0SF++m1CG
         xuFod+DMFoP8uTRz17dh9MvwIzMuRq7CCB2EiZri8RNCupv/MdpyiQacCznzyf9Hd0Hm
         FhBrhOLm+FIsA6Wt/Uu/B/3Nlo28pPvmhyhjwn+WhNH66L0Y/en19olQMt1/sRgiJtSM
         LrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EBxO7W3vjKfKExb7YIhRFg//dsteKdeNGdPmppkjMb8=;
        b=A92X8F6O9ZZ/sefrG8X3+lnBbHgSzPl/mH0w2b8Fr8ovLmcCCO3Y5wd8syVZhNHSAo
         XEE8Yb1+zHFY8GwyiJavjdyPPJGoe5a3Mi0eUaH0PAfpiZQJi5MvY3Y3HntfHVaR5l3A
         KLcsLcnF5aLnTeCaU9OwV5ygsP9dyWUm0vvcdYGhaPBWh4RCodBGcDSWeQSpsbGJhgGw
         1LpiwXwHPfLVLoCAHFkyct2v5m8auuGJx8+87WHPBuF2JcW74T2bNxwHpF0A0EScN3Te
         QbJvN/+/FLSbgtbq+Yi8qnDlNbqWk8KoBhVDyY+EEne8SOwQGSucIVvzTmzsEY+uYUZL
         bxEQ==
X-Gm-Message-State: AOAM533j5O2Dp47UJOXGXjMlbVZ9bVHufOnuGYp+UJ0wnbqIzW/bD/2E
        0erjhOVP6vvY1GJnU71B5IU=
X-Google-Smtp-Source: ABdhPJwBXYzSqVqaej7MrTtvAoxQQyVfrLurS2VT0FpRREZWIImH+ognZwMO6/Mmioqfe4mIEvAzzw==
X-Received: by 2002:a17:902:301:: with SMTP id 1mr14726130pld.214.1593451231314;
        Mon, 29 Jun 2020 10:20:31 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f29sm331735pga.59.2020.06.29.10.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 10:20:30 -0700 (PDT)
Subject: Re: [PATCH v2 08/10] of: mdio: remove the 'extern' keyword from
 function declarations
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200629120346.4382-1-brgl@bgdev.pl>
 <20200629120346.4382-9-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4ec2d4c1-3169-da94-2fe2-1165e1fbd531@gmail.com>
Date:   Mon, 29 Jun 2020 10:20:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629120346.4382-9-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2020 5:03 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The 'extern' keyword in headers doesn't have any benefit. Remove them
> all from the of_mdio.h header.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
