Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E33EAB56
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfJaIIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:08:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:08:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 81CE360A19; Thu, 31 Oct 2019 08:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509316;
        bh=MDrT9v0ThT/J4lxmhoR8Yct7jp86wfCet8Yba/5pTNU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Sw1TFbmu1+9dI8oq2DvllKhbdQIOBAbZ4rTJ/Cw2HKbTvMviCNBPOGQGrG+jpySzy
         gp+UrH0aBLg830amk4zPn8FVFlDIbGXdavfjCWufmsTPN0yvIlCy2ZzD6oXN5Y0G8D
         ff85bq61SpNtSucAEo4rYirlFbuMfzILlTdzfvmw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 698D260540;
        Thu, 31 Oct 2019 08:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509316;
        bh=MDrT9v0ThT/J4lxmhoR8Yct7jp86wfCet8Yba/5pTNU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ospIRJ24M0damMZFiGDO/HkVNg8r5rCi8glrv06VuJBORoY2mDgxn2wdmEuzinH2M
         ZrlHAHUBPDLSS5oFydkD6RtI+FpCReiG6Z41G6rYe3grFKPMIdXCvSJm2l/mLTeKa+
         1JRy5OLpVZCUwykRo6szRYonYvHlKlDcXCmm7/3Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 698D260540
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: dma: Fix use true/false for bool type variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191028191259.GA27369@saurav>
References: <20191028191259.GA27369@saurav>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     davem@davemloft.net, tglx@linutronix.de,
        saurav.girepunje@gmail.com, allison@lohutok.net,
        swinslow@gmail.com, mcgrof@kernel.org,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031080836.81CE360A19@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:08:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> wrote:

> use true/false for bool type variables assignment.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

a9160bb35ad9 b43: dma: Fix use true/false for bool type variable

-- 
https://patchwork.kernel.org/patch/11216307/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

