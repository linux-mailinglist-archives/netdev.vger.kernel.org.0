Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67347F245B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfKGBiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:38:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbfKGBh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 20:37:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C652150301BF;
        Wed,  6 Nov 2019 17:37:59 -0800 (PST)
Date:   Wed, 06 Nov 2019 17:37:58 -0800 (PST)
Message-Id: <20191106.173758.108649448585045638.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/2] tipc: update cluster capabilities if node
 deleted
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
References: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 17:37:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>
Date: Wed,  6 Nov 2019 13:26:09 +0700

> There are two improvements when re-calculate cluster capabilities:
> 
> - When deleting a specific down node, need to re-calculate.
> - In tipc_node_cleanup(), do not need to re-calculate if node
> is still existing in cluster.
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied.
