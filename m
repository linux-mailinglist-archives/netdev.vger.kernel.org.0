Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2185824FF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiG0K6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbiG0K6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:58:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F9948CB7;
        Wed, 27 Jul 2022 03:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A0E7B82018;
        Wed, 27 Jul 2022 10:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FB5C433B5;
        Wed, 27 Jul 2022 10:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919500;
        bh=xW2P//S98oJ0Zei/Gd9VaS4pLuH4B7R47tjkR+E+Ios=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kHKVGlo5duedaLpFD/U/b6kxASNKgCSUCyzyI/1I2jvtAXQ2zdCtxUJVK61hucx9w
         4KLODd3w+/EvC+qiW986yeI4mP1DEkGcNj0jAIat0JP2UzQOHOIfP5aJJHi7H1JLRc
         5Uqow6S1wouwqYN7ejxiDxsjBUDYZqC0tvcVDsjoq9gDbtGlazluuV7ujtrF7lFqDR
         vKcFs60bJCWFJZxlgrEh2cuRtr8YPMmyPjLXznHSZadf7LWwCce13rWj0176V5OSWU
         e8O91eoWCRSmE0bwrTWXY1vyU14eKs5YXRJ6lLuL1XXEgkWmAMUiKVFBP/vTad7zTh
         OANzKhthRATtw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rsi: Fix comment typo
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220715050016.24164-1-wangborong@cdjrlc.com>
References: <20220715050016.24164-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     siva8118@gmail.com, amitkarwar@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891949522.17998.4505817327328354942.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:58:17 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Wang <wangborong@cdjrlc.com> wrote:

> The double `the' is duplicated in line 799, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

c2ce2145f7f3 wifi: mwl8k: use time_after to replace "jiffies > a"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220715050016.24164-1-wangborong@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

