Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AC5694D59
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjBMQwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBMQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:52:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFAE17CDF;
        Mon, 13 Feb 2023 08:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EEDFB81619;
        Mon, 13 Feb 2023 16:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14776C433D2;
        Mon, 13 Feb 2023 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676307165;
        bh=igSAdkoS2WIZMh4kG0/InVeysLSvrfcm3Uxd1IZ0v5E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=iA61dwX1WUciLOkZH/Rhh/XCKjyDkxOlgxedv+r75v7008rwHySnW7/NLvK9HNYgA
         vKoj+qn7zjDihLkd7ZTZUHbVfLf5hqZMiCU4W68y8Fjqp8ONspKjPSHvJvxGd8kCDR
         1bH89U+dPrNyWfcjrFv7OhnREAlzB3pXmJtDgs2uOYLPC5HdClyELVPvHyR/5J2SIt
         N7v74VbwiaEmRb2u9DzJVmc3aUKjdbdHQ1jdPzUmCf6rYZRPk6dlD90k1FJpfM5h71
         JhydfcZlU41Qklpzs0i8CDA7+fH19vuDByJKJnGb4D+wtiFsEhOlfao5GwK6coPEeb
         adeweJoZflz4Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [next] wifi: brcmfmac: Replace one-element array with
 flexible-array member
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <Y9xjizhMujNEtpB4@work>
References: <Y9xjizhMujNEtpB4@work>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630716010.12830.17813889618686482223.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 16:52:41 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct brcmf_tlv.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/253
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

552ac55ee9bc wifi: brcmfmac: Replace one-element array with flexible-array member

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/Y9xjizhMujNEtpB4@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

