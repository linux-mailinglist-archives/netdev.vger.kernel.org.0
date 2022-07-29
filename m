Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810855850DD
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbiG2NY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiG2NY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49856248C;
        Fri, 29 Jul 2022 06:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BEBFB826F5;
        Fri, 29 Jul 2022 13:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED014C433D7;
        Fri, 29 Jul 2022 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659101095;
        bh=ab6U8k5VzA1N93q7e14xfEP3XV3xMPYq2x/un0XhcVY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jag+p/M1rAr9jsSIbl5zFufcaUMupqfqF9hQFNLZynHPNIBQQfzoRV4JYboO1SWr5
         ZZ/TggktqoJOqsXdTaWzQqSNrGIIMlzSwcZaCtnbwZJ8l+I1kOSDN2CMWP8/crtgsW
         Lu8YWpevp/2i2rpNBgkL1xs8lDkYFYWsE7sKZieYbefKVdHJqL04iWhE+nX2mnPeYz
         Sp5uWsDPqUDu/9HRfu+2zc7dWw6iXoqNwpCORFHZReKKD7rvFVRZDTf9hVKq8sBgfq
         3wvi0JLPTcLc2I+jbXgK5PlObMzrXA3hwUb9lj0vrH3b+O/rrDTYpEuxipg2b/Znkn
         +Atohc161slNw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/4] wcn36xx: Rename clunky firmware feature bit enum
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220727161655.2286867-2-bryan.odonoghue@linaro.org>
References: <20220727161655.2286867-2-bryan.odonoghue@linaro.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bryan.odonoghue@linaro.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165910108848.7985.3358974290537883596.kvalo@kernel.org>
Date:   Fri, 29 Jul 2022 13:24:52 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> wrote:

> The enum name "place_holder_in_cap_bitmap" is self descriptively asking to
> be changed to something else.
> 
> Rename place_holder_in_cap_bitmap to wcn36xx_firmware_feat_caps so that the
> contents and intent of the enum is obvious.
> 
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

4 patches applied to ath-next branch of ath.git, thanks.

5b7fc772e657 wifi: wcn36xx: Rename clunky firmware feature bit enum
37de943d0153 wifi: wcn36xx: Move firmware feature bit storage to dedicated firmware.c file
75072b2970a8 wifi: wcn36xx: Move capability bitmap to string translation function to firmware.c
5cc8cc4406ed wifi: wcn36xx: Add debugfs entry to read firmware feature strings

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220727161655.2286867-2-bryan.odonoghue@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

