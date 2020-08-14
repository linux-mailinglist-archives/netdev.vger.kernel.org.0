Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE1245033
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 01:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgHNXtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 19:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgHNXtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 19:49:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E2CC061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 16:49:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 393B91277D62B;
        Fri, 14 Aug 2020 16:32:55 -0700 (PDT)
Date:   Fri, 14 Aug 2020 16:49:39 -0700 (PDT)
Message-Id: <20200814.164939.1293677054266877903.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net,stable 1/1] net: fec: correct the error path for
 regulator disable in probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200813071314.6384-1-fugang.duan@nxp.com>
References: <20200813071314.6384-1-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 16:32:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: fugang.duan@nxp.com
Date: Thu, 13 Aug 2020 15:13:14 +0800

> From: Fugang Duan <fugang.duan@nxp.com>
> 
> Correct the error path for regulator disable.
> 
> Fixes: 9269e5560b26 ("net: fec: add phy-reset-gpios PROBE_DEFER check")
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

Applied and queued up for -stable, thanks.
