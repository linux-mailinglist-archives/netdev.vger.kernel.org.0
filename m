Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D88E378A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439714AbfJXQLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:11:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40368 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436655AbfJXQLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:11:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D22F5611AD; Thu, 24 Oct 2019 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571933484;
        bh=6BQeRd1YE343V3Pyn6bXhu7AVvclx5LyH+xiYk/mmsQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TQNWdZPw1VNshMmWaBQj1Njknz4thr4uOvbL1s7+gUpZ2/S4Z6UPbwd/i0UR/Pl7b
         Sp4caPzRIbVyjzYY/jo54suzPij6UtrkvF+XsYDXl1bDXeAvgT6m7F8e19ZDERebd7
         vU/FhgsI3fyJCWKzlLamjK3sITo8j5Zub6XmHcBw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CE9586110A;
        Thu, 24 Oct 2019 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571933480;
        bh=6BQeRd1YE343V3Pyn6bXhu7AVvclx5LyH+xiYk/mmsQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ad96iQEMymUX4ygi/5GDCdgFnmUhXDrCv64tNVhd3dPGHxI4cDyjZzfjbCwrwUedx
         /jnhJJswJ5dPo4LKE68u2uv2H7SAvEKEbExn15lSHN9CohgbLdjqfa6M8ApqgrEYzy
         NJ7yZ41/UYNotjEG+4ToTSevM23sPyCLz9KkbYLk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CE9586110A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [trivial] net: Fix misspellings of "configure" and "configuration"
References: <20191024152201.29868-1-geert+renesas@glider.be>
Date:   Thu, 24 Oct 2019 19:11:15 +0300
In-Reply-To: <20191024152201.29868-1-geert+renesas@glider.be> (Geert
        Uytterhoeven's message of "Thu, 24 Oct 2019 17:22:01 +0200")
Message-ID: <878spaqg2k.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> writes:

> Fix various misspellings of "configuration" and "configure".
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Merge
>     [trivial] net/mlx5e: Spelling s/configuraiton/configuration/
>     [trivial] qed: Spelling s/configuraiton/configuration/
>   - Fix typo in subject,
>   - Extend with various other similar misspellings.
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 2 +-
>  drivers/net/ethernet/qlogic/qed/qed_int.h                | 4 ++--
>  drivers/net/ethernet/qlogic/qed/qed_sriov.h              | 2 +-
>  drivers/net/ethernet/qlogic/qede/qede_filter.c           | 2 +-
>  drivers/net/wireless/ath/ath9k/ar9003_hw.c               | 2 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-fh.h              | 2 +-
>  drivers/net/wireless/ti/wlcore/spi.c                     | 2 +-
>  include/uapi/linux/dcbnl.h                               | 2 +-
>  8 files changed, 9 insertions(+), 9 deletions(-)

I hope this goes to net-next? Easier to handle possible conflicts that
way.

For the wireless part:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
