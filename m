Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A10625CD03
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 00:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgICWAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 18:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbgICWAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 18:00:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E670AC061247
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 15:00:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E35461278BDD5;
        Thu,  3 Sep 2020 14:43:26 -0700 (PDT)
Date:   Thu, 03 Sep 2020 15:00:13 -0700 (PDT)
Message-Id: <20200903.150013.1684062443303428226.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: fix error handling in ethtool_phys_id
From:   David Miller <davem@davemloft.net>
In-Reply-To: <99914576-a923-b9d9-3dea-62732508b4ad@solarflare.com>
References: <99914576-a923-b9d9-3dea-62732508b4ad@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 14:43:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 1 Sep 2020 18:52:32 +0100

> If ops->set_phys_id() returned an error, previously we would only break
>  out of the inner loop, which neither stopped the outer loop nor returned
>  the error to the user (since 'rc' would be overwritten on the next pass
>  through the loop).
> Thus, rewrite it to use a single loop, so that the break does the right
>  thing.  Use u64 for 'count' and 'i' to prevent overflow in case of
>  (unreasonably) large values of id.data and n.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied, thanks.
