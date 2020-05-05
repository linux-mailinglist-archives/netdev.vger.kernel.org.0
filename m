Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775171C5FC6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgEESMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbgEESMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:12:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE456C061A0F;
        Tue,  5 May 2020 11:12:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D08A127EDD2C;
        Tue,  5 May 2020 11:12:10 -0700 (PDT)
Date:   Tue, 05 May 2020 11:12:06 -0700 (PDT)
Message-Id: <20200505.111206.118627398774406136.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     swboyd@chromium.org, ynezz@true.cz, netdev@vger.kernel.org,
        jonathan.richardson@broadcom.com, linux-kernel@vger.kernel.org,
        scott.branden@broadcom.com, ray.jui@broadcom.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net v1] net: broadcom: fix a mistake about ioremap
 resource
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505020329.31638-1-zhengdejin5@gmail.com>
References: <20200505020329.31638-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:12:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Tue,  5 May 2020 10:03:29 +0800

> Commit d7a5502b0bb8b ("net: broadcom: convert to
> devm_platform_ioremap_resource_byname()") will broke this driver.
> idm_base and nicpm_base were optional, after this change, they are
> mandatory. it will probe fails with -22 when the dtb doesn't have them
> defined. so revert part of this commit and make idm_base and nicpm_base
> as optional.
> 
> Fixes: d7a5502b0bb8bde ("net: broadcom: convert to devm_platform_ioremap_resource_byname()")
> Reported-by: Jonathan Richardson <jonathan.richardson@broadcom.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Applied, thank you.
