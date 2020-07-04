Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC55214710
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 17:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgGDPux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgGDPux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 11:50:53 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A81C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 08:50:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d16so23846168edz.12
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 08:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GYsAYR1te6//pNcW6gB1ad57K81ey1g6bKnX5N1BXpA=;
        b=rMsUKh+aJuuqg+Y0mZgTRsrhnACLKkhOvsJXEelYinCWH8cjUmeLWMOvKkFfGJwGb5
         QSy8A18D0eHAOo1EdT0JJGtZ/vdhJVfBoi9JXbNHMxvl6LKQ101+ni8Cg2LIWJNyTSE0
         JHf8MOnZOQnFVYIeG6iCKmnYV89+oeQwkTOy48SBzi8l5NGoUrlbDGQAEiTIMPqP0Rwf
         zGlX0VgJ63Lq6VjWe9c3HaQqD0uNmMuVR2eKJwigJMMzQYkj97rvjWZcLJ4LvadBpX6T
         OGNXdLqFeHclIbL5AyDuAqg1mdpuUo2DZpoQy8KeAnVlH8qcZUaamNZYp0On0G7UmXU0
         ZYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GYsAYR1te6//pNcW6gB1ad57K81ey1g6bKnX5N1BXpA=;
        b=dkoTuPF0yVkp050+1Mc1kLh9lP6OgPJye6NZvB6GBBuJO6kRSrRB0ISoNcTAmxsO1I
         6ZUo1YNnDyoHRHQTmyy7F5boP20GdxHS04qAmaKet85NCPJprv1lyHoiJa6I+RUzzHfz
         JikUNZUm9NEeb2lPnOoNI3TNHq336P8WLueAhqlvwFUNQ9bnf84ATAxzx/Jz6afBGffU
         Et0sWUq4S6LK2MmZOoUJ++Ey6uXWeSh2QPyuk073ahJ26pcPEOK3daNU96s6Jt8qyFB2
         HEyvPyUY4yEQeDsntVHaJDaIIcUYSLwcKcK94GTc09/tz3Eb02WPstJAP6FApzByYctd
         o3BQ==
X-Gm-Message-State: AOAM530DkmDKANn1mwE0arftTILIsi5SMRGaQAYSdvFPspq92DbKTb0M
        qmc0hmaPfpqeL5KOclyrpkU=
X-Google-Smtp-Source: ABdhPJzT+e6/sR5hkdhiC4Gsc3zACVNv6egXoDn+BvEqja95+whyLmy1Lu9wBTUmtJJK9R2ba359tw==
X-Received: by 2002:a50:f187:: with SMTP id x7mr44338854edl.59.1593877851403;
        Sat, 04 Jul 2020 08:50:51 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x64sm18774351edc.95.2020.07.04.08.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 08:50:50 -0700 (PDT)
Date:   Sat, 4 Jul 2020 18:50:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 5/6] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200704155048.nsrzn4byujvkab3q@skbuf>
References: <20200704124507.3336497-1-olteanv@gmail.com>
 <20200704124507.3336497-6-olteanv@gmail.com>
 <20200704145613.GR1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704145613.GR1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 04, 2020 at 03:56:14PM +0100, Russell King - ARM Linux admin wrote:

[snip]

> 
> NAK for this description.  You know why.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Sorry, I cannot work with "too busy" (your feedback from v1) and "you
know why". If there's anything incorrect in the description of the
patch, please point it out and I will change it.

There seems to be a disconnect between what I thought this phylink
callback does (and hence the reason why the code I'm deleting exists)
and what it really does. That disconnect is explained in enough detail
that even somebody who isn't intimately familiar with phylink and/or
clause 37 AN can understand. Then a justification of why deleting this
code is, at least given what we know now, the right thing to do.

I am really not trying to make any more waves than necessary, so please
help me to formulate the description in a way that is acceptable for
merging into the mainline Linux kernel.

-Vladimir
