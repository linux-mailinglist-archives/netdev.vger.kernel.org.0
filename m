Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A544A2B9B
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 05:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352367AbiA2EdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 23:33:22 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:37468 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbiA2EdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 23:33:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V35NcGa_1643430797;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V35NcGa_1643430797)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 29 Jan 2022 12:33:18 +0800
Date:   Sat, 29 Jan 2022 12:33:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, matthieu.baerts@tessares.net
Subject: Re: [PATCH v2 net-next 3/3] net/smc: Fallback when handshake
 workqueue congested
Message-ID: <YfTDjXh8zP3WBAtg@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <2d3f81193fc7a245c50b30329d0e84ae98427a33.1643380219.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d3f81193fc7a245c50b30329d0e84ae98427a33.1643380219.git.alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 10:44:38PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> @@ -19,3 +19,15 @@ config SMC_DIAG

...

> +if SMC
> +
> +config SMC_AUTO_FALLBACK
> +	bool "SMC: automatic fallback to TCP"
> +	default y
> +	help
> +	  Allow automatic fallback to TCP accroding to the pressure of SMC-R
> +	  handshake process.
> +
> +	  If that's not what you except or unsure, say N.
> +endif

Using a netlink knob to control behavior with static key should be more
flexible. As I appended in the previous version of this patch.

Thank you,
Tony Lu
