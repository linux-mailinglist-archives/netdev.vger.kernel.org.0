Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A9C633833
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiKVJTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiKVJSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:18:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21A049B4F;
        Tue, 22 Nov 2022 01:18:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41FF2615B1;
        Tue, 22 Nov 2022 09:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DDEC433C1;
        Tue, 22 Nov 2022 09:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669108714;
        bh=j9speDymTYbUPsP1fOy8bbC9qMHtxNbRU0XlKQO9gww=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TOB+dzstBVseFxp1lggAMCRNz9fLnNifrR62pam7JAqtqyIEeAFvsiuC3wQw7B9gZ
         UOaLWruuYlFRpj1goSOogbU+I+7Q9ViTohU4R0gtOhUIwPoWZnmnRL0Pja0o0xRSlS
         wHdIFiiVBfQFzrjUmQ54t7oHJriq1L/m/EUWy/rCNanjRnIa8P58iqyHSDI7vEVwgd
         9Q12a+/rornNH9gUxFMkdKEqoXWXyqlgIP+76lyygnslZNIEVwIYVf0rtnnOrqgY+d
         PZL9FWLxAIrFHXNZiFg+ilbr5SKaiG1Q18DBMajvO5QnSJbNGizdBiXdsvwxNUAmAK
         6QenHfl9HLtUA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rsi: Mark driver as orphan
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221113185838.11643-1-marex@denx.de>
References: <20221113185838.11643-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166910870966.6391.12194362025928207561.kvalo@kernel.org>
Date:   Tue, 22 Nov 2022 09:18:31 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> Neither Redpine Signals nor Silicon Labs seem to care about proper
> maintenance of this driver, nor is there any help, documentation or
> feedback on patches. The driver suffers from various problems and
> subtle bugs. Mark it as orphaned.

This is really unfortunate but I don't see any other option. I hope that in
the future the companies would change their minds and start contributing to
upstream again. 

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221113185838.11643-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

