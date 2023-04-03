Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5B26D4603
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjDCNmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjDCNms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:42:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C4F10419;
        Mon,  3 Apr 2023 06:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ACDD61638;
        Mon,  3 Apr 2023 13:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03780C433D2;
        Mon,  3 Apr 2023 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680529366;
        bh=owyom4CpdsC7GEmcYFEc5y8r7LgfED1mw1+NirsoRf0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=D5RNrASxmZ7G3Cn8ml/ukv+Y4dVsKQxdjihXNg7D1nsNfa3wD7s257+KBFagv+6Dq
         q9U+WHYsun/hcLIiN7bkfAyUEWvpy/gldxu3NKZzgvo67lQCs9uqmrBC4UQgiWcvrh
         ifO0VjLej/cGjSQF3Pl0ZxagLSUx6pu8MTyxtpRsMzBhz+X7Aw/Y5mmxLIwR9eTPKP
         n3oavfUVfy8haumlJg6kCFuyzGavuKSNBO48h8IETz+Eh5sATqDzNE8tJlM7C2nBCm
         UM0RoSukVPMzlwqZrMoyj6owrfqZYZbBQddZCnpAg7Z56CxNopVCYW1POBJLV7OnIs
         WTjrrPF4vNDOA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: b43legacy: Remove the unused function prev_slot()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230330021841.67724-1-jiapeng.chong@linux.alibaba.com>
References: <20230330021841.67724-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Larry.Finger@lwfinger.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168052936227.11825.11333120719656159579.kvalo@kernel.org>
Date:   Mon,  3 Apr 2023 13:42:43 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> The function prev_slot is defined in the dma.c file, but not called
> elsewhere, so remove this unused function.
> 
> drivers/net/wireless/broadcom/b43legacy/dma.c:130:19: warning: unused function 'prev_slot'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4642
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-next.git, thanks.

e83ce86aa7d9 wifi: b43legacy: Remove the unused function prev_slot()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230330021841.67724-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

