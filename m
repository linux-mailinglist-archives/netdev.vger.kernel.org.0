Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DBC225544
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGTBRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgGTBRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:17:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAE1C0619D2;
        Sun, 19 Jul 2020 18:17:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B85F1284AF6B;
        Sun, 19 Jul 2020 18:17:00 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:16:59 -0700 (PDT)
Message-Id: <20200719.181659.1807927650741641565.davem@davemloft.net>
To:     hch@lst.de
Cc:     ast@kernel.org, daniel@iogearbox.net, 3chas3@gmail.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: Re: sockopt cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:17:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Fri, 17 Jul 2020 08:23:09 +0200

> this series cleans up various lose ends in the sockopt code, most
> importantly removing the compat_{get,set}sockopt infrastructure in favor
> of just using in_compat_syscall() in the few places that care.

Series applied to net-next, thanks.
