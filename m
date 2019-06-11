Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80693D5EE
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404372AbfFKS4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:56:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404245AbfFKS4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:56:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A0361525A429;
        Tue, 11 Jun 2019 11:56:06 -0700 (PDT)
Date:   Tue, 11 Jun 2019 11:56:06 -0700 (PDT)
Message-Id: <20190611.115606.603445030371765724.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: netlink: make netlink_walk_start() void
 return type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190609170530.27895-1-ap420073@gmail.com>
References: <20190609170530.27895-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 11:56:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Mon, 10 Jun 2019 02:05:30 +0900

> netlink_walk_start() needed to return an error code because of 
> rhashtable_walk_init(). but that was converted to rhashtable_walk_enter()
> and it is a void type function. so now netlink_walk_start() doesn't need 
> any return value.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied.
