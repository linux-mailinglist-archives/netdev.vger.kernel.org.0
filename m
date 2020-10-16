Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BCD290D52
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411375AbgJPVdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403754AbgJPVdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 17:33:07 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D29C061755;
        Fri, 16 Oct 2020 14:33:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id md26so5238023ejb.10;
        Fri, 16 Oct 2020 14:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dTb8d/UhRfbTMio5+VxFrc4Soz1L65wJS6P9hkKmCXI=;
        b=EE8hQEnErRe33P/yQNAalgzNxwV41iPkKeGjM4FIuNheFMBV7viB9p1yONGf0w8+vc
         h4kBCTMVd64MBcfbhKxOGf9UhqVVarEVsHcBbxVcwXdyLmlgRj35/uG6phfp0I+VzsPX
         u4R4zg8fZrgeVDcn3lq7PufhYkJ1GFRyb83GfeqgH9P/3ivAd/ABzjX0XG+AThE5Pbr1
         1/bIhKaRLJrlbl3uDF1YVscGr8gH/Z1WGNgC7TW+EpdAG+N7iSXHqxPmkmA2whobhVMq
         H+V5bl2AwNn0waHOj5KfzglTv4aq6ESDwTsDbpQ7oOBSHKFb+xSaLWryiF39VDmVLTpq
         5uzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dTb8d/UhRfbTMio5+VxFrc4Soz1L65wJS6P9hkKmCXI=;
        b=E6ajfbZbKKsuyinHD/dsQIAJ0wXMbOeAifo1Q9TS5D2DMHsPbzN4e3BjJpunYLquiY
         XyLltEDFalOMhmLq2Y1dop4FGhA03cbzQDdMEU1cU+gGsgkC135/txkVl62gtM+PhG3O
         4RcbV/vC/zB3SnZ/dSAPwgxnmlctddWiD0QVw+VsWcd1ipVjZn+Z/YoHzxc3FI8bGyOz
         470IMhJg/5kDgnZlXwfVsCgIlfDrukYulla5xK8/ltu7EwrMsF1I4r94Fj5Tom5tAYRJ
         MjOwbDnBi3Lt2EngA5v8dnFkUlqApffsL6N5NoEmo5I+rpt+3NHI3tG70VdDWXFt1N1I
         rkOg==
X-Gm-Message-State: AOAM532YuCMH0jwcNbtyFMtIB5ewbeuqLIQgMBEjPw+5q9GM684wB7b0
        Mu0fs9p+2Tq/kj+g5MwSqWk=
X-Google-Smtp-Source: ABdhPJx9LpbVK1fph6oLdBGqh0y586b8B822Dk9qMPL4IAK9coJwJ4GPACv59wQihPGCmvjK3wasPA==
X-Received: by 2002:a17:906:2dd7:: with SMTP id h23mr6008953eji.175.1602883984383;
        Fri, 16 Oct 2020 14:33:04 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id k11sm2846664eji.72.2020.10.16.14.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 14:33:03 -0700 (PDT)
Date:   Sat, 17 Oct 2020 00:33:02 +0300
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
Message-ID: <20201016213302.yeesw4jbw3rzfluf@skbuf>
References: <20201016162800.7696-1-ceggers@arri.de>
 <202010170153.fwOuks52-lkp@intel.com>
 <20201016173317.4ihhiamrv5w5am6y@skbuf>
 <20201016201428.GI139700@lunn.ch>
 <20201016201930.2i2lw4aixklyg6j7@skbuf>
 <20201016210318.GL139700@lunn.ch>
 <20201016211628.mw7jlvqx3audzo76@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016211628.mw7jlvqx3audzo76@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 12:16:28AM +0300, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 11:03:18PM +0200, Andrew Lunn wrote:
> > 2ecbc1f684482b4ed52447a39903bd9b0f222898 does not have net-next, as
> > far as i see,
> 
> Not sure what you mean by that.

Ah, I do understand what you mean now. In git, that is what I see as
well. But in my cgit link, why would tail_tag be there?
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/include/net/dsa.h#n93?id=2ecbc1f684482b4ed52447a39903bd9b0f222898
I think either cgit is plainly dumb at showing the kernel tree at a
particular commit, or I'm plainly incapable of using it.
