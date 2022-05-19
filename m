Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0C952D78B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbiESPbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240921AbiESPbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2575D18B36;
        Thu, 19 May 2022 08:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3F3161B32;
        Thu, 19 May 2022 15:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA51C385AA;
        Thu, 19 May 2022 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652974257;
        bh=RcFf0b+QIRVZc4ItzJhYv6MFcknZbxIyxsCo6+AeZEw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Q+AGXk2Y4E2gMRbMbpVGS9Tdv7g/rzuT3IG4BmoHoYXuKvfbOsu4cIFyTr/5FE5l/
         IgdGCrz6TiUwXRidBNZjsuYlMaiqdt6m+r0dbed+YIVV/ETTQ2YwqmMOaxSNNaM2Gc
         cEW/fOu1PiUDRRQZ4q7agmqNXk5Vvqqcx8f+hEPJWuPrhZv8oJezykO79PZztrzMfZ
         Fx1xBQT6XEuSoblmE+brKxxb3tE8S06YkSkeaUwcNPXASl0C9u9H/w50XTCM6VdCBM
         PuGJbgWwUVGi2/CEEpFWJ5eLEeiD+uEwwLA+if1ik5+rscPjtu/12iF96QcthOrdjS
         5W11l62fsBY3Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Yongzhi Liu <lyz_cs@pku.edu.cn>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fuyq@stu.pku.edu.cn
Subject: Re: [PATCH v2] iio: vadc: Fix potential dereference of NULL pointer
References: <1652957674-127802-1-git-send-email-lyz_cs@pku.edu.cn>
Date:   Thu, 19 May 2022 18:30:51 +0300
In-Reply-To: <1652957674-127802-1-git-send-email-lyz_cs@pku.edu.cn> (Yongzhi
        Liu's message of "Thu, 19 May 2022 03:54:34 -0700")
Message-ID: <87v8u11qvo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yongzhi Liu <lyz_cs@pku.edu.cn> writes:

> The return value of vadc_get_channel() needs to be checked
> to avoid use of NULL pointer. Fix this by adding the null
> pointer check on prop.
>
> Fixes: 0917de94c ("iio: vadc: Qualcomm SPMI PMIC voltage ADC driver")
>
> Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
> ---
>  drivers/iio/adc/qcom-spmi-vadc.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)

Did you sent this to linux-wireless by mistake?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
