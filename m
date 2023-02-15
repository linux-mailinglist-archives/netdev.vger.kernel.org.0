Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0CC698745
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjBOVUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjBOVUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:20:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4396226879;
        Wed, 15 Feb 2023 13:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D11C461C40;
        Wed, 15 Feb 2023 21:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 300ACC433A0;
        Wed, 15 Feb 2023 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676496020;
        bh=XLI3+MkI4Fb5n5qhwX0Y7+IOf0TYe32DqmDGxmr7L78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fpv1c46bC7D/JDlgR8AIKkJmw6NkHwJzdJccN3Hoiifo8DmStHnTryPtTuaTj46Uj
         DNTWW/AV/96ZNAsYQVdB0vvPjP6P+lb+tUzz/5TUwxlD219tIazabvqGknxNLc/km0
         DjoTDRV6QjwFgilW/SFk3Es7SvZ9GbK71JBHLsMolTBT/92Fu78UpglGUbtkE2bNHr
         qzKwNCm+7tPmcDQboXqxXHW0APR5KM2j8qB0/fTAphVoVeeHu5/5VDDAmsn0R+Nx7o
         4iGZXr4kjzOF/fVnmpVERTUIvdDT4dSVBFa0Jk/rCFgqDkvFpmMi6Ung8G5bSnPzQX
         G4NlCaB8BP2CA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11644E270C2;
        Wed, 15 Feb 2023 21:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167649602006.21327.2804578434988521190.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 21:20:20 +0000
References: <20230213120926.8166-1-francesco@dolcini.it>
In-Reply-To: <20230213120926.8166-1-francesco@dolcini.it>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, luiz.dentz@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        francesco.dolcini@toradex.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        johan.hedberg@gmail.com, s.hauer@pengutronix.de,
        shawnguo@kernel.org, kernel@pengutronix.de, festevam@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 13 Feb 2023 13:09:21 +0100 you wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> support for changing the baud rate. The command to change the baud rate is
> taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> interfaces) from NXP.
> 
> [...]

Here is the summary with links:
  - [v3,1/5] dt-bindings: bluetooth: marvell: add 88W8997
    https://git.kernel.org/bluetooth/bluetooth-next/c/f48823aa0c4f
  - [v3,2/5] dt-bindings: bluetooth: marvell: add max-speed property
    https://git.kernel.org/bluetooth/bluetooth-next/c/d7303dce9fcb
  - [v3,3/5] Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
    https://git.kernel.org/bluetooth/bluetooth-next/c/e275614465ec
  - [v3,4/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
    https://git.kernel.org/bluetooth/bluetooth-next/c/58c6156a4d4b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


