Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8DEE7A23
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfJ1UeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:34:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbfJ1UeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:34:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8245814B79E1F;
        Mon, 28 Oct 2019 13:34:03 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:34:00 -0700 (PDT)
Message-Id: <20191028.133400.1796551680665069509.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net 0/5] net: avoid KCSAN splats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024054452.81661-1-edumazet@google.com>
References: <20191024054452.81661-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:34:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 23 Oct 2019 22:44:47 -0700

> Often times we use skb_queue_empty() without holding a lock,
> meaning that other cpus (or interrupt) can change the queue
> under us. This is fine, but we need to properly annotate
> the lockless intent to make sure the compiler wont over
> optimize things.

Series applied and I'll queue this up for -stable.

Thanks Eric.
