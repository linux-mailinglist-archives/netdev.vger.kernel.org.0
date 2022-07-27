Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BE8582514
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiG0LDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0LDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:03:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FE712B;
        Wed, 27 Jul 2022 04:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5047DCE2129;
        Wed, 27 Jul 2022 11:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A5AC433D6;
        Wed, 27 Jul 2022 11:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919787;
        bh=kVtK6cEEIUx9djaWlrGOAd/br/S94h7B+jN+ap+guJQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZThkWWho4qterDmPWAGiSavf8g5Q+0iUbKfYE7CCyBpwfDJohTFgcAs8zNYHThnTo
         b/mrPBS9hjFMNQbwCKtxk6EUMM25BsUYVWXf/2Ue1kA8gnzWszNiefr0Zk2ulnjMxA
         u7lDEA5DRYVBX3XFBWUBtPZsSiHq+LUojmO2KR9uUmo9XSDLljc5gxqEc10Dqb/zci
         EkO+L9Gwtcj43wkUe1sTI2YEMlnYoIpJt1l0BMv+VR27U0JMAt+Yp/tPsuGuTkaUQH
         QM33/BiV6YQ7X1eaRvzjB45CV2A86c+Ps5NkOV0uHTr7+Trqlws7dSkMKSgNhJeXZP
         goYhl5Hj6lbWw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: wifi: brcmfmac: sdio: Fix typo in comment
References: <20220618131305.13101-1-wangxiang@cdjrlc.com>
        <165891947499.17998.10174395154988805110.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 14:03:00 +0300
In-Reply-To: <165891947499.17998.10174395154988805110.kvalo@kernel.org> (Kalle
        Valo's message of "Wed, 27 Jul 2022 10:57:56 +0000 (UTC)")
Message-ID: <874jz2lswr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Xiang wangx <wangxiang@cdjrlc.com> wrote:
>
>> Delete the redundant word 'and'.
>> 
>> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
>
> Patch applied to wireless-next.git, thanks.
>
> 3f368ed80201 wifi: mwl8k: use time_after to replace "jiffies > a"

Oh man, my patchwork script doesn't detect if a similar patch has been
already applied and it just silently accepts the patch. That's why mwl8k
is showing here and in other typo fixes.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
