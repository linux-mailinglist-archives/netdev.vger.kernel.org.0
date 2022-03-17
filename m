Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0251C4DC898
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbiCQOTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiCQOTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:19:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FCF118F78;
        Thu, 17 Mar 2022 07:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E76D9B81EB7;
        Thu, 17 Mar 2022 14:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9559C340E9;
        Thu, 17 Mar 2022 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647526667;
        bh=gMjWfzI/ebAXBs+J+heckAQ3cGegE1gnKUCPGJjbtoo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QPUfYyu275f0pCV8humpvsTLjqN9gTMLbNiVFHMsx1gWM7oa3jnVrXu3LRhc9Glvc
         1jQWU0+e5WdYWPUkPK5ZUqujkHJEsSNyMmkRcP0fY+SSHgTEwoWvvdgc2/wI4bATJn
         VcHtT601+PLvxIU1VID3IgqlMWauOBXOi47NjTZX3EIw8987g2vItaOLIwWUcyvcpD
         gPY5wW1ZeRcZ5YNLgwotW+6ZPTs74rJpRA7OB6tRjFWB+V0l8L+8IT4+MVCVBeA6ro
         pKTrvQuSGtj1awiqmlh3pPARk0zdwwgw+FZvEo+HTINUUY0sCWlV1+doWMgDPywvdz
         xRxDs8Yiy6SQQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw89: Fix spelling mistake "Mis-Match" -> "Mismatch"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220316234242.55515-1-colin.i.king@gmail.com>
References: <20220316234242.55515-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164752666358.16149.10285910465540787141.kvalo@kernel.org>
Date:   Thu, 17 Mar 2022 14:17:45 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> There are some spelling mistakes in some literal strings. Fix them.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

00f1d133867f rtw89: Fix spelling mistake "Mis-Match" -> "Mismatch"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220316234242.55515-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

