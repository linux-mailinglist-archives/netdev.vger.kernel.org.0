Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D725A4462
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiH2H7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiH2H7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580052A8;
        Mon, 29 Aug 2022 00:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81886090A;
        Mon, 29 Aug 2022 07:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA762C433D6;
        Mon, 29 Aug 2022 07:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661759984;
        bh=+3aaj/8AximEUiQUzMAF2hVXGvCDb75+FpRM0iYci0s=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=f7KqM8VT1BKfQz3qAOQWSpheDgoxWsucr3vdXHX/yZ01KTFvOo364BCpzgGftfJeX
         1OX1S1jX1DZp6hb9fzYbifqfh1hFL3WPNrr49Qkpw+5g96Figq8qn/o5mqzQbkHchO
         tmAoc2X8FegsK/VKmimjL/9s0RNGYC+rHYCm+FvujdZuE/g46NTAKqjt2GArXvb7G/
         PAy0RjJa5iErgOAQCS7O3shCdYgXH0lhGXCRmJsByzmCpQR3TV5UeHFpbEuv/xvNqO
         MywMkRH5V/KnGs9gqAlIulmjyEix49N2TSLRexajhBTtjQTcsGZbu/xTwfIlR+lUc7
         Kf2x8b5xDA+MQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: cfg80211: add error code in brcmf_notify_sched_scan_results()
In-Reply-To: <20220829065831.14023-1-liqiong@nfschina.com> (Li Qiong's message
        of "Mon, 29 Aug 2022 14:58:31 +0800")
References: <20220829065831.14023-1-liqiong@nfschina.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 29 Aug 2022 10:59:35 +0300
Message-ID: <87edwzjx94.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ linux-wireless

Li Qiong <liqiong@nfschina.com> writes:

> The err code is 0 at the first two "out_err" paths, add error code
> '-EINVAL' for these error paths.
>
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
>  1 file changed, 2 insertions(+)

You need to CC linux-wireless, otherwise patchwork won't see it. Also
the title should be:

wifi: brcmfmac: add error code in brcmf_notify_sched_scan_results()

Please resubmit as v2.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
