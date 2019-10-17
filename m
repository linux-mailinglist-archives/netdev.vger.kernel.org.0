Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA75DB6C1
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441359AbfJQTD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:03:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728796AbfJQTD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:03:28 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E86E1401B3D7;
        Thu, 17 Oct 2019 12:03:28 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:03:25 -0400 (EDT)
Message-Id: <20191017.150325.322504489773598663.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] net: socionext: netsec: fix xdp stats
 accounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <50cf2bc622d81c8447713113c5c6a7d0fd4f5c95.1571315083.git.lorenzo@kernel.org>
References: <50cf2bc622d81c8447713113c5c6a7d0fd4f5c95.1571315083.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:03:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 17 Oct 2019 14:28:32 +0200

> Increment netdev rx counters even for XDP_DROP verdict. Report even
> tx bytes for xdp buffers (TYPE_NETSEC_XDP_TX or TYPE_NETSEC_XDP_NDO).
> Moreover account pending buffer length in netsec_xdp_queue_one as it is
> done for skb counterpart
> 
> Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - fix BQL accounting
> - target the patch to next-next

Applied, thanks.
