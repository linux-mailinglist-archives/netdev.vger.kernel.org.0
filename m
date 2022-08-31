Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46A65A7C5B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 13:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiHaLnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 07:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHaLnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 07:43:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42F9BA9D8;
        Wed, 31 Aug 2022 04:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B990B82069;
        Wed, 31 Aug 2022 11:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88791C433D6;
        Wed, 31 Aug 2022 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661946196;
        bh=ehCq2Ob3dMV024kvlcrirlxJ9Kh8bhNV8iCQ2RN/mp8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=koVRLrjtfjix/Kl6/n+g0mVzB/hS6PmUvZRgCndJwf8fVWykRzTo0czlmu9awr3pe
         ixd8+r23ZVwmbcJwWNN32BFQN9DwRvtxW1se+ZYTcYXNg+TZZUh+6ALfhqtK0d5DIr
         UIC+/r7rOdUzaZ7J14lZl86uKN0qJLrnKWSjahVag/F3+HoFYftasNqyvuMi2QBE5L
         0jVsMXBzJghWINmQtwGdfvWsrWoIlbZOV4Bl9cHShKHZvmxyCT2nB5Yt4i0rPRbL3Z
         vbO5r3qJ6DPCFXGXHpzoGn7O/X5gP4ng/tl7lrU3vTrUFQNCJlrUzt8vtvR7PBIbN1
         psYXse5Hti3Tw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: add 43439 SDIO ids and initialization
References: <20220827024903.617294-1-marex@denx.de>
Date:   Wed, 31 Aug 2022 14:43:10 +0300
In-Reply-To: <20220827024903.617294-1-marex@denx.de> (Marek Vasut's message of
        "Sat, 27 Aug 2022 04:49:03 +0200")
Message-ID: <874jxsfxkh.fsf@kernel.org>
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

Marek Vasut <marex@denx.de> writes:

> Add HW and SDIO ids for use with the muRata 1YN (Cypress CYW43439).
> Add the firmware mapping structures for the CYW43439 chipset.
> The 43439 needs some things setup similar to the 43430 chipset.
>
> Signed-off-by: Marek Vasut <marex@denx.de>

The title should be:

wifi: brcmfmac: add 43439 SDIO ids and initialization

I can fix that during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
