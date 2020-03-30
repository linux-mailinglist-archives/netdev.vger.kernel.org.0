Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3AF1973A7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgC3FEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:04:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3FEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:04:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5F5015C5D629;
        Sun, 29 Mar 2020 22:04:31 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:04:30 -0700 (PDT)
Message-Id: <20200329.220430.551244658649124260.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: show more ethtool
 statistics counters for P/Q/R/S
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327140016.629-1-olteanv@gmail.com>
References: <20200327140016.629-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:04:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Mar 2020 16:00:16 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It looks like the P/Q/R/S series supports some more counters,
> generically named "Ethernet statistics counter", which we were not
> printing. Add them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
