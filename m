Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0273B244F73
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgHNVHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgHNVHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 17:07:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFB0C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 14:07:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 018541274C3BC;
        Fri, 14 Aug 2020 13:50:50 -0700 (PDT)
Date:   Fri, 14 Aug 2020 14:07:36 -0700 (PDT)
Message-Id: <20200814.140736.1835882100760285689.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] sfc: check hash is valid before using it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <35c28344-605a-009b-70a0-6030cf88ed02@solarflare.com>
References: <35c28344-605a-009b-70a0-6030cf88ed02@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 13:50:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Fri, 14 Aug 2020 13:26:22 +0100

> On EF100, the RX hash field in the packet prefix may not be valid (e.g.
>  if the header parse failed), and this is indicated by a one-bit flag
>  elsewhere in the packet prefix.  Only call skb_set_hash() if the
>  RSS_HASH_VALID bit is set.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied.
