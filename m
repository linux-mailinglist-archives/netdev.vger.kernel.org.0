Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E959F1C45D5
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgEDS1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729963AbgEDS1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:27:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696AEC061A0E;
        Mon,  4 May 2020 11:27:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C59B811F5F61A;
        Mon,  4 May 2020 11:27:12 -0700 (PDT)
Date:   Mon, 04 May 2020 11:27:11 -0700 (PDT)
Message-Id: <20200504.112711.737183739334621556.davem@davemloft.net>
To:     elder@linaro.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] net: ipa: I/O map SMEM and IMEM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504175859.22606-1-elder@linaro.org>
References: <20200504175859.22606-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:27:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon,  4 May 2020 12:58:55 -0500

> This series adds the definition of two memory regions that must be
> mapped for IPA to access through an SMMU.  It requires the SMMU to
> be defined in the IPA node in the SoC's Device Tree file.
> 
> There is no change since version 1 to the content of the code in
> these patches, *however* this time the first patch is an update to
> the binding definition rather than an update to a DTS file.

Series applied, thanks Alex.
