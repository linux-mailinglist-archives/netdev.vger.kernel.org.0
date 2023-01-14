Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8AE66ACC6
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjANRCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjANRB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:01:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4CC4ECA
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:01:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37C5D60BD8
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 17:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A090AC433EF;
        Sat, 14 Jan 2023 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673715717;
        bh=nRiD7bZOj3MYgPtgPyty3vnNvwXc5vsGUusc44NhPj4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wn60HyFdTXqvwvQCeNOn6bBQI5WP8SJaSEe0BL/rhaQOOsRr0kBls+x5BPhtGABTW
         YKfJyz2AI/ncANFRuS0E6zkoXzVA7rsXAXQx6DRgyZWY1+j8oOvzTFlXivXIs+11VJ
         29ynFM2i72emFE1RyOMqajESlesCUC5PtN9GdyJH4NRy+ikVMg9WLTDUFnS2uwfjqW
         vOCmJeKhfVLOdhxDTd5xkTp5CAOK79wuF/8FwS0TW/Fo854RVMWqa19E4NTMVZXdL4
         P/8wBpqBOngZceKbSnogMxMBnX41IEAH7GVlRm94Qr4scjJA0HdcRnHAaaVbCSonrS
         VnINX9f0xw93Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81016E21EE0;
        Sat, 14 Jan 2023 17:01:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 iproute2 00/11] SPDX cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167371571751.23476.13414787521832179174.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 17:01:57 +0000
References: <20230111185227.69093-1-stephen@networkplumber.org>
In-Reply-To: <20230111185227.69093-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 11 Jan 2023 10:52:16 -0800 you wrote:
> Cleanout the GPL boiler plate in iproute.
> Better to use modern SPDX to document the license
> rather than copy/paste same text in multiple places.
> 
> There is no change in licensing here, and none is planned.
> 
> v2 rebase and found some more missing SPDX places
> 
> [...]

Here is the summary with links:
  - [v2,iproute2,01/11] bridge: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=9458a2c1f568
  - [v2,iproute2,02/11] genl: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8aa217546e9e
  - [v2,iproute2,03/11] lib: replace GPL boilerplate with SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=9e7e786ae49a
  - [v2,iproute2,04/11] devlink: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=18a13ec516a3
  - [v2,iproute2,05/11] ip: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=c37d21944bca
  - [v2,iproute2,06/11] testsuite: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2a5fb175fa01
  - [v2,iproute2,07/11] tipc: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d2c5676eec06
  - [v2,iproute2,08/11] tc: replace GPL-BSD boilerplate in codel and fq
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=01bdedff993b
  - [v2,iproute2,09/11] tc: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=b3a091d10004
  - [v2,iproute2,10/11] misc: use SPDX
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=6af63cc73287
  - [v2,iproute2,11/11] netem: add SPDX license header
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=07b65f312f59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


