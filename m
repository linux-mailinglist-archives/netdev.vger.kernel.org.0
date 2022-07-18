Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3357578155
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiGRLzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiGRLzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:55:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94A710FEE;
        Mon, 18 Jul 2022 04:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C63FB810F4;
        Mon, 18 Jul 2022 11:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2576C341CB;
        Mon, 18 Jul 2022 11:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145299;
        bh=JrABNSLBquy6UY/twSBJ4EF3aY/YoAKKA7YOdQp+hPI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eU6hGtxN2gwE8ynRAS+EAHsjFJ0UwHP/GyZ0E3go6jkwxyG0Tup0InjkXZ8B13d3e
         gp5yHkB2opoi+QEinmXKMPSfE2zVz1qt5xUXfPbsQh5wuI3lpf3s2fDAhORUqB7QH4
         V+NdDDgRaI2AbkLOxWpwuU1tI1MHc3scPwJ80XfwJkoiCfh1nX8sjVbiD8u4DO4UuA
         HzDtmebHfE2QLYWbKZDR8js3pxOMmNF7MOJ/wzRjbNDPp/6ggqTeZz01LJq2FbmONM
         5ZOKs25SmINbrXvuogLcbo9AJD6ddUpdMQN2yjtacoJpZSSJPRTg9IX/cheKnKoUWV
         thtAg6UXsDpnQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: p54: add missing parentheses in p54_flush()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220714134831.106004-1-subkhankulov@ispras.ru>
References: <20220714134831.106004-1-subkhankulov@ispras.ru>
To:     Rustam Subkhankulov <subkhankulov@ispras.ru>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814529503.17539.8245171776508092662.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 11:54:56 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rustam Subkhankulov <subkhankulov@ispras.ru> wrote:

> The assignment of the value to the variable total in the loop
> condition must be enclosed in additional parentheses, since otherwise,
> in accordance with the precedence of the operators, the conjunction
> will be performed first, and only then the assignment.
> 
> Due to this error, a warning later in the function after the loop may
> not occur in the situation when it should.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
> Fixes: 0d4171e2153b ("p54: implement flush callback")
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-next.git, thanks.

bcfd9d7f6840 wifi: p54: add missing parentheses in p54_flush()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220714134831.106004-1-subkhankulov@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

