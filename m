Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114DDE9D69
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfJ3OZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:25:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35802 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfJ3OZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:25:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F208060B6E; Wed, 30 Oct 2019 14:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572445555;
        bh=sk6wzxiMvVRKpjDGRWKQ2yuiHkwjsWywpXOwNnQW9Gg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=K2vsSc1gpF5zrjF2e6l9mJGpZZdhgqO4zoO6HV9sF1YU7FgLQaEV7yWB4OQdIfJJ7
         qiAMu8TCjWyU4Ty6yBCe4QFwRuZ2LV1vRcGn3dyrsJGSmKemXyUVnLf4t2/Yy1OXh4
         ckAo9sTShaJZINbwtLI4lmymCdn4hBzBRLY4mYXQ=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BDA16081E;
        Wed, 30 Oct 2019 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572445554;
        bh=sk6wzxiMvVRKpjDGRWKQ2yuiHkwjsWywpXOwNnQW9Gg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Fr3Z19TvyHPLK9kLCfXd7mndKZj32sJrii/bwC9oNViH7BM5NOe+/iqUSirZkHXN3
         eWql8R7NZFAJ3Gl9LS6EB+h+Xz0KaJUI+78F+6pMPYMZ9arNJXh/eZr5MDo6HPqACb
         Ro4UQwL1syYVqrs+U7PkEBQ5x7J+/6WN5yHEYGGY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3BDA16081E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     liupold <rohn.ch@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Fixed "Failed to wake target" QCA6174
References: <20191030125035.31848-1-rohn.ch@gmail.com>
Date:   Wed, 30 Oct 2019 16:25:50 +0200
In-Reply-To: <20191030125035.31848-1-rohn.ch@gmail.com> (liupold's message of
        "Wed, 30 Oct 2019 18:20:35 +0530")
Message-ID: <87eeyu2tu9.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ ath10k list

liupold <rohn.ch@gmail.com> writes:

> There is a issue with card about waking up during boot and from suspend
> the only way to prevent it (is seems) by making pci_ps = false,
> on Acer Swift 3 (ryzen 2500u).

Can you provide dmesg output when this problem happens? Was QCA6174
installed to Swift 3 by default at the factory or did you install it
afterwards on your own?

> Signed-off-by: liupold <rohn.ch@gmail.com>

Is 'liupold' your full legal name?

> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index a0b4d265c6eb..653590342619 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -3514,7 +3514,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>  	case QCA6164_2_1_DEVICE_ID:
>  	case QCA6174_2_1_DEVICE_ID:
>  		hw_rev = ATH10K_HW_QCA6174;
> -		pci_ps = true;
> +		pci_ps = false;
>  		pci_soft_reset = ath10k_pci_warm_reset;
>  		pci_hard_reset = ath10k_pci_qca6174_chip_reset;
>  		targ_cpu_to_ce_addr = ath10k_pci_qca6174_targ_cpu_to_ce_addr;

This increases power consumption for all QCA6174 devices so I'm not
eager to do this.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
