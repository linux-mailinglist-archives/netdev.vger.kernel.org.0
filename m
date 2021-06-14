Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749673A6F74
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhFNTxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbhFNTxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 15:53:16 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C800C061574;
        Mon, 14 Jun 2021 12:51:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 251124D079864;
        Mon, 14 Jun 2021 12:51:12 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:51:11 -0700 (PDT)
Message-Id: <20210614.125111.1519954686951337716.davem@davemloft.net>
To:     mcroce@linux.microsoft.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, kuba@kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, drew@beagleboard.org, kernel@esmil.dk
Subject: Re: [PATCH net-next] stmmac: align RX buffers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210614022504.24458-1-mcroce@linux.microsoft.com>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 14 Jun 2021 12:51:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


But thois means the ethernet header will be misaliugned and this will kill performance on some cpus as misaligned accessed
are resolved wioth a trap handler.

Even on cpus that don't trap, the access will be slower.

Thanks.
