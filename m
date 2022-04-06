Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252B64F62FC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbiDFPSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235722AbiDFPRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:17:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253A1524349;
        Wed,  6 Apr 2022 05:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7CCCB822B2;
        Wed,  6 Apr 2022 12:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B897C385A1;
        Wed,  6 Apr 2022 12:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649247406;
        bh=bBXDw64UOpzm7gZgO/Usb8R7Vc4waEovDX6UsSvLe3g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TU8cYii2k0J2zHNl4T9PTAmCaJOM13yuwVdi5EFGMICiq8qSTUcCJzR4M7cbAs7eb
         V+I9jZbPnxr3rFimLi5uA0dvNZy/wLv5S3cMruztrzOp+cU58JhkZjPMw64maGu7bA
         UYd7gvFo/xSvinA4dfkrqha9GRcYBeD2xqp0YAs2PvUWBEoWJlvaiDxz0u1itEuKwJ
         sLcmBdc4amKVW1tDuQMWxE0zY4mnqttGW2aQROYTnbda/6gF2IyzOOsyMWZ9SRF8Ro
         vV8GtmvcUCrfqHg3gndsqYIfXBdAvd2DBuLhKMMoTSeJKQROwm86Vr0SNSjDC6EETC
         Q8aAvcvPQlFXg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] ipw2x00: use DEVICE_ATTR_*() macro
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220406015444.14408-1-tangmeng@uniontech.com>
References: <20220406015444.14408-1-tangmeng@uniontech.com>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924740245.19026.7090113247090845414.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 12:16:44 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meng Tang <tangmeng@uniontech.com> wrote:

> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>

Patch applied to wireless-next.git, thanks.

92bbf95df768 ipw2x00: use DEVICE_ATTR_*() macro

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220406015444.14408-1-tangmeng@uniontech.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

