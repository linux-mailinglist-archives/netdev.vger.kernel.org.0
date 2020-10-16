Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58AE2908B4
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410279AbgJPPnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 11:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408621AbgJPPnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 11:43:40 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F07DC061755;
        Fri, 16 Oct 2020 08:43:39 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dn5so2898846edb.10;
        Fri, 16 Oct 2020 08:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s2fSUP2pQdigm2ZLQlG4rY4cdhTfJVKo36iXzX3SphQ=;
        b=CwwmpyGHUdvW5G3CD2mILb5z8eCd8MlwF8iFr/kiDkf61CJ1c6N8vSaJXB48SNepI9
         MhfXJ44EJAWtjN1pEYBTdF7JTc09eB4OU9KM6c3GWNMBLfmo5114B30IzgFHRhUy1YeW
         L5CtZEhBCGYvYzxF+NOwpXE0eHVFsZUIkLRewRthjZfzdM0oL4aPt089jhiVjXncZa+k
         a2H6lp4nrf4UYWXziJrbiM57O2Cxhh+QvAbJs7Q9EaSo0Xi1TYzxLKvzHSK120Xxwg2P
         QCuiIwkC9LiW5c3Zlql/N/3jdtun8tlB14xhWj4FXoe4wt7N0kT73zz3A3G7R+E4phR/
         B6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s2fSUP2pQdigm2ZLQlG4rY4cdhTfJVKo36iXzX3SphQ=;
        b=eItHbTHdig8qt5l79TvWqcRI2bWrvCloXqXIHtl5fznC/ql9eBRu1elTVt4Tzp/pnP
         6zYFJn7MDGIfNQsHlAR9CIj9+QnMZl8yelWz7FSQophi8LLslUaGJeZBC420S6os2Sis
         WZTa3sJCTTHKl5Fkx2xLF7mYxC2S3lhAFP9WJl1kFO7YhqljbxYFVbUD4XD/TrWTBuVm
         vqCaexxwT/Hy9Ti4ZPfV5hpyPcMPXU6GBSI25vk1dgN2gw3vUrLPkZ33T7gvKIClLEV+
         aZsBvABR8Qn9WVaD0oBQ3LgOGCfD/ydY0NHNyoshv4bMT8asbwKU0uHpO/Ct4eKr6Lat
         FpvQ==
X-Gm-Message-State: AOAM5331/oiC8nLlyfr7a6nR/VOH3B1l+QHwBtqao+e8+yxpOYKvbbrR
        Ol40ZW1P4jW52Hac6hePrqk=
X-Google-Smtp-Source: ABdhPJwh1upbg2EI+r8plArJ5CJKA5Whi255Kuf+tBSr5OHy3561x3iS/ffvadWZPJKK0Zgl9s0qeg==
X-Received: by 2002:aa7:d394:: with SMTP id x20mr4753622edq.14.1602863018342;
        Fri, 16 Oct 2020 08:43:38 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id rs18sm1923459ejb.69.2020.10.16.08.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:43:37 -0700 (PDT)
Date:   Fri, 16 Oct 2020 18:43:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201016154336.s2acp5auctn2zzis@skbuf>
References: <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
 <20201006113237.73rzvw34anilqh4d@skbuf>
 <87wo037ajr.fsf@kurt>
 <20201006135631.73rm3gka7r7krwca@skbuf>
 <87362lt08b.fsf@kurt>
 <20201011153055.gottyzqv4hv3qaxv@skbuf>
 <87r1q4f1hq.fsf@kurt>
 <87sgaee5gl.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgaee5gl.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 02:11:06PM +0200, Kurt Kanzenbach wrote:
> When VLAN awareness is disabled, the packet is still classified with the
> pvid. But, later all rules regarding VLANs (except for the PCP field)
> are ignored then. So, the programmed pvid doesn't matter in this case.

Ok, clear now.

> The only way to implement the non-filtering bridge behavior is this
> flag. However, this has some more implications. For instance when
> there's a non filtering bridge, then standalone mode doesn't work
> anymore due to the VLAN unawareness. This is not a problem at the
> moment, because there are only two ports. But, later when there are more
> ports, then having two ports in a non-filtering bridge and one in
> standalone mode doesn't work. That's another limitation that needs to be
> considered when adding more ports later on.

Well, then you have feedback to bring to the hardware engineers when
switches with more than 2 user ports will be instantiated.

> Besides that problem everything else seem to work now in accordance to
> the expected Linux behavior with roper restrictions in place.

Ok, that's great.
