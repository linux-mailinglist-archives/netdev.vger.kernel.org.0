Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B735AFD2D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiIGHMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIGHLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:11:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4FDA3D09;
        Wed,  7 Sep 2022 00:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1374D61589;
        Wed,  7 Sep 2022 07:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D990C433D7;
        Wed,  7 Sep 2022 07:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662534701;
        bh=8bW+ISvEjXQ7whCeJ9Tq8O45emuRmH86uTYdJqFBVOA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Cc2f+QU2Jo/g4EWxcIkIqnWJrFE+ITYHvRzYXExSYsRPvQegN9MKHLQKNTOoP0Vzx
         xNfyZPY4ZauTYvLaNdqPwpQNJcXexN//wqrD/4FCvxWMKCHpoOs8ljnCMcSjZIK8ls
         vc+XORa7mdI+2sOv3vGlpgCdmycYB8ar8/5hWAyJ++rgHOdxigYy1vkhx4sTRCejcN
         oF7TIxb3OPDMU0T7j6D8bW9Q/LaWoRwcYnX70AmrniifCvIev95BmsYsMKyHLtE2zw
         75R9dR66Y8P0QQBq5X58wMOMS2UCJe7OfDrnDILq4CQDYLbJD75BH+UgqICEaMVnEm
         6J4d4HcTp86gw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: iwlwifi: don't spam logs with NSS>2 messages
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220905172246.105383-1-Jason@zx2c4.com>
References: <20220905172246.105383-1-Jason@zx2c4.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes.berg@intel.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253468596.3736.6006842007998566694.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 07:11:40 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> I get a log line like this every 4 seconds when connected to my AP:
> 
> [15650.221468] iwlwifi 0000:09:00.0: Got NSS = 4 - trimming to 2
> 
> Looking at the code, this seems to be related to a hardware limitation,
> and there's nothing to be done. In an effort to keep my dmesg
> manageable, downgrade this error to "debug" rather than "info".
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Patch applied to wireless.git, thanks.

4d8421f2dd88 wifi: iwlwifi: don't spam logs with NSS>2 messages

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220905172246.105383-1-Jason@zx2c4.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

