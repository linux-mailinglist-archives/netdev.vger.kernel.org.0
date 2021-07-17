Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF203CC45F
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 18:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGQQMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 12:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhGQQMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 12:12:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230F6C06175F
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 09:09:50 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s18so13428814pgg.8
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 09:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mr1xvfrVTh66xqHWAwYZ4lFNWcGmN3q+MwpYoJ9NDjs=;
        b=TfxiS0qcutJMpNgLJq+JkeXSn26bHWQ6OOtcefjPbU9eu5q5AsMja74ZAV0hA/zYpz
         M0Zi1llXcZfGsoClQ9ibnoFTgeO6maszrPlQe5THbYWkn+AtAPnPjwMaaJvQDnRBFwbx
         E/ab9QFv9xb9h/2Iq/OmEw0NM+KTjWNkaf7YDx9bHIdogBpAMh0U+pPKdYDj5CnjVLY3
         cL47j7jkYN6COAzLiA/mOASVhMGk2sadY2PImzdiFBJwjf37rtJfhYnVOrKEa5rArGAP
         PG1nBwFcfVPu4aAAlvBPa5oTtT4zPs7EmgybynzSxa4Sz3RPBX6z+fUWblFvSUV1Q2Du
         h9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mr1xvfrVTh66xqHWAwYZ4lFNWcGmN3q+MwpYoJ9NDjs=;
        b=oTdmvUJm1C3m8bvKVK1EgnsLZNQePGovV7411X5W6I+7B3w0Rk2ZLWBiwzooXhcjg8
         Qrx/mYtQ1eGfxI/z6djaE4TRFy+ci4/yOxDaJLiNReu6aEaeWAVILMskQdSgApefNIXq
         U9YDarjD2mcB+XnpsCZxW6gQKPV0rh+rbzFB8V6KFwZgcJFXccgiJ9h/k2ZI1mwwq45s
         MNlvxIjNLhi3fNCHB2neXrFjLqOB53r7xEDZeFDDSz6VtySk22JGz/gYzK/DTDkAyxYF
         nIT7/Fq3TdkrrvVjkBuOPHwj6KrbNPkmWH12XGLp5gVeTGf0BcEoJRz0P3xZX6qAKlal
         SixA==
X-Gm-Message-State: AOAM533aFdWssonqWZs9OzuLajkLMnBMDSHQwhCiFx6WJMlDaODam6Z5
        E2dzFNmXzGGglmZG4sVU0LzYIouUXHvjHw==
X-Google-Smtp-Source: ABdhPJwmRXKxueWlC1ZWvXZQbt6aoWBYda4K1kTyxPs9HoG2TYTK7Eu7gM8w+PG+wImQWT3HHH22Vg==
X-Received: by 2002:a62:481:0:b029:31d:f010:26b2 with SMTP id 123-20020a6204810000b029031df01026b2mr15965956pfe.2.1626538189477;
        Sat, 17 Jul 2021 09:09:49 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y6sm15029107pgk.79.2021.07.17.09.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 09:09:48 -0700 (PDT)
Subject: Re: [PATCH] net: phy: Fix data type in DP83822 dp8382x_disable_wol()
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>
References: <20210717123249.56505-1-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <29e2ddba-44fc-4f2b-3d87-5508ca34ce75@gmail.com>
Date:   Sat, 17 Jul 2021 09:09:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210717123249.56505-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2021 5:32 AM, Marek Vasut wrote:
> The last argument of phy_clear_bits_mmd(..., u16 val); is u16 and not
> int, just inline the value into the function call arguments.
> 
> No functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
