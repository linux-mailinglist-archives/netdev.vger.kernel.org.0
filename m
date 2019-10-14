Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B20D6633
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbfJNPgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 11:36:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35940 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbfJNPgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 11:36:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so10613038pfr.3;
        Mon, 14 Oct 2019 08:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YONmzZ+a8NEL+EO7tC6G4AKBcj7OBsdFo9WkRSi+L14=;
        b=qbGxe42ZmeHJMm64Rh3UQXqzbNf3Ily+Vb5dFC58pJ620supxH+jnsU01eYvIcAwZS
         Y2xhdq4TLu9JShB33QHbwAw2frrJHoSuUEuABelFq7Y7re01hTir8W4nQqo+pvu28mI7
         wN7QK8G8bbt1fuFkd+Iaj1hHNXDD13irVf9Vq/Sh4ERWDxwwRwW4+GdMWN7WSPAwagBv
         VoK27dqER7BBEfgoPtf07BwD0wPpvnOSuEola2NtqSb6zb26gNTfUaG7o4QnXxbAKeRD
         RuHFmEMSo0kNMJf1D6xK2XmR/IdxkId1NpIi63wMyxUwJ1d81uAkuzJYQxNYXtgGr/4o
         sOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YONmzZ+a8NEL+EO7tC6G4AKBcj7OBsdFo9WkRSi+L14=;
        b=iGsH8fwsl2ENKnOLUCaDXQ/y93qYNIAGA9hxXFQCfp+AZHSHCc+L0xNS1n3lM7ehJt
         KISmi84EDW/FpV3SDy0d5iYM6Gfwjo5G+Jvzp+KBH1C/jodBTFBMD+6obhmQe+hE2oAu
         Fu/pzGL9jp7HIo8UG0KWoQJKgq56AO3jNVAaxEIUeJepUEADmEjL7qTH5+NIZT5te3LQ
         qsjWbRUZQ2pEUY/7pGl+OlFDjt5HiQgfa5UTzP3Zb6wN6uQWhLZQvlPz4WASg+sOGIPb
         JPyHhXKTcyH2y0X/RArF/d3J6v4yDRJE6bcRgdSs0kkuqVBRF7FVlPHKZ2rLBuzh2Fjk
         x9ww==
X-Gm-Message-State: APjAAAU0CUr8A/xGfjaYGIB/YR9ntrZHaOypxxVgLQCxVnvzMGZTsRID
        Kb+/bhVHfwGMgCsev/Te3ItVSzESeTq+Sg==
X-Google-Smtp-Source: APXvYqynSzwT44OjdQWYA5BZOvtUfY2YmHlSIov24k9Em3YpnPqEzkHuhyGwmLAclCC/ZWTyQZjhbg==
X-Received: by 2002:aa7:8e47:: with SMTP id d7mr2228609pfr.125.1571067383647;
        Mon, 14 Oct 2019 08:36:23 -0700 (PDT)
Received: from nishad ([2406:7400:54:c1b:38e9:5260:8522:a8f0])
        by smtp.gmail.com with ESMTPSA id l23sm11597798pjy.12.2019.10.14.08.36.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Oct 2019 08:36:22 -0700 (PDT)
Date:   Mon, 14 Oct 2019 21:06:09 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: sja1105: Use the correct style for SPDX
 License Identifier
Message-ID: <20191014153607.GA3324@nishad>
References: <20191012123938.GA6865@nishad>
 <CA+h21hr=Wg7ydqcTLk85rrRGhx_LCxu2Ch3dWCt1-d1XtPaAcA@mail.gmail.com>
 <20191014130016.GD19861@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014130016.GD19861@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 03:00:16PM +0200, Andrew Lunn wrote:
> On Mon, Oct 14, 2019 at 01:46:26PM +0300, Vladimir Oltean wrote:
> > Hi Nishad,
> > 
> > On Sat, 12 Oct 2019 at 15:39, Nishad Kamdar <nishadkamdar@gmail.com> wrote:
> > >
> > > This patch corrects the SPDX License Identifier style
> > > in header files related to Distributed Switch Architecture
> > > drivers for NXP SJA1105 series Ethernet switch support.
> > > For C header files Documentation/process/license-rules.rst
> > > mandates C-like comments (opposed to C source files where
> > > C++ style should be used)
> > >
> > > Changes made by using a script provided by Joe Perches here:
> > > https://lkml.org/lkml/2019/2/7/46.
> > >
> > > Suggested-by: Joe Perches <joe@perches.com>
> > > Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> > > ---
> > 
> > Your commit message has nothing to do with what you're fixing, but
> > whatever. The SPDX identifiers _are_ using C-like comments.
> 
> Agreed. Please fix the commit message, and maybe make the script
> generating the commit message, so future uses of it will get the
> message correct.
> 
> Thanks
> 	Andrew
Hello Andrew and Vladimir,

I understand your comments.
I will change the commit message in the next version of the patch.

Thanks for the review.

Regards,
Nishad
