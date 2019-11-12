Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1B9F9A88
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKLUYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:24:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLUYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:24:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24D55154D4A28;
        Tue, 12 Nov 2019 12:24:11 -0800 (PST)
Date:   Tue, 12 Nov 2019 12:24:10 -0800 (PST)
Message-Id: <20191112.122410.512273112809490584.davem@davemloft.net>
To:     afabre@cloudflare.com
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        cmclachlan@solarflare.com, mhabets@solarflare.com, ast@kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH v2 net-next] sfc: trace_xdp_exception on XDP failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112153601.5849-1-afabre@cloudflare.com>
References: <20191112153601.5849-1-afabre@cloudflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:24:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Fabre <afabre@cloudflare.com>
Date: Tue, 12 Nov 2019 15:36:01 +0000

> The sfc driver can drop packets processed with XDP, notably when running
> out of buffer space on XDP_TX, or returning an unknown XDP action.
> This increments the rx_xdp_bad_drops ethtool counter.
> 
> Call trace_xdp_exception everywhere rx_xdp_bad_drops is incremented,
> except for fragmented RX packets as the XDP program hasn't run yet.
> This allows it to easily be monitored from userspace.
> 
> This mirrors the behavior of other drivers.
> 
> Signed-off-by: Arthur Fabre <afabre@cloudflare.com>

Applied.
