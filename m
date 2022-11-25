Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A256163886F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 12:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiKYLPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 06:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKYLPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 06:15:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7024824958;
        Fri, 25 Nov 2022 03:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ADDD6239A;
        Fri, 25 Nov 2022 11:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D478DC433C1;
        Fri, 25 Nov 2022 11:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669374905;
        bh=jbz6wVa+XiyBRVRh8XiIiRYL5nN8ly7IaofiEJMqw7E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Kmiwn3hXLX57+xwkCq9XvrTQcY1dFIep1GSam6l0m0xxAXkkvdJwavbhxAbtpfLY7
         p1j20js7sgvD4E83SNqWtFAS6ra8FxPnxdEZ4CQLkwj0fZ6l1Rm0NpVtQ8ePBJIjwF
         x0IKGasRu93eUlbJh2edStvAWRKofoisTSu+067pMy9HVMDbKdnMYTo2sJL5J1vbUz
         jMxEr7wXOSfVoOyHVOwWotw0vGjt+xRbqJfax8h/qw53VjmTLAVzxmYNcwd8BIysAb
         hvth31sCYMXd3AfV4TDXHWRsN26tObifhA+aEkhhUsqqgAZ1F4eaXBBCImSRYA10v2
         k/syhCfUnFqXg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] carl9170: Replace zero-length array of trailing structs
 with
 flex-array
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221118211146.never.395-kees@kernel.org>
References: <20221118211146.never.395-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166937490066.28196.15714498796045859464.kvalo@kernel.org>
Date:   Fri, 25 Nov 2022 11:15:02 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Zero-length arrays are deprecated[1] and are being replaced with
> flexible array members in support of the ongoing efforts to tighten the
> FORTIFY_SOURCE routines on memcpy(), correctly instrument array indexing
> with UBSAN_BOUNDS, and to globally enable -fstrict-flex-arrays=3.
> 
> Replace zero-length array with flexible-array member.
> 
> This results in no differences in binary output.
> 
> [1] https://github.com/KSPP/linux/issues/78
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

7256f28767fa wifi: carl9170: Replace zero-length array of trailing structs with flex-array

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221118211146.never.395-kees@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

