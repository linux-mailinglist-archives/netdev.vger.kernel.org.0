Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855273631D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFESJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:09:08 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43127 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFESJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:09:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id w33so6987306edb.10;
        Wed, 05 Jun 2019 11:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3kkJoePojOH2DqUPlKLHgq3td/DufBzIP3M2ebsRF7c=;
        b=VK6nFpjuXkMWNTERySkphfawJotFUYOdP0wGWCujtfEpKSLNB+6bgIiLCPvDndUyAZ
         MMJwEvm79kVuVrno3nFwfntAReb3567GHUVpsLnUTFqDih8eDDr+rdN2iCkKruYFgfoA
         qNzyzwT3PRIRvid3RWRl7OwDT+j2Vr7dVx42+iO1jQMbyPUC6aHw0C/T7hZaOuFL1dNI
         6o4vTq9T9nKtVIOSfFdnLDpktt9IMUuh6wIm4f6phrK+ztxicqMX5OyHHDLGXFR5HO4w
         6CLSJaW20N4VGu6P/c5UKEHb2abUbvlBEhSAXZyPk0TwEX6bakluGxB4ncuSUkY362y9
         MBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3kkJoePojOH2DqUPlKLHgq3td/DufBzIP3M2ebsRF7c=;
        b=uNJMEYhpOZkPjRaQ5v4kUq7SORoOkql52EIEJtGWWNQmNkWZkaZmdRZhT3ijm0oO87
         aPOaZgfabH98xkG7UDwm4pSrMdKV98b6O+lLHLdB8WN7lpbF8AtShZ2txpx7YPltRSF6
         irfXYcgY8WtXtmLrcqu+oHIuNLJHiWzdIWUJg+za3GtCugAWE9uk0+tvxENzyOvR9lfi
         fhl/TYx52M13Tf/4kutLy71Lk6fSY/7GE/oz1Jqdive50N2e9ATZixNXR9dPxeJ3rvXG
         pBaoayCokv3mfyUzWv/Er6JuKry5JhO8sBoHBArTGjs2BxsLsjRFL0Q8lk+J+tAUl3Rw
         /68w==
X-Gm-Message-State: APjAAAWRpcpF2PE6yOxFGg+093YpKCR6GHYUz5SJlVLdtEq7sLu8vbvA
        RmaqX1I5BtXnkeEJFSh9wa22DUY+S30RZJU2KXg=
X-Google-Smtp-Source: APXvYqyhcKLFHtdseQURsMnPIeyQTO3UV+kTb27MHsqATshvfpU+hXz9sgAp8FqkWUKc1jLYewuy52l6zEXrtVoAHl4=
X-Received: by 2002:aa7:da4b:: with SMTP id w11mr37188183eds.36.1559758145636;
 Wed, 05 Jun 2019 11:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190604170756.14338-1-olteanv@gmail.com> <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com> <20190605174547.b4rwbfrzjqzujxno@localhost>
In-Reply-To: <20190605174547.b4rwbfrzjqzujxno@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 21:08:54 +0300
Message-ID: <CA+h21hqdmu3+YQVMXyvckrUjXW7mstjG1MDafWGy4qFHB9zdtg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 20:45, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Wed, Jun 05, 2019 at 02:33:52PM +0300, Vladimir Oltean wrote:
> > In the meantime: Richard, do you have any objections to this patchset?
>
> I like the fact that you didn't have to change the dsa or ptp
> frameworks this time around.  I haven't taken a closer look than that
> yet.
>

There's one more thing I wanted to ask you if you get the chance to
take a closer look.
Currently I'm using a cyclecounter, but I *will* need actual PHC
manipulations for the time-based shaping and policing features that
the switch has in hardware. On the other hand I get much tighter sync
offset using the free-running counter than with hardware-corrected
timestamps. So as far as I see it, I'll need to have two sets of
operations.
How should I design such a dual-PHC device driver? Just register two
separate clocks, one for the timestamping counter, the other for the
scheduling/policing PTP clock, and have phc2sys keep them in sync
externally to the driver? Or implement the hardware corrections
alongside the timecounter ones, and expose a single PHC (and for
clock_gettime, just pick one of the time sources)?

> > I was wondering whether the path delay difference between E2E and P2P
> > rings any bell to you.
>
> Can it be that the switch applies corrections in HW?
>
> Thanks,
> Richard

Thanks,
-Vladimir
