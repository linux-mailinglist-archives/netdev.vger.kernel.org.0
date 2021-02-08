Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649BE3130B4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhBHLXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:23:46 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:64325 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233056AbhBHLUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:20:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612783190; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ZfPBl6SItvH/px01pEtiPLgUOmFev1HLYNK3j7R8gw8=;
 b=S0aBdSu4Ji+5K+QDepJyb6uUhqXffU1mRD76TjVVyDDdZkYaYrjatV9hHaewXZgHREPDzYjs
 BizKHAa21t2TNKIDcq8hC6TdGMokWU74fSBloqzw4hPoEf3sFXHUi7+ANvdW3X61MaHgWu/k
 Z0g5v/YnUevci2izyWENxd6ESL8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60211e3a3919dfb455999bb8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 11:19:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4E7B0C433CA; Mon,  8 Feb 2021 11:19:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BAC2C433C6;
        Mon,  8 Feb 2021 11:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8BAC2C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwl8k: assign value when defining variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210203061625.588-1-samirweng1979@163.com>
References: <20210203061625.588-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     buytenh@wantstofly.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208111921.4E7B0C433CA@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 11:19:21 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samirweng1979 <samirweng1979@163.com> wrote:

> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> define refilled and then assign value to it, which should do
> that at the same time.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

bb779d476ff7 mwl8k: assign value when defining variables

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210203061625.588-1-samirweng1979@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

