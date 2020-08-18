Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCC248F51
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHRUDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgHRUDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:03:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BBBC061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 13:03:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 80308127AA57F;
        Tue, 18 Aug 2020 12:46:22 -0700 (PDT)
Date:   Tue, 18 Aug 2020 13:03:07 -0700 (PDT)
Message-Id: <20200818.130307.1315751913363152890.davem@davemloft.net>
To:     ganji.aravind@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net 0/2]cxgb4: Fix ethtool selftest flits calculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
References: <20200818154058.1770002-1-ganji.aravind@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:46:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ganji Aravind <ganji.aravind@chelsio.com>
Date: Tue, 18 Aug 2020 21:10:56 +0530

> Patch 1 will fix work request size calculation for loopback selftest.
> 
> Patch 2 will fix race between loopback selftest and normal Tx handler.

Series applied.

Thanks for the review Jesse.
