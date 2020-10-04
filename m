Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBA02827A7
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgJDAdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgJDAdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:33:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D491FC0613D0;
        Sat,  3 Oct 2020 17:33:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C388511E3E4CB;
        Sat,  3 Oct 2020 17:17:01 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:33:48 -0700 (PDT)
Message-Id: <20201003.173348.274419775415549268.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     aelior@marvell.com, skalluru@marvell.com, kuba@kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bnx2x: Use fallthrough pseudo-keyword
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002232611.GA8809@embeddedor>
References: <20201002232611.GA8809@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:17:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Fri, 2 Oct 2020 18:26:11 -0500

> Replace /* no break */ comments with the new pseudo-keyword macro
> fallthrough[1].
> 
> [1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied.
