Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2E1FD2AD
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfKOCEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:04:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKOCEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:04:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF56714B79ED9;
        Thu, 14 Nov 2019 18:04:40 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:04:40 -0800 (PST)
Message-Id: <20191114.180440.1601232234094527874.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: mvneta: fix build skb for bm capable
 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2369ff5a16ac160d8130612e4299efe072f53d80.1573686984.git.lorenzo@kernel.org>
References: <2369ff5a16ac160d8130612e4299efe072f53d80.1573686984.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:04:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 14 Nov 2019 01:25:55 +0200

> Fix build_skb for bm capable devices when they fall-back using swbm path
> (e.g. when bm properties are configured in device tree but
> CONFIG_MVNETA_BM_ENABLE is not set). In this case rx_offset_correction is
> overwritten so we need to use it building skb instead of
> MVNETA_SKB_HEADROOM directly
> 
> Fixes: 8dc9a0888f4c ("net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine")
> Fixes: 0db51da7a8e9 ("net: mvneta: add basic XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied.
