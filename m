Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AD24F626C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiDFOxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiDFOwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:52:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F911925BA;
        Wed,  6 Apr 2022 04:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 15480CE22A0;
        Wed,  6 Apr 2022 11:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD01C385A7;
        Wed,  6 Apr 2022 11:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649244496;
        bh=eAgbv9qgg274UEIYdexRlug70MVocnKwK9vWroUZko0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pIa4E0+UEbA/SOqY2lPQRFBLbmmUL0xYSP6M7jkkfkqwJf9TgYsN473SXmo2sHjlU
         XLWBEYPihuWGVMM5W7V8bvRJweLXMypfFYcCgSrqAJ4zfmBjnH97NpR0pb8nqL2KU2
         yFdkNcWhloCeDF6i6GhqjHHRKFd/Dkh1vCN+0mfC3XqAlANEpmKz9jiiXF8eovm3U3
         9EJ+TqSTXdN7C4Msd+UYwvdf/9Pzl1GHAKAnxFBIVrMvyXe60cNfJakGXXwRfPQjB+
         xYII7hf8ECE4TLJb2sPpnQxUA17myXM3T0xI6zDVH9m/OhT0SqR/oMbFxrLazompDI
         YzxNMSJJlQ3/A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v3,2/2] rtl8xxxu: fill up txrate info for gen1 chips
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220325035735.4745-3-chris.chiu@canonical.com>
References: <20220325035735.4745-3-chris.chiu@canonical.com>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924448932.19026.12333806311207815732.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 11:28:14 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chris.chiu@canonical.com> wrote:

> RTL8188CUS/RTL8192CU(gen1) don't support rate adaptive report hence
> no real txrate info can be retrieved. The vendor driver reports the
> highest rate in HT capabilities from the IEs to avoid empty txrate.
> This commit initiates the txrate information with the highest supported
> rate negotiated with AP. The gen2 chip keeps update the txrate from
> the rate adaptive reports, and gen1 chips at least have non-NULL txrate
> after associated.
> 
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>

You ignored Reto's comment in v2 about misspelling of adaptive, but I'll fix
that during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220325035735.4745-3-chris.chiu@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

