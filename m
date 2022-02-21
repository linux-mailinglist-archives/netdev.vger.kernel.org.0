Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE224BE909
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345634AbiBUK5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:57:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355666AbiBUK4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:56:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A42A2DD71;
        Mon, 21 Feb 2022 02:25:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1773E60F5F;
        Mon, 21 Feb 2022 10:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879B5C340E9;
        Mon, 21 Feb 2022 10:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645439105;
        bh=I0h6TXzpI9LTd9+PXWtc7STtHBWbZ1omafIuWXHUcvM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dPpIDnIeu+OeUBZ1vTyvbO1j9NeQvZqlqC/YN5IoGmfD/CmJdP73k2C0mtiBUGOFc
         WEQTyXgwoZcQG4gYHaZZsux6ucbLuUJgrgoVjdC6djv3VScHpsUFAKxpbYpv6EM1qC
         3JPLd0bRsue5qdYek8oAjYxJpl2KLGAlukVL9X0MFt0jydNeleoZJaFijz7X+plocd
         YWEqAQ867NxG1pc+ftAOMD/cpZ0GXb1Xz0uilkg+Ng17WlsSDgJXggRyQsj62cyHUD
         FW32uTlLw4uqRlTbI3vOerJSI7T++XtD//7EFfTA7Afpt3vFODb2XpqfaKQC2g6CBB
         t22zEnQ8dYohQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] ath11k: Replace zero-length arrays with
 flexible-array
 members
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216194836.GA904035@embeddedor>
References: <20220216194836.GA904035@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164543910185.26423.18264056361764169829.kvalo@kernel.org>
Date:   Mon, 21 Feb 2022 10:25:03 +0000 (UTC)
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

e9e591686ccb ath11k: Replace zero-length arrays with flexible-array members

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216194836.GA904035@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

