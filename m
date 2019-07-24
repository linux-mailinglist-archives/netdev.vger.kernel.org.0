Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3766572DE8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfGXLnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:43:01 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfGXLnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:43:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DEC966044E; Wed, 24 Jul 2019 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968579;
        bh=cq7gOfy4KYJkJG7NJ3YoUs/IippuTKs2V00UjCfwjTA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MtHIojECPGjQAcTqXKX6UQsb2FSkANEVQRNb384kwCWM0W7QKlkc7lEB9CMTlyNEp
         2z+u8pSUcajn9asWHKYVPXh4+k2DNp0yngXqVoeaWEEwn2tYCur9HDMLFQRAvCqwmZ
         9MCQ6ffaDzjlx44WzNeG36ASK7ToTvXkR5zr4HM0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF10B6030E;
        Wed, 24 Jul 2019 11:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968579;
        bh=cq7gOfy4KYJkJG7NJ3YoUs/IippuTKs2V00UjCfwjTA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=mp8jspkiLSP9402W53WkwQUjmJkv17CBlyEHUZrk+5EUxu3G+ZqI4v2vXf3Xgoc5o
         8aqUOktuvDT0qfJf/hYQALynSUbyfZXQdY3U+VsOeMp1qUC8gR7NNigP0cjHtwp9Kj
         QGZiZ4rsdWLt/A5J5jjCI5hNbB/8cPuJtB500Oks=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DF10B6030E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/2] rt2x00usb: remove unnecessary rx flag checks
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190701105314.9707-2-smoch@web.de>
References: <20190701105314.9707-2-smoch@web.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Soeren Moch <smoch@web.de>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114259.DEC966044E@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:42:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> wrote:

> In contrast to the TX path, there is no need to separately read the transfer
> status from the device after receiving RX data. Consequently, there is no
> real STATUS_PENDING RX processing queue entry state.
> Remove the unnecessary ENTRY_DATA_STATUS_PENDING flag checks from the RX path.
> Also remove the misleading comment about reading RX status from device.
> 
> Suggested-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Soeren Moch <smoch@web.de>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

3b902fa811cf rt2x00usb: remove unnecessary rx flag checks

-- 
https://patchwork.kernel.org/patch/11025559/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

