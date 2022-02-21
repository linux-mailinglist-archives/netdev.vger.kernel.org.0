Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34E54BDF08
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244369AbiBUK5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:57:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355439AbiBUKzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:55:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646272D1EF;
        Mon, 21 Feb 2022 02:24:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE121B80F10;
        Mon, 21 Feb 2022 10:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4C5C340E9;
        Mon, 21 Feb 2022 10:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645439047;
        bh=6s+hgRMRd1mGGSL9Zvl+8+90hKWB0EL5G7F0mNadTzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MtjrfxSImCQN6xpeOrz63uqubJDixtbjelbnF/EFsOhFr0Z25J99wQmKSULgReg9h
         L31eXvy6S0rODX8i79FTkHgiopSLKaDyA1YzTsnG0dQwjz7QKv9TuHT44fbPhxZAjG
         t87+oUvdR7qBojyhSpwSKAcD0gIGByttCzo9fwHHcYE/s2PwKFA/RCLXPAqy1gNmeh
         x0g+D70fWq5h8YK1NcpH6tQBjJNTxpdfaAztkTF72STdoDQcbAk7j9huQurf0nIvd2
         0DnvyCR3tn48HCA8sstUgS58AETs4KS5IzssOBXGLm2QVcQWBkYprH/hoxlCXETVcM
         b+Ju2bPQUJ4kA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] ath10k: Replace zero-length array with
 flexible-array
 member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216194807.GA904008@embeddedor>
References: <20220216194807.GA904008@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164543904389.26423.17294004275131018250.kvalo@kernel.org>
Date:   Mon, 21 Feb 2022 10:24:05 +0000 (UTC)
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

8bc66426ca54 ath10k: Replace zero-length array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216194807.GA904008@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

