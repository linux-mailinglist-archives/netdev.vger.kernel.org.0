Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA1469F1FD
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjBVJkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBVJkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:40:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17D138EA6;
        Wed, 22 Feb 2023 01:37:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05B6A612B2;
        Wed, 22 Feb 2023 09:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FFEC433A0;
        Wed, 22 Feb 2023 09:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677058570;
        bh=rFQ08XqnmKgreYK0T/xvGGP3R+J2JrSfW9FfpliUaPs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pwlyWK4iVjR8tABgAOltE1OFLX1vmDwB78exTdCb8OeRE1K1yKo+IdVYeUL/BqESA
         BaHGSBUTf4J92Ev884CbXmqm0FjFiaUB7dloSaBYrO4PQzVH5jClJX6ASp/sWYG6O4
         w39i5ctPyuQwvEr7Eo7VNTFzFDSghetuEhMCR7XBmDCoyQc2HfT9mUmeYb9EkbXrsQ
         dQN6yUkONs0CKUHvaL8FORav4HxEJqfNeQjHFjZgyCnqEu7xpybLrTt9modqFtUlgA
         SqMfnHxXTzoIiHwYRApL+jYPOm92N8U7N9vQkAB1sDlFNjyQhfDwmsf7T9sDZkq1bh
         8ujIbE/PxEMvg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        quic_mpubbise@quicinc.com, netdev@vger.kernel.org, kuba@kernel.org,
        linux-wireless@vger.kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2] ath10k: snoc: enable threaded napi on WCN3990
In-Reply-To: <CACTWRws334p0qpsZrDBULgS124Zye9D7YC3F9hzJpaFzSmn1CQ@mail.gmail.com>
        (Abhishek Kumar's message of "Tue, 21 Feb 2023 23:09:24 -0800")
References: <20230203000116.v2.1.I5bb9c164a2d2025655dee810b983e01ecd81c14e@changeid>
        <CACTWRws334p0qpsZrDBULgS124Zye9D7YC3F9hzJpaFzSmn1CQ@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Wed, 22 Feb 2023 11:36:03 +0200
Message-ID: <878rgqt530.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> Gentle reminder for your comments.

A gentle reminder to avoid sending gentle reminders :) For example, I
currently have 103 patches in patchwork and if everyone send gentle
reminders that's a lot of unnecessary email. So please avoid sending
unnecessary emails. "gentle reminders" don't help, quite the opposite.

Unfortunately sometimes it takes time before I'm able to look at
patches, but if the patch is in patchwork in an active state I will look
at them eventually. More info here:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
