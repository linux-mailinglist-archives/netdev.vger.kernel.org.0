Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2AE2EC6C7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbhAFXTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbhAFXTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 18:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E8022D74;
        Wed,  6 Jan 2021 23:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609975123;
        bh=8GEIRU7czEcwhjlkZqPI1pzzpaFaO4i2fKnlWzt7mKU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fyPuJm6dJrCkyGhLzSEXsmr6dUaxEp4H7iCjFnYWxdRwLPumetV+/nBZhewJYTNJb
         Fj4qRui/m5PwzmfU+HzXcPVYnbbPeNZm7Xudnx5V/aj5u0M0h3yRetQMKYooZui4ay
         vLm/zOQHgiRkY8Ybz4B3UDG3HPxt+14J5TwHUnyjwxdoVqjCZTZgIpYe0LtWrpqJSn
         DDPHtbdF1lYu2H9CWKRTp1rmDKOd6yodv5t/P9K2LiQjrzlNZKuW3fioE80PIt+QTL
         CD0wYFPZB28rhEvQFvKCCVUxmNUbkK6ruvmuvG40FE2XfHgZ7hzNfAaKxjVyBWKOmm
         bci3z1ILIIa7g==
Date:   Wed, 6 Jan 2021 15:18:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyingjie55@126.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Message-ID: <20210106151842.74edc6cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1609915757-4282-1-git-send-email-wangyingjie55@126.com>
References: <1609915757-4282-1-git-send-email-wangyingjie55@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jan 2021 22:49:17 -0800 wangyingjie55@126.com wrote:
> From: Yingjie Wang <wangyingjie55@126.com>
> 
> In rvu_mbox_handler_cgx_mac_addr_get()
> and rvu_mbox_handler_cgx_mac_addr_set(),
> the msg is expected only from PFs that are mapped to CGX LMACs.
> It should be checked before mapping,
> so we add the is_cgx_config_permitted() in the functions.
> 
> Fixes: 85482bb ("af/rvu_cgx: Fix missing check bugs in rvu_cgx.c")
> Signed-off-by: Yingjie Wang <wangyingjie55@126.com>

Thanks for the tag but:

Fixes tag: Fixes: 85482bb ("af/rvu_cgx: Fix missing check bugs in rvu_cgx.c")
Has these problem(s):
	- Target SHA1 does not exist

This hash does not seem to exist in any tree known to linux-next.

The hash should also be at least 12 chars.


