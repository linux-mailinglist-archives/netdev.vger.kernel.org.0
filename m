Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0E01C7E8E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEGA2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgEGA2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:28:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4815FC061A0F;
        Wed,  6 May 2020 17:28:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62E6F1277CC71;
        Wed,  6 May 2020 17:28:01 -0700 (PDT)
Date:   Wed, 06 May 2020 17:28:00 -0700 (PDT)
Message-Id: <20200506.172800.273989085861588453.davem@davemloft.net>
To:     elder@linaro.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org,
        evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] arm64: dts: sdm845: add IPA iommus
 property
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504181350.22822-1-elder@linaro.org>
References: <20200504181350.22822-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:28:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon,  4 May 2020 13:13:50 -0500

> Add an "iommus" property to the IPA node in "sdm845.dtsi".  It is
> required because there are two regions of memory the IPA accesses
> through an SMMU.  The next few patches define and map those regions.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied.
