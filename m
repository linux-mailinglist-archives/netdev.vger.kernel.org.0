Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76F5A6A2B
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfICNkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:40:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfICNkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:40:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D15F660907; Tue,  3 Sep 2019 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518046;
        bh=kGoj/xp0kX7mOwdsd2X5M3W7dTHktSJCTS0WiuYdXKA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=g8noLUsxOpTFeCU8y5QURhp2EV9OVmtVoHU6OmoxL0Ws8a/6Ca/9LYajuOttA1j1F
         2c0WYrxo2WKmqURU8LE8twh1EcaFSMYL0I4qKmCqOPbvs+17r+Df4K13g0lUhCmd1v
         m3uWz2Ujvw6Zc89MrT4yPICMylkzri9AlsJOEB2k=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E43AE605A2;
        Tue,  3 Sep 2019 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567518046;
        bh=kGoj/xp0kX7mOwdsd2X5M3W7dTHktSJCTS0WiuYdXKA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TIlpV6BeruheFKPvxmNS4/No17Ba5o+UDxz0JXVRHEXf2pw8rDNKKo0wdD9QTdVm2
         p6z9RlH39dPT7ZNO6OzwAOr57wdUvD68lgX3nKeNzgvwYMS5GbA2ViXQIF9BAvG4tk
         NmfIi2gNznLjJIiyehTFjHPcy9S+inwMx5SpI/G4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E43AE605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: fix spelling mistake "initializationg" ->
 "initialization"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190822220025.5690-1-colin.king@canonical.com>
References: <20190822220025.5690-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903134046.D15F660907@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:40:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in an IPW_DEBUG_INFO message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

14aba89386a4 ipw2x00: fix spelling mistake "initializationg" -> "initialization"

-- 
https://patchwork.kernel.org/patch/11110159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

