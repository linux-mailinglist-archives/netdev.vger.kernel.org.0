Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410422BA1B4
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKTFKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgKTFKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 00:10:48 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E67E32236F;
        Fri, 20 Nov 2020 05:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605849047;
        bh=uFaxa41pCsApxSyPWISk14ywt9omyQOUzb8sb7/5Fcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=og3atr54IMdXkBis7vX5TwcoDWQyZPCNQd2xztFfhdH4dE2ZeXOZrY3c+XI5zXgo3
         YzqoJmKE28H1K3CWMpfaY1bDBNeGjL0aKqm7iPGa13gXHPjAoE1zDZqnS92vTi9dsm
         igNpskn8j8fl4dqR8mn+K3KlAUGPWBcFWGn2Aevc=
Date:   Thu, 19 Nov 2020 21:10:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        manivannan.sadhasivam@linaro.org
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        cjhuang@codeaurora.org, linux-arm-msm@vger.kernel.org,
        hemantk@codeaurora.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, clew@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Unprepare MHI channels during remove
Message-ID: <20201119211046.64294cf6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
References: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 10:20:25 -0800 Bhaumik Bhatt wrote:
> Reset MHI device channels when driver remove is called due to
> module unload or any crash scenario. This will make sure that
> MHI channels no longer remain enabled for transfers since the
> MHI stack does not take care of this anymore after the auto-start
> channels feature was removed.
> 
> Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>

Patch seems reasonable, Mani are you taking it or should I?

Bhaumik would you mind adding a Fixes tag to be clear where 
the issue was introduced?
