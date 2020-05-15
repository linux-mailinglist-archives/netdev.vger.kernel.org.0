Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5493A1D42A1
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEOBDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726122AbgEOBDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:03:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED9CC061A0C;
        Thu, 14 May 2020 18:03:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF56A14DDDEE5;
        Thu, 14 May 2020 18:03:23 -0700 (PDT)
Date:   Thu, 14 May 2020 18:03:22 -0700 (PDT)
Message-Id: <20200514.180322.2120900678402639632.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        xiaoliang.yang_1@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: felix: fix incorrect clamp calculation
 for burst
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514183302.16925-1-colin.king@canonical.com>
References: <20200514183302.16925-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 18:03:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 14 May 2020 19:33:02 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently burst is clamping on rate and not burst, the assignment
> of burst from the clamping discards the previous assignment of burst.
> This looks like a cut-n-paste error from the previous clamping
> calculation on ramp.  Fix this by replacing ramp with burst.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 0fbabf875d18 ("net: dsa: felix: add support Credit Based Shaper(CBS) for hardware offload")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
