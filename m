Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE810106B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfKSBDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:03:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfKSBDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:03:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7D8E150FA0E4;
        Mon, 18 Nov 2019 17:03:34 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:03:33 -0800 (PST)
Message-Id: <20191118.170333.2218428781780118321.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     toke@redhat.com, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, saeedm@mellanox.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com, lorenzo@kernel.org,
        tariqt@mellanox.com
Subject: Re: [net-next v2 PATCH 0/3] page_pool: followup changes to restore
 tracepoint features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157390333500.4062.15569811103072483038.stgit@firesoul>
References: <157390333500.4062.15569811103072483038.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:03:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Sat, 16 Nov 2019 12:22:32 +0100

> This patchset is a followup to Jonathan patch, that do not release
> pool until inflight == 0. That changed page_pool to be responsible for
> its own delayed destruction instead of relying on xdp memory model.
> 
> As the page_pool maintainer, I'm promoting the use of tracepoint to
> troubleshoot and help driver developers verify correctness when
> converting at driver to use page_pool. The role of xdp:mem_disconnect
> have changed, which broke my bpftrace tools for shutdown verification.
> With these changes, the same capabilities are regained.

Series applied, thanks Jesper.
