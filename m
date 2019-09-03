Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0E5A6A10
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfICNio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:38:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbfICNin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:38:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8B9BD6025A; Tue,  3 Sep 2019 13:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517922;
        bh=ej069zxmm9FbOAIunXcS+l57Bk7LOELm9ibfNx23sA8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XO1qSstPVykmMPstFDLagfancdpch3VXv9ZMCWrmcVBcRrlb67aQmoKMwDKSnWklo
         xgOMyq98tKll+8Znge4Ucp2/9uRAih0i3QsnawRjUNIOywW4iSkxG0hKYxjxmnbwYW
         PosY9fzlT7tsWhdAHcjWlZLBldR8NKZyONwLkCA0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45E496025A;
        Tue,  3 Sep 2019 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517922;
        bh=ej069zxmm9FbOAIunXcS+l57Bk7LOELm9ibfNx23sA8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=I6HEaAHYPOzMcZJ3O/nnMRCvNnXSrYspLAyfEsxmP/ZKHtEdWjzsEdE4D82iXe/3u
         Rfe43h+jZf8Hoci4A4dTcmbM1MiDKFcgwdA5OoxS8IuPXEo91NS+tM8FStk4LyYkrd
         Pi7FCUBTj5PTqRjKiyhDCY6SCRap+Y/6ww82jVLo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45E496025A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: remove redundant assignment to pointer hash
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190809172217.1809-1-colin.king@canonical.com>
References: <20190809172217.1809-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133842.8B9BD6025A@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:38:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer hash is being initialized with a value that is never read
> and is being re-assigned a little later on. The assignment is
> redundant and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

73c742bb9c9b brcmfmac: remove redundant assignment to pointer hash

-- 
https://patchwork.kernel.org/patch/11087385/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

