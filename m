Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC0345424
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfFNFoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:44:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfFNFoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:44:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 227E114DD4FC6;
        Thu, 13 Jun 2019 22:44:14 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:44:13 -0700 (PDT)
Message-Id: <20190613.224413.938595981926047101.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        rdunlap@infradead.org, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_sja1105: Select CONFIG_PACKING
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611184745.6104-1-olteanv@gmail.com>
References: <20190611184745.6104-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 22:44:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 11 Jun 2019 21:47:45 +0300

> The packing facility is needed to decode Ethernet meta frames containing
> source port and RX timestamping information.
> 
> The DSA driver selects CONFIG_PACKING, but the tagger did not, and since
> taggers can be now compiled as modules independently from the drivers
> themselves, this is an issue now, as CONFIG_PACKING is disabled by
> default on all architectures.
> 
> Fixes: e53e18a6fe4d ("net: dsa: sja1105: Receive and decode meta frames")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
