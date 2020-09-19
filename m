Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B427116B
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 01:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgISXlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 19:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgISXlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 19:41:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A11DC061755;
        Sat, 19 Sep 2020 16:41:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD91D11FFD370;
        Sat, 19 Sep 2020 16:24:19 -0700 (PDT)
Date:   Sat, 19 Sep 2020 16:41:06 -0700 (PDT)
Message-Id: <20200919.164106.2177705163414890141.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net-next] net/packet: Fix a comment about network_header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918135616.8677-1-xie.he.0141@gmail.com>
References: <20200918135616.8677-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 16:24:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Fri, 18 Sep 2020 06:56:16 -0700

> skb->nh.raw has been renamed as skb->network_header in 2007, in
> commit b0e380b1d8a8 ("[SK_BUFF]: unions of just one member don't get
>                       anything done, kill them")
> 
> So here we change it to the new name.
> 
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied.
