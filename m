Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F00B470AA8
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbhLJTtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242184AbhLJTtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:49:24 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCB1C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:45:49 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id e3so33880248edu.4
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=aZZxLkcb3qxQTYWAP3brmQ7juUisH0ddXymVV2saU50=;
        b=pz21/umz5BZ3QDd3gbVC1Mapu4JtP6r0d/HiKW555EcfI4I0ngWHKRDEjZBa0FP9Wd
         LAHcZFTzFZE6ZO9edf5FqiN2uedMoxKzq3LGwdkO6x3vc+TpV1775juNCtREtKmiCE7D
         Gft2UDebzUV3M1Haaqmnm5K/B8AEjXnVyVZjHbzDxYIB6/otGJVHpy3H6SkT8vxLA/6J
         xKlQ5xfSOMfKCD+t8g/USKKE/8SChO1CSQE05l+cLu+bcxRkWl2hjr0iyJrmV/nx/R7e
         A9pGbMfSotLAsOdQY66n8GVPJaHUNHJTAsMu/CsZxogQ7ch+hZaFcRwXsizAbaLfnjCm
         2/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=aZZxLkcb3qxQTYWAP3brmQ7juUisH0ddXymVV2saU50=;
        b=Bd1kqm3ieslMqZfnXuQzzBE9gNk4J+c6r6HhoVR2EjnsT+tKfGsdm/l2qwwiDgdA6E
         AHO3gXXbIhK83EFJCSHvEdhBR60KsD4AbnbWRgg3MFhZ2kIxbUrsQu3wbWFKDz4mP7Ox
         fw3MNJO8xJbDEDTnMxm9kRj3IH/cJH5oP5yxT2+/su/CWPwPQSHVqU2P5dtJorLh30Il
         /7jZz7KYIlwdQNuhsp+Y3xjTCOumNcq3ex1IrmkEHaDu2GMMhOI1LYLdR0ujINugJuH0
         Y4jtWokWtRdLXVou5dj/JWhv1VFEigKxP0DnNjyujIQQkohw2mNZ1FYCw90x4IJD+JI1
         HiZQ==
X-Gm-Message-State: AOAM531vq/IdFHYsxFdfoqaHpCzdKBcQSsRwgwWMIc7hMGLpwz5JEdLB
        kheVhBkLva0UASaiMutLBfc=
X-Google-Smtp-Source: ABdhPJzlEzM2VxePT63UXaMeNcg6KXU6LeosMnpFHNC2dKLYyjD+VqBBKKCWZcIzvxIoz57tHIubxA==
X-Received: by 2002:a17:907:6ea8:: with SMTP id sh40mr26145530ejc.53.1639165547567;
        Fri, 10 Dec 2021 11:45:47 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id de15sm1909525ejc.70.2021.12.10.11.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 11:45:47 -0800 (PST)
Message-ID: <61b3ae6b.1c69fb81.9a57f.8856@mx.google.com>
X-Google-Original-Message-ID: <YbOuZ0VrnLS4Y6CC@Ansuel-xps.>
Date:   Fri, 10 Dec 2021 20:45:43 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
 <20211210170242.bckpdm2qa6lchbde@skbuf>
 <61b38a18.1c69fb81.95975.8545@mx.google.com>
 <20211210171530.xh7lajqsvct7dd3r@skbuf>
 <61b38e7f.1c69fb81.96d1c.7933@mx.google.com>
 <61b396c3.1c69fb81.17062.836a@mx.google.com>
 <61b3a621.1c69fb81.b4bf5.8dd2@mx.google.com>
 <20211210192723.noa3hb2vso6t7zju@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210192723.noa3hb2vso6t7zju@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 07:27:24PM +0000, Vladimir Oltean wrote:
