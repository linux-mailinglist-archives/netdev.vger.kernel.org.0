Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D6F66C7D1
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjAPQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjAPQeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:34:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592AF3B0FC;
        Mon, 16 Jan 2023 08:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2E4CCE1281;
        Mon, 16 Jan 2023 16:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF34C433F0;
        Mon, 16 Jan 2023 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673886120;
        bh=8SvgBpmKMDLhVuZQZo6HjdX+P6mQwUkiuy8oY6EYlcg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BUmg4wcDKcg3E8azwwVmhQGhtped4mjwsf80KUoZ/03nHWtApp8eZsxr6VT+kh4Tt
         00YTqSjm2Dq/S//3jnjkymwT5BGWQSe6AdnHFjdFcRGeS58+dNCtKmTTK3Fyuel8yQ
         03LHnUwU9pGs0XvWbP4m0IMCE8X1Wy2hYSDFh1SGnQX7fxd79KTwarRPHFXdpyOZ4q
         icBfV2nxfLEekzYHkOEaWX7pTiIMVuATLEUVAB0LIbIcPoMIRnI4b3mr5kju6KL6lx
         iDAgILLoYGEk4QgjFHF7U+oiV/8lPkydj3dBGvjgEMY1kh4iSnoJ8/wruFC1C7xKuL
         WVVfRknTNSWDA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: rtlwifi: rtl8723ae: fix obvious spelling error
 tyep->type
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221222-rtl8723ae-typo-fix-v2-1-71b6b67df3f5@mricon.com>
References: <20221222-rtl8723ae-typo-fix-v2-1-71b6b67df3f5@mricon.com>
To:     Konstantin Ryabitsev via B4 Submission Endpoint 
        <devnull+icon.mricon.com@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jens Schleusener <Jens.Schleusener@fossies.org>,
        Konstantin Ryabitsev <mricon@kernel.org>,
        Konstantin Ryabitsev <icon@mricon.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167388611656.5321.6986629423832015340.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 16:21:58 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konstantin Ryabitsev via B4 Submission Endpoint
        <devnull+icon.mricon.com@kernel.org> wrote:

> From: Konstantin Ryabitsev <icon@mricon.com>
> 
> This appears to be an obvious spelling error, initially identified in a
> codespell report and never addressed.
> 
> Reported-by: Jens Schleusener <Jens.Schleusener@fossies.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205891
> Signed-off-by: Konstantin Ryabitsev <icon@mricon.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

cb689109d9d7 wifi: rtlwifi: rtl8723ae: fix obvious spelling error tyep->type

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221222-rtl8723ae-typo-fix-v2-1-71b6b67df3f5@mricon.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

