Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3911530310
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344581AbiEVM34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240899AbiEVM3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:29:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF63CA65;
        Sun, 22 May 2022 05:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 074DF60FC9;
        Sun, 22 May 2022 12:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B385AC385AA;
        Sun, 22 May 2022 12:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653222594;
        bh=pQa0Xfjqbbh3fqvKaRXDPRrQF3+yVWTnEMtE0LqO6bo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RLi6vuckQutx3V0a3ySVeCd85K4m+tV7vG3hnhJ9i/JIJhVC8xXu6B5AKpksJW2dh
         mc8+fE00D3z3pecaYVxgahx48PY8juKa0uA21WQ0aENItOn63l4j6aTchI8FvAg6YP
         j3dQXZ7+zgNWy6neF9tYsownHEItAFzaKXvgx9V421oQ4nlAj2xyU+V+Id5zHHx2cp
         KXyIX0We37G/+aPo1XjwEryab8d1BWOSYxVOOpz/7BowK5eNO4fjG/4LI/cdBjLMjS
         M+Meu177PJ+ylUR/+615ZioCHplEKnwwyZVbmI4a10J76oSt0sxfxYfeVWxARKQQTZ
         HKDtB6hZrA6IA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH linux-next v2] net: ath5k: replace ternary operator with
 min()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220517023923.76989-1-guozhengkui@vivo.com>
References: <20220517023923.76989-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:ATHEROS ATH5K WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165322258657.774.8414386492190244747.kvalo@kernel.org>
Date:   Sun, 22 May 2022 12:29:51 +0000 (UTC)
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
> drivers/net/wireless/ath/ath5k/phy.c:3139:62-63: WARNING
> opportunity for min()
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

b380d2056ebb ath5k: replace ternary operator with min()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220517023923.76989-1-guozhengkui@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

