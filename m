Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC554318C2
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhJRMSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:18:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62068 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhJRMSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:18:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634559388; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=hHOTyhKY+jF9m2eMBr2/9tn1FPmbSZyijxUuMni71YQ=;
 b=hitnut89a7azzCLqn93xC+s9i4CohdV4yeeYc4mqfPGjLF0zj2it/tm7IrXbku86eTy2SkMS
 zRblapQswTCUb4Ggt5l+2+qjfqnufBJ7M5J9UtF1AzHm/xyArQQXVa66iZ6jrDHxJpSUdLoy
 sLxgAEbYx41O6MNbmEe6HhlNEGo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 616d65878ea00a941fc4a75c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:16:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 44428C43616; Mon, 18 Oct 2021 12:16:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19B50C4338F;
        Mon, 18 Oct 2021 12:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 19B50C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] rtw89: fix return value check in
 rtw89_cam_send_sec_key_cmd()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211018033102.1813058-1-yangyingliang@huawei.com>
References: <20211018033102.1813058-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <pkshih@realtek.com>,
        <kuba@kernel.org>, <davem@davemloft.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163455936283.19217.11931035159424062771.kvalo@codeaurora.org>
Date:   Mon, 18 Oct 2021 12:16:07 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote:

> Fix the return value check which testing the wrong variable
> in rtw89_cam_send_sec_key_cmd().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

rtw89 patches are applied wireless-drivers-next, not net-next. rtw89 is not
even in net-next yet.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211018033102.1813058-1-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

