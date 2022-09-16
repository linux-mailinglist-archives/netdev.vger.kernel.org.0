Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78ABA5BA946
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIPJTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiIPJT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:19:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8C5321;
        Fri, 16 Sep 2022 02:19:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88E79B8249C;
        Fri, 16 Sep 2022 09:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400A7C433D6;
        Fri, 16 Sep 2022 09:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663319964;
        bh=pN2OW3EORLXqVnkTRzakv6rscjLGxA/+z976k8wEY8Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Z3SLybas6VHvRutUEUDe5zDYTXg2rVJ/ejUmCooO3HJlmHy3ML2NF2F2+XuYDyTs8
         0v+HKXFMzwtumXHyyIPf6L0pC6v7rjor9+1tUn6ma//YM6bN7mKi4mNBsrs+FxDPHR
         4g5OfuZ9ZHtJcHEeRbITH14uxQWqRSOfR7kqHMO7MMomtR5YkeHIrGABXfLTLXIrzz
         0LTShhzqDJWIcezjepg7KnIaJ/qD1Ir8I0eJwPzTjyhZwEzLXwIhEf1qCiZwQw4DFN
         qi245dSghp7f/3WGkcxuo6ISsP+qJ6UCE1vseREO3sumAbLlLjttG1PhCvf+5pImbR
         /Sal6PShMcrEQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: Fix miscellaneous spelling errors
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220909145535.20437-1-quic_jjohnson@quicinc.com>
References: <20220909145535.20437-1-quic_jjohnson@quicinc.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166331996035.3127.11557394788042015674.kvalo@kernel.org>
Date:   Fri, 16 Sep 2022 09:19:22 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> wrote:

> Fix misspellings flagged by 'codespell'.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3fecca0e7de8 wifi: ath11k: Fix miscellaneous spelling errors

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220909145535.20437-1-quic_jjohnson@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

