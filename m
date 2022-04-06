Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE684F62CE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbiDFPNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiDFPMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:12:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086B82B4B38;
        Wed,  6 Apr 2022 05:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86F6061990;
        Wed,  6 Apr 2022 12:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0951DC385A3;
        Wed,  6 Apr 2022 12:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649247197;
        bh=C5yY4TzJsHO5v5SmsV4DdCVU8KzN24skgAd7g6PA70Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=f4Sn5I8ER6nvBYLy9ptHOBkC3EiOEEHM89nbOlt0vt6afUVcuXZpzNLUmvJxXittq
         2+2BvXchKEHZ17hbu9h6oFMYTKe4sibMtmYZ0ULB0x5Rir+W4LHX3nxEhnvrD2ZcPc
         V2ZVrLRXHbrHdfAETQm3D6VEyDnPkRxf6K+7YwuYKFh19yUd4/LUez7hHtUCMoR6xp
         eQOtETFdi2XHuTb8SqCxnOVfHDKH30shvaFQEUEflXMrMLMY7MfDgy1wDpqH60I04F
         VSqyl39xqtQNgG/SBKjnbKHX0Lb7E48vnRfpEpgtbz8D33oa00P7UZcH55auL2EdkE
         qTyb8hP/rboZQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V3] b43legacy: Fix assigning negative value to unsigned
 variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1648203433-8736-1-git-send-email-baihaowen@meizu.com>
References: <1648203433-8736-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924719317.19026.17281329284987126566.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 12:13:14 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haowen Bai <baihaowen@meizu.com> wrote:

> fix warning reported by smatch:
> drivers/net/wireless/broadcom/b43legacy/phy.c:1181 b43legacy_phy_lo_b_measure()
> warn: assigning (-772) to unsigned variable 'fval'
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>

Patch applied to wireless-next.git, thanks.

3f6b867559b3 b43legacy: Fix assigning negative value to unsigned variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1648203433-8736-1-git-send-email-baihaowen@meizu.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

