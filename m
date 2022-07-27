Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48C7582502
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiG0K7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiG0K6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:58:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8E848C91;
        Wed, 27 Jul 2022 03:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47D6A618C1;
        Wed, 27 Jul 2022 10:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1341C433D7;
        Wed, 27 Jul 2022 10:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919531;
        bh=7tUhEJs2CQxJjk41H0dCq5KM5IJQERlXBZx+wr9WzlY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tTe9hGhvG3LkuK5e2qSzFejTNytV6m19U7o6rhZSEXhl3uLv5b03ECPOZ/7vLfB3I
         /U5rh6FK45wr4Rb5t+EzhD+RT4jsZrMQsZwQvLpAu8ricNa6NMRxmYXkHdVAgY8tDf
         7qeNr7p4sK4A5lpzGeFMir8UA/q2zRn2ubXeNS2zoYoNgag/BD1WX4j4dzF0TBKsgE
         iUW0WHNIvckByAXmEs0X8UsSkEuGSr+uM39rEfYKjMXLtIZn7L8Z/J6gHKQbSU68Pw
         F+C/6Enhl+isCBw1LSylSEz0VF8x+KGY77fJn7AVJWIanDR4fVz4/jfZvuYUBslmkC
         nO80iYtnb1Lhw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mwifiex: Fix comment typo
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220715050053.24382-1-wangborong@cdjrlc.com>
References: <20220715050053.24382-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     ganapathi017@gmail.com, amitkarwar@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891952721.17998.5897691380524860117.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:58:48 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Wang <wangborong@cdjrlc.com> wrote:

> The double `the' is duplicated in line 1540, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

6d1725a4a620 wifi: mwifiex: Fix comment typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220715050053.24382-1-wangborong@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

