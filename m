Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E7470B59
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 21:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhLJUGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhLJUGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 15:06:34 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B92C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 12:02:59 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x10so15918514edd.5
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 12:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=iN+JhHsogVcY4GjBn12Q/Mv9mK5tS2WGr0PrFlT++4g=;
        b=GYKmhXvdn00spXpxHL4orRTgpgr1BWpmlxCrsbs8WQt6defryVspp672czfQnZXyta
         KVG31r9LawL9hDqhPsc54Sipjn3WUW2sLlMzO6DcAojq+ZYkXw4DH0gN0EQHkNirz/j7
         M7InrAstY5PjpwR6/a+d8PAFrLHacZXLFKZ9KAHiF7XJdTZ0LiKdedpokyKN7xa5eZlz
         SdL8dIVkolxHqp9F8BnrN4iI8zRzTy1smrpKH8C3oZahRSQrRIFfBWx1O6mfMPmEy7Iy
         z6WDUKzSB+oqJM1xTKrPCLo3Shgkj74qSn9yhXG+6C9gLkteW43yDw2k+QwpdkOk+AR+
         mqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=iN+JhHsogVcY4GjBn12Q/Mv9mK5tS2WGr0PrFlT++4g=;
        b=mHG4gglrK3Z0rsEXis17MvigGsPdBTe8UKP1djphINaqD8Gm+5U1VhNLc1uS6CF9Up
         acidk0ZaUIZp5OzqLA36UNgsGnZeFcKc4BmPuBdL2tZtrjOe2Xi6eDVxhPpgtIAViA6T
         LvW6PisGLuytuSOn6sB33zQ2wcqA+l0h25ipLO7Xz1P1zf0Bzrw884IC1CgUGFmVug5Z
         rmqXRWwqlGY6gCBNlai4KkSu9gbSeWbAEVWK+YppIyCFaSrMvqa3bL8lK5DGftgbGP19
         K0wqr1lu1k2A+/yCxzZkLhQCEaCRkgSFWhKGHA+9z0RYE0YbSOtIdy8Wx635k+j9bfOn
         n6LQ==
X-Gm-Message-State: AOAM532IJgDsqcuuDIiE1vlpaH1KyD4CRrQiswfwBy9WUfWqTRRLvh6+
        Kw1qtpeVLK3SOK2gDB+I6ps=
X-Google-Smtp-Source: ABdhPJzE8xcKd6jWntjRNU5IusSBMGnMsVI5VE8yZeQiwQyBE6dIXmSiVAqOYSY9YKBEHWW/dLIvxA==
X-Received: by 2002:a17:906:390:: with SMTP id b16mr25515655eja.522.1639166577612;
        Fri, 10 Dec 2021 12:02:57 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id qf8sm1935923ejc.8.2021.12.10.12.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 12:02:56 -0800 (PST)
Message-ID: <61b3b270.1c69fb81.6dd2d.8ce5@mx.google.com>
X-Google-Original-Message-ID: <YbOybVDl/X2bcycj@Ansuel-xps.>
Date:   Fri, 10 Dec 2021 21:02:53 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
References: <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
 <20211210170242.bckpdm2qa6lchbde@skbuf>
 <61b38a18.1c69fb81.95975.8545@mx.google.com>
 <20211210171530.xh7lajqsvct7dd3r@skbuf>
 <61b38e7f.1c69fb81.96d1c.7933@mx.google.com>
 <61b396c3.1c69fb81.17062.836a@mx.google.com>
 <61b3a621.1c69fb81.b4bf5.8dd2@mx.google.com>
 <20211210192723.noa3hb2vso6t7zju@skbuf>
 <61b3ae6b.1c69fb81.9a57f.8856@mx.google.com>
 <20211210195441.6drqtckl2m6rbmk6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210195441.6drqtckl2m6rbmk6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 07:54:42PM +0000, Vladimir Oltean wrote:
> On Fri, Dec 10, 2021 at 08:45:43PM +0100, Ansuel Smith wrote:
> > > Anyway the reason why I didn't say anything about this is because I
> > > don't yet understand how it is supposed to work. Specifically:
> > > 
> > > rtnl_lock
> > > 
> > > dev_open()
> > > -> __dev_open()
> > >    -> dev->flags |= IFF_UP;
> > >    -> dev_activate()
> > >       -> transition_one_qdisc()
> > > -> call_netdevice_notifiers(NETDEV_UP, dev);
> > > 
> > > rtnl_unlock
> > > 
> > > so the qdisc should have already transitioned by the time NETDEV_UP is
> > > emitted.
> > > 
> > > and since we already require a NETDEV_UP to have occurred, or dev->flags
> > > to contain IFF_UP, I simply don't understand the following
> > > (a) why would the qdisc be noop when we catch NETDEV_UP
> > > (b) who calls netdev_state_change() (or __dev_notify_flags ?!) after the
> > >     qdisc changes on a TX queue? If no one, then I'm not sure how we can
> > >     reliably check for the state of the qdisc if we aren't notified
> > >     about changes to it.
> > 
> > The ipv6 check is just a hint. The real clue was the second
> > NETDEV_CHANGE called by linkwatch_do_dev in link_watch.c
> > That is the one that calls the CHANGE event before the ready stuff.
> > 
> > I had problem tracking this as the change logic is "emit CHANGE when flags
> > change" but netdev_state_change is also called for other reason and one
> > example is dev_activate/dev_deactivate from linkwatch_do_dev.
> > It seems a bit confusing that a generic state change is called even when
> > flags are not changed and because of this is a bit problematic track why
> > the CHANGE event was called.
> > 
> > Wonder if linkwatch_do_dev should be changed and introduce a flag? But
> > that seems problematic if for whatever reason a driver use the CHANGE
> > event to track exactly dev_activate/deactivate.
> 
> Yes, I had my own "aha" moment just minutes before you sent this email
> about linkwatch_do_dev. So indeed that's the source of both the
> dev_activate(), as well as the netdev_state_change() notifier.
> 
> As to my previous question (why would the qdisc be noop when we catch
> NETDEV_UP): the answer is of course in the code as well:
> 
> dev_activate() has:
> 	if (!netif_carrier_ok(dev))
> 		/* Delay activation until next carrier-on event */
> 		return;
> 
> which is then actually picked up from linkwatch_do_dev().
> 
> Let's not change linkwatch_do_dev(), I just wanted to understand why it
> works. Please confirm that it also works for you to make master_admin_up
> depend on qdisc_tx_is_noop() instead of the current ingress_queue check,
> then add a comment stating the mechanism through which we are tracking
> the dev_activate() calls, and then this should be good to go.
> I'd like you to pick up the patches and post them together with your
> driver changes. I can't post the patches on my own since I don't have
> any use for them. I'll leave a few more "review" comments on them in a
> minute.

Ok will do the test, but I'm positive about that.
So the idea is to send a v3 rfc with the depends of the tagger-owned
private data. Add to my series your series with this extra check.
(when I will post v3 feel free to tell me if I messed code credits)

Is the additional bool and function correct or should we merge them and
assume a link up only when we both have the flag and the qdisc?

-- 
	Ansuel
