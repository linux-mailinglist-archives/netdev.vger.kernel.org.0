Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF59514213
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354288AbiD2F7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354268AbiD2F7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:59:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB1C6FF74;
        Thu, 28 Apr 2022 22:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 178B1619C2;
        Fri, 29 Apr 2022 05:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B93C385A7;
        Fri, 29 Apr 2022 05:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651211776;
        bh=nLjslqL2g1+g19MOZADoeMFdBpRmEuS3yhHh7jqJpRA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CKQ9PF0Y2rMzZJRREYPMTyKqXwQF2vzm2f8B45S2oy4RGxpgyTcsxy2k90ESeifGo
         ow+9cs1KugaXRQ5iy/ckEAWl9Ko+Qpp2r0JUt9lZHArHAbj4fNOsOVuDQ3kQiCUWFy
         e/UNXMdhInX3hi1BuKlp104bkk5BfV6Y2ZYiypFnLsfZq0kTyTwa1nnmQte+ecShoZ
         7GF+9Bo69OGcs/wFqPI43H81R3iV5dDuQON1ZGy0gDLR67VmA55p0NWWn1fxfOOM0C
         3f241OCOCUfV3kJWtckx0vE55LKhkwBY473c7TxTePE/ehjkNsFLtHnSJMayts0Hu6
         fMPwS/c9rGd4A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] rtw89: remove unneeded semicolon
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220427003142.107916-1-yang.lee@linux.alibaba.com>
References: <20220427003142.107916-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pkshih@realtek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165121177069.27390.3387634506276557316.kvalo@kernel.org>
Date:   Fri, 29 Apr 2022 05:56:14 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Eliminate the following coccicheck warning:
> ./drivers/net/wireless/realtek/rtw89/rtw8852c.c:2556:2-3: Unneeded
> semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

11dc130b4ee0 rtw89: remove unneeded semicolon

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220427003142.107916-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

