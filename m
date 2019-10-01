Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1075C2FD1
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbfJAJPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:15:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387465AbfJAJPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:15:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A489B60AD9; Tue,  1 Oct 2019 09:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921304;
        bh=wvvOSSjNKpd2qndbx85vEEgnBWI9oz8By+twyKlLrgY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=T1QhCF9I22KD9MbLPPs+RC8GizrAs7SR/tBz7nYDi1tFhzVeGkhPX3tyiVQU8DZ8a
         XQB+BZVye8f7sJ/rYr1tpCQJjJ+UKnwC3Kql8Et/GM6KAbme/KsOPR8SSIXejMfIVN
         TzFUhy1DBqOpGpXIKspJxmoSxcUkvW6MHaBrHwl8=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83F8460112;
        Tue,  1 Oct 2019 09:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569921304;
        bh=wvvOSSjNKpd2qndbx85vEEgnBWI9oz8By+twyKlLrgY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=TG9dmkNVIjuOKo1GXTyssktZASsgtjINbmVj+0ZCJ6fY8dW/H2uccnIkI8rG8ZWb0
         GjLtnaS9IydaLqjGnVmRXhR9Mbw4mqJm9C6OLwfv9r3f/WMCLvGqiIO2wfxQPSgMXP
         TvmsA1GSmeMqIJixl6GALbPeySgKWbzGTMdoeHUU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 83F8460112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: remove duplicated if condition
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190925203152.21548-1-efremov@linux.com>
References: <20190925203152.21548-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191001091504.A489B60AD9@smtp.codeaurora.org>
Date:   Tue,  1 Oct 2019 09:15:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis Efremov <efremov@linux.com> wrote:

> The nested 'li_mimo == &locale_bn' check is excessive and always
> true. Thus it can be safely removed.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>

Patch applied to wireless-drivers-next.git, thanks.

fa38b4fddc7c brcmsmac: remove duplicated if condition

-- 
https://patchwork.kernel.org/patch/11161343/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

