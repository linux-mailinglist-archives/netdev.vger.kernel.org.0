Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3DF514491
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 10:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356017AbiD2IrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356028AbiD2IrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 04:47:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82374C400C;
        Fri, 29 Apr 2022 01:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D371B83303;
        Fri, 29 Apr 2022 08:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42C4C385B1;
        Fri, 29 Apr 2022 08:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651221812;
        bh=VoXyvQSTeBg8qTamiUL7QDqnfvP7lgfDXgBXw/8qiV4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=An7/ebAIzdo9wxz4L0DSyXEnYJ0Z8WBcOyHEoMcOszxCdAnQictJWe6zKvWP/j+o2
         RRIxAKLXBTlTl7t1FFzkVaiaiWEJzyUdkT36te9IMabrIzM2X+4IpY/eknMezL4XFx
         by4Am/uFENwIWZ4+gU4ZQDZSoe7tLdPkMt1ka28r7kpvJjVAC3FFoBsyR3fodxAidj
         m5nAMwZcQMZL9oLLX+XBnj8BYY4BfQdgnJiKbJm2Mf5AMe4nkpAudDveu3luPB2vyV
         McjbE+04DEGROFbW5g4dEAoiIyNKlJRCWmvyq1z1dK5FUH/FJudSaOR+Cqra+xCdPl
         IonU6UpHFAH9g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     srini.raju@purelifi.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] wireless: Remove unused including <linux/version.h>
References: <20220429075459.72029-1-jiapeng.chong@linux.alibaba.com>
Date:   Fri, 29 Apr 2022 11:43:26 +0300
In-Reply-To: <20220429075459.72029-1-jiapeng.chong@linux.alibaba.com> (Jiapeng
        Chong's message of "Fri, 29 Apr 2022 15:54:59 +0800")
Message-ID: <87tuace0up.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> writes:

> Eliminate the follow versioncheck warning:
>
> ./drivers/net/wireless/purelifi/plfxlc/usb.c: 20 linux/version.h not
> needed.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/wireless/purelifi/plfxlc/usb.c | 1 -
>  1 file changed, 1 deletion(-)

The title should be:

plfxlc: Remove unused including <linux/version.h>

I can fix that during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
