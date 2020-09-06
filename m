Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8800025EC14
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 03:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgIFB4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 21:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIFB4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 21:56:48 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134A9C061573
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 18:56:47 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so1753604pjg.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 18:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7WPkdTehgW9sSNpu+KhxUtXcjqffOjrsmBnhQ4xxDXc=;
        b=Q7TW9wzmS0UGtnsak92LdHfHujWlSjPh+zz6KbCJ70NCJzVhYD3Qn9a/vpQiKiJymn
         ZANLG9sAVjWUpw6XxUp2M1IF5ePI7PIpAMwfExu3THX5lCYDzLsn2HLQHDxk9UufIOgX
         UrKUUyTErp+Of7S5LieFO3cO0AbniXpsshoyA2uC695TJyZt6lM2SziftHT1LpSnMWqa
         o29nVpC0qNa3d40Hh9Ph8NZ0ByHprLSpdOFhnidW5tnkhv248V9KxzhJrx03/p8BF+An
         aspeIHts8zBH54yyt8cCsPCjfYfLSTe2aJCHnvIBUvHWxNbJeFWc6AloYNpO/TWkd0ET
         c7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7WPkdTehgW9sSNpu+KhxUtXcjqffOjrsmBnhQ4xxDXc=;
        b=ViUfN+pJJF7Ue+Dq79KIVxb7bQxDrIegaGtonbKpGZrqsw5dgMVSDSAnoc99A91E09
         2FlIdsdr8L7KZ9OEgtVi6BMzxC4Ln6X9xs0n/Yn6/uhQONSCmczX4NQeuuiJoDIInUkL
         jbtpLtKnO7pnlIea6f9kWMpNAGXmxLZ5/R+oVOZSM0QVTL3XGmxsdc7BWHFaIakZu5JJ
         cvC3Bd0m0FMtfi4IKgJlF6/LC3bMFFpqr4gduMsuvjRPzTesAHRpz/aDE9dD64GX2vXi
         bBEIWHceNEw4gQ/vF9t+HTodNIQsWAPeM5wdTyN/02veW7Hd0L9I3w/6HEu9c7QC5Jl7
         DRDQ==
X-Gm-Message-State: AOAM532ScLca/W2iQf7SdstM2qLlPLkPxSoetxVXbHRuAf6i5F809bv9
        B9+VJshsjfP5V1ba3dD7Ods=
X-Google-Smtp-Source: ABdhPJxihLu/ZXDhO9zwhBiP+O0jC3OT7qH270fWDHxCZOmUE7o3k80yjLaPZiKC8f/15YpDFIYqzA==
X-Received: by 2002:a17:90a:ca98:: with SMTP id y24mr14358099pjt.98.1599357406991;
        Sat, 05 Sep 2020 18:56:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v205sm11042082pfc.110.2020.09.05.18.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 18:56:46 -0700 (PDT)
Subject: Re: [net-next PATCH] net: dsa: rtl8366rb: Switch to phylink
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
References: <20200905224828.90980-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bd776604-0285-1dbc-1a97-51829d037a9a@gmail.com>
Date:   Sat, 5 Sep 2020 18:56:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200905224828.90980-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Russell,

On 9/5/2020 3:48 PM, Linus Walleij wrote:
> This switches the RTL8366RB over to using phylink callbacks
> instead of .adjust_link(). This is a pretty template
> switchover. All we adjust is the CPU port so that is why
> the code only inspects this port.
> 
> We enhance by adding proper error messages, also disabling
> the CPU port on the way down and moving dev_info() to
> dev_dbg().
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

The part of the former adjust_link, especially the part that forces the 
link to 1Gbit/sec, full duplex and no-autonegotiation probably belongs 
to a phylink_mac_config() implementation.

Assuming that someone connects such a switch to a 10/100 Ethernet MAC 
and provides a fixed-link property in Device Tree, we should at least 
attempt to configure the CPU port interface based on those link 
settings, that is not happening today.
-- 
Florian
