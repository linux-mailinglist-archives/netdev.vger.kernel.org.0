Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D2A4DB4CC
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbiCPP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiCPP2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:28:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCEE66FB6;
        Wed, 16 Mar 2022 08:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 073BB616D5;
        Wed, 16 Mar 2022 15:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C689C340E9;
        Wed, 16 Mar 2022 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647444437;
        bh=cKHMfEEuQWjkMg9IVsapbzoI/deGhDOqoxo8h1Pfj4w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Jx6/gUnfFvTWYhsjPB8Sysp75pa4maiTq5EZEpP1jpTbvScVH46gWD7CixZgiAqUz
         Ce4Tq6stpudFBkZOMW2bdIBV8KMgDBbMFfL5DINGDsPvCS1YFx6jcD2sOXoTOvpsnG
         Ho1WoaXb4/turf+duna7fPplueauyniqmw+3i1dZhxISxZhStzPyTAwPY0dRfV9MRG
         J5KARGct264zx+zSdUummt1PWu7Pu6q48H+ln3aNUadbjdZDmTguY6bZH5/0ZoT0pw
         KGxGvwEjLpkfg1zSx5edFC/lhYm9KvKa7cadP2/Ziu9i9EUjcXmaNEOK7h2eVc3TJ+
         v2Trt6YxkFJZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: check the return value of devm_kzalloc() in
 brcmf_of_probe()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220311021751.29958-1-baijiaju1990@gmail.com>
References: <20220311021751.29958-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        davem@davemloft.net, kuba@kernel.org, len.baker@gmx.com,
        gustavoars@kernel.org, shawn.guo@linaro.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164744442985.16413.13793620395472132632.kvalo@kernel.org>
Date:   Wed, 16 Mar 2022 15:27:13 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> The function devm_kzalloc() in brcmf_of_probe() can fail, so its return
> value should be checked.
> 
> Fixes: 29e354ebeeec ("brcmfmac: Transform compatible string for FW loading")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Fails to apply to wireless-next:

Recorded preimage for 'drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c'
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Applying: brcmfmac: check the return value of devm_kzalloc() in brcmf_of_probe()
Using index info to reconstruct a base tree...
M	drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
Patch failed at 0001 brcmfmac: check the return value of devm_kzalloc() in brcmf_of_probe()

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220311021751.29958-1-baijiaju1990@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

