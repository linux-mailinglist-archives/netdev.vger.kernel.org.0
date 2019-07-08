Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCAC629CC
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404126AbfGHTli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:41:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbfGHTlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:41:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0090E133E9BDC;
        Mon,  8 Jul 2019 12:41:36 -0700 (PDT)
Date:   Mon, 08 Jul 2019 12:41:36 -0700 (PDT)
Message-Id: <20190708.124136.118336806940211197.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        willemb@google.com, lrizzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] gve: fix unused variable/label warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190708124350.3470436-1-arnd@arndb.de>
References: <20190708124350.3470436-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 12:41:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon,  8 Jul 2019 14:43:39 +0200

> On unusual page sizes, we get harmless warnings:
> 
> drivers/net/ethernet/google/gve/gve_rx.c:283:6: error: unused variable 'pagecount' [-Werror,-Wunused-variable]
> drivers/net/ethernet/google/gve/gve_rx.c:336:1: error: unused label 'have_skb' [-Werror,-Wunused-label]
> 
> Change the preprocessor #if to regular if() to avoid this.
> 
> Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
