Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD614EB624
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbiC2WlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiC2WlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:41:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B40260D8F;
        Tue, 29 Mar 2022 15:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 166A3B81AB2;
        Tue, 29 Mar 2022 22:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63551C340ED;
        Tue, 29 Mar 2022 22:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648593565;
        bh=jBEoQd+o9IxNRSHD1Zzy9pW1E9ZsrIAJQR+GoRmhc34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a/me7BLLcoF7bZiZTOZZWP0nvjDsSLhUz6xLsScdiijWlBXX7/gX6ltU71GRgQKz1
         nfJpMcb7Ite2jHy2+McnRGT5oSZ/z9hDfO9j0PclLSGjIYDVgZuPFEr8pTjlrG4lvU
         Ils9HtzwK0HJw2S1LIVzNaUIxuV7cPjFMrR5vCOhe7eUbeQv0TbD0y+zcCf8JGPjbB
         i4yoFhZzFF5PiluOHYXeTptKnx3nQxwtrRYqZ9JaoPLr2/vBgGWfUaOvqLAwV4HM16
         RjX2248mzBp3bg8X+dlah2rVTbY1VTYsrrDRnk8cVtkIJiWGnSOMrqtDpjzxBgSSlk
         ZYe0ujtpaxikw==
Date:   Tue, 29 Mar 2022 15:39:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, bhupesh.linux@gmail.com, vkoul@kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 net-next 1/1] dt-bindings: net: qcom,ethqos: Document
 SM8150 SoC compatible
Message-ID: <20220329153924.18863c8f@kernel.org>
In-Reply-To: <20220325200731.1585554-1-bhupesh.sharma@linaro.org>
References: <20220325200731.1585554-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Mar 2022 01:37:31 +0530 Bhupesh Sharma wrote:
> From: Vinod Koul <vkoul@kernel.org>
> 
> SM8150 has an ethernet controller and it needs a different
> configuration, so add a new compatible for this.
> 
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> [bhsharma: Massage the commit log]
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
> 
> Changes since v3:
> -----------------
> - v3 can be seen here: https://lore.kernel.org/lkml/20220303084824.284946-4-bhupesh.sharma@linaro.org/T/
> - Bjorn requested that this patch be sent to networking list separately,
>   so that patch can be easily reviewed and merged.

Looks like the support had been added already and this is just
documenting the binding so applied to net - commit 6094e391e643
("dt-bindings: net: qcom,ethqos: Document SM8150 SoC compatible")
Thanks!
