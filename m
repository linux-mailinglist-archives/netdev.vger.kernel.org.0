Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA7418C68D
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCTEiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:38:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgCTEiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:38:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E6D11590D672;
        Thu, 19 Mar 2020 21:38:00 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:38:00 -0700 (PDT)
Message-Id: <20200319.213800.2199070365154062407.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Avoid error message for
 unknown PHY mode on disabled ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319201210.22824-1-olteanv@gmail.com>
References: <20200319201210.22824-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:38:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 19 Mar 2020 22:12:10 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When sja1105_init_mii_settings iterates over the port list, it prints
> this message for disabled ports, because they don't have a valid
> phy-mode:
> 
> [    4.778702] sja1105 spi2.0: Unsupported PHY mode unknown!
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Suggested-by: Vivien Didelot <vivien.didelot@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
