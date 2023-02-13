Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7877694ABE
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjBMPPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjBMPO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42DB1E9F2;
        Mon, 13 Feb 2023 07:14:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB1361174;
        Mon, 13 Feb 2023 15:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3720C433EF;
        Mon, 13 Feb 2023 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676301290;
        bh=HmFLOdK64GJkRf3i4ztkg2FSB2GD+7uH7qO3+IVjX4s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NOw6cX7Ow//limBbrQiXZRUl8SqWZH9l7qSEjcSQllmhjHzFNGd1ZPFPx6av0ogBk
         wpyXvwBXIrUgNMDB4VqUK6y2n2CiZBFplA4yO2deTNXA5pRc85zqK+qE/jTS8VIL+t
         BBqdru5Ul7DOlHlsfL7n83f+NItUCMLOEm5P8viyZg9GaR6INyDjLcTsWxxfXI8sEN
         VnF0GSzxVlD+SlyJFU+b3u1Ju/dJUEXsjxugKhMmp1pq0Q1GI1rjhQdIStpU8odTK8
         WH1xqFawUDoI38U8kzBbqXI5l25IWZqAnbjf5Jfq3rZCcqt6tBEjTYDj26wLTRo6Mg
         nDnxilh4ASV+Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: wl1251: Fix a typo ("boradcast")
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230129124919.1305057-1-j.neuschaefer@gmx.net>
References: <20230129124919.1305057-1-j.neuschaefer@gmx.net>
To:     =?utf-8?q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Cc:     linux-wireless@vger.kernel.org,
        =?utf-8?q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630128685.12830.16223613209304553774.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 15:14:48 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Neuschäfer <j.neuschaefer@gmx.net> wrote:

> It should be "broadcast".
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Patch applied to wireless-next.git, thanks.

900cad6ef12e wifi: wl1251: Fix a typo ("boradcast")

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230129124919.1305057-1-j.neuschaefer@gmx.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

