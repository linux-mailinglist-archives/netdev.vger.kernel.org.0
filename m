Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54294B96C2
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiBQDkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:40:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiBQDkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:40:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D3D29C134
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EE4061D64
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 03:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA774C340EB;
        Thu, 17 Feb 2022 03:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645069209;
        bh=a8dFgvDv9tH5oKCPVObcSmKYXSdewuT/BdYMZjP78Uc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nTtTzlP8cANu3qcFM6tcdIfK9k0/P1HFDx6wzHdQmzi6a2YL4Ci7kTREIvEPWqQVN
         Eoj/e6SAb18z+BiCNpHDDDJk4YY6q+jEq82O3C7R/INLapixr9EuYWlKbCEVhfEF5k
         YeVaA3G9wiwPw/Xk+nAFyfQbJ8YhmRzBsTPfvq89m4IDMYgfjqCqW9slP2x0Thu+dJ
         et5ilMRts2Gt0GPfCv9qmO4jpQZB567fWQ/81FPlEbKuy8oKrXQ+EPCVcVB+jCaJOF
         lrhQHQx23aOX7AKJ4kbrc161NUQDTlNRBGryHcFR3rtYq8YMdxRoaScnSazWoFEW89
         G0xgdeUVSLTSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1590E7BB07;
        Thu, 17 Feb 2022 03:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] f_flower: fix indentation for enc_key_id and
 u32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164506920965.25556.15861895759081637869.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 03:40:09 +0000
References: <20220210125715.54568-1-wojciech.drewek@intel.com>
In-Reply-To: <20220210125715.54568-1-wojciech.drewek@intel.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 10 Feb 2022 13:57:15 +0100 you wrote:
> Commit b2450e46b7b2 ("flower: fix clang warnings") caused enc_key_id
> and u32 to be printed without indentation. Fix this by printing two
> spaces before calling print_uint_name_value.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: use unsigned int instead of uint in print_uint_indent_name_value
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2] f_flower: fix indentation for enc_key_id and u32
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=4f015972988a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


