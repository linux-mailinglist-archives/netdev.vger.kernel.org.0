Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C839946BBBA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhLGMwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhLGMwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:52:23 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4308BC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 04:48:53 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x6so56356155edr.5
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 04:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cvqKW/p9TrW95sOWMZZfcLjCNwhhZz8pdyyQ/jVIu0I=;
        b=Io0wTeY7warTOvPWRq1LVpemFPQgPmiBLt5p0DAGLp+utCf03CORq5CrNhQDrKO9s0
         nuOBpR6OeJ8Q9wgOAkN7k4VXDidiS9R2NuWHBCP4A9dbqWFZBcqP/Cgt8+JSNmaxb5IN
         qhZQz0CPDKKNhBOJ3JtG9VWY7SvAxqcjOpvB7yVaiVQS272oo4KAMQc8LdjegU60jHTJ
         djghYqI6a87TXdgdxuETkS2a/kJXh1QRcX+L9WTiIFShaIzxGUn7ep1CvwjZop0OH+tP
         D7DDtlh4t+z7wldbcUhqqGQbhtir3BYhue/SUmRJ9J0q8lq7M+c8gfjPah18cqlCjtOf
         O5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cvqKW/p9TrW95sOWMZZfcLjCNwhhZz8pdyyQ/jVIu0I=;
        b=wlRnYI4rO2Yb8Z4CVknllHFT8/yoRd/NFTNonG+XjvlCB3UjWnC3X1uPUfBXQ01Bn4
         i4SKU/3oBf97gis9VRLT64ZRmSsJZ9IEg48yPVOsA6XbS/pMnrW76mcI5DJuoZ0dPVYc
         FYiMze5uazyFP067O8nISmvclzd5pgO5UEybT3d6Ygr25JRBFv+udGw0a7idTPRXBdiV
         6ydzRoXOhtF4AzghYaPSWVrNKz/+X9a12PvMFA+saN2H7kPFu+AiK63dR96RwEIJ93dN
         zKK+LbqxadslH1BPpROsLtsDWHmAp2TCy1E3my801K+j8FnyBIsM/bSDgC7grnwttCjs
         tJHQ==
X-Gm-Message-State: AOAM533vSSh7O6iqP2wqN/EsLTMtnpdcpQzIGPZAQFDt3P+VJQjO8ZeH
        8yKm8GduVoPYV2eMvF/SEcc=
X-Google-Smtp-Source: ABdhPJx80/bBIYSnY8zgdSW0qKgg5RoC7iMdrdPn6FUirHKpeJf4VPHXC2u3h5htELXif9RuR/YA8Q==
X-Received: by 2002:a05:6402:d09:: with SMTP id eb9mr8773172edb.216.1638881331723;
        Tue, 07 Dec 2021 04:48:51 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id m6sm11042060edc.36.2021.12.07.04.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 04:48:51 -0800 (PST)
Date:   Tue, 7 Dec 2021 14:48:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211207124850.qa2o223lesux637a@skbuf>
References: <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <20211206215139.fv7xzqbnupk7pxfx@skbuf>
 <Ya6NF9OxSmLO9hv+@shell.armlinux.org.uk>
 <20211206234443.ar567ocqvmudpckj@skbuf>
 <Ya7BvzxrpJT9dvDA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya7BvzxrpJT9dvDA@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 03:06:55AM +0100, Andrew Lunn wrote:
> > > mv88e6xxx_software_reset() does not fully reinitialise the switch.
> > > To quote one switch manual for the SWReset bit "Register values are not
> > > modified." That means if the link was forced down previously by writing
> > > to the port control register, the port remains forced down until
> > > software changes that register to unforce the link, or to force the
> > > link up.
> > 
> > Ouch, this is pretty unfortunate if true.
> 
> Come on. Do you really think Russell is making this up?

I didn't say it isn't true, I just lacked the energy to research this
too last night in the documentation I happened to have. I did find that
quote about the SWReset bit now.

But I did also write a full email after that phrase, making an argument
that still did hold if what was said about the mv88e6xxx resets was true.
