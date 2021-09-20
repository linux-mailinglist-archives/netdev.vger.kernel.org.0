Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03AF412BD7
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350990AbhIUCiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238347AbhIUC02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:26:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F13C1E3251;
        Mon, 20 Sep 2021 12:03:34 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c22so65008126edn.12;
        Mon, 20 Sep 2021 12:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o23tvqbeMHj1qDEUMi/8ydwOa2gB4JJoEnpgkeFEwlA=;
        b=h1YrLcb5PocnjEZsPr2k3GDjzjtT5/qYhF/nssyKwKDrEda+NE/KwxYxK1x6CMTjcF
         iQt4+gGmlwtdMKgOTZFV5DCP96ihL6Vju0rwZ5Vu/85Gj2sJVRuBiKOuhpMPBG4FNhUJ
         adBjc3CJfr/IrHIYFo4Wgc5G86oB6CsRtt7BfU3d1fr7gJT/cixid9vLrscEvQPU45pv
         mUSt46I/P1jyLwuedkdeP4XrkovhYPXIZSM3ATIzOG1ZSoS/0pLMcu7iTYdhmccVQjHd
         iKeRYsqymPb3BLJF9ksKa9nx9+Dl64HwWWHy0Nv4E0fa3y08LMGak1h18bf0fc9j9+HL
         Hdsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o23tvqbeMHj1qDEUMi/8ydwOa2gB4JJoEnpgkeFEwlA=;
        b=vv0MQpJMFzlgOqzurKmRd6l97PsK8YHqiPidV/kIOQ9B9Tvbl7KG7rsZyVTivfp9Eh
         h3qp6RaMkYl9cVbs51M5nkUhoQ3tEXsfVQ23OduDSF6esp85pQ27uGuWL2sblxYI8bfK
         psMFzcUrz1q/arZMC+eGe7LZDh6gO/6K5byuJM3M5cZczcNw3Q8r8v2oxX+FIa2q0yYF
         JmjPU46BptS9dpyguL/a9yv0ApXaBUfGiDUaU/6D+IuIq/72hu8guNcVbzUBDMuxwaB8
         sGCaUW0ux8B1CcLwLpTaihJuLjVMDk4uvIXP4MCrFjpAsIVqco/eSCoRymffTW0qmLnv
         +hRQ==
X-Gm-Message-State: AOAM532AF5uMvXTE3+SGm1wXuvo7YD6WuL2AGw/p8crrkRKov9n3n+UD
        4sMK9uXCC7EaQNW09pFscDc=
X-Google-Smtp-Source: ABdhPJx6rA7X1b39sQpaJioTLCSknE8y1KtajsuCK3X7B6AUNrG5u9KjQykJuwmxDJUAyjPgrpFxQw==
X-Received: by 2002:a50:d8ce:: with SMTP id y14mr25040166edj.92.1632164613284;
        Mon, 20 Sep 2021 12:03:33 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.gmail.com with ESMTPSA id k12sm6484046ejk.63.2021.09.20.12.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 12:03:32 -0700 (PDT)
Date:   Mon, 20 Sep 2021 21:02:44 +0200
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
Message-ID: <YUja1JsFJNwh8hXr@Ansuel-xps.localdomain>
References: <20210920180851.30762-1-ansuelsmth@gmail.com>
 <YUjZNA1Swo6Bv3/Q@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUjZNA1Swo6Bv3/Q@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 08:55:48PM +0200, Andrew Lunn wrote:
> On Mon, Sep 20, 2021 at 08:08:50PM +0200, Ansuel Smith wrote:
> > Add support for led control and led toggle.
> > qca8337 and qca8327 switch have various reg to control port leds.
> > The current implementation permit to toggle them on/off and to declare
> > their blink rules based on the entry in the dts.
> > They can also be declared in userspace by the "control_rule" entry in
> > the led sysfs. When hw_mode is active (set by default) the leds blink
> > based on the control_rule. There are 6 total control rule.
> > Control rule that applies to phy0-3 commonly used for lan port.
> > Control rule that applies to phy4 commonly used for wan port.
> > Each phy port (5 in total) can have a maximum of 3 different leds
> > attached. Each led can be turned off, blink at 4hz, off or set to
> > hw_mode and follow their respecitve control rule. The hw_mode can be
> > toggled using the sysfs entry and will be disabled on brightness or
> > blink set.
> 
> Hi Ansuel
> 
> It is great you are using the LED subsystem for this. But we need to
> split the code up into a generic part which can shared by any
> switch/PHY and a driver specific part.
> 
> There has been a lot of discussion on the list about this. Maybe you
> can help get us to a generic solution which can be used by everybody.
> 
>     Andrew

Yes, can you point me to the discussion?
I post this as RFC for this exact reason... I read somehwere that there
was a discussion on how to implementd leds for switch but never ever
found it. Also i'm very confused on the node structure on how to define
leds, I think my current implementation is very verbose and long.
As you can see this switch have all the leds controllable with a special
mode to apply some special rules (and actually blink by the switch)
So yes I would like to propose some idea and describe how this switch
works hoping other OEM does the same thing. (I'm very negative about
this part)


