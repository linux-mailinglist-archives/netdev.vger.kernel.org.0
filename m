Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32341E4A4B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391234AbgE0Qdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390688AbgE0Qdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:33:35 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7580C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:33:34 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u188so30447wmu.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l+Ph3/6hHFWOrRHysGCZFQF4fKqod2qj4SSi/HRSaSY=;
        b=lfU6AECdjGbIu9YBdpVBSLSrZ8Fc8G9M7G6XObBju9ahZPIdxrx/gLwSebxhfn90qL
         /7bK2c+ZCtTsgfUE7bO8lKC6U5rZSU+wnr+6kXmYv22DUFytburtayubNs3CieIclzNo
         iJLe4a4MhSyUP3L3tBRg7HvW8HOrKZ1VZhY77ThZjfs+6ftTd+QcA2X7AuRxdkyhDbDe
         2O8ZTtPMmyY33v2Z9HQaN63sqj7XkL4QIQp0fCvM0z/puCLj2dJWuW+FOgrqXkCuFmL7
         upSzlJVzAySlvDQLUEmHE1gWdb3pBUJNhDW2zW0kuIrJhq0ofr+yc95a+TZcM34cvw2L
         5o/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l+Ph3/6hHFWOrRHysGCZFQF4fKqod2qj4SSi/HRSaSY=;
        b=WPRApDzazaVrYJMktMHSUCBIyIsT2aisZRe5xeRUW0XwzRyKZmpWoOi3B/o4vWmQWF
         Z4bt2waKGHCgCYJhu71VD+umVsnP6Cu5J0dB5V0XI7aDr9dm7DXoiznHE5X3aBIje5m7
         65/vHMMY5z/X2BBcRh0nCDh7Q6MVRuAH8eFszkjnE4RnumSF0gTCJc99dd/95wOGqyFC
         exxwEL6dAsQbEa7/ebl9UIXV2N7WgRPXYeAwzOxckztqxUs4MJMWm/yozccFIrEa77Q0
         1o1eKm1tOQdApjHkYTRVTqk4prQ/Y5moJewv3opSl+0S3WezT9mBuWddmMX3Nkrq4qKF
         2uFw==
X-Gm-Message-State: AOAM530+MIY6J5LDe0fPyJX0nzC7we/cApj+ls24XhPZCb03//zy1RkV
        8A75V4rEWCRWic6Ih+FvxKmipQlm
X-Google-Smtp-Source: ABdhPJytqoNnbjQ8qXTKnVvPkKtOHzT6+AJvAfYJe2GXemt1TJo5A147OhfhKD5XFtFLQiz7tG8xZw==
X-Received: by 2002:a1c:dd44:: with SMTP id u65mr5470054wmg.180.1590597213218;
        Wed, 27 May 2020 09:33:33 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z132sm3814383wmc.29.2020.05.27.09.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:33:32 -0700 (PDT)
Subject: Re: [PATCH RFC v2 5/9] net: phy: reword get_phy_device() kerneldoc
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNu-00083q-Ok@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1804bd50-6766-e31f-9cd3-6a80c0e129e7@gmail.com>
Date:   Wed, 27 May 2020 09:33:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtNu-00083q-Ok@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:34 AM, Russell King wrote:
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
