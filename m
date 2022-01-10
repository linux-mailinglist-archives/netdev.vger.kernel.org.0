Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1096489630
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243784AbiAJKSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbiAJKSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:18:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B34AC06173F;
        Mon, 10 Jan 2022 02:18:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BAAA6124F;
        Mon, 10 Jan 2022 10:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A40C36AEF;
        Mon, 10 Jan 2022 10:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641809893;
        bh=BZo15StAkByqX0uv90iAfnL4AMqF0l/eyPPVS/zwN2Y=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=r5ugoXVB1Q2HkO2wPGFs6AG7AX8wjlsIbb5k++SVMklThxdH5xYLo8PZG1WLfGt42
         bN5D+G9vSG7ki/+C1qqZJKsOQl9Z3WJd7DzCqm5s0xYLDpXT3dpn/osblvdYVohqe9
         6g1WLRBNn/M1PY1O66EkRXQSztAVWRBOoFj/3IxkP3oJKwXvR+R0D9ZjzSDx+nAs6x
         8PVEVm2VhcBxmjBrWDbMpad+EpeCnWc6x/SEkQ0mv+AOq9QGgeZH3YDWCG9WadMwIG
         7uaqN5lqHzu3EStFQ1IWk5lwPiLhaRIBNps84hNkDATFrFCoJ9g1D520e845+fg/ye
         z5/NE6nEmxQgQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     dianders@chromium.org, pillair@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] dt: bindings: add dt entry for ath10k default BDF name
References: <20220107200417.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
        <20220107200417.2.Ia0365467994f8f9085c86b5674b57ff507c669f8@changeid>
Date:   Mon, 10 Jan 2022 12:18:08 +0200
In-Reply-To: <20220107200417.2.Ia0365467994f8f9085c86b5674b57ff507c669f8@changeid>
        (Abhishek Kumar's message of "Fri, 7 Jan 2022 20:04:31 +0000")
Message-ID: <87pmozvqqn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> It is possible that BDF name with board-id+chip-id+variant
> combination is not found in the board-2.bin. Such cases can
> cause wlan probe to fail and completely break wifi. In such
> case there can be an optional property to define a default
> BDF name to search for in the board-2.bin file when none of
> the combinations (board-id,chip-id,variant) match.
> To address the above concern provide an optional proptery:
> qcom,ath10k-default-bdf
>
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>
>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt          | 4 ++++
>  1 file changed, 4 insertions(+)

Please CC ath10k list on all ath10k related patches.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
