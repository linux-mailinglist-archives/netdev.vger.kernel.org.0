Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD374EB63E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfJaRiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:38:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbfJaRiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:38:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84E9714FA67E0;
        Thu, 31 Oct 2019 10:38:15 -0700 (PDT)
Date:   Thu, 31 Oct 2019 10:38:13 -0700 (PDT)
Message-Id: <20191031.103813.2043786873046546149.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] cxgb4/l2t: Simplify 't4_l2e_free()' and
 '_t4_l2e_free()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031055345.32487-1-christophe.jaillet@wanadoo.fr>
References: <20191031055345.32487-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 10:38:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu, 31 Oct 2019 06:53:45 +0100

> Use '__skb_queue_purge()' instead of re-implementing it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to net-next.
