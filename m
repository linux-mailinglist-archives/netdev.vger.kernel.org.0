Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B9B343072
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCUBDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 21:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhCUBDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 21:03:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC7C061574;
        Sat, 20 Mar 2021 18:03:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h10so15102649edt.13;
        Sat, 20 Mar 2021 18:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sYxUtyAOLdJkhobYZlH8F8gX4p7P2TgZmZ5PNFmnT+8=;
        b=THiVEz36og5hrIWzcGXbTKxvDjd6DAIASZSFfxncTsxKBScDakrsCiRVQhJ66EODVS
         pELwi2ZxITpsooxJqz8rgSY15VEsvp4H9AMxwmFifDlmUWgmG6Wl4eEoAecertY4mGfO
         p0vVip0MeA0jtil8u8WRIhyLIF5cuS86HyUAja5BMyyE0HcCA8+8uAcceUC4Vx/jJtJ8
         L6Y9nIXXRDoUiHQ2bDLx2L5EaJ34TIPhWZWb8MbP4En2La9N8QLaVlgQ/b2wsshr6jgD
         o4MxfjlGggQlrPJM88mirTZQ+5yURySzlq4mvRFb4ZhpaN+yVT+WjoZQlostpQKNavU4
         cyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sYxUtyAOLdJkhobYZlH8F8gX4p7P2TgZmZ5PNFmnT+8=;
        b=r7gJF0tkA93nW+c2HM8vV+rlXBtQNjxg5nyaa5RY6xreS3/NHQPaJcQKs34N3FHpof
         UoM+3q21PpsvyTTbtYXb1t0z/cIDMK/OJD9rLBmNjaJ1ah+ParYoZx/LKqUjue90PHd6
         0N0Ju8mq7Gr5qqJzPF84kDdPQaIrJX/vl3XdgSxgOMBocbK/QJmSDUbKSMxnb3vedhT6
         ckcSkkq16+BD5fpPSq9OfWHHLAcB4tSBTUqgtHA2yimBuCk1bDXiBMuz9Qh8KyW3V2Y6
         k7vriELupRgNH4/hezgyWvdCLRwdjGC80SQ0JkUfr/X5zEWhKaDi+JxUPuvsK+twRh4L
         w7iw==
X-Gm-Message-State: AOAM5327lpJ55g8H8SmyhoF42JCSHeQUw8s9p8Q7mWT26xg6QeaBweR/
        SBaAatZFqQ6Rf+t49FclPFc=
X-Google-Smtp-Source: ABdhPJyj8vbEU+wPreri1LsmqncKXNJmYOKxeCZk3J/7RMT9Y3axyli/378Z0OKeN4CkI6cXSzLefw==
X-Received: by 2002:a05:6402:c88:: with SMTP id cm8mr18047826edb.62.1616288596424;
        Sat, 20 Mar 2021 18:03:16 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y24sm7339185eds.23.2021.03.20.18.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 18:03:16 -0700 (PDT)
Date:   Sun, 21 Mar 2021 03:03:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] dsa: simplify Kconfig symbols and dependencies
Message-ID: <20210321010314.mdbvtfc3zangtqgi@skbuf>
References: <20210319154617.187222-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319154617.187222-1-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 03:46:30PM +0000, Alexander Lobakin wrote:
> 1. Remove CONFIG_HAVE_NET_DSA.
>
> CONFIG_HAVE_NET_DSA is a legacy leftover from the times when drivers
> should have selected CONFIG_NET_DSA manually.
> Currently, all drivers has explicit 'depends on NET_DSA', so this is
> no more needed.
>
> 2. CONFIG_HAVE_NET_DSA dependencies became CONFIG_NET_DSA's ones.
>
>  - dropped !S390 dependency which was introduced to be sure NET_DSA
>    can select CONFIG_PHYLIB. DSA migrated to Phylink almost 3 years
>    ago and the PHY library itself doesn't depend on !S390 since
>    commit 870a2b5e4fcd ("phylib: remove !S390 dependeny from Kconfig");
>  - INET dependency is kept to be sure we can select NET_SWITCHDEV;
>  - NETDEVICES dependency is kept to be sure we can select PHYLINK.
>
> 3. DSA drivers menu now depends on NET_DSA.
>
> Instead on 'depends on NET_DSA' on every single driver, the entire
> menu now depends on it. This eliminates a lot of duplicated lines
> from Kconfig with no loss (when CONFIG_NET_DSA=m, drivers also can
> be only m or n).
> This also has a nice side effect that there's no more empty menu on
> configurations without DSA.
>
> 4. Kbuild will now descend into 'drivers/net/dsa' only when
>    CONFIG_NET_DSA is y or m.
>
> This is safe since no objects inside this folder can be built without
> DSA core, as well as when CONFIG_NET_DSA=m, no objects can be
> built-in.
>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---

Thanks!

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
