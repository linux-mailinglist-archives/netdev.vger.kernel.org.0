Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363755164D8
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 16:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347845AbiEAPDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 11:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiEAPDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 11:03:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F39865D3F;
        Sun,  1 May 2022 07:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF54B80DCC;
        Sun,  1 May 2022 14:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B166C385A9;
        Sun,  1 May 2022 14:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651417186;
        bh=0Srov6pC2BZ2FIszQPGiVgnDWQGcaMRoriPIrSjons0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EU9h5rchfb0wJ5DRjwt03QPD/0WDbZZLBbjKoEwc1fZDOavi03lNIlM4/DqSHjrkB
         pK5XcE9mDQYwJjf2m9NPd8x6EL9x1hRSQuLZYPTPGlM2NPNRsJYjB4wix2iDsMdgJU
         gUSutiQ4QIW0LIA4Vc6Gs7+6wPRfO8hbaaa7dvYerBG/UPE3HUtTvevGEe+O0K0WcA
         xfTzti1xAxtpTUsmoZYjuQ7u6x8D3tOhhWddp7Y6U+VaK07ms+5GBdCytE7/RdgEuT
         WARim8w8/gTboJNmxhbztIgY4ViA2tJ7eYAbbY8i5eVHq1QJQcKoTmv+9H87sJYRZU
         O91YPXZOxUgmw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: plfxlc: Remove unused include <linux/version.h>
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220429075459.72029-1-jiapeng.chong@linux.alibaba.com>
References: <20220429075459.72029-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     srini.raju@purelifi.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165141717916.7016.4975023063201935235.kvalo@kernel.org>
Date:   Sun,  1 May 2022 14:59:44 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> Eliminate the follow versioncheck warning:
> 
> ./drivers/net/wireless/purelifi/plfxlc/usb.c: 20 linux/version.h not
> needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Patch applied to wireless-next.git, thanks.

72a1a2edeb1c plfxlc: Remove unused include <linux/version.h>

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220429075459.72029-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

