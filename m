Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816A05AFE49
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiIGIAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiIGH76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:59:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7C42D1D6;
        Wed,  7 Sep 2022 00:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE62616EF;
        Wed,  7 Sep 2022 07:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD70C433D7;
        Wed,  7 Sep 2022 07:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537585;
        bh=u72lc84TgQs9bAXFd+8wgoMc9W3qBLgCgr54TktnduE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hkmuMBi5VvwhmpxtI9Q3onHlnLqjYQLMScepKHYIFonZ4MyWJ6ao3ARr9ZBfCMrD/
         3cfJa27TDfGgksMEQOrzJpGia6+lLvrzaoNi5MDs6HVp/YM17NZFK7ZpDGYH9Wfmvp
         2MHZX6DfNVL0tP/Es9dp8sAT1qvyXNDzBTCnrVNVI2s6BJNy3vasdtzw0ItkuWXGOP
         XHrAbAtvQQPBcvQZlxNoLiVWYNPi6+yBxTqSrbLVOcp3/n/EzFSiBU+IQlkvfIa3Fb
         aipN4Iah1LMo5FzB3enTNih/0qa/ToDGDC2HKkDIsC/TboHQCyifae+WLr597LSRsF
         W3Gt6nPky2T1w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: p54: Fix comment typo
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220811120340.12968-1-wangborong@cdjrlc.com>
References: <20220811120340.12968-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     chunkeey@googlemail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253758158.23292.8128020768476719085.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 07:59:43 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Wang <wangborong@cdjrlc.com> wrote:

> The double `to' is duplicated in the comment, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-next.git, thanks.

3d784bade0fd wifi: p54: Fix comment typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220811120340.12968-1-wangborong@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

