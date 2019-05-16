Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10A41FFE1
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 08:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfEPG4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 02:56:19 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:37340 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfEPG4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 02:56:19 -0400
Received: by mail-ed1-f52.google.com with SMTP id w37so3629883edw.4
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 23:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v9f62nITeY4BysFMjwoONHrB8ht9661GUCQagdWwpSc=;
        b=OFhVYwBHBx6xaL4XZ6ZhtQUHU6O6KRTNN1UR0kWbVy4A8lSdwAqa5MAqt/BaTxpjyF
         3AB7U08449/6V0v7EfKz90Mgk0NCZvM+21GU+PWuKrzt2B7T5NXTuMNUmtgo9SFmY11j
         pWTjk/liNy82rkOI5citIwJ9/xLE3PT9lA1KF1ec5mqDhrWHp9ud8MAQWvdgPa0eCrEi
         pNDCi8pZkQS24OOWn0Ll7q8kGd95i+r2Zg2CaxF9UpVPV5b08GoXmbIocXfbG/bNx6nN
         whJon0zK0sYjdFht+fM527rnzPQXUOebUZFJo84FcU1HXFZOQFoKr6XKkXU8Y3itGL9C
         s4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v9f62nITeY4BysFMjwoONHrB8ht9661GUCQagdWwpSc=;
        b=N/zqSG4HMoBhU0KujbYhl2czL+4ysK77KMqhURMqRMMt9h6BOSXq+UdYgtShCDpBd5
         el14jtoUenAR4q5Jj9G95UbwsJDhSJxs0+44P98Ia7qY6yxWehK0D6N/S5XUCoRiyJYf
         DKE33181/aR1HA8I3JAMFJ6xDIk8YulOMX9D9fpF7ianRu0DAkyUnjpC/690rspolxXn
         XCEnHLXzjQt9/yEhamOVCjIYBMynw9gqKdCNXFm1voo8Zm1M3C9hvNi/g7ab2vM7AMCv
         oIYVO8WojPG4uKgp85MogUW8v76YUX2mrZFPenrM9Sz6ht9Jo695Nchvf8B0mNdYqO8g
         3BBw==
X-Gm-Message-State: APjAAAWuzYer6I2y9UhaNEod2BXu4SHvNzk3WDGO1U7VpI1LpSMVIQJA
        AzUfKICVW6ekmidSuseJUrUujZ27Ne4NLzcVVuM=
X-Google-Smtp-Source: APXvYqy8oFI1HCxNAc9zuXpitUzW924ySU+X2eQAc5vUR054ln5wIF8S2aHPS4/hfQmKgeVkjKOFx2/xursx1XxmUyY=
X-Received: by 2002:a50:9264:: with SMTP id j33mr47031057eda.125.1557989777103;
 Wed, 15 May 2019 23:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190515143936.524acd4e@bootlin.com> <20190515132701.GD23276@lunn.ch>
 <20190515160214.1aa5c7d9@bootlin.com> <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
 <20190515161931.ul2fmkfxmyumfli5@shell.armlinux.org.uk>
In-Reply-To: <20190515161931.ul2fmkfxmyumfli5@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 16 May 2019 09:56:06 +0300
Message-ID: <CA+h21hp5aX00jtj5bSkig1jGY8JHAsKwGp+584jbOw3k82Z5KA@mail.gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 May 2019 at 19:19, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, May 15, 2019 at 09:09:26AM -0700, Florian Fainelli wrote:
> > Vladimir mentioned a few weeks ago that he is considering adding support
> > for PHYLIB and PHYLINK to run without a net_device instance, you two
> > should probably coordinate with each other and make sure both of your
> > requirements (which are likely the same) get addressed.
>
> I don't see how that's sane unless we just replace the "netdevice" in
> there with an opaque "void *" and lose the typechecking.
>
> That then means we'd need to eradicate all the messages therein, since
> we can't use netdev_*() functions to print.
>
> Then there's the patches I still have, that were rejected, and have had
> no progress to get SFP working on 88x3310 - I'm just not bothering to
> push them due to the rejection, and the lack of any ideas how to
> approach this problem.  So we have the Macchiatobin which has now been
> around for quite some time with SFP+ slots that are not particularly
> functional with mainline kernels (but hey, I don't care, because they
> work for me, because I have the patches that work!)
>
> You all know where that is, I've tried pointing it out several times...
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

I'm unfortunately not up to speed yet on what has been tried so far,
but I do plan to start prototyping the idea soon and I'll probably
find your patches then.
My basic idea is to interface a Raspberry Pi-like board to a dumb
"switch evaluation board" which has only the Ethernet ports and the
SPI/whatever control interface exposed. The DSA CPU/master port combo
in this case would go through a Cat5 cable, which is not going to pan
out very well currently because both the RPi-side PHY and the switch
board-side PHY need some massaging from their respective drivers. Both
PHYs are C22.
A rough idea of what I'm actually planning to do at:
https://www.spinics.net/lists/netdev/msg569087.html

-Vladimir
