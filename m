Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A08F164E1D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgBSSyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:54:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbgBSSyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:54:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6827F15ADF42E;
        Wed, 19 Feb 2020 10:54:36 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:54:35 -0800 (PST)
Message-Id: <20200219.105435.570179417597765763.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        kuba@kernel.org, lorenzo.bianconi@redhat.com, brouer@redhat.com,
        dsahern@kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6c5f27aff46e6dd6be92ce29b65bc3670eeabffc.1582105994.git.lorenzo@kernel.org>
References: <6c5f27aff46e6dd6be92ce29b65bc3670eeabffc.1582105994.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 10:54:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Wed, 19 Feb 2020 10:57:37 +0100

> Introduce "rx" prefix in the name scheme for xdp counters
> on rx path.
> Differentiate between XDP_TX and ndo_xdp_xmit counters
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since RFC:
> - rename rx_xdp_tx_xmit in rx_xdp_tx
> - move tx stats accounting in mvneta_xdp_xmit_back/mvneta_xdp_xmit

Applied, thanks for following up on this Lorenzo.
