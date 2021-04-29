Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4927836F2F1
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 01:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhD2Xlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 19:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhD2Xll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 19:41:41 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33478C06138B;
        Thu, 29 Apr 2021 16:40:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s15so7220345plg.6;
        Thu, 29 Apr 2021 16:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XhukHwYbMb8O314H4ZGGa+i+YIDh1nbMFFV8k4MmwUI=;
        b=op9P97+VwniEZEgl6V0uJg4liTBfCSve0gYuIwtJV2VxgUw2uUscBqDXghoZPDnU6f
         kmbxPcA8HMaMk9tqhS0jkzO7vEHxBQU70muIVCdylatZ9w3zGSt44TC3VOxcSJHLkdk8
         HF7pjnC265ouFoBV4707RyhBohR2M7FGgk3tuRDZhZxKL8HrWpiXBOk5po+DkFwTPJiE
         KKQNrgRjFEc2xWJhu3cSdmQhT0b5UW/Kmv4aYB6IFMprXMFAviFbSnYw8yVV596Z52b0
         nLL7Ac0HUC1DYwzPnV4gn9R7Y9oS+3ZcDr/YsqIgEWLniuGvjD9Jo9T8F7uT60zX8IA+
         03Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XhukHwYbMb8O314H4ZGGa+i+YIDh1nbMFFV8k4MmwUI=;
        b=a/Sg0XfthBgefVvxF5rAvzp6pjdvpuWg3i1vsOXgh/5GUufNGLthQMlOKPxH4rRikF
         sGM8P1qPDNeZsrSYWIvQE5V67V1WbIO6sRJFIM1RH8nR8Dimi5oDWoQdxZsMmxhnAzet
         yV1CmlVzLOUhxnAVk2c+XJQkZfnRrql5PeLzSP/9wk5eqUz5GIYUI9R+Rjmqtwmulhi6
         Orv/s0r7FiIz6dRbpZ/jR0NgIRfRDpA7lEguj1Wc4wfQzHw3sB8qA6q8uF7LIJV5VkVF
         rFQJqtY6L0lSxCsttTt1STjRs4obQBqYl8MyYCnXQMc3Gg9/sYXaU5X3QI7Lw1H//WEN
         ngUw==
X-Gm-Message-State: AOAM533VBPB9JaIgRSy/NyNeL/QmW8meLuXhgra/KdjGql0756XlmStc
        uiP/Ga6hKlT4XUY3Z/o0pww=
X-Google-Smtp-Source: ABdhPJwjGyTLCdT6s5cn8i6gJu489rSGDxoyn02TFF4vVytwGrZ2VZpOChwO4adx+To7A4ZukzXXtA==
X-Received: by 2002:a17:90b:3615:: with SMTP id ml21mr4991739pjb.28.1619739653805;
        Thu, 29 Apr 2021 16:40:53 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id q21sm23807pfl.152.2021.04.29.16.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 16:40:53 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: phy: add MediaTek PHY driver
To:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429062130.29403-2-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7330e4f6-5e7a-1993-1577-fefaa163b6cd@gmail.com>
Date:   Thu, 29 Apr 2021 16:40:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429062130.29403-2-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 11:21 PM, DENG Qingfang wrote:
> Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
> The initialization procedure is from the vendor driver, but due to lack
> of documentation, the function of some register values remains unknown.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
