Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F72E326994
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBZVcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBZVcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:32:11 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F54C061574;
        Fri, 26 Feb 2021 13:31:31 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so17119982ejf.11;
        Fri, 26 Feb 2021 13:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yn3z8555ilXZ27plUdbqV/IXBk4L8y/JmZfJIgzwhQI=;
        b=CD4DRIO4ve4xJd65Hh+FxT6Cmp/En+5bFE52vvVRltQlALKIcO0ezW3L3oKegqx+Xf
         LDe8n1mnTdtAWriH3EFhEzHRxvSlYo6SYQxBioRfrhvl7gcltMSHLdj5BDal9y1+ixvV
         QOJj7JpqTFrJEJgRSZsPyBe4LV7gRbDFaZ4BFVU0YoaT0OUrBho7Jmt1OUAgzpTMjhWy
         OmE7CS2OzcM0mPuhVpQkCAcRnOsxY/aIdNx0c6h1oSzvVGktEqfrAVpDtSauv0mjYXMM
         1RhuhbVL5ypLoAMHsJzF0ZGJ7UwUwortAoQis3QA9iCKeEvj2Dp7WBk90jZxOgKzfrin
         h9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yn3z8555ilXZ27plUdbqV/IXBk4L8y/JmZfJIgzwhQI=;
        b=hrvAZQUGgG6qGl20uJwyLfI4p0So/Ft+2YqQp+E0b6Vx08DPJoqqWMJN1P8QXwK2Vw
         OpIQA5107Z4IluumHcodNmUecqhaY5TmKjgMMhDPpSUnAWUxzP/sMdI4/HcCQpM3m07v
         NaJtn5UukN7Z2aZeNpGb2ZZ6bluljEMLJgW5cyRJpFml1fdlxNT6bBbZ6df/hfxUcsQh
         vqCTvPTgqQPlckb6tSndpqcyFfp2hy1OzvcRtWAUl1TpHYgjIMhOOJi65nMFTJwuscmo
         CX0MQSn8gL0pgLoiD35CAtThg/B5XgN3FRbuooujK4C8VzJaDCb4WicUWQLe4PiJJHnW
         ujOA==
X-Gm-Message-State: AOAM532OCFBuMkNnUFij6sqY13YqHjCmeEAss66sFta2DpgDo6d8dRLq
        Hzxg1LXfLYwfmhHDaf7jUzQ=
X-Google-Smtp-Source: ABdhPJy9Tq7xvLfdxRcCTdv8XqlxoKyoyaws5wsntRvl5epXBWwQX4iYB8S9Ah+flR/agrI9QDgcyw==
X-Received: by 2002:a17:906:758:: with SMTP id z24mr5318243ejb.406.1614375089938;
        Fri, 26 Feb 2021 13:31:29 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id b18sm5907767ejb.77.2021.02.26.13.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 13:31:29 -0800 (PST)
Date:   Fri, 26 Feb 2021 23:31:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: tag_ocelot_8021q: fix driver dependency
Message-ID: <20210226213128.pvtekhkdejzulcpz@skbuf>
References: <20210225143910.3964364-1-arnd@kernel.org>
 <20210225143910.3964364-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225143910.3964364-2-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:38:32PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When the ocelot driver code is in a library, the dsa tag
> code cannot be built-in:
> 
> ld.lld: error: undefined symbol: ocelot_can_inject
> >>> referenced by tag_ocelot_8021q.c
> >>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a
> 
> ld.lld: error: undefined symbol: ocelot_port_inject_frame
> >>> referenced by tag_ocelot_8021q.c
> >>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a
> 
> Building the tag support only really makes sense for compile-testing
> when the driver is available, so add a Kconfig dependency that prevents
> the broken configuration while allowing COMPILE_TEST alternative when
> MSCC_OCELOT_SWITCH_LIB is disabled entirely.  This case is handled
> through the #ifdef check in include/soc/mscc/ocelot.h.
> 
> Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
