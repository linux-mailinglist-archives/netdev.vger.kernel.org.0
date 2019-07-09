Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED69E62E20
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfGICag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:30:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33812 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGICaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:30:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88167133E9760;
        Mon,  8 Jul 2019 19:30:35 -0700 (PDT)
Date:   Mon, 08 Jul 2019 19:30:35 -0700 (PDT)
Message-Id: <20190708.193035.1657931859879684675.davem@davemloft.net>
To:     cpaasch@apple.com
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net] tcp: Reset bytes_acked and bytes_received when
 disconnecting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190706231307.98483-1-cpaasch@apple.com>
References: <20190706231307.98483-1-cpaasch@apple.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 19:30:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>
Date: Sat, 06 Jul 2019 16:13:07 -0700

> If an app is playing tricks to reuse a socket via tcp_disconnect(),
> bytes_acked/received needs to be reset to 0. Otherwise tcp_info will
> report the sum of the current and the old connection..
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 0df48c26d841 ("tcp: add tcpi_bytes_acked to tcp_info")
> Fixes: bdd1f9edacb5 ("tcp: add tcpi_bytes_received to tcp_info")
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>

Applied and queued up for -stable.
