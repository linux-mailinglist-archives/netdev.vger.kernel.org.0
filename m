Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330E1141EC0
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgASPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:12:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgASPMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:12:25 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B1A714EC3214;
        Sun, 19 Jan 2020 07:12:23 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:12:22 +0100 (CET)
Message-Id: <20200119.161222.304613321340810474.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix Tx multi channel port rate limit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579265635-7773-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1579265635-7773-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 07:12:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Fri, 17 Jan 2020 18:23:55 +0530

> T6 can support 2 egress traffic management channels per port to
> double the total number of traffic classes that can be configured.
> In this configuration, if the class belongs to the other channel,
> then all the queues must be bound again explicitly to the new class,
> for the rate limit parameters on the other channel to take effect.
> 
> So, always explicitly bind all queues to the port rate limit traffic
> class, regardless of the traffic management channel that it belongs
> to. Also, only bind queues to port rate limit traffic class, if all
> the queues don't already belong to an existing different traffic
> class.
> 
> Fixes: 4ec4762d8ec6 ("cxgb4: add TC-MATCHALL classifier egress offload")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied.
