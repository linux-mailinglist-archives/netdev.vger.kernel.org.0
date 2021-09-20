Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2FE412BD9
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhIUCix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243960AbhIUCbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:31:11 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D115CC0610D0;
        Mon, 20 Sep 2021 13:11:26 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v5so64666174edc.2;
        Mon, 20 Sep 2021 13:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=98Yd/K1Bh/3/kN/u7n+eWpJ4IriwcVmS+sgj8ZHAVhE=;
        b=SaQJims3Q66u4dkNl16L3kFOTCHhK2QjTatEpa7vXYYTv5uK1xApAIYBiqdxMsJDUo
         KseyA5OIRPnu0REy/i2AlO47+/QvbGy8J20RTdc/PLBgC8j3/NbW/xZZDQbb9BP3CroC
         gkueHKOWSGeOo+TsJCz2cR5VJ3xx4E4WgLzWvyE+sv7IlBQTRlcuAFSYYnDC/dEB3euQ
         zl9X2P0MGWCGq1Qjc9D8JpLKaTNrMvo5SIFBEjDQfZz6MqOpCmW05P5o0DJv6r5c4buV
         wjw+3Jf0+CpPd3Q4Yo47GyfCbrjEwE/z1f/6wPORer5DN8dAMMe8BKf08lzwFFFWlYxr
         rFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=98Yd/K1Bh/3/kN/u7n+eWpJ4IriwcVmS+sgj8ZHAVhE=;
        b=FhoXPVm7o/M8Lcj3lVf6XzBjZwSiqkBrCNoGIVh+OTIphg+Fs28+3zxCr0PidM1PjT
         2iOVCzcyId4MwNgDtB9gCo/LlixQBDfhHZqGPKDZtIqja9XP6688L7EH1juf7E/m0cyb
         i+p/ClK1LirZvWOJELrSB+cOL0i3W812u2cthmrPdRWM3qNz8LjjXwGVY7vCO4J7L//x
         xLd8X4iCdcXu21tUzgMt+hXJmhtlGSJVZqjccih6wLkjzkWQyoR7DY1MZ2OpIVUBVkUC
         aVaz6upiAnKlWrUSjJqS/5qrWk7RLkyUZdlY8e5jaM6KnFm7TTCoSEUL54NcVU6ZnOgD
         eGCQ==
X-Gm-Message-State: AOAM532oDxNEa7O2PrvbFUWHrVPpuyrHt6laniLp9KLIzyx3hvQYXh7o
        8y/77BauyjMzmtZiDCmOUbo=
X-Google-Smtp-Source: ABdhPJzSfDNUL+PuZQPM6mZ3V3eB07yEHRLqMiP/E6jMcq9ks9IncSRyBxrB4mm/7j9AVhRA61nejQ==
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr8056745ede.74.1632168685035;
        Mon, 20 Sep 2021 13:11:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.gmail.com with ESMTPSA id m10sm6385451ejx.76.2021.09.20.13.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 13:11:24 -0700 (PDT)
Date:   Mon, 20 Sep 2021 22:11:00 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC PATCH 1/2] drivers: net: dsa: qca8k: add support
 for led config
Message-ID: <YUjq1Al7s5fP7PBa@Ansuel-xps.localdomain>
References: <20210920180851.30762-1-ansuelsmth@gmail.com>
 <YUjZNA1Swo6Bv3/Q@lunn.ch>
 <YUja1JsFJNwh8hXr@Ansuel-xps.localdomain>
 <YUjesc5nLItkUNxy@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUjesc5nLItkUNxy@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 09:19:13PM +0200, Andrew Lunn wrote:
> > Yes, can you point me to the discussion?
> 
> It has gone through many cycles :-(
> 
> The linux-led list is probably the better archive to look through, it
> is a lot lower volume than netdev.
> 
> https://www.spinics.net/lists/linux-leds/msg18652.html
> 
> https://www.spinics.net/lists/linux-leds/msg18527.html
> 
> 

Thanks for the links.

> > I post this as RFC for this exact reason... I read somehwere that there
> > was a discussion on how to implementd leds for switch but never ever
> > found it.
> 
> Most of the discussion so far has been about PHY LEDs, where the PHY
> driver controls the LEDs. However some Ethernet switches also have LED
> controls, which are not part of the PHY. And then there are some MAC
> drivers which control the PHY in firmware, and have firmware calls for
> controlling the LEDs. We need a generic solution which scales across
> all this. And it needs to work without DT, or at least, not block ACPI
> being added later.
> 
> But progress is slow. I hope that the PHY use case will drive things
> forward, get the ABI defined. We can then scale it out to include
> switches, maybe with a bit of code refactoring.
> 
> 	  Andrew

Wow... What a mess. Tell me if I'm wrong but it seems progress is stuck.
I can see the api proposal patch had no review from June. Should I put a
message there to try to move things up?

