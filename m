Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C38C3A03
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfJAQIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:08:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfJAQIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:08:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8685D154B1F13;
        Tue,  1 Oct 2019 09:08:41 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:08:40 -0700 (PDT)
Message-Id: <20191001.090840.281037950909937158.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net] net: socionext: netsec: always grab descriptor lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <24b0644bf4e2c1de36e774a8cd95bd39697f9b12.1569918386.git.lorenzo@kernel.org>
References: <24b0644bf4e2c1de36e774a8cd95bd39697f9b12.1569918386.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:08:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue,  1 Oct 2019 10:33:51 +0200

> Always acquire tx descriptor spinlock even if a xdp program is not loaded
> on the netsec device since ndo_xdp_xmit can run concurrently with
> netsec_netdev_start_xmit and netsec_clean_tx_dring. This can happen
> loading a xdp program on a different device (e.g virtio-net) and
> xdp_do_redirect_map/xdp_do_redirect_slow can redirect to netsec even if
> we do not have a xdp program on it.
> 
> Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied and queued up for v5.3 -stable.
