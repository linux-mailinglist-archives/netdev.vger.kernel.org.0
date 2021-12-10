Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881544709EA
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343544AbhLJTOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhLJTOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:14:03 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06CC0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:10:27 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g14so32154237edb.8
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=l0GLoG8P9uBaT/HNeJEnVyJ+pRllp2wwDyAm4pnrMVg=;
        b=OphThgGbhlbB5+U+WNBViiMvmqopKO/Lh9uc4IV8gGKQt3ekF+/vcrGh41bhLH0iZj
         Y8xxkz9v5L9jJgY1Yw2LJLDOUOAZOIp8MU8sBeDGmGzlhVnyd6O2O+dXcQF2mjp3angs
         FlsjPdOssTs4RSdnvpXe5gpTxU+KxSnysuyB3x53TprvHN6s1vqmfjWu96pLPLkQzpSM
         6qaLsehquBrv5s4yupFsk54r2zUfEooUmmwlvyZ7jmY+BRa7mPETuxYXLBjd70WQVmmy
         TB6KsV2NYmiloZV9dx1RqxK4YeFral5hiUFtXUI0Hq4ujO2sYGZT8t/+jyeDJTrroZtT
         BGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=l0GLoG8P9uBaT/HNeJEnVyJ+pRllp2wwDyAm4pnrMVg=;
        b=yDN8CW+NHuIuIN0x2Ur0YfRKM2SgbMUps/CthR38wpo1XVSEGDsP9BQdwlHjubl+k7
         W0CipqOWmoo322PftM3KepSTLB6U7qLuMHvrebyKuMo7WzAhWraemfLQreQuSNRxRkXv
         rIGiFhPzRMLHZ6M26cY71REXMBU3hCuhFKI5l1x2xDt/SHBkJ+LwyGt+DsHAwoe3JvtC
         2nnuePaxvu1lOhJDNWzKgSCjmRYbWDDCquMliWM5clHnRR9GKrUtmvwPrV/HXQGs/V/b
         755U3aSnrCWuWubUUH3ods+TLY4W4JLfTWZj6WCo8wzU0kY/jEeRqklF5+kCfPWyDbLT
         ctHQ==
X-Gm-Message-State: AOAM530sCymUTmP2OwTndJJEfUeCLprzFwiN189E0KCP2nPOnuG1p8i0
        E0wLTpM1mPjhFA8iKkNA4/I=
X-Google-Smtp-Source: ABdhPJyhwkvK6HjdnTtyfaFOTVFsx4+sGnRU6fueMFHe+NVCo4W+7y4koxbeDiVeB2Qjyx1iFq/sYQ==
X-Received: by 2002:a05:6402:4387:: with SMTP id o7mr36240102edc.47.1639163425788;
        Fri, 10 Dec 2021 11:10:25 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id u23sm1957403edi.88.2021.12.10.11.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 11:10:25 -0800 (PST)
