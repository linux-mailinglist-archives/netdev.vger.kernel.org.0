Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D58609F8D
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJXK7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiJXK67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:58:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7068065578;
        Mon, 24 Oct 2022 03:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95B83B810F1;
        Mon, 24 Oct 2022 10:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F7FC433D6;
        Mon, 24 Oct 2022 10:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666609074;
        bh=243wXPv4AR2wrZkqmi6qWWqrr84EZXHvLWH+aXKTZsc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JZvUXGBJ26inuxYa/KlwNRJoQGifNOjtPJkX/9C32foZtGJ8nTh8fuatdepOlb0Qt
         M//aDMT33B6pKFUfBccCaG4jv9krcP0fpr5ZZuELySaI5JtM0qZ/LTaI1zL8V3lrNI
         bi9FKJ1FamNwYCoC4QQdsRcrbtw6GmuVeWnt+FpUGH5H76zyLY6rHce8E3C3QnhCkG
         9ia5dPvhbTxcZTgkB+L4t20u/2wowB/e3EHoYmdR/XcMBCGONZNFhsYYgrVTj+6gB/
         cK6YSqyJtRrOXsdkwhf2JA7cG3w/zI5QQPgFCjou70h4iJPEuPZJArH8ukmxyk++ji
         PG/s734059ngA==
From:   Kalle Valo <kvalo@kernel.org>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     gregory.greenman@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi/mvm: fix repeated words in comments
References: <20221022054244.31996-1-wangjianli@cdjrlc.com>
Date:   Mon, 24 Oct 2022 13:57:50 +0300
In-Reply-To: <20221022054244.31996-1-wangjianli@cdjrlc.com> (wangjianli's
        message of "Sat, 22 Oct 2022 13:42:44 +0800")
Message-ID: <87y1t5h4k1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wangjianli <wangjianli@cdjrlc.com> writes:

> Delete the redundant word 'the'.
>
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

The same here as well, it's easier if you fold this patch with the first
iwlwifi patch.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
