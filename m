Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7F26190A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 03:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfGHBzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 21:55:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfGHBzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 21:55:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA9E615288A25;
        Sun,  7 Jul 2019 18:55:19 -0700 (PDT)
Date:   Sun, 07 Jul 2019 18:55:19 -0700 (PDT)
Message-Id: <20190707.185519.1104845537295054845.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/6] gtp: fix several bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702152034.22412-1-ap420073@gmail.com>
References: <20190702152034.22412-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 18:55:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Wed,  3 Jul 2019 00:20:34 +0900

> This patch series fixes several bugs in the gtp module.

I reviewed these carefully by hand and decided to apply these now.

Thanks Taehee.
