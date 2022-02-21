Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7204BDCC4
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345729AbiBUK5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:57:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355792AbiBUK4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:56:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834A51F8;
        Mon, 21 Feb 2022 02:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45A97B80DA4;
        Mon, 21 Feb 2022 10:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52968C340E9;
        Mon, 21 Feb 2022 10:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645439165;
        bh=x6k+ycJdfYSMO02ATdagF4nEoyWp5WFVtrDQAT/eU1k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XnwV50qndTO0Xo45t5JsGpYY6Tlo6TXVim7QQAfD/gahHvtKY8SuMUFwdQE6mfurl
         S6no9Mik+DRG4rhPRPxaHBIkDRgGdXXCNqjfbtT2soCtrPbvWii8X4wJYAy9ncAGeq
         NAXOCe8z3HcEo2ZiIngk5JF01IKK0ZQRTCqt3QXI4LS5Trt6oUtIe6+1bkA7IMGQ/N
         CyvJwvD3pqIE5aaEBWKIZ09t14OAg8E7m4+oZ607udCBXIeUjUGlNvXpuv+dkWc8j/
         xF89kHSdYpDos/RSPeKUKwS24dLjw2rpKwlsfE2/G/cC9MXzoh4rU9t+EbMmt0Ua5r
         XbfinfhMiqOnw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] ath6kl: Replace zero-length arrays with
 flexible-array
 members
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216194857.GA904059@embeddedor>
References: <20220216194857.GA904059@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164543916134.26423.3775423173401494740.kvalo@kernel.org>
Date:   Mon, 21 Feb 2022 10:26:03 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use “flexible array members”[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d9bc14167b1f ath6kl: Replace zero-length arrays with flexible-array members

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216194857.GA904059@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

