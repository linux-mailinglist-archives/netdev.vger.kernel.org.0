Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22525491C3
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfFQU5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:57:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFQU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:57:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AC7E15130B12;
        Mon, 17 Jun 2019 13:57:13 -0700 (PDT)
Date:   Mon, 17 Jun 2019 13:57:12 -0700 (PDT)
Message-Id: <20190617.135712.1886619234506210997.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     ard.biesheuvel@linaro.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: Re: [PATCH v3] net: ipv4: move tcp_fastopen server side code to
 SipHash library
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e1c4c9b6-3668-106a-69ef-7ef6c016a5f6@gmail.com>
References: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
        <e1c4c9b6-3668-106a-69ef-7ef6c016a5f6@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 13:57:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 17 Jun 2019 10:00:28 -0700

> All our fastopen packetdrill tests pass (after I changed all the cookie values in them)
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

I'm going to apply this to net-next, I want it to sit there for a
while.

Thanks.
