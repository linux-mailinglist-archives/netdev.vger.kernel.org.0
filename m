Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9018A95B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCRXjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:39:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCRXjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:39:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1F44155371D4;
        Wed, 18 Mar 2020 16:39:16 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:39:16 -0700 (PDT)
Message-Id: <20200318.163916.1829921372966500306.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: rework TC filter rule insertion across
 regions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584528891-24714-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1584528891-24714-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:39:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Wed, 18 Mar 2020 16:24:51 +0530

> Chelsio NICs have 3 filter regions, in following order of priority:
> 1. High Priority (HPFILTER) region (Highest Priority).
> 2. HASH region.
> 3. Normal FILTER region (Lowest Priority).
> 
> Currently, there's a 1-to-1 mapping between the prio value passed
> by TC and the filter region index. However, it's possible to have
> multiple TC rules with the same prio value. In this case, if a region
> is exhausted, no attempt is made to try inserting the rule in the
> next available region.
> 
> So, rework and remove the 1-to-1 mapping. Instead, dynamically select
> the region to insert the filter rule, as long as the new rule's prio
> value doesn't conflict with existing rules across all the 3 regions.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied, thank you.
