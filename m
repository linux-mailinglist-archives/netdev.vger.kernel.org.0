Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16D110CF89
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 22:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfK1VaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 16:30:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49334 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfK1VaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 16:30:24 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8843145487A4;
        Thu, 28 Nov 2019 13:30:23 -0800 (PST)
Date:   Thu, 28 Nov 2019 13:30:23 -0800 (PST)
Message-Id: <20191128.133023.1503723038764717212.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1] net: WireGuard secure network tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127112643.441509-1-Jason@zx2c4.com>
References: <20191127112643.441509-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 Nov 2019 13:30:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 27 Nov 2019 12:26:43 +0100

> +	do {
> +		next = skb->next;

I've been trying desperately to remove all direct references to the SKB list
implementation details so that we can convert it over to list_head.  This
means no direct references to skb->next nor skb->prev.

Please rearrange this using appropriate helpers and abstractions from skbuff.h
