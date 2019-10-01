Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F117DC4191
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 22:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfJAUIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 16:08:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfJAUIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 16:08:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C9CF1550B56C;
        Tue,  1 Oct 2019 13:08:07 -0700 (PDT)
Date:   Tue, 01 Oct 2019 13:08:04 -0700 (PDT)
Message-Id: <20191001.130804.924010447362293417.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] tcp: add ipv6_addr_v4mapped_loopback() helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001174906.96622-1-edumazet@google.com>
References: <20191001174906.96622-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 13:08:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  1 Oct 2019 10:49:06 -0700

> tcp_twsk_unique() has a hard coded assumption about ipv4 loopback
> being 127/8
> 
> Lets instead use the standard ipv4_is_loopback() method,
> in a new ipv6_addr_v4mapped_loopback() helper.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
