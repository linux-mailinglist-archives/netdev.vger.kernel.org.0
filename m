Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676AA251B7F
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHYOzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgHYOzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 10:55:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED29FC061574;
        Tue, 25 Aug 2020 07:55:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60BFA133F652E;
        Tue, 25 Aug 2020 07:38:28 -0700 (PDT)
Date:   Tue, 25 Aug 2020 07:55:13 -0700 (PDT)
Message-Id: <20200825.075513.1635570856037122037.davem@davemloft.net>
To:     joe@perches.com
Cc:     trivial@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/29] ipv6: fib6: Avoid comma separated statements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <21b0a23daf050d522c5d49a908821ce280045207.1598331149.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
        <21b0a23daf050d522c5d49a908821ce280045207.1598331149.git.joe@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 07:38:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 24 Aug 2020 21:56:24 -0700

> Use semicolons and braces.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
