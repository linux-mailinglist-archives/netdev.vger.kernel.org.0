Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5CD50C7E8
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 09:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiDWHLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 03:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiDWHLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 03:11:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A48E615E;
        Sat, 23 Apr 2022 00:08:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF39BB80022;
        Sat, 23 Apr 2022 07:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679F4C385A5;
        Sat, 23 Apr 2022 07:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650697703;
        bh=OzuUkjBuVQjUbo0lFDTYt59BB3BKVtxNXhEO7jEUugA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DljQjlbilDI7S5tXKmpMQYm4LyBEv1PXofM0HVcfqbF4b/9VBKjlU5gv7lSqjW6vu
         VxLc5iDFtSQ+WYePId29b4BsyDFdeTtsrBQPlvWK2w2LWfcp/CrhXSAsljvnRQ84At
         eEdxxLAA3XLlgE3/68HeXHSA9RLd9f8W0l5c6/n/xfOG7+n9HHaz1NjirzaRooGsUU
         37zvObNTJPwb+HbtNLjp+7FtGnxxvtrcKX8YYMSwhOiv1Zz+aZEbzeIiQgM3ZrQj6R
         zU0VS5ccfZ5oS8zq4nxHy0c/CHzU3IlkNrcEe/OnQqCloiq19PNrkc96rO9LixbJMi
         spasHPpsg1cjw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wlcore: main: use pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220412091742.2533527-1-chi.minghao@zte.com.cn>
References: <20220412091742.2533527-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165069769602.11296.14767168314317407909.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 07:08:21 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Patch applied to wireless-next.git, thanks.

ab589ac24ee1 wlcore: main: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220412091742.2533527-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