> On Fri, Dec 10, 2021 at 08:10:21PM +0100, Ansuel Smith wrote:
> > > Ok I added more tracing and packet are received to the tagger right
> > > after the log from ipv6 "link becomes ready". That log just check if the
> > > interface is up and if it does have a valid sched.
> > > I notice after link becomes ready we have a CHANGE event for eth0. That
> > > should be the correct way to understand when the cpu port is actually
> > > usable.
> > > (just to make it clear before the link becomes ready no packet is
> > > received to the tagger and the completion timeouts)
> > > 
> > > -- 
> > > 	Ansuel
> > 
> > Sorry for the triple message spam... I have a solution. It seems packet
> > are processed as soon as dev_activate is called (so a qdisk is assigned)
> > By adding another bool like master_oper_ready and
> > 
> > void dsa_tree_master_oper_state_ready(struct dsa_switch_tree *dst,
> >                                       struct net_device *master,
> >                                       bool up);
> > 
> > static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
> >                                         struct net_device *master)
> > {
> >        struct dsa_notifier_master_state_info info;
> >        struct dsa_port *cpu_dp = master->dsa_ptr;
> > 
> >        info.master = master;
> >        info.operational = cpu_dp->master_admin_up && cpu_dp->master_oper_up && cpu_dp->master_oper_ready;
> > 
> >        dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_STATE_CHANGE, &info);
> > }
> > 
> > void dsa_tree_master_oper_state_ready(struct dsa_switch_tree *dst,
> >                                       struct net_device *master,
> >                                       bool up)
> > {
> >        struct dsa_port *cpu_dp = master->dsa_ptr;
> >        bool notify = false;
> > 
> >        if ((cpu_dp->master_oper_ready && cpu_dp->master_oper_ready) !=
> >            (cpu_dp->master_oper_ready && up))
> >                notify = true;
> > 
> >        cpu_dp->master_oper_ready = up;
> > 
> >        if (notify)
> >                dsa_tree_master_state_change(dst, master);
> > }
> > 
> > In slave.c at the NETDEV_CHANGE event the additional
> > dsa_tree_master_oper_state_ready(dst, dev, dev_ingress_queue(dev));
> > we have no timeout function. I just tested this and it works right away.
> > 
> > Think we need this additional check to make sure the tagger can finally
> > accept packet from the switch.
> > 
> > With this added I think this is ready.
> 
> Why ingress_queue?
> I was looking at dev_activate() too, especially since net/ipv6/addrconf.c uses:
> 
> /* Check if link is ready: is it up and is a valid qdisc available */
> static inline bool addrconf_link_ready(const struct net_device *dev)
> {
> 	return netif_oper_up(dev) && !qdisc_tx_is_noop(dev);
> }
> 
> and you can see that qdisc_tx_is_noop() checks for the qdisc on TX
> queues, not ingress qdisc (which makes more sense anyway).
> 
> Anyway the reason why I didn't say anything about this is because I
> don't yet understand how it is supposed to work. Specifically:
> 
> rtnl_lock
> 
> dev_open()
> -> __dev_open()
>    -> dev->flags |= IFF_UP;
>    -> dev_activate()
>       -> transition_one_qdisc()
> -> call_netdevice_notifiers(NETDEV_UP, dev);
> 
> rtnl_unlock
> 
> so the qdisc should have already transitioned by the time NETDEV_UP is
> emitted.
> 
> and since we already require a NETDEV_UP to have occurred, or dev->flags
> to contain IFF_UP, I simply don't understand the following
> (a) why would the qdisc be noop when we catch NETDEV_UP
> (b) who calls netdev_state_change() (or __dev_notify_flags ?!) after the
>     qdisc changes on a TX queue? If no one, then I'm not sure how we can
>     reliably check for the state of the qdisc if we aren't notified
>     about changes to it.

The ipv6 check is just a hint. The real clue was the second
NETDEV_CHANGE called by linkwatch_do_dev in link_watch.c
That is the one that calls the CHANGE event before the ready stuff.

I had problem tracking this as the change logic is "emit CHANGE when flags
change" but netdev_state_change is also called for other reason and one
example is dev_activate/dev_deactivate from linkwatch_do_dev.
It seems a bit confusing that a generic state change is called even when
flags are not changed and because of this is a bit problematic track why
the CHANGE event was called.

Wonder if linkwatch_do_dev should be changed and introduce a flag? But
that seems problematic if for whatever reason a driver use the CHANGE
event to track exactly dev_activate/deactivate.

-- 
	Ansuel
