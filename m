Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904165A0B8
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfF1QYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:24:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfF1QYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:24:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D8E514E03874;
        Fri, 28 Jun 2019 09:24:15 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:24:15 -0700 (PDT)
Message-Id: <20190628.092415.219171929303857748.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao.Pinto@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com
Subject: Re: [PATCH net-next v2 00/10] net: stmmac: 10GbE using XGMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:24:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri, 28 Jun 2019 09:29:11 +0200

> Support for 10Gb Link using XGMAC core plus some performance tweaks.
> 
> Tested in a PCI based setup.
> 
> iperf3 TCP results:
> 	TSO ON, MTU=1500, TX Queues = 1, RX Queues = 1, Flow Control ON
> 	Pinned CPU (-A), Zero-Copy (-Z)
> 
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-600.00 sec   643 GBytes  9.21 Gbits/sec    1             sender
> [  5]   0.00-600.00 sec   643 GBytes  9.21 Gbits/sec                  receiver

Series applied, thanks Jose.

About the Kconfig change, maybe it just doesn't make sense to list all
of the various speeds the chip supports... just a thought.
