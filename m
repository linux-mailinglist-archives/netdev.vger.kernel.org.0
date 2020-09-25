Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B3D277E3F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 04:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgIYCxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 22:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgIYCxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 22:53:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8847BC0613CE;
        Thu, 24 Sep 2020 19:53:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 905EA135F50B0;
        Thu, 24 Sep 2020 19:36:27 -0700 (PDT)
Date:   Thu, 24 Sep 2020 19:53:14 -0700 (PDT)
Message-Id: <20200924.195314.1847234607417192488.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de,
        madhuparnabhowmik10@gmail.com
Subject: Re: [PATCH net v2] drivers/net/wan/x25_asy: Correct the ndo_open
 and ndo_stop functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923181818.422274-1-xie.he.0141@gmail.com>
References: <20200923181818.422274-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:36:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Wed, 23 Sep 2020 11:18:18 -0700

> 1.
> Move the lapb_register/lapb_unregister calls into the ndo_open/ndo_stop
> functions.
> This makes the LAPB protocol start/stop when the network interface
> starts/stops. When the network interface is down, the LAPB protocol
> shouldn't be running and the LAPB module shoudn't be generating control
> frames.
> 
> 2.
> Move netif_start_queue/netif_stop_queue into the ndo_open/ndo_stop
> functions.
> This makes the TX queue start/stop when the network interface
> starts/stops.
> (netif_stop_queue was originally in the ndo_stop function. But to make
> the code look better, I created a new function to use as ndo_stop, and
> made it call the original ndo_stop function. I moved netif_stop_queue
> from the original ndo_stop function to the new ndo_stop function.)
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
