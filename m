Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434A66ED38D
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjDXReX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjDXReV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:34:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C64729E;
        Mon, 24 Apr 2023 10:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA91561838;
        Mon, 24 Apr 2023 17:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2BAC433EF;
        Mon, 24 Apr 2023 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682357651;
        bh=fxBO3odpLRkRZu6k/tfRcxy+1TN9rB/OpQCKH9+JWHQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YqzUTY7pD3P2QLzp+UqRi/7mPLOJNMQI5Bn4m4ufoyIpmE0/J328T4EEs8vssgm4y
         wwUX5BLwsDPvpyoFwxUUHshjrk+nx5uzM3o4Lq+qZSkddibZBGeSGGklZjFF7zAL09
         CRCEBRWbf2Ui4aA2t5W3wwxV/8jzrgVOURe5NlgTfaXzYZzFZgyrTXoLg8SUb0pyL1
         MNwPJilQqUgqYSoytw2TRZDGktiBD7jW+YsNG1SvbAi3XA2Abmawtu5etKRf7b6ZAz
         5hH9f/mgipPNtJsUHIVDogeXyFytknJ9YbXABFGoFaJeI0oiH/csgzVeimBxykGXTo
         kUVffG6MsXvbQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: pull-request: wireless-next-2023-04-21
References: <20230421104726.800BCC433D2@smtp.kernel.org>
        <20230421073934.1e4bc30c@kernel.org>
Date:   Mon, 24 Apr 2023 20:34:06 +0300
In-Reply-To: <20230421073934.1e4bc30c@kernel.org> (Jakub Kicinski's message of
        "Fri, 21 Apr 2023 07:39:34 -0700")
Message-ID: <87zg6xtca9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 21 Apr 2023 10:47:26 +0000 (UTC) Kalle Valo wrote:
>> Hi,
>> 
>> here's a pull request to net-next tree, more info below. Please let me know if
>> there are any problems.
>
> Sparse warning to follow up on:
>
> drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25: warning:
> invalid assignment: |=
> drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25: left side has
> type restricted __le32
> drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25: right side
> has type unsigned long

Ah, sorry about that. We still have some sparse warnings left so I don't
check them for each pull request. We should fix all the remaining sparse
warnings in drivers/net/wireless, any volunteers? :) Would be a good
task for a newcomer.

Felix, could you submit a fix for this? I can then apply it to wireless
tree and send a pull request to net tree in two weeks or so.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