Message-ID: <61b3a621.1c69fb81.b4bf5.8dd2@mx.google.com>
X-Google-Original-Message-ID: <YbOmHec4qqaG+jHW@Ansuel-xps.>
Date:   Fri, 10 Dec 2021 20:10:21 +0100
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b396c3.1c69fb81.17062.836a@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 07:04:48PM +0100, Ansuel Smith wrote:
> On Fri, Dec 10, 2021 at 06:29:32PM +0100, Ansuel Smith wrote:
> > On Fri, Dec 10, 2021 at 05:15:30PM +0000, Vladimir Oltean wrote:
> > > On Fri, Dec 10, 2021 at 06:10:45PM +0100, Ansuel Smith wrote:
> > > > On Fri, Dec 10, 2021 at 05:02:42PM +0000, Vladimir Oltean wrote:
> > > > > On Fri, Dec 10, 2021 at 04:37:52AM +0100, Ansuel Smith wrote:
> > > > > > On Thu, Dec 09, 2021 at 07:39:23PM +0200, Vladimir Oltean wrote:
> > > > > > > This patch set is provided solely for review purposes (therefore not to
> > > > > > > be applied anywhere) and for Ansuel to test whether they resolve the
> > > > > > > slowdown reported here:
> > > > > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
> > > > > > > 
> > > > > > > The patches posted here are mainly to offer a consistent
> > > > > > > "master_state_change" chain of events to switches, without duplicates,
> > > > > > > and always starting with operational=true and ending with
> > > > > > > operational=false. This way, drivers should know when they can perform
> > > > > > > Ethernet-based register access, and need not care about more than that.
> > > > > > > 
> > > > > > > Changes in v2:
> > > > > > > - dropped some useless patches
> > > > > > > - also check master operstate.
> > > > > > > 
> > > > > > > Vladimir Oltean (4):
> > > > > > >   net: dsa: provide switch operations for tracking the master state
> > > > > > >   net: dsa: stop updating master MTU from master.c
> > > > > > >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
> > > > > > >   net: dsa: replay master state events in
> > > > > > >     dsa_tree_{setup,teardown}_master
> > > > > > > 
> > > > > > >  include/net/dsa.h  | 11 +++++++
> > > > > > >  net/dsa/dsa2.c     | 80 +++++++++++++++++++++++++++++++++++++++++++---
> > > > > > >  net/dsa/dsa_priv.h | 13 ++++++++
> > > > > > >  net/dsa/master.c   | 29 ++---------------
> > > > > > >  net/dsa/slave.c    | 27 ++++++++++++++++
> > > > > > >  net/dsa/switch.c   | 15 +++++++++
> > > > > > >  6 files changed, 145 insertions(+), 30 deletions(-)
> > > > > > > 
> > > > > > > -- 
> > > > > > > 2.25.1
> > > > > > > 
> > > > > > 
> > > > > > Hi, I tested this v2 and I still have 2 ethernet mdio failing on init.
> > > > > > I don't think we have other way to track this. Am I wrong?
> > > > > > 
> > > > > > All works correctly with this and promisc_on_master.
> > > > > > If you have other test, feel free to send me other stuff to test.
> > > > > > 
> > > > > > (I'm starting to think the fail is caused by some delay that the switch
> > > > > > require to actually start accepting packet or from the reinit? But I'm
> > > > > > not sure... don't know if you notice something from the pcap)
> > > > > 
> > > > > I've opened the pcap just now. The Ethernet MDIO packets are
> > > > > non-standard. When the DSA master receives them, it expects the first 6
> > > > > octets to be the MAC DA, because that's the format of an Ethernet frame.
> > > > > But the packets have this other format, according to your own writing:
> > > > > 
> > > > > /* Specific define for in-band MDIO read/write with Ethernet packet */
> > > > > #define QCA_HDR_MDIO_SEQ_LEN           4 /* 4 byte for the seq */
> > > > > #define QCA_HDR_MDIO_COMMAND_LEN       4 /* 4 byte for the command */
> > > > > #define QCA_HDR_MDIO_DATA1_LEN         4 /* First 4 byte for the mdio data */
> > > > > #define QCA_HDR_MDIO_HEADER_LEN        (QCA_HDR_MDIO_SEQ_LEN + \
> > > > >                                        QCA_HDR_MDIO_COMMAND_LEN + \
> > > > >                                        QCA_HDR_MDIO_DATA1_LEN)
> > > > > 
> > > > > #define QCA_HDR_MDIO_DATA2_LEN         12 /* Other 12 byte for the mdio data */
> > > > > #define QCA_HDR_MDIO_PADDING_LEN       34 /* Padding to reach the min Ethernet packet */
> > > > > 
> > > > > The first 6 octets change like crazy in your pcap. Definitely can't add
> > > > > that to the RX filter of the DSA master.
> > > > > 
> > > > > So yes, promisc_on_master is precisely what you need, it exists for
> > > > > situations like this.
> > > > > 
> > > > > Considering this, I guess it works?
> > > > 
> > > > Yes it works! We can totally accept 2 mdio timeout out of a good way to
> > > > track the master port. It's probably related to other stuff like switch
> > > > delay or other.
> > > > 
> > > > Wonder the next step is wait for this to be accepted and then I can
> > > > propose a v3 of my patch? Or net-next is closed now and I should just
> > > > send v3 RFC saying it does depend on this?
> > > 
> > > Wait a minute, I don't think I understood your previous reply.
> > > With promisc_on_master, is there or is there not any timeout?
> > 
> > With promisc_on_master I have only 2 timeout.
> > 
> > > My understanding was this: DSA tells you when the master is up and
> > > operational. That information is correct, except it isn't sufficient and
> > > you don't see the replies back. Later during boot, you have some init
> > > scripts triggered by user space that create a bridge interface and put
> > > the switch ports under the bridge. The bridge puts the switch interfaces
> > > in promiscuous mode, because that's what bridges do. Then DSA propagates
> > > the promiscuous mode from the switch ports to the DSA master, and once
> > > the master is promiscuous, the Ethernet MDIO starts working too.
> > > Now, with promisc_on_master set, the DSA master is already promiscuous
> > > by the time DSA tells you that it's up and running. Hence your message
> > > that "All works correctly with this and promisc_on_master."
> > > What did I misunderstand?
> > 
> > You got all correct. But still I have these 2 timeout at the very start.
> > Let me give you another pastebin to make this more clear. [0]
> > Transaction done is when the Ethernet packet is received and processed.
> > I added some pr with the events received by switch.c
> > 
> > I should check if the tagger receive some packet before the
> > "function timeout". 
> > What I mean with "acceptable state" is that aside from the 2
> > timeout everything else works correctly withtout any slowdown in the
> > init process.
> > 
> > [0] https://pastebin.com/VfGB5hAQ
> > 
> > -- 
> > 	Ansuel
> 
> Ok I added more tracing and packet are received to the tagger right
> after the log from ipv6 "link becomes ready". That log just check if the
> interface is up and if it does have a valid sched.
> I notice after link becomes ready we have a CHANGE event for eth0. That
> should be the correct way to understand when the cpu port is actually
> usable.
> (just to make it clear before the link becomes ready no packet is
> received to the tagger and the completion timeouts)
> 
> -- 
> 	Ansuel

