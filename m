Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9126BC38
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgIPGJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:09:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30615 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgIPGJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:09:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600236548; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=0PhPse1fAuXhvgCnPdooOQgglRxHYeqV3vovP/hlC/k=;
 b=hM+tFhYZeocNGJEaRn6FjGswU8T7zVfpN3+e+MT3EOlcklhfXbTnS4ufWaXptBazlIUOpfdY
 MZ7oLywYdJ+7CDtLy76ajoC1CKYs6x2SW+YqIiANqMcq5sGsRkafTZBwcpMj7w96+P12Or9+
 CYuRyt7WIfiUJ+wUvdWByO7CKOs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f61ac0473afa3417e2e4bce (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Sep 2020 06:09:08
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A1ED3C433F1; Wed, 16 Sep 2020 06:09:07 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 77C8CC433F0;
        Wed, 16 Sep 2020 06:09:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 77C8CC433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtw88: rtw8822c: eliminate code duplication,
 use native swap() function
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200913165958.419744-1-insafonov@gmail.com>
References: <20200913165958.419744-1-insafonov@gmail.com>
To:     Ivan Safonov <insafonov@gmail.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Safonov <insafonov@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200916060907.A1ED3C433F1@smtp.codeaurora.org>
Date:   Wed, 16 Sep 2020 06:09:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ivan Safonov <insafonov@gmail.com> wrote:

> swap_u32() duplicate native swap(), so replace swap_u32() with swap().
> 
> Signed-off-by: Ivan Safonov <insafonov@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

d10f6af58ef4 rtw88: rtw8822c: eliminate code duplication, use native swap() function

-- 
https://patchwork.kernel.org/patch/11772397/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

