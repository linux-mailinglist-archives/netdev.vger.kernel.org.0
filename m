Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370BF20EA72
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgF3AnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgF3AnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:43:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B6EC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:43:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3206B127C6770;
        Mon, 29 Jun 2020 17:43:06 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:43:05 -0700 (PDT)
Message-Id: <20200629.174305.1387004568035982151.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH RESEND net-next 0/2] dpaa2-eth: send a scatter-gather
 FD instead of realloc-ing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629184712.12449-1-ioana.ciornei@nxp.com>
References: <20200629184712.12449-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:43:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Mon, 29 Jun 2020 21:47:10 +0300

> This patch set changes the behaviour in case the Tx path is confroted
> with an SKB with insufficient headroom for our hardware necessities (SW
> annotation area). In the first patch, instead of realloc-ing the SKB we
> now send a S/G frames descriptor while the second one adds a new
> software held counter to account for for these types of frames.

Series applied, thanks.
