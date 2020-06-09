Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693491F4A04
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 01:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgFIXKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 19:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgFIXKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 19:10:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984BBC05BD1E;
        Tue,  9 Jun 2020 16:10:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 077D4120ED4A0;
        Tue,  9 Jun 2020 16:10:25 -0700 (PDT)
Date:   Tue, 09 Jun 2020 16:10:22 -0700 (PDT)
Message-Id: <20200609.161022.775948518079033031.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, jacob.e.keller@intel.com
Subject: Re: [PATCH] net: flow_offload: remove indirect flow_block
 declarations leftover
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609214744.28412-1-pablo@netfilter.org>
References: <20200609214744.28412-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 16:10:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue,  9 Jun 2020 23:47:44 +0200

> Remove function declarations that are not available in the tree anymore.
> 
> Fixes: 709ffbe19b77 ("net: remove indirect block netdev event registration")
> Reported-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thank you.
