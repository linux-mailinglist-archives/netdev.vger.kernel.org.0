Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6119D441A25
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 11:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhKAKt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 06:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhKAKtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 06:49:24 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65364C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 03:46:51 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id h74so1989949pfe.0
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 03:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uLZnCK2vG2ue2FGckFgnrzceCVeAwVXBZxRaEkA4mB0=;
        b=Yw8nuz1XG8pF4EGXweP0F8dOai0FlFoQOO3rM73eo8kBZtdSxrRtNmZZ74/vqBUyM3
         ujau1VYQgfBHOfPjXB1pjKe08V/1G9VZNCY6QjiV/kZ/H4JPEoaW91rAM5ErhRlqReF3
         l22YkpBuxnfdHpICdrzXYUw6JnW5tyR7gh09ScIIitHt1aVMYjvkQMknZZb6YJtogp9J
         xXtYkWuGOS5PamJOnnYZcutTeb6014vCDcWpx48ovKq6RYQsvHpXTSEtzeHSA2hfU5TW
         IkgUrFpiIZxr1ihbTjb1pyp1WmiYduWsszExMXYpQaVcSaMNp7Gi8uRgJqzh94Gv3sO+
         vi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uLZnCK2vG2ue2FGckFgnrzceCVeAwVXBZxRaEkA4mB0=;
        b=ynomGXS6n/vPkbzMohPoDA4/pqluaJDIcrYhWrD5ik9PQ6ErcQEauZQaDKcunFsKnq
         WTQ2yMZREdlmDV8syCjTOb5As4rDgrh8HVmqGJhnzFBw5Y8eEWW+OaBXSOFoaFPTxvxE
         7OZBdzUcx2y0yy/BWIR+P+dPk2snw7CUO+f5wZFNSlRWKbpqc6resJPN2zm1JPMz7jbO
         lm8q+R5sfXhZqsROxh3CX86po9H3hDd77JXpBGrFYRJ42mlXYwetIZDib9ExNE2y3Jte
         Bdw2ZhyyqutDjs1crQ1vlqaLubWpiI3yXak9X+0wd/KlMXpTN2Eg0JrRx8+/NPR4eec+
         ssNg==
X-Gm-Message-State: AOAM530TnIsdqNSuUHOGx3nNs1hW6c9zmUfMsmsYwmjFH9xwIwiJD+qo
        +9m3wVEAeYxPcPlUiex+yHI=
X-Google-Smtp-Source: ABdhPJzecvUyzsIeRfsaK2zAqE5kLhGDTMI/WZDuGm/86xrv6Tmgjly2jdne2KOMo32jyBLrqsjT/g==
X-Received: by 2002:a63:4c5c:: with SMTP id m28mr20951255pgl.67.1635763610979;
        Mon, 01 Nov 2021 03:46:50 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm14595803pfl.41.2021.11.01.03.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 03:46:50 -0700 (PDT)
Date:   Mon, 1 Nov 2021 18:46:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jonathan Toppins <jtoppins@redhat.com>
Subject: Re: [Draft PATCH net-next] Bonding: add missed_max option
Message-ID: <YX/FlQKJNea3c4/B@Laptop-X1>
References: <20211029065529.27367-1-liuhangbin@gmail.com>
 <7320.1635545478@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7320.1635545478@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jay, Denis,

Thanks for the comments. Please see my replies below.

On Fri, Oct 29, 2021 at 03:11:18PM -0700, Jay Vosburgh wrote:
> >+missed_max
> >+
> >+        Maximum number of arp_interval for missed ARP replies.
> >+        If this number is exceeded, link is reported as down.
> >+
> >+        Note a small value means a strict time. e.g. missed_max is 1 means
> >+        the correct arp reply must be recived during the interval.
> >+
> >+        default 3
> 
> 	I'd suggest "arp" in the option name to make the scope more
> obvious.

I didn't add arp prefix in purpose because I'd like to re-use this parameter
after adding bonding IPv6 NS/NA support. I will add this reason in the commit
description.

Or if you like to make a difference for ARP and IPv6 NS, I can add the arp_
prefix.

> >@@ -3224,7 +3224,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
> > 
> > 		/* Backup slave is down if:
> > 		 * - No current_arp_slave AND
> >-		 * - more than 3*delta since last receive AND
> >+		 * - more than missed_max*delta since last receive AND
> > 		 * - the bond has an IP address
> > 		 *
> > 		 * Note: a non-null current_arp_slave indicates
> >@@ -3236,20 +3236,20 @@ static int bond_ab_arp_inspect(struct bonding *bond)
> > 		 */
> > 		if (!bond_is_active_slave(slave) &&
> > 		    !rcu_access_pointer(bond->current_arp_slave) &&
> >-		    !bond_time_in_interval(bond, last_rx, 3)) {
> >+		    !bond_time_in_interval(bond, last_rx, bond->params.missed_max)) {
> > 			bond_propose_link_state(slave, BOND_LINK_DOWN);
> > 			commit++;
> > 		}
> > 
> > 		/* Active slave is down if:
> >-		 * - more than 2*delta since transmitting OR
> >-		 * - (more than 2*delta since receive AND
> >+		 * - more than missed_max*delta since transmitting OR
> >+		 * - (more than missed_max*delta since receive AND
> > 		 *    the bond has an IP address)
> > 		 */
> > 		trans_start = dev_trans_start(slave->dev);
> > 		if (bond_is_active_slave(slave) &&
> >-		    (!bond_time_in_interval(bond, trans_start, 2) ||
> >-		     !bond_time_in_interval(bond, last_rx, 2))) {
> >+		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
> >+		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
> > 			bond_propose_link_state(slave, BOND_LINK_DOWN);
> > 			commit++;
> > 		}
> 
> 	The above two changes make the backup and active logic both
> switch to using the missed_max value (i.e., both set to the same value),
> when previously these two cases used differing values (2 for active, 3
> for backup).
> 
> 	Historically, these intervals were staggered deliberately; an
> old comment removed by b2220cad583c9b states:
> 
> 			if ((slave != bond->curr_active_slave) &&
> 			    (!bond->current_arp_slave) &&
> 			    (time_after_eq(jiffies, slave_last_rx(bond, slave) + 3*delta_in_ticks))) {
> 				/* a backup slave has gone down; three times
> 				 * the delta allows the current slave to be
> 				 * taken out before the backup slave.
> 
> 	I think it would be prudent to insure that having the active and
> backup timeouts set in lockstep does not result in an undesirable change
> of behavior.

Yes, I'm also a little concern about this. What about make the backup slave
timeout 1 plus delta then active slave. i.e. for backup slave

bond_time_in_interval(bond, last_rx, bond->params.missed_max + 1)

> >@@ -270,6 +272,15 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
> > 		.values = bond_intmax_tbl,
> > 		.set = bond_option_arp_interval_set
> > 	},
> >+	[BOND_OPT_MISSED_MAX] = {
> >+		.id = BOND_OPT_MISSED_MAX,
> >+		.name = "missed_max",
> >+		.desc = "Maximum number of missed ARP interval",
> >+		.unsuppmodes = BIT(BOND_MODE_8023AD) | BIT(BOND_MODE_TLB) |
> >+			       BIT(BOND_MODE_ALB),
> >+		.values = bond_intmax_tbl,
> 
> 	This allows missed_max to be set to 0; is that intended to be a
> valid setting?

In bond_time_in_interval() there is an arp_interval/2 extra time. Do you think
if this is enough for fast network when we set missed_max to 0?

Of course in the very fast network the value should be at lease 1 in case
the ARP send/recv time frame is same.

Thanks
Hangbin
