Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD913B4A6A
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 00:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhFYWGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 18:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFYWGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 18:06:31 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EC5C061574;
        Fri, 25 Jun 2021 15:04:09 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v7so9315559pgl.2;
        Fri, 25 Jun 2021 15:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zNX5+hQPuOKekDYxVhjoGrDUq/O+yLikGLjedRTLerE=;
        b=igy55tbCUAFSm65Kwf/wn4MHLmP3WR9hLLpy2Wa7uJWdqun2Z4DLJ/NmI2MdTkcdwv
         7OolAhtco5PhXtX01koOvfR2ZU6e+5UI+51oKjbSGJnA0TTAKg8EshQlu66gDygivv/M
         6GhjXVrwkhnyiGZFwuVYM9DPPN/VamyuluMoEMo0VwDd3lYEkvLJakpYPaNzLgPssPHJ
         bON3y6hMoCH4AOdBXndWHD4YAeBzeotgX2Y3bB+OxHSagWYSkt4C9EWFB8dMcLWbtnBz
         7aqtSccCRzMHl1QbzcRAGmjv1GiVL8t0N92VAtYWaJJLGwxpbG5+ifPAPO80hZISWo2v
         KspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zNX5+hQPuOKekDYxVhjoGrDUq/O+yLikGLjedRTLerE=;
        b=YNhtiPt95ZtD/MhnvR1HQAe0ypTaRISbdaejB9vUtgmCpSfKPNdn1ovAbbfzct7rw0
         1jQkgxHdCDu+Hw5wrAb4hOCCGtF2/aMcj+tNIKdHzdHCvjG9BmfT/fa+mMmeRPbjH8sZ
         y5PCO6Edh3jlmwX8kZN4QK3r2vN69afcJnOoifOmLnzvlK1jJZtJNsnvML+kj1GNasKD
         tmhdWrL+nTwEvbs/TvRq1vt9IkP/OQ/dXhH5GjA46h4Vmt1bSlH3LJFFWuRo1YvhxcFf
         lVyZaZ75G80aN86gLnGJ+1GcUArhOEe9a03eIbgbBDsQUIujc1DIeMztbidcbAW6h42A
         KIaQ==
X-Gm-Message-State: AOAM531idaYt/865NiVZ0U8Od8SrWO7iXfNoTmOMlYUomgVNQVF5OhkO
        eJdsa0ocwDr/RTKtaxR7LbvR+Rll9B4UUw==
X-Google-Smtp-Source: ABdhPJx53BWnV5W+OXYUVvGDhA1GAeHyV8LnlB35yd6SenbtLJ4VxVHz1oOaWTT3o05PpAFC1rPikA==
X-Received: by 2002:a63:dc4e:: with SMTP id f14mr11193438pgj.378.1624658648248;
        Fri, 25 Jun 2021 15:04:08 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c18sm6513960pfo.143.2021.06.25.15.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 15:04:07 -0700 (PDT)
Subject: Re: [PATCH net] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210625215732.209588-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <79839c8f-4c4d-a70d-178c-1d7674e2b429@gmail.com>
Date:   Fri, 25 Jun 2021 15:03:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210625215732.209588-1-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/21 2:57 PM, Doug Berger wrote:
> Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
> logic of the internal PHY to prevent the system from sleeping. Some
> internal PHYs will report that energy is detected when the network
> interface is closed which can prevent the system from going to sleep
> if WoL is enabled when the interface is brought down.
> 
> Since the driver does not support waking the system on this logic,
> this commit clears the bit whenever the internal PHY is powered up
> and the other logic for manipulating the bit is removed since it
> serves no useful function.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
