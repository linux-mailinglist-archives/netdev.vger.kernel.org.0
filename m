Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D7B6E5042
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDQSbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjDQSbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECFB44BE;
        Mon, 17 Apr 2023 11:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC65162955;
        Mon, 17 Apr 2023 18:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A289C4339E;
        Mon, 17 Apr 2023 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681756219;
        bh=/rsQ6J2YK2l/l9T0OPWVhKop9ubcsEa3okputK1C9ZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uL3j49uFVTb73DWqFTg0VMZZQ1jrr/MBuB/PJpzlqYbu8h3G3U1Jyc9eCZqH3fXlR
         D1niHCqD2mdxhWATAg3z8QSbfrxUBG1wxUai9AhJeE10bpD+YsQQbBzP3uJPYoSvXT
         XOvakt+sZhMYtt+xlGSQXRDJYEU4OqefT26aiCe9WiWuXBPKPwZ8hYj3avqblnjg4I
         /XIRZH64goXtvYQ3FA+9+BCBhQrHMP6FGzt9sQn25bC+WgWEN82nriurZdpQINsKNi
         y7BADHC63GwTF/XSoapbhk4qEkBiJeLyiEPFiIqdSZfafx7NeNU2K3Qsjcc5Ao31Jp
         rBbc/gRHwc7vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55254E330AB;
        Mon, 17 Apr 2023 18:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Bluetooth: Devcoredump: Fix storing u32 without specifying
 byte order issue
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168175621934.2755.15515767143213123834.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 18:30:19 +0000
References: <1681724399-28292-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1681724399-28292-1-git-send-email-quic_zijuhu@quicinc.com>
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        abhishekpandit@chromium.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 17 Apr 2023 17:39:59 +0800 you wrote:
> API hci_devcd_init() stores its u32 type parameter @dump_size into
> skb, but it does not specify which byte order is used to store the
> integer, let us take little endian to store and parse the integer.
> 
> Fixes: f5cc609d09d4 ("Bluetooth: Add support for hci devcoredump")
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> 
> [...]

Here is the summary with links:
  - [v2] Bluetooth: Devcoredump: Fix storing u32 without specifying byte order issue
    https://git.kernel.org/bluetooth/bluetooth-next/c/61cad9af36db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


