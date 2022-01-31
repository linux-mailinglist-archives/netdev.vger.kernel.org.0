Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0945F4A4923
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 15:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379333AbiAaOOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 09:14:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53060 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346623AbiAaOOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 09:14:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48CD6B82985;
        Mon, 31 Jan 2022 14:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B83C340EF;
        Mon, 31 Jan 2022 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643638482;
        bh=Jwzdg3jhNqhksWvoAOfXZTDUHbCt7r7dWEMB/5+WEb4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=khi1WY1hIz6HuXBPUO7Hxyfb9A/gfLwJK2wgyhKyjcCfD8XUlycpXp65+/+0EI+RK
         efAAUC4dnl+YaY9OyycR6A/0OTvwCdNpCkDxwsfUljSenIFPzV3rXVE4iLlVlzhp6o
         /JSHVo0/dbKxJm3sTrOavET6LELm9aQFTi+wTEVdr6HhF11y+U/AVs/enDlKPsxc3Y
         nmcZG5/vgd+KDq7BAXpECM5gSVfULe2zNjd8nzOAzP08DItTQ1HCG58BCHbCS0fDtV
         1P6KWikH0WguN4FoSaWV4nhOfth4rrfjnDyO4CkM8GWI/h4G2E9DeUjR813c/PfL3z
         V/ZaQUtedEjaQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] carl9170: fix missing bit-wise or operator for tx_params
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220125004406.344422-1-colin.i.king@gmail.com>
References: <20220125004406.344422-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stable@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164363847846.10147.1688492518810406694.kvalo@kernel.org>
Date:   Mon, 31 Jan 2022 14:14:39 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Currently tx_params is being re-assigned with a new value and the
> previous setting IEEE80211_HT_MCS_TX_RX_DIFF is being overwritten.
> The assignment operator is incorrect, the original intent was to
> bit-wise or the value in. Fix this by replacing the = operator
> with |= instead.
> 
> Kudos to Christian Lamparter for suggesting the correct fix.
> 
> Fixes: fe8ee9ad80b2 ("carl9170: mac80211 glue and command interface")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Cc: <Stable@vger.kernel.org>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

02a95374b5ee carl9170: fix missing bit-wise or operator for tx_params

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220125004406.344422-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

