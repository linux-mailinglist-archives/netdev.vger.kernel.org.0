Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE51C25CE80
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 01:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgICXwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 19:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgICXwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 19:52:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5653C061244;
        Thu,  3 Sep 2020 16:52:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3E89128967D8;
        Thu,  3 Sep 2020 16:35:23 -0700 (PDT)
Date:   Thu, 03 Sep 2020 16:51:31 -0700 (PDT)
Message-Id: <20200903.165131.2279289098821384874.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Fix various styling and
 space issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200903195112.18868-1-dmurphy@ti.com>
References: <20200903195112.18868-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 16:35:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Thu, 3 Sep 2020 14:51:12 -0500

> Fix spacing issues reported for misaligned switch..case and extra new
> lines.
> 
> Also updated the file header to comply with networking commet style.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Applied, thank you.
