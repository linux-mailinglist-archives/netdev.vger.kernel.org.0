Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBACA2C6CE2
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgK0V0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbgK0VXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 16:23:48 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E79C0613D1;
        Fri, 27 Nov 2020 13:23:46 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id a16so9393496ejj.5;
        Fri, 27 Nov 2020 13:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DDExtL66ZCh0FGtSKUuRJn/grVzmZKlMBYgKET4VO1w=;
        b=ES9LgO+x0Fo4f7NZamulYy3bFgjqttQgJAWBPP1oCJo3MiilDaQv1KAz2vO9A9JlmM
         g38yr6RsTml50xamIOAD9czwI3N7azZK8qUvaZufklkcb73QUg4D5HMBnqMtmyD5GYf1
         NeiJqz2Bp2h3Q0jNwBudTqLVA5RZ3vahNNGI1k457rf6oc4tuqvBF4GzQTWDQd9b7t+p
         qVwvw2mQKN/ZOqQPL2fil/LOfcEHqRNAPZY24Hc3nOT4YDE/ISOdPUzz5yXTJo0uY3Dt
         xaRVcNo70EY6QkNz/vSjB+ttfzSqBIQ4+NtXjhkfe54uFQa6tMayEoa8sSS+fCgisp7x
         47wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DDExtL66ZCh0FGtSKUuRJn/grVzmZKlMBYgKET4VO1w=;
        b=VmTOwRXOhV2dtcqEgHD+5/F+7X0peDuyHDkkYViP6mUgs9JwZHfQtbOGEuzOoMoPOK
         qFvztHdah4uaupQWjK8P/ryQXR7Hq8e2Sd14obGIDa2Dqg+SizGrH+KCyQQlcvk2kxvu
         fy80csP3j0UfEbo22dkhn++DFY5lzILxX/VUi80LvXR1lCuyakNeSN0C7q3aG1jFKQ8Y
         xdWWB5se7feA91WEEprXru0GYAGphkhz8TdsEr+ZKRT9WuCS7i+uUbgrhqoi8zWDnhYS
         lojLdJRnXEDpBWHjPvLFW+2A7W36I9n5GVmus9a/WGhtQ2O//VNqAW9qPUBLFyfTJUuj
         iV+A==
X-Gm-Message-State: AOAM533Xny0IeKzB3E/GHiY3KLrKClDzHvHZSRSDfXQb0577iaC/SSrj
        9Mtymu1T0j/VvugMgRtpgpc=
X-Google-Smtp-Source: ABdhPJzfzjM2/lOaGzmt9K70CIiOsFJ0tuXhC4u2gEDSPwxrGXISkRRuzARSlmt/T5cnNzL6UYl7FQ==
X-Received: by 2002:a17:906:7f10:: with SMTP id d16mr10011162ejr.104.1606512224625;
        Fri, 27 Nov 2020 13:23:44 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id c8sm5652114edr.29.2020.11.27.13.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 13:23:44 -0800 (PST)
Date:   Fri, 27 Nov 2020 23:23:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127212342.qpyp6bcxd7mwgxf2@skbuf>
References: <20201125193740.36825-3-george.mccollister@gmail.com>
 <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127204714.GX2073444@lunn.ch>
 <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 01:13:46PM -0800, Jakub Kicinski wrote:
> On Fri, 27 Nov 2020 21:47:14 +0100 Andrew Lunn wrote:
> > > Is the periodic refresh really that awful? We're mostly talking error
> > > counters here so every second or every few seconds should be perfectly
> > > fine.
> >
> > Humm, i would prefer error counts to be more correct than anything
> > else. When debugging issues, you generally don't care how many packets
> > worked. It is how many failed you are interesting, and how that number
> > of failures increases.
>
> Right, but not sure I'd use the word "correct". Perhaps "immediately up
> to date"?
>
> High speed NICs usually go through a layer of firmware before they
> access the stats, IOW even if we always synchronously ask for the stats
> in the kernel - in practice a lot of NICs (most?) will return some form
> of cached information.
>
> > So long as these counters are still in ethtool -S, i guess it does not
> > matter. That i do trust to be accurate, and probably consistent across
> > the counters it returns.
>
> Not in the NIC designs I'm familiar with.
>
> But anyway - this only matters in some strict testing harness, right?
> Normal users will look at a stats after they noticed issues (so minutes
> / hours later) or at the very best they'll look at a graph, which will
> hardly require <1sec accuracy to when error occurred.

Either way, can we conclude that ndo_get_stats64 is not a replacement
for ethtool -S, since the latter is blocking and, if implemented correctly,
can return the counters at the time of the call (therefore making sure
that anything that happened before the syscall has been accounted into
the retrieved values), and the former isn't?

The whole discussion started because you said we shouldn't expose some
statistics counters in ethtool as long as they have a standardized
equivalent. Well, I think we still should.
