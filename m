Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5569227086A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIRVhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRVhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:37:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295CBC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:37:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BAF57159F6A04;
        Fri, 18 Sep 2020 14:20:28 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:37:15 -0700 (PDT)
Message-Id: <20200918.143715.361880195338935962.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 1/1] l2tp: fix up inconsistent rx/tx statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918102321.7036-1-tparkin@katalix.com>
References: <20200918102321.7036-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:20:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Fri, 18 Sep 2020 11:23:21 +0100

> Historically L2TP core statistics count the L2TP header in the
> per-session and per-tunnel byte counts tracked for transmission and
> receipt.
> 
> Now that l2tp_xmit_skb updates tx stats, it is necessary for
> l2tp_xmit_core to pass out the length of the transmitted packet so that
> the statistics can be updated correctly.
> 
> Signed-off-by: Tom Parkin <tparkin@katalix.com>

Applied.
