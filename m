Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2581164DA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 02:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfLIBwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 20:52:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfLIBwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 20:52:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76293153AF38E;
        Sun,  8 Dec 2019 17:52:22 -0800 (PST)
Date:   Sun, 08 Dec 2019 17:52:09 -0800 (PST)
Message-Id: <20191208.175209.1415607162791536317.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191208232734.225161-1-Jason@zx2c4.com>
References: <20191208232734.225161-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Dec 2019 17:52:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon,  9 Dec 2019 00:27:34 +0100

> WireGuard is a layer 3 secure networking tunnel made specifically for
> the kernel, that aims to be much simpler and easier to audit than IPsec.
> Extensive documentation and description of the protocol and
> considerations, along with formal proofs of the cryptography, are
> available at:
> 
>   * https://www.wireguard.com/
>   * https://www.wireguard.com/papers/wireguard.pdf
 ...

Applied, thanks Jason.
