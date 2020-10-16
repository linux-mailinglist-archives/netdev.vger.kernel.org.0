Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB25290CAD
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393596AbgJPUTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393350AbgJPUTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 16:19:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1175BC061755;
        Fri, 16 Oct 2020 13:19:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id md26so4941870ejb.10;
        Fri, 16 Oct 2020 13:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FA2VjoAOVa3zI6J2opQjTrtgww1jO5eNYFEdgCxHx6w=;
        b=M5YRjTwHGKRGb6866ns3452jEWgGy0LzwHZQVBj772EGLvAHUtvMAX7i/vTW9IJ6El
         XWqIJVLmSsP4h+EnjED61eOct26U3+UJftJHcLp32bY8okG7TkKTTY+uigTAIIL7AklB
         sjwOqHFrE9x8u3LcmBKQCd6Zt1lvFtEXAQYQ4Womo0WG+A+OyQhnPh5ejyLfsBoT0pEM
         awai1DaWmcpx+ISh3HqllJWBm0a9QklxwTebmPf+5MYzyp+abu+XUa5wczuImyg/oEn8
         snO0xhZjNqjf0YF4/pz+ALL74MMjeacMOGzJp/NmEl/EVXOR2IyRPNWAqw9Sv3zv5I2D
         jV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FA2VjoAOVa3zI6J2opQjTrtgww1jO5eNYFEdgCxHx6w=;
        b=oY019FUpIDFAtYtEskYhYG8NVo+GCw+hiZ+ml37iY33piRM/sw49DzsMmUsRRaXIIT
         eFzMfTTJxQuIDRRVIYhk50D0YWY7sM4TLalVht7Q1bGnUXUIPqyDHudXw6iSX4zTzsSn
         4XrzDh5Igx//7aYeyWZsgeMGhjwYEtyi+k99+Y3+8m/V6rDDf2ZZouvatvyXspl0rpW1
         LOOpSVxM5vFSXK8wvIFVWu5K7DY5rAf8ZFmMyFblUS4yE+keTQYrFQPy+KGNJUDr4yv1
         ehGNXBcUbETfbrKvlE68MtF3YkAjutZ8Ed8tXADi0CJWAutRMRCuM/kPH5ThYhDwp7aC
         48ow==
X-Gm-Message-State: AOAM5337M6ZVZ0P32nI9FQB9bHsNnA2UA2k1koYuQTd/XoW3/7U5oYdD
        4d/wmRlq08wZzaifFmHKhUQ=
X-Google-Smtp-Source: ABdhPJycfqqRhRIEfhQWm6SCqKIuDZRiZgFaUAbcupXtKXwp6RB2pk9D65/0sSaJlebhr+Z7xt4Rmw==
X-Received: by 2002:a17:906:11d3:: with SMTP id o19mr5381348eja.287.1602879572776;
        Fri, 16 Oct 2020 13:19:32 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id v23sm2555507edq.86.2020.10.16.13.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 13:19:32 -0700 (PDT)
Date:   Fri, 16 Oct 2020 23:19:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kernel test robot <lkp@intel.com>,
        Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        kbuild-all@lists.01.org,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: point out the tail taggers
Message-ID: <20201016201930.2i2lw4aixklyg6j7@skbuf>
References: <20201016162800.7696-1-ceggers@arri.de>
 <202010170153.fwOuks52-lkp@intel.com>
 <20201016173317.4ihhiamrv5w5am6y@skbuf>
 <20201016201428.GI139700@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016201428.GI139700@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 10:14:28PM +0200, Andrew Lunn wrote:
> On Fri, Oct 16, 2020 at 08:33:17PM +0300, Vladimir Oltean wrote:
> > On Sat, Oct 17, 2020 at 01:25:08AM +0800, kernel test robot wrote:
> > > Hi Christian,
> > >
> > > Thank you for the patch! Yet something to improve:
> > >
> > > [auto build test ERROR on net/master]
> > >
> > > url:    https://github.com/0day-ci/linux/commits/Christian-Eggers/net-dsa-point-out-the-tail-taggers/20201017-003007
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 2ecbc1f684482b4ed52447a39903bd9b0f222898
> 
> > Is the test bot being a bit "slow" today?
> 
> It is using the net.git commit from yesterday afternoon. net-next got
> merged into net yesterday evening, so it is a bit behind, but not too
> far behind.

Exactly. The sha1sum it uses _does_ contain the tail_tag member inside
struct dsa_device_ops. What's it complaining about?
