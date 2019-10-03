Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05530CAF9A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbfJCTyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:54:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44071 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730787AbfJCTyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:54:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id r16so3707322edq.11;
        Thu, 03 Oct 2019 12:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCANBX3Ox20ir7Rnd71k7qK1oIfWgWYZ+Zijy9thnRQ=;
        b=u2zaPc8GXJbXYFfBiXepdfldy29Y56jlxdJgs6pMzI19+zuoR7jASA2ogeUdIPX5F4
         cXlNsdsf1pyLCNGQeZVQ/18dtHgfwyzt33ulPOZj4raoDtvmbfcFE7yb5uRawOQbVSMS
         KW1Dv45cWwbiUB8gOBY6NnQ1MdbZLXN8vZNNcxbpMqspjGcEfnCwXffYPiobuCtCQPLL
         vUjHLfnKCjjU76HC5TgMc5r/mRWiHs+f8mTPPt/RgFB9nmB3IkRmLbNO6xRuvStc8ZmI
         wquUT/RsUYk8+JbJOb+X0iBvkcpkpnlXKnHFHWjKbWluezEjYbmZhQwghdsSxNLhMUOa
         pIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vCANBX3Ox20ir7Rnd71k7qK1oIfWgWYZ+Zijy9thnRQ=;
        b=m57VDlRafucQmiPUMOox0U2ojaHsT9uCt77ax2gBF3K+pQ8Et7AM4Ik4opiY4mSxZx
         mpImD3vpS+3Xs29RXyhhLkDJYkGPRrAlRdITqG65co6YzXIHQY5pWKSf9glezbjoYcLd
         4vfJyNbmzSY+xZb56kMkChJFugFtZFJpZAayicrf+8CU4GUZ5/DMAoO0BPSGdh+R/QDa
         BLQXpG8rQ94BWUxmthf0PEFPIvIpWI8cupOJfm94TIC9SpedO6UXBLvPfASKkH5SKEe4
         uobYz6g2KmwE1O26TCiFqYEJ2D+eG2E905u3l8WbfD83N/kRz1BXEAxfJPEyjnuSRA4p
         j41w==
X-Gm-Message-State: APjAAAUFNou2jMtUelmjbrDgEt2AfcZ9/8XOICjB4U/oGhH0ehnJjSE7
        z+3+TFtSnpDaOUAHigTZpjADgrhpD/bdWp/5s7U=
X-Google-Smtp-Source: APXvYqy+b7puDNAizNWXrhfSQqWIBuHAJZhIsUw09ZPXCWgN6mhw/BYh3I+xZX4l8hoxta2hmrTD3lXAKtlApkKy7dU=
X-Received: by 2002:a17:906:d797:: with SMTP id pj23mr9300759ejb.70.1570132477537;
 Thu, 03 Oct 2019 12:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191003184352.24356-1-f.fainelli@gmail.com> <20191003185116.GA21875@lunn.ch>
 <0d5e4195-c407-2915-de96-3c4b3713ada0@gmail.com> <20191003190651.GB21875@lunn.ch>
In-Reply-To: <20191003190651.GB21875@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 3 Oct 2019 22:54:26 +0300
Message-ID: <CA+h21hp0-zdJjt+dXkp0ZjZk5wG64kwPV01Js3cPMNS9qySqGQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: phy: broadcom: RGMII delays fixes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        manasa.mudireddy@broadcom.com, ray.jui@broadcom.com,
        rafal@milecki.pl
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, 3 Oct 2019 at 22:06, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Oct 03, 2019 at 11:55:40AM -0700, Florian Fainelli wrote:
> > Hi Andrew,
> >
> > On 10/3/19 11:51 AM, Andrew Lunn wrote:
> > > On Thu, Oct 03, 2019 at 11:43:50AM -0700, Florian Fainelli wrote:
> > >> Hi all,
> > >>
> > >> This patch series fixes the BCM54210E RGMII delay configuration which
> > >> could only have worked in a PHY_INTERFACE_MODE_RGMII configuration.
> > >
> > > Hi Florian
> > >
> > > So any DT blob which incorrectly uses one of the other RGMII modes is
> > > now going to break, where as before it was ignored.
> >
> > Potentially yes. There is a precedent with the at803x PHY driver
>
> Hi Florian
>
> Yes that was an interesting learning experience. I'm not sure we want
> to do that again. A lot of devices broken, and a lot of people were
> unhappy.
>
> If we are looking at a similar scale of breakage, i think i would
> prefer to add a broadcom,bcm54210e-phy-mode property in the DT which
> if present would override the phy_interface_t passed to the driver.
>
>    Andrew

What is the breakage concern here?
The driver was unconditionally clearing the RGMII delays. Therefore,
any board that needed them would have noticed really fast, IMO. That
should include people who configure 'rgmii-id' in the DT in the hope
that it would solve some problems.
The typical RGMII delay breakage is not realizing you need Linux to
enable RGMII delays (perhaps due to strapping) and specifying plain
"rgmii" in the phy-mode, then somebody 'fixing' those and disabling
them.
But in this case, the only breakage would be "hmmm, let's just enable
RGMII delays everywhere. So it works with rgmii-id on both the PHY and
the MAC side of things? Great, time for lunch!". I just hope that did
not happen. And maybe even if it did, AFAIK the BCM54xx skews the data
lines by 1.9 ns (unfortunately not configurable), that leaves an extra
~2.1 ns of timing budget until the next RGMII clock transition,
considering a 50% duty cycle? Maybe that's enough to fit the MAC's
RGMII I/O buffer delays without breaking anything, and then it doesn't
really matter?

Regards,
-Vladimir
