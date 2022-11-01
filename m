Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C95614814
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiKALAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiKALAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF7E178BC;
        Tue,  1 Nov 2022 03:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A48B4B81B0F;
        Tue,  1 Nov 2022 10:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9B7C433D6;
        Tue,  1 Nov 2022 10:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667300397;
        bh=dKEuaYyyAw0/iFBymiu6NLIfDXb4VFkaxpP0t9sFQn0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YDcgPJMnCwXLtF5ZBJ3e1vZ/8v2eo7+N0HdsMyBc+vncFG3OJjUegJDLOw5agKDC6
         1PbS+8y7XUGCrZq2OEylHUwrkPxiot5IQSbbHxOLN5A5yiNy5AP6A3Ybhe/rzB9nSe
         mVHPDaYWrZbdn/zEpk4w9fay9MbCjrhimbME64d3n/T0DpvUScGkjbGICgaKX7YInb
         aCsGQ0Be3hl5+REJpUwAN90sH8PM1aaxhQLnJ39aTMMCQLY0VdQfxv/oQX+WzdYdmF
         cL5T8VBwE7XNQ4mfexmuTJMuPORfqpwTjLu5dvUKISvMFgBp5BRNB+Tb5kd9ZgE005
         9lv1AEyuofzAA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [next] wifi: atmel: Fix atmel_private_handler array size
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221018023732.never.700-kees@kernel.org>
References: <20221018023732.never.700-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Simon Kelley <simon@thekelleys.org.uk>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166730039237.21401.8200103649620545525.kvalo@kernel.org>
Date:   Tue,  1 Nov 2022 10:59:54 +0000 (UTC)
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Fix the atmel_private_handler to correctly sized (1 element) again. (I
> should have checked the data segment for differences.) This had no
> behavioral impact (no private callbacks), but it made a very large
> zero-filled array.
> 
> Cc: Simon Kelley <simon@thekelleys.org.uk>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Fixes: 8af9d4068e86 ("wifi: atmel: Avoid clashing function prototypes")
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

8b860466b137 wifi: atmel: Fix atmel_private_handler array size

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221018023732.never.700-kees@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

