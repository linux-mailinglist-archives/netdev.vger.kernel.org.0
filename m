Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C153FF192
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346395AbhIBQiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:38:14 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:53687 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346160AbhIBQiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 12:38:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630600634; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=LMyjDk/cc/kRj8f/Uf84VKM4wJB8c8yU2wNT57VCuCU=; b=fjwpJ101OP4gWmay1gFLXQV/ug7TKff/7sjwxI3TH30Yf0mAjtwpH7lJVzto63qQIzxFk0/c
 eiZOQE44aca2r5MMRjb+DuRQaSZ/wyLp97aRSDB8e9+myahohDUqsIoFyNWuCcFLHYGGaqau
 QzIO6IA6nfwZMAZ4TXpsmU9Qc/g=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6130fdb76fc2cf7ad9bed236 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 02 Sep 2021 16:37:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E6FD2C4360D; Thu,  2 Sep 2021 16:37:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B80AAC4338F;
        Thu,  2 Sep 2021 16:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B80AAC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Benjamin Li <benl@squareup.com>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wcn36xx: handle connection loss indication
References: <20210901180606.11686-1-benl@squareup.com>
Date:   Thu, 02 Sep 2021 19:37:03 +0300
In-Reply-To: <20210901180606.11686-1-benl@squareup.com> (Benjamin Li's message
        of "Wed, 1 Sep 2021 11:06:05 -0700")
Message-ID: <8735qn2ats.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> writes:

> Firmware sends delete_sta_context_ind when it detects the AP has gone
> away in STA mode. Right now the handler for that indication only handles
> AP mode; fix it to also handle STA mode.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Benjamin Li <benl@squareup.com>
> Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

How well is this tested? I'm pondering should I queue this to v5.15 or
v5.16, at the moment I'm leaning towards v5.16.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
