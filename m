Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB3B654C81
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 07:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbiLWGbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 01:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiLWGbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 01:31:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA362C767;
        Thu, 22 Dec 2022 22:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 684BFB81F54;
        Fri, 23 Dec 2022 06:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853A3C433EF;
        Fri, 23 Dec 2022 06:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671777071;
        bh=lr0f3tny8DtczVnRvNqmxVJZKPbWkCMC9EtJBM2ueoI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=riI23Saz64+uxtxD6jYFatyl8edxBnVg8OeJ02JlUDCx7ZfkNx4Pe/hPtVV5s9MPs
         NDkkSgUVFUMrs7uPi96VX79McOpJ/AiseIvo4EkDewOnuqDeyduCHpZI0WNoFmWsLg
         /jrRDlSGvS2UWJSjK4lhC+SPJlFFEVrSXyFMzzIkXnFlmHoAse5RLlo9Vc2OGWB8xM
         wonmgaJ7LCNQ6DktBDC4yFer11Ce4kDw0ybbG3NZ88EdYv1Um2GTX/DHlfSU5inZke
         3XAhgyWXeEAcGa1pUYG9UBhXc2rc9mwjqM2Wg9xWXb51vjgYRGZBc0CeESp8Sa2/8a
         ngKPjcDUPVZdQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>
Subject: Re: [PATCH net-next] wl18xx: use strscpy() to instead of strncpy()
References: <202212231057406402834@zte.com.cn>
Date:   Fri, 23 Dec 2022 08:31:02 +0200
In-Reply-To: <202212231057406402834@zte.com.cn> (yang's message of "Fri, 23
        Dec 2022 10:57:40 +0800 (CST)")
Message-ID: <87y1qyiqc9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<yang.yang29@zte.com.cn> writes:

> From: Xu Panda <xu.panda@zte.com.cn>
>
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL-terminated strings.
>
> Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
> Signed-off-by: Yang Yang <yang.yang29@zte.com>
> ---
>  drivers/net/wireless/ti/wl18xx/main.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Wireless patches go to wireless-next, not net-next. Also always Cc
linux-wireless list, more info in the wiki link below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
