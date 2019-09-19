Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26510B7571
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbfISIt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:49:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfISIt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:49:58 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78BC4154F0788;
        Thu, 19 Sep 2019 01:49:57 -0700 (PDT)
Date:   Thu, 19 Sep 2019 10:49:53 +0200 (CEST)
Message-Id: <20190919.104953.1082591608077978681.davem@davemloft.net>
To:     torvalds@linux-foundation.org
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHk-=whSTx4ofABCgWVe_2Kfo3CV6kSkBSRQBR-o5=DefgXnUQ@mail.gmail.com>
References: <20190918.003903.2143222297141990229.davem@davemloft.net>
        <CAHk-=whSTx4ofABCgWVe_2Kfo3CV6kSkBSRQBR-o5=DefgXnUQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 01:49:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Sep 2019 13:37:57 -0700

> I've obviously already pulled this (and only noticed when I was
> testing further on my laptop), but please explain or fix.

I'll take a look, thanks.
