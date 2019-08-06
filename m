Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24AE838A6
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733011AbfHFSei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:34:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfHFSeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:34:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03E6B152488D1;
        Tue,  6 Aug 2019 11:34:36 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:34:36 -0700 (PDT)
Message-Id: <20190806.113436.87450273064586797.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: cxgb3_main: Fix a resource leak in a error path
 in 'init_one()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806085512.11729-1-christophe.jaillet@wanadoo.fr>
References: <20190806085512.11729-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 11:34:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue,  6 Aug 2019 10:55:12 +0200

> A call to 'kfree_skb()' is missing in the error handling path of
> 'init_one()'.
> This is already present in 'remove_one()' but is missing here.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Looks good, applied, thanks.
