Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C5B1D3DE9
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgENTtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727833AbgENTtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:49:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E476C061A0C;
        Thu, 14 May 2020 12:49:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 33386128CF131;
        Thu, 14 May 2020 12:49:09 -0700 (PDT)
Date:   Thu, 14 May 2020 12:49:08 -0700 (PDT)
Message-Id: <20200514.124908.1791254966123977524.davem@davemloft.net>
To:     vkoul@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rahulak@qti.qualcomm.com
Subject: Re: [PATCH] net: stmmac: fix num_por initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514062836.190194-1-vkoul@kernel.org>
References: <20200514062836.190194-1-vkoul@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 12:49:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>
Date: Thu, 14 May 2020 11:58:36 +0530

> Driver missed initializing num_por which is por values that driver
> configures to hardware. In order to get this values, add a new structure
> ethqos_emac_driver_data which holds por and num_por values and populate
> that in driver probe.
> 
> Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")
> Reported-by: Rahul Ankushrao Kawadgave <rahulak@qti.qualcomm.com>
> Signed-off-by: Vinod Koul <vkoul@kernel.org>

Applied and queued up for -stable, thanks.
