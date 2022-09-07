Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB4F5AFD82
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiIGH3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIGH3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:29:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87F9255BD;
        Wed,  7 Sep 2022 00:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56323B81B89;
        Wed,  7 Sep 2022 07:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25219C433B5;
        Wed,  7 Sep 2022 07:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662535748;
        bh=MAKhOisrj5H/XxMjCHU1vIPYaY3C42nvmmE4fodHQbE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MrzpHAU3adhwuJTn3wfPTK9TmDWoZEcluaDPaExZTU0UEiWcQTvEGbTTHgH4+W44X
         XyTkvuvbOy9i9NB2kul67+W/tPCMcoRM9hxBezch/r4qOdCle3uCikI5ydCDAgXE35
         uqzDUCIx36pJVd9YZ603pEIqqnifsdoL2C4E53+x0ODBDXgN0fOwcmEdkacVRsjd4T
         2khVKU8f1pAnVHnjEgOlC1F9reFzSmP8/W4qVh5VAxWypZcX3i32c73xp18lOKbonq
         jQRmkGAgUBiTJ1TTaTEVkodj5QnuFg7nbVFSMdIl3/fK/xoowahxTOFhAMjVAZM3MV
         a3E+/SgFpba7g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: brcmfmac: add error code in
 brcmf_notify_sched_scan_results()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220829111256.21923-1-liqiong@nfschina.com>
References: <20220829111256.21923-1-liqiong@nfschina.com>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
        Li Qiong <liqiong@nfschina.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253574027.23292.7635371064073371162.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 07:29:04 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Qiong <liqiong@nfschina.com> wrote:

> The err code is 0 at the first two "out_err" paths, add error code
> '-EINVAL' for these error paths.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>

Arend already commented v1:

https://lore.kernel.org/netdev/a054ffb1-527b-836c-f43e-9f76058cc9ed@gmail.com/

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220829111256.21923-1-liqiong@nfschina.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

