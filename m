Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6B9242FD7
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgHLUGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgHLUGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 16:06:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAE0C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 13:06:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67C4812838768;
        Wed, 12 Aug 2020 12:49:21 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:06:06 -0700 (PDT)
Message-Id: <20200812.130606.1336382904304655382.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org,
        linux@roeck-us.net
Subject: Re: [PATCH net] sfc: fix ef100 design-param checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <311d8274-9c6f-4614-552f-b1d3da64f368@solarflare.com>
References: <311d8274-9c6f-4614-552f-b1d3da64f368@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Aug 2020 12:49:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Wed, 12 Aug 2020 10:32:49 +0100

> The handling of the RXQ/TXQ size granularity design-params had two
>  problems: it had a 64-bit divide that didn't build on 32-bit platforms,
>  and it could divide by zero if the NIC supplied 0 as the value of the
>  design-param.  Fix both by checking for 0 and for a granularity bigger
>  than our min-size; if the granularity <= EFX_MIN_DMAQ_SIZE then it fits
>  in 32 bits, so we can cast it to u32 for the divide.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied.
