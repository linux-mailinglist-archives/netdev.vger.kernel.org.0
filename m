Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB701F872
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfEOQYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:24:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfEOQYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:24:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E44A14E340D7;
        Wed, 15 May 2019 09:24:13 -0700 (PDT)
Date:   Wed, 15 May 2019 09:24:12 -0700 (PDT)
Message-Id: <20190515.092412.1272864626450901775.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net] tcp: do not recycle cloned skbs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190515161015.16115-1-edumazet@google.com>
References: <20190515161015.16115-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 May 2019 09:24:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 May 2019 09:10:15 -0700

> It is illegal to change arbitrary fields in skb_shared_info if the
> skb is cloned.
> 
> Before calling skb_zcopy_clear() we need to ensure this rule,
> therefore we need to move the test from sk_stream_alloc_skb()
> to sk_wmem_free_skb()
> 
> Fixes: 4f661542a402 ("tcp: fix zerocopy and notsent_lowat issues")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Diagnosed-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable.
