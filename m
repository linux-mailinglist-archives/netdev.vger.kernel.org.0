Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E9E2C552C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389743AbgKZNYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389603AbgKZNYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:24:22 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F05C0613D4;
        Thu, 26 Nov 2020 05:24:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id q16so2250500edv.10;
        Thu, 26 Nov 2020 05:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xUQ9iYS8DZZmFJG3hqLV8u3HjCR6GcQ7ha8Yn9D0h2Y=;
        b=Kw0QcVVgvszkH6wATTStoi3oNXb+T6n31svBwuwDpSiCFcFJum/ZInLX/ST27iw53M
         SQ43vuJ3MQbJkx7+4wViSwgxDBeXS8ABn+aYMv3DITa200rxk6WmDyfyBRZdfYUyVLTN
         vTDBG3IoDAbCW4bttz5+EIfC3e49eeqGPwrfOovAl0k6nfzkPU3rzJWsGkpD253/7VwF
         7XeEdxH88RNB+YPKSYzVAfq+VVQZaEdcZvwubHFhYZux2X5ThT1e/b4t4zmmP9tQp2WC
         Smc7/kXl5p4h7EHNg7qQb+bq0AkwTYFJuA9cw1/YJD197/C72bLd4Qsut9/aVhm4jCG0
         twzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xUQ9iYS8DZZmFJG3hqLV8u3HjCR6GcQ7ha8Yn9D0h2Y=;
        b=pS9b/xZFmzajLw7AYtVtT2jwaEE6P/nFvQ2kbhFdE4JM3vRx52BpSXJLQLrZ/f0TIs
         +lvYkaQvJMN7AVEgwvBlbHM2jGX2CjLCOmflz+I6JfezeDI4/j/eiZnzGZdhaRS3IPbk
         h5hAkDfkYQaRkbsEkBCjIZ7QxUjGAxewcv+qpR8ljC10qqsTI26DwPDjraIeK0j26FAd
         P0eAeabyeZZBwyL5y4z05rbnhjnTfgUbC60qbQrfW/f39VKf7mQ2WLOj3pQ7IgWthtoF
         wXpvbRFNM1ZLjofHgpWEpOcMTTaO+y6RSsOm6piDYUXWvS31l+EuajlTi7GEHWM/IKuk
         xrSg==
X-Gm-Message-State: AOAM532WHi3ZgyNmIwIbmDlL/6xnOAHIr/ITFbXfUOmn//J8mIlX7gY2
        4Gud8x2IkZD6FYgdDWZj9gI=
X-Google-Smtp-Source: ABdhPJwVCwjfW/pragoptzjKbLnTua6xsV3kAXviMnijgS59C8xrddDUKW+unl+E0Vg6amIQKbifkg==
X-Received: by 2002:a50:ef13:: with SMTP id m19mr2534718eds.34.1606397060891;
        Thu, 26 Nov 2020 05:24:20 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id b15sm3222314edv.85.2020.11.26.05.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:24:19 -0800 (PST)
Date:   Thu, 26 Nov 2020 15:24:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201126132418.zigx6c2iuc4kmlvy@skbuf>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-3-george.mccollister@gmail.com>
 <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 08:25:11PM -0600, George McCollister wrote:
> > > +     {XRS_RX_UNDERSIZE_L, "rx_undersize"},
> > > +     {XRS_RX_FRAGMENTS_L, "rx_fragments"},
> > > +     {XRS_RX_OVERSIZE_L, "rx_oversize"},
> > > +     {XRS_RX_JABBER_L, "rx_jabber"},
> > > +     {XRS_RX_ERR_L, "rx_err"},
> > > +     {XRS_RX_CRC_L, "rx_crc"},
> >
> > As Vladimir already mentioned to you the statistics which have
> > corresponding entries in struct rtnl_link_stats64 should be reported
> > the standard way. The infra for DSA may not be in place yet, so best
> > if you just drop those for now.
> 
> Okay, that clears it up a bit. Just drop these 6? I'll read through
> that thread again and try to make sense of it.

I feel that I should ask. Do you want me to look into exposing RMON
interface counters through rtnetlink (I've never done anything like that
before either, but there's a beginning for everything), or are you going
to?
