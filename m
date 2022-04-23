Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D2A50CA08
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 14:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbiDWMsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 08:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiDWMsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 08:48:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BC8BEC;
        Sat, 23 Apr 2022 05:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FAE6610AB;
        Sat, 23 Apr 2022 12:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9BCC385A5;
        Sat, 23 Apr 2022 12:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650717957;
        bh=pZgBCGqzSpZFGZFs77ncuwGPCPkctR6rHLCakx1n/V8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DIHIZiZf49Ifa6XOoloc4hVEmHPkSQFStdSjr2xsX1MkJyZQJ3MMSLpQfXEhfH5lc
         OTnpwx5QqiAVgmnh56Y5c/PER/W1Qb1cLgjVwcnWWkdhrg5lfihj+N2NibxYWxKsZF
         BqWZEKJJZdrlCXLtgalEdeWEeSQgVBCgaP54RFwIW5Zgv14Zme/YvUFVpzfVywX8H3
         065NSeosgL/yyYimQkZDmb4AENsMUSRPFYJu63U71E+mSAeW6ASJy7svwmkoxmX0cH
         v88h6wnJBtFI/qG9wiDVqcvNrnYsQpNz9gVlYv7p5VTJ5wj2FTs9a97+hY4ebKtse7
         jSA0awMLbMtYQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wl12xx: use pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220420090214.2588618-1-chi.minghao@zte.com.cn>
References: <20220420090214.2588618-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165071795417.1434.13837411851415220071.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 12:45:55 +0000 (UTC)
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
> Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. This change is just to simplify the code, no
> actual functional changes.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Patch applied to wireless-next.git, thanks.

54d5ecc1710e wl12xx: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220420090214.2588618-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

