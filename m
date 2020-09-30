Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F2727EB02
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgI3Oe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgI3Oe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 10:34:56 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54A1C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 07:34:54 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q13so3142096ejo.9
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 07:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TQyEaAgESegXFCVeihxqlmK1ccraTLpe4yE+R7O6ES4=;
        b=g8C07i+8/CBCWmnCF/Zf470TzY9dG+UaSxd5HPjKKc+s5Xybbf78Gf0RA7BVuQkJ42
         D6WsWP7KJr2HKS+ea2MeTC59iKY35k5gBaVgZE4Ha23FR2m+NtufeToA2tHkUGRS/K+F
         lrUnOhDE0fUCQ9gofFxDK+1LJ5q6fZIxBm1KNr+7oPfPd9zYplzodHHpNyjBeYfahDv0
         web9HhQvwnOp0tOuO7Sj84ZNZEpx7EIGiBro5o5LwH52SUn2FPIWi1XHhrz/cY4Pb3Io
         65WESo6SrQ+BEz/R1Ant6dKuvU6LCho4zLgy827NpRCeQZq/tf6ycKDQbAxUnEa4yEN7
         UGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TQyEaAgESegXFCVeihxqlmK1ccraTLpe4yE+R7O6ES4=;
        b=I4HuCW6q+RmJcmfwebVXhY4keg8WLGKMv9C4AkjMeQm8Mby6dIaK8J4UNa1vhPiTPW
         dQyLAghbqXO/D1IJ5R5ZCJ8sIgVLRamihirTjkvI6/CLnRXCT9q11KL5kQ/WftYG4m79
         AWBnBa6ZyDpUjX69Fp0FeWK0ZgcH/ezEAOiZT3l7GG95zlw5FDSMu7WjP3hZ1biNDRBp
         AU/aYdNYGKjbi/V5KGjcBM2UyOHHfyaqnO6ui3tzaGw5id4nUZqqiD0yg8s+kvuNfUiH
         bmHcWBwvuHmmJ4nELk0uScYO11njt2hnlGN0lh9g//kPbRAuU0NFOOvZA5M7uQ/EKtRh
         /YTg==
X-Gm-Message-State: AOAM531MMZdIDWXP0agVNpvR59x5+v3WVcWoijY61aZ1tl5MYO+1o9Z9
        a2bZdRbWlSPvGE6ZEOjws4wFYg==
X-Google-Smtp-Source: ABdhPJzvhXDL0zW16VflvAk75XjPUAikvC8SFao/GpoNvUmMoYokCtT5XN/LeFLdjUJ/VRe8+LPgbw==
X-Received: by 2002:a17:906:d7ab:: with SMTP id pk11mr3085169ejb.472.1601476493597;
        Wed, 30 Sep 2020 07:34:53 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id rn10sm1197054ejb.8.2020.09.30.07.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 07:34:53 -0700 (PDT)
Date:   Wed, 30 Sep 2020 16:34:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200930143452.GJ8264@nanopsycho>
References: <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
 <20200929130758.GF8264@nanopsycho>
 <20200929135700.GG3950513@lunn.ch>
 <20200930065604.GI8264@nanopsycho>
 <20200930135725.GH3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930135725.GH3996795@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 30, 2020 at 03:57:25PM CEST, andrew@lunn.ch wrote:
>> I get it. But I as I wrote previously, I wonder if used/unused should
>> not be another attribute. Then the flavour can be "undefined".
>
>In the DSA world, it is not undefined. It is clear defined as
>unused. And it cannot be on-the-fly changed. It is a property of the
>PCB, in that the pins exist on the chip, but they simply don't go
>anywhere on the PCB. This is quite common on appliances, e.g. The
>switch has 7 ports, but the installation in the aircraft is a big
>ring, so there is a 'left', 'right', 'aux' and the CPU port. That
>leaves 3 ports totally unused.

Understand the DSA usecase.


>
>> But, why do you want to show "unused" ports? Can the user do something
>> with them? What is the value in showing them?
>
>Because they are just ports, they can have regions. We can look at the

What do you mean by "regions"? Devlink regions? They are per-device, not
per-port. I have to be missing something.


>region and be sure they are powered off, the boot loader etc has not
>left them in a funny state, bridged to other ports, etc.

It is driver's responsibility to ensure that. But that does not mean
that the devlink port needs to be visible.


>
>Regions are a developers tool, not a 'user' tools. So the idea of
>hiding them by default in 'devlink port show' does make some sense,
>and have a flag like -d for details, which includes them. In 'devlink
>region show' i would probably list all regions, independent of any -d
>flag.
>
>      Andrew
