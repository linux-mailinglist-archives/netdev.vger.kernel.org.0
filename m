Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F36B4A80EF
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 10:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349697AbiBCJFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 04:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349689AbiBCJFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 04:05:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996FDC06173B;
        Thu,  3 Feb 2022 01:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB2BB83376;
        Thu,  3 Feb 2022 09:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A847C340E4;
        Thu,  3 Feb 2022 09:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643879120;
        bh=ka31XnUdzDPVoP4gtRyLrU0AKLDgZbk5b+AQBM6fMiU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Wvuju0luhlSZncifUc+VBM5JTfT7R53lLSF/Hp82Gf3UH+hzqlWDSAU5u3HgcYMuE
         kT4rFvPknbChBSgt8QXYUCAo3ghbImJasRgDv9ao32J1DRFYXl0e2HjupocAqAofTo
         ch2g5hGj+BPI1zy3hr93XJ1BWBlwucL8OoclrGP8xYbzlF6WT10NDdn8eVz/YvUIf5
         8mNtJqvKDemJmXofskVMuRMuwS/ndsS4MsxTzTuK+7H/XLikxi3qwQaCODuwgog1Fo
         VhWdl89yCkR8mLDIu6Iu49l8LMWriMIlSjv1y+ARsIsQK9MgJM4iKedo8P4tc9J4+D
         yUEgdBq5i8Kwg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] wcn36xx: clean up some inconsistent indenting
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220201041548.18464-1-yang.lee@linux.alibaba.com>
References: <20220201041548.18464-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164387911640.6516.16681553921400829209.kvalo@kernel.org>
Date:   Thu,  3 Feb 2022 09:05:17 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Eliminate the follow smatch warnings:
> drivers/net/wireless/ath/wcn36xx/main.c:1394 wcn36xx_get_survey() warn:
> inconsistent indenting
> drivers/net/wireless/ath/wcn36xx/txrx.c:379 wcn36xx_rx_skb() warn:
> inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

df507a7f8675 wcn36xx: clean up some inconsistent indenting

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220201041548.18464-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

