Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB16E94B3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjDTMi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjDTMiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:38:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7286E659C;
        Thu, 20 Apr 2023 05:38:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1086A6492B;
        Thu, 20 Apr 2023 12:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEDBC433EF;
        Thu, 20 Apr 2023 12:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681994324;
        bh=nfJH/+e/lzF8OUfdswNN7jypUAc6X6n5NbRH8m2Wyzg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RidI+JGvvBt+q2AnYq9/4G/nYPDXpf/m0Y+F7zVsAm9ue8xpJvzhc1MYZQSWvYeTr
         RMWKANWUCJsJwy6pcOr4v21gDYliVJT6+QXSlIoLzBscO1XLfWbuBAqDyX23S4Hdm5
         e23VG35DyPF9r2GrAXsfd0vAfCnQ7sRhNZ4NrqDjZXbQHBS4+rHv06FdC/eJ8t5Hsj
         93pzlvmeyjtpZBGeQT1IVF0pVeA1rXuZt8Li5xvqEqkoIkzmIE362a0VE4QWSW31M2
         D2E+E/+UEwbRuy+agAqswXBUNrHe472n7t4bQdklEI4QHvEuudIQ/5sXBXz8S6DCae
         GxRayFYgJ4rHQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: airo: remove ISA_DMA_API dependency
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230417205131.1560074-1-arnd@kernel.org>
References: <20230417205131.1560074-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168199432066.31131.2024979256921490085.kvalo@kernel.org>
Date:   Thu, 20 Apr 2023 12:38:42 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> This driver does not actually use the ISA DMA API, it is purely
> PIO based, so remove the dependency.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

09be55585d27 wifi: airo: remove ISA_DMA_API dependency

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230417205131.1560074-1-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

