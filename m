Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BA3115E57
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 20:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLGT71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 14:59:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfLGT7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 14:59:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85CF915422CCC;
        Sat,  7 Dec 2019 11:59:23 -0800 (PST)
Date:   Sat, 07 Dec 2019 11:59:22 -0800 (PST)
Message-Id: <20191207.115922.532322440743611081.davem@davemloft.net>
To:     ms@dev.tdt.de
Cc:     andrew.hendry@gmail.com, edumazet@google.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/x25: add new state X25_STATE_5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206133418.14075-1-ms@dev.tdt.de>
References: <20191206133418.14075-1-ms@dev.tdt.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 11:59:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>
Date: Fri,  6 Dec 2019 14:34:18 +0100

> +	switch (frametype) {
> +
> +		case X25_CLEAR_REQUEST:

Please remove this unnecessary empty line.

> +			if (!pskb_may_pull(skb, X25_STD_MIN_LEN + 2))
> +				goto out_clear;

A goto path for a single call site?  Just inline the operations here.

