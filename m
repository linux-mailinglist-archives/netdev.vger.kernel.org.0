Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C440B25F420
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgIGHgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:36:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51351 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbgIGHgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:36:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7B5FF5C0117;
        Mon,  7 Sep 2020 03:36:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Sep 2020 03:36:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BX3Yd1
        6YTvIjzxzIgDzPgSrUa7+hMF3VetQZvcsgTF4=; b=FzNGBuMOgyAdZLMN+FexmO
        vleTEK0ncOUQSxx07He+F67gk7JC2cz4+1FGx4u0sL+EQVD1W0z9tvkMqcp3qXTD
        Up7Da8K3JL+am7KHNO3TzqQOsspgg4++7StV+/IllSOdFiloJ5gB7tKDHMDxshQg
        EIgTuj6OlfLRpHrcs4VJ2vKhv20x7iFiK7kBOrZC684CxzrDalvLdHhzp9nYjM6m
        p6hcF7ldhpAAlVFkHMvyBWPvMMsi1pPzKAJ5RD5KCFv4eOtPtXGC+Nam/JyzcFBi
        2q1onV4fsSOpHD+onLaG2ZrA2qJu2MdhF39tS3DKVRHfyesNYXZcjDC5WEKgSMsg
        ==
X-ME-Sender: <xms:BuNVXxdulKQj0rv2EQrerWFTDIm8OgNAS9F6fVj0Gv3r1Z_jI-2nKQ>
    <xme:BuNVX_OlRSXlyYmhDWbTM_trNrGp44zHL2f_LFPKVVlvmql_Dp-CqlDM1_b8gdgYf
    ntrFg17Ozdmykw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegledgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeekgfevfefgffdvfffhtdeujedvheduudejtdekjeevuedtgfduieeghfdtvedu
    udenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhmrghilhdqrghrtghhihhvvgdrtg
    homhenucfkphepkeegrddvvdelrdefiedruddvkeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BuNVX6hSJB9MEcMvPoqwcHslvlHpIXUT1USLPAVu6zDJGKMZlvxO8w>
    <xmx:BuNVX6-NfQxCxcgdebraZp_rajxn1SjtLGGv7YaKZP-Nj1faRygQxw>
    <xmx:BuNVX9tRWLqNYFudipib4hdvazG--E8WkLZ6w0msr4KH0-cRaNTFKQ>
    <xmx:CeNVX3LB3iWQUrs14dcBhTwLHSp_I74Mxp_GMEn2aOunwYZRfLHZ3Q>
