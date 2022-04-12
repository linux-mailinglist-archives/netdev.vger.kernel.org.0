Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8DD4FDC9F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiDLKhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354507AbiDLKdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:33:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7869D5B3FE;
        Tue, 12 Apr 2022 02:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13530617D9;
        Tue, 12 Apr 2022 09:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEF0C385A1;
        Tue, 12 Apr 2022 09:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649756023;
        bh=p2HThk8k2ZTvsydyJhVxe8rGHmh0AkIHBuDz5J5Ldgc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZenysrLZcXIJlDuLAbZuQlXmpAX2KP1jUqlSMLZ1SB24hcPJhaD9rmZlex8NuQZTr
         3BxEbQq8TtqO1axlJXrznslc1pGYNiD+DOYs/CDoporNNUjsHpMWwzNBLnNfZDI4wj
         DutC19Sy5ftlhthoacWgexgX7ui9FcM9W2wTFsp4r6V8W1B+vc2O8EHiumK/5HfMFn
         Fk5aDSTx+2BOS0yVxrrtAp0yRhlH0qI79hrVnI9OAyOQ4SaYqkKYj1pRQe2Tsp45gh
         JOumOgcJBcJ2Rz/dTcpsThTkBTctcLQTAzeBuIcg1eyoL6PRnmEboajhvwAIh5vYl8
         KYrJ6lZFavajw==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] wlcore: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
References: <20220412091742.2533527-1-chi.minghao@zte.com.cn>
Date:   Tue, 12 Apr 2022 12:33:36 +0300
In-Reply-To: <20220412091742.2533527-1-chi.minghao@zte.com.cn> (cgel zte's
        message of "Tue, 12 Apr 2022 09:17:42 +0000")
Message-ID: <8735iiprwv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Please try to make the patch titles unique, you have already submitted a
patch with the same name:

wlcore: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

https://patchwork.kernel.org/project/linux-wireless/patch/20220408081205.2494512-1-chi.minghao@zte.com.cn/

I'll rename this patch to:

wlcore: main: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
