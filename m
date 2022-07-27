Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0858271D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiG0MyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbiG0MyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23EB27B13;
        Wed, 27 Jul 2022 05:54:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E832B82149;
        Wed, 27 Jul 2022 12:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFEAC433C1;
        Wed, 27 Jul 2022 12:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926446;
        bh=bUI8RRcRRi8N4BCjRhAZBlP3oQu0WfRYo+LB9U7ijHI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JCHGNXwGYot1cE5EL6Gc3+C09mDz8gC6wsoK7F+rP4k6EuhITigg3GaQXGPRg3GmV
         Pl7jfG5plca5zDcHmeAM47HBPux8Dw8QLBSmMvE+tNpbjiBKXweXjGpbV3Jx/NrDgA
         PBgUJPE4rkdvgioC+hPE0tefuicFIwpDDumQkL+pKXOYbWuGzpwMWh2CPdrwbkRIt7
         09aDkk2Oe1kyVOpM6qo7tP+YaTmMGbs/wFlkBOOEayw2BvZN9/z1G2pHrkoyHqt+sK
         RoBx2TqQJGMTf+CbVrJXlLRqEkR6pRZC+OfidtHElKtiypk1AQUdPDuMSWEaWO5vMe
         2Hjnq/JaUcWtQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: b43: do not initialise static variable to 0
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220720194245.8442-1-gaoxin@cdjrlc.com>
References: <20220720194245.8442-1-gaoxin@cdjrlc.com>
To:     Xin Gao <gaoxin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xin Gao <gaoxin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892644221.11639.11999522991830836091.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:54:03 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Gao <gaoxin@cdjrlc.com> wrote:

> No need to initialise static variables to zero.
> 
> Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> [kvalo@kernel.org: improve commit log]

Patch applied to wireless-next.git, thanks.

dbf8cd368a47 wifi: b43: do not initialise static variable to 0

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220720194245.8442-1-gaoxin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

