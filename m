Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05333279569
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgIZAJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgIZAJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:09:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26397C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:09:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C69713BA39E4;
        Fri, 25 Sep 2020 16:52:25 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:09:12 -0700 (PDT)
Message-Id: <20200925.170912.564701612655223547.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] dpaa2-eth: fix command version for Tx shaping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925143530.6673-1-ioana.ciornei@nxp.com>
References: <20200925143530.6673-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:52:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Fri, 25 Sep 2020 17:35:30 +0300

> When adding the support for TBF offload, the improper command version
> was added even though the command format is for the V2 of
> dpni_set_tx_shaping(). This does not affect the functionality of TBF
> since the only change between these two versions is the addition of the
> exceeded parameters which are not used in TBF. Still, fix the bug so
> that we keep things in sync.
> 
> Fixes: 39344a89623d ("dpaa2-eth: add API for Tx shaping")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied, thanks.
