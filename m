Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B5F324C1
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 22:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFBUdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 16:33:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFBUdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 16:33:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D852C140ADA45;
        Sun,  2 Jun 2019 13:33:19 -0700 (PDT)
Date:   Sun, 02 Jun 2019 13:33:17 -0700 (PDT)
Message-Id: <20190602.133317.1717743440184492447.davem@davemloft.net>
To:     nirranjan@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, dt@chelsio.com,
        indranil@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Set initial IRQ affinity hints
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1c4c78465a3f128a72c912a68ec3afcd19f206fb.1559115965.git.nirranjan@chelsio.com>
References: <1c4c78465a3f128a72c912a68ec3afcd19f206fb.1559115965.git.nirranjan@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 13:33:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nirranjan Kirubaharan <nirranjan@chelsio.com>
Date: Thu, 30 May 2019 23:14:28 -0700

> +	while (--ethqidx >= 0) {
> +		--msi_index;

It is more canonical to use "msi_index--;" here.
