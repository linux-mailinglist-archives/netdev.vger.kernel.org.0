Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1C3D9C88
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhG2EPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2EPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:15:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC45C061757;
        Wed, 28 Jul 2021 21:15:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso13562675pjq.2;
        Wed, 28 Jul 2021 21:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4EsZdeVNwXXAzJzhYh1YYH40qz659GS3MHBPwyno9kE=;
        b=NtcXOE3PAcw2VrJlN8Zvjmu2KTO49UxI7AqFRSFaFYX3sVVJhNmGmO+uCIV3fVwHva
         LExwqihkuw+suWhfHXrpXIzBWtxUXDQ72m79eOwO8KPp6xVcYh7WSxfz4MlUBNQDMe1b
         tyKeneYL3fSJkbHxf7y5A5+p/VCNaw9SwiaeywHy5Jzgpe3pKSs8uP7bP1sY8v40jO1C
         A0U40tq47VdvjyAe7qiXPIzmPqFiiy6neycfbN+qn/U8OkzhFbIxsO8u9zw11hxfEwS2
         +9CMbd4tLnjqn13jRv+YUExM8W7iqNFRAlEKmAj/ksvJ79Ly6Ku50F0brOX5zf1/dH6u
         FTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4EsZdeVNwXXAzJzhYh1YYH40qz659GS3MHBPwyno9kE=;
        b=guWctSuGPHhhfQaoEK6aQdSkLpGjLIyka1VXHoZmV/KMLt2zY7uk+EZnI2dF7VnHMf
         Y2pWoUB0QUSEhCfLmb3fSiXzXFPH7upeg3p+kJHMx5njGvErhbVb/JHpwPZl97XFvWeH
         U/aw8EPuDyQgx+ujriNzQePYqDs0fJ/IE0Bn4Wb4S83l4EELmI7L+HmzynXRbryu1Qtw
         0UH7THa011uUx6nrgzt5vH7M7fiigH0tdmFhU5yJKpsTa6U/anxbWANUZa6CwxBwZJI/
         4+dVLTNoHv+i6CELqNgOF8G/6MPxf4DyvsIgcNeRj7SQ0IIGhOUlK/iTCo+kUGxifv3N
         6Y+Q==
X-Gm-Message-State: AOAM533gSe2+7pvCXV4IC0pGxB1GSJh2p+f58cICG09rklg+na/OoH9r
        bozd4g4mWHsoH0HL5+iYPXg=
X-Google-Smtp-Source: ABdhPJyVMbBAzwBqN7q5k088w03Am0q9HO9yfN5pvnKdd7H2nVW/VJ5UJcs/6KcZvR6e7ucrhyJfBg==
X-Received: by 2002:a63:5643:: with SMTP id g3mr2135467pgm.263.1627532151784;
        Wed, 28 Jul 2021 21:15:51 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id r18sm1699039pgk.54.2021.07.28.21.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 21:15:51 -0700 (PDT)
Subject: Re: [PATCH v2] bcm63xx_enet: delete a redundant assignment
To:     Tang Bin <tangbin@cmss.chinamobile.com>, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
References: <20210729040300.25928-1-tangbin@cmss.chinamobile.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c5f4c8c7-75fa-7c06-6224-3063193be355@gmail.com>
Date:   Wed, 28 Jul 2021 21:15:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729040300.25928-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2021 9:03 PM, Tang Bin wrote:
> In the function bcm_enetsw_probe(), 'ret' will be assigned by
> bcm_enet_change_mtu(), so 'ret = 0' make no sense.
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
