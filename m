Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28EA25B71F
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIBXIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIBXIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:08:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295A7C061244;
        Wed,  2 Sep 2020 16:08:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 306A71574646C;
        Wed,  2 Sep 2020 15:52:02 -0700 (PDT)
Date:   Wed, 02 Sep 2020 16:08:48 -0700 (PDT)
Message-Id: <20200902.160848.820546658369900440.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dp83867: Fix WoL SecureOn password
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902192704.9220-1-dmurphy@ti.com>
References: <20200902192704.9220-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:52:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Wed, 2 Sep 2020 14:27:04 -0500

> Fix the registers being written to as the values were being over written
> when writing the same registers.
> 
> Fixes: caabee5b53f5 ("net: phy: dp83867: support Wake on LAN")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Applied and queued up for -stable, thanks.
