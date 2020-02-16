Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E7E160489
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 16:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgBPPdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 10:33:33 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43415 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgBPPdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 10:33:33 -0500
Received: by mail-pg1-f193.google.com with SMTP id u12so7347698pgb.10;
        Sun, 16 Feb 2020 07:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XIEPrOUEc1xxULTMEXHUWg4Qjw7jq42rfdXNd7KhPm0=;
        b=BHr0jtmdSFo5SLeKbPpnFJoeBLATA6KiCLy+hyrRGKN8KbNvjxZ/J43HsJYCVHOzMd
         Q6OAkwpSXJZFKMuHKPtxMF1X2hmBPsxRa8lhrm0kiUwG00ub0kvx6+9wE8oUBEec2njr
         EPuMwg4LhYMpTptmi8w7XmTHRl4SDsa/QVMzN/543SyYgSHGN7FhJOve5/uD9Fsc3fXP
         leQOPbLTa10oqBFxnrYs1Ynxc59xc7a/nJ7EDhydBtaGVk/kJSgPZ7ZGp8IrUnZO1TN9
         pb8jXvat/htlqWdzY4I6MZdXNjjKe5a8HL6txN9iArq59JtTbjOkiFoUcuYVTNC0PH85
         t04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XIEPrOUEc1xxULTMEXHUWg4Qjw7jq42rfdXNd7KhPm0=;
        b=S51dXmlfA/vnKDxV6Y0xNnnFq2FQw1OP5rvU7w4IUAqYUCjbzxk4BVlxApTgUpnV85
         YrSPpg961km6phY1OmyvSMCRApUswhDuGZBqJxz+cIpFOZejVvvB0iUDq9zqJSYL/JPp
         bnGRDun8kPLAKKrL1XWhltvg6RAXHwlo73dqmszgc0ubHmTyRfukg7c1WNjrTFcZI0i7
         WECR6McEN9/SF/5a5fTvRPWMWdI0aeAxq4+Kyb4ztrpK86Pqn5bLZShGUOWsC/WDf4xy
         tGRMn8DfQElVW85GqwFebZUtHX6IX0Nq4Nma4tClpca+UDku5KyYxOJiEp0yJmNi+Lej
         eXzw==
X-Gm-Message-State: APjAAAV1mfYp8SWObD5pqwVKafSMqgbpDrkilJ+xMwJvrHgdQkm9Rmez
        fg0FjVa04+n6dtBljodsDQ==
X-Google-Smtp-Source: APXvYqxt6ISJAda/OBTeJGQHGHJPXLd2MKMKC3TChnw4o2Ef3kJeSPKe0NBrjzvD4aZJzBf/m1Xw0w==
X-Received: by 2002:a65:6147:: with SMTP id o7mr14233461pgv.442.1581867211415;
        Sun, 16 Feb 2020 07:33:31 -0800 (PST)
Received: from madhuparna-HP-Notebook ([2402:3a80:d03:50cf:14b2:4950:fe83:57e])
        by smtp.gmail.com with ESMTPSA id m15sm14347484pgn.40.2020.02.16.07.33.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 16 Feb 2020 07:33:30 -0800 (PST)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Sun, 16 Feb 2020 21:03:24 +0530
To:     Sven Eckelmann <sven@narfation.org>
Cc:     madhuparnabhowmik10@gmail.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com, linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: batman-adv: Use built-in RCU list checking
Message-ID: <20200216153324.GA4542@madhuparna-HP-Notebook>
References: <20200216144718.2841-1-madhuparnabhowmik10@gmail.com>
 <3655191.udZcvKk8tv@sven-edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3655191.udZcvKk8tv@sven-edge>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 04:22:51PM +0100, Sven Eckelmann wrote:
> On Sunday, 16 February 2020 15:47:18 CET madhuparnabhowmik10@gmail.com wrote:
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > hlist_for_each_entry_rcu() has built-in RCU and lock checking.
> > 
> > Pass cond argument to hlist_for_each_entry_rcu() to silence
> > false lockdep warnings when CONFIG_PROVE_RCU_LIST is enabled
> > by default.
> > 
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > ---
> >  net/batman-adv/translation-table.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> Added with alignment and line length codingstyle fixes [1].
> 
> Can you tell us how you've identified these four hlist_for_each_entry_rcu?
>
Hi Sven,

Thank you for the fixes.
The other hlist_for_each_entry_rcu() are used under the protection of
rcu_read_lock(). We only need to pass the cond when
hlist_for_each_entry_rcu() is used under a
different lock (not under rcu_red_lock()) because according to the current scheme a lockdep splat
is generated when hlist_for_each_entry_rcu() is used outside of
rcu_read_lock() or the lockdep condition (the cond argument) evaluates
to false. So, we need to pass this cond when it is used under the
protection of spinlock or mutex etc. and not required if rcu_read_lock()
is used.

Thank you,
Madhuparna
> Thanks,
> 	Sven
> 
> [1] https://git.open-mesh.org/linux-merge.git/commit/967709ec53a07d1bccbc3716f7e979d3103bd7c5


