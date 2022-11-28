Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE24563AA36
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiK1N5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbiK1N4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:56:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DA2209B7;
        Mon, 28 Nov 2022 05:56:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90B2561194;
        Mon, 28 Nov 2022 13:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DC4C433D6;
        Mon, 28 Nov 2022 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669643802;
        bh=Vn72y+Uf4zhMuyCFO7GqK4vlRa1VsO5swAZK1L334vs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qdWaCVGG3fmU4aNMlK1WJAZH2c/XCLgy9esZJPEzoj1fqMIAozIEs9lsa+5r4tzWV
         psEAlJXhsQXYKpn5wwouOJu1ubitl0ZdDsf7rXhz7ZIEFRcJo72H1Us2bXA2DWcIW3
         unuvavFZJyRL+kseMiBdMNAPxfjEHzur9VsIDkKofScY/qBSMrhbmzl4KiMbHcCi3Y
         l+iYkMVyQSh0Oq/T3KnCMocOZAtZUM9nWuNKvZpniNuYxMuOfPFG0jeoJoYr+4Vsk+
         UvupilbC7x2r6DbfEEShwhqkOuLoD7czNYbQxGhE85doD9HXZ3DeIeTNPSG2+lOCYA
         hvX1d1TwFJKjQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] wifi: plfxlc: fix potential memory leak in
 __lf_x_usb_enable_rx()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221119051900.1192401-1-william.xuanziyang@huawei.com>
References: <20221119051900.1192401-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <srini.raju@purelifi.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166964379732.4701.17323833019999253439.kvalo@kernel.org>
Date:   Mon, 28 Nov 2022 13:56:39 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ziyang Xuan <william.xuanziyang@huawei.com> wrote:

> urbs does not be freed in exception paths in __lf_x_usb_enable_rx().
> That will trigger memory leak. To fix it, add kfree() for urbs within
> "error" label. Compile tested only.
> 
> Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Patch applied to wireless-next.git, thanks.

895b3b06efc2 wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221119051900.1192401-1-william.xuanziyang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

