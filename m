Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AC23631A7
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbhDQRyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:54:36 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47153 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236643AbhDQRyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 13:54:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618682049; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=WdPueMETllMURIOix1ZcNxcr/xst331JFouT0N99A6U=;
 b=KEo7+gfOV3IU4FjsupnbFt1HGcC+CxF6JcUMgfyzA8P01Lds5kc37BxvZ23XCQNso/GCtwJi
 WDoY6UHi+kWyWn3ChJY8OWR2m3mYiDk0jRRFALlS7T4awC4BrlyQsXwMqkGwKbOK9ukgvXyv
 i37r9AUxT0i9npQ+i7yY2JNRHUI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 607b20c0f34440a9d42a53aa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 17 Apr 2021 17:54:08
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C53CBC433D3; Sat, 17 Apr 2021 17:54:08 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D29D7C433F1;
        Sat, 17 Apr 2021 17:54:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D29D7C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: Remove unneeded variable: "ret"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210317063353.1055-1-zuoqilin1@163.com>
References: <20210317063353.1055-1-zuoqilin1@163.com>
To:     zuoqilin1@163.com
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210417175408.C53CBC433D3@smtp.codeaurora.org>
Date:   Sat, 17 Apr 2021 17:54:08 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zuoqilin1@163.com wrote:

> From: zuoqilin <zuoqilin@yulong.com>
> 
> Remove unneeded variable: "ret"
> 
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

c81852a48e13 mwifiex: Remove unneeded variable: "ret"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210317063353.1055-1-zuoqilin1@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

