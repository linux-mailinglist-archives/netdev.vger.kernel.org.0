Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A35324E95B
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgHVT00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgHVT00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:26:26 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA0CC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:26:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i13so1658635pjv.0
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GRbSM5kXrknYF/X36VB8aJksuuTk+uSSWZYzEUi6Hdo=;
        b=eaMhUkeQd8+Znz9FnCOMKJp9oJuBxn0WpaeJXcpFwgQBvDjKOiOgRr1KPpmHMsIlyf
         nXyOX6yXqOkmy3pNI2UKOPkwv30oYooYMxZkWNMJM/6TLykuMwPGg06+fELYxSkspvfO
         oKsvohrk87Itvma2Jzs+AFD0UD5HWxh7VEiQ74xoee1sru49K7IgBJqvcRezg0eDmAS3
         lnJVNqguSn8OeUobd+XaBGwOZDgatEJ5TutaMo4UkDGfczQJhTC9itoCFLLVqNlGaqT6
         ze60MMTBsebELg9paL7UrVvzuHpVqYj9xWlqD/tg5g/r/62B9M8zTw7aGgmsgjQwV6pp
         nRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GRbSM5kXrknYF/X36VB8aJksuuTk+uSSWZYzEUi6Hdo=;
        b=pSfVi2xyhE+IC+qdB1rmN56AJ6qJRAM1my1r6s5r8Xe+pOaaM7VBtsBL0I8opoPc+v
         If73FflTvHKyTOnkddXkatb+x7ihUTBPNZIaSSvBMrhBspIS/XYk1UpqbtahVJ4MyCgT
         j2Y9fWvmiva4+jvtAa9LS/a5dZ/N0KD6lCLZYHeIWkq+m62j1DHV6P1vrjk/wWakCF2h
         suovi4Nkmg/4MJsNSBtV8tb8l+GCx9AeC+mhE0E/sveZ4QnQhSC9TQ/8kLrofEOzt86+
         UY95W9R0u3ZkY0pIb4pBiTAK9Bsp3q0fWfWRKn12Uirv8zK4Jo7vDur/bmdc99TfC3O9
         bK9w==
X-Gm-Message-State: AOAM533FNKbmX+bYkK42gg3EEQixRhVn8JTDPPFIF16NZSMoJ1Mp5R9+
        HC+g6kV5/ZuGeo1+tArt6Ew=
X-Google-Smtp-Source: ABdhPJxZ0Pf5e6HUfWlJNq9Sl/JZXRuUzxzBPevyOfED7NTGQYL7yropCHkw3ifDF6CEO1XHvXGGeQ==
X-Received: by 2002:a17:902:768a:: with SMTP id m10mr6890785pll.125.1598124385521;
        Sat, 22 Aug 2020 12:26:25 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y4sm6325339pff.44.2020.08.22.12.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 12:26:24 -0700 (PDT)
Subject: Re: [PATCH net-next v3 3/5] net: xgene: Move shared header file into
 include/linux
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200822180611.2576807-1-andrew@lunn.ch>
 <20200822180611.2576807-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5c9b9618-5b28-df96-5680-0e075439b7f1@gmail.com>
Date:   Sat, 22 Aug 2020 12:26:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200822180611.2576807-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/22/2020 11:06 AM, Andrew Lunn wrote:
> This header file is currently included into the ethernet driver via a
> relative path into the PHY subsystem. This is bad practice, and causes
> issues for the upcoming move of the MDIO driver. Move the header file
> into include/linux to clean this up.
> 
> v2:
> Move header to include/linux/mdio
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