Received: from localhost (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 84F2F3280063;
        Mon,  7 Sep 2020 03:36:38 -0400 (EDT)
Date:   Mon, 7 Sep 2020 10:36:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: Failing to attach bond(created with two interfaces from
 different NICs) to a bridge
Message-ID: <20200907073635.GA2455115@shredder>
References: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
 <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200906111249.GA2419244@shredder.lan>
 <20200906101335.47b2b60b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0502c0a4-0c2e-65d8-cd1e-860856510391@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0502c0a4-0c2e-65d8-cd1e-860856510391@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 06, 2020 at 12:23:23PM -0700, Florian Fainelli wrote:
> 
> 
> On 9/6/2020 10:13 AM, Jakub Kicinski wrote:
> > On Sun, 6 Sep 2020 14:12:49 +0300 Ido Schimmel wrote:
> > > On Thu, Sep 03, 2020 at 12:14:28PM -0700, Jakub Kicinski wrote:
> > > > On Thu, 3 Sep 2020 12:52:25 +0530 Vasundhara Volam wrote:
> > > > > Hello Jiri,
> > > > > 
> > > > > After the following set of upstream commits, the user fails to attach
> > > > > a bond to the bridge, if the user creates the bond with two interfaces
> > > > > from different bnxt_en NICs. Previously bnxt_en driver does not
> > > > > advertise the switch_id for legacy mode as part of
> > > > > ndo_get_port_parent_id cb but with the following patches, switch_id is
> > > > > returned even in legacy mode which is causing the failure.
> > > > > 
> > > > > ---------------
> > > > > 7e1146e8c10c00f859843817da8ecc5d902ea409 net: devlink: introduce
> > > > > devlink_compat_switch_id_get() helper
> > > > > 6605a226781eb1224c2dcf974a39eea11862b864 bnxt: pass switch ID through
> > > > > devlink_port_attrs_set()
> > > > > 56d9f4e8f70e6f47ad4da7640753cf95ae51a356 bnxt: remove
> > > > > ndo_get_port_parent_id implementation for physical ports
> > > > > ----------------
> > > > > 
> > > > > As there is a plan to get rid of ndo_get_port_parent_id in future, I
> > > > > think there is a need to fix devlink_compat_switch_id_get() to return
> > > > > the switch_id only when device is in SWITCHDEV mode and this effects
> > > > > all the NICs.
> > > > > 
> > > > > Please let me know your thoughts. Thank you.
> > > > 
> > > > I'm not Jiri, but I'd think that hiding switch_id from devices should
> > > > not be the solution here. Especially that no NICs offload bridging
> > > > today.
> > > > 
> > > > Could you describe the team/bridge failure in detail, I'm not that
> > > > familiar with this code.
> > > 
> > > Maybe:
> > > 
> > > br_add_slave()
> > > 	br_add_if()
> > > 		nbp_switchdev_mark_set()
> > > 			dev_get_port_parent_id()
> > > 
> > > I believe the last call will return '-ENODATA' because the two bnxt
> > > netdevs member in the bond have different switch IDs. Perhaps the
> > > function can be changed to return '-EOPNOTSUPP' when it's called for an
> > > upper device that have multiple parent IDs beneath it:
> > > 
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index d42c9ea0c3c0..7932594ca437 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -8646,7 +8646,7 @@ int dev_get_port_parent_id(struct net_device *dev,
> > >                  if (!first.id_len)
> > >                          first = *ppid;
> > >                  else if (memcmp(&first, ppid, sizeof(*ppid)))
> > > -                       return -ENODATA;
> > > +                       return -EOPNOTSUPP;
> > >          }
> > >          return err;
> > 
> > LGTM, or we could make bridge ignore ENODATA (in case the distinctions
> > is useful?)
> > 
> > I was searching for the early versions of Florian's patch set but
> > I can't find it :( Florian, do you remember if there was a reason to
> > fail bridge in this case?
> 
> v3: https://patchwork.kernel.org/patch/10798697/
> v2: https://lore.kernel.org/patchwork/patch/1038907/
> v1:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1921358.html
> 
> I went back to check the tree before
> d6abc5969463359c366d459247b90366fcd6f5c5 and the logic for return -ENODATA
> was copied from switchdev_port_attr_get():
> 
> ...
>           /* Switch device port(s) may be stacked under
>            * bond/team/vlan dev, so recurse down to get attr on
>            * each port.  Return -ENODATA if attr values don't
>            * compare across ports.
>            */
> 
>           netdev_for_each_lower_dev(dev, lower_dev, iter) {
>                   err = switchdev_port_attr_get(lower_dev, attr);
>                   if (err)
>                           break;
>                   if (first.id == SWITCHDEV_ATTR_ID_UNDEFINED)
>                           first = *attr;
>                   else if (memcmp(&first, attr, sizeof(*attr)))
>                           return -ENODATA;
>           }
> 
>           return err;
>   }
>   EXPORT_SYMBOL_GPL(switchdev_port_attr_get);
> 
> the bridge code would specifically treat -EOPNOTSUPP as success and return
> early, whereas other error code would be treated as a failure.
> 
> Jiri or Ido, do you remember the reason for return -ENODATA here?

I don't know about the past, but I checked all the current callers of
dev_get_port_parent_id() and I think the proposed change should be OK:

1. nbp_switchdev_mark_set(): Current use case. Does not seem to be a
problem

2. dev_get_port_parent_id(): Recursive call

3. netdev_port_same_parent_id(): Unaffected by this change

4. phys_switch_id_show(): Likewise. Does not recurse

5. rtnl_phys_switch_id_fill(): Likewise

6. vif_add: Does not check the error code

I can test the patch in our regression and submit later this week unless
you have a better suggestion. Please let me know.

Thanks
