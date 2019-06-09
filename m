Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0443ABB0
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 21:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfFITr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 15:47:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfFITr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 15:47:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9A8114DD36DF;
        Sun,  9 Jun 2019 12:47:58 -0700 (PDT)
Date:   Sun, 09 Jun 2019 12:47:58 -0700 (PDT)
Message-Id: <20190609.124758.1263532600061409322.davem@davemloft.net>
To:     info@metux.net
Cc:     linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: fib_semantics: fix uninitialized variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559832197-22758-1-git-send-email-info@metux.net>
References: <1559832197-22758-1-git-send-email-info@metux.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 12:47:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Date: Thu,  6 Jun 2019 16:43:17 +0200

> From: Enrico Weigelt <info@metux.net>
> 
> fix an uninitialized variable:
> 
>   CC      net/ipv4/fib_semantics.o
> net/ipv4/fib_semantics.c: In function 'fib_check_nh_v4_gw':
> net/ipv4/fib_semantics.c:1027:12: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    if (!tbl || err) {
>             ^~
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Applied.
