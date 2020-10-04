Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76F52827A3
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgJDAdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgJDAdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:33:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34D8C0613D0;
        Sat,  3 Oct 2020 17:33:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5A4711E3E4CB;
        Sat,  3 Oct 2020 17:16:51 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:33:38 -0700 (PDT)
Message-Id: <20201003.173338.2245433774593882221.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     rmody@marvell.com, skalluru@marvell.com, kuba@kernel.org,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: bna: Use fallthrough pseudo-keyword
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002230001.GA3320@embeddedor>
References: <20201002230001.GA3320@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:16:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Fri, 2 Oct 2020 18:00:01 -0500

> Replace /* !!! fall through !!! */ comments with the new pseudo-keyword
> macro fallthrough[1].
> 
> [1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied.
