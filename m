Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2527AFA784
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfKMDp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:45:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfKMDp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:45:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6B2E154FFB1E;
        Tue, 12 Nov 2019 19:45:55 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:45:55 -0800 (PST)
Message-Id: <20191112.194555.2091644272236024677.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [net-next] tipc: update mon's self addr when node addr
 generated
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112004004.3625-1-hoang.h.le@dektech.com.au>
References: <20191112004004.3625-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:45:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>
Date: Tue, 12 Nov 2019 07:40:04 +0700

> In commit 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address
> hash values"), the 32-bit node address only generated after one second
> trial period expired. However the self's addr in struct tipc_monitor do
> not update according to node address generated. This lead to it is
> always zero as initial value. As result, sorting algorithm using this
> value does not work as expected, neither neighbor monitoring framework.
> 
> In this commit, we add a fix to update self's addr when 32-bit node
> address generated.
> 
> Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied.
