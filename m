Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B1758580A
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 04:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiG3CjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 22:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiG3CjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 22:39:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BBE326E8;
        Fri, 29 Jul 2022 19:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B1B2CE2C68;
        Sat, 30 Jul 2022 02:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F61AC433D6;
        Sat, 30 Jul 2022 02:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659148739;
        bh=jC4oRprx1TKs7W+r2M7fjYgSP5Y7zb8tHOZjDPUfBDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jHECg2Suwr3BHPLithsIfgAJ7KS5lNxPLQJKzYvUFddEj1ot6U6tDG/vtbKziFTl5
         6T1ovO9by8Do7IxUK9Fn8FaqCimFcC/Ld+OnjcvYlSLjK6/aOmOISLeaGz8M1JmZF1
         Mb4ZnqEPH6kg7DTUxyaRGK0fhqw1QMBEjSlhkIPPdq0xU8i9WanvI/Mf9QC9Bdby3h
         h7EjrvRWl4M4t9Sog3A49LMpC5cWzlBDcS/u8D70dZ1aWRvrHgFzeOyNgPs5KOwHs1
         Rwn6IBsis94b00Y2A/mQYfFojMej3AtUAgy7zTfv/FG817eci9/TzSdnlFH0lT5oC5
         wBtj3Woe7mkjw==
Date:   Fri, 29 Jul 2022 19:38:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-07-29
Message-ID: <20220729193858.664c59f4@kernel.org>
In-Reply-To: <20220729192832.A5011C433D6@smtp.kernel.org>
References: <20220729192832.A5011C433D6@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jul 2022 19:28:32 +0000 (UTC) Kalle Valo wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.

Sparse complains about this spurious inline:

+++ b/drivers/net/wireless/microchip/wilc1000/hif.h
@@ -206,13 +206,14 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
 void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
                                struct cfg80211_crypto_settings *crypto);
 int wilc_set_default_mgmt_key_index(struct wilc_vif *vif, u8 index);
+inline void wilc_handle_disconnect(struct wilc_vif *vif);

drivers/net/wireless/microchip/wilc1000/hif.h:218:35: error: marked inline, but without a definition
