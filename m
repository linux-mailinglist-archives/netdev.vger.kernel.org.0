Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9306DB21D8
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbfIMOYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:24:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbfIMOYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 10:24:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1180760769; Fri, 13 Sep 2019 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568384649;
        bh=7Mu6zb2zVJC32hBRU8iS+CwGW1/scWJt1XF34sRcaXw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QkEiSFQzOu4Au82YolR++ShD11XBiedosHtmdUtigV0NGlg2bJoPVD+3ybSXyFvZA
         KFoc3PmTHkX3NkEwvWKo9MU9UX1qbMZ1k4dkBDPpnsQGrs6EQ+S/aW1wLE+wFtOJ1r
         gUpRyrVWLwBYuSPNs8VQm5TwuFbtAPbuTHNORzig=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0C28A602F8;
        Fri, 13 Sep 2019 14:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568384648;
        bh=7Mu6zb2zVJC32hBRU8iS+CwGW1/scWJt1XF34sRcaXw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PDSf1WNZe2hp95ECdCcGsQcSVsHbscquivaeFSqDiUtmHiUd7MMZw1GXRQZl8PxTR
         K2BWq/eZOwwCUj1rLcN8UXMgNzM2Cuhby0Jrgp2Mfy9oBIug2duXMTyISPYaF8zEr/
         eVz6XKGYVNqXvKE1bDnmQjfMuLN3tqCNICdK6pDs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0C28A602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: use mesh_wdev->ssid instead of priv->mesh_ssid
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190907151855.2637984-1-lkundrak@v3.sk>
References: <20190907151855.2637984-1-lkundrak@v3.sk>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913142409.1180760769@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 14:24:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lubomir Rintel <lkundrak@v3.sk> wrote:

> With the commit e86dc1ca4676 ("Libertas: cfg80211 support") we've lost
> the ability to actually set the Mesh SSID from userspace.
> NL80211_CMD_SET_INTERFACE with NL80211_ATTR_MESH_ID sets the mesh point
> interface's ssid field. Let's use that one for the Libertas Mesh
> operation
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Patch applied to wireless-drivers-next.git, thanks.

2199c9817670 libertas: use mesh_wdev->ssid instead of priv->mesh_ssid

-- 
https://patchwork.kernel.org/patch/11136509/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

