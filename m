Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A654BDD37
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380870AbiBUQlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:41:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380905AbiBUQlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:41:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C946A2A704
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 08:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631586130E
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 16:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5071C340EC;
        Mon, 21 Feb 2022 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645461610;
        bh=jKh9emTImFIUYvn8IMIR2ylOVPqzXjysW1MVnN7rv20=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FB0PZGoiXx6zHu+QvWsK/D1C54EEW9vm3SKD1i8YRzSXz12iBl4eZQ4wwD+NvL9GS
         /CgX3miChcFqtQnWd0OsEpK/in7RekMOcex5N1wjxc4QfviJPigISogjupnUphueD3
         ORYKn7u9yN9Vy076JREaV6vsId9SlSrxoNfvd3gvmnyUQiQ9l6n/KypyphRQLMO/8b
         MCde92ce91YbgjL7aq7CX9yYQhy2473vuV8Duza/0IzDsU9pGvGpjSMd3i7aSOB4Tp
         J2i8yYpPVq1ndhFYFgHQd5tNMWi0omDMe1kiktk8YRL8soWYr/QhT6HexHoI8nrb14
         Lig9c++fFoDjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2F67E6D447;
        Mon, 21 Feb 2022 16:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/4] devlink: Remove custom string conversions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164546161066.3907.3775492783576524283.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 16:40:10 +0000
References: <20220217025711.9369-1-dsahern@kernel.org>
In-Reply-To: <20220217025711.9369-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        parav@nvidia.com, jiri@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed, 16 Feb 2022 19:57:07 -0700 you wrote:
> Remove strtouint${N}_t variants in favor of the library functions get_u${N}
> 
> David Ahern (4):
>   devlink: Remove strtouint64_t in favor of get_u64
>   devlink: Remove strtouint32_t in favor of get_u32
>   devlink: Remove strtouint16_t in favor of get_u16
>   devlink: Remove strtouint8_t in favor of get_u8
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/4] devlink: Remove strtouint64_t in favor of get_u64
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=7cb0e24dcfaa
  - [iproute2-next,2/4] devlink: Remove strtouint32_t in favor of get_u32
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=95c03f405183
  - [iproute2-next,3/4] devlink: Remove strtouint16_t in favor of get_u16
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2688abf0c98d
  - [iproute2-next,4/4] devlink: Remove strtouint8_t in favor of get_u8
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=e8fd4d4b8448

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


