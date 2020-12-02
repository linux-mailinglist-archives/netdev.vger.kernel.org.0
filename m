Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAFD2CB18F
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgLBA3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 19:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgLBA3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 19:29:34 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80044C0613CF;
        Tue,  1 Dec 2020 16:28:54 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id l5so238359edq.11;
        Tue, 01 Dec 2020 16:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2dd0iBQsF6Mvl+LUZk4CXOfntTO4gjf84Fzh9kYKAFs=;
        b=UcpudWfkuw2mJU3ShPJ44ebknO5BtDJAdCK13QTCGmMiGbOU75lM7XS29TIbWsmdKu
         YmkdexSUuJG5lzjVTDUHyPaf89QAiP36eXW6gsRsSIy+fQGsHNfm0XHOETl3zX8ntL1q
         r29IS9i8dC9vYKPqRN3bwX2SvBpIcDetH8Ctdg8vXVpsiO9rg/ptGZDZ67ewXjgZ4Gwb
         wV9eKVH3vAnJNdSExI/7+CRc7gYi9uTRhL/Zc1u3vDsGgLiGZ0A9tLijccjuk2NfU2Fk
         /kNqR5waBg6D9Kx9cdc5aH9bYqlCEAixtjkNuj2btJAFAZ1uqeXbNxRVU+53sxdmr4WC
         qZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2dd0iBQsF6Mvl+LUZk4CXOfntTO4gjf84Fzh9kYKAFs=;
        b=RmGZZ2NdNCnUHqwsCR43I4bz6/6+UZzC72Km54Pq+yopiL4rNglV1VbyrOXEjGeXKY
         Xwzhr2DSGudPJURu93ZXcV0P1OHrx7ZDeRkRxg+pkchrz+Ri8a8nOjzsGYyZRe3q+Q5k
         +75VkO7MFAPD4+ASDqiAQVqNGdfvRwL3w0eHOXuPYJu4j1+iNPu8Fo7J0YSyo1/sjMUk
         E7kxMYRY1Hx9Uhmkyb2loE25O6BamJIDM5gEfa1YzdyRcMBOkUC5NiEWaNsSI73XGxRE
         W4pluHhkcMSMUbjLf0yr9FKsA1e7JKpzhuyuP8rlqsbySWiEkitBBdELk/nwrN4aliuW
         XCKw==
X-Gm-Message-State: AOAM5305rDNbyQpyqs7adPK4Fnw+PoGeOtaJhemiyVFp9BCeA1OA6PcL
        R95EJy4gS1HUPQnrH30xWKE=
X-Google-Smtp-Source: ABdhPJz9otjMtF2sfm3ofGx6lV1f1gG1rMHDFimQzFI3Y8STzmpZrEVfc10sYE4TW61zEbh1dcBSfA==
X-Received: by 2002:a05:6402:6:: with SMTP id d6mr162688edu.31.1606868933210;
        Tue, 01 Dec 2020 16:28:53 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id f18sm50494edt.60.2020.12.01.16.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 16:28:52 -0800 (PST)
Date:   Wed, 2 Dec 2020 02:28:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201202002851.z63jdsfqxdkjb46k@skbuf>
References: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127204714.GX2073444@lunn.ch>
 <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127212342.qpyp6bcxd7mwgxf2@skbuf>
 <20201127213642.GZ2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127213642.GZ2073444@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Nov 27, 2020 at 10:36:42PM +0100, Andrew Lunn wrote:
> > Either way, can we conclude that ndo_get_stats64 is not a replacement
> > for ethtool -S, since the latter is blocking and, if implemented correctly,
> > can return the counters at the time of the call (therefore making sure
> > that anything that happened before the syscall has been accounted into
> > the retrieved values), and the former isn't?
>
> ethtool -S is the best source of consistent, up to date statistics we
> have. It seems silly not to include everything the hardware offers
> there.

To add to this, it would seem odd to me if we took the decision to not
expose MAC-level counters any longer in ethtool. Say the MAC has a counter
named rx_dropped. If we are only exposing this counter in ndo_get_stats64,
then we could hit the scenario where this counter keeps incrementing,
but it is the network stack who increments it, and not the MAC.

dev_get_stats() currently does:
	storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
	storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);

thereby clobbering the MAC-provided counter. We would not know if it is
a MAC-level drop or not.
