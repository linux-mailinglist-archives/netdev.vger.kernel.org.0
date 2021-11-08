Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36636449B59
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhKHSEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbhKHSER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:04:17 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8813C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 10:01:32 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o29so9924280wms.2
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 10:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SCiIfZT5y5Re3whs/pUtqfg09Tz51O7KasolCWFWnvU=;
        b=U6RNBBKin++SaXPiFPQoln/1gmAUU+ctoojRurTA4cVoOn3tbgHKBSAAl+HxuJ71K/
         oS7hJfEah6Zc/XsvG2l0EtT92xnIkDKb+jAPe/thVfzbmbJh8RYHgXEYmU+8yVd6DQOb
         QTKwLB1da/cXtPUY/SPfzEP9CsSB0GDVSTIs5O8erFG+AWFf05eZxmm2reAO36KSJ8u2
         F3sPOm2xxzy51Y4Sy46az2YDOAbkGG1+LBDDr8RfxNaKgU/42oePOHNG5+Qbc2ncCL39
         DmqhNsZRXxkE2YndPKeIz9dypS4lWwOrrPBo1nFHZNkqb9r0fE1dSxIRB06pdUAQICyc
         3EIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SCiIfZT5y5Re3whs/pUtqfg09Tz51O7KasolCWFWnvU=;
        b=nrYpXWmpnlzArejmXkCDFoVnCoaX2dAHlcLAVlcv6HBP9X65V5E+KkYLlpMmIp0j+e
         oT2BQU0uRtD0vHhV+tQ2yNy3VBuPWQEucG1lJrVI6yVmnWHDcuHPwS9l/Jn6COod8/lh
         TQdqPw3jX5XBPT3iUBPBW6krnJK3SbuxrAVRA1pNjZc9vvgXfVJx3r22yX1FNdROnJYt
         IYRgDM5kcZqL5XMZk1xaVYMlmNtf0bdPG6gHS/UvxRFYp4/t5e3d0YgA848bk7WhJbIw
         kj2bJCBsbXmamHIF5PdS3u7oqXsbI781sHPZ5DnHCkF8xSZIi5Sw6IJeOViZj6+JbXpk
         tKIg==
X-Gm-Message-State: AOAM531XfZkULDr6SfdDJQ5kOOxuBuEUO+LpMxly/O/0mKSQSYuzPfXR
        lsY/kD8YGm8Dd1HlfoJuPoA=
X-Google-Smtp-Source: ABdhPJzhyzQbCcqyfarQ3wy1LSH87w9kAhdAlZglDSwq5KA/o+cHOyF3zR0NkASBsyZEUOF2tgCSpw==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr213956wmk.32.1636394491297;
        Mon, 08 Nov 2021 10:01:31 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:2d8a:e3d9:1c29:7a84? (p200300ea8f1a0f002d8ae3d91c297a84.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:2d8a:e3d9:1c29:7a84])
        by smtp.googlemail.com with ESMTPSA id 126sm58854wmz.28.2021.11.08.10.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 10:01:30 -0800 (PST)
Message-ID: <e07b6b7c-3353-461e-887d-96be9a9f6f36@gmail.com>
Date:   Mon, 8 Nov 2021 19:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Bastian Germann <bage@linutronix.de>
Cc:     Benedikt Spranger <b.spranger@linutronix.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk> <20211108160653.3d6127df@mitra>
 <YYlLvhE6/wjv8g3z@lunn.ch>
 <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
 <YYlk8Rv85h0Ia/LT@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <YYlk8Rv85h0Ia/LT@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.11.2021 18:57, Andrew Lunn wrote:
>> It is BCM53125. Currently, you can set "mdix auto|off|on" which does
>> not take any effect.  The chip will do what is its default depending
>> on copper autonegotiation.
>>
>> I am adding support for setting "mdix auto|off". I want the thing to error on "mdix on".
>> Where would I add that check?
> 
> /* MDI or MDI-X status/control - if MDI/MDI_X/AUTO is set then
>  * the driver is required to renegotiate link
>  */
> #define ETH_TP_MDI_INVALID	0x00 /* status: unknown; control: unsupported */
> #define ETH_TP_MDI		0x01 /* status: MDI;     control: force MDI */
> #define ETH_TP_MDI_X		0x02 /* status: MDI-X;   control: force MDI-X */
> #define ETH_TP_MDI_AUTO		0x03 /*                  control: auto-select */
> 
> So there are three valid settings. And you are saying you only want to
> implement two of them? If the hardware can do all three, you should
> implement all three.
> 

If we would like to support PHY's that don't support all MDI modes then
supposedly this would require to add ETHTOOL_LINK_MODE bits for the
MDI modes. Then we could use the generic mechanism to check the bits in
the "supported" bitmap.

> 	  Andrew
> 
> 

