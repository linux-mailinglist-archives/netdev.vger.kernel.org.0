Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA04547CD08
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 07:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242785AbhLVGnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 01:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242781AbhLVGnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 01:43:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB515C061574;
        Tue, 21 Dec 2021 22:43:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEF6FB81B0B;
        Wed, 22 Dec 2021 06:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30216C36AE5;
        Wed, 22 Dec 2021 06:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640155389;
        bh=Z6mkk7Vo2fTpBswx9tgs/mZsMrVgsubgbLVn+u4gtlI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=czGnMuR2/N2xlzLIFHtEwYHnrBaJVld0jWlpQREg5k74T6THJ/pKHTFVeq59WR56J
         m7ehoCep0HjfeCbBs4DKi7Hkmk4QfNHo27SoSRtGozsoTRtF3mkgf2sPATnmpM+ZPr
         hE/oacS8517AaB1dW8jWcDYhRXUX8JG+eQAmGS9LcQQ4vfeD/d0GwxABORKy6WMUSH
         I8AfJ7zLwc8QbvDToC4Ptic7/WdPFcvLu/2d0Dm41kCKUPngWPiCl0zDugrHXlcBzm
         zIzr3nop6iGQQDMIsvfHShdNu8J8FmephObZ3ftUIe5xo+E+/OgLbTqixxQImLV5O/
         LmCh5781R9Fxg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     briannorris@chromium.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, dianders@chromium.org,
        pillair@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ath10k: enable threaded napi on ath10k driver
References: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
        <CACTWRwtn+xwVfdFC_1ZAEGC41+gqjDNpTk46vctejnF74Pf+AQ@mail.gmail.com>
Date:   Wed, 22 Dec 2021 08:43:04 +0200
In-Reply-To: <CACTWRwtn+xwVfdFC_1ZAEGC41+gqjDNpTk46vctejnF74Pf+AQ@mail.gmail.com>
        (Abhishek Kumar's message of "Tue, 14 Dec 2021 14:48:13 -0800")
Message-ID: <87k0fx2l8n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> This patch is to trigger a discussion on the best approach to enable
> threaded NAPI on ath10k. Threaded NAPI feature was added in (net:
> extract napi poll functionality to __napi_poll() commit
> 898f8015ffe74118e7b461827451f2cc6e51035b) and showed good results on
> ath10k snoc based solution.
>
> If we come to a consensus with this as the best approach to enable
> threaded NAPI on ath10k, then we can moved ahead with the
> implementation and enable across sdio and pci, or if there is any
> objection then we can discuss it here.

Few tips:

It's a good idea to mark patches like this with "[PATCH RFC]":

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#use_rfc_or_rft_for_patches_not_ready

And you can add a text like the above after the "---" line in the patch
itself.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
