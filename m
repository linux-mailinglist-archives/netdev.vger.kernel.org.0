Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CFF614835
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiKALHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKALHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:07:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4A719027;
        Tue,  1 Nov 2022 04:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5EE4B81C6E;
        Tue,  1 Nov 2022 11:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BC3C433C1;
        Tue,  1 Nov 2022 11:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667300870;
        bh=DQIRA6FEZkpo5HH+L+soeSfMq90M3xQzxc4Lot0+jd0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N3EZtqTG68jOjfQwQhAUqB75r1hjKRJzprhtVtLSTrG3kCx3I6o37EaXtFFEH2yMr
         eWJi6D9Qo0Z5AN+Qmu+q5LP4Zt5C3MAkiyrvJZx/KCRaXShY1M4p/cr9BCJY4HkZK+
         bE127+MpiTdWUjCbWshlZFLCAMqbonwhAbicu8RpSOsnG4uyMBvGvrDaF/PWysV5Jt
         0/AFSzSPzxGhY7XpGR4sKqDmRZovuBSgnVnUFVDyfN2LvLPE6CLBmMZX3IqNDP0nFa
         j70QDomjKF3MY252I7vdwFuwhzSw5/gCcaFYwe8BQdMnlgvoQLKyFBkTiCno0v2Wjp
         x5iT9cR2/YUHQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wilc1000: sdio: fix module autoloading
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221027171221.491937-1-michael@walle.cc>
References: <20221027171221.491937-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        stable@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166730086353.21401.9805927122982212508.kvalo@kernel.org>
Date:   Tue,  1 Nov 2022 11:07:47 +0000 (UTC)
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Walle <michael@walle.cc> wrote:

> There are no SDIO module aliases included in the driver, therefore,
> module autoloading isn't working. Add the proper MODULE_DEVICE_TABLE().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>

Patch applied to wireless-next.git, thanks.

57d545b5a3d6 wifi: wilc1000: sdio: fix module autoloading

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221027171221.491937-1-michael@walle.cc/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

