Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6323C59
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388808AbfETPkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:40:35 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45423 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731091AbfETPkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:40:35 -0400
Received: by mail-ed1-f66.google.com with SMTP id g57so24482416edc.12
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jP6daD5wGfF6Yv5hjVkyCjRza/unbAeRgr5gAnYelDw=;
        b=Lvr5DCYG0Q7ZKYgFBt9BGDSD6TWTikz7uYGZkk8YVW/lnqrWLTa/91fMe1cXDD8Flc
         ddRdjMdp06XnkCBea6qDaV/uKLwBqhM3Th41aSAHJtbN6zVWNaiO74n/hDJs+eUYeKH1
         1ckamoXJ8GWUP0/7uKVTtnHBjqolwr1t9XY33S+2j0M/eBXgLw33jdsS5kx4KL4OrWtB
         eDSmHAST7gx7p0j8rNNHq8XY7yDVsf2b+gU+nDkEbRPR3rrKm4qNQsBaz+MJT1LfNZ96
         s+QoglJrdBVVlb5ZElSJeEL1vlwx877dnOOJH6H6YuWLCAIibEJOLc2vWgshCYPKDZ7H
         4FUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jP6daD5wGfF6Yv5hjVkyCjRza/unbAeRgr5gAnYelDw=;
        b=BEgtMALWCffh35iZyhKzGnpYk4zTFRhyueOH9cwmS/H7iFJJyiWyFCl5Z6RUw/GgS5
         7AdBSELXVZbrW4N8OgPlq9W6SNtiTN68+cTSF/B+DSHgsCZmUfXO1sShR6dY8vMJjXvo
         ++NtP8eS5PRa2uXesEH1WT7dAEu380Wcl2Ie0VdPhJm3nXK2bjYyESb/w/1CAuoFF30x
         A4egA0pkJOwetviq4xSkE9FiMmoU3Qt1s3QVOrtzYdJGZUxbLbJZmZT2h6PGEPz3/ehH
         dqfHNiGerSauBvbzOgLbhlHYSF/xtg3Q0np97vmcVen8aHPvyUrBd9GsY+TXsoNK+8oT
         pRJw==
X-Gm-Message-State: APjAAAWnBh666Sgx3+MHeCEliuBo/FFeDeqN7gVbTW5qLjeV0rkX54iu
        UMgZnNsFT9snPe2GjF5UCB39q16vG9hCtlafPDs=
X-Google-Smtp-Source: APXvYqySJpKfk5ei6JIc3790A2e4wMebE5BQ/wUaY14o/7jn8YSWWrVfCNYpScS17zIzOIr+xwthu1jtLD4qvdRfsOQ=
X-Received: by 2002:a17:906:f19a:: with SMTP id gs26mr52217363ejb.78.1558366833897;
 Mon, 20 May 2019 08:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
In-Reply-To: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 20 May 2019 18:40:22 +0300
Message-ID: <CA+h21hrVzeVq6RTtGAaLGnxug8wPcU34iJHJEDjQ04EJmQ-8Zw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] phylink/sfp updates
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, ioana.ciornei@nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 May 2019 at 18:21, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> Hi,
>
> I realise that net-next probably isn't open yet, but I believe folk
> will find these patches "interesting" so I'm sending them to share
> them with people working on this code, rather than expecting them to
> be picked up this week.
>
> The first patch adds support for using interrupts when using a GPIO
> for link status tracking, rather than polling it at one second
> intervals.  This reduces the need to wakeup the CPU every second.
>
> The second patch adds support to the MII ioctl API to read and write
> Clause 45 PHY registers.  I don't know how desirable this is for
> mainline, but I have used this facility extensively to investigate
> the Marvell 88x3310 PHY.
>
> There have been discussions about removing "netdev" from phylink.
> The last two patches remove netdev from the sfp code, which would be
> a necessary step in that direction.

Hi Russell,

I've been working with Ioana to introduce a
phylink_create_raw/phylink_attach_raw set of function that work in the
absence of an attached_dev. It does not remove the netdev references
from the existing code, just guards the few places that needed that.
Then we plugged it into DSA (via a notifier block) and now phylink is
used for both the user and non-user ports. Next step is to make the
dpaa2-mac driver use this new API and send the patchset for review.
Hopefully that will happen tomorrow.

-Vladimir

>
>  drivers/net/phy/phy.c     | 33 ++++++++++++++++++++--------
>  drivers/net/phy/phylink.c | 55 +++++++++++++++++++++++++++++++++++++++++------
>  drivers/net/phy/sfp-bus.c | 14 +++++-------
>  include/linux/sfp.h       | 12 +++++++----
>  4 files changed, 86 insertions(+), 28 deletions(-)
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
