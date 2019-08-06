Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393048318C
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbfHFMkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:40:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfHFMkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:40:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C96B260867; Tue,  6 Aug 2019 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095238;
        bh=ASJAGZBmDYHp/aL9d+1itrj0Rvi/sYbEA8dvRwakVNg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fQIcvayFE6otqijATkf5nDh5TQg9xizi8t367h3Vw4CiMvpVHdugKGH1ITTZRj4Q4
         JQXeq0cR8Lw9pHkc3EZaObWr1K5Wz1NQxIGVeDiHEKk9CDG3FO187JSPmFX2X727xB
         xCNon6hx7rzbayGZaNWVf9oUuNVPgGJOlwLD24JY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 900AA60590;
        Tue,  6 Aug 2019 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095238;
        bh=ASJAGZBmDYHp/aL9d+1itrj0Rvi/sYbEA8dvRwakVNg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=FjLypiZcx/VTshUpSiZRwa2yyNMAS5ApzY30ZpiGDre72KxLlB8UsTOihp+J6Bsvv
         v+bX1UhZEp9vk+jZCiLdpH1h+LYngCUN3gOx49IbuVxyinoeymQi1zSWoqUme52M1B
         D/yz8mKd7xRBSgTN+1iROeGO4IsnHJfMqG1QkVMA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 900AA60590
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] rt2800usb: Add new rt2800usb device PLANEX
 GW-USMicroN
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190728140742.3280-1-standby24x7@gmail.com>
References: <20190728140742.3280-1-standby24x7@gmail.com>
To:     Masanari Iida <standby24x7@gmail.com>
Cc:     sgruszka@redhat.com, helmut.schaa@googlemail.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806124038.C96B260867@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:40:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Masanari Iida <standby24x7@gmail.com> wrote:

> This patch add a device ID for PLANEX GW-USMicroN.
> Without this patch, I had to echo the device IDs in order to
> recognize the device.
> 
> # lsusb |grep PLANEX
> Bus 002 Device 005: ID 2019:ed14 PLANEX GW-USMicroN
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

706f0182b1ad rt2800usb: Add new rt2800usb device PLANEX GW-USMicroN

-- 
https://patchwork.kernel.org/patch/11062963/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

