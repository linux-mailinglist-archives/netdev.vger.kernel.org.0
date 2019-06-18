Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B339D4ADEE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 00:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfFRWkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 18:40:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54576 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbfFRWkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 18:40:32 -0400
Received: from localhost (unknown [198.134.98.50])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1DB212D6B4D3;
        Tue, 18 Jun 2019 15:40:31 -0700 (PDT)
Date:   Tue, 18 Jun 2019 18:40:26 -0400 (EDT)
Message-Id: <20190618.184026.1967040334284472836.davem@davemloft.net>
To:     ard.biesheuvel@linaro.org
Cc:     ebiggers@kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com,
        ycheng@google.com
Subject: Re: [PATCH 2/2] net: fastopen: use endianness agnostic
 representation of the cookie
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKv+Gu-xBCe09B1=GvXBH3V-p7=fOZcdL5pvFi5v19LT0J4KHA@mail.gmail.com>
References: <20190618093207.13436-3-ard.biesheuvel@linaro.org>
        <20190618182253.GK184520@gmail.com>
        <CAKv+Gu-xBCe09B1=GvXBH3V-p7=fOZcdL5pvFi5v19LT0J4KHA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 15:40:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 18 Jun 2019 20:40:18 +0200

> Can we first agree on whether we care about this or not? If so, i
> can spin a v2.

Well, how can it possibly work otherwise in deployment scenerios involving
both big and little endian hosts?
