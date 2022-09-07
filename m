Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225335AFE65
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiIGICi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiIGICF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:02:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750C1AA37A;
        Wed,  7 Sep 2022 01:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C480615B0;
        Wed,  7 Sep 2022 08:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA85C433D7;
        Wed,  7 Sep 2022 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537712;
        bh=M72LimJubYG55D07kyPiSwEOdkaTR+QpalmclsdUG9w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=u8FYGjKK/yERsqYw5DaNvvMKsVl08Eu7qAXT0tgGhHjYRsO0oQPuKWHLZOquO48Iv
         2/DRPsYXc+zXFB98L8LnMxOxecdkgOTosiHBBWTYWJsok8OKG21UIzLS+Xug2xSfzs
         2zb/et2joRPQ+fP8JN7QGGGkn+eEHXzevQ8h+dhD6Dz1qR2ZWK4/4ani6LDaqaDiiK
         NSw5+RXNPgz8X53sPBEi7+zTgYOPolc5rJwzpYfky9b8r6mAsLqRcdVAYMrEoMFxRG
         V8y7G8m+tihcAB12xKyKhwrZOJfM9D/GUs2jG4ugoKXX1eU9ctGI2xRkVuSrIbwGec
         v012PcG9JqkRA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 linux-next] wifi: brcmfmac: remove redundant variable
 err
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220831132254.303697-1-cui.jinpeng2@zte.com.cn>
References: <20220831132254.303697-1-cui.jinpeng2@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        johannes.berg@intel.com, alsi@bang-olufsen.dk,
        loic.poulain@linaro.org, quic_vjakkam@quicinc.com,
        cui.jinpeng2@zte.com.cn, smoch@web.de, hdegoede@redhat.com,
        prestwoj@gmail.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253770653.23292.6858653088795782018.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 08:01:48 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> Return value from brcmf_fil_iovar_data_set() and
> brcmf_config_ap_mgmt_ie() directly instead of
> taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Patch applied to wireless-next.git, thanks.

e56a770883b2 wifi: brcmfmac: remove redundant variable err

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220831132254.303697-1-cui.jinpeng2@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

