Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98B23B019
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgHCWPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbgHCWPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:15:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA09C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:15:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16CCF12771D76;
        Mon,  3 Aug 2020 14:58:49 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:15:33 -0700 (PDT)
Message-Id: <20200803.151533.1892178607896129466.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        mw@semihalf.com, mcroce@microsoft.com
Subject: Re: [PATCH net] net: mvpp2: fix memory leak in mvpp2_rx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c1c2f9c0b79d4a84701d374c6e63f69ec3f42098.1596184502.git.lorenzo@kernel.org>
References: <c1c2f9c0b79d4a84701d374c6e63f69ec3f42098.1596184502.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 14:58:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 31 Jul 2020 10:38:32 +0200

> Release skb memory in mvpp2_rx() if mvpp2_rx_refill routine fails
> 
> Fixes: b5015854674b ("net: mvpp2: fix refilling BM pools in RX path")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied and queued up for -stable, thank you.
