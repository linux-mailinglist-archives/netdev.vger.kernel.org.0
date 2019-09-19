Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24208B785B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389821AbfISLWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:22:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389755AbfISLWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:22:54 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E88A154FB2E3;
        Thu, 19 Sep 2019 04:22:53 -0700 (PDT)
Date:   Thu, 19 Sep 2019 13:22:51 +0200 (CEST)
Message-Id: <20190919.132251.194552806374954659.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 04:22:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Sep 2019 13:37:57 -0700

> Hmm. This adds that NET_TC_SKB_EXT config thing, and makes it "default y".
> 
> Why?
> 
> It's also done in a crazy way:
> 
> +       depends on NET_CLS_ACT
> +       default y if NET_CLS_ACT

I agree.

I've asked Paul Blakey, who added this, to make it depend upon OpenVSWwtch
or whatever else uses it.
