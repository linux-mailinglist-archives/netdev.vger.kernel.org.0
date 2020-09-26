Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034ED27957A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgIZAP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729377AbgIZAP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:15:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285B7C0613CE;
        Fri, 25 Sep 2020 17:15:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3033D13BA5207;
        Fri, 25 Sep 2020 16:59:08 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:15:54 -0700 (PDT)
Message-Id: <20200925.171554.1696394343282908508.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com, kuba@kernel.org,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] dpaa2-mac: Fix potential null pointer dereference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925170323.GA20546@embeddedor>
References: <20200925170323.GA20546@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:59:08 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Fri, 25 Sep 2020 12:03:23 -0500

> There is a null-check for _pcs_, but it is being dereferenced
> prior to this null-check. So, if _pcs_ can actually be null,
> then there is a potential null pointer dereference that should
> be fixed by null-checking _pcs_ before being dereferenced.
> 
> Addresses-Coverity-ID: 1497159 ("Dereference before null check")
> Fixes: 94ae899b2096 ("dpaa2-mac: add PCS support through the Lynx module")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied, thanks.
