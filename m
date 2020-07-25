Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D4B22D332
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGYATc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYATc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:19:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761D7C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:19:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E46E1275D4D7;
        Fri, 24 Jul 2020 17:02:47 -0700 (PDT)
Date:   Fri, 24 Jul 2020 17:19:31 -0700 (PDT)
Message-Id: <20200724.171931.1501078505676501560.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 0/9] l2tp: avoid multiple assignment, remove
 BUG_ON
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 17:02:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Fri, 24 Jul 2020 16:31:48 +0100

> l2tp hasn't been kept up to date with the static analysis checks offered
> by checkpatch.pl.
> 
> This patchset builds on the series: "l2tp: cleanup checkpatch.pl
> warnings" and "l2tp: further checkpatch.pl cleanups" to resolve some of
> the remaining checkpatch warnings in l2tp.

Series applied, thanks Tom.
