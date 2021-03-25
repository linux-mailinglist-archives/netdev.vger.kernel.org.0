Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262CB348E46
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCYKoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhCYKog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:44:36 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E50C06174A;
        Thu, 25 Mar 2021 03:44:32 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v4so1735332wrp.13;
        Thu, 25 Mar 2021 03:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MZjis3vrfNS4o0432qm7e5nhATdqsIWVgffv/njY2mk=;
        b=Ukk2S4Qydfdr4xZ5yBY5upwmcg/QvDRZdymH/Xt/x4VXYfaLh7NpAne0dJfIbJx/Fy
         6G+k0D4Pbc0ZnfAUleUBNL1FMyWKcUFxrLrWUBJjiofGkCnLJWROhA/600JMJGmQlbm7
         VhuCjiAlTXFdKp4FrJ1lutY93b/hia2CGVfQ1gxV4wTffOIkKDoM7z5yXAJqjN3Mnxvx
         jCKWpSMxycVpKciAKIEuLDrSZgfnJd9CdBbDP7HwsnrFG/5v9KYdpusGe1A4b7gAQ5Iz
         e3QxX9fUTxACR9wyM1pU6OW4gOHTLU7wTmZP864zP44R9FpPl3Y1OzNR/W//4fP2ciir
         B50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MZjis3vrfNS4o0432qm7e5nhATdqsIWVgffv/njY2mk=;
        b=qZF8LEUHcAee4BLPuP1HiebecMKSywLTd4GH4R81BWwkM4xUkjndIhAL8sCLyE6E9I
         hrzVbSsxn7507yjZ36+A/QVNpsG83Y4Zab5zRImBh6CEqtpKpm3g9jBeJlL+B0+lu6SD
         fRChclvJ9PfwNZ5IuNmnwNbSfyxKG8P2JoZKeLFso8PgW8dNMS0+fE7Cdb54jkD1PRpk
         mpGrAW5jcURE8Ky+ZiD6YnRxBUTtRq/cr3vH565UZL29CUeNs6okUDAS8lbWqJ42ek5z
         yExJyeKT3MVqVGOClAB/6oim0KWtpXx1X1aN6pkNbVNucJeTfNOs5AjVk/pH3g5g9smP
         Nwag==
X-Gm-Message-State: AOAM532Z6XzRH0L5zg/52eHwhTR1VgQunMwcOH7+46nf6zYxBlk+1jiw
        5Ct/lTh4IRFtPSeSlhPx1gXsDX7aC5vbt5VuFRyxnQ90
X-Google-Smtp-Source: ABdhPJyjq5mQt67+NuxzwHKThOq9tL8kT3q1QFWgJeNLwCYhsScbs7UqkH2iHXhptMd8avdzmCYVbO9xalrVfYdykg4=
X-Received: by 2002:adf:f2c3:: with SMTP id d3mr8320379wrp.380.1616669071289;
 Thu, 25 Mar 2021 03:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
 <YFpO7n9uDt167ANk@lunn.ch>
In-Reply-To: <YFpO7n9uDt167ANk@lunn.ch>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 25 Mar 2021 16:14:20 +0530
Message-ID: <CA+sq2CeT2m2QcrzSn6g5rxUfmJDVQqjYFayW+bcuopCCoYuQ6Q@mail.gmail.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers & phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Hi Hariprasad
> > >
> > > Private flags sound very wrong here. I would expect to see some integration
> > > between the switchdev/DSA driver and the MAC driver.
> > > Please show how this works in combination with drivers/net/dsa/mv88e6xxx
> > > or drivers/net/ethernet/marvell/prestera.
> > >
> >       Octeontx2 silicon supports NPC (network parser and cam) unit , through which packet parsing and packet classification is achieved.
> >               Packet parsing extracting different fields from each layer.
> >                                 DMAC + SMAC  --> LA
> >                                              VLAN ID --> LB
> >                                              SIP + DIP --> LC
> >                                                             TCP SPORT + DPORT --> LD
> >     And packet classification is achieved through  flow identification in key extraction and mcam search key . User can install mcam rules
> >     With action as
> >               forward packet to PF and to receive  queue 0
> >               forward packet to VF and  with as RSS ( Receive side scaling)
> >               drop the packet
> >               etc..
> >
> >    Now with switch header ( EDSA /FDSA) and HIGIG2 appended to regular packet , NPC can not parse these
> >    Ingress packets as these headers does not have fixed headers. To achieve this Special PKIND( port kind) is allocated in hardware
> >    which will help NPC to parse the packets.
> >
> >  For example incase of EDSA 8 byte header which is placed right after SMAC , special PKIND reserved for EDSA helps NPC to
> >  Identify the  input packet is EDSA . Such that NPC can extract fields in this header and forward to
> >  Parse rest of the headers.
> >
> >  Same is the case with higig2 header where 16 bytes header is placed at start of the packet.
> >
> > In this case private flags helps user to configure interface in EDSA/FDSA or HIGIG2. Such that special
> > PKIND reserved for that header are assigned to the interface.  The scope of the patch series is how
> > User can configure interface mode as switch header(HIGIG2/EDSA etc) .In our case no DSA logical
> > Ports are created as these headers can be stripped by NPC.
>
> So you completely skipped how this works with mv88e6xxx or
> prestera. If you need this private flag for some out of mainline
> Marvell SDK, it is very unlikely to be accepted.
>
>         Andrew

What we are trying to do here has no dependency on DSA drivers and
neither impacts that functionality.
Here we are just notifying the HW to parse the packets properly.

Thanks,
Sunil.
