Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9295826FB
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbiG0Ms0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiG0MsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:48:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC1D2B629;
        Wed, 27 Jul 2022 05:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD581B8214D;
        Wed, 27 Jul 2022 12:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DF1C433C1;
        Wed, 27 Jul 2022 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926101;
        bh=m+Y9fN4D6eY/G8gHM+Oa2JUyeykBswR2RrqOp5fY+r4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GkzdfYnM+iNza4SBkvJOyd3czK4liDG4b3y52UL0x7FgxxoSkKNdfW0NCzEJdK5uv
         Rk+2qh7Ug6JlZVr0+yJow9jSo4eMUCJa6nbWVusslwJyWO5erqpuWExUvaIaYA67rS
         oEYR8yTpd2ZQnppFcIeUjfa5FB/pZNzJ2mp76q3g7zcWagDZIkU4WqYqUhLo2Z8bxv
         lHALsTeMBEWyRsdqco9m4V3G7iE6q6SOs+M5OmG9t+v/N7FPH542A/42v4CsONeHAU
         SG7Fpf65gj1dZA3U4N8DlluOEc+brmgNFlI4tZNHgtn1c/kVJ7jKqzhyUTe8GjDm6Z
         NN1WBOLamIFBw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [-next] wifi: mwifiex: clean up one inconsistent indenting
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220615005316.9596-1-yang.lee@linux.alibaba.com>
References: <20220615005316.9596-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892609585.11639.14156741495498065635.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:48:18 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Eliminate the follow smatch warning:
> drivers/net/wireless/marvell/mwifiex/pcie.c:3364 mwifiex_unregister_dev() warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Patch applied to wireless-next.git, thanks.

06ce07860b32 wifi: mwifiex: clean up one inconsistent indenting

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220615005316.9596-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

