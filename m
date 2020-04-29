Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C4B1BE709
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgD2TNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbgD2TNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:13:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AE4C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 12:13:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A1FF1210A3E3;
        Wed, 29 Apr 2020 12:13:08 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:13:07 -0700 (PDT)
Message-Id: <20200429.121307.673493528481511466.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-stm32@st-md-mailman.stormreply.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 1/5] stmmac: intel: Check return value of
 clk_prepare_enable()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429140449.9484-1-andriy.shevchenko@linux.intel.com>
References: <20200429140449.9484-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:13:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please post your patch series with a proper header posting, explaining what
the patch series does, how it does it, and why you are doing it that way.

Thank you.
