Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2DB26E986
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQXi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIQXiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:38:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B887AC06174A;
        Thu, 17 Sep 2020 16:38:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F74913660F1E;
        Thu, 17 Sep 2020 16:21:38 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:38:24 -0700 (PDT)
Message-Id: <20200917.163824.1681362492378748718.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Make skb->protocol
 consistent with the header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916164918.450933-1-xie.he.0141@gmail.com>
References: <20200916164918.450933-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:21:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Wed, 16 Sep 2020 09:49:18 -0700

> This driver is a virtual driver stacked on top of Ethernet interfaces.
> 
> When this driver transmits data on the Ethernet device, the skb->protocol
> setting is inconsistent with the Ethernet header prepended to the skb.
> 
> This causes a user listening on the Ethernet interface with an AF_PACKET
> socket, to see different sll_protocol values for incoming and outgoing
> frames, because incoming frames would have this value set by parsing the
> Ethernet header.
> 
> This patch changes the skb->protocol value for outgoing Ethernet frames,
> making it consistent with the Ethernet header prepended. This makes a
> user listening on the Ethernet device with an AF_PACKET socket, to see
> the same sll_protocol value for incoming and outgoing frames.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
