Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DED2140EE
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgGCVgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 17:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgGCVgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:36:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1E7C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 14:36:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 944DB155CB0A3;
        Fri,  3 Jul 2020 14:36:15 -0700 (PDT)
Date:   Fri, 03 Jul 2020 14:36:15 -0700 (PDT)
Message-Id: <20200703.143615.1441662205959237446.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net-next] ipv6/ping: set skb->mark on icmpv6 sockets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703204308.3372523-1-willemdebruijn.kernel@gmail.com>
References: <20200703204308.3372523-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 14:36:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri,  3 Jul 2020 16:43:08 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> IPv6 ping sockets route based on fwmark, but do not yet set skb->mark.
> Add this. IPv4 ping sockets also do both.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thank you.
