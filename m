Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7AA254851
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgH0PFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgH0PFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:05:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C5C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 08:05:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18DC6127A057C;
        Thu, 27 Aug 2020 07:48:29 -0700 (PDT)
Date:   Thu, 27 Aug 2020 08:05:14 -0700 (PDT)
Message-Id: <20200827.080514.1573033574724120328.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     kuba@kernel.org, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        gabriel.ganne@6wind.com
Subject: Re: [PATCH net-next v3] gtp: add notification mechanism
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827121923.7302-1-nicolas.dichtel@6wind.com>
References: <20200827090026.GK130874@nataraja>
        <20200827121923.7302-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 07:48:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 27 Aug 2020 14:19:23 +0200

> Like all other network functions, let's notify gtp context on creation and
> deletion.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Tested-by: Gabriel Ganne <gabriel.ganne@6wind.com>
> Acked-by: Harald Welte <laforge@gnumonks.org>

Applied, thanks.
