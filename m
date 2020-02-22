Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA16E168AB3
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 01:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgBVAFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 19:05:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBVAFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 19:05:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3710C15828FFF;
        Fri, 21 Feb 2020 16:05:48 -0800 (PST)
Date:   Fri, 21 Feb 2020 16:05:47 -0800 (PST)
Message-Id: <20200221.160547.1967010307076185614.davem@davemloft.net>
To:     esben@geanix.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        michal.simek@xilinx.com, ynezz@true.cz
Subject: Re: [PATCH net v2 0/4] net: ll_temac: Bugfixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1582267079.git.esben@geanix.com>
References: <cover.1582108989.git.esben@geanix.com>
        <cover.1582267079.git.esben@geanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 16:05:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>
Date: Fri, 21 Feb 2020 07:47:09 +0100

> Fix a number of bugs which have been present since the first commit.
> 
> The bugs fixed in patch 1,2 and 4 have all been observed in real systems, and
> was relatively easy to reproduce given an appropriate stress setup.
> 
> Changes since v1:
> 
> - Changed error handling of of dma_map_single() in temac_start_xmit() to drop
>   packet instead of returning NETDEV_TX_BUSY.

Series applied, thanks.
