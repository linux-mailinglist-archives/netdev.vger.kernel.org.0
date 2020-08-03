Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62C223B09F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgHCXBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgHCXBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:01:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA53C06174A;
        Mon,  3 Aug 2020 16:01:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B6861277918D;
        Mon,  3 Aug 2020 15:44:47 -0700 (PDT)
Date:   Mon, 03 Aug 2020 16:01:32 -0700 (PDT)
Message-Id: <20200803.160132.173649007258760362.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kou.ishizaki@toshiba.co.jp, kuba@kernel.org, linas@austin.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] net: spider_net: Remove a useless memset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200802135348.691046-1-christophe.jaillet@wanadoo.fr>
References: <20200802135348.691046-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:44:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun,  2 Aug 2020 15:53:48 +0200

> Avoid a memset after a call to 'dma_alloc_coherent()'.
> This is useless since
> commit 518a2f1925c3 ("dma-mapping: zero memory returned from dma_alloc_*")
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
