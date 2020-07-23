Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1C022B930
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGWWKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgGWWKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:10:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09AFC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 15:10:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02B8711E48C62;
        Thu, 23 Jul 2020 14:54:06 -0700 (PDT)
Date:   Thu, 23 Jul 2020 15:10:51 -0700 (PDT)
Message-Id: <20200723.151051.16194602184853977.davem@davemloft.net>
To:     kuniyu@amazon.co.jp
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        willemb@google.com, jakub@cloudflare.com, netdev@vger.kernel.org,
        kuni1840@gmail.com, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net] udp: Remove an unnecessary variable in
 udp[46]_lib_lookup2().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722165227.51046-1-kuniyu@amazon.co.jp>
References: <20200722165227.51046-1-kuniyu@amazon.co.jp>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 14:54:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date: Thu, 23 Jul 2020 01:52:27 +0900

> This patch removes an unnecessary variable in udp[46]_lib_lookup2() and
> makes it easier to resolve a merge conflict with bpf-next reported in
> the link below.
> 
> Link: https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/
> Fixes: efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>

This doesn't apply to net-next.
