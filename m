Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C227047C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIRS7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRS7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:59:55 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2501FC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:59:55 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gx22so439578ejb.5
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lfca+Nppnm8OvUnKGMdCXKErfh6VXSaKLiBppnEOFDE=;
        b=HEwDbdKHW+JToHa3FydVp2nTdkBSgNLn0ws2VTmmJkUm9v/FP1rp2pQHnCDborWX1S
         fc911Qn89izEWqrPvb/+kuS+zDo/OaS/8dRE8nYDhmwJ+wCYS1gZvmLay3VB/vIg5+zs
         xqCeSV4chv8KOLJBagLU8yOWARCzu4FxBHidhLtq7MT+S4yRA6dPhEgbc7DDydI4H9r0
         MCG1Dm8aIiBttt7i0apXtmVtiEY7V7v5A6dqKKjNMi68ADnMPiFChhd5cvu1gFtcH6fE
         X5W5xk7w5WNnluCZar4DnMBXQObdK+jNuTEoqJGzuUwNaEoyz+xx2tlddPJVU7egLBLW
         kQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lfca+Nppnm8OvUnKGMdCXKErfh6VXSaKLiBppnEOFDE=;
        b=IogUgciNZc6LFal5HO2G7+lOYQ7pvgnu3rHvjfMdx1rKyrLhCR603eZmRuMDq8VZTV
         zgxJFFhOeWLtailkKP1PofEgDdnLwbMNfFvfniqLB2q7nMKwCY/8PpfGbbaH9ka4vFyu
         YxUkxSPM5RxWCOpQ71kt10iVY+BL8fvW17ErcpS5c01EimCuWEYrcBXE+o6pqKocTb4W
         zZ9IA8ZYPgOWCoSRiWLQi1Ixuc8682PHBk8gPr/xf3Hxorp9RLXIAmVgrzISy7lkoJL1
         Ap+8Cdomd9CAeNL19WmIfVeTER5ZfIWpq4O+S8i4PiHCsLmoo8Nsu6DRcyVJLXoCCL7c
         JvfQ==
X-Gm-Message-State: AOAM532qKK6jwOhYCO2SNs9CaWMil2kLLaftd3DVKaSjXQkmA8jigHZl
        aZi2k37S6sWSYuMQlsCsHl8=
X-Google-Smtp-Source: ABdhPJzGseDLisMo1xwRWA5OnJq1DlqxcG78ztccddaOs3Bi4x6LKJE2Omli0rBWi5zEYCCm3DUefA==
X-Received: by 2002:a17:906:ae45:: with SMTP id lf5mr36415727ejb.339.1600455593641;
        Fri, 18 Sep 2020 11:59:53 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id h18sm2816374edt.75.2020.09.18.11.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 11:59:52 -0700 (PDT)
Date:   Fri, 18 Sep 2020 21:59:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next 05/11] net: dsa: seville: remove unused defines
 for the mdio controller
Message-ID: <20200918185146.5322qugrmapyv7oo@skbuf>
References: <20200918105753.3473725-1-olteanv@gmail.com>
 <20200918105753.3473725-6-olteanv@gmail.com>
 <20200918154645.GG9675@piout.net>
 <20200918155426.rb6mz72npul5m4fc@skbuf>
 <20200918173719.GH9675@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918173719.GH9675@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 07:37:19PM +0200, Alexandre Belloni wrote:
> On 18/09/2020 18:54:42+0300, Vladimir Oltean wrote:
> > On Fri, Sep 18, 2020 at 05:46:45PM +0200, Alexandre Belloni wrote:
> > > On 18/09/2020 13:57:47+0300, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > Some definitions were likely copied from
> > > > drivers/net/mdio/mdio-mscc-miim.c.
> > > >
> > > > They are not necessary, remove them.
> > >
> > > Seeing that the mdio controller is probably the same, couldn't
> > > mdio-mscc-miim be reused?
> >
> > Yeah, it probably can, but for 75 lines of code, is it worth it to
> > butcher mdio-mscc-miim too? I'm not sure at what level that reuse should
> > be. Should we pass it our regmap? mdio-mscc-miim doesn't use regmap.
>
> It may be worth it, I'm going to add DSA support for ocelot over SPI. So
> to abstract the bus, it is probably worth moving to regmap.

Wow, that's interesting, tell me more. For traffic, will you be using
an NPI port, or some other configuration?

And as for reusing mdio-mscc-miim, I think I'll look into that as a
separate set of patches.

Thanks,
-Vladimir
