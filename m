Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A015FC0BB
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 08:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJLGhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 02:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJLGhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 02:37:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9FFB03C0;
        Tue, 11 Oct 2022 23:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39127B81964;
        Wed, 12 Oct 2022 06:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B22C433D7;
        Wed, 12 Oct 2022 06:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665556624;
        bh=VpYQlndqycx0FJh72D35XMdOGmJBs1MOcPOJvcY/kAA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JJUhNO4PN6dpLW2afeHD0HeOfZK/QIh8XQ6pcAaItqvVRdjdBr4b3vxqAG+XCengq
         VERekJdkwMICbF1PcwVjrmnRpwqleb1sWEzGtiro0eyUyAfwtaOBgjpmDdlhfuXyyj
         v/K7KI7aIx7X2Ymh6caJIpU6zyfdC2t7A8dQ1HErbJoQoMMBQNdlkADwtZHG/WPYAG
         Mgh3cUww5DNf3L6QoJIhCQdc67cj5an/+1LoHqSyUn6KYFL1MEbXQteWhPxgOqYluB
         6Qzovf0N6aisxt06WkzVNCSkCa43/xw/Lnxs0TWewsz6hHo8BYy6cOOFUURSkh+ztp
         wuEoz3sUN5pQw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: carl9170: Remove -Warray-bounds exception
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221006192051.1742930-1-keescook@chromium.org>
References: <20221006192051.1742930-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166555661512.24262.8970482659659186700.kvalo@kernel.org>
Date:   Wed, 12 Oct 2022 06:37:01 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> GCC-12 emits false positive -Warray-bounds warnings with
> CONFIG_UBSAN_SHIFT (-fsanitize=shift). This is fixed in GCC 13[1],
> and there is top-level Makefile logic to remove -Warray-bounds for
> known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
> '-Warray-bounds' universally for now").
> 
> Remove the local work-around.
> 
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

2577a58df244 wifi: carl9170: Remove -Warray-bounds exception

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221006192051.1742930-1-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

