Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD805FD265
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfKOBZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:25:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKOBZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:25:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D988314B72710;
        Thu, 14 Nov 2019 17:25:08 -0800 (PST)
Date:   Thu, 14 Nov 2019 17:25:08 -0800 (PST)
Message-Id: <20191114.172508.1027995193093100862.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: allow fast GRO for skbs with
 Ethernet header in head
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112122843.30636-1-alobakin@dlink.ru>
References: <20191112122843.30636-1-alobakin@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 17:25:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Tue, 12 Nov 2019 15:28:43 +0300

> Commit 78d3fd0b7de8 ("gro: Only use skb_gro_header for completely
> non-linear packets") back in May'09 (2.6.31-rc1) has changed the
> original condition '!skb_headlen(skb)' to the current
> 'skb_mac_header(skb) == skb_tail_pointer(skb)' in gro_reset_offset()
> saying: "Since the drivers that need this optimisation all provide
> completely non-linear packets".

Please reference the appropriate SHA1-ID both here in this paragraph and
also in an appropriate Fixes: tag.

If this goes so far back that it is before GIT, then you need to provide
a reference to the patch posting via lore.kernel.org or similar because
it is absolutely essentialy for people reviewing this patch to be able
to do some digging into why the condition is code the way that it is
currently.

Thank you.
