Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966835BCC0F
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 14:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiISMnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 08:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiISMnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 08:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E824B7FE;
        Mon, 19 Sep 2022 05:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B990B808CF;
        Mon, 19 Sep 2022 12:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF53CC433C1;
        Mon, 19 Sep 2022 12:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663591391;
        bh=Q8fJYO06V+cKawvYJFPow/JzQRmmjcBoh4RWAL+M2uM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Lhv7mMP/n8/YClRKzPQHGZENbEbpbuzBEoX8RWXpdrplVDmuMEzcxFCsNP7beQNY8
         ppEfbuaz0gv29NjP1V7EQGhROuMKchwflydmMR/oT0Q2/y2Bo1hzfH4WHjR2J2LL8V
         NBnODN/AcnvdX3G/o1HlLQxJqw2ryrGRLTKO9IMH5W0nEX8nl66rIt7vjtH51EJE2A
         LKT0Cqpvb2m4Uy3cwV0dgmuwqvRd1UOvsQx9RxDeCWgU4SN/5pi+g7EyOT5675Q+7t
         VfAStrt49tlXPrNlAEgzQK+26SrlZGxJC1i0QPthrMiaxB8VKbulwKk22XQ9syp+3z
         abdaUso0EARAQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wcn36xx: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220915030428.38510-1-yuanjilin@cdjrlc.com>
References: <20220915030428.38510-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166359138667.17652.14752203668170556958.kvalo@kernel.org>
Date:   Mon, 19 Sep 2022 12:43:08 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'that'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

be327016a313 wifi: wcn36xx: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220915030428.38510-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

