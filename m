Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6B2649F6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgIJQiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:38:20 -0400
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:35516
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726979AbgIJQfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599755294;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=QJgTcfrPcTXgRkBOLIEGlx3bhnq3+fZghmrt8poCN5E=;
        b=Us6DXPIf2G7jAJLQEO5CZLilLEnZiGPZNxK4rH7R4wk9LzzPJ3d+z5KYOKRELW95
        iKZyTrtNoGZNuKPGjQNPBt4TYuBIXP+zNv6ZPLKQ8gYl6pHad1dzJqhGH3DuOWYSoFG
        p2mhbAaj+isCuX9lVT/a41JpkJoPFr03I5Hy2v30=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599755294;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=QJgTcfrPcTXgRkBOLIEGlx3bhnq3+fZghmrt8poCN5E=;
        b=N4cugInAChys50fhmqgyv7j1YCCQqc4RV45QeoVyyejMKsp850eeswk0fm2KYK7O
        4XjTmqWOecbyamoiKxSWloiKJfh+Hwr6jt9rPAG/MpCUnx1ryxGanD+WOqVi5izFrRf
        Ocv2acfc3D9cDd76zj4fPHzLzEXYcjnLHM7gRtqk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3BCADC433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] ath5k: fix 'mode' kernel-doc warning in
 ath5k_hw_pcu_init()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200909131858.70391-1-wanghai38@huawei.com>
References: <20200909131858.70391-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <jirislaby@kernel.org>, <mickflemm@gmail.com>, <mcgrof@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017478d89404-f89af71e-5c00-45b7-a8c9-02d98996d92f-000000@us-west-2.amazonses.com>
Date:   Thu, 10 Sep 2020 16:28:13 +0000
X-SES-Outgoing: 2020.09.10-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai <wanghai38@huawei.com> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/wireless/ath/ath5k/pcu.c:955: warning: Excess function parameter 'mode' description in 'ath5k_hw_pcu_init'
> 
> This parameter is not in use. Remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Already fixed in ath.git.

error: patch failed: drivers/net/wireless/ath/ath5k/pcu.c:945
error: drivers/net/wireless/ath/ath5k/pcu.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11765471/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

