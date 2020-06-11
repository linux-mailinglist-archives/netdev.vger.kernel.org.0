Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0721F6E11
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgFKTl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgFKTl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:41:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AC2C08C5C1;
        Thu, 11 Jun 2020 12:41:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB85F128646D9;
        Thu, 11 Jun 2020 12:41:26 -0700 (PDT)
Date:   Thu, 11 Jun 2020 12:41:23 -0700 (PDT)
Message-Id: <20200611.124123.2172344882681894046.davem@davemloft.net>
To:     vulab@iscas.ac.cn
Cc:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: dpaa2: Use devm_kcalloc() in setup_dpni()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611024520.630-1-vulab@iscas.ac.cn>
References: <20200611024520.630-1-vulab@iscas.ac.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 12:41:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>
Date: Thu, 11 Jun 2020 02:45:20 +0000

> A multiplication for the size determination of a memory allocation
> indicated that an array data structure should be processed.
> Thus use the corresponding function "devm_kcalloc".
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied, thanks.
