Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467D358741
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfF0QjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:39:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfF0QjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:39:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26F7714DB597A;
        Thu, 27 Jun 2019 09:39:24 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:39:23 -0700 (PDT)
Message-Id: <20190627.093923.1974740159331605623.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     pablo@netfilter.org, f.fainelli@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, antoine.tenart@bootlin.com,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next v2] net: ethtool: Allow parsing ETHER_FLOW
 types when using flow_rule
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627085226.7658-1-maxime.chevallier@bootlin.com>
References: <20190627085226.7658-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 09:39:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Thu, 27 Jun 2019 10:52:26 +0200

> When parsing an ethtool_rx_flow_spec, users can specify an ethernet flow
> which could contain matches based on the ethernet header, such as the
> MAC address, the VLAN tag or the ethertype.
> 
> ETHER_FLOW uses the src and dst ethernet addresses, along with the
> ethertype as keys. Matches based on the vlan tag are also possible, but
> they are specified using the special FLOW_EXT flag.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2 : Add src and dst mac address parsing, as suggested by Pablo.

Applied, thanks.
