Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB18E13789
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfEDErM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:47:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfEDErL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:47:11 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67F1D14D91C4B;
        Fri,  3 May 2019 21:47:04 -0700 (PDT)
Date:   Sat, 04 May 2019 00:47:00 -0400 (EDT)
Message-Id: <20190504.004700.1643902028919203643.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: cls_u32: use struct_size() helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190501162315.GA27166@embeddedor>
References: <20190501162315.GA27166@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:47:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Wed, 1 May 2019 11:23:15 -0500

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace code of the following form:
> 
> sizeof(*s) + s->nkeys*sizeof(struct tc_u32_key)
> 
> with:
> 
> struct_size(s, keys, s->nkeys)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
