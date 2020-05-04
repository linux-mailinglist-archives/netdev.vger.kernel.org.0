Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EC81C42E7
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgEDReL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729549AbgEDReK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:34:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922B2C061A0E;
        Mon,  4 May 2020 10:34:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8138148FE64F;
        Mon,  4 May 2020 10:34:09 -0700 (PDT)
Date:   Mon, 04 May 2020 10:34:09 -0700 (PDT)
Message-Id: <20200504.103409.787413834519966204.davem@davemloft.net>
To:     mmrmaximuzz@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] stmmac: fix pointer check after utilization in
 stmmac_interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504062639.GA11585@maxim-hplinux>
References: <20200504062639.GA11585@maxim-hplinux>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:34:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Petrov <mmrmaximuzz@gmail.com>
Date: Mon, 4 May 2020 09:26:43 +0300

> The paranoidal pointer check in IRQ handler looks very strange - it
> really protects us only against bogus drivers which request IRQ line
> with null pointer dev_id. However, the code fragment is incorrect
> because the dev pointer is used before the actual check which leads
> to undefined behavior. Remove the check to avoid confusing people
> with incorrect code.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>

Applied, thanks.
