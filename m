Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0742C66E
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfE1MZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:25:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfE1MZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:25:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E8CD66087A; Tue, 28 May 2019 12:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046352;
        bh=5xobLk5VZD3Sx8VuUFArtuUgsnmrCcbwuOiQH/P02Is=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LEtv2C1/hd4w2K3EVXszdYzzmLpf4S2WrSUrdl73ZAPdftBLCr4LpH+9GTqAjz62t
         BT/WLlkTmuZ0KRm8qeaP9bnf2ueXy+LmfcwhcSviS13U4bEMQO2uEYC3KOiO551BUX
         xn8FIVK8lT7NSSliD+8THnEE91QYcJD143lDlFBY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D32A06034D;
        Tue, 28 May 2019 12:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559046352;
        bh=5xobLk5VZD3Sx8VuUFArtuUgsnmrCcbwuOiQH/P02Is=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VUDupo9fO30ejgM3yF+KzCapKVO7YPK4vrjaeOk/f4uVt5aPb9F/5rziTxvyPb7F6
         kGCv25aa2PVNfBqqWHFu2csZjOHWAOk45ToBIo7Z4K3CWmQEFX0n4JInTgUj4aYtMn
         qZjAFDDFrx7Ah06uriteheJN8PZGNnnecTYNnnaA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D32A06034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: use strlcpy() instead of strcpy()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1558429940-8709-1-git-send-email-neojou@gmail.com>
References: <1558429940-8709-1-git-send-email-neojou@gmail.com>
To:     neojou@gmail.com
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net, rafal@milecki.pl,
        hdegoedg@redhat.com, p.figiel@camlintechnologies.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@braodcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528122552.E8CD66087A@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:25:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

neojou@gmail.com wrote:

> From: Neo Jou <neojou@gmail.com>
> 
> The function strcpy() is inherently not safe. Though the function
> works without problems here, it would be better to use other safer
> function, e.g. strlcpy(), to replace strcpy() still.
> 
> Signed-off-by: Neo Jou <neojou@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

bbfab331e3ab brcmfmac: use strlcpy() instead of strcpy()

-- 
https://patchwork.kernel.org/patch/10953203/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

