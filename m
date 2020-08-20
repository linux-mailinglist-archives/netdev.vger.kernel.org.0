Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD8624C5F2
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHTSzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgHTSzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:55:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8DBC061385;
        Thu, 20 Aug 2020 11:55:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CCE1128006A5;
        Thu, 20 Aug 2020 11:38:31 -0700 (PDT)
Date:   Thu, 20 Aug 2020 11:55:12 -0700 (PDT)
Message-Id: <20200820.115512.511642239854628332.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, thomas@sockpuppet.org,
        adhipati@tuta.io, dsahern@gmail.com, toke@redhat.com,
        kuba@kernel.org, alexei.starovoitov@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net v6] net: xdp: account for layer 3 packets in
 generic skb handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9oBQu-k6VKJ5QzVLpE-ZuYoo=qHGKESj8JbxQhDq9QNrQ@mail.gmail.com>
References: <20200815074102.5357-1-Jason@zx2c4.com>
        <20200819.162247.527509541688231611.davem@davemloft.net>
        <CAHmME9oBQu-k6VKJ5QzVLpE-ZuYoo=qHGKESj8JbxQhDq9QNrQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 11:38:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 20 Aug 2020 11:13:49 +0200

> It seems like if an eBPF program pushes on a VLAN tag or changes the
> protocol or does any other modification, it will be treated in exactly
> the same way as the L2 packet above by the remaining parts of the
> networking stack.

What will update the skb metadata if the XDP program changes the
wireguard header(s)?
