Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AC71E825E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgE2PpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgE2PpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:45:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEDBC03E969;
        Fri, 29 May 2020 08:45:10 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so4245977wrp.2;
        Fri, 29 May 2020 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5RslimxnNmh0r71SLnEnRv0yda4yBo03pB6i0RDHhDA=;
        b=B2nszOsdY1d+EVCNyYyeQLXoUdQKtkIwIBDpnY3TuQuTWEmosdUDgl5ojrBtpzssgh
         e/rr8jPGoMJdvjbTLQJfucNtHiurwL315Jo9fdIlAvgXbeaGuvwItamUzBvxTZsDUwXn
         +3anwv0lZS4s/LO6Oh22Ft7B2Ov+q2hGpb+JUTFPkJr1kJoIpDSRtYc1br1E6vk7xyAw
         OHTW31cNw5bQGZm7wSuTlTdRi6s0Slwc601E/O9EaXxCVARxWurCfBNkD8JotbswPBpY
         w1WO9E9zzOc/sxbel9LVLw4QHfeMU0HiYJrPJEJ5GwFhYTjfVuMYYJy4ePZ4RynYj1Rh
         bDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5RslimxnNmh0r71SLnEnRv0yda4yBo03pB6i0RDHhDA=;
        b=WP93ElqUNFQMjYG1h6Z2gsKJTZb5CrB7rm2wHTVPEZTTL8NdHHhi8x9gbFbNF/m7a2
         di356uDIoy9Q6WzxrSZ/cyKsH8BWDsH4Rlpob6IFN14UZ1iuHTN51lqqFGsFalEdyL1a
         20H8fGmn06l5O5piPYjtKsq+OPo+uKdv95qmjksrqo57YXjglgnz/FlV+/MOQEU+Pavm
         yS+illMcexbAAvT7GurAGewu9mwteUDyUR1vj7gx57F5Sxgn+JCCrYzFQscshpRvMcc2
         YXMem2GuJPQLuojIUfbWgLznYNDO7/7x4p6pGRXWt1iNYd8qH0r4Br88a8JH3ICSNemT
         BBbA==
X-Gm-Message-State: AOAM531dQY/548c8G5Q8UACRD+XiwKwlHvSeVJZlWG0rK/N3TRa/asdg
        d80PgI4PE1oCOpOSHGTGpTfseVk6
X-Google-Smtp-Source: ABdhPJx3qrfb59v2e+jBBUQ/HdeGOFhHqUWEy/K21mtA8NJfHKvQCr9MdY5uUO31Ws2q2lyvScL/ug==
X-Received: by 2002:adf:df03:: with SMTP id y3mr8877459wrl.376.1590767108555;
        Fri, 29 May 2020 08:45:08 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t13sm10589690wrn.64.2020.05.29.08.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 08:45:08 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: mscc: fix PHYs using the vsc8574_probe
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, hkallweit1@gmail.com
Cc:     michael@walle.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200529094909.1254629-1-antoine.tenart@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c7b30c5a-a7b4-cd13-8c7a-f74b8d5a1c90@gmail.com>
Date:   Fri, 29 May 2020 08:45:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200529094909.1254629-1-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/29/2020 2:49 AM, Antoine Tenart wrote:
> PHYs using the vsc8574_probe fail to be initialized and their
> config_init return -EIO leading to errors like:
> "could not attach PHY: -5".
> 
> This is because when the conversion of the MSCC PHY driver to use the
> shared PHY package helpers was done, the base address retrieval and the
> base PHY read and write helpers in the driver were modified. In
> particular, the base address retrieval logic was moved from the
> config_init to the probe. But the vsc8574_probe was forgotten. This
> patch fixes it.
> 
> Fixes: deb04e9c0ff2 ("net: phy: mscc: use phy_package_shared")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
