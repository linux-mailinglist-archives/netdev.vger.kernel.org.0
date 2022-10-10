Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFF25F9C2F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 11:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiJJJq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 05:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiJJJq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 05:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D63F6566D;
        Mon, 10 Oct 2022 02:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E92BB60EC8;
        Mon, 10 Oct 2022 09:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE61C433D6;
        Mon, 10 Oct 2022 09:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665395184;
        bh=FJra+6/H/yK2ECcF/qdxyMMLN4AXw9SpU4CxqP12U5E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qKhwdOoVUbj4pLXHeBI+Kx1++W9/CgQvXOaNoGJuWvXWWPphzZJY6HyOFZhecJzi9
         Bcs2xOsCZ5umBruPH1eTQT0eoaYWk1ouxTwCjer019qkpwizSslqzAMEFTErkfxgBi
         fQQyRIjlSyQbBAZ0hsbv3aq7/dQZeK8Ip1rU+Ib+7yK6bygQ0CejbizaHzEz9a/JOf
         D2X6jMuMFNj3nTPu3LRcOhUnzmTZA2l5Eh1mo7VzH4h+wbOq3wk6fVcE1se0thyAvY
         U+qZa6EvRAgcjnVUTPhRa4+LngSdg+NivoMTa+4kE48KP6VyVlae2FRGGEIlpPiGPy
         rPqRtOJMqvkXg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: Make arrays prof_prio and channelmap static const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221005155558.320556-1-colin.i.king@gmail.com>
References: <20221005155558.320556-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166539518023.12656.10839315414003633288.kvalo@kernel.org>
Date:   Mon, 10 Oct 2022 09:46:21 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Don't populate the read-only arrays prof_prio and channelmap
> on the stack but instead make them static const. Also makes the
> object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

e161d4b60ae3 wifi: ath9k: Make arrays prof_prio and channelmap static const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221005155558.320556-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