Sorry for the triple message spam... I have a solution. It seems packet
are processed as soon as dev_activate is called (so a qdisk is assigned)
By adding another bool like master_oper_ready and

void dsa_tree_master_oper_state_ready(struct dsa_switch_tree *dst,
                                      struct net_device *master,
                                      bool up);

static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
                                        struct net_device *master)
{
       struct dsa_notifier_master_state_info info;
       struct dsa_port *cpu_dp = master->dsa_ptr;

       info.master = master;
       info.operational = cpu_dp->master_admin_up && cpu_dp->master_oper_up && cpu_dp->master_oper_ready;

       dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_STATE_CHANGE, &info);
}

void dsa_tree_master_oper_state_ready(struct dsa_switch_tree *dst,
                                      struct net_device *master,
                                      bool up)
{
       struct dsa_port *cpu_dp = master->dsa_ptr;
       bool notify = false;

       if ((cpu_dp->master_oper_ready && cpu_dp->master_oper_ready) !=
           (cpu_dp->master_oper_ready && up))
               notify = true;

       cpu_dp->master_oper_ready = up;

       if (notify)
               dsa_tree_master_state_change(dst, master);
}

In slave.c at the NETDEV_CHANGE event the additional
dsa_tree_master_oper_state_ready(dst, dev, dev_ingress_queue(dev));
we have no timeout function. I just tested this and it works right away.

Think we need this additional check to make sure the tagger can finally
accept packet from the switch.

With this added I think this is ready.

-- 
	Ansuel
