Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9D23B22B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgHDBRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:17:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDF5C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:17:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60E461278B047;
        Mon,  3 Aug 2020 18:00:35 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:17:20 -0700 (PDT)
Message-Id: <20200803.181720.135003671058674990.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: add TC-MATCHALL IPv6 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596479408-31023-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1596479408-31023-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:00:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Tue,  4 Aug 2020 00:00:08 +0530

> Matching IPv6 traffic require allocating their own individual slots
> in TCAM. So, fetch additional slots to insert IPv6 rules. Also, fetch
> the cumulative stats of all the slots occupied by the Matchall rule.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied, thank you.
