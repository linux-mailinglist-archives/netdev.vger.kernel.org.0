Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683B56D22E5
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbjCaOqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjCaOq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FA42031B;
        Fri, 31 Mar 2023 07:46:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E6A629C6;
        Fri, 31 Mar 2023 14:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60811C4339B;
        Fri, 31 Mar 2023 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680273979;
        bh=teWUDEWRNjOrCokuMkC7iMtqqgjV3KHiiJPzrW2yqoo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=L457bPwNtr2YNzRK2HvoBzV05ESkOo/S+oq8r9GbEonbmV+2uIl5kFRcm0faje5er
         bEO+2DJ40eK/kQrT8K4WZZdKcQAly0+dXsNqzSEtkfvENLUBtYzuM8vjL1+dwRvR5f
         zGDpkQzyNhkJRaZQOep/X9kwYLjy2KUfyiX4aA0XYkc2r8knZPf1CMPqS8ZkY7aNWi
         SQQatA9A+6x6WB6Tkgw1jeQoVSFwgGRjKOcPwnw82LK5H5e59OQXquKlVm0oAjqRyU
         ypMwXkC31WhlM0C0qigg8ipieLmOOPCHybg/7CZbmPUwdX8AKwq36mnJOTkIvwBHfo
         fkt406DwAcxYw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw88: remove unused rtw_pci_get_tx_desc function
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230320233448.1729899-1-trix@redhat.com>
References: <20230320233448.1729899-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     tony0620emma@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027397456.32751.13158951931785484475.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:46:16 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> clang with W=1 reports
> drivers/net/wireless/realtek/rtw88/pci.c:92:21: error:
>   unused function 'rtw_pci_get_tx_desc' [-Werror,-Wunused-function]
> static inline void *rtw_pci_get_tx_desc(struct rtw_pci_tx_ring *tx_ring, u8 idx)
>                     ^
> This function is not used, so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

c9b6111a6f94 wifi: rtw88: remove unused rtw_pci_get_tx_desc function

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230320233448.1729899-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

