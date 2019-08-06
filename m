Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93C983BDF
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfHFVi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:38:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbfHFViZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:38:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 123B81423AA78;
        Tue,  6 Aug 2019 14:38:25 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:38:24 -0700 (PDT)
Message-Id: <20190806.143824.217572108778111632.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] Fixes for SJA1105 DSA: FDBs, Learning and PTP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190804223848.31676-1-olteanv@gmail.com>
References: <20190804223848.31676-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:38:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  5 Aug 2019 01:38:43 +0300

> This is an assortment of functional fixes for the sja1105 switch driver
> targeted for the "net" tree (although they apply on net-next just as
> well).
> 
> Patch 1/5 ("net: dsa: sja1105: Fix broken learning with vlan_filtering
> disabled") repairs a breakage introduced in the early development stages
> of the driver: support for traffic from the CPU has broken "normal"
> frame forwarding (based on DMAC) - there is connectivity through the
> switch only because all frames are flooded.
> I debated whether this patch qualifies as a fix, since it puts the
> switch into a mode it has never operated in before (aka SVL). But
> "normal" forwarding did use to work before the "Traffic support for
> SJA1105 DSA driver" patchset, and arguably this patch should have been
> part of that.
> Also, it would be strange for this feature to be broken in the 5.2 LTS.
> 
> Patch 2/5 ("net: dsa: sja1105: Use the LOCKEDS bit for SJA1105 E/T as
> well") is a simplification of a previous FDB-related patch that is
> currently in the 5.3 rc's.
> 
> Patches 3/5 - 5/5 fix various crashes found while running linuxptp over the
> switch ports for extended periods of time, or in conjunction with other
> error conditions. The fixed-up commits were all introduced in 5.2.

Series applied.
