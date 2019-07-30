Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC22C7B4ED
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbfG3VWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:22:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55482 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfG3VWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:22:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01A4E14A8CC6D;
        Tue, 30 Jul 2019 14:22:38 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:22:38 -0700 (PDT)
Message-Id: <20190730.142238.1475873068715429404.davem@davemloft.net>
To:     axboe@fb.com
Cc:     jonathan.lemon@gmail.com, willy@infradead.org,
        jakub.kicinski@netronome.com, Kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to
 bio_vec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1d34658b-a807-44ae-756a-d55dead27f94@fb.com>
References: <20190730144034.444022-1-jonathan.lemon@gmail.com>
        <1d34658b-a807-44ae-756a-d55dead27f94@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 14:22:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@fb.com>
Date: Tue, 30 Jul 2019 20:49:09 +0000

> Pretty appalled to see this abomination:
> 
> net: Convert skb_frag_t to bio_vec
> 
> There are a lot of users of frag->page_offset, so use a union
> to avoid converting those users today.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> show up in the net tree without even having been posted on a
> block list...
> 
> At least this kills this ugly thing.

Sorry about that Jens, but at least as you say it's gone now.
