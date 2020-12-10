Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474D02D5174
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgLJDgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729708AbgLJDfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:35:47 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FFFC0613D6;
        Wed,  9 Dec 2020 19:35:07 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id EA6544D2492CE;
        Wed,  9 Dec 2020 19:35:06 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:35:06 -0800 (PST)
Message-Id: <20201209.193506.2090158352867619865.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de
Subject: Re: [PATCH net-next] net: x25: Fix handling of Restart Request and
 Restart Confirmation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209081604.464084-1-xie.he.0141@gmail.com>
References: <20201209081604.464084-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:35:07 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Wed,  9 Dec 2020 00:16:04 -0800

> 1. When the x25 module gets loaded, layer 2 may already be running and
> connected. In this case, although we are in X25_LINK_STATE_0, we still
> need to handle the Restart Request received, rather than ignore it.
> 
> 2. When we are in X25_LINK_STATE_2, we have already sent a Restart Request
> and is waiting for the Restart Confirmation with t20timer. t20timer will
> restart itself repeatedly forever so it will always be there, as long as we
> are in State 2. So we don't need to check x25_t20timer_pending again.
> 
> Fixes: d023b2b9ccc2 ("net/x25: fix restart request/confirm handling")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thanks.
