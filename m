Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9962B25F560
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgIGIfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:35:30 -0400
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:49862
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726971AbgIGIf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599467728;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=G/8ZddugbqirayybsCh6RukMKwpj/f34RiWIAGtYJRk=;
        b=Fjp9gPBEVnlGqm1KCrNl1siJSYPDScbCbSzsSUI8aagUFIxIMjJARl2x0MElR0wD
        I/davDOapWOC6ueBHVNbzAeZ4zKfSY8T+OV3AFKSNtURKARun+9gy0z61AXzM4KUWeE
        bmAqRRsghc+v9mTwHzqTPfbNImmK7h5PeEtllg5g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599467728;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=G/8ZddugbqirayybsCh6RukMKwpj/f34RiWIAGtYJRk=;
        b=RV4gbfSkL92z7xXDFm6PDbyyUVGGbry0CIsHFvtPtPa7U4uF0eHgjOedXPv1iIFa
        5ByGFmmR2t1nBpevWjfy9jCsOgmIIGfibm1seV3UMR74Aw8Tc7maSQZEPRRS95BE5/i
        eBiZv9VJyxG9b4sO6Us+XT5idm/m4rIN4jH/06JA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9ED26C35A38
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mwifiex: sdio: Fix -Wunused-const-variable warnings
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200902141155.30144-1-yuehaibing@huawei.com>
References: <20200902141155.30144-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <amitkarwar@gmail.com>, <ganapathi.bhat@nxp.com>,
        <huxinming820@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017467b4ac46-9af8a146-3a53-46e5-a96b-0d89ebfe3fe5-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 08:35:27 +0000
X-SES-Outgoing: 2020.09.07-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> These variables only used in sdio.c, move them to .c file
> can silence these warnings:
> 
> In file included from drivers/net/wireless/marvell/mwifiex//main.h:59:0,
>                  from drivers/net/wireless/marvell/mwifiex//cfp.c:24:
> drivers/net/wireless/marvell/mwifiex//sdio.h:705:41: warning: ‘mwifiex_sdio_sd8801’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:689:41: warning: ‘mwifiex_sdio_sd8987’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:674:41: warning: ‘mwifiex_sdio_sd8887’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:658:41: warning: ‘mwifiex_sdio_sd8997’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:642:41: warning: ‘mwifiex_sdio_sd8977’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:627:41: warning: ‘mwifiex_sdio_sd8897’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:612:41: warning: ‘mwifiex_sdio_sd8797’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:597:41: warning: ‘mwifiex_sdio_sd8787’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex//sdio.h:582:41: warning: ‘mwifiex_sdio_sd8786’ defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
>                                          ^~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

992a23702554 mwifiex: sdio: Fix -Wunused-const-variable warnings

-- 
https://patchwork.kernel.org/patch/11750823/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

