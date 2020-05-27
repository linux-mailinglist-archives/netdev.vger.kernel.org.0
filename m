Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E711E390D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 08:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgE0GYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 02:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgE0GYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 02:24:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A99C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 23:24:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85BB8127B0470;
        Tue, 26 May 2020 23:24:17 -0700 (PDT)
Date:   Tue, 26 May 2020 23:24:16 -0700 (PDT)
Message-Id: <20200526.232416.1374413190444423900.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ayush.sawal@chelsio.com, vinay.yadav@chelsio.com
Subject: Re: [PATCH net] crypto: chelsio/chtls: properly set tp->lsndtime
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527002856.212293-1-edumazet@google.com>
References: <20200527002856.212293-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 23:24:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 26 May 2020 17:28:56 -0700

> TCP tp->lsndtime unit/base is tcp_jiffies32, not tcp_time_stamp()
> 
> Fixes: 36bedb3f2e5b ("crypto: chtls - Inline TLS record Tx")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you.
