Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0158C4FE251
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347903AbiDLNX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355965AbiDLNWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:22:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E8FB47;
        Tue, 12 Apr 2022 06:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28BE5B81B1F;
        Tue, 12 Apr 2022 13:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC7EC385B3;
        Tue, 12 Apr 2022 13:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769168;
        bh=/vmu44weNRIQQXno9KBtiVr3WCW3XhcLvkMQI6ma3p4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qPMhMA/1nt5PjdyYlYofPIkLDrgS/GxzukEvqNUNEwWUpRZ5hWJCWF0HqRZNmUCR4
         OP+KEPXV6Pw36hLg/1TmF1zG2oe+uWulYFfpOdgeecwZBHuz18W8tNH5orLFViooxK
         kl+4i9AdEwZvTNGoyuG3qEk9WiXgxr6M9EhLawNV5WuM4G+0mt4aiYaqBdGeqsMd6G
         3YMFHdUGLHBgN3k3kth1+3ChUZNTEmRTP3RWdVkFdkTyS1+2u15D7c2CSICtdlIKie
         +3S5uPxnmYfuN3vCY0WFGwuvMMvMnpGhqeIdAd5Qhk/GmHlR3uzrSjzwqt7eJbvRHl
         VYNHN2612HCfw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: Fix spelling mistake "reseting" ->
 "resetting"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220407102820.613881-1-colin.i.king@gmail.com>
References: <20220407102820.613881-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164976916384.15500.12618442954054836491.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:12:45 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> There is a spelling mistake in an ath11k_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

405342ebea2a ath11k: Fix spelling mistake "reseting" -> "resetting"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220407102820.613881-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

