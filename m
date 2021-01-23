Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748CC301696
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 17:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAWQFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 11:05:03 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40121 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbhAWQE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 11:04:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B08995C014E;
        Sat, 23 Jan 2021 11:03:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 23 Jan 2021 11:03:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=aq6Uu67tL9E9uPSKo9XbNQhKfBADUmFovTpQgKZV7
        10=; b=eEpIZz5LPbnlMbVPdQKlxxd+c4XilDegayL5pQjaJdL8TopfDnbTHW/oU
        bFaNBIyukz+Lh0pQXEqwz7qC1BQXTxxrzVWcigfN9An6f2R4kNGtIenmQMDRa/70
        toKzUqWwm6wk8ZCL5unzO4Hsb5SENVEmqsyfoYqFguUhfCl/LhyLbPzur2OjTtbg
        PqNBiK6WwjyqYbXrAsw+tvqZjTpu5qqc9hDrqzBr6OCirt3DxIUXBsutrq4UYewR
        d26bOrkQyMsDKvIbdY9GwxaYJ1qShKO2J2ynQ3JPprDXF9joK9qgj1u4SWj5ApDk
        Ngg2qqlJ9g8QoQpKxu8cEH4nbZ+AQ==
X-ME-Sender: <xms:6EgMYBgouMwvWwofplvF9vMcUmyvUBSeMR1D_bGfClJlL3iNkWTSwg>
    <xme:6EgMYGC-hKzc-_1_UD-LnQJYl3YThh4fAhSoECqJA7YtoW5HjdjBVV7QQvSMmgfbS
    tuKB5VbFzao2Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvffevkeefieeiueeitedufeekveekuefhueeiudduteekgeelfedvgeehjeeh
    hfenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6EgMYBGnb2_jOiqidyJO--FdzP3SnIQdmHDFmhtKZVqZG_QeyHYsTQ>
    <xmx:6EgMYGTUMslxM-2kLU--QEbkEGp6iRnQy5TM43zByjG34bn3G58y9Q>
    <xmx:6EgMYOwK6hVM6xomDfTgnPJ3S4q8fgxZZiGri6hNBLLdHmFQR0wesQ>
    <xmx:6EgMYJ8J2xR_TnXcVEMiBJkOc32yDTZcufhAvkndsN_oO2RZntRr_Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F3CC1080057;
        Sat, 23 Jan 2021 11:03:51 -0500 (EST)
Date:   Sat, 23 Jan 2021 18:03:48 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Message-ID: <20210123160348.GB2799851@shredder.lan>
References: <AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 08:36:01AM +0000, Oleksandr Mazur wrote:
> On Thu, 21 Jan 2021 14:21:52 +0200 Ido Schimmel wrote:
> > On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote:
> > > Add new trap action HARD_DROP, which can be used by the
> > > drivers to register traps, where it's impossible to get
> > > packet reported to the devlink subsystem by the device
> > > driver, because it's impossible to retrieve dropped packet
> > > from the device itself.
> > > In order to use this action, driver must also register
> > > additional devlink operation - callback that is used
> > > to retrieve number of packets that have been dropped by
> > > the device.  
> > 
> > Are these global statistics about number of packets the hardware dropped
> > for a specific reason or are these per-port statistics?
> > 
> > It's a creative use of devlink-trap interface, but I think it makes
> > sense. Better to re-use an existing interface than creating yet another
> > one.
> 
> > Not sure if I agree, if we can't trap why is it a trap?
> > It's just a counter.
> 
> It's just another ACTION for trap item. Action however can be switched, e.g. from HARD_DROP to MIRROR.
> 
> The thing is to be able to configure specific trap to be dropped, and provide a way for the device to report back how many packets have been dropped.
> If device is able to report the packet itself, then devlink would be in charge of counting. If not, there should be a way to retrieve these statistics from the devlink.

So no need for another action. Just report these stats via
'DEVLINK_ATTR_STATS_RX_DROPPED' if the hardware supports it.

Currently you do:

+static int
+devlink_trap_hard_drop_stats_put(struct sk_buff *msg,
+				 struct devlink *devlink,
+				 const struct devlink_trap_item *trap_item)
+{
+	struct nlattr *attr;
+	u64 drops;
+	int err;
+
+	err = devlink->ops->trap_hard_drop_counter_get(devlink, trap_item->trap,
+						       &drops);
+	if (err)
+		return err;
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd, u32 portid, u32 seq,
@@ -6857,7 +6889,10 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, trap_item->stats);
+	if (trap_item->action == DEVLINK_TRAP_ACTION_HARD_DROP)
+		err = devlink_trap_hard_drop_stats_put(msg, devlink, trap_item);
+	else
+		err = devlink_trap_stats_put(msg, trap_item->stats);
 	if (err)
 		goto nla_put_failure;

Which means that user space will see stats come and go based on the
trap's action. That's not desirable. Instead, change:

[DEVLINK_ATTR_STATS]
	[DEVLINK_ATTR_STATS_RX_PACKETS]
	[DEVLINK_ATTR_STATS_RX_BYTES]

To:

[DEVLINK_ATTR_STATS]
	[DEVLINK_ATTR_STATS_RX_PACKETS]
	[DEVLINK_ATTR_STATS_RX_BYTES]
	[DEVLINK_ATTR_STATS_RX_DROPPED]

Where the last attribute is reported to user space for devices that
support such stats. No changes required in uAPI / iproute2.
