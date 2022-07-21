Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14AD57CCA3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiGUNuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiGUNu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:50:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45307F58F;
        Thu, 21 Jul 2022 06:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1B80B8251F;
        Thu, 21 Jul 2022 13:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 637EFC341C6;
        Thu, 21 Jul 2022 13:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658411413;
        bh=DwHS4x4VdAzK7fYgjOzKqAO/8GHishU3PbAMBk3Oi24=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S2LESK03Frxv6vOQFnzJXklhNnhqYnf+jkZFf9M/8gKBjM8WWj/P40J3o4B7D8O5I
         1044uJL7KgXD/YQczrzbF5zrxc/Ikejxp4dN0hRylszlEPOe9OKlzmumUYJkL+0umB
         PRUUWx8lDkDzr5h2m3b2nHqU8NKm54smGC3xut3EcA2Cw1TziQJ+cqqEQVP6Myof6A
         s3td5qdMSu/UWuMgbZWDAy78c4pTgAcacXXO6muZFAJn6+3c6vs3oJU6RwFaf1Bfio
         FKi2NiaDQH14Tn7vh0Sw3DhJhrMAcf0MKREThSXiVVj5a8xo0Cp6b+nXkZYUx37od/
         CynkP7MDkR0pA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43915E451BA;
        Thu, 21 Jul 2022 13:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet
 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165841141327.10842.14500268917851858367.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 13:50:13 +0000
References: <20220720060518.541-1-lukasz.spintzyk@synaptics.com>
In-Reply-To: <20220720060518.541-1-lukasz.spintzyk@synaptics.com>
To:     =?utf-8?q?=C5=81ukasz_Spintzyk_=3Clukasz=2Espintzyk=40synaptics=2Ecom=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com,
        Bernice.Chen@synaptics.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 20 Jul 2022 08:05:17 +0200 you wrote:
> From: Dominik Czerwik <dominik.czerwik@synaptics.com>
> 
> This improves performance and stability of
> DL-3xxx/DL-5xxx/DL-6xxx device series.
> 
> Specifically prevents device from temporary network dropouts when
> playing video from the web and network traffic going through is high.
> 
> [...]

Here is the summary with links:
  - [v5,1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices
    https://git.kernel.org/netdev/net-next/c/266c0190aee3
  - [v5,2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
    https://git.kernel.org/netdev/net-next/c/5588d6280270

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


