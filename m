Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E617F36340A
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 08:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhDRGaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 02:30:35 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:27600 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhDRGaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 02:30:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618727403; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=WBNIwYCXwYO9JdNQK1NvuiwmRIAohCzfFDbqq7zH86M=;
 b=KSa/Vw2YJFomBAX0ALd8nb5dj8e+zls5gpKBGL3bgyn5rXGhPY9IUHf1J8ntO4nvxKgEtwdz
 O3cD6bf0w0n8/2JpQkrtR8wnuxnWUhU3yg1SrK81iZXl4140c79sLzmyuXh8NVFlx/mE3SKv
 4zaqEjy7LNgSQV+J9GT5A5Q1oXo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 607bd1db853c0a2c461393c8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:29:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 82862C433D3; Sun, 18 Apr 2021 06:29:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E2FAC433F1;
        Sun, 18 Apr 2021 06:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E2FAC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: libertas: struct lbs_private is declared duplicately
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210325064154.854245-1-wanjiabing@vivo.com>
References: <20210325064154.854245-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kael_w@yeah.net
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418062946.82862C433D3@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 06:29:46 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wan Jiabing <wanjiabing@vivo.com> wrote:

> struct lbs_private has been declared at 22nd line.
> Remove the duplicate.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Patch applied to wireless-drivers-next.git, thanks.

d3240418a662 libertas: struct lbs_private is declared duplicately

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210325064154.854245-1-wanjiabing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

