Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B9D1C467B
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEDS5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDS5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:57:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9542C061A0E;
        Mon,  4 May 2020 11:57:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B69711F5F61A;
        Mon,  4 May 2020 11:57:39 -0700 (PDT)
Date:   Mon, 04 May 2020 11:57:38 -0700 (PDT)
Message-Id: <20200504.115738.1197878174801820355.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: gmac5+: fix potential integer overflow on
 32 bit multiply
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501141016.290699-1-colin.king@canonical.com>
References: <20200501141016.290699-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:57:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri,  1 May 2020 15:10:16 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The multiplication of cfg->ctr[1] by 1000000000 is performed using a
> 32 bit multiplication (since cfg->ctr[1] is a u32) and this can lead
> to a potential overflow. Fix this by making the constant a ULL to
> ensure a 64 bit multiply occurs.
> 
> Fixes: 504723af0d85 ("net: stmmac: Add basic EST support for GMAC5+")
> Addresses-Coverity: ("Unintentional integer overflow")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
