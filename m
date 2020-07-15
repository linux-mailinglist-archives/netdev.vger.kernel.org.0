Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18FC2212EB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgGOQrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:47:15 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:32247 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgGOQrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:47:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594831631; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=TKew3JJfCToYrT8uujUrU8/Gqwdn23TvQoieCSi469s=;
 b=ckkXyEp25WqQ2vMSTs5GUom1uGp8mXLpvUQ8cpElE/8OiigGDQfdRevASuQw69/EHdEsOzl9
 UvT9WSRcIzbSw/Weu//yZEDcb+EQvAu1GS7RWRz+Z8E2Mc4Y1OJkokYA+OM+2RvsSRcSZUew
 D0jFSm6TEJhfcocDcQXqDrvnkUU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f0f3304ee6926bb4f2c394b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 16:47:00
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B8EACC43395; Wed, 15 Jul 2020 16:46:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0240CC433C6;
        Wed, 15 Jul 2020 16:46:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0240CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] zd1211rw: remove needless check before
 usb_free_coherent()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200630070404.8207-1-vulab@iscas.ac.cn>
References: <20200630070404.8207-1-vulab@iscas.ac.cn>
To:     Chen Ni <vulab@iscas.ac.cn>
Cc:     dsd@gentoo.org, kune@deine-taler.de, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200715164659.B8EACC43395@smtp.codeaurora.org>
Date:   Wed, 15 Jul 2020 16:46:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chen Ni <vulab@iscas.ac.cn> wrote:

> From: Xu Wang <vulab@iscas.ac.cn>
> 
> usb_free_coherent() is safe with NULL addr and this check is
> not required.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Patch applied to wireless-drivers-next.git, thanks.

4f3ebd6fb680 zd1211rw: remove needless check before usb_free_coherent()

-- 
https://patchwork.kernel.org/patch/11633321/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

