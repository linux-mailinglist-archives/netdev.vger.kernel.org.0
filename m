Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24327D80B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgI2U1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgI2U1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:27:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BFCC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 13:27:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CBFE146008B9;
        Tue, 29 Sep 2020 13:10:26 -0700 (PDT)
Date:   Tue, 29 Sep 2020 13:27:12 -0700 (PDT)
Message-Id: <20200929.132712.1135733794216670483.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 1/1] l2tp: report rx cookie discards in
 netlink get
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929123541.31780-1-tparkin@katalix.com>
References: <20200929123541.31780-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 13:10:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Tue, 29 Sep 2020 13:35:41 +0100

> When an L2TPv3 session receives a data frame with an incorrect cookie
> l2tp_core logs a warning message and bumps a stats counter to reflect
> the fact that the packet has been dropped.
> 
> However, the stats counter in question is missing from the l2tp_netlink
> get message for tunnel and session instances.
> 
> Include the statistic in the netlink get response.
> 
> Signed-off-by: Tom Parkin <tparkin@katalix.com>

Please in the future put a "v2" into your Subject like like "[PATCH v2
net-next]" when you post a new version of a patch.

Applied to net-next, thanks.
