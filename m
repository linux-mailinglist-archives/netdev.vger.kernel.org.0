Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E5D530316
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345004AbiEVMbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344947AbiEVMbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:31:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFDD1ED;
        Sun, 22 May 2022 05:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05C64B80B34;
        Sun, 22 May 2022 12:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFC8C385AA;
        Sun, 22 May 2022 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653222687;
        bh=7te1wsNhE0iRbZj3vuk69BZJd3L6befe1LzQZxknktE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IQaDO8YN/tOSaAiNflda1/b5tkOFbROyoNuugWDukx9/jPbE1mGyJSRYCCIvEWIbW
         /kkTViCz2kreedHCWl55+DcCHJhujOBW3ul+BLaZqlUmaJ6pP3lZlTVS7XKJX36NZ6
         0rhsbFvyAvPdgXKAlO89y4JMFJpCN+0dU5BnrK99SFLTyhIcFwaGVVweHwScSbrKY6
         4CANEAbAtLEa4E08YjtEFN9pgwXUdePEfW8lV3go8H4k5IkEpd3a/3En6o6AEYwpNF
         AnUDi9rEdXnY+KlKV15kPayrlWm+vF1yTT2PTLU0BGdRpd5eFYoOi/f/TnrjDOQp3K
         tpf0BrVC1dihQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next v2] net: ath9k: replace ternary operator with
 max()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220517024106.77050-1-guozhengkui@vivo.com>
References: <20220517024106.77050-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:QUALCOMM ATHEROS ATH9K
        WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165322268311.774.15307281943439031205.kvalo@kernel.org>
Date:   Sun, 22 May 2022 12:31:24 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guo Zhengkui <guozhengkui@vivo.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/ath/ath9k/dfs.c:249:28-30: WARNING
> opportunity for max()
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

2be8afe05833 ath9k: replace ternary operator with max()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220517024106.77050-1-guozhengkui@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

