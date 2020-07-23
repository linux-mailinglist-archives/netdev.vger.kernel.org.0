Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4541D22B64B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgGWTAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgGWTAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:00:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C6C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 12:00:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E01613B0143A;
        Thu, 23 Jul 2020 11:43:31 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:00:15 -0700 (PDT)
Message-Id: <20200723.120015.959837413744320941.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com
Subject: Re: [PATCH net-next v3] cxgb4: add loopback ethtool self-test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723124950.21035-1-vishal@chelsio.com>
References: <20200723124950.21035-1-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 11:43:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Thu, 23 Jul 2020 18:19:50 +0530

> In this test, loopback pkt is created and sent on default queue.
> The packet goes until the Multi Port Switch (MPS) just before
> the MAC and based on the specified channel number, it either
> goes outside the wire on one of the physical ports or looped
> back to Rx path by MPS. In this case, we're specifying loopback
> channel, instead of physical ports, so the packet gets looped
> back to Rx path, instead of getting transmitted on the wire.
> 
> v3:
> - Modify commit message to include test details.
> v2:
> - Add only loopback self-test.
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Applied.
