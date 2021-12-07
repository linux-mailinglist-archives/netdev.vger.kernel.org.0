Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF06A46B36F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhLGHOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:14:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54662 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhLGHOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:14:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05E3DB812A7;
        Tue,  7 Dec 2021 07:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3F2C341C3;
        Tue,  7 Dec 2021 07:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638861035;
        bh=kCGsGGeR5QnFYKn4gsjzd/63TI+GAON4K8jZsOn8PYA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Z9kuwQr36CwBs7ACFmkWeOi519ZSOxjCOb4ctlgwMoKfSf0H4K0+hr8mkzIYp4EsS
         Ez5uub6Id9yzt/hLpfcay61GeWftOSebecU4F1l4r2qs0SU346PCUHGbWCizMTcQg+
         M+Wl9uYSFlL5paKM4sA5dp/VkWIgem486+XH2gbk3Jl00BEnMcoN0cLhXWn0Q79+A0
         ScFeXs3wt8z1sf+8BKHRxOUs8FLjXYJtwENDFRnd6gRFhtYb5cALfQds96o3rU3oxr
         3NPGAHfuEV+Ljzn61cpPj/lwHfr58t9kkYksXXKcPCHUfsDiIsLVpCWgF8DzWWwpKn
         IgFfP1dEAkL8A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Improve the A-MPDU retransmission rate with RTS/CTS protection
References: <20211205095836.417258-1-chris.chiu@canonical.com>
Date:   Tue, 07 Dec 2021 09:10:32 +0200
In-Reply-To: <20211205095836.417258-1-chris.chiu@canonical.com> (Chris Chiu's
        message of "Sun, 5 Dec 2021 17:58:36 +0800")
Message-ID: <87ee6oubyv.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chris.chiu@canonical.com> writes:

> The A-MPDU retransmission rate is always high (> 20%) even in a very
> clean environment. However, the vendor driver retransimission rate is
> < 10% in the same test bed. The different is the vendor driver starts
> the A-MPDU TXOP with initial RTS/CTS handshake which is observed in the
> air capture and the TX descriptor. Since there's no related field in
> TX descriptor to enable the L-SIG TXOP protection and the duration,
> applying the RTS/CTS protection instead helps to lower the retransmission
> rate from > 20% to ~12% in the same test setup.
>
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>

You should have marked this as v2 because you submitted already before:

https://patchwork.kernel.org/project/linux-wireless/patch/20211129143953.369557-1-chris.chiu@canonical.com/

And include a list of changes between versions, more info in the wiki
below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
