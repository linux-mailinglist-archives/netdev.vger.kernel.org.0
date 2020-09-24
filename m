Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3E7276528
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIXAeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:34:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D4EC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 17:34:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1E7311E59B71;
        Wed, 23 Sep 2020 17:17:21 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:34:08 -0700 (PDT)
Message-Id: <20200923.173408.1463852454290265675.davem@davemloft.net>
To:     song.bao.hua@hisilicon.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, mripard@kernel.org,
        wens@csie.org
Subject: Re: [PATCH] net: allwinner: remove redundant irqsave and
 irqrestore in hardIRQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922015615.19212-1-song.bao.hua@hisilicon.com>
References: <20200922015615.19212-1-song.bao.hua@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:17:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Barry Song <song.bao.hua@hisilicon.com>
Date: Tue, 22 Sep 2020 13:56:15 +1200

> The comment "holders of db->lock must always block IRQs" and related
> code to do irqsave and irqrestore don't make sense since we are in a
> IRQ-disabled hardIRQ context.
> 
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>

Applied to net-next, thanks.
