Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD035F3A3D
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJDAAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiJDAAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D6512772;
        Mon,  3 Oct 2022 17:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DBBA6121F;
        Tue,  4 Oct 2022 00:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80038C43144;
        Tue,  4 Oct 2022 00:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664841615;
        bh=B6OCM0F6dUjed/jy6I4UZsIJrf70/6IhDd1fzHasx70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KNmGEqiro3NwxMSMzOyTx+p8Ht4vHNrmJN/uqa+ZWtYdon8dY1nQc9uF97Z8oHJpY
         FfWVejIldxJUPaZaf6ttw0bAA/QLM3UX1MPDGh0g9tHNbZV1I8FGGN1AnO412KFMHS
         zPDIkIbgejAyLCktCK7+R5BpnHKLmy4cy1zZa21TXA1eV3HURGU4XGVKI4kC8/P/t1
         RxVMbydKVptQl3LJtDIE3BVkNRjpzbQmDCDKp30vbYcEOCd4ZS3ETYwBeqwVWmAjiU
         ZLTLa1e7dEyvvYihmrY+0MFRr1otmPc969Nvnl5cYdds5jxXe2VMFRyj9I1+jruoRP
         hqzN9Mn/7hJPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69862E4D03C;
        Tue,  4 Oct 2022 00:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: update copyrights
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484161542.2431.10618262756641872172.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 00:00:15 +0000
References: <20220930224549.3503434-1-elder@linaro.org>
In-Reply-To: <20220930224549.3503434-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 30 Sep 2022 17:45:49 -0500 you wrote:
> Some source files state copyright dates that are earlier than the
> last modification of the file.  Change the copyright year to 2022 in
> all such cases.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi.c           | 2 +-
>  drivers/net/ipa/gsi.h           | 2 +-
>  drivers/net/ipa/gsi_private.h   | 2 +-
>  drivers/net/ipa/gsi_reg.h       | 2 +-
>  drivers/net/ipa/gsi_trans.c     | 2 +-
>  drivers/net/ipa/gsi_trans.h     | 2 +-
>  drivers/net/ipa/ipa.h           | 2 +-
>  drivers/net/ipa/ipa_cmd.c       | 2 +-
>  drivers/net/ipa/ipa_cmd.h       | 2 +-
>  drivers/net/ipa/ipa_data.h      | 2 +-
>  drivers/net/ipa/ipa_endpoint.c  | 2 +-
>  drivers/net/ipa/ipa_endpoint.h  | 2 +-
>  drivers/net/ipa/ipa_interrupt.c | 2 +-
>  drivers/net/ipa/ipa_interrupt.h | 2 +-
>  drivers/net/ipa/ipa_main.c      | 2 +-
>  drivers/net/ipa/ipa_mem.c       | 2 +-
>  drivers/net/ipa/ipa_modem.c     | 2 +-
>  drivers/net/ipa/ipa_modem.h     | 2 +-
>  drivers/net/ipa/ipa_power.c     | 2 +-
>  drivers/net/ipa/ipa_power.h     | 2 +-
>  drivers/net/ipa/ipa_qmi.c       | 2 +-
>  drivers/net/ipa/ipa_qmi.h       | 2 +-
>  drivers/net/ipa/ipa_qmi_msg.c   | 2 +-
>  drivers/net/ipa/ipa_qmi_msg.h   | 2 +-
>  drivers/net/ipa/ipa_reg.c       | 2 +-
>  drivers/net/ipa/ipa_reg.h       | 2 +-
>  drivers/net/ipa/ipa_resource.c  | 2 +-
>  drivers/net/ipa/ipa_smp2p.c     | 2 +-
>  drivers/net/ipa/ipa_smp2p.h     | 2 +-
>  drivers/net/ipa/ipa_sysfs.c     | 2 +-
>  drivers/net/ipa/ipa_sysfs.h     | 2 +-
>  drivers/net/ipa/ipa_table.c     | 2 +-
>  drivers/net/ipa/ipa_table.h     | 2 +-
>  drivers/net/ipa/ipa_uc.c        | 2 +-
>  drivers/net/ipa/ipa_uc.h        | 2 +-
>  drivers/net/ipa/ipa_version.h   | 2 +-
>  36 files changed, 36 insertions(+), 36 deletions(-)

Here is the summary with links:
  - [net-next] net: ipa: update copyrights
    https://git.kernel.org/netdev/net-next/c/a4388da51ad5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


