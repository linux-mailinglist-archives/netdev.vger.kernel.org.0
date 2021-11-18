Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880FA455455
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 06:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhKRFjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 00:39:20 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:14902 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242431AbhKRFjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 00:39:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637213777; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=YvyeJf5mJyXmpQpByrjXB8SyQEI/4CbO3Q2j3mWnZhg=; b=Oaxr9oOofaTDRBl5RVrOQKvpeSoNQlnIITO+hswhsqjvV/K7pZuvxEE2USjTt1E7vt0PWW5M
 jN5gBZzfDSW5hifZlTpodoS1KjPPiRyvtMMkLLP/EGN02Fb8hcR8YUN6BmVw3rbHXHnUEV/J
 6w+CK1qzf7mYNFNWA0huJqJri6Y=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6195e650c48ba48884c8e4c7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Nov 2021 05:36:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0B20FC4360D; Thu, 18 Nov 2021 05:36:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6BCB9C4338F;
        Thu, 18 Nov 2021 05:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 6BCB9C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        stas.yakovlev@gmail.com
Subject: Re: [PATCH net-next 4/9] ipw2200: constify address in ipw_send_adapter_address
References: <20211118041501.3102861-1-kuba@kernel.org>
        <20211118041501.3102861-5-kuba@kernel.org>
Date:   Thu, 18 Nov 2021 07:36:12 +0200
In-Reply-To: <20211118041501.3102861-5-kuba@kernel.org> (Jakub Kicinski's
        message of "Wed, 17 Nov 2021 20:14:56 -0800")
Message-ID: <878rxmdnzn.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Add const to the address param of ipw_send_adapter_address()
> all the functions down the chain have already been changed.
>
> Not sure how I lost this in the rebase.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
