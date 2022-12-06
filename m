Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FB5644E3B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 22:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLFVx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 16:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLFVxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 16:53:24 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083EC42F7C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 13:53:24 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s186so18407034oia.5
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 13:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ixVQz31A6SNro0IMQ4m/V3KBYAQXKGqXgeNzq68MklA=;
        b=SYxofyzy1Z0mv6fUYqEclR0kQ4/D8roHjbClzmQGncLjtvkX0pU20urOgUDCvOO0sb
         jIqa8N1adWiFm4xaoWVf1rJiAp9xB4A/JA29AU0QLF7TkQdsIVEWN6c2lPTTHU6iSlTv
         d5gYVo+PakMJ+Jiqrg00ZrG0c3j3qanbnUoSbOIDjirQHCHUGgolEPf8RyXISmoDTUKO
         6317gMtNMeTeb25bOBLHNMO4QA2IYjmnKQzk8qULdfee8YGiJ3BFEDcBsC+nHVjyworA
         sSMldL2EggVePEPgLotesK6yF8hOCgGe1jeIWcwelHj3aSG8xfkJOn4eb4UQlx8I5Vwf
         YDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ixVQz31A6SNro0IMQ4m/V3KBYAQXKGqXgeNzq68MklA=;
        b=7B15iMPB6NKQOD9prreYLQ+S02tolj8zVk13dQFthG49jVg9f7mNPjF1Nr+ZYihI5j
         CoLzPwPVMdSoNWR5cLv3T0uoRWt/1ei+CAyuyfcOTEUWCnXTvHoC3VKZM1cGb4SYVUOL
         KjikIk0M5lUePx7hVyILbOamVA0IPIUEu5Wt3REmkLzIC18V2W67btPu5+XcAAVHS/n9
         5XmIWQdVuIHsXj6dtsfdLtm+mRwc1rKE3cEcCiTbFK6AEO+zem5+iV7aqCO1uXfHGbVW
         1kTuN6uP/dJ5HVif+rBnuwbSiWfdCsPJkVWtT43X0Sd+vbIR/FNYoDwTfJzxzPoJE2zm
         PHlg==
X-Gm-Message-State: ANoB5pmQVetWYOqC7VWI9mJPLwk7ygGUH7oE50d8PAyCMfl4EljdOiMr
        jT1Em0l0fDxe81MtOrHfo9ZdgREUtjeX30h5G5o=
X-Google-Smtp-Source: AA0mqf4p5HqqFxS2VHqqBo9aEhCudoblBdqTgWeFJr1BFlG5keaq9mj1IQyg06TVDr5ksfWQAAydHdr5WJB12bDjYLM=
X-Received: by 2002:aca:2801:0:b0:35a:13f4:d875 with SMTP id
 1-20020aca2801000000b0035a13f4d875mr45928766oix.190.1670363603284; Tue, 06
 Dec 2022 13:53:23 -0800 (PST)
MIME-Version: 1.0
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
 <Y4731q0/oqwhHZod@nanopsycho> <CADvbK_e6dFT6L69g63FOu=uE7b48rubaYOBL0RDTmKRUBFDCjw@mail.gmail.com>
In-Reply-To: <CADvbK_e6dFT6L69g63FOu=uE7b48rubaYOBL0RDTmKRUBFDCjw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 6 Dec 2022 16:52:33 -0500
Message-ID: <CADvbK_eaEb9vQ9h34WNcibULBFHAZcPB05dNztV=+QOUzOYBwQ@mail.gmail.com>
Subject: Re: [PATCH net] team: prevent ipv6 link local address on port devices
To:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, LiLiang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 8:32 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Dec 6, 2022 at 3:05 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Mon, Dec 05, 2022 at 06:46:05PM CET, lucien.xin@gmail.com wrote:
> > >The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
> > >for slaves separately from master") is also needed in Team. Otherwise,
> > >DAD and RS packets to be sent from the slaves in turn can confuse the
> > >switches and cause them to incorrectly update their forwarding tables
> > >as Liang noticed in the test with activebackup mode.
> > >
> > >Note that the patch also sets IFF_MASTER flag for Team dev accordingly
> > >while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
> > >not really used in Team, it's good to show in 'ip link':
> > >
> > >  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
> > >  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
> > >
> > >Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> > >Reported-by: LiLiang <liali@redhat.com>
> > >Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >
> > Nack. Please don't do this. IFF_MASTER and IFF_SLAVE are historical
> > flags used by bonding and eql. Should not be used for other devices.
> I see. I was wondering why it was not used in Team at the beginning. :)
>
> >
> > addrconf_addr_gen() should not check IFF_SLAVE. It should use:
> > netif_is_lag_port() and netif_is_failover_slave() helpers.
Hi Jiri,

Sorry, it seems not to work with this.

As addrconf_addr_gen() is also called in NETDEV_UP event where
IFF_TEAM_PORT and IFF_BONDING haven't yet been set before
dev_open() when adding the port.

If we move IFF_TEAM_PORT setting ahead of dev_open(), it will revert
the fix in:

commit d7d3c05135f37d8fdf73f9966d27155cada36e56
Author: Jiri Pirko <jiri@resnulli.us>
Date:   Mon Aug 25 21:38:27 2014 +0200

    team: set IFF_TEAM_PORT priv_flag after rx_handler is registered

Can we keep IFF_SLAVE here only for no ipv6 addrconf?
or do you see a better solution?

Thanks.
