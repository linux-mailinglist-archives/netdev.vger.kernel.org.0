Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 067CA7B578
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388014AbfG3WIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:08:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56088 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfG3WIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:08:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97252146F6EF4;
        Tue, 30 Jul 2019 15:08:12 -0700 (PDT)
Date:   Tue, 30 Jul 2019 15:08:12 -0700 (PDT)
Message-Id: <20190730.150812.942736721465627162.davem@davemloft.net>
To:     xiaofeis@codeaurora.org
Cc:     vkoul@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH v3] net: dsa: qca8k: enable port flow control
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
References: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 15:08:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiaofeis <xiaofeis@codeaurora.org>
Date: Sun, 28 Jul 2019 08:57:50 +0800

> Set phy device advertising to enable MAC flow control.
> 
> Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>

I've read the discussion over a few times and if internal PHY is the
only thing supported, and the specific setup this driver supports uses
internal signalling to sync the PHY and MAC settings I guess this is
OK although suboptimal.

So applied, thanks.

Thanks.
