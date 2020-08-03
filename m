Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB11B23B037
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgHCWeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCWeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:34:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C049C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:34:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DFE412775CEE;
        Mon,  3 Aug 2020 15:17:31 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:34:15 -0700 (PDT)
Message-Id: <20200803.153415.228586642815952528.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: fix check for running offline ethtool
 selftest
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596228652-25525-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1596228652-25525-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:17:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Sat,  1 Aug 2020 02:20:52 +0530

> The flag indicating the selftest to run is a bitmask. So, fix the
> check. Also, the selftests will fail if adapter initialization has
> not been completed yet. So, add appropriate check and bail sooner.
> 
> Fixes: 7235ffae3d2c ("cxgb4: add loopback ethtool self-test")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied.
