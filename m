Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE8F4FE269
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbiDLNYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356304AbiDLNXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:23:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CC52196;
        Tue, 12 Apr 2022 06:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 613D4B81D07;
        Tue, 12 Apr 2022 13:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CC7C385A5;
        Tue, 12 Apr 2022 13:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769231;
        bh=D6Jlv2JUyY3cAN0adwNthYMXFUd3G0DuUSmPixoa1Hk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PoCjwU3YP9NmCxrWjNmDlhRjC/5rGVTTSS1PWbxkpHHcU/y55P0HdQwVoVxcRW/8u
         t7CFFZCJAqqdamlKCr4D7fEAAjiXuf6i7nhqyyOfSlAdSkQ8CS8ON5o6KCl6iR4kBV
         5vCcNAsluyrFwibSOngLQj1kgbWWtRejlg48H3tXBrBN89+nx60gDAcA0bswjOKGat
         UPHAdZUKq8ezQX2YYJVu2LlDu7i7V/F8A+YZlRIWAIq3Q34lRG79+NOJLSYVkymryn
         0i9KwTrf5RbkwhoA1h2gYiNG10qRlRhqTqbl0/bXEzncdZuYNty//FCm9TOjsF9oX2
         kJkQbBLwTjGZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next 2/2] ath9k: Remove unnecessary print function
 dev_err()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220408000113.129906-2-yang.lee@linux.alibaba.com>
References: <20220408000113.129906-2-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        loic.poulain@linaro.org, toke@toke.dk, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164976922680.15500.1095811162535053166.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:13:48 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> The print function dev_err() is redundant because
> platform_get_irq_byname() already prints an error.
> 
> Eliminate the follow coccicheck warning:
> ./drivers/net/wireless/ath/ath9k/ahb.c:103:2-9: line 103 is redundant
> because platform_get_irq() already prints an error
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d7ceee8051ba ath9k: Remove unnecessary print function dev_err()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220408000113.129906-2-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

