Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C30434744
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhJTIvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:51:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27470 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhJTIvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:51:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634719767; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=FexXiz3ghhtHU88bBmHU5MspxGEjavF4AvEw80CRTY4=;
 b=DxN5XgQaf8POgHMrL/fiNU5dIoVD6LhGHsPUHZ0PXXoYd1DB8BiAdYRLDC0rlyn8D/2Dq1QW
 pYoh3y8PB0FWx7mMzqFZ83yv2neYZQyV52e6phrZXc8tS/w+ZJfDRdWl0P4lIug8h2GlwivP
 hUrTfEKEPzNg0vgFX3A89+WfY9M=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 616fd8155ca800b6c136e174 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 20 Oct 2021 08:49:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CAFE4C4360C; Wed, 20 Oct 2021 08:49:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2FB21C4338F;
        Wed, 20 Oct 2021 08:49:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 2FB21C4338F
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
Message-ID: <163471975843.1743.1396425390394291812.kvalo@codeaurora.org>
Date:   Wed, 20 Oct 2021 08:49:25 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

a04310edcd00 rtw89: fix return value check in rtw89_cam_send_sec_key_cmd()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211018033102.1813058-1-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

