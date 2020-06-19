Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D28201C41
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388968AbgFSURu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388032AbgFSURu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:17:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDF6C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 13:17:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 242F1120ED481;
        Fri, 19 Jun 2020 13:17:50 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:17:49 -0700 (PDT)
Message-Id: <20200619.131749.589289078892437281.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next 0/5] cxgb4: add support for ethtool n-tuple
 filters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619142139.27982-1-vishal@chelsio.com>
References: <20200619142139.27982-1-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:17:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Fri, 19 Jun 2020 19:51:34 +0530

> Patch 1: Adds data structure to maintain list of filters and handles init/dinit
> 	 of the same.
> 
> Patch 2: Handles addition of filters via ETHTOOL_SRXCLSRLINS.
> 
> Patch 3: Handles deletion of filtes via ETHTOOL_SRXCLSRLDEL.
> 
> Patch 4: Handles viewing of added filters.
> 
> Patch 5: Adds FLOW_ACTION_QUEUE support.

Series applied, thank you.
