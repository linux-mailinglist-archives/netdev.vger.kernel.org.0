Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E99180E0
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 22:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfEHUOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 16:14:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHUOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 16:14:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 908EA12B05D27;
        Wed,  8 May 2019 13:14:01 -0700 (PDT)
Date:   Wed, 08 May 2019 13:13:57 -0700 (PDT)
Message-Id: <20190508.131357.1972863276402672227.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH][V3] net: dsa: sja1105: fix check on while loop exit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508133041.14435-1-colin.king@canonical.com>
References: <20190508133041.14435-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 13:14:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed,  8 May 2019 14:30:41 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The while-loop exit condition check is not correct; the
> loop should continue if the returns from the function calls are
> negative or the CRC status returns are invalid.  Currently it
> is ignoring the returns from the function calls.  Fix this by
> removing the status return checks and only break from the loop
> at the very end when we know that all the success condtions have
> been met.
> 
> Kudos to Dan Carpenter for describing the correct fix and
> Vladimir Oltean for noting the change to the check on the number
> of retries.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Tested-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thank you.
