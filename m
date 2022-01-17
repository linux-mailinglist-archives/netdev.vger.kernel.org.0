Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298514908C7
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbiAQMio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbiAQMin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:38:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AC9C061574;
        Mon, 17 Jan 2022 04:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B15E86111A;
        Mon, 17 Jan 2022 12:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AD7C36AE7;
        Mon, 17 Jan 2022 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642423122;
        bh=YoRCQyRKboV1wpmbg9gOR7ZKCoDlo9AUujfUF1dp0vw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Nb2McJJ8uhM7zcIMkx9fSNagvRTJhRdeogys3k6fCJKj8DxnE/iBmNoygv8Xn+H52
         yVb8e6TJLNFiDwN4ibdX1uku4NF+/U9SpTIesWB6TWnC7yGAdAs1GVMqrqDb1sguqX
         skkbut2v5aUxkDVK9pQXRV9xWBXUsLYhVT5zaYEdis3Wsal3sREG3dTyx8CcEMzyMG
         nNZbBfTy02pPp+V8JkpyD0kL+81es1Wh3D/0WLLAuNK6PYSjLtg2VpX8I71BVScn2U
         TsimwqCo45vLBI1dBZH81+37spKv7e65gdUtHTFJQ5iA8z8v7OlUA5XTLxEVm3n17R
         4GYG0j6kaxn1w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1 1/5] ath5k: remove unused ah_txq_isr_qtrig member from
 struct ath5k_hw
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220110223021.17655-1-ps.report@gmx.net>
References: <20220110223021.17655-1-ps.report@gmx.net>
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164242311822.27899.14639459012545076340.kvalo@kernel.org>
Date:   Mon, 17 Jan 2022 12:38:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> wrote:

> Remove unused ah_txq_isr_qtrig member from struct ath5k_hw (set in
> ath5k_hw_get_isr() but never used anywhere).
> 
> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

5 patches applied to ath-next branch of ath.git, thanks.

5b747459477b ath5k: remove unused ah_txq_isr_qtrig member from struct ath5k_hw
bcc08e05041e ath5k: remove unused ah_txq_isr_qcburn member from struct ath5k_hw
0feb4052ad47 ath5k: remove unused ah_txq_isr_qcborn member from struct ath5k_hw
3296fe1a8339 ath5k: remove unused ah_txq_isr_txurn member from struct ath5k_hw
dff39ad93de8 ath5k: fix ah_txq_isr_txok_all setting

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220110223021.17655-1-ps.report@gmx.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

