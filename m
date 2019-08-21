Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0429766B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfHUJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:51:45 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39209 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHUJvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 05:51:45 -0400
Received: by mail-ed1-f67.google.com with SMTP id g8so2219864edm.6
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 02:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nX+QC3sh0zmRpo4Yr4YHSZYBkBIFMbiT9NQKHv0GPQs=;
        b=KZnzUfXot7OA/y5+4fURRLd1PkmKH25urTHV5ozPTkdqYNdb2cPpm/TUQdRum6kYYc
         r5Jzn/NOJO5chaO5DaelKPgmph9I+VFopGjthtvuYNnRyEfZss96fvTLZfovcqfrF+Va
         Aem5SDukaAnRrT8LGccK+fDRmy5csOOSVekdt0nexOoDWAZxxlir2VSGno2NgOnpw5jZ
         pV920GD6Kn1pMLA+frOr7PrHkmP53oHLezburRW4w2GH1PrYwirCKdZbLBXnyOXBXQ8G
         x6PCfD1o47zvmmu5C1HVam+uKEOnNP9dIRfw4rG5NzjiEFFToJdIgcsu5sqhjr9W4J1Z
         eJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nX+QC3sh0zmRpo4Yr4YHSZYBkBIFMbiT9NQKHv0GPQs=;
        b=oNBt0LP8jutju/X6zA6zknMDkX6JWCle08RRZ27QAccTQZPD2Y5oReSCWF3f4Sjxmy
         T7sSRoZA78ZNvWbBx+8XX2CodesuWce4gbQVcshTuw5AmcI07aoim1Jl7ZZBZAbJuWbs
         WKdLX15gS5dxmfe3DErm0moPnBGNfONVxW6h6ncMUSjl7m/xkbatrC0rBoUEWppRcyfp
         JoIPEII+23ikgjSA+8zDy0PHJBr92RMfjo9+Z5EJC7jqmLkCv5oER350Dat3NWtiCPl1
         UOyxW3MCnZVAFt0zcFzFgQb1gEziHUEWq3hflFKOp8WrtIZQK0jZ1NMm0DfoU3CxxrHw
         ljeQ==
X-Gm-Message-State: APjAAAXB4OSQV4xPH8Vw1+qLbkNPkeZRP0r87OXim++1gQSG0/OnofyJ
        YJ/rVkLdhbb5QfA49puNymbNf1QmH8u+rkOMEPg=
X-Google-Smtp-Source: APXvYqxANT5p+XjWCZmJOmHcX3GEibIOZ+vZyrJxmhsyHFgmXlVanAxR+iN/Ym8u8zgHmpVYYgqzvdgS8aWBTNvDHcU=
X-Received: by 2002:aa7:d811:: with SMTP id v17mr27684204edq.165.1566381103395;
 Wed, 21 Aug 2019 02:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain> <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain> <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
 <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com>
 <20190820165813.GB8523@t480s.localdomain> <CA+h21hrgUxKXmYuzdCPd-GqVyzNnjPAmf-Q29=7=gFJyAfY_gw@mail.gmail.com>
 <20190820173602.GB10980@t480s.localdomain> <CA+h21hodsDTwPHY1pxQA-ucu6FU7rkOQa7Y4HJGZC0fRd8zmDA@mail.gmail.com>
 <20190820233026.GC21067@t480s.localdomain>
In-Reply-To: <20190820233026.GC21067@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 21 Aug 2019 12:51:32 +0300
Message-ID: <CA+h21hoXX7CRvf0C5q3Kxwj-4xpP+gcg58S0mx=Kruayg69Kaw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 at 06:30, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> On Wed, 21 Aug 2019 01:09:39 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > I mean I made an argument already for the hack in 4/6 ("Don't program
> > the VLAN as pvid on the upstream port"). If the hack gets accepted
> > like that, I have no further need of any change in the implicit VLAN
> > configuration. But it's still a hack, so in that sense it would be
> > nicer to not need it and have a better amount of control.
>
> How come you simply cannot ignore the PVID flag for the CPU port in the
> driver directly, as mv88e6xxx does in preference of the Marvell specific
> "unmodified" mode? What PVID are you programming on the CPU port already?
>
>
> Thanks,
>
>         Vivien

sja1105 has no such thing as an "unmodified" egress policy.
And ignoring the flags in the switch driver for the CPU port is just
as hacky as fixing it up in the DSA core.
I fail to see any reason to change the pvid for the CPU/DSA ports,
maybe you can clarify.

Actually I gave a second thought to the patchset and in a weird,
convoluted way, I can get away with just:
- 2/6: net: bridge: Populate the pvid flag in br_vlan_get_info
- 5/6 net: dsa: Allow proper internal use of VLANs
- 6/6 net: dsa: tag_8021q: Restore bridge pvid when enabling vlan_filtering
A side effect of running dsa_port_restore_pvid on a user port will be
that it is going to also restore the pvid on the CPU port, via the
bitmap operations. I had not thought of this initially when I first
jumped to remove the BRIDGE_VLAN_INFO_PVID flag in 4/6. And the fact
that it would work would just be "programming by coincidence".

I guess my aversion against the VLAN bitmap operations (and, well,
"match" in your new change) stems from the fact that the DSA core sits
in the way of doing custom configuration of the CPU port VLAN
settings. Yes, you can work around it (dsa_8021q first configures the
user ports as pvid and egress untagged, then configures the CPU port
as egress tagged, so that the pvid setting from user ports doesn't
"stick" to the CPU via the bitmap), but it's like pouring water that's
half hot and half cold from a water cooler, when all you want is water
that's at room temperature.

-Vladimir
