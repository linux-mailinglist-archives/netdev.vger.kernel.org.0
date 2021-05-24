Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D935538F4D2
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhEXVZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhEXVZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 17:25:51 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A04C061574;
        Mon, 24 May 2021 14:24:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 528524D2C9938;
        Mon, 24 May 2021 14:24:20 -0700 (PDT)
Date:   Mon, 24 May 2021 14:24:16 -0700 (PDT)
Message-Id: <20210524.142416.2165023047022388991.davem@davemloft.net>
To:     gatis@mikrotik.com
Cc:     chris.snook@gmail.com, kuba@kernel.org, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] atl1c: add 4 RX/TX queue support for Mikrotik
 10/25G NIC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210524191115.2760178-1-gatis@mikrotik.com>
References: <20210524191115.2760178-1-gatis@mikrotik.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 24 May 2021 14:24:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gatis Peisenieks <gatis@mikrotik.com>
Date: Mon, 24 May 2021 22:11:15 +0300

> More RX/TX queues on a network card help spread the CPU load among
> cores and achieve higher overall networking performance. The new
> Mikrotik 10/25G NIC supports 4 RX and 4 TX queues. TX queues are
> treated with equal priority. RX queue balancing is fixed based on
> L2/L3/L4 hash.
> 
> This adds support for 4 RX/TX queues while maintaining backwards
> compatibility with older hardware.
> 
> Simultaneous TX + RX performance on AMD Threadripper 3960X
> with Mikrotik 10/25G NIC improved from 1.6Mpps to 3.2Mpps per port.
> 
> Backwards compatiblitiy was verified with AR8151 and AR8131 based
> NICs.
> 
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>

This does not apply cleanly to net-next, please respin.

Thank you.
