Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D68551540
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbiFTKFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbiFTKFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146F5644B;
        Mon, 20 Jun 2022 03:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B48F9B80FBD;
        Mon, 20 Jun 2022 10:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21864C3411C;
        Mon, 20 Jun 2022 10:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655719527;
        bh=cPppPj+Qhf181z6CBrZBE6BDGsgeUJNsxSiGQa1KC24=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U+YrHMbKQMJy3tJioHB7BRcAXR/K61tcmlntOAe02gGJMC8EozyoxhQXbvD/a5KfQ
         v6Su+0Q2PfTF92+uV+7bTT3gcGXCFZ5oq+4wid7UnCZZVVx6rmc9NczDV4lwrN3I8n
         UwybRBOAvY3o4l6nSp7T6VUN8+SAmT+vYeF8PWXI5dOEauQRTYu+kJ81pPiLSK0V6C
         MW+b9deSMewjWyxcJCq5ySQEd73kPlpjvKOFkIHhIaRfHhKsjb76CQREiJXkUBsTya
         gazlexNMVi/24tLFIhPZzI8S4LXU6TVt+JYa/NiBl7TbCG0vV2m8dgauLbNPrbut+S
         vHtGmYIHu4nQg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: Fix typo in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220613172818.7491-1-wangxiang@cdjrlc.com>
References: <20220613172818.7491-1-wangxiang@cdjrlc.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, loic.poulain@linaro.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165571952297.24910.11979078139314947223.kvalo@kernel.org>
Date:   Mon, 20 Jun 2022 10:05:24 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiang wangx <wangxiang@cdjrlc.com> wrote:

> Delete the redundant word 'the'.
> 
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d7af63abde74 wcn36xx: Fix typo in comment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220613172818.7491-1-wangxiang@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

