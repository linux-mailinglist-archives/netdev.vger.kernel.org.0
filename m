Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61784D4EEE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbiCJQVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242515AbiCJQUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:20:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA041265B;
        Thu, 10 Mar 2022 08:19:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA2FB826BD;
        Thu, 10 Mar 2022 16:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B89EC340E8;
        Thu, 10 Mar 2022 16:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646929160;
        bh=JTnw/ENTIA18v/u9Hp5h40ebMk+RRYm7ZuQ7qV50Aw8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gWeoJ8NG6brbdkkgCwR1jPawqyy2eUIIPx5E9azGWKSDPg/SfHLhwp+AlxBZVnp8j
         QzEhjSUHk54s13rvmbc/qMsh5eHz+aFv2BebTe2vi+mzVm94RZ4P6zSwKwCT4RbuvW
         iOOlhVCoIcauRjCQ0F/0qeh93Er+RWdFMtPX9Vo51J6jPB4gIEwNxqA9ggT6CiX1Kt
         s58voUjMOch9gj22ijscRVTKW2PacEWLsQtTYqNBL2ZINZic2wUyKtLLHEASB5nVcA
         bzAf/BeAfo/lSAxgfHzJeWHzrzmcopV2vS+PXbXprJ16Y8Z9T9+pbtr0VH1OS5+3Xr
         eeOncUEmMCtyg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: make the read-only array pktflags static const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220307223227.165963-1-colin.i.king@gmail.com>
References: <20220307223227.165963-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692915539.6056.8702286718755392270.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 16:19:16 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Don't populate the read-only array pktflags on the stack but
> instead make it static const. Also makes the object code a little
> smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Patch applied to wireless-next.git, thanks.

2386f64ceb33 brcmfmac: make the read-only array pktflags static const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220307223227.165963-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

