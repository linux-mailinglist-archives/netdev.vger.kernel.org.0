Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B0B33A83
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFCV7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:59:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35934 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfFCV7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:59:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF10C133E97D9;
        Mon,  3 Jun 2019 14:59:24 -0700 (PDT)
Date:   Mon, 03 Jun 2019 14:59:24 -0700 (PDT)
Message-Id: <20190603.145924.1916623136571096714.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        wangkefeng.wang@huawei.com
Subject: Re: [PATCH net-next] ipv6: icmp: use this_cpu_read() in icmpv6_sk()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531222700.252607-1-edumazet@google.com>
References: <20190531222700.252607-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 14:59:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 31 May 2019 15:27:00 -0700

> In general, this_cpu_read(*X) is faster than *this_cpu_ptr(X)
> 
> Also remove the inline attibute, totally useless.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>

Applied.
