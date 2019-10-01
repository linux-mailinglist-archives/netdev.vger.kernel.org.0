Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F80C3013
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbfJAJWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:22:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44060 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfJAJWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:22:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 44164619AD; Tue,  1 Oct 2019 09:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921737;
        bh=VmuhhQTQwUQ/rwmArhiYtJQWVBWeBWRRgiKWa06tF+I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N1+ROFef5avpHmoKEQBtCs4pSbXwod/5ZmCmePlkmqu/WxftNiYYhWDv7TO7d6Cs/
         G2EmNpRj+wkiuHO6iRzMJAOVYHRM8BBn2LLobbuj7FuAtPIGGU2FmcKJHHYYcFtptc
         GDrYF69DS9YCXw6EYqgiMrZeDCt1v8tBsxm1Lu/8=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 038A461950;
        Tue,  1 Oct 2019 09:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921733;
        bh=VmuhhQTQwUQ/rwmArhiYtJQWVBWeBWRRgiKWa06tF+I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=himDNRC4nbOwpPSsBw8yOo5x5YwEtnoMsQLkKhbXdsvA4Qj50ca8CeBIrTm1QE+Hn
         AN2X2GsXiVN+EvY2j1cg1Sr6Oc0OW1Nj7vdo036Eq4ejBMlQwbXVIeWm4dOpWXoChG
         hWuLN/p8B5bTXwbDfWWAw9sXn7/VIXRtMsRyQtQg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 038A461950
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: fix a potential NULL pointer dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1568824500-4243-1-git-send-email-allen.pais@oracle.com>
References: <1568824500-4243-1-git-send-email-allen.pais@oracle.com>
To:     Allen Pais <allen.pais@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001092217.44164619AD@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:22:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allen Pais <allen.pais@oracle.com> wrote:

> alloc_workqueue is not checked for errors and as a result,
> a potential NULL dereference could occur.
> 
> Signed-off-by: Allen Pais <allen.pais@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

7da413a18583 libertas: fix a potential NULL pointer dereference

-- 
https://patchwork.kernel.org/patch/11150757/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

