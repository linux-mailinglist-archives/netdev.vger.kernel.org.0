Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7398133494
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgAGV0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:26:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38226 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgAGV0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:26:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D21AF15A16D6A;
        Tue,  7 Jan 2020 13:26:33 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:26:33 -0800 (PST)
Message-Id: <20200107.132633.1454816315429651325.davem@davemloft.net>
To:     jiping.ma2@windriver.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V5] stmmac: debugfs entry name is not be changed
 when udev rename device name.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107063400.41666-1-jiping.ma2@windriver.com>
References: <20200107063400.41666-1-jiping.ma2@windriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:26:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiping Ma <jiping.ma2@windriver.com>
Date: Tue, 7 Jan 2020 14:34:00 +0800

> Add one notifier for udev changes net device name.
> Fixes: b6601323ef9e ("net: stmmac: debugfs entry name is not be changed when udev rename")
> 
> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>

Applied.
