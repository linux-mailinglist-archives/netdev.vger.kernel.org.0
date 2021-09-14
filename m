Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB0040ADB6
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhINMas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhINMar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:30:47 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C28EC061574;
        Tue, 14 Sep 2021 05:29:30 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qq21so22618013ejb.10;
        Tue, 14 Sep 2021 05:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lHNifMCUIR7aMWzM8FSwIif6mCro0VhUimeQwpusd7c=;
        b=YLVzlqwM3IqRR/T9eXu4ESA2f3wIj6BWvkUPPViW2vc8bMEKJklckJ7iRgK0fi9DXP
         RiX/nB/eQcGaBYRED5RLFJNDv18mQbjYeJyFDD2Md9uWHJ2yW6kJe/Hg0Bq4g5adtVX/
         YBdF5q28AKb0p9ONfuXwMdxKU7srcNRpQqfnYLD6HXgcd2ARJaPs9qKTL6rqJgjwLDiV
         dF8JrTTcsuTOTLu2iY2RcNL0hVW2FRIEA0IXCNIPOpo9Ctmh44C1Z4joS4nv6bESzamR
         INJYUlPqYixqjqGU1upku9oEIscuu6B3Rqb/tSB2kAb95/ue9zj2akiTv3Q5gMaTUEaj
         rBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lHNifMCUIR7aMWzM8FSwIif6mCro0VhUimeQwpusd7c=;
        b=BY6K7gGVolhF9ebhDqnBPe4jKDZ5Vc8Aew98JH5JUrYlTF4F5G2Q9EHsG2ZT/e3edG
         y+J4MFV33QQ/xge0xJ3Rxvk42ee79TWmsP9CW8E1lroz04z6QDMJV3zgtIC4i7vlKndJ
         onSL/LHmnSTtg3M3QysrGBvxhdgVOqGIZfUG0lZDOeHAHbvn68v7v/XKrkhpnN21xa0O
         NKVsVZCsSHLogMBwn36+ZRukWX7V5gs8gcBYhrh7pq/d+fsA81TAq3N/OlYJqsKcjwKO
         Ws2r3/QwekHlp3Fc/kBBBzol6/ptt9F2hYhNG+CguNouMmBy5ujYuTtU3ElOXHUNPNC1
         xjbg==
X-Gm-Message-State: AOAM533jLk297qXMDIv10UhRADMLN6t2NYWWLU+CfA0Jib49hlmJgA39
        jRFRj6kGQE5q13zgjhcJ1P0=
X-Google-Smtp-Source: ABdhPJwwTOfOhZ7PBQeeQF7ebYLbvl+lQpi+teQ7kvdnjYQYWDdsondqEtzAseGhqrxcGQiRAbLdFg==
X-Received: by 2002:a17:906:90c9:: with SMTP id v9mr16032995ejw.356.1631622568481;
        Tue, 14 Sep 2021 05:29:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain ([5.170.108.60])
        by smtp.gmail.com with ESMTPSA id q11sm5439198edv.73.2021.09.14.05.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:29:28 -0700 (PDT)
Date:   Tue, 14 Sep 2021 14:29:23 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH net-next] net: phy: at803x: add support for qca 8327
 internal phy
Message-ID: <YUCVo4+wS3Q1Tg6Q@Ansuel-xps.localdomain>
References: <20210914071141.2616-1-ansuelsmth@gmail.com>
 <YUCUar+c28XLOCXV@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUCUar+c28XLOCXV@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 02:24:10PM +0200, Andrew Lunn wrote:
> On Tue, Sep 14, 2021 at 09:11:41AM +0200, Ansuel Smith wrote:
> > Add support for qca8327 internal phy needed for correct init of the
> > switch port. It does use the same qca8337 function and reg just with a
> > different id.
> 
> Hi Ansuel
> 
> Please also add it to the atheros_tbl array. It looks like the 8337 is
> also missing as well.
>

Sure will send v2.

> Have you tried the cable test code on this PHY?

Yes I tried, the documentation is very confusionary and with a simple
implementation it looks like it doesn't work at all... In one
documentation version the reg for cable test are described but by
actually implementing and setting the correct regs nothing happen and
the random results are reported. I honestly thing it doesn't support
cable test at all...

> 
>      Andrew
