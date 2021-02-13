Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6499631A9AC
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhBMCzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhBMCzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:55:05 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3793BC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 18:54:25 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z6so704513pfq.0
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 18:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wor44M4dPhZglkXM9TvPxQt/hAIxFmEYoBSrlBkApbI=;
        b=DNHkw8O93Bju8475zTY8tUwY2lo+ZTrfUz/9LS2FoLEReOvoe03r/1BYnpC05zcCw6
         54IU3xBLwwwCEywqA20eoG+Q8l92w4Ch9wSJ9nzsuAlKhTkryCRVw/y0KN5PWDVm80bb
         JY4jFPMw7Ed+fIMc2xYg+fgXyATTJzt4eRSep9xPfIbUL2YFDURg6DjdVf9SUUSni6IQ
         vPuztF3E12PSkurFx9DTpsWlpDEtobDA2GobdqLwhPFB1q+Z6p/h6jHOjdOVOvCi4WM1
         LDhFq7ae/8iT+efHQblUxabEdwdFkoOTlcTqkryqlxdKWZFSNAmDCgENf/kLd/Ujg8/z
         BcSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wor44M4dPhZglkXM9TvPxQt/hAIxFmEYoBSrlBkApbI=;
        b=iOjpREWtSuXKmDZusMFXwC7ui5T/9Kzf53NQLXgW0kW1xlHpYeEj87jJzudJoeVVJ9
         G0aPy50S4bV+/GJa5zjGN7QfML428TB7cvKqk9LksUDaPh3UGpiFwH47h6Ou/SX9SrWf
         uMMQUjteBMzTHM3t9/qR5sTHdoQ/jjiTPJfs2WBwbXSc7z3BpzcfviaTQDK8ATdvrd+l
         CkYfP+p0AlwtXe1yhV1aX+DIEVPyTMgQvPRRUJttjktPbfssA7yw8Hj0s5cPWPs7J1ss
         DQgxOT//44IXwErN27xzCEg+27M7Eku5qiJI39qq6bVKLk7DlYv9WGahb+KYNhT/n1Rx
         nzUw==
X-Gm-Message-State: AOAM530QcxUnWrNwu3ujmMzECPuKFChYJT2xzLTerqbEas8C9DMEaAxU
        A2I1mJPUS1Mf5BACf0inY0Eb3NapOzA=
X-Google-Smtp-Source: ABdhPJwOfkYfvIqKdZXfTopP7OU7ZSrg9cq2PY/OtAjwxSzV/nUpwFfEiPCTNOh5lYZ+6VZwraWWrw==
X-Received: by 2002:a65:4083:: with SMTP id t3mr5943172pgp.150.1613184863501;
        Fri, 12 Feb 2021 18:54:23 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h12sm10208332pgs.7.2021.02.12.18.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 18:54:23 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
To:     Robert Hancock <robert.hancock@calian.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
References: <20210213021840.2646187-1-robert.hancock@calian.com>
 <20210213021840.2646187-3-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e0ae1d5a-9ed4-e145-a35b-44b704be69c1@gmail.com>
Date:   Fri, 12 Feb 2021 18:54:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213021840.2646187-3-robert.hancock@calian.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 6:18 PM, Robert Hancock wrote:
> bcm54xx_config_init was modifying the PHY LED configuration to enable link
> and activity indications. However, some SFP modules (such as Bel-Fuse
> SFP-1GBT-06) have no LEDs but use the LED outputs to control the SFP LOS
> signal, and modifying the LED settings will cause the LOS output to
> malfunction. Skip this configuration for PHYs which are bound to an SFP
> bus.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
