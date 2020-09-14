Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEF92697D8
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINVkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgINVki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:40:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F44EC06174A;
        Mon, 14 Sep 2020 14:40:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0ECD71282CE71;
        Mon, 14 Sep 2020 14:23:50 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:40:36 -0700 (PDT)
Message-Id: <20200914.144036.361794705186870305.davem@davemloft.net>
To:     ogiannou@gmail.com
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, olympia.giannou@leica-geosystems.com
Subject: Re: [PATCH] rndis_host: increase sleep time in the query-response
 loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911141725.5960-1-olympia.giannou@leica-geosystems.com>
References: <20200911141725.5960-1-olympia.giannou@leica-geosystems.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 14:23:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olympia Giannou <ogiannou@gmail.com>
Date: Fri, 11 Sep 2020 14:17:24 +0000

> Some WinCE devices face connectivity issues via the NDIS interface. They
> fail to register, resulting in -110 timeout errors and failures during the
> probe procedure.
> 
> In this kind of WinCE devices, the Windows-side ndis driver needs quite
> more time to be loaded and configured, so that the linux rndis host queries
> to them fail to be responded correctly on time.
> 
> More specifically, when INIT is called on the WinCE side - no other
> requests can be served by the Client and this results in a failed QUERY
> afterwards.
> 
> The increase of the waiting time on the side of the linux rndis host in
> the command-response loop leaves the INIT process to complete and respond
> to a QUERY, which comes afterwards. The WinCE devices with this special
> "feature" in their ndis driver are satisfied by this fix.
> 
> Signed-off-by: Olympia Giannou <olympia.giannou@leica-geosystems.com>

Applied, thank you.
