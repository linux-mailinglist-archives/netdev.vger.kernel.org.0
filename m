Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F481C0C8D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgEADYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgEADYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:24:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6625FC035494;
        Thu, 30 Apr 2020 20:24:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F03B12772F6A;
        Thu, 30 Apr 2020 20:24:23 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:24:22 -0700 (PDT)
Message-Id: <20200430.202422.549223229334559883.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     jonas.jensen@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: moxa: Fix a potential double 'free_irq()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200426205921.47714-1-christophe.jaillet@wanadoo.fr>
References: <20200426205921.47714-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:24:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 26 Apr 2020 22:59:21 +0200

> Should an irq requested with 'devm_request_irq' be released explicitly,
> it should be done by 'devm_free_irq()', not 'free_irq()'.
> 
> Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thank you.
