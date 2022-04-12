Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9738C4FE2D1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240889AbiDLNjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiDLNju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:39:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9762E092;
        Tue, 12 Apr 2022 06:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B9DCB81D7A;
        Tue, 12 Apr 2022 13:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857E1C385A1;
        Tue, 12 Apr 2022 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649770649;
        bh=v0nDaaCQ3usmsYxnhE/FHNZck2HIGICmWaiMBdencwI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Uk22QgIvlCLGqhttJUlJHTKFNSZX3+X8U3p7zjNDrYvQZ51Q+P+X/ad8ErHVMVOVB
         AbsreyM2rucCIm8k3sOR9v5RGUoilV/1m6IzSXvTJ5VW+WDsOrwwC61nkO+ItW/MSV
         23oD+7nfadTQw0idWgv8adiHLZGLOanERg0NgFEHS2ODvDLmfhqqVe3jpVVHccqGts
         JIkq8FvcNzgNVvGqIDsMdr09ViFum4BZiR55Zq672PyUeOAJDUURNLOf3RkCKAiX44
         geNC39ZapXVaX88pE0H4QQ66mC9DgYk8RMs6nV0vuKqKnhEF8zpmInujfPFmMs+0L+
         8cjrQNJwae/vQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw89: ser: add a break statement
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220407175349.3053362-1-trix@redhat.com>
References: <20220407175349.3053362-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164977064177.31115.17806762798615887989.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:37:26 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> The clang build fails with
> ser.c:397:2: error: unannotated fall-through
>   between switch labels [-Werror,-Wimplicit-fallthrough]
>         default:
>         ^
> The case above the default does not have a break.
> So add one.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>

I took Zong's version:

https://patchwork.kernel.org/project/linux-wireless/patch/20220408001353.17188-2-pkshih@realtek.com/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220407175349.3053362-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

