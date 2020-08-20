Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6824C880
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgHTX0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgHTX03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:26:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D208AC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:26:29 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17B6F12879A25;
        Thu, 20 Aug 2020 16:09:43 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:26:28 -0700 (PDT)
Message-Id: <20200820.162628.738522152343093660.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] ethtool: allow flow-type ether without IP
 protocol field
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818185503.664-1-vishal@chelsio.com>
References: <20200818185503.664-1-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 16:09:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Wed, 19 Aug 2020 00:25:03 +0530

> Set IP protocol mask only when IP protocol field is set.
> This will allow flow-type ether with vlan rule which don't have
> protocol field to apply.
> 
> ethtool -N ens5f4 flow-type ether proto 0x8100 vlan 0x600\
> m 0x1FFF action 3 loc 16
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Applied, thank you.
