Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF762581C6
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgHaTaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgHaTaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:30:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0C8C061573;
        Mon, 31 Aug 2020 12:30:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F9841286DD3F;
        Mon, 31 Aug 2020 12:13:26 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:30:12 -0700 (PDT)
Message-Id: <20200831.123012.737901524491392379.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vigneshr@ti.com
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: fix i2083 genf
 (and estf) Reconfiguration Issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200828203325.29588-1-grygorii.strashko@ti.com>
References: <20200828203325.29588-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:13:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 28 Aug 2020 23:33:25 +0300

> The new bit TX_GENF_CLR_EN has been added in AM65x SR2.0 to fix i2083
> errata, which can be just set unconditionally for all SoCs.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied, thanks.

