Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3D7561295
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 08:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiF3Gh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 02:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF3Gh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 02:37:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47E82E08D;
        Wed, 29 Jun 2022 23:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7152CB826A4;
        Thu, 30 Jun 2022 06:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2CEC34115;
        Thu, 30 Jun 2022 06:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656571075;
        bh=/4IgsvPx9hX0p7CIMt6foyWsR1g2kqSqShazso0sels=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VLQSfb4Ta2ZZa/2Ew8AYt2hyGsWClFy0Q7u3JSu0pIwXcxTevJKTeYPTL3pgOWwkI
         LV5XC7cHws60juXc4C9sYqAY18SM+ZOuxctGY32VsD1AdFZmXKxqsXydrdPkdB+doz
         q5WPDF6kt62FKzjpEZfjdoTSwFCRiPrbCcjXw61x0Q66LiuxiiuO52d1LdOt/eSKET
         XOFBuifLuSr1erZUCijCgRMwjbrqf/WK36q+b1w2TvwdaPD+g+oEUuZCSdXgfaji67
         AFIRBQm1kSx8tPd/3tM9GKLgs0naXQyTrRjsMEC9d6xY+T0WPH3pmu05+wDu9FIM9i
         4th0CCuUO61Tw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hyunwoo Kim <imv4bel@gmail.com>
Cc:     gregory.greenman@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: Fixed integer overflow in iwl_write_to_user_buf
References: <20220626105931.GA57801@ubuntu>
Date:   Thu, 30 Jun 2022 09:37:51 +0300
In-Reply-To: <20220626105931.GA57801@ubuntu> (Hyunwoo Kim's message of "Sun,
        26 Jun 2022 03:59:31 -0700")
Message-ID: <87leteodvk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I submitted this patch 11 days ago.
>
> Can I get feedback on this patch?

11 days is not that long, we have other things to do as well. Please
don't resend a patch, that just increases our workload. Instead comment
on your original patch and ask for review, but please wait more than 11
days before commenting.

Your original patch is in patchwork so it is in the queue:

https://patchwork.kernel.org/project/linux-wireless/patch/20220614173352.GA588327@ubuntu/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
