Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0F5B47FB
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 09:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392507AbfIQHQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 03:16:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58364 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfIQHQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 03:16:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1BAF96016D; Tue, 17 Sep 2019 07:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568704592;
        bh=GZZTS5JwXBklyWYN0ChgnYdm/WVY6X3Z75O2fGgHcPY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IOP0AzwiWqB9Mtz2BrXRrc2WVU2k136JFRamBfmUyznbHTxHVo6mb12LuH6WZ7OwS
         UjbhOSmn+kU/2K7EE9NCMylc9ZvQQC3L/J9ad3xoiOZtRlfZ2jewZem451ROkZzSrG
         w+WQokvqX3zyXlGJSxkh+jMccv2scxg/cjhpdaQo=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7FD2061528;
        Tue, 17 Sep 2019 07:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568704591;
        bh=GZZTS5JwXBklyWYN0ChgnYdm/WVY6X3Z75O2fGgHcPY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nTIpmkiW0DG6OSrf5w0qyOszg7275rTei1E0UhXDgjZr061oGKA3Xjt0+29qubP0P
         8df+N9z6tNnYataWv5KHc7DCn3ZJJs1XCqI5+JJeC8aZrPt0fNSxz/4O0QAHietuEd
         wTxxZUVljrHn1BNNyUxbBtvWTquoZ/em852YM46w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7FD2061528
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Use ARRAY_SIZE instead of dividing sizeof array
 with sizeof an element
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1567582878-18739-1-git-send-email-zhongjiang@huawei.com>
References: <1567582878-18739-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <zhongjiang@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190917071632.1BAF96016D@smtp.codeaurora.org>
Date:   Tue, 17 Sep 2019 07:16:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> With the help of Coccinelle, ARRAY_SIZE can be replaced in ath10k_snoc_wlan_enable.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

I already got an identical patch so dropping this one.

error: patch failed: drivers/net/wireless/ath/ath10k/snoc.c:976
error: drivers/net/wireless/ath/ath10k/snoc.c: patch does not apply
stg import: Diff does not apply cleanly

-- 
https://patchwork.kernel.org/patch/11129531/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

