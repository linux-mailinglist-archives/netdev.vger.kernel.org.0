Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B4225ED9E
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 13:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgIFLM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 07:12:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55171 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgIFLMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 07:12:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0DA135C00D2;
        Sun,  6 Sep 2020 07:12:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 06 Sep 2020 07:12:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2z4dWQ
        O59QVm1/ss2wiMON2ioGsD6WQtzXPXXDBUgvE=; b=YPFvZ40t5sNaDO+HmYsju8
        j4FwBGcVOCP4qwnIEjxvXlE2giauBa3MzY6ao9pqo4uxrPkMO142euGrqWzqbdCV
        +8E7YmNKqy7G7hQbkLFVdWypZEujKsli9R24M+YKPsWxkykU7dEa5MpdprpX2nWs
        mjfID2VAhvYwKN0pS4/k9Yx+p+Hdss9gnVNY0RF4gkXNCTKrWV25Z02C+ufNel0M
        20uPBQke4OCvJKZQMg6JUSMKeTFfOMpZOVRBQOZwJ/aSBDYlIZSUFWOEUZoHtqYM
        HbFh9INMKF6RvMEWPHTMUp0pbLnU0hK6t/yzDB4QxkMHrZjth4Xkv9pVCU+/g0ww
        ==
X-ME-Sender: <xms:NMRUX5uOPj8QNcpDzUfMe1odzxrtBjxBsbiaJnOvnL4G7pnAIwfjLg>
    <xme:NMRUXycWnEoFPhxXKOq2iswyInsgVstSv1pSCopSaIu60hUQmYsgo2-mHcVsRWEyx
    byHey6OHrxZY78>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegjedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefiedruddvkeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:NMRUX8zQsDVZ9DHVd_r6cMi_82L8HBXR7J5QQKrQosi3FdSekTkjCQ>
    <xmx:NMRUXwOb02BoF9szzdWI4wGWIyWOWYMT0X-WuEAFa-z2aAPu9xZkxg>
    <xmx:NMRUX592ZRTG-l5wzE6rj5G3wrGpfrrrr4csxgYWGNuC9YamSZgjPg>
    <xmx:NsRUX0Z5zHAm_QEX-LCPzcKjF_0XuW07x9NbcDJzTwIrJccE7ueSfQ>
Received: from localhost (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B726306467E;
        Sun,  6 Sep 2020 07:12:52 -0400 (EDT)
Date:   Sun, 6 Sep 2020 14:12:49 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: Failing to attach bond(created with two interfaces from
 different NICs) to a bridge
Message-ID: <20200906111249.GA2419244@shredder.lan>
References: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
 <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 12:14:28PM -0700, Jakub Kicinski wrote:
> On Thu, 3 Sep 2020 12:52:25 +0530 Vasundhara Volam wrote:
> > Hello Jiri,
> > 
> > After the following set of upstream commits, the user fails to attach
> > a bond to the bridge, if the user creates the bond with two interfaces
> > from different bnxt_en NICs. Previously bnxt_en driver does not
> > advertise the switch_id for legacy mode as part of
> > ndo_get_port_parent_id cb but with the following patches, switch_id is
> > returned even in legacy mode which is causing the failure.
> > 
> > ---------------
> > 7e1146e8c10c00f859843817da8ecc5d902ea409 net: devlink: introduce
> > devlink_compat_switch_id_get() helper
> > 6605a226781eb1224c2dcf974a39eea11862b864 bnxt: pass switch ID through
> > devlink_port_attrs_set()
> > 56d9f4e8f70e6f47ad4da7640753cf95ae51a356 bnxt: remove
> > ndo_get_port_parent_id implementation for physical ports
> > ----------------
> > 
> > As there is a plan to get rid of ndo_get_port_parent_id in future, I
> > think there is a need to fix devlink_compat_switch_id_get() to return
> > the switch_id only when device is in SWITCHDEV mode and this effects
> > all the NICs.
> > 
> > Please let me know your thoughts. Thank you.
> 
> I'm not Jiri, but I'd think that hiding switch_id from devices should
> not be the solution here. Especially that no NICs offload bridging
> today. 
> 
> Could you describe the team/bridge failure in detail, I'm not that
> familiar with this code.

Maybe:

br_add_slave()
	br_add_if()
		nbp_switchdev_mark_set()
			dev_get_port_parent_id()

I believe the last call will return '-ENODATA' because the two bnxt
netdevs member in the bond have different switch IDs. Perhaps the
function can be changed to return '-EOPNOTSUPP' when it's called for an
upper device that have multiple parent IDs beneath it:

diff --git a/net/core/dev.c b/net/core/dev.c
index d42c9ea0c3c0..7932594ca437 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8646,7 +8646,7 @@ int dev_get_port_parent_id(struct net_device *dev,
                if (!first.id_len)
                        first = *ppid;
                else if (memcmp(&first, ppid, sizeof(*ppid)))
-                       return -ENODATA;
+                       return -EOPNOTSUPP;
        }
 
        return err;
