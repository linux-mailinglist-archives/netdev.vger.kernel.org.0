Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF298DC5CE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410189AbfJRNJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:09:43 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40730 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408337AbfJRNJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 09:09:43 -0400
Received: by mail-ed1-f67.google.com with SMTP id v38so4513918edm.7;
        Fri, 18 Oct 2019 06:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x4jU8RnkUmGfnuabopPe+N7RjYpoqQdgATxq7oLTD4U=;
        b=eKJ2L/AZnmLXMAiBDmrPUEq94LYtwCx17rvPAwbyAAWCcmVvQWh5R6wLajw/4Y71wB
         rd29g1vh+5tY15xF9Glsoq1+Oe/d5Vb6m8LAD8gaq6wa1vUk+Euoxu5DHTsEiyGrlYr8
         PxWbMguCHUiF9rQPSNVM5cWfgbAvPGFp7s9IqUZM8Y9mTgbZvFFDuqjK304lrO4KHinC
         Lh+SmDpTf+bWDYH8TVIlZB1k723J3FnIIj4d+3D0YUEY2yPULqYRkJVsughiDbAu8GMJ
         wQDurut7FbSLRDc9rLs5GyRk2CPsWlgbamH9hHaGTrFkFSMKW8pvmmexrtAantTcr2rz
         xFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x4jU8RnkUmGfnuabopPe+N7RjYpoqQdgATxq7oLTD4U=;
        b=VsjtNPBbhCHvv4LxzTvfZyZEj1yxiF5cwtbwzPWi9EEnIA1ZyNS751v0RiIS1wluER
         Nd1IdXZ8wT97QLOcxhbFwWje4pkJJ3k4K5OLPMjikogiEJEe5cu/YPlB/tSlN1li24/f
         BOMtlq0vRad6l34/diqPMA3jvgapxOhiDCiImNRMOl9PQqE/rY0Rm1oKO9nyrirviqO1
         WjwfgCEkxMX/kCQSfna+AMKZ3gTH/fL84EzCs88KZMSkUGUecy6KBo9bStzIXVOyrkUi
         EVeVXMkqbpbASELxEKnyKb0hrghYG1Yqu1Uea7wpctz0JquJdW2FyEDD61lBXyrOAMKs
         maMQ==
X-Gm-Message-State: APjAAAUmxyuaXvsoTLI9CQAuSfTTSieSYKPBlGFvdfT/xT7y82glF9Cp
        cRx1U3W/LGbjae/8zzkieQb1Nln8xjOkRHL7A9M=
X-Google-Smtp-Source: APXvYqzqijmc/yk5VLLpRHZRa2Sol8ZtigBsmh5CBn1yzI03fvb0fcyKAHVy9IaxhrBYDCVflPmsE0FdccVNFWdgmLI=
X-Received: by 2002:aa7:c259:: with SMTP id y25mr9335025edo.117.1571404181364;
 Fri, 18 Oct 2019 06:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191015224953.24199-1-f.fainelli@gmail.com> <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com> <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
 <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com> <20191018130121.GK4780@lunn.ch>
In-Reply-To: <20191018130121.GK4780@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 18 Oct 2019 16:09:30 +0300
Message-ID: <CA+h21hoPrwcgz-q=UROAu0PC=6JbKtbdPhJtZg5ge32_2xJ3TQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII connections
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Russell King <rmk+kernel@armlinux.org.uk>, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, 18 Oct 2019 at 16:01, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Well, that's the tricky part. You're sending a frame out, with no
> > guarantee you'll get the same frame back in. So I'm not sure that any
> > identifiers put inside the frame will survive.
> > How do the tests pan out for you? Do you actually get to trigger this
> > check? As I mentioned, my NIC drops the frames with bad FCS.
>
> My experience is, the NIC drops the frame and increments some the
> counter about bad FCS. I do very occasionally see a frame delivered,
> but i guess that is 1/65536 where the FCS just happens to be good by
> accident. So i think some other algorithm should be used which is
> unlikely to be good when the FCS is accidentally good, or just check
> the contents of the packet, you know what is should contain.
>
> Are there any NICs which don't do hardware FCS? Is that something we
> realistically need to consider?
>
> > Yes, but remember, nobody guarantees that a frame with DMAC
> > ff:ff:ff:ff:ff:ff on egress will still have it on its way back. Again,
> > this all depends on how you plan to manage the rx-all ethtool feature.
>
> Humm. Never heard that before. Are you saying some NICs rewrite the
> DMAN?
>

I'm just trying to understand the circumstances under which this
kernel thread makes sense.
Checking for FCS validity means that the intention was to enable the
reception of frames with bad FCS.
Bad FCS after bad RGMII setup/hold times doesn't mean there's a small
guy in there who rewrites the checksum. It means that frame octets get
garbled. All octets are just as likely to get garbled, including the
SFD, preamble, DMAC, etc.
All I'm saying is that, if the intention of the patch is to actually
process the FCS of frames before and after, then it should actually
put the interface in promiscuous mode, so that frames with a
non-garbled SFD and preamble can still be received, even though their
DMAC was the one that got garbled.

>         Andrew

Thanks,
-Vladimir
