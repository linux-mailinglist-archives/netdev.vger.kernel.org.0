Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904305850FD
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbiG2NgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiG2NgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCCD20BDD;
        Fri, 29 Jul 2022 06:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 984BF61F41;
        Fri, 29 Jul 2022 13:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6318C433C1;
        Fri, 29 Jul 2022 13:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659101762;
        bh=qFuiy5RGnMWAsrTSIlSP+Qm37HzZ4t25uoraBaL7fhA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aKRD7FIoJ96Jj4E7GObBJw+FPD1HuLDDafVTxh1cHhj4AwSuyu0fz0yhvsxcXoqs/
         +PyjWVbMurJnZWcWTLLY7zPweqcfaATmiDIusft0kSdPMJtvHXh6ND9hX9huEI9Zmb
         4CZXi104r3nxiCXPE77Y/9LqSfuiU0Netd3kNb7EkuxGosYtYDlMJruXMLxpkRKjuN
         JOPZvO3uv02vHmqCh3zXKtGLQLwtTD1aiPMlQorqIyFsPzyGERYF8Lchx+oGNRWnmp
         s7ENOnEcK1BDJTtijuY151TclJDNPNEjimz+EwzM1vP7zM+EeK6e1/Zm6S+H2tEfr5
         u4mpTi5y/5gdw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtw88: check the return value of alloc_workqueue()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220723063756.2956189-1-williamsukatube@163.com>
References: <20220723063756.2956189-1-williamsukatube@163.com>
To:     williamsukatube@163.com
Cc:     tony0620emma@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165910175801.2014.14758943115910688556.kvalo@kernel.org>
Date:   Fri, 29 Jul 2022 13:35:59 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

williamsukatube@163.com wrote:

> From: William Dean <williamsukatube@gmail.com>
> 
> The function alloc_workqueue() in rtw_core_init() can fail, but
> there is no check of its return value. To fix this bug, its return value
> should be checked with new error handling code.
> 
> Fixes: fe101716c7c9d ("rtw88: replace tx tasklet with work queue")
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: William Dean <williamsukatube@gmail.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

42bbf810e155 wifi: rtw88: check the return value of alloc_workqueue()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220723063756.2956189-1-williamsukatube@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

