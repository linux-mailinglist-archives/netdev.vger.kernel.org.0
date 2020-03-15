Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50601185ADB
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgCOHH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:07:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35968 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgCOHH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:07:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E35A13CB6A09;
        Sun, 15 Mar 2020 00:07:28 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:07:27 -0700 (PDT)
Message-Id: <20200315.000727.1384093516107032596.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     ying.xue@windriver.com, netdev@vger.kernel.org, jmaloy@redhat.com,
        maloy@donjonn.com
Subject: Re: [net-next 2/2] tipc: add NULL pointer check to prevent kernel
 oops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313031803.9588-2-hoang.h.le@dektech.com.au>
References: <20200313031803.9588-1-hoang.h.le@dektech.com.au>
        <20200313031803.9588-2-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:07:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hoang.h.le@dektech.com.au
Date: Fri, 13 Mar 2020 10:18:03 +0700

> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> Calling:
> tipc_node_link_down()->
>    - tipc_node_write_unlock()->tipc_mon_peer_down()
>    - tipc_mon_peer_down()
>   just after disabling bearer could be caused kernel oops.
> 
> Fix this by adding a sanity check to make sure valid memory
> access.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied.
