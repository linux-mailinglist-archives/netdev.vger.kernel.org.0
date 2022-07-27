Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B21458270E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiG0Mvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiG0Mvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:51:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9651571F;
        Wed, 27 Jul 2022 05:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F496CE2277;
        Wed, 27 Jul 2022 12:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D91C433C1;
        Wed, 27 Jul 2022 12:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926301;
        bh=s5kMgiBwQskmWHY4pql5p3R8coIW7YD8Cs3HUXJ0iq4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qJchCg2QeN9VxMVvNDG0+IBB5ocdDk7G2LJYgk3TUueWQ4ecKFNbRI4JzK8gsyWq7
         jQCAGKleDMdxBUnCYjbsOmWqtPfEPNuDpekAJw8gX9BthrYd0eYTi+Hvf2JdPRUjx8
         6D/YXjot4X92L31o5NMBV5e07LPFQBSlMwuFhPKDmh6Z0GBDwMBjdc2xih48aIrxg/
         rRQ92a5lBjYX6zfi2YUzhIJ/zmw5Jo3yfVy1KnKhPHgOXqQCJDQJ+TKAAgzbhKqDZX
         3pPhw4KOoxLXhlgiDKxtgrdhcuUe5OmC5epck3ctJn843j9tRgcG+P6ao0BA4GxYRa
         ru38Ch09GbkJg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rsi: remove redundant pointer bss
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220622113402.16969-1-colin.i.king@gmail.com>
References: <20220622113402.16969-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892629292.11639.18092056778220420918.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:51:39 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> The pointer bss is being assigned a value that is never read, the
> pointer is redundant and can be removed.
> 
> Cleans up clang scan-build warning:
> drivers/net/wireless/rsi/rsi_91x_hal.c:362:2: warning: Value stored
> to 'bss' is never read [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Already fixed in: https://git.kernel.org/netdev/net-next/c/9dd9495d560a

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220622113402.16969-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

