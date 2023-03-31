Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3116D232D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjCaOyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbjCaOym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76873F751;
        Fri, 31 Mar 2023 07:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C672A629E3;
        Fri, 31 Mar 2023 14:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8573C433EF;
        Fri, 31 Mar 2023 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680274440;
        bh=wxcb9cD6cEroWCkgzs/6F5+/2yGtnigGqAEymcE8U2k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=m5bzenqHDZAgr8Vg9PoLMVep0OOrYOV3A/sXb/zdbnfTD78fDOZlUdGUHl67PUIip
         UGz00cOPjXgn7i0oE1WVqc768FBxafsyeCu6sC2t+iH+5jt/3kaFnjRdM1YSeUVBu3
         Ifmxd006WiOucm7w9dRFmREQkdzdm/rKorwBQ+1kNkHzuNyCL0bfKygXEgetaMc69P
         qQLsT22vAGCFKteT+Ifgp1t4p68GhI9nrJwYa5Kgc06ZYfvgrt2jjBOTrPbqUOgAo4
         AvT5Lz8erdpgXlMgzX+8BRVIohPKmL/5tnFFuy7vZCgmjMtB3fz+qPknDH5sHsV6x1
         fIzoqOnMb50LA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmsmac: ampdu: remove unused suc_mpdu variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230327151151.1771350-1-trix@redhat.com>
References: <20230327151151.1771350-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027443492.32751.8602974974807880536.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:53:56 +0000 (UTC)
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
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c:848:5: error: variable
>   'suc_mpdu' set but not used [-Werror,-Wunused-but-set-variable]
>         u8 suc_mpdu = 0, tot_mpdu = 0;
>            ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

2f73f04b7f93 wifi: brcmsmac: ampdu: remove unused suc_mpdu variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230327151151.1771350-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

