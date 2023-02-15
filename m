Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E4F698749
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBOVUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBOVUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:20:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61F3392AA;
        Wed, 15 Feb 2023 13:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ADE1B823D9;
        Wed, 15 Feb 2023 21:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20110C4339C;
        Wed, 15 Feb 2023 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676496020;
        bh=KhznJ5MqsWCGU5jiXt79rHN7OFi4bXjp4btJ5yN1aMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G322UuEEln5uUQOP8JcW+0cqbah88Aqvs8NAHoDBKrjD7hn1AHFLt749Eehj5zZ9X
         sgEzSGGV/xiFYWGlfA2NGsVxRzlptitnbt6/2whR5O7NXP+kzyR5cZDnNFFBT8flBo
         42QStP6rUpCT+h9vt9LAoMn7JL94ITs3Gmuhp2jSy/UOSfSIqHR4SAEkKip79zpPdX
         fJ6OUkgp23Fc6fOuJWPLU6w1mv39qDWxSXTzacuQBTqFatRMmSVOzXAAIiU+12vJY2
         PDfEm9STgiHp5F0sFWWyPBx3V+CZEyaC8/0NRQc9uz7HXcKYBCO9lHvBGd7iYP/lP1
         PtRaKOGQLNrXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07E15C4166F;
        Wed, 15 Feb 2023 21:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167649602001.21327.9252864686596807637.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 21:20:20 +0000
References: <20230126074356.431306-1-francesco@dolcini.it>
In-Reply-To: <20230126074356.431306-1-francesco@dolcini.it>
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

On Thu, 26 Jan 2023 08:43:51 +0100 you wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> support for changing the baud rate. The command to change the baud rate is
> taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> interfaces) from NXP.
> 
> [...]

Here is the summary with links:
  - [v2,1/5] dt-bindings: bluetooth: marvell: add 88W8997
    https://git.kernel.org/bluetooth/bluetooth-next/c/f48823aa0c4f
  - [v2,2/5] dt-bindings: bluetooth: marvell: add max-speed property
    https://git.kernel.org/bluetooth/bluetooth-next/c/d7303dce9fcb
  - [v2,3/5] Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
    https://git.kernel.org/bluetooth/bluetooth-next/c/e275614465ec
  - [v2,4/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
    (no matching commit)
  - [v2,5/5] arm64: dts: imx8mp-verdin: add 88W8997 serdev to uart4
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


