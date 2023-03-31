Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339A16D22FB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjCaOu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjCaOus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084F71FD38;
        Fri, 31 Mar 2023 07:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92D89629C8;
        Fri, 31 Mar 2023 14:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0972C433D2;
        Fri, 31 Mar 2023 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274246;
        bh=x89Ay4WTQ/HoiUnOx6TQ6dSFNV6rvRgDjjP0hgj9Jes=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KTSCHod3Pyd8939Qt4nufqXOOFVaAHT/D1mINOirR/DQ+ZRyvqokO1yjJ2RS6CdMr
         70l2J85ipGr+KaW66BYsZgzsoL8BeFonbiuRhvEuvkcwvmz4gLS/csJKHglkQWwYCX
         keSejGlp920XTA+L2/oFSwodj/jJsG1fuH4/rx4go6DA9li2Q2yDotfAlJC/sbKOij
         Ywbi0MKSjtEpRYZ+/i7HzcHb1p6LnRi7blbNCnKMcV0jbcsyBZ6r+06kU+3wBlt2uO
         VTsZq3VtkssRZozpGhIKMg8mQW3Z1I/pbhKmbaJriuaQ8jW5/Giqr/bqgyYtZd56mT
         jRSQDoe3JwF4Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmsmac: remove unused has_5g variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230325130343.1334209-1-trix@redhat.com>
References: <20230325130343.1334209-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        johannes.berg@intel.com, quic_srirrama@quicinc.com,
        alexander@wetzel-home.de, shaul.triebitz@intel.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027424008.32751.3800989663447592780.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:50:41 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> clang with W=1 reports
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:1051:6: error:
>   variable 'has_5g' set but not used [-Werror,-Wunused-but-set-variable]
>         int has_5g = 0;
>             ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

5aeb763a27c2 wifi: brcmsmac: remove unused has_5g variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230325130343.1334209-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

