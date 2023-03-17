Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057986BF6AD
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 00:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCQXvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 19:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjCQXvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 19:51:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3EE3B23E;
        Fri, 17 Mar 2023 16:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5502BB82741;
        Fri, 17 Mar 2023 23:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB6A8C433D2;
        Fri, 17 Mar 2023 23:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679097056;
        bh=WR+tqewczy5kh9G0x5J34eXgDDCY5t9xJhykv7aIXN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ptxVKc0dN/q8hYKuRw3Ps+YJg5t6XwIU6VqruWwjxVhouF71Kc/eeYZ21fCk8Dsk7
         QcVbB6EJPmY0asHTvd7uiPP7LNnHL50Ag34RpRpO0jV3SKCVxtCN7HoFtRTwzNObxd
         D649t4FFcAFzy1rPMsEHsjInuNuBuf2isyWfxs30brJZcIoHGv3nJBPXZkg60jmFQf
         7viIGijL/yij7Imw0csg5gJwKflshfD7mIXP3Wa78rWtm/S5g9pZKB06Amn2n+C8Aw
         E/SyzdqzRPBoWLjrL66URd29BM+cw9u4HYO1fap6iO7rWNdV7BO2tVR1R2PMlVRgMc
         9S3vqVi6mlfOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C744EE66CBF;
        Fri, 17 Mar 2023 23:50:55 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v13 0/4] Add support for NXP bluetooth chipsets
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167909705581.28336.12052092434994272835.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 23:50:55 +0000
References: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
In-Reply-To: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
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

On Thu, 16 Mar 2023 22:52:10 +0530 you wrote:
> This patch adds a driver for NXP bluetooth chipsets.
> 
> The driver is based on H4 protocol, and uses serdev APIs. It supports host
> to chip power save feature, which is signalled by the host by asserting
> break over UART TX lines, to put the chip into sleep state.
> 
> To support this feature, break_ctl has also been added to serdev-tty along
> with a new serdev API serdev_device_break_ctl().
> 
> [...]

Here is the summary with links:
  - [v13,1/4] serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
    https://git.kernel.org/bluetooth/bluetooth-next/c/d227f286d259
  - [v13,2/4] serdev: Add method to assert break signal over tty UART port
    https://git.kernel.org/bluetooth/bluetooth-next/c/5ea260df53c2
  - [v13,3/4] dt-bindings: net: bluetooth: Add NXP bluetooth support
    https://git.kernel.org/bluetooth/bluetooth-next/c/02986ce4a4fe
  - [v13,4/4] Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
    https://git.kernel.org/bluetooth/bluetooth-next/c/3e662aa4453a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


