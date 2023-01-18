Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4953A6715A3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjARH4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjARHxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:53:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D9558663;
        Tue, 17 Jan 2023 23:28:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30863615CE;
        Wed, 18 Jan 2023 07:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948FAC433EF;
        Wed, 18 Jan 2023 07:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674026935;
        bh=b84KPZ2F9X2F1bkJ0Ejdn0pRUACRucNe2ZVO2IOrpWo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Tzox7rROXdvBicsZM0UYTGyoqU9D/06FaYJvhL+qqGSHKVOzOIjMYYb8YxqCn1W5z
         3bmmBrxxnbCciq+QqCHXDWZ8HnH0nXcm7wt5Jlpq6xqKvTxPmX9lpQyVN6FyPf4TmQ
         9XLDds6UFL3MeP/IT/7L2wSs7+uFHKpHQRhJZzVERLJAluimTUvm9fjnOujWXkzu9A
         kcQ5uhtgwUlmZCoeccZZX4XmzfIvNNyMv5QSYrYxubvsMPhsd0H017e1QfrbryIu6w
         ++q0ofUMbd429nSGVxCmwGjlcf2Os7i+nVHqPLpKzpkKLkUx7CaIaZXkr+FNK7Fbai
         S2bW2UYaR6FUw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] wifi: rsi: Avoid defines prefixed with CONFIG
References: <87mt6h8xu7.fsf@kernel.org> <20230117122838.5006-1-peter@n8pjl.ca>
Date:   Wed, 18 Jan 2023 09:28:51 +0200
In-Reply-To: <20230117122838.5006-1-peter@n8pjl.ca> (Peter Lafreniere's
        message of "Tue, 17 Jan 2023 07:28:38 -0500")
Message-ID: <87bkmwxpvw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Lafreniere <peter@n8pjl.ca> writes:

> That would work better, but to me it seems odd to have one define
> with a prefix and the others without. I could change them all, but
> that seems like excessive churn for the very minor 'issue' that
> it fixes.
>
> After rereadig rsi_load_9113_firmware(), it seems like just dropping
> the CONFIG_ would be a reasonable change that doesn't affect readability.

Yeah, removing CONFIG_ looks good as well.

But please add quotes into your email. We get A LOT of email so having
proper quotes is important, otherwise we don't know what you are
answering to.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
